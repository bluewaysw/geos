InvFrame:
	; Parameter: r2-r4   Akku: Muster
	; Zur}ck: ----
	; Zerst|rt: r0,r1,r5-r7,a,x,y
	jsr	VLine
	lda	#%10101010
InvHLine:	sta	r1L
	lda	r3L
	and	#%11111000
	clc
	adc	#8
	sta	r0L
	lda	r3H
	adc	#00
	sta	r0H
	lda	r4L
	and	#%11111000
	sec
	sbc	r0L
	sta	r1H
	lda	r4H
	sbc	r0H

	ldy	#3
@10:	lsr
	ror	r1H
	dey
	bne	@10

	ldx	r2L
	jsr	@15

	ldx	r2H

@15:	jsr	GetScanLine

	lda	r5L
	clc
	adc	r0L
	sta	r5L
	lda	r5H
	adc	r0H
	sta	r5H
	lda	r5L
	sec
	sbc	#8
	sta	r6L
	lda	r5H
	sbc	#0
	sta	r6H
	ldx	r1H
	ldy	#0
@20:
;XXX	lda	r5H
;XXX	bmi	@64
;XXX	jsr	a128
;XXX	jmp	@128
;XXX	rts
;XXX@64:
	lda	(r5),y
	eor	r1L
	sta	(r5),y
@128:	lda	r5L
	clc
	adc	#8
	sta	r5L
	bcc	@22
	inc	r5H
@22:	dex
	bne	@20

	ldy	#0
	lda	r3L
	and	#%00000111
	tax
	lda	@maskTab,x
	and	r1L
;XXX	ldx	r6H
;XXX	bpl	@65
;XXX	jsr	c128
;XXX	jmp	@129
;XXX@65:	
	eor	(r6),y
	sta	(r6),y
;XXX@129:
	lda	r4L
	and	#%00000111
	tax
	lda	@maskTab,x
	eor	#$ff
	and	r1L
;XXX	ldx	r5H
;XXX	bpl	@66
;XXX	jsr	d128
;XXX	rts
;XXX@66:
	eor	(r5),y
	sta	(r5),y
	rts
@maskTab:	.byte	%11111111,%01111111,%00111111,%00011111
	.byte	%00001111,%00000011,%00000001,%00000000
VLine:
	ldy	#1
@05:	lda	r2L,y
	and	#%11111000
	sta	r0L,y
	dey
	bpl	@05
	ldx	r0L
	jsr	GetScanLine	 ; Card
;XXX	lda	r5H
;XXX	bmi	@64n
;XXX	rts
;XXX@64n:
	lda	r3L
	ldy	r3H
	jsr	@07
	lda	r4L
	ldy	r4H

@07:	tax
	and	#%11111000
	clc
	adc	r5L
	sta	r6L
	tya
	adc	r5H
	sta	r6H
	txa
	and	#7
	tax
	lda	Masken,x
	sta	r1L

; Einzeichnen des oberen Restes:

	lda	r2L
	and	#7
	tay
@10:	jsr	@110
	tya
	sec
	sbc	#8
@20:	sta	r1H ; AnfangsPkt (gerade ung.)
; Mitte:
	lda	r0H
	sec
	sbc	r0L
	lsr
	lsr
	lsr
	tax	; x+1 Durchl{ufe
	dex
	beq	@50
@40:	ldy	r1H
@30:	jsr	@110
	dex
	bne	@40
	
; Rest Unten:
@50:	lda	r2H
	and	#7
	cmp	r1H
	blt	@60
	sta	r7L
	ldy	r1H
@55:	jsr	@100
	cpy	r7L
	ble @55
@60:	rts
@100:

;XXX	lda	r6H
;XXX	bpl	@64
;XXX	jsr	b128
;XXX	jmp	@128
;XXX@64:
	lda	(r6),y
	eor	r1L
	sta	(r6),y
@128:	iny
	iny
	rts
@110:	jsr	@100
	cpy	#8
	
	blt	@110
	AddVW__	320,r6
;XXX	lda	r6H
;XXX	bpl	@65
;XXX	AddVW__	320,r6

;XXX @65:
	rts
Masken:	.byte	128,64,32,16,8,4,2,1
.if 0
d128:	;eor	(r5),y
	;sta	(r5),y
	sta	@a
	PushB	r1L
	lda	@a
	sta	r1L
	jsr	a128
	PopB	r1L
	rts
@a:	.byte	0
c128:	;eor	(r6),y
	;sta	(r6),y
	sta	@a
	PushB	r1L
	lda	@a
	sta	r1L
	jsr	b128
	PopB	r1L
	rts
@a:	.byte	0
b128:	tya
	pha
	;lda	(r6),y
	tya		; Zieladr (r6+y) in Reg $12/$13 setzten
	clc
	adc	r6L
	ldx	#$13
	jsr	SetReg
	dex
	lda	r6H
	jmp	a128b
a128:	tya
	pha
	;lda	(r5),y
	tya		; Zieladr (r5+y) in Reg $12/$13 setzten
	clc
	adc	r5L
	ldx	#$13
	jsr	SetReg
	dex
	lda	r5H
a128b:	adc	#0
	jsr	SetReg
	ldx	#$1f
	jsr	GetReg	; Inhalt aus $1f holen 
	eor	r1L
	;sta	(r?),y	; Zieladr noch gesetzt !
	ldx	#$1f
	jsr	SetReg
	ldx	#$12	; Zeichen schreiben durch beliebiges Beschreiben
	jsr	SetReg	;von Reg. $12
	pla
	tax
	rts
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
.endif

	