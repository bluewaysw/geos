
;GEOS F1011 disk driver
;reassembled by Maciej 'YTM/Elysium' Witkowiak
;31.08-3.09.2001
;ported 1581 to F011 for MEGA65 compatiblity
;05.08.2016 - 08.08.2016

		;*=DISK_BASE

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "jumptab.inc"
.include "c64.inc"


; this module is always built with the mega65 variant, so 4510 cpu supported enabled

.segment "drvf011"

DriveAddy = $0300

USE_BLOCK_DMA = 1

STATE_INIT	= 0
STATE_FAILED	= 1
STATE_SUCCESS	= 2

dir3Head	= $9c80

_InitForIO:			.word __InitForIO		;9000
_DoneWithIO:			.word __DoneWithIO		;9002
_ExitTurbo:			.word __ExitTurbo		;9004
_PurgeTurbo:			.word __PurgeTurbo		;9006
_EnterTurbo:			.word __EnterTurbo		;9008
_ChangeDiskDevice:	.word __ChangeDiskDevice	;900a
_NewDisk:			.word __NewDisk 		;900c
_ReadBlock:			.word __ReadBlock		;900e
_WriteBlock:			.word __WriteBlock		;9010
_VerWriteBlock:		.word __VerWriteBlock		;9012
_OpenDisk:			.word __OpenDisk		;9014
_GetBlock:			.word __GetBlock		;9016
_PutBlock:			.word __PutBlock		;9018
_GetDirHead:			.word __GetDirHead		;901a
_PutDirHead:			.word __PutDirHead		;901c
_GetFreeDirBlk:		.word __GetFreeDirBlk		;901e
_CalcBlksFree:	.word __CalcBlksFree		;9020
_FreeBlock:			.word __FreeBlock		;9022
_SetNextFree:		.word __SetNextFree		;9024
_FindBAMBit:			.word __FindBAMBit		;9026
_NxtBlkAlloc:		.word __NxtBlkAlloc		;9028
_BlkAlloc:			.word __BlkAlloc		;902a
_ChkDkGEOS:			.word __ChkDkGEOS		;902c
_SetGEOSDisk:		.word __SetGEOSDisk		;902e

Get1stDirEntry:		JMP _Get1stDirEntry		;9030
GetNxtDirEntry:		JMP _GetNxtDirEntry		;9033
GetBorder:			JMP _GetBorder			;9036
AddDirBlock:			JMP _AddDirBlock		;9039
ReadBuff:			JMP _ReadBuff			;903c
WriteBuff:			JMP _WriteBuff			;903f
					JMP __I9042			;9042
					JMP GetDOSError 		;9045
AllocateBlock:		JMP _AllocateBlock		;9048
ReadLink:			JMP _ReadLink			;904b

E904E:				.byte $03			;904e

	.byte	0	; filler, wheels version
				
SetImageFile:          	; $9050
	JMP	_SetImageFile 
SetImageCluster:	; $9053
	JMP	_SetImageCluster
GetImageFile:          	; $9056
	JMP	_GetImageFile 

; ==============================================================================

evenFlag:		.byte 0

; ==============================================================================

__GetDirHead:	
	JSR SetDirHead_1		;904f
	JSR __GetBlock
	BNE GDH_0
	JSR SetDirHead_2
	JSR __GetBlock
	BNE GDH_0
	JSR SetDirHead_3
	BNE __GetBlock
GDH_0:		
	RTS				;9064

_ReadBuff:	
	LoadW r4, diskBlkBuf		;9065

__GetBlock:
	JSR InitForIO
	JSR ReadBlock

	JSR DoneWithIO

	TXA
	RTS

__PutDirHead:					;907d
	JSR SetDirHead_1
	JSR __PutBlock
	BNE PDH_0
	JSR SetDirHead_2
	JSR __PutBlock
	BNE PDH_0
	JSR SetDirHead_3
	BNE __PutBlock
PDH_0:		
	RTS				;9092

_WriteBuff:	
	LoadW r4, diskBlkBuf		;9093
__PutBlock:
	JSR InitForIO
	JSR WriteBlock
	bnex PutBlk0
	JSR VerWriteBlock

PutBlk0:
	JSR DoneWithIO			;90ac

	TXA
	RTS

SetDirHead_1:	
	LDX #>curDirHead		;90b1
	LDY #<curDirHead
	LDA #0
	BEQ SDH_1

	SetDirHead_2:	
	LDX #>dir2Head			;90b9
	LDY #<dir2Head
	LDA #1
	BNE SDH_1
SetDirHead_3:
	LDX #>dir3Head			;90c1
	LDY #<dir3Head
	LDA #2
SDH_1:		
	STX r4H				;90c7
	STY r4L
	STA r1H
	LDA #DIR_1581_TRACK
	STA r1L
	RTS

CheckParams:
	bbrf 6, curType, CheckParams_1	;90d2
	JSR DoCacheVerify
	BEQ CheckParams_2
CheckParams_1:
	LDA #0				;90dc
	STA errCount
	LDX #INV_TRACK
	LDA r1L
	BEQ CheckParams_2
	CMP #81
	BCS CheckParams_2
	SEC
	RTS
CheckParams_2: 	
	CLC				;90ed
	RTS

__OpenDisk:					;90ba
	LDY curDrive
	LDA _driveType,y
	STA tmpDriveType
	AND #%10111111
	STA _driveType,y
	
	lda #128
	sta curtrk
	
	JSR NewDisk
	bnex OpenDsk1
	JSR GetDirHead
	bnex OpenDsk1
	bbrf 6, tmpDriveType, OpenDsk10
	JSR SetDirHead_1
	JSR DoCacheVerify
	BNE OpenDsk0
	JSR SetDirHead_2
	JSR DoCacheVerify
	BEQ OpenDsk10
