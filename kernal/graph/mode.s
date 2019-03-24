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
;.import scrFullCardsX
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
	;bit  graphMode
	;beq @1
	bbsf 7, graphMode, @_1
	jmp  @1
@_1:
	LoadW r0, VIC_IniTbl
	.assert * - VIC_IniTbl_end - VIC_IniTbl < 256, error, "VIC_IniTbl must be < 256 bytes"
	ldy #<(VIC_IniTbl_end - VIC_IniTbl)
	jsr SetVICRegs

	LDA   #80
	STA   $D058
	STA   $D05E

    	; 80 column mode, or advanced modes
	; Set bitmap mode (makes horizontal borders take effect)
	LDA   #$3B
	STA   $D011
	lda #$09
	sta $d016

	; 90 column mode, or advanced modes
	lda #$C0
    	sta $d031


	; enable sprite H640
	LDA   $D054
	ORA   #$10
	STA   $D054
	LDA #0
	sta $D076

	LDA #79
	STA $D05C
	LDA #$80
	STA $D05D

	lda	#$04	; 3.5Mhz, H640, no bitplanes
	sta	$d030

	lda cia2base
	and #%00110000
	ora #%00000101
	sta cia2base

	; Set screen ram that has 100x60 cells x 2 bytes per cell = 12,000 bytes of colour
	; information for bitmap mode.
	; First byte is foreground colour (8-bit) and second byte is background colour (also 8-bit),
	; so each 8x8 cell can still have only 2 colours, but they can be chosen from the whole
	; palette.
	LDA #<$e000
	STA $D060
	LDA #>$e000
	STA $D061
	LDA #<4
	STA $D062
	LDA #>4
	STA $D063
	; Set bitmap data to somewhere that has 100x60 x 8 = 48,000 bytes of RAM.
	; (We are using 2nd bank of 64KB for this)
	; NOTE: This can't actually be set freely (yet), but will be on 16KB boundaries.
	LDA #<$0000
	STA $D068
	LDA #>$0000
	STA $D069
	LDA #4
	STA $D06A

	LDA #$8F
	STA $d06D

	LoadW screenNextLine, 632
	LoadW screenMaxX, 639
	LoadW screenMaxY, 199
	LoadW screenCardsX, 80
	LoadB scrFullCardsX, 80
	LoadB scrFullCardsX+1, 25
	LoadB spriteXPosOff, VIC_X_POS_OFF_640
	LoadB spriteYPosOff, VIC_Y_POS_OFF_640

	LoadW	r5, 640
	jsr	InitScanLineTab
	END_IO
	rts
;    	END_IO
;    	rts
@1:
	lda graphMode
	cmp #3
	beq @12
	jmp @11
@12:
	LoadW r0, VIC_IniTbl
	.assert * - VIC_IniTbl_end - VIC_IniTbl < 256, error, "VIC_IniTbl must be < 256 bytes"
	ldy #<(VIC_IniTbl_end - VIC_IniTbl)
	jsr SetVICRegs

	LDA #39
	STA $D05C
	LDA #$80
	STA $D05D
	LDA #1
	sta $D076
	LDA   $D054
	ORA   #$10
	STA   $D054

	lda #$c9
	sta grcntrl2

	; Set bitmap mode (makes horizontal borders take effect)
	LDA   #$3B
	STA   $D011

	; 90 column mode, or advanced modes
	lda #$C8
    	sta $d031

	LDA   #90
	STA   $D058
	STA   $D05E

	lda	#$04	; 3.5Mhz, H640, no bitplanes
	sta	$d030

	lda cia2base
	and #%00110000
	ora #%00000101
	sta cia2base

	; Set screen ram that has 100x60 cells x 2 bytes per cell = 12,000 bytes of colour
	; information for bitmap mode.
	; First byte is foreground colour (8-bit) and second byte is background colour (also 8-bit),
	; so each 8x8 cell can still have only 2 colours, but they can be chosen from the whole
	; palette.
	LDA #<$e000
	STA $D060
	LDA #>$e000
	STA $D061
	LDA #<4
	STA $D062
	LDA #>4
	STA $D063
	; Set bitmap data to somewhere that has 100x60 x 8 = 48,000 bytes of RAM.
	; (We are using 2nd bank of 64KB for this)
	; NOTE: This can't actually be set freely (yet), but will be on 16KB boundaries.
	LDA #<$0000
	STA $D068
	LDA #>$0000
	STA $D069
	LDA #4
	STA $D06A

	LDA #$8F
	STA $d06D

	lda #<74
	sta $d048
	lda #>74
	sta $d049
	lda #<554
	sta $D04A
	lda #>554
	sta $d04b

	lda #<74
	sta $d04e
	lda #>74
	sta $d04f

	LoadW screenNextLine, 712
	LoadW screenMaxX, 719
	LoadW screenMaxY, 479
	LoadW screenCardsX, 90
	LoadB scrFullCardsX, 90
	LoadB scrFullCardsX+1, 60
	LoadB spriteXPosOff, VIC_X_POS_OFF_720
	LoadB spriteYPosOff, VIC_Y_POS_OFF_720

	LoadW	r5, 720
	jsr	InitScanLineTab
	END_IO
	rts
