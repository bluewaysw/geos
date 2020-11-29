; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Dialog box: RstrFrmDialogue and misc

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.import DialogRestore
.import dlgBoxCallerPC
.import dlgBoxCallerSP
.import RcvrMnu0
.import defIconTab
.import DialogSave
.import InitGEOEnv
.import L8871

.import FrameRectangle
.import Rectangle
.import SetPattern

.global CalcDialogCoords
.global DlgBoxPrep
.global DrawDlgBox
.global Dialog_2
.global _RstrFrmDialogue

.import MapUnderlay
.import UnmapUnderlay

.segment "dlgbox1c"

DlgBoxPrep:
.ifdef wheels_size ; Dialog_2 was folded into this
	sec
	jsr DlgBoxPrep2
	LoadB sysDBData, NULL
	jmp InitGEOEnv

Dialog_2:
	clc
DlgBoxPrep2:
	START_IO
	php
	jsr MapUnderlay
	plp
	LoadW r4, dlgBoxRamBuf
	bcc @1
	jsr DialogSave
	LoadB mobenble, 1
	bne @2
@1:	jsr DialogRestore
@2:
	jsr UnmapUnderlay
	END_IO
	rts
.else
	START_IO_128
	START_IO
	LoadW r4, dlgBoxRamBuf
	jsr MapUnderlay
	jsr DialogSave
	jsr UnmapUnderlay
	LoadB mobenble, 1
	END_IO_128
	END_IO
	jsr InitGEOEnv
	LoadB sysDBData, NULL
	rts
.endif

DrawDlgBox:

	LoadB dispBufferOn, ST_WR_FORE | ST_WRGS_FORE
	ldy #0
	lda (DBoxDesc),y
	and #%00011111
.ifdef speedupDlgBox
	bne DrwDlgSpd0
	jmp @1
DrwDlgSpd0:
	;1st: right,right+8,top+8,bottom
	;2nd: left+8,right+8,bottom,bottom+8
	jsr SetPattern
	PushW DBoxDesc
	ldy #0
	lda (DBoxDesc),y
	bpl DrwDlgSpd1
	LoadW DBoxDesc, DBDefinedPos-1
	bbrf 6, graphMode, DrwDlgSpd1
	LoadW DBoxDesc, DBDefinedPosScalable-1
DrwDlgSpd1:
	ldy #1
	lda (DBoxDesc),y
	addv 8
	sta r2L
	iny
	lda (DBoxDesc),y
	sta r2H
	iny
	iny
	iny
	lda (DBoxDesc),y
	sta r3L
	tax
	iny
	lda (DBoxDesc),y
	sta r3H
	txa
	addv 8
	sta r4L
	lda r3H
	adc #0
	sta r4H
	jsr Rectangle
	MoveB r2H, r2L
	addv 8
	sta r2H
	ldy #1+2
	lda (DBoxDesc),y
	sta r3L
	iny
	lda (DBoxDesc),y
	sta r3H
	AddVW 8, r3
	jsr Rectangle
	PopW DBoxDesc
.else
	beq @1
	jsr SetPattern
	sec
	jsr CalcDialogCoords
.if .defined(bsw128) || .defined(mega65)
	;lda r3H
	;and #$80
	;sta L8871
.endif
	jsr Rectangle
.endif
@1:

	lda #0
	jsr SetPattern
	clc
	jsr CalcDialogCoords
	bbrf 6, graphMode, @11
	lda rightMargin+1
	and #%11110000
	sta rightMargin
	lda r4H
	and #%00001111
	ora rightMargin
	sta rightMargin+1
	MoveB r4L, rightMargin
	bra @12
@11:
	MoveW r4, rightMargin
@12:
	jsr Rectangle
.ifndef wheels_size_and_speed ; redundant
	clc
	jsr CalcDialogCoords
.endif
	lda #$ff
	jsr FrameRectangle
	lda #0
	sta defIconTab
.ifndef wheels_size_and_speed ; single 0 = no icons
	sta defIconTab+1
	sta defIconTab+2
.endif
	rts

Dialog_1:
	ldy #0
	lda (DBoxDesc),y
	and #%00011111
	beq @1
	sec
	jsr @2
@1:	clc
@2:	jsr CalcDialogCoords
	jmp RcvrMnu0

CalcDialogCoords:
.ifdef speedupDlgBox
	LoadB r1H, 0
.else
	lda #0
	bcc @1
	lda #8
@1:	sta r1H
.endif
	PushW DBoxDesc
	ldy #0
	lda (DBoxDesc),y
	bpl @2c
	LoadW DBoxDesc, DBDefinedPos-1
	ldy	graphMode
	bbrf 6, graphMode, @2
	LoadW DBoxDesc, DBDefinedPosScalable-1
@2c:
	ldy	graphMode
	cpy	#$41
	bne	@2b
	ldy	#$80
	bra	@2
@2b:
	ldy	#0
@2:	sty	L8871
	ldx #0
	ldy #1
@3:	lda (DBoxDesc),y
	clc
	adc r1H
	sta r2L,x
	iny
	inx
	cpx #2
	bne @3
@4:	lda (DBoxDesc),y
	clc
	adc r1H
	sta r2L,x
	iny
	inx
	lda (DBoxDesc),y
	;bcc @5
	adc #0
@5:	sta r2L,x
	iny
	inx
	cpx #6
	bne @4
	PopW DBoxDesc
	rts

DBDefinedPos:
.if .defined(bsw128) || .defined(mega65)
MSB = DOUBLE_W
.else
MSB = 0
.endif
	.byte DEF_DB_TOP
	.byte DEF_DB_BOT
	.word MSB | DEF_DB_LEFT
	.word MSB | DEF_DB_RIGHT

DBDefinedPosScalable:
	ByteCY	%101100000000 | ((-96) & $FF), %101100000000 | ((-48) & $FF)
	ByteCY	%101100000000 | ((95) & $FF), %101100000000 | ((47) & $FF)
	WordCX 	%101100000000 | ((-96) & $FF), %101100000000 | ((-48) & $FF)
	WordCX	%101100000000 | ((95) & $FF), %101100000000 | ((47) & $FF)

_RstrFrmDialogue:
	jsr Dialog_2
	jsr Dialog_1
	MoveB sysDBData, r0L
	ldx dlgBoxCallerSP
	txs
	PushW dlgBoxCallerPC
	rts

.ifndef wheels_size ; folded into DlgBoxPrep
Dialog_2:
	START_IO_128
	START_IO
	LoadW r4, dlgBoxRamBuf
	jsr MapUnderlay
	jsr DialogRestore
	jsr UnmapUnderlay
	END_IO_128
	END_IO
	rts
.endif
