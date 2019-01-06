; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Hardware initialization

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.import ResetMseRegion
.import Init_KRNLVec
.import SetVICRegs
.import VIC_IniTbl_end
.import VIC_IniTbl
.import KbdQueTail
.import KbdQueHead
.import KbdQueFlag
.import KbdDBncTab
.import KbdDMltTab
.import InitVDC

.import SetColorMode

.global _DoFirstInitIO

.segment "hw1b"

_DoFirstInitIO:
	LoadB CPU_DDR, $2f
.ifdef bsw128
	LoadB config, CIOIN
.else
ASSERT_NOT_BELOW_IO
.ifdef mega65
	LoadB CPU_DATA, IO_IN
.else
	LoadB CPU_DATA, KRNL_IO_IN
.endif
.ifdef wheels
	sta scpu_turbo
.endif
.endif
	ldx #7
	lda #$ff
@1:	sta KbdDMltTab,x
	sta KbdDBncTab,x
	dex
	bpl @1
	stx KbdQueFlag
	stx cia1base+2
	inx
	stx KbdQueHead
	stx KbdQueTail
	stx cia1base+3
	stx cia1base+15
	stx cia2base+15
.ifdef bsw128
	PushB rcr
	and #%11110000
	ora #%00000111
	sta rcr
.endif
	lda PALNTSCFLAG
	beq @2
	ldx #$80
@2:
.ifdef bsw128
	PopB rcr
.endif
	stx cia1base+14
	stx cia2base+14
	lda cia2base
	and #%00110000
	ora #%00000101
	sta cia2base
	LoadB cia2base+2, $3f
	LoadB cia1base+13, $7f
	sta cia2base+13
.ifdef bsw128
	lda cia1base+13
	lda cia2base+13
.endif
	LoadW r0, VIC_IniTbl
.assert * - VIC_IniTbl_end - VIC_IniTbl < 256, error, "VIC_IniTbl must be < 256 bytes"
	ldy #<(VIC_IniTbl_end - VIC_IniTbl)
	jsr SetVICRegs
.ifdef bsw128
	jsr InitVDC
	lda #0 ; monochrome mode
	jsr SetColorMode
.endif
.ifdef mega65
.if 1
	; Enable C65GS IO
	; 47, 53 = enable VIC IV
	; a5, 96 = enable VIC III
	
	lda #$47
	sta $d02f
	lda #$53
	sta $d02f

	; enable 800x600 mode
	; 1. Set horizontal border width
	LDA #$00
	STA $D05C
	STA $D05D
	
	; Set bitmap mode (makes horizontal borders take effect)
	LDA   #$3B
	STA   $D011

	; Set 640H, 400V
	LDA   $D031
	ORA   #$C8
	STA   $D031

	lda	#$04	; 3.5Mhz, H640, bitplanes
	sta	$d030
	
	 ; Set to 100 characters per row
	 LDA   #100
	 STA   $D058
	 
	 ; Disable/Enable 16-colour sprite mode for each sprite?
	 LDA	  #$00
	 STA	  $D06B

	; Bit 10 of sprite X position for positions >511
	 LDA	#$00
	 STA	$D05F
	
	 LDA #<$4000
	 STA $D068
	 LDA #>$4000
	 STA $D069
	 LDA #1
	 STA $D06A

	 LDA #<$2000
	 STA $D060
	 LDA #>$2000
	 STA $D061
	 LDA #<1
	 STA $D062
	 LDA #>1
	 STA $D063

	LDA	#$8F
	 STA $d06D

	lda #<74
	sta $d048
	lda #>74
	sta $d049
	lda #<553
	sta $D04A
	lda #>553
	sta $d04b

	lda #<74
	sta $d04e
	lda #>74
	sta $d04f
.else
	lda #$a5
	sta $d02f
	lda #$96
	sta $d02f

    ; enable bitplanes


	lda	#$D0	; 3.5Mhz, H640, bitplanes
	;lda	#$90	; 3.5Mhz, H640, bitplanes
	bbsf    7, graphMode, @11
	lda #$50
	;lda #$10
@11:
	sta	$d031

	lda	#$04	; 3.5Mhz, H640, bitplanes
	sta	$d030

    ; enable bitplace 1 (from 0-7)
    lda #2
    sta $d032

    ;   bitplane data @$10000
;    lda #0
;    sta $d034

    ;   bitplane data @$14000
    lda #$04
    sta $d034

    lda #$33
    sta $d102
    sta $d202
    sta $d302
    lda #$bb
    sta $d100
    sta $d200
    sta $d300
.endif

.endif

.if .defined(wheels) || .defined(removeToBASIC)
	ldx #32
@3:	lda KERNALVecTab-1,x
	sta irqvec-1,x
	dex
	bne @3
.elseif .defined(bsw128)
	jsr $FF8A ; "RESTOR" CBM KERNAL call
.else
	jsr Init_KRNLVec
.endif
.ifndef bsw128
.ifndef mega65
	LoadB CPU_DATA, RAM_64K
.endif
.endif
ASSERT_NOT_BELOW_IO
	jmp ResetMseRegion

