; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Graphics library: rectangles

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.import _HorizontalLine
.import _InvertLine
.import _RecoverLine
.import _VerticalLine
.import ImprintLine
.import UncompactXY
.import _NormalizeY

.global _Rectangle
.global _InvertRectangle
.global _RecoverRectangle
.global _ImprintRectangle
.global _FrameRectangle

.segment "graph2c"

;---------------------------------------------------------------
; Rectangle                                               $C124
;
; Pass:      r2L top (0-199)
;            r2H bottom (0-199)
;            r3  left (0-319)
;            r4  right (0-319)
; Return:    draws the rectangle
; Destroyed: a, x, y, r5 - r8, r11
;---------------------------------------------------------------
_Rectangle:
	PushW	r2
	PushW	r3
	PushW	r4
	;PushB	r5H

	jsr _NormRect

	MoveB r2L, r11L

@1:
	lda r11L
	and #$07
	tay
.ifdef bsw128
	PushB rcr
	and #$F0
	ora #$0A
	sta rcr
.endif
	lda (curPattern),Y
.ifdef bsw128
	tax
	PopB rcr
	txa
.endif
	jsr _HorizontalLine
	lda	r11L
	cmp r2H
	bne 	@3_

	lda	r4H
	and #$F0
	sta r5H
	lda r3H
	and #$F0
	cmp	r5H
	beq 	@3
@3_:
	;lda r11L
	inc r11L
	bne @2

	lda r3H
	add #16
	sta r3H
	;cmp	r4H
	;bcc	@3
@2:
	bra	@1

@3:
	;PopB  	r5H
rectEnd:
	PopW  	r4
	PopW	r3
	PopW	r2
	rts

;---------------------------------------------------------------
; InvertRectangle                                         $C12A
;
; Pass:      r2L top in scanlines (0-199)
;            r2H bottom in scanlines (0-199)
;            r3  left in pixels (0-319)
;            r4  right in pixels (0-319)
; Return:    r2L, r3H unchanged
; Destroyed: a, x, y, r5 - r8
;---------------------------------------------------------------
_InvertRectangle:
	PushW	r2
	PushB	r3H
	PushB	r4H
	;PushB	r5H

	jsr _NormRect

	MoveB	r2L, r11L
@1:	jsr	_InvertLine

	lda	r11L
	cmp 	r2H
	bne 	@3_
	beq	@3

	lda	r4H
	and	#$F0
	sta	r5H
	lda	r3H
	and	#$F0
	cmp	r5H
	beq 	@3
@3_:
	inc 	r11L
	bne	@2

	lda 	r3H
	add 	#16
	sta 	r3H
	;lda 	r4H
	;add 	#16
	;sta 	r4H
@2:
	bra	@1

@3:
	;PopB  	r5H
	PopB  	r4H
	PopB	r3H
	PopW	r2
	rts

.segment "graph2e"

;---------------------------------------------------------------
; RecoverRectangle                                        $C12D
;
; Pass:      r2L top (0-199)
;            r2H bottom (0-199)
;            r3  left (0-319)
;            r4  right (0-319)
; Return:    rectangle recovered from backscreen
; Destroyed: a, x, y, r5 - r8, r11
;---------------------------------------------------------------
_RecoverRectangle:
	MoveB r2L, r11L
@1:	jsr _RecoverLine
	lda r11L
	inc r11L
	cmp r2H
	bne @1
	rts

.segment "graph2g"

;---------------------------------------------------------------
; ImprintRectangle                                        $C250
;
; Pass:      r2L top (0-199)
;            r2H bottom (0-199)
;            r3  left (0-319)
;            r4  right (0-319)
; Return:    r2L, r3H unchanged
; Destroyed: a, x, y, r5 - r8, r11
;---------------------------------------------------------------
_ImprintRectangle:
	MoveB r2L, r11L
@1:	jsr ImprintLine
	lda r11L
	inc r11L
	cmp r2H
	bne @1
	rts

.segment "graph2i1"

_NormRect:
	ldx	#r3
	ldy	#r2L
	jsr 	_NormalizeY
	ldx	#r4
	ldy	#r2H
	jmp 	_NormalizeY

;---------------------------------------------------------------
; FrameRectangle                                          $C127
;
; Pass:      a   GEOS pattern
;            r2L top (0-199)
;            r2H bottom (0-199)
;            r3  left (0-319)
;            r4  right (0-319)
; Return:    r2L, r3H unchanged
; Destroyed: a, x, y, r5 - r9, r11
;---------------------------------------------------------------
_FrameRectangle:
	sta 	r9H
	
	jsr 	_NormRect
	;PushB	r5H

	PushW	r2
	PushW	r3
	PushW	r4

	ldy 	r2L
	sty 	r11L
	lda 	r9H
	jsr 	_HorizontalLine
	MoveB 	r2H, r11L
	lda	r3H
	pha
	and	#$0F
	sta	r3H
	lda	r4H
	and	#$F0
	ora	r3H
	sta	r3H
	lda 	r9H
	jsr 	_HorizontalLine
	PopB	r3H
	PushB 	r3H
	PushW 	r4
	lda	r4H
	and	#$F0
	sta	r4H
	lda	r3H
	and	#$0F
	ora	r4H
	sta	r4H
	MoveB 	r3L, r4L
	MoveB	r3H, r5L
	MoveW 	r2, r3
	lda 	r9H
	jsr 	_VerticalLine
	PopW 	r4
	pla
	sta	r5L
	lda 	r9H
	jsr 	_VerticalLine
	;PopW 	r3
	jmp	rectEnd
