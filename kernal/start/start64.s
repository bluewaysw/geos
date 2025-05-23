; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak; Michael Steil
;
; Purgeable start code; first entry

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "inputdrv.inc"
.include "diskdrv.inc"
.include "c64.inc"

; main.s
.import InitGEOEnv
.import _DoFirstInitIO
.import _EnterDeskTop

; header.s
.import dateCopy

; irq.s
.import _IRQHandler
.import _NMIHandler

.import LdApplic
.import GetBlock
.import EnterDeskTop
.import GetDirHead
.import FirstInit
.import i_FillRam

; used by header.s
.global _ResetHandle

.ifdef usePlus60K
.import DetectPlus60K
.endif
.if .defined(useRamCart64) || .defined(useRamCart128)
.import DetectRamCart
.endif
.ifdef useRamExp
.import LoadDeskTop
.endif

.ifdef mega65
.import InitScanLineTab
.import MapUnderlay
.import UnmapUnderlay
.import _MapLow
.import ClrScr
.import SetNewMode
.endif

.ifdef debugger
.global _DebugStart
.endif

.import vmiTopBorder
.import vmiBottomBorder
.import vmiSpriteYPosOff
.import vmiMaxY
.import vmiFullCardsY

.segment "start"

; The original version of GEOS 2.0 has purgeable init code
; at $5000 that is run once. It does some initialization
; and handles application auto-start.
;
; The cbmfiles version of GEOS does some init inside
; "BOOTGEOS" right after copying the components to their
; respective locations, then jumps to $500D, which contains
; a different version of the code, and skipping the first
; five instructions.
;
; This version is based on the cbmfiles version.
; "OrigResetHandle" below is the original cbmfiles code at
; $5000, and the code here at _ResetHandle is some additional
; initialization derived from the code in BOOTGEOS to make
; everything work.
;
; TODO: * REU detection seems to be currently missing.
;       * It would be best to put the original GEOS 2.0 code
;         here.
;

_ResetHandle:
	sei
	cld
	ldx #$FF
	txs

ASSERT_NOT_BELOW_IO
	lda #IO_IN
	sta CPU_DATA

	LoadW NMI_VECTOR, _NMIHandler
	LoadW IRQ_VECTOR, _IRQHandler

	lda	$DC0E
	ora	#$80
	tax
	lda	$DD0E
	ora	#$80
	tay

	; adapt screen mode tables for NTSC
	bbrf 	7, $D06F, @doneWithPAL

	LoadW 	vmiTopBorder, 42
	LoadW 	vmiTopBorder+2, 42
	LoadW 	vmiTopBorder+4, 42
	LoadW 	vmiTopBorder+6, 1

	LoadW 	vmiBottomBorder, 442
	LoadW 	vmiBottomBorder+2, 442
	LoadW 	vmiBottomBorder+4, 442
	LoadW 	vmiBottomBorder+6, 480

	LoadB 	vmiSpriteYPosOff+2, 41
	LoadB 	vmiSpriteYPosOff+3, 1

	LoadW 	vmiMaxY+6, 478

	LoadB 	vmiFullCardsY+3, 59

	txa
	and	#$7F
	tax
	tya
	and	#$7F
	tay

@doneWithPAL:
	stx	$DC0E
	sty	$DD0E

	; move underlayr from $0A000 to $1A000
	lda	#>underlaylist
	ldy	#<underlaylist

	sta	$d701
	lda	#0
	sta	$d702
	sta	$d704	;	enhanced bank
	sty	$d705

	lda	#0
	sta	countHighMap
	lda	#$80
	sta	lastHighMap

	; draw background pattern
.ifndef mega65
	LoadW r0, SCREEN_BASE
	ldx #$7D
@2:	ldy #$3F
@3:	lda #$55
	sta (r0),y
	dey
	lda #$AA
	sta (r0),y
	dey
	bpl @3
	lda #$40
	clc
	adc r0L
	sta r0L
	bcc @4
	inc r0H
@4:	dex
	bne @2
.endif

	; set clock in CIA1
	lda cia1base+15
	and #$7F
	sta cia1base+15 ; prepare for setting time
	lda #$81
	sta cia1base+11 ; hour: 1 + PM
	lda #0
	sta cia1base+10 ; minute: 0
	sta cia1base+9 ; seconds: 0
	sta cia1base+8 ; 10ths: 0

.ifndef mega65
	lda #RAM_64K
	sta CPU_DATA
.endif
ASSERT_NOT_BELOW_IO


	jsr i_FillRam
	.word $0500
	.word dirEntryBuf
	.byte 0

	; set date
	ldy #2
@6:	lda dateCopy,y
	sta year,y
	dey
	bpl @6
	;
.ifdef mega65
	lda #3|64
	sta graphMode