OpenDsk0:
	JSR DoClearCache		;911e
	JSR SetDirHead_1
	JSR DoCacheWrite
	JSR SetDirHead_2
	JSR DoCacheWrite
	JSR SetDirHead_3
	JSR DoCacheWrite
OpenDsk10:
	JSR SetCurDHVec			;9133

	JSR ChkDkGEOS
	LoadW r4, curDirHead+OFF_DISK_NAME
	LDX #r5
	JSR GetPtrCurDkNm
	LDX #r4
	LDY #r5
	LDA #18
	JSR CopyFString
	LDX #0
OpenDsk1:
	LDY curDrive			;910a
	LDA tmpDriveType
	STA _driveType,y
	RTS

__BlkAlloc:					;915b
	PopW r3			;!!!hint???
	PushW r3
	SubW SaveFile+1, r3
	LDY #$27
	LDA r3H
	BEQ E917E
	LDY #$23
E917E:
	STY r3L				;917e
	LDY #0
	STY r3H
	LDA #2
	BNE E918A
__NxtBlkAlloc:
	LDA #0				;9188
E918A:
	STA E9C64			;918a

	PushW r9
	PushW r3
	LoadW r3, $00fe
	LDX #r2
	LDY #r3
	JSR Ddiv
	LDA r8L
	BEQ BlkAlc0
	INC r2L
	BNE *+4
	INC r2H
BlkAlc0: 	
	JSR SetCurDHVec			;91b2
	JSR CalcBlksFree
	PopW r3
	LDX #INSUFF_SPACE
	CmpW r2, r4
	BEQ BlkAlc1
	BCS BlkAlc4
BlkAlc1: 	
	MoveW r6, r4			;91ce
	MoveW r2, r5
BlkAlc2:
 	JSR SetNextFree 		;91de
	bnex BlkAlc4
	LDY #0
	LDA r3L
	STA (r4),y
	INY
	LDA r3H
	STA (r4),y
	AddVW 2, r4
	LDA E9C64
	BEQ BlkAlc2_1
	DEC E9C64
	BNE BlkAlc2_1
	LoadB r3L, $23
BlkAlc2_1:	
	LDA r5L				;9208
	BNE *+4
	DEC r5H
	DEC r5L
	LDA r5L
	ORA r5H
	BNE BlkAlc2
	LDY #0
	TYA
	STA (r4),y
	INY
	LDA r8L
	BNE BlkAlc3
	LDA #$fe
BlkAlc3: 
	CLC				;9222
	ADC #1
	STA (r4),y
	LDX #0
BlkAlc4:
 	PopW r9			;9229
	RTS

SetCurDHVec:	
	LoadW r5, curDirHead		;9230
	RTS

_Get1stDirEntry:			
		;9239
	JSR SetDirHead_3
	INC r1H
	LoadB borderFlag, 0
	BEQ GNDirEntry0

_GetNxtDirEntry:				;9245
	LDX #0
	LDY #0
	AddVW $20, r5
	CmpWI r5, diskBlkBuf+$ff
	BCC GNDirEntry1
	LDY #$ff
	MoveW diskBlkBuf, r1
	BNE GNDirEntry0
	LDA borderFlag
	BNE GNDirEntry1
	LDA #$ff
	STA borderFlag
	JSR GetBorder
	bnex GNDirEntry1
	TYA
	BNE GNDirEntry1
GNDirEntry0:
	JSR ReadBuff			;9281
	LDY #0
	LoadW r5, diskBlkBuf+FRST_FILE_ENTRY
GNDirEntry1:
	RTS				;928e

_GetBorder:					;928f
	JSR GetDirHead
	bnex GetBord2
	JSR SetCurDHVec
	JSR ChkDkGEOS
	BNE GetBord0
	LDY #$ff
	BNE GetBord1
GetBord0:	
	MoveW curDirHead+OFF_OP_TR_SC, r1	;92a1
	LDY #0
GetBord1:	
	LDX #0				;92ad
GetBord2:	
	RTS				;92af

__ChkDkGEOS:					;92b0
	LDY #OFF_GS_ID
	LDX #0
	STX isGEOS
ChkDkG0:
 	LDA (r5),y			;92b7
	CMP GEOSDiskID,x
	BNE ChkDkG1
	INY
	INX
	CPX #11
	BNE ChkDkG0
	LoadB isGEOS, $ff
ChkDkG1:
 	LDA isGEOS			;92c9
	RTS

GEOSDiskID:
	.byte "GEOS format V1.0",NULL	;92cd

__GetFreeDirBlk: 				;92de
	PHP
	SEI
	PushB r6L
	PushW r2
	LDX r10L
	INX
	STX r6L
	LoadB r1L, DIR_1581_TRACK
	LoadB r1H, 3
GFDirBlk0:
	JSR ReadBuff			;92f6
GFDirBlk1:
	bnex GFDirBlk5 		;92f9
	DEC r6L
	BEQ GFDirBlk3
GFDirBlk11:
	LDA diskBlkBuf			;9300
	BNE GFDirBlk2
	JSR AddDirBlock
	bra GFDirBlk1
GFDirBlk2:
	STA r1L 			;930b
	MoveB diskBlkBuf+1, r1H
	bra GFDirBlk0
