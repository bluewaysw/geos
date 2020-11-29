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
.global _GetRealSize

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

;.import screenMaxX
;.import screenMaxY
.import screenCardsX
;.import scrFullCardsX
.import spriteXPosOff
.import spriteYPosOff
.import screenNextLine
.import PrvCharWidth

.import i_MoveData
.import ColTab
.import RowTab

.global SetRightMargin
_SetNewMode:
        jsr SetNewMode0
	jmp SetRightMargin
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


	lda 	$d031
	;bit 	graphMode
	;beq 	@1
	bbsf 	7, graphMode, @_1
	jmp  	@1
@_1:
	
	lda	#1		; init 80 col
	jsr 	InitVideoMode

	END_IO
	rts
@1:
	lda	graphMode
	cmp	#3|64		; high res mode
	beq	@12
        cmp	#1|64
	bne	@11b
	jmp	@_1
@11b:
        jmp 	@11
@12:
	lda	#2
	jsr 	InitVideoMode
	END_IO
	rts
@11:
	lda	graphMode
	cmp	#5|64
	beq	@13
        cmp	#8|64
	beq	@13
	jmp 	@14
@13:
	lda	#3		; super res
	jsr 	InitVideoMode
	END_IO
	rts

@14:
	lda	#0
	jsr	InitVideoMode
    	END_IO
    	rts
.endif

SetRightMargin:
.ifdef bsw128
	lda #0
.endif
	lda screenMaxX
	sta rightMargin
	lda screenMaxY+1
	asl
	asl
	asl
	asl
	ora screenMaxX+1
	sta rightMargin+1
	lda screenMaxY
        sta windowBottom

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
	;stx rightMargin+1
	;sty rightMargin
	jmp UseSystemFont

.ifdef mega65

InitVideoMode:
	pha

	LoadW 	r0, VIC_IniTbl
	.assert * - VIC_IniTbl_end - VIC_IniTbl < 256, error, "VIC_IniTbl must be < 256 bytes"
	ldy 	#<(VIC_IniTbl_end - VIC_IniTbl)
	jsr 	SetVICRegs

	pla
	tax
	asl
	tay

	LDA   	vmiSideBorder, y
	STA	$D05C	; width of side border
	LDA   	vmiSideBorder+1, y
	STA	$D05D	; bit 7 enable VICII hot register, bit 6 raster delay

	lda	vmiD030, x	
	sta	$d030

	; 80 column mode, or advanced modes
	; Set bitmap mode (makes horizontal borders take effect)
	LDA   	vmiD011, x
	STA   	$D011
	LDA   	vmiD016, x
	sta 	$d016

	LDA   	vmiFullCardsY, X
	sta     $d07b

	LDA   	vmiCardsX, X
	STA   	$D058	; characters per logical text row
	STA  	$D05E	; Number of characters to diplay per row

	; 90 column mode, or advanced modes
	lda	vmiD031,x 
	sta	$d031

	LDA 	#0
	STA 	$D05D		; reset hot registers,
				; so that other reg acces doesn't reset
				; everything

	; enable sprite H640
	LDA   	$D054
	ORA   	vmiSpriteH640_OR, x
	and   	vmiSpriteH640_AND, x
	STA   	$D054

	lda   	vmiSpriteV400, x
	sta 	$D076

	lda	#0
	sta	$D059

	lda 	cia2base
	and 	#%00110000
	ora 	#%00000101
	sta 	cia2base

	; Set screen ram that has 100x60 cells x 2 bytes per cell = 12,000 bytes of colour
	; information for bitmap mode.
	; First byte is foreground colour (8-bit) and second byte is background colour (also 8-bit),
	; so each 8x8 cell can still have only 2 colours, but they can be chosen from the whole
	; palette.
	LDA 	vmiColorRAMOffset, y
	STA 	$D060
	LDA 	vmiColorRAMOffset+1 , y
	STA 	$D061
	LDA 	vmiColorRAMBank,y
	STA 	$D062
	LDA 	vmiColorRAMBank+1,y
	STA 	$D063

	; Set bitmap data to somewhere that has 100x60 x 8 = 48,000 bytes of RAM.
	; (We are using 2nd bank of 64KB for this)
	; NOTE: This can't actually be set freely (yet), but will be on 16KB boundaries.
	LDA 	vmiBitmapRAMOffset, y
	STA 	$D068
	LDA 	vmiBitmapRAMOffset+1, y
	STA 	$D069
	LDA 	vmiBitmapRAMBank,x
	STA 	$D06A

	lda	vmiSpritePtrAddr, x
	STA 	$d06D

	lda	vmiNextLine, y
	sta	screenNextLine
	lda	vmiNextLine+1, y
	sta	screenNextLine+1

	lda	vmiMaxX, y
	sta	screenMaxX
	lda	vmiMaxX+1, y
	sta	screenMaxX+1

	lda	vmiMaxY, y
	sta	screenMaxY
	lda	vmiMaxY+1, y
	sta	screenMaxY+1

	lda	vmiCardsX, y
	sta	screenCardsX
	lda	vmiCardsX+1, y
	sta	screenCardsX+1

	lda	vmiFullCardsX, x
	sta	scrFullCardsX
	lda	vmiFullCardsY, x
	sta	scrFullCardsX+1

	lda	vmiSpriteXPosOff, x
	sta	spriteXPosOff
	lda	vmiSpriteYPosOff, x
	sta	spriteYPosOff

	lda 	vmiTopBorder, y
	sta 	$d048
	sta	$d04e
	lda 	vmiTopBorder+1, y
	sta 	$d049
	sta	$d04f
	lda 	vmiBottomBorder, y
	sta 	$D04A
	lda 	vmiBottomBorder+1, y
	sta 	$D04B
	
	lda	screenCols, y
	sta	@colSrc
	lda	screenCols+1, y
	sta	@colSrc+1	

	lda	screenRows, y
	sta	@rowSrc
	lda	screenRows+1, y
	sta	@rowSrc+1
	
	LDA 	#0
	STA 	$D05D		; reset hot registers,
				; so that other reg acces doesn't reset
				; everything

				LDA   	vmiCardsX, Y
				STA   	$D058	; characters per logical text row
				STA  	$D05E	; Number of characters to diplay per row
				LDA   	vmiCardsX+1, Y
				STA	$d059
				LDA   	vmiFullCardsY, X
				sta     $d07b

	lda	vmiScanLineLen, y
	sta 	r5L
	lda	vmiScanLineLen+1, y
	sta 	r5H
	jsr	InitScanLineTab

	jsr	i_MoveData
