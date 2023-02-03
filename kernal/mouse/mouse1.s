; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Mouse: IsMseInRegion syscalls

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.import NormalizeX
.import NormalizeY

.global _IsMseInRegion
.global UncompactXY

.segment "mouse1"

_IsMseInRegion:
	txa
	pha
.if .defined(bsw128) || .defined(mega65)
	ldx #r3
	jsr NormalizeX
	ldy #r2L
	jsr NormalizeY	
	ldx #r4
	jsr NormalizeX
	ldy #r2H
	jsr NormalizeY	
.endif
	PushW r0

	lda r3H
	and #%11110000
	sta r0L
	lda r3H
	and #%00001111
	sta r3H
	lda r4H
	and #%11110000
	sta r0H
	lda r4H
	and #%00001111
	sta r4H

	; check y within range
	lda mouseXPos+1
	and #%11110000
	tax
	cmp r0L
	bne @6
	lda mouseYPos
	cmp r2L
@6:
	bcc @5

	txa
	cmp r0H
	bne @7
	lda mouseYPos
	cmp r2H
@7:
	beq @1
	bcs @5

	; check y within range
@1:	lda mouseXPos+1
	and #%00001111
	cmp r3H
	bne @2
	lda mouseXPos
	cmp r3L
@2:	bcc @5

	lda mouseXPos+1
	and #%00001111
	cmp r4H
	bne @3
	lda mouseXPos
	cmp r4L
@3:	beq @4
	bcs @5

@4:	jsr @9
	PopW r0
	pla
	tax
	lda #$ff
	rts
@5:	jsr @9
	PopW r0
	pla
	tax
	lda #0
	rts

@9:	lda r3H
	ora r0L
	sta r3H
	lda r4H
	ora r0H
	sta r4H
	rts