GFDirBlk3:
	LDY #FRST_FILE_ENTRY		;9315
	LDX #0
GFDirBlk4:
	LDA diskBlkBuf,y		;9319
	BEQ GFDirBlk5
	TYA
	addv $20
	TAY
	BCC GFDirBlk4
	LoadB r6L, 1
	LDX #FULL_DIRECTORY
	LDY r10L
	INY
	STY r10L
	CPY #$12
	BCC GFDirBlk11
GFDirBlk5:
	PopW r2			;9334
	PopB r6L
	PLP
	RTS

_AddDirBlock:					;933f
	PushW r6
	LDX #4
	LDA dir2Head+$fa
	BEQ ADirBlk0
	MoveW r1, r3
	JSR SetNextFree
	MoveW r3, diskBlkBuf
	JSR WriteBuff
	bnex ADirBlk0
	MoveW r3, r1
	JSR ClearAndWrite
ADirBlk0:
	PopW r6			;9372
	RTS

ClearAndWrite:
	LDA #0				;9379
	TAY
CAndWr0:
 	STA diskBlkBuf,y		;937c
	INY
	BNE CAndWr0
	DEY
	STY diskBlkBuf+1
	JMP WriteBuff

__SetNextFree:					;9389
	JSR SNF_1
	BNE SNF_0
	RTS
SNF_0:
	LoadB r3L, $27			;938f
SNF_1:
	LDA r3H				;9393
	addv 1
	STA r6H
	MoveB r3L, r6L
	CMP #DIR_1581_TRACK
	BEQ SNF_3
SNF_2:
	LDA r6L				;93a2
	CMP #DIR_1581_TRACK
	BEQ SNF_8
SNF_3:
	CMP #DIR_1581_TRACK+1		;93a8
	BCC SNF_4
	subv DIR_1581_TRACK
SNF_4:
	subv $01			;93af
	ASL
	STA r7L
	ASL
	CLC
	ADC r7L
	TAX
	CmpBI r6L, DIR_1581_TRACK+1
	BCC SNF_5
	LDA dir3Head+$10,x
	bra SNF_6
SNF_5:
	LDA dir2Head+$10,x		;93c6
SNF_6:
	BEQ SNF_8			;93c9
	LoadB r7L, DIR_1581_TRACK
	TAY
SNF_7:
	JSR SNxtFreeHelp		;93d0
	BEQ SNF_11
	INC r6H
	DEY
	BNE SNF_7
SNF_8:
	CmpBI r6L, DIR_1581_TRACK+1			;93da
	BCS SNF_9
	DEC r6L
	BNE SNF_10
	LoadB r6L, DIR_1581_TRACK+1
	BNE SNF_10
SNF_9:
	INC r6L				;93ea
SNF_10:
	CmpBI r6L, $51			;93ec
	BCS SNF_12
	LoadB r6H, 0
	BEQ SNF_2
SNF_11:
	MoveW r6, r3			;93f8
	LDX #0
	RTS
SNF_12:
	LDX #INSUFF_SPACE		;9403
	RTS

SNxtFreeHelp:	
	LDA r6H 			;9406
SNFHlp_1:	
	CMP r7L 			;9408
	BCC SNFHlp_2
	sub r7L
	bra SNFHlp_1
SNFHlp_2:
	STA r6H 			;9412

_AllocateBlock:
	JSR FindBAMBit			;9414
	BNE AllBlk_0
	LDX #BAD_BAM
	RTS
AllBlk_0:
	PHP				;941c
	CmpBI r6L, DIR_1581_TRACK+1
	BCC AllBlk_2
	LDA r8H
	EOR dir3Head+$10,x
	STA dir3Head+$10,x
	LDX r7H
	PLP
	BEQ AllBlk_1
	DEC dir3Head+$10,x
	bra AllBlk_4
AllBlk_1:
	INC dir3Head+$10,x		;9436
	bra AllBlk_4
AllBlk_2:
	LDA r8H				;943c
	EOR dir2Head+$10,x
	STA dir2Head+$10,x
	LDX r7H
	PLP
	BEQ AllBlk_3
	DEC dir2Head+$10,x
	bra AllBlk_4
AllBlk_3:
	INC dir2Head+$10,x		;944f
AllBlk_4:
	LDX #0				;9452
	RTS

__FreeBlock:
	JSR FindBAMBit			;9455
	BEQ AllBlk_0
	LDX #BAD_BAM
	RTS

__FindBAMBit:
					;945d
	LDA r6H
	AND #%00000111
	TAX
	LDA FBBBitTab,x
	STA r8H
	CmpBI r6L, DIR_1581_TRACK+1
	BCC FBB_1
	subv DIR_1581_TRACK
FBB_1:
	subv $1
	ASL
	STA r7H
	ASL
	add r7H
	STA r7H
	LDA r6H
	LSR
	LSR
	LSR
	SEC
	ADC r7H
	TAX
	CmpBI r6L, DIR_1581_TRACK+1
	BCC FBB_2
	LDA dir3Head+$10,x
	AND r8H
	RTS
FBB_2:
	LDA dir2Head+$10,x
	AND r8H
	RTS
		
FBBBitTab:
	.byte $01, $02, $04, $08	;9497
	.byte $10, $20, $40, $80

__CalcBlksFree:					;949f
	LoadW r4, 0
	LDY #$10
CBlksFre0:
	LDA dir2Head,y			;94a7
	add r4L
	STA r4L
	BCC *+4
	INC r4H
