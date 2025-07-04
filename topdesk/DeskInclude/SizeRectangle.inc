;SizeRectangle	(mod. 24.07.1990)	(mod. 24.4.91)
;Par: r0  - Zahl, die der Maximalgr|~e entspricht
;     r1  - Darzustellende Zahl
;     r2L - y-oben
;     r2H - y-unten
;     r3  - linke x-Koordinate
;     r4  - rechte x-Koordinate
;Des: r0,r1,r5-r9,r11
SizeRectangle:
	lda	#1
	jsr	SetPattern
	ldy	#5
@loop:	lda	r2L,y
	pha
	dey
	bpl	@loop
	jsr	NewRectangle
	ldy	#0
@loop2:	pla
	sta	r2L,y
	iny
	cpy	#6
	bne	@loop2
;	lda	#$ff
;	jsr	FrameRectangle
	lda	#0
	ldy	#5
@10:	sta	r5L,y
	dey
	bpl	@10

	ldx	r3H
	ldy	r4H
	txa
	lsr
	lsr
	lsr
	lsr
	sta	r3H
	tya
	lsr
	lsr
	lsr
	lsr
	sta	r4H

	lda	r2H
	sec
	sbc	r2L	; H|he ermitteln
	sta	r5L	; ->r5L
	lda	r4H
	sbc	r3H
	sta	r5H

	sty	r4H
	stx	r3H

	SubVW_	2, r5	; -2

	ldx	#r0L
	ldy	#r5L
	jsr	NewDdiv	; Max / H|he
	
	ldy	#$ff
	sty	r9H
@20:	iny
	bne	@20a
	inc	r9H
@20a:
	CmpW	r6,r1		; r1, value to set
	bge	@40
	AddW	r0,r6
	AddW	r8,r7
	CmpW	r7,r5
	blt @20
	SubW	r5,r7
	inc	r6L
	bne	@20
	inc	r6H
	bne	@20
@40:	tya
	beq	@30
	iny
	bne	 @30
	inc	r9H
@30:	sty	r9L
	SubW	r9, r5
	MoveB	r2L, r9L
	lda	r3H
	lsr
	lsr
	lsr
	lsr
	sta	r9H
	AddW	r5, r9

	lda	r9L
	sta	r2H
	lda	r4H
	and	#$0F
	sta	r4H
	lda	r9H
	asl
	asl
	asl
	asl
	ora	r4H
	sta	r4H
;	lda	r2H 
;	sec 
;	sbc	r9L 
;	sta	r2L 
;	lda	#1
;;	lda	r2H
;;	sec
;;	sbc	r2L
;;	sec
;;	sbc	r9L
;;	clc
;;	adc	r2L
	;sta	r2H

	inc	r2L
	IncW	r3
	DecW	r4
	lda	#0
	jsr	SetPattern
	jmp	NewRectangle

;NewDdiv
; behebt den Fehler von Ddiv und kann auch kleine bzw. 0
; durch gr|~ere Werte dividieren.
; Par & Ret: s. Ddiv
NewDdiv:
	lda	$01,x
	cmp	$01,y
	bne	@10
	lda	$00,x
	cmp	$00,y
@10:	bcc	@20
	jmp	Ddiv
@20:	lda	$00,x
	sta	r8L
	lda	$01,x
	sta	r8H
	lda	#0
	sta	$00,x
	sta	$01,x
	rts
