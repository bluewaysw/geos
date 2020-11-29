; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Graphics library: NormalizeX (480px width)

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.global _NormalizeX
.ifdef mega65
.global UncompactXY
.global _NormalizeY
.endif

.global	ColTab
.global RowTab

;.import screenMaxX
;.import screenMaxY

.segment "graph5"

.ifdef mega65

ColTab:
	.word	80, 160, 240, 320, 400, 480, 560, 639
RowTab:
	.word	50, 100, 150, 200, 250, 300, 350, 399
	
.endif

.ifdef mega65
_NormalizeY:
	bbsf 	6, graphMode, @10
	jmp 	_NormalizeX
@10:
	lda 	zpage+1,x
	bpl	@4

	lda 	zpage+1,x
	pha
	and	#$0F
	sta	zpage+1,x
	pla
	lsr
	lsr
	lsr
	and 	#$0E
	phx
	tax
		
	lda	zpage,y
	php
	lda	#0
	plp
	bpl	@positive
	dec
@positive:
	pha
	lda	RowTab,x
	clc
	adc	zpage,y
	sta	zpage, y 
	
	pla
	adc	RowTab+1,x

	asl
	asl
	asl
	asl
	;and 	#$F0
	plx
	ora 	zpage+1,x
	sta 	zpage+1,x
	
@4:
	rts

.endif

_NormalizeX:
	bbrf	6, graphMode, @10
	
	; extended mode, scalable coordinates
	lda	zpage+1,x
	and	#%00001000
	cmp	#%00001000	; from end?
	bne	@5
	
	tya	
	pha
	; scale from end
	lda	zpage+1,x
	pha

	and	#%00000111
	asl
	tay
	
	lda	#0
	bit	zpage,x
	bpl	@positiv
	dec
@positiv:
	pha
	lda	graphMode
	cmp	#$41
	bne 	@noScale

	lda	zpage, x
	asl
	bra	@noScale2
@noScale:
	lda	zpage, x
@noScale2:
	clc
	adc	ColTab, y
	sta	zpage, x

	pla
	adc	ColTab+1, y
	and	#$0F
	sta	zpage+1,x
	
	pla
	and	#$F0
	ora	zpage+1,x
	sta	zpage+1,x

	pla
	tay
	;rts

	; scale from 0 origin
@5:	rts
	
	; C128 compatible mode
@10:
	lda	zpage+1,x
	bpl	@2
	rol
	bmi	@4
	ror
	bbrf	7, graphMode, @1
	add	#$60
	rol	zpage,x
	rol
@1:	and	#%00011111
	sta	zpage+1,x
	rts
	
@2:	rol
	bpl	@4
	ror
	bbrf	7, graphMode, @3
	sec
	adc	#$A0
	rol	zpage,x
	rol
@3:	ora	#$E0
	sta	zpage+1,x
@4:
	rts

.ifdef mega65
UncompactXY:
	tax
	lsr
	lsr
	lsr
	lsr
	bit #$08
	beq @3
	ora #$F0
@3:
	tay
	txa
	and	#$0F
	bit #$08
	beq @2
	ora	#$F0
@2:
	rts
.endif