CBlksFre1:
	TYA				;94b3
	addv 6
	TAY
	CPY #$FA
	BEQ CBlksFre1
	CPY #$00
	BNE CBlksFre0
	LDY #$10
CBlksFre2:
	LDA dir3Head,y			;94c2
	add r4L
	STA r4L
	BCC *+4
	INC r4H
CBlksFre3:
	TYA				;94ce
	addv 6
	TAY
	BNE CBlksFre2
	LoadW r3, $0c58
	RTS

__InitForIO:					;95c6
	PHP
	PLA
	STA tmpPS
	SEI

	LDA $D030
	LDA CPU_DATA
	STA tmpCPU_DATA
	LoadB CPU_DATA, KRNL_IO_IN

	lda #C65_VIC_INIT1
	sta $d02f
	lda #C65_VIC_INIT2
	sta $d02f
	
	LDA grirqen
	STA tmpgrirqen
	LDA clkreg
	STA tmpclkreg
	LDY #0
	STY clkreg
		
	STY grirqen
	LDA #%01111111
	STA grirq
	STA cia1base+13
	STA cia2base+13
.if 1
	lda #>D_IRQHandler
	sta irqvec+1
.if .defined(config128) & (!.defined(mega65))
	sta nmivec+1
.endif
	lda #<D_IRQHandler
	sta irqvec
.if .defined(config128) & (!.defined(mega65))
	sta nmivec
.endif
.if (!.defined(config128)) || .defined(mega65)
	lda #>D_NMIHandler
	sta nmivec+1
	lda #<D_NMIHandler
	sta nmivec
.endif
.endif
	
	LDA #%00111111
	STA cia2base+2
	LDA mobenble
	STA tmpmobenble
	STY mobenble
	STY cia2base+5
	INY
	STY cia2base+4
	
	LoadB	imageMounted, STATE_INIT
.if 0
	; set or reset floppy bit for drive 1 if needed
	lda	$D6A1
	cpy	#DRV_F011_0
	bne	@1
	ora	#4	; set drive 1 real floppy
	sta	$D6A1
		
@1:
	
	; mount sd if needed
	cpy	#DRV_SD_81
	bne	@1b
	jsr	HyperSave
	
	lda control_store
	ora #$01
	sta $D080
	sta control_store


	; do mount now, drive 1
	;; Copy file name
	ldy #0
@2:
	lda TestImageName,y
	sta $0100,y
	iny
	cmp #0
	bne @2
	;;  Call dos_setname()
	ldy #>$0100
	ldx #<$0100
	lda #$2E     		; dos_setname Hypervisor trap
	STA $D640		; Do hypervisor trap
	NOP			; Wasted instruction slot required following hyper trap instruction

	;; XXX Check for error (carry would be clear)

	lda #$46     		; dos_d81attach1
	STA $D640		; Do hypervisor trap
	NOP			; Wasted instruction slot required following hyper trap instruction
.if 0
	;lda #$44     		; dos_d81write_en
	;STA $D640		; Do hypervisor trap
	;NOP			; Wasted instruction slot required following hyper trap instruction
.endif
	lda $d68b		;write enable f011 drive one
	ora #$20
	sta $d68b

	jsr	HyperRestore

@3:
	;bra @3
.endif	
@1b:	
	RTS
	
D_IRQHandler:
.if .defined(config128) &(!.defined(mega65))
    pla
    sta $ff00
.endif
	pla
	tay
	pla
	tax
	pla
D_NMIHandler:
	rti

__DoneWithIO:
	SEI
	ldy	curType
	cpy	#DRV_F011_1
	beq	@1a
	cpy	#DRV_F011_0
	bne	@1
@1a:
	;jsr	_WaitReady
	lda	control_store
	and	#%10011111
	jsr	_ControlReg
	;jsr _MotorDelay
	;lda #128
	;sta curtrk
@1:
	LDA tmpclkreg
	STA clkreg
	LDA tmpmobenble
	STA mobenble
	LoadB cia2base+13, %01111111
	LDA cia2base+13
	LDA tmpgrirqen
	STA grirqen
;.ifndef mega65
	lda #C65_VIC_INIT1
	sta $d02f
	lda #C65_VIC_INIT2
	sta $d02f
	lda $d031
	ora #$40
	sta $d031
;.endif	
;.ifndef mega65
	LDA tmpCPU_DATA
	cmp #RAM_64K
	bne @2
	lda #IO_IN
@2:
	STA CPU_DATA
	LoadB CPU_DATA, IO_IN
;.endif
	LDA tmpPS
	PHA
	PLP
	RTS

_EnsureImageMounted:
	; after bitstream updates #192 #193
	; virtual (one drive expected) is using first one found (or none)
	; floppy (internal or external) is used on and if there is an appropriate drive config
	; sd mount is used on and if there is an appropriate drive config

	; init state
	; set or reset floppy bit for drive 1 if needed
	LoadB	imageMounted, STATE_FAILED
	ldy	curType
	LoadB	mountDrive, $FF
	LoadB	mountCount, 0

	; ======================================================================
	; match drive 0

	; is drive 0 virtual? (D68A.2)
	lda	$D68A
	and	#%00000100
	beq	@5000

	; are we looking for virtual drive
	cpy	#DRV_F011_V
	bne	@6000

	; matched virtual drive
	jmp	@9002

@5000:
	; drive 0 not virual, check floppy
	lda	$D6A1
	and	#%00000001
	beq	@5001			; drive 0 is no floppy

	; drive 0 is floppy, check of internal or external
	cpy	#DRV_SD_81
	beq	@5020
	LoadB	mountDrive, 0
