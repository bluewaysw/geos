; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Graphics library: BitmapUp syscall

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.import _GetScanLine
.ifdef bsw128
.import _TempHideMouse
; XXX wrong bank
CallNoRAMSharing = $9D80
.endif

.global BitmapUpHelp
.global BitmapDecode
.global _BitmapUp

.segment "graph3c"

;---------------------------------------------------------------
; BitmapUp                                                $C142
;
; Pass:      r0  ptr of bitmap
;            r1L x pos. in bytes (0-39)
;            r1H y pos. in scanlines (0-199)
;            r2L width in bytes (0-39)
;            r2H height in pixels (0-199)
; Return:    display the bitmap
; Destroyed: a, x, y, r0 - r9l
;---------------------------------------------------------------
_BitmapUp:
.ifdef bsw128
	jsr _TempHideMouse
	PushB rcr
	and #%11110000
	ora #%00001010
	sta rcr
.endif
	PushB r9H
	LoadB r9H, NULL
.ifndef wheels_size_and_speed
	lda #0
.endif
.if .defined(bsw128) || .defined(mega65)
	sta L888D
.endif
	sta r3L
	sta r4L

	ldx #$F8	; y high part
	bit r1L
	bpl @5
	bit r1H
	bvc @2	; not neg

	clc
	lda r1H
	ora #%10000000
	adc scrFullCardsX+1
	and #$7F
	sta r1H
	bra @2
@5:
	lda r1H
	and #$07
	ora #$F8
	tax
	lsr r1H
	lsr r1H
	lsr r1H
@2:
@1:	txa
	pha
	jsr BitmapUpHelp
	pla
	tax
	inx
	bne @4
	txa
	ora #$F8
	tax
	inc r1H
@4:
	dec r2H
	bne @1
	PopB r9H
.ifdef bsw128
	PopB rcr
.endif
	rts

BitmapUpHelp:
	ldy r1H
	jsr _GetScanLine
	MoveB r2L, r3H
.if .defined(bsw128) || .defined(mega65)
	bpl @Y
	bbsf 7, graphMode, @X
	and #$7F
	sta r3H
	bne @Y
@X:	asl r3H
@Y:
.ifndef mega65
	bbsf 7, graphMode, @4
	lda r1L
	and #$7F
	cmp #$20
.else
	ldx r5H
	ldy #0
	sty r5H

	ldy #3  ; by 8
	lda r1L
	bit r1L
	bpl @41
	bvc @41

	; x negative case
	clc
	adc scrFullCardsX
@41:
	and #$7f
	bpl @4
	bbrf 7, graphMode, @4
	ldy #4  ; by 16
@4:
    	and #$7F
@5:
	asl a
	rol r5H
	dey
	bne @5

	pha
	lda r5H
	stx r5H
	pha
	add r5H
	sta r5H
	pla
	add r6H
	sta r6H

	pla
	tay
.endif
.else
	CmpBI r1L, $20
.endif
.ifndef mega65
	bcc @1
	inc r5H
	inc r6H
@1:
	asl
	asl
	asl
.endif
	tay
@2:	sty r9L
	jsr BitmapDecode
	ldy r9L
	sta (r5),y
	sta (r6),y
	tya
	addv 8
	bcc @3
	inc r5H
	inc r6H
@3:	tay
	dec r3H
	bne @2
	rts
.ifdef bsw128
; 80 column version
.import StaBackbuffer80
.import StaFrontbuffer80
@4:	lda r1L
	bpl @5
	asl a
@5:	clc
	adc r5L
	sta r5L
	sta r6L
	bcc @6
	inc r5H
	inc r6H
@6:	jsr BitmapDecode
	jsr StaFrontbuffer80
	jsr StaBackbuffer80
	inc r6L
	inc r5L
	bne @7
	inc r6H
	inc r5H
@7:	dec r3H
	bne @6
	rts
.endif

BitmapDecode:
.if .defined(bsw128) || .defined(mega65)
   ;jmp  BitmapDecodeX
	bbrf 7, graphMode, BitmapDecodeX
	bbrf 7, r2L, BitmapDecodeX
	bbrf 0, L888D, @1
	lda L888E
	inc L888D
	rts
; this is for stretching bitmap 2x in X axis
@1:	jsr BitmapDecodeX
	sta L888E
	ldy #3
@2:	asl L888E
	php
	rol a
	plp
	rol a
	dey
	bpl @2
	pha
	ldy #$03
@3:	asl L888E
	php
	rol a
	plp
	rol a
	dey
	bpl @3
	sta L888E
	pla
	inc L888D
	rts
.endif
BitmapDecodeX:
	lda r3L
	and #%01111111
	beq @2
	bbrf 7, r3L, @1
	jsr BitmapDecode2
	dec r3L
	rts
@1:	lda r7H
	dec r3L
	rts
@2:	lda r4L
	bne @3
	bbrf 7, r9H, @3
.ifdef bsw128
	lda #r14
	jsr CallNoRAMSharing
.else
	jsr IndirectR14
.endif
@3:	jsr BitmapDecode2
	sta r3L
	cmp #$dc
	bcc @4
	sbc #$dc
	sta r7L
	sta r4H
	jsr BitmapDecode2
	subv 1
	sta r4L
	MoveW r0, r8
	bra @2
@4:	cmp #$80
	bcs BitmapDecodeX
	jsr BitmapDecode2
	sta r7H
	bra BitmapDecodeX

.ifdef wheels ; moved, but identical
IndirectR13:
	jmp (r13)

IndirectR14:
	jmp (r14)
.endif

BitmapDecode2:
	bit r9H
	bpl @1
.ifdef bsw128
	lda #r13
	jsr CallNoRAMSharing
.else
	jsr IndirectR13
.endif
@1:
.ifdef bsw128
	lda config
	ora #1
	sta config
.endif
	ldy #0
	lda (r0),y
.ifdef bsw128
	pha
	lda config
	and #$FE
	sta config
	pla
.endif
	inc r0L
	bne @2
	inc r0H
@2:	ldx r4L
	beq @3
	dec r4H
	bne @3
	ldx r8H
	stx r0H
	ldx r8L
	stx r0L
	ldx r7L
	stx r4H
	dec r4L
@3:	rts

.if (!.defined(bsw128)) && (!.defined(wheels)) ; moved
IndirectR13:
	jmp (r13)

IndirectR14:
	jmp (r14)
.endif
