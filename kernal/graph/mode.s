; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; C128 graphics mode switching

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.import UseSystemFont
.ifndef mega65
.import SetColorMode
.endif

.global _GraphicsString
.global SetNewMode0
.global i_FillRam

.segment "mode"

.ifndef mega65
.import SetVDCRegister
.endif
.global _SetNewMode
.ifdef mega65
.global InitScanLineTab
.import LineTabL
.import LineTabH
.import VIC_IniTbl
.import VIC_IniTbl_end
.import SetVICRegs
.endif

.import screenMaxX
.import screenMaxY
.import screenCardsX
.import spriteXPosOff
.import spriteYPosOff
.import screenNextLine

.global SetRightMargin
_SetNewMode:
	jsr SetRightMargin
SetNewMode0:
.ifdef bsw128
	lda grcntrl1
	bbrf 7, graphMode, @1
	and #%01101111
	sta grcntrl1
	lda vdcClrMode
	jmp SetColorMode
@1:	ora #%00010000
	and #%01111111
	sta grcntrl1
	ldx #26
	lda #0
	jsr SetVDCRegister
	dex
	lda #$80
	jmp SetVDCRegister
.else
	START_IO
	lda $d031
	bbrf 7, graphMode, @1

    	; 80 column mode, or advanced modes
;    	ora #%10000000
    	;sta $d031
;    	END_IO
;    	rts
@1:
	
	; 40 column compatibility mode
    	and #%01010111
    	sta $d031
	
	jsr i_FillRam
	.word 1000
	.word COLOR_MATRIX
	.byte (DKGREY << 4)+LTGREY

	LoadW screenNextLine, 312
	LoadW screenMaxX, 319
	LoadW screenMaxY, 199
	LoadW screenCardsX, 40
	LoadB spriteXPosOff, VIC_X_POS_OFF
	LoadB spriteYPosOff, VIC_Y_POS_OFF
	LoadW r0, VIC_IniTbl
.assert * - VIC_IniTbl_end - VIC_IniTbl < 256, error, "VIC_IniTbl must be < 256 bytes"
	ldy #<(VIC_IniTbl_end - VIC_IniTbl)	
	jsr SetVICRegs
	
	LDA #79
	STA $D05C
	LDA #$00
	STA $D05D
	LDA #0
	sta $D076

	lda #%00111000
	sta $d011
	lda #$38
	sta $d018
	lda #$08
	sta $d016
	
	lda	#$04	; 3.5Mhz, H640, no bitplanes
	sta	$d030

	lda cia2base
	and #%00110000
	ora #%00000101
	sta cia2base
		
	LDA	#$8F
	 STA $d06D
		
	lda #<104
	sta $d048
	lda #>104
	sta $d049
	lda #<504
	sta $D04A
	lda #>504
	sta $d04b
	
	
	LDA #<$4000
	STA $D068
	LDA #>$4000
	STA $D069
	LDA #1
	STA $D06A

	LDA #<$8c00
	STA $D060
	LDA #>$8c00
	STA $D061
	LDA #0
	STA $D062
	
	;LDA   #40
	;STA   $D058
	;STA   $D05E	
	LoadW	r5, 320
	jsr	InitScanLineTab
	
    	END_IO
    	rts
.endif

SetRightMargin:
.ifdef bsw128
	lda #0
.endif
	ldx #>(SC_PIX_WIDTH-1)
	ldy #<(SC_PIX_WIDTH-1)
	bbrf 7, graphMode, @1
	;LoadB L8890, $ff
.ifdef bsw128
	;lda #1
.endif
	;ldx #>(SCREENPIXELWIDTH-1)
	;ldy #<(SCREENPIXELWIDTH-1)
@1:
.ifdef bsw128
	sta clkreg  ; D030
.endif
	stx rightMargin+1
	sty rightMargin
	jmp UseSystemFont

.ifdef mega65

;---------------------------------------------------------------
; InitScanLineTab                                             
;
; Function:  Inits the scan line tab for given scan line 
;            size.
;
; Pass:      r5  scanline size
; Destroyed: a, x
;---------------------------------------------------------------
InitScanLineTab:

	PushB	CPU_DATA
	LoadB	CPU_DATA, RAM_64K

	ldx	#0
	txa
	sta LineTabL, X
	sta LineTabH, x
@1:
	clc
	lda	LineTabL,X
	add r5L
	sta LineTabL+1,X
	lda	LineTabH,X
	adc r5H
	sta LineTabH+1,X
	inx
	cpx		#127
	bne		@1

	PopB	CPU_DATA

	rts
.endif
	