@5020:
	lda	$D689
	and	#%00100000
	bne	@5002			; drive 0 is swapped, so it is external

	; drive 0 is internal floppy
	cpy	#DRV_F011_0
	bne	@6000

	lda	#0
	jmp	@9000

@5002:
	; drive 0 is external floppy
	cpy	#DRV_F011_1
	bne	@6000

	bra	@9002

@5001:
	; drive 0 is sd mount
	inc 	mountCount
	cpy	#DRV_SD_81
	bne	@6000

	lda	$D68B
	and	#$01
	beq	@6000

	LoadB	mountDrive, 0

	; check if expected mount
	; check if something already has been mounted
	;lda	currentImageCluster
	;and	currentImageCluster+1
	;and	currentImageCluster+2
	;and	currentImageCluster+3
	;cmp	#$FF
	;bne	@6000

	ldy	#3
@5007:
	lda	$D68C,y
	cmp	currentImageCluster,y
	bne	@6001
	dey
	bpl	@5007

@9002:
	lda	#0
	bra	@9000

@6001:	
	ldy	curType

	; ======================================================================
	; match drive 1
@6000:
	; is drive 1 virtual? (D68A.2)
	lda	$D68A
	and	#%00001100
	beq	@6002

	; are we looking for virtual drive
	cpy	#DRV_F011_V
	bne	@7000

	; matched virtual drive
	lda	#1
	bra	@9000

@6002:
	; drive 1 not virual, check floppy
	lda	$D6A1
	and	#%00000100
	beq	@6011			; drive 1 is no floppy

	; drive 1 is floppy, check of internal or external
	cpy	#DRV_SD_81
	beq	@6020
	LoadB	mountDrive, 1
@6020:

	lda	$D689
	and	#%00100000
	bne	@6003			; drive 1 is swapped, so it is internal

	; drive 1 is external floppy
	cpy	#DRV_F011_1
	bne	@7000

	lda	#1
	bra	@9000

@6003:
	; drive 1 is internal floppy
	cpy	#DRV_F011_0
	bne	@7000

	lda	#1
	bra	@9000

@6011:
	; drive 1 is sd mount
	inc 	mountCount
	cpy	#DRV_SD_81
	bne	@7000
	
	lda	$D68B
	and	#$02
	beq	@7000

	LoadB	mountDrive, 1

	; check if expected mount
	; check if something already has been mounted
	;lda	currentImageCluster
	;and	currentImageCluster+1
	;and	currentImageCluster+2
	;and	currentImageCluster+3
	;cmp	#$FF
	;bne	@7000

	ldy	#3
@6007:
	lda	$D690,y
	cmp	currentImageCluster,y
	bne	@6091
	dey
	bpl	@6007

	lda	#1
@9000:
	sta	mountDrive
	LoadB	imageMounted, STATE_SUCCESS
	jmp 	@1b

@6091:	
	ldy	curType
@7000:

	; no exact match
	; was there a candidate drive for reconfiguration/mount?
	lda	mountDrive
	cmp	#$FF
	bne	@7001

	; if floppy and mount count == 0, force drive 1 to be floppy
	lda	$D689
	cpy	#DRV_F011_0
	bne	@7010

	; drive 1 -> floppy, swapped
	ora	#%00100000

	bra	@7011
@7010:	
	cpy	#DRV_F011_1
	bne	@7004

	; drive 1 -> floppy, unswapped
	and	#%11101111
@7011:
	sta	$D689

	; GS $D6A1.2 F011:DRV2EN Use real floppy drive instead of SD card for 2nd floppy drive
	lda	$D6A1						; force drive 1 to be floppy
	ora	#%00000100
	sta	$D6A1

	lda	#1
	sta	mountDrive
	LoadB	imageMounted, STATE_SUCCESS
	jmp 	@1b


	; failed to init a proper drive
@7004:
	LoadB	imageMounted, STATE_FAILED
	ldx 	#NO_SYNC
	sec
	rts

@7001:
	cpy	#DRV_SD_81
	beq	@7002

	; so it is floppy, let swap and done
	; GS $D689.5 - F011 swap drive 0 / 1
	lda	$D689
	eor	#%00100000
	sta	$D689

	lda	mountDrive
	bra	@9000

@7002:
	; we have to mount anyhow
	lda	currentImageName
	beq	@7004

	; mount image
	jsr	HyperSave

	; do mount now, drive 1
	;; Copy file name
	ldy	#0
@6:
	lda	currentImageName,y
	sta	$0100,y
	iny
	cmp	#0
	bne	@6
	
	;;  Call dos_setname()
	ldy	#>$0100
	ldx	#<$0100
	lda	#$2E     	; dos_setname Hypervisor trap
	STA	$D640		; Do hypervisor trap
	NOP			; Wasted instruction slot required following hyper trap instruction

	;; XXX Check for error (carry would be clear)
	lda	#$46     	; dos_d81attach1
	ldy	mountDrive
	cpy	#1
	beq	@8000
	lda	#$40		; dos_d81attach0
@8000:
	STA	$D640		; Do hypervisor trap
	NOP			; Wasted instruction slot required following hyper trap instruction

	bcs	@ok
@HOHO:
	bra	@HOHO
@ok:
	lda	$d68b
	ora	#$20
	sta	$d68b

	; remember cluster
	ldy	#0
	lda	mountDrive
	cmp	#0
	beq	@8003
@8001:
	lda	$D690,y
	sta	currentImageCluster,y
	iny	
	cpy	#4
	bne	@8001
	bra	@8002