.endif
	jsr FirstInit

	LDA #0
	STA $D05D

	; start with bank $6000-$8000 swapped out so we prevent debugger from beeing destroyed
	;ldx #$00
	;lda #$80
	ldx #$00
	lda #$00
	jsr _MapLow

.ifdef debugger
	; move debugger from $06000 to $16000
	lda	#>debuggerlist
	ldy	#<debuggerlist

	sta	$d701
	lda	#0
	sta	$d702
	sta 	$d704	;	enhanced bank
	sty	$d705

	jsr FirstInit
.endif
.if 0
	LDA #$12
	STA $D640
	NOP
	tax
	ldy #>$0400 		; write dirent to DirEntry

	lda #$14
	STA $D640
	NOP
.endif
.if 0
	; run a raster line cycle counter
	sei	; interrupts off

	; 1 mhz
	lda     $d031
        and 	#%10111111
        sta     $D031

	lda	#0
	ldx	#0
@aaa:
	sta	$4000, x
	sta	$4100, x
	sta	$4200, x
	sta	$4300, x
	inx
	bne     @aaa


@eee:
	ldx	rasreg
	bne	@eee
@eee1:
	ldx	rasreg
	beq	@eee1

	lda	$D011
	bmi 	@eee

@ccc2:
	ldx	rasreg
	beq	@bbb

@ccc:
	; inc
	inc	$4000, x
	bne	@ccc1
	inc	$4100, x
	bne	@ccc1
	inc	$4200, x
	bne	@ccc1
	inc	$4300, x
@ccc1:
	; wait for next line
	cpx	rasreg
	beq	@ccc

	ldx	rasreg
	jmp	@ccc2

@bbb:
	cli


.endif

	jsr MouseInit
	lda #currentInterleave
	sta interleave

	lda #1
	sta NUMDRV
	ldy $BA
	sty curDrive

	lda #DRV_TYPE ; see config.inc

.ifdef mega65
	; determ proper drive type,
	; from MEGA65 BASIC 10.0 coming there are following options:
	; 1.)
	; preconditions:
	; curDrive is one of the BASIC mapped drives, directing us to
	; F011-0 or F011-1, we don't support booting from other drives and
	; could/should hard reset here? In general we assume that GEOS
	; holds an disk driver that is in some way compatible to the boot drive.

	lda	#C65_VIC_INIT1
	sta	$d02f
	lda 	#C65_VIC_INIT2
	sta	$d02f

	; get MEGA65 DOS drive 0 device number
	; 10113/10114 clear device numbers of the f011 drive, we will
	; manage those independent of dos
	lda	#$10
	sta 	r0L
	lda 	#$01
	sta 	r0H
	lda 	#$01
	sta 	r1L
	lda	#$00
	sta 	r1H

	jsr	loadZDriveOffset
	;LDZ	#3
	EOM
	lda 	(r0), Z
	cmp	curDrive
	beq	@detectDrive0

	; get MEGA65 DOS drive 1 device number
	;LDZ	#4
	inz
	EOM
	lda 	($02), Z
	cmp	curDrive
	beq	@detectDrive1

	; unclear how this has been booted
	; still could try to setup drive 0 as real or sd mount

@detectDrive0:
	; is virtual enabled?
	ldx	#DRV_F011_V
	lda	$D68A
	bit	#4
	bne	@detected

	; check if real drive
	ldx	#DRV_F011_0	; real internal floppy
	lda	$D6A1
	bit	#1
	bne	@detected

	ldx	#DRV_SD_81
	; setup d81 offset
	LoadB	r2L, 0 		; remember the drive number
	bra	@detected

@detectDrive1:
	; potentially now drive 1 may be virtual,
	; but because monitor-load does not support this
	; at the moment, we assume this will not be the case
	; check if real drive
	ldx	#DRV_F011_0	; real internal floppy
	lda	$D6A1
	bit	#4
	bne	@detected
	ldx	#DRV_SD_81
	; setup d81 offset
	LoadB	r2L, 1 		; remember the drive number
	bra	@detected

@detected:
	; redirect DOS device numbers of the internal drives
	; so GEOS only looks at real serial drives using the DOS
	;LDZ	#3
	jsr	loadZDriveOffset
	lda	#28
	EOM
	sta 	(r0), Z
	inz
	lda	#29
	EOM
	sta 	(r0), Z
	txa
.endif
	sta	curType
	sta	_driveType,y

	cmp	#DRV_SD_81
	bne	@detectDone
	
	; get the current tasks mounted image file names via HYPPO
	; load the process descriptor to $4F00 just before the boot code
	LDY	#$4F
	
	LDA 	#$48	; HYPPO_DOS_GET_PROC_DESC
	STA 	$D640
	NOP
	bcc	@10	; branch if error/unsupported
	lda	r2L
	bne	@31	; branch if current drive is not device 0
	LoadW	r0, $4F00+21
	ldy	$4F00+19
	bra	@30
