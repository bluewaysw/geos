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

.import screenMaxX
.import screenMaxY

.segment "graph5"

.ifdef mega65
_NormalizeY:
	lda zpage+1,x
	and #%11000000
	cmp	#%10000000
	bne	@4
	lda zpage,x
	pha

	lda zpage+1,x
	lsr
	lsr
	lsr
	lsr
	and #$03
	sta	zpage,x

	lda zpage+1,x
	and #$0F
	sta zpage+1,x

	lda screenMaxY
	sec
	sbc zpage,y
	sta zpage,y
	lda screenMaxY+1
	sbc zpage,x

	asl
	asl
	asl
	asl
	and #$30
	ora zpage+1,x
	sta zpage+1,x

	pla
	sta zpage,x
@4:
	rts

.endif

_NormalizeX:
.ifdef scalable_coords
	lda zpage+1,x
	and #%00001100
	cmp	#%00001000
	bne	@4
	lda zpage+1,x
	pha
	and #$03
	sta zpage+1,x
	lda	screenMaxX
	sec
	sbc zpage, x
	sta zpage, x
	lda screenMaxX+1
	sbc zpage+1,x
	sta zpage+1,x
	pla
	and #$F0
	ora zpage+1,x
	sta zpage+1,x
	rts
@4:
	lda zpage+1,x
	and #$F3
	sta zpage+1,x
.else
	lda zpage+1,x
	bpl @2
	rol
	bmi @4
	ror
	bbrf 7, graphMode, @1
	add #$60
	rol zpage,x
	rol
@1:	and #%00011111
	sta zpage+1,x
	rts
@2:	rol
	bpl @4
	ror
	bbrf 7, graphMode, @3
	sec
	adc #$A0
	rol zpage,x
	rol
@3:	ora #$E0
	sta zpage+1,x
@4:
.endif
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