@8003:
	lda	$D68C,y
	sta	currentImageCluster,y
	iny	
	cpy	#4
	bne	@8003
@8002:
	jsr	HyperRestore

	; the hypervisor in new bitstreams changes the buffer, so change it back as we need it
	lda	$d689			; force to use floppy buffer
	and	#$7f
	sta	$d689

	LoadB	imageMounted, STATE_SUCCESS
@1b:

	lda	control_store
	and	#$FE
	ora	mountDrive
	sta	$D080
	sta	control_store
@1:
	clc
	rts

_ReadLink:					;98cf
__ReadBlock:					;98e4

	JSR CheckParams_1
	bcs @1
	jmp  _ReadBlockEnd
@1:
	bbrf 6, curType, _ReadBlockCont1
	JSR DoCacheRead
	BEQ @1b
	jmp _ReadBlockEnd
@1b:

_ReadBlockCont1:
; Read sector from disk
	JSR _SetOperation	; set 
	BCC @1c
@1d:
	jmp _ReadBlockEnd
@1c:
	jsr _WaitReady
	lda #$01
	sta $D081
	jsr _WaitReady
	LDA #$40
	STA $D081
.if 1	
	ldy #$28
	ldx #0
@aa:
	DEX
	bne @aa
	dey
	bne @aa
.endif
.if USE_BLOCK_DMA
	jsr _WaitReady
.endif	
@3:
	LDA $D082
	AND #$10
	BNE @2
.ifndef USE_BLOCK_DMA
	LDA $D083
	BPL @3
.endif
	bra @1a
@2:
	sec
	jmp	_ReadBlockEnd
@1:
	brk
@1a:
	lda	curDrive
	cmp	#DRV_F011_0
	bne	@2a
@2a:

.ifdef USE_BLOCK_DMA
	MoveW r4, dmalist_to
.endif

	LDY #$00		;; read over 256 bytes if needed
	LDA evenFlag
	BEQ @4

.ifdef USE_BLOCK_DMA
	; get second half
	LoadB dmalist_from+1, $61
	bra @do_dma
.else
@5:
	JSR _ReadByteSlow		
	INY
	BNE @5
.endif
@4:
.ifdef USE_BLOCK_DMA
	; get first half
	LoadB dmalist_from+1, $60
@do_dma:
	lda	#>dmalist
	ldy	#<dmalist

	sta	$d701
	lda	#0
	sta	$d702
	sta 	$d704	;	enhanced bank
	sty	$d705
.else
@6:
	JSR _ReadByteSlow		; read our 256 byte sector in the buffer?
	STA (r4L),Y
	INY
	BNE @6
.endif	

	jsr _CheckResult
	bcs _ReadBlockEnd
	LDX #0			; no error
	
ReadBlockDirBlock:
	CmpBI r1L, DIR_1581_TRACK                      ;9924
	BNE _ReadBlockWriteCache
	LDA r1H
	BNE _ReadBlockWriteCache

	LDY #4
_ReadBlockMoveLoop:
	LDA (r4),y                      ;9930
	STA E9C63
	TYA
	addv $8c
	TAY
	LDA (r4),y
	PHA
	LDA E9C63
	STA (r4),y
	TYA
	subv $8c
	TAY
	PLA
	STA (r4),y
	INY
	CPY #$1d
	BNE _ReadBlockMoveLoop

_ReadBlockWriteCache:
	bnex _ReadBlockEnd                  ;9924
	bbrf 6, curType, _ReadBlockEnd
	JSR DoCacheWrite
	bra _ReadBlockEnd

_ReadBlockEnd:
	LDY #0

	RTS

.ifdef USE_BLOCK_DMA
; 0xffd6000L

dmalist:
	; enchanced dma mode header
	.byte	$0a
	.byte	$80, $FF
	.byte	$81, $00
	.byte 	0
	.byte	0	; swap
	.word	256
dmalist_from:
	.word	$6000
	.byte	$0d				; bank 0
dmalist_to:
	.word	DISK_SWAPBASE+DISK_DRV_LGH
	.byte	0				; bank 1
	.word	0				; unsued mod
.endif

_ReadByteSlow:
	jsr _ReadByte
	rts

_ReadByte:
@1:
	lda $d082
	bit #%00001000
	bne @2
	LDA $D082
	AND #$20
	BNE @1
	LDA $D087
@2:
	RTS
_WriteByte:
	STA $D087
	RTS
	
_SetOperation:

	JSR _WaitReady

	jsr _EnsureImageMounted
	
	bcs @3
	LDA r1L		; track 1-80
	DEC
	STA $D084		; track
	
	LDA r1H		; 
	CMP #$14		; c set if >= 20
	LDA #$00
	ROL
	;EOR #1
	STA $D086		; side
	;EOR #1
	BEQ @1
	LDA #$14
@1:
	NEG
	CLC
	ADC r1H
	LSR
	INC
	STA $D085		; sector
	
	LDA #$00
	ROR
	STA evenFlag
	
	lda curType
	cmp #DRV_F011_0
	beq @real
	cmp #DRV_F011_1
	bne @2

@real:
	jsr _InitControl
	bcs @3
	jsr _FindTrack
@2:
	CLC
	RTS
@3:
	sec
	rts
	
	
_SideMask:
	.byte $08, $00
		
_InitControl:
	lda control_store
	and #$60
	tay
	
	ldx $D086	; side
	lda _SideMask, x
	bne @5