@colSrc:	
	.word	0
	.word	ColTab
	.word	16
	
	jsr	i_MoveData
@rowSrc:	
	.word	0
	.word	RowTab
	.word	16

	rts

;
;       Video Modes init table
;

;       
;		320x200x2	640x200x2	640x400x2	720xYx2(dyn)
;		(320x200x256)	(640x200x16)	(640x400x4)
vmiScanLineLen:  
	.word	320,		640,		640,		720
vmiNextLine:
	.word	312,		632,		632,		712
vmiMaxX:
	.word	319,		639,		639,		719
vmiMaxY:
	.word	199,		199,		399,		568
vmiCardsX:
	.word	40,		80,		80,		90
vmiFullCardsX:
	.byte	40,		40,		80,		90
vmiFullCardsY:
	.byte	25,		25,		50,		71
vmiSpriteXPosOff:
	.byte	24,		79,		79,		38
vmiSpriteYPosOff:
	.byte	50,		50,		104,		17
vmiD011:
	.byte	%00111011,	$3B,		$3B,		$3b
vmiD016:
	.byte	$09,		$09,		$09,		$09
vmiSideBorder:
	.word	78 | $8000,	80 | $8000,	80 | $8000,	39 | $8000
vmiD031:
	.byte	$40,		$C0,		$C8,		$C8
vmiSpriteH640_OR:
	.byte	$00,		$10,		$10,		$10
vmiSpriteH640_AND:
	.byte	$EF,		$FF,		$FF,		$FF
vmiSpriteV400:
	.byte	0,		$00,		$FF,		$FF
vmiD030:		; 3.5Mhz, H640, no bitplanes
	.byte	$04,		$04,		$04,		$04
vmiSpritePtrAddr:
	.byte	$8F,		$8F,		$8F,		$8F
vmiColorRAMOffset:
	.word	$8c00,		$e000,		$e000,		$e000
vmiColorRAMBank:
	.word	0,		4,		4,		4
vmiBitmapRAMOffset:
	.word	$0000,		$0000,		$0000,		$0000
vmiBitmapRAMBank:
	.byte	4,		4,		4,		4
		;104
		;504
vmiTopBorder:
	.word	104,		104,		104,		17
vmiBottomBorder:
	.word	504,		504,		504,		586
screenCols:
	.word	Col320, 	Col640,		Col640,		Col720
screenRows:
	.word	Row200,		Row200,		Row400,		Row569

Col720:
	.word	90, 180, 270, 360, 450, 540, 630, 719
Col640:
	.word	80, 160, 240, 320, 400, 480, 560, 639
Col320:
	.word	40, 80, 120, 160, 200, 240, 280, 319
Row200:
	.word	25, 50, 75, 100, 125, 150, 175, 199
Row400:
	.word	50, 100, 150, 200, 250, 300, 350, 399
Row569:
	.word	71, 142, 213, 284, 355, 426, 497, 568


.endif

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

;---------------------------------------------------------------
; GetRealSize                                             $C1B1
;
; Function:  Returns the size of a character in the current
;            mode (bold, italic...) and current Font.
;
; Pass:      a   ASCII character
;            x   currentMode
; Return:    y   character width
;            x   character height
;            a   baseline offset
; Destroyed: nothing
;---------------------------------------------------------------

.ifndef wheels ; moved
.ifdef mega65

GetChWdth2:
	cmp #$5f
.ifdef bsw128 ; branch taken/not taken optimization
	beq @2
.else
	bne @1
	lda PrvCharWidth
	rts
@1:
.endif
        asl
        tay
        iny
        iny
.ifdef mega65
        PushB	CPU_DATA
        LoadB	CPU_DATA, RAM_64K
.endif
        lda (curIndexTable),y
        dey
        dey
        sec
        sbc (curIndexTable),y
.ifdef mega65
        tay
        PopB	CPU_DATA
        tya
.endif
        rts
.ifdef bsw128 ; branch taken/not taken optimization
@2:	lda PrvCharWidth
        rts
.endif

_GetRealSize:
	subv 32
_GetRealSize2:
	jsr GetChWdth2
	tay
	txa
.ifndef bsw128
	ldx curHeight
	pha
.endif
	and #$40
	beq @1
	iny
@1:
.ifdef bsw128
	txa
.else
	pla
.endif
	and #8
.ifdef bsw128
	bne @2
	ldx curHeight
	lda baselineOffset
	rts
@2:	ldx curHeight
	inx
	inx
	iny
	iny
	lda baselineOffset
	addv 2
	rts
.else
	beq @2
	inx
	inx
	iny
	iny
	lda baselineOffset
	addv 2
	rts
@2:	lda baselineOffset
	rts
.endif ; bsw128
.endif
.endif