@11:
	lda graphMode
	cmp #5
	beq @13
	jmp @14
@13:
	LoadW r0, VIC_IniTbl
	.assert * - VIC_IniTbl_end - VIC_IniTbl < 256, error, "VIC_IniTbl must be < 256 bytes"
	ldy #<(VIC_IniTbl_end - VIC_IniTbl)
	jsr SetVICRegs

	LDA #20
	STA $D05C
	LDA #$80
	STA $D05D
	LDA #1
	sta $D076
	LDA   $D054
	ORA   #$10
	STA   $D054

	lda #$c9
	sta grcntrl2

	; Set bitmap mode (makes horizontal borders take effect)
	LDA   #$3B
	STA   $D011

	; 90 column mode, or advanced modes
	lda #$C8
    	sta $d031

	LDA   #94
	STA   $D058
	STA   $D05E

	lda	#$04	; 3.5Mhz, H640, no bitplanes
	sta	$d030

	lda cia2base
	and #%00110000
	ora #%00000101
	sta cia2base

	; Set screen ram that has 100x60 cells x 2 bytes per cell = 12,000 bytes of colour
	; information for bitmap mode.
	; First byte is foreground colour (8-bit) and second byte is background colour (also 8-bit),
	; so each 8x8 cell can still have only 2 colours, but they can be chosen from the whole
	; palette.
	LDA #<$e000
	STA $D060
	LDA #>$e000
	STA $D061
	LDA #<4
	STA $D062
	LDA #>4
	STA $D063
	; Set bitmap data to somewhere that has 100x60 x 8 = 48,000 bytes of RAM.
	; (We are using 2nd bank of 64KB for this)
	; NOTE: This can't actually be set freely (yet), but will be on 16KB boundaries.
	LDA #<$0000
	STA $D068
	LDA #>$0000
	STA $D069
	LDA #4
	STA $D06A

	LDA #$8F
	STA $d06D

	lda #<11
	sta $d048
	lda #>11
	sta $d049
	lda #<604
	sta $D04A
	lda #>604
	sta $d04b

	lda #<11
	sta $d04e
	lda #>11
	sta $d04f

	LoadW screenNextLine, 744
	LoadW screenMaxX, 751
	LoadW screenMaxY, 588
	LoadW screenCardsX, 94
	LoadB scrFullCardsX, 94
	LoadB scrFullCardsX+1, 74
	LoadB spriteXPosOff, VIC_X_POS_OFF_800
	LoadB spriteYPosOff, VIC_Y_POS_OFF_800

	LoadW	r5, 752
	jsr	InitScanLineTab
	END_IO
	rts


@14:
	; 40 column compatibility mode
    	lda #$40
    	sta $d031

	jsr i_FillRam
	.word 1000
	.word COLOR_MATRIX
	.byte (DKGREY << 4)+LTGREY

	LoadW screenNextLine, 312
	LoadW screenMaxX, 319
	LoadW screenMaxY, 199
	LoadW screenCardsX, 40
	LoadB scrFullCardsX, 40
	LoadB scrFullCardsX+1, 25
	LoadB spriteXPosOff, VIC_X_POS_OFF
	LoadB spriteYPosOff, VIC_Y_POS_OFF
	LoadW r0, VIC_IniTbl
.assert * - VIC_IniTbl_end - VIC_IniTbl < 256, error, "VIC_IniTbl must be < 256 bytes"
	ldy #<(VIC_IniTbl_end - VIC_IniTbl)
	jsr SetVICRegs

	LDA #80
	STA $D05C
	LDA #$80
	STA $D05D
	LDA #0
	sta $D076

	lda #%00111011
	sta $d011
	;lda #$38
	;sta $d018
	;lda #$08
	;sta $d016

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


	LDA #<$0000
	STA $D068
	LDA #>$0000
	STA $D069
	LDA #4
	STA $D06A

	LDA #<$8c00
	STA $D060
	LDA #>$8c00
	STA $D061
	LDA #0
	STA $D062

	LDA   #40
	STA   $D058
	STA   $D05E

	; disable sprite H640
	LDA   $D054
	AND   #$EF
	STA   $D054

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