@5:
	ora #$60	; motor (+led)
	;ora drive
	jsr _ControlReg
	tya
	bne @4
	
	jsr _MotorDelay
@4:
	lda #$01	; reset_bp
	sta $D081
	jsr _WaitReady
	dec $D081
	jsr _WaitReady
	
	
	lda #96		; steprate
	sta $D089
	lda #$FF
	sta $D088
	
	; got a disc?
	lda $D083	;statb
	and #$01
	bne @step 
@6:
	; seek the Track
	ldx #0
	lda curtrk
	bpl @1

	lda #$10	; stin
	
@3:
	lsr $D082	; stata
	bcs @2
	jsr _ExecCommand
	inx
	cpx #100	; if drive not present
			; seeking 100 should not find
			; track 0 
	bne @3
	ldx #DEV_NOT_FOUND
	bra @err
@2:
	jsr _SettleHead
	lda #0
	sta curtrk
@1:
	clc
	rts
@step:
	; using dskchg/rdy to detect inserted disk
	; if unready step may force it to enter ready
	; otherwise no disc is inserted
	lda #128
	sta curtrk
	lda #$10	; stin
	jsr _ExecCommand

	LDX #$21	; "no formated disk"	
	lda $D083	;statb
	and #$01
	beq @6
@err:
	sec
	rts
	
	
curtrk: 
	.byte 0
control_store:
	.byte 0

; destroys: y, a, x
_FindTrack:
	ldy #0
	lda $D084		; track we want
@5:
	jsr _WaitReady
	cmp curtrk
	beq @1
	bcc @3
	
	inc curtrk
	ldy #$18	; stout
	bra @4
@3:
	dec curtrk
	ldy #$10	; stin
@4:
	sty $D081
	bra @5
@1:
	tya
	beq @2
	jsr _SettleHead
@2:
	rts

_ControlReg:
	and #$FE
	pha
	jsr _CheckDC
.if 0
	lda curType
	cmp #DRV_F011_V
	beq @4
	lda #3
	bra @5
@4:
	lda #2
@5:
	tsb $D080	; control
.endif
	jsr _WaitReady
	
	lda curType
	cmp #DRV_F011_V
	beq @2
	pla
	ora #1
	bra @3
@2:
	pla
@3:
	sta $D080
	sta control_store 
	bra _WaitReady
	
_CheckDC:
	
	rts
	
_SettleHead:
	jsr _WaitReady
	lda #192	; settle rate
	sta $D089	; step
	lda #$14	; timer (1 step delay)
	jsr _ExecCommand
	jsr _ExecCommand
	lda #96		; step rate
	sta $D089	; step
	jsr _WaitReady
	rts
	
_MotorDelay:
	ldx #0
@1:
	inx 
	stx $D089	; step
	lda #$14	; time
	jsr _ExecCommand
	cpx #96		; step rate
	bcc @1
	rts
	
_ExecCommand:
	STA $D081
_WaitReady:
@1:
	BIT $D082
	BMI @1
	RTS

_CheckResult:
	JSR _WaitReady
	LDA $D082
	AND #$18
	BEQ @1
	
	SEC
	RTS
@1:
	CLC
	RTS

_DriveReady:
	JSR _WaitReady
	LDA $D082
	AND #$02
	BNE @1
	CLC
	RTS
@1:
	SEC
	RTS
	
__WriteBlock:					;9960
	ldy	curType
	cpy	#DRV_F011_1
	beq	@112
	cpy	#DRV_F011_0
	bne	@111
@112:
	sec
	ldx	#$26
	rts	
@111:
	JSR CheckParams
	BCC _WriteBlockEnd

	JSR ReadBlockDirBlock

	; f011 block write here
	JSR _SetOperation		; set track, side, sector
	BCS _WriteBlockEnd
	
	JSR _DriveReady		; drive ready, not wrote protect
	BCS _WriteBlockEnd
	
	lda #$01
	sta $D081
	jsr _WaitReady

	LDA #$46
	JSR _ExecCommand		; execute read	
	JSR _CheckResult		; test if read succeeded
	BCS _WriteBlockEnd
	
	LDY #$00		; skip first 256 bytes if needed
	LDA evenFlag
	BEQ @1
@2:
	JSR _ReadByte	; read byte without checking if available
	INY	
	BNE @2	
@1:
	LDA (r4),Y		; write our 256 byte buffer
	JSR _WriteByte
	INY
	BNE @1
@4:
	LDA $D082		; read up rest of the buffer
	AND #$20
	BNE @3
	JSR _ReadByte 	; read byte without checking if available
	BRA @4
@3:
	LDA #$80
	JSR _ExecCommand 		; write sector

	; read back written sector
	; here we use this not for checking but to ensure the 
	; the next read will be alined, strange
	; TODO: double check why this fails on mega65 if reading
	; the next blick straigt after write command
	LDA #$40	; read command
	JSR _ExecCommand	; execute FDC command
	JSR _CheckResult  	; Test wether read or write succeed?
	
	LDX	#0
	
_WriteBlockEnd:
	JSR ReadBlockDirBlock			;998b

	RTS				;998e

__VerWriteBlock: 				;998f
	LDX #0
	bbrf 6, curType, VWrBlock3
	JMP DoCacheWrite
VWrBlock3:
	RTS				;9886

__ChangeDiskDevice:
	STA curDrive
	STA curDevice

