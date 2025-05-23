; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; C64/VIC-II sprite driver

.include "config.inc"
.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "kernal.inc"
.include "c64.inc"

; bitmask.s
.import BitMaskPow2

.import scr_mobx

.import NormalizeX
.import NormalizeY

.import UncompactXY

; syscalls
.global _DisablSprite
.global _DrawSprite
.global _EnablSprite
.global _PosSprite

.import spriteXPosOff
.import spriteYPosOff

.segment "sprites"

;---------------------------------------------------------------
; DrawSprite                                              $C1C6
;
; Pass:      r3L sprite nbr (2-7)
;            r4  ptr to picture data
; Return:    graphic data transfer to VIC chip
; Destroyed: a, y, r5
;---------------------------------------------------------------
_DrawSprite:
	ldy r3L
	lda SprTabL,Y
	sta r5L
	lda SprTabH,Y
	sta r5H
	ldy #63
@1:	lda (r4),Y
	sta (r5),Y
	dey
	bpl @1
	rts

.define SprTab spr0pic, spr1pic, spr2pic, spr3pic, spr4pic, spr5pic, spr6pic, spr7pic
SprTabL:
	.lobytes SprTab
SprTabH:
	.hibytes SprTab

;---------------------------------------------------------------
; PosSprite                                               $C1CF
;
; Pass:      r3L sprite nbr (0-7)
;            r4  x pos (0-319)
;            r5L y pos (0-199)
; Return:    r3L unchanged
; Destroyed: a, x, y, r6
;---------------------------------------------------------------
_PosSprite:
;	PushB	r5H

;	lda	r4H
;	jsr	UncompactXY
;	sta 	r4H
;	sty 	r5H

;;	jsr	_HR_PosSprite


_HR_PosSprite:

.if .defined(bsw128) || .defined(mega65)
	ldx #r4
	jsr NormalizeX
	ldy #r5L
	jsr NormalizeY
.endif
	START_IO

	lda r3L
	rol
	tay
	lda r5L
	clc
	adc spriteYPosOff
	;sta r6L
	sta mob0ypos,Y

	;lda r5H
	php
	lda	r4H
	jsr	UncompactXY
	sta	r4H
	plp
	tya
	ldy $D077
	ldx #1
	jsr @2__
	sta $D077

	lda #2
	ldy $D078
	jsr @2_
	sta $D078

.ifdef bsw128
	lda graphMode
	bpl @X
	lda r4H
	sta scr_mobx+1,y
	lsr a
	sta r4H
	lda r4L
	sta scr_mobx,y
	ror a
	sta r4L
@X:
.endif
;.ifdef mega65
	;MoveW r4, r6
	;lda graphMode
	;bpl @X
	;asr r6H
	;ror r6L
;@X:
;	AddVW    VIC_X_POS_OFF, r6
;.else
	lda r3L
	rol
	tay
	lda r4L
	clc
	adc spriteXPosOff
	;sta r6L
	sta mob0xpos,Y
	lda 	r4H
;.endif

	ldy	msbxpos
	ldx	#1

	jsr	@2__
	sta msbxpos
	lda #2
	ldy	$d05f
	jsr	@2_
	sta $d05f

	END_IO
;	PopB	r5H
	rts
@2__:
	adc #0
	sta r6H
	txa
@2_:
	ldx	r3L
	and	r6H
	beq	@2_clear
	tya
	ora BitMaskPow2,x
	rts

@2_clear:
	tya
	eor #$ff
	ora BitMaskPow2,x
	eor #$ff
	rts

;---------------------------------------------------------------
; EnablSprite                                             $C1D2
;
; Pass:      r3L sprite nbr (0-7)
; Return:    sprite activated
; Destroyed: a, x
;---------------------------------------------------------------
.ifdef wheels_size
_EnablSprite:
	sec
	bcs EnablSpriteCommon
_DisablSprite:
	clc
EnablSpriteCommon:
	START_IO
	ldx r3L
	lda BitMaskPow2,x
	bcs @1
	eor #$FF
	and mobenble
	bra @2
@1:	ora mobenble
@2:	sta mobenble
	END_IO
        rts
.else
_EnablSprite:
	ldx r3L
	lda BitMaskPow2,x
	tax
	; XXX On C128, the "tax"/"txa" is a no-op
	START_IO
	txa
	ora mobenble
	sta mobenble
	END_IO
	rts

;---------------------------------------------------------------
; DisablSprite                                            $C1D5
;
; Pass:      r3L sprite nbr (0-7)
; Return:    VIC register set to disable
;            sprite.
; Destroyed: a, x
;---------------------------------------------------------------
_DisablSprite:
	ldx r3L
	lda BitMaskPow2,x
	eor #$FF
	pha ; XXX on C128, the "pha"/"pla" is a no-op
	START_IO_X
	pla
	and mobenble
	sta mobenble
	END_IO_X
	rts
.endif
