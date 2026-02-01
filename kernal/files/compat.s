; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Check app compatibility

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.global CheckAppCompat
.global FetchSerial

.import SerialNumber

.segment "compat"

CheckAppCompat:
	; if we are in extended mode 
	; but app is not INCOMPATIBLE
	bit	graphMode
	bvc	@4
	lda	fileHeader+O_128_FLAGS
	lsr
	bcc	@1
	bra	@3
@4:	
	bbsf 7, graphMode, @2 ; 80 col
	bit fileHeader+O_128_FLAGS
	bpl @3 ; ok
@1:	ldx #INCOMPATIBLE
	rts
@2:	bbrf 6, fileHeader+O_128_FLAGS, @1
@3:	ldx #0
	rts

FetchSerial:
	PushW	r0
	LoadW	r0, 0
	; assue fileHeader contains file info block for application or desk accessory
	ldx	#0
@loop:
	lda	fileHeader+O_GHINFO_TXT,x
	cmp	#'@'
	beq	@check
	inx
	bne	@loop
	beq	@end
@check:
	ldy	#4
@cloop:
	jsr	@get
	bcs	@end

	asl	r0L
	rol	r0H
	asl	r0L
	rol	r0H
	asl	r0L
	rol	r0H
	asl	r0L
	rol	r0H

	ora	r0L
	sta	r0L

	dey
	bne	@cloop

	MoveW	r0, SerialNumber
@end:
	PopW	r0
	rts

@get:
	inx
	beq	@failed
	lda	fileHeader+O_GHINFO_TXT,x
	cmp	#'0'
	bcc	@failed
	cmp	#'9'+1
	bcs	@char
	sec
	sbc	#'0'
	clc
	rts
@char:
	cmp	#'A'
	bcc	@failed
	cmp	#'F'+1
	bcs	@failed
	sec
	sbc	#'A'-10
	clc
	rts

@failed:
	sec
	rts
