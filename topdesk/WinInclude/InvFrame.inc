InvFrame:
	; Parameter: r2-r4   Akku: Muster
	; Zur}ck: ----
	; Zerst|rt: r0,r1,r5-r7,a,x,y
	PushW	r2
	PushW	r3
	PushW	r4
	jsr	HideOnlyMouse
	PopW	r4
	PopW	r3
	PopW	r2
	;lda	graphMode
	;bpl	@64n
	;bmi	@64n
	
	;lda 	r3H
	;and	#%00001111
	;sta	r3H
	;lda 	r4H
	;and	#%00001111
	;sta	r4H
	jsr	VLine
	PushW	r8
	PushW	r11
	PushB	r2H
	MoveB	r2L, r11L
	jsr	InvertLine
	pla
	sta	r11L
	; if r11L is the bottom end of the frame
	; r3H need to transport the msb of bottom y
	lda	r3H
	and     #%00001111
	sta	r3H
	lda 	r4H
	and     #%11110000
	ora	r3H
	sta	r3H
	jsr	InvertLine
	PopW    r11
	PopW    r8
	rts
	
VLine:
	; r2L	- vertical from
	; r2H 	- vertical to

	MoveB	r2L, r0L
	lda	r3H
	and	#%11110000
	sta     r0H

	; determ mask for r3 (r1L) and r4 (r1H)
	lda	r3L
	and	#7
	tax
	lda	Masken,x
	sta	r1L	; mask in r1L
	lda	r4L
	and	#7
	tax
	lda	Masken,x
	sta	r1H	; mask in r1L
@loop:
	lda	r0L
	pha
	lda	r0H
	lsr
	lsr
	lsr
	lsr
	asl	r0L
	rol
	asl	r0L
	rol
	asl	r0L
	rol
	asl	r0L
	rol
	asl	r0L
	rol
	tay
	pla	
	sta	r0L
	and #$07
	ora #$f8
	tax

	;ldx	r0L
	jsr	GetScanLine	 ; Card

	lda	r3L
	and	#%11111000
	clc
	adc	r5L
	sta	r6L
	lda	r3H
	and     #%00001111
	adc	r5H
	sta	r6H	; card address in r3 -> r6

	lda	r4L
	and	#%11111000
	clc
	adc	r5L
	sta	r5L
	lda	r4H
	and	#%00001111
	adc	r5H
	sta	r5H	; card address in r4 -> r5
@cardLoop:
	ldy	#0
	lda	(r6),y
	eor	r1L
	sta	(r6),y
	lda	(r5),y
	eor	r1H
	sta	(r5),y

	lda	r2H
	cmp	r0L
	beq     @end
@next:
	inc	r0L
	bne	@noover
	clc
	lda	r0H
	adc     #16
	sta     r0H
@noover:
	inc     r5L
	inc     r6L
	
	; end of card
	lda     r5L
	and     #%00000111
	bne     @cardLoop
	
	; end of card we need to advance
	; by one scan line
	bra     @loop
@end:
	lda	r4H
	and	#%11110000
	cmp     r0H
	bne     @next

	rts
	
Masken:	.byte	128,64,32,16,8,4,2,1

SetReg:	stx	$d600
@wait:	bit	$d600
	bpl	@wait
	sta	$d601
	rts
GetReg:	stx	$d600
@wait:	bit	$d600
	bpl	@wait
	lda	$d601
	rts

	