__EnterTurbo:
        ;lda     curDrive                        ; 957B AD 89 84                 ...
        ;jsr     SetDevice                       ; 957E 20 B0 C2                  ..
        ;ldx     #$00                            ; 9581 A2 00                    ..
        ;rts                                     ; 9583 60                       `

__NewDisk:
__PurgeTurbo:
__ExitTurbo:	
GetDOSError:
__I9042:
__SetGEOSDisk:
GetDError:
	LDA #0
	TAX
	RTS


ClrCacheDat:
	.word 0				;9bb2

ClearCache:	
	bbsf 6, curType, DoClearCache	;9bb4
	RTS

DoClearCache:
	JSR E9C4A			;9bba
	LoadW r0, ClrCacheDat		;9c0f
	LDA #0
	STA r1L
	STA r1H
	STA r2H
	LDA #2
	STA r2L
	LDY curDrive
	LDA driveData,y
	STA r3L
DoClrCache1:
	JSR StashRAM			;9bd9
	INC r1H
	BNE DoClrCache1
DoClrCache2:
	LDX #8				;9be0
DoClrCache3:
	LDA E9C63-1,x			;9be2
	STA r0L-1,x
	DEX
	BNE DoClrCache3
	RTS

DoCacheVerify:
	LDA r1L				;9beb
	CMP #DIR_1581_TRACK
	BNE E9BF9
	LDY #$93			;9bf1
	JSR DoCacheDisk
	AND #$20
	RTS
E9BF9:
	LDX #0				;9bf9
	LDA #$ff
	RTS

DoCacheRead:
	LDA r1L				;9bfe
	CMP #DIR_1581_TRACK
	BNE GiveNoError
	LDY #%10010001			;9bfe
	JSR DoCacheDisk
	LDY #0
	LDA (r4),y
	INY
	ORA (r4),y
	RTS
GiveNoError:
	LDX #0				;9c11
	RTS

DoCacheWrite:
	LDA r1L				;9c14
	CMP #DIR_1581_TRACK
	BNE E9C1E
	LDY #%10010000
	BNE DoCacheDisk
E9C1E:
	LDX #0				;9c1e
	RTS
DoCacheDisk:
	JSR E9C4A			;9c21
	TYA
	PHA
	LDY curDrive
	LDA driveData,y
	STA r3L
	LDY #0
	STY r1L
	STY r2L
	INY
	STY r2H
	MoveW r4, r0
	PLA
	TAY
	JSR DoRAMOp
	TAY
	JSR DoClrCache2
	TYA
	RTS

E9C4A:
	LDX #8				;9c4a
E9C4C:
	LDA r0L-1,x			;9c4c
	STA E9C63-1,x
	DEX
	BNE E9C4C
	RTS

HyperSave:
	ldx #0
@1:
	lda $CE00,x
	sta HyperBuffer, x
	inx
	bne @1
	rts

HyperRestore:
	ldx #0
@1:
	lda HyperBuffer, x
	sta $CE00,x
	inx
	bne @1
	rts

imageMounted:
	.byte	0		; TRUE (!= 0) if mount
				; has been resolved after
				; InitForIO or change
				; of image/cluster configuration

_SetImageFile:
	ldx	#r0
	LoadW	r1, currentImageName
	ldy	#r1
	jsr	CopyString
	LoadW	currentImageCluster, $FFFF
	LoadW	currentImageCluster+2, $FFFF
	LoadB	imageMounted, 0
	jmp	_SaveDriver
	
_SetImageCluster:
	MoveW	r0, currentImageCluster
	MoveW	r1, currentImageCluster+2
	LoadB	imageMounted, 0
	lda	#0
	sta	currentImageName
	jmp	_SaveDriver
	
_GetImageFile:
	LoadW	r0, currentImageName
	rts
	
driverRAMStartLow:
	.byte	<($8300)
	.byte	<($8300+DISK_DRV_LGH)
	.byte	<($8300+DISK_DRV_LGH*2)
	.byte	<($8300+DISK_DRV_LGH*3)
driverRAMStartHigh:
	.byte	>($8300)
	.byte	>($8300+DISK_DRV_LGH)
	.byte	>($8300+DISK_DRV_LGH*2)
	.byte	>($8300+DISK_DRV_LGH*3)

_SaveDriver:
	; save driver with the current properties
	lda	sysRAMFlg
	bit	#64
	beq	@1	; branch if driver is not stored in RAM
	
	LoadW	r0, DISK_BASE
	ldx	curDrive
	lda	driverRAMStartLow-8,x
	sta	r1L
	lda	driverRAMStartHigh-8,x
	sta	r1H
	LoadW	r2, DISK_DRV_LGH
	LoadB	r3L, 0
	jsr	StashRAM
@1:
	rts
	
currentImageCluster:
	.word	$FFFF		; illegal cluster number
				; for disc image
	.word	$FFFF
currentImageName:
	.repeat 64
		.byte 0
	.endrep
mountDrive:
	.byte	0
mountCount:
	.byte	0
HyperBuffer:
	.repeat 256
		.byte 0
	.endrep
	
tmpclkreg:
	.byte 0				;9c55
tmpPS:			
	.byte 0				;9c56
tmpgrirqen:		
	.byte 0				;9c57
tmpCPU_DATA:		
	.byte 0				;9c58
tmpmobenble:		
	.byte 0				;9c59
	.byte 0				;9c5a
errCount:		
	.byte 0				;9c60
tmpDriveType:	
	.byte 0				;9c62
E9C63:			
	.byte 0				;9c63
E9C64:			
	.byte 0				;9c64
borderFlag:		
	.byte 0				;9c65

.assert * <= $9C80, error, "Driver code and data need to end before $9C80"