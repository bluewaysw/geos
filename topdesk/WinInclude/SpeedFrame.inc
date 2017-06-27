Schrw	=	15

;SpeedFrame
;Par: r2L  - y-oben
;     r2H  - y-unten
;     r3   - x-links
;     r4   - x-rechts
;     r10L - Ziely-oben (r5L)
;     r10H - Ziely-unten (r5H)
;     r11  - Zielx-links (r6)
;     r12  - Zielx-rechts (r7)
;Des: r0 bis r13
SpeedFrame:

	; **** Verschiebung von r5-r7 nach r10-r12
	ldx	#5
@e10:	lda	r5L,x
	sta	r10L,x
	dex
	bpl	@e10
	; ****
	ldx	#r13
	ldy	#1
@10:	lda	r10L,y
	sec
	sbc	r2L,y
	sta	$00,x
	lda	#0
	sbc	#0
	sta	$01,x
	ldx	#r10
	dey
	bpl	@10
	ldy	#2
@20:	lda	r11L,y
	sec
	sbc	r3L,y
	sta	r11L,y
	lda	r11H,y
	sbc	r3H,y
	sta	r11H,y
	dey
	dey
	bpl	@20
	LoadB	r0L,Schrw
	LoadB	r0H,0

	ldx	#r10
	ldy	#r0
@30:	jsr	DSdiv
	inx
	inx
	cpx	#r14
	bcc	@30
	MoveB	r13L,r10H
	ldx	#0
@40:	lda	r2,x
	pha
	inx
	cpx	#6
	bcc	@40
	jsr	@60
	ldx	#5
@50:	pla
	sta	r2,x
	dex
	bpl	@50
@60:	LoadB	r8L,Schrw
@100:	jsr	InvFrame
	ldy	#1
@110:	lda	r2L,y
	clc
	adc	r10L,y
	sta	r2L,y
	dey
	bpl	@110
	ldy	#2
@120:	lda	r3L,y
	clc
	adc	r11L,y
	sta	r3L,y
	lda	r3H,y
	adc	r11H,y
	sta	r3H,y
	dey
	dey
	bpl	@120
	dec	r8L
	bne	@100
	rts