@31:
	LoadW	r0, $4F00+21+32
	ldy	$4F00+20
@30:
	lda	#0
	sta	(r0), y
	bra	@20
	
@10:	; unsupported by HYPPO use default
	LoadW	r0, imageFileName
@20:
	jsr	SetImageFile

@detectDone:
	; on MEGA65 we check if we are able to transform
	; from F011 mode to direct access SD mount
	; this is possible if the drive is not a real drive and not virtual
	;lda #8  ; DRV_F011_V, see config.inc
	;sta curType
	;sta _driveType,y


; This is the original code the cbmfiles version
; has at $5000.
OrigResetHandle:
	sei
	cld

.ifdef mega65
	lda #3|64
	sta graphMode
	LoadW	r5, 720
	jsr MapUnderlay
	jsr InitScanLineTab
.endif
	ldx #$ff
	jsr _DoFirstInitIO
.ifdef mega65
 	jsr UnmapUnderlay
.endif
	jsr InitGEOEnv
	jsr SetNewMode
	jsr ClrScr
.ifdef usePlus60K
	jsr DetectPlus60K
.endif
.if .defined(useRamCart64) || .defined(useRamCart128)
	jsr DetectRamCart
.endif
_DebugStart:
	;brk

	jsr GetDirHead
	MoveB bootSec, r1H
	MoveB bootTr, r1L
	AddVB 32, bootOffs
	bne @3
@1:	MoveB bootSec2, r1H
	MoveB bootTr2, r1L
	bne @3
	lda NUMDRV
	bne @2
	inc NUMDRV
@2:	LoadW EnterDeskTop+1, _EnterDeskTop
.ifdef useRamExp
	jsr LoadDeskTop
.endif
	jmp EnterDeskTop

@3:	MoveB r1H, bootSec
	MoveB r1L, bootTr
	LoadW r4, diskBlkBuf
	jsr GetBlock
	bnex @2
	MoveB diskBlkBuf+1, bootSec2
	MoveB diskBlkBuf, bootTr2
@4:	ldy bootOffs
	lda diskBlkBuf+2,y
	beq @5
	lda diskBlkBuf+$18,y
	cmp #AUTO_EXEC
	beq @6
@5:	AddVB 32, bootOffs
	bne @4
	beq @1
@6:	ldx #0
@7:	lda diskBlkBuf+2,y
	sta dirEntryBuf,x
	iny
	inx
	cpx #30
	bne @7
	LoadW r9, dirEntryBuf
	LoadW EnterDeskTop+1, OrigResetHandle
	LoadB r0L, 0
	jsr LdApplic

loadZDriveOffset:

	; ok, different ROM version have different locations of the
	; device numbers map for the internal/F011 drives
	; for 910110 ROM it is 010112/010113
	; for 9110XY ROM it is 010113/010114

	; as a simple solution for now we detect the ROM and use
	; ROM < 10 to be 010112/010113, otherwise 010113/010114
	; default is 2, so for old ROM or unrecognized situations

	PushW	r0
	PushW	r1

	lda	#$16
	sta 	r0L
	lda 	#$00
	sta 	r0H
	lda 	#$02
	sta 	r1L
	lda	#$00
	sta 	r1H

	ldz	#0
	EOM
	lda	(r0), z
	cmp	'V'
	bne	@1
	inz
	EOM
	lda	(r0), z
	cmp	#'9'
	bne	@1

	inz
	inz
	EOM
	lda	(r0), z
	cmp	#'1'
	bne	@1
	PopW	r1
	PopW	r0
	ldz	#3
	rts
@1:
	PopW	r1
	PopW	r0
	ldz	#3
	rts

underlaylist:
	; enchanced dma mode header
	.byte	$0a
	.byte	$80, $00
	.byte	$81, $00
	.byte 	0
	.byte	0	; swap
	.word	$2000	; $6000-$8000
	.word	$A000
	.byte	0				; bank 0
	.word	$A000
	.byte	1				; bank 1
	.word	0				; unsued mod

.ifdef debugger
debuggerlist:
	; enchanced dma mode header
	.byte	$0a
	.byte	$80, $00
	.byte	$81, $00
	.byte 	0
	.byte	0	; swap
	.word	$2000	; $6000-$8000
	.word	$6000
	.byte	0				; bank 0
	.word	$6000
	.byte	1				; bank 1
	.word	0				; unsued mod
.endif

imageFileName:
	.byte	"GEOSX.D81", NULL
bootTr:
	.byte DIR_1581_TRACK
bootSec:
	.byte 3
bootTr2:
	.byte 0
bootSec2:
	.byte 0
bootOffs:
	.byte 0
