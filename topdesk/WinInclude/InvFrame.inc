InvFrame:
	; Parameter: r2-r4   Akku: Muster
	; Zur}ck: ----
	; Zerst|rt: r0,r1,r5-r7,a,x,y
.ifdef topdesk128
    PushW   r2
    PushW   r3
    PushW   r4
    jsr HideOnlyMouse
    PopW    r4
    PopW    r3
    PopW    r2
    lda     graphMode
    bpl @64n
    bmi @64n
    PushW   r8
    PushW   r11
    PushB   r2H
    MoveB   r2L, r11L
    jsr InvertLine
    Pla
    sta r11L
    jsr InvertLine
    PopW    r11
    PopW    r8
    rts
@64n:
.endif
.ifdef mega65
	lda r2L
	pha
@p87:
	lda	r2H
	pha
	sub	r2L
@p85:
	cmp	#64
	bcc	@p86
	beq	@p86
	clc
	ror
	and #$FE
	jmp	@p85

@p86:
	add	r2L
	sta r2H

	pla	
	cmp	r2H
	pha
	; above?
	bcs @p89	; branch if a is above r2H
	sta	r2H
@p89:
	jsr	VLine
	pla
	cmp	r2H
	bcc	@p88
	beq	@p88

	ldx r2H
	sta	r2H
	inx
	inx
	txa
	
	sta r2L
	jmp @p87



@p88:
	pla
	sta	r2L
.else
	jsr	VLine
.endif
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

.ifdef topdesk128
.ifndef mega65
    lda graphMode
    bpl @64e
    lsr r0H
    ror r0L
    lsr r0H
    ror r0L
    lsr r0H
    ror r0L
.endif
@64e:
.endif

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
.ifdef topdesk128
.ifndef mega65
    lda graphMode
    bpl @64f
    lda r6L
    clc
    adc #7
    sta r6L
    lda r6H
    adc #0
    sta r6H
@64f:
.endif
.endif

	ldx	r1H
	ldy	#0
@20:
.ifdef topdesk128
	lda	r5H
	bmi	@64
	jsr	a128
	jmp	@128
;XXX	rts
@64:
.endif
	lda	(r5),y
	eor	r1L
	sta	(r5),y
.ifdef topdesk128
    jmp @64g
@128:
    inc r5L
    beq @64h2
    bne @22
@64g:
.else
@128:
.endif
    lda r5L
    clc
    adc #8
    sta r5L
.ifdef topdesk128
@64h:
.endif
	bcc	@22
.ifdef topdesk128
@64h2:
.endif
	inc	r5H
@22:	dex
	bne	@20

	ldy	#0
	lda	r3L
	and	#%00000111
	tax
	lda	@maskTab,x
	and	r1L
.ifdef topdesk13
	ldx	r6H
	bmi @65
.else
;XXX	bpl	@65
.endif
.ifdef topdesk128
	jsr	c128
	jmp	@129
.endif
@65:
	eor	(r6),y
	sta	(r6),y
.ifdef topdesk128
@129:
.endif
	lda	r4L
	and	#%00000111
	tax
	lda	@maskTab,x
	eor	#$ff
	and	r1L
.ifdef topdesk128
	ldx	r5H
.ifdef topdesk128
	bmi @66
.else
	bpl	@66
.endif
	jsr	d128
	rts
@66:
.endif
	eor	(r5),y
	sta	(r5),y
	rts
@maskTab:	.byte	%11111111,%01111111,%00111111,%00011111
	.byte	%00001111,%00000011,%00000001,%00000000
VLine:
	; r2L	- vertical from
	; r2H 	- vertical to

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
.ifdef topdesk128
.ifndef mega65
    bit graphMode
    bmi @g80
.endif
.endif
	and	#%11111000
.ifdef topdesk128
@07a:
.endif
	clc
	adc	r5L
	sta	r6L
	tya
	adc	r5H
	sta	r6H
.ifdef topdesk128
.ifndef mega65
    jmp @g40
@g80:
    sty r6H
    lsr r6H
    ror
    lsr r6H
    ror
    lsr r6H
    ror
    ldy r6H
    jmp @07a
@g40:
.endif
.endif
	txa
	and	#7
	tax
	lda	Masken,x
	sta	r1L

; Einzeichnen des oberen Restes:

	lda	r2L
	and	#7
.ifdef topdesk128
.ifndef mega65
    bit graphMode
    bpl @09
    pha
    tay
    iny
@loop:
    dey
    beq @08
    AddVW__ 80, r6
    jmp @loop
@08:
    pla
@09:
.endif
.endif
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
.ifdef topdesk128
	lda	r6H
;XXX	bpl	@64
    bmi @64
;XXX	jsr	b128
    jsr e128
	jmp	@128
@64:
.endif
	lda	(r6),y
	eor	r1L
	sta	(r6),y
@128:	iny
	iny
.ifdef topdesk128
.ifndef mega65
    lda graphMode
    bpl @g41
    AddVW__ 160,r6
@g41:
.endif
.endif
	rts
@110:	jsr	@100
	cpy	#8
	
	blt	@110
.ifdef topdesk128
.ifndef mega65
    lda graphMode
    bmi @g81
.endif
.endif
.ifdef mega65
    lda graphMode
    bpl @g88

	AddVW__	320,r6
@g88:
.endif
	AddVW__	320,r6
;XXX	lda	r6H
;XXX	bpl	@65
;XXX	AddVW__	320,r6

;XXX @65:
.ifdef topdesk128
@g81:
.endif
	rts
Masken:	.byte	128,64,32,16,8,4,2,1
.ifdef topdesk128
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
e128:
    MoveW_   r6, VDCMem
    tya
    pha
    ldy #0
    jsr a128x
    pla
    tay
    rts
b128:
    MoveW_   r6, VDCMem
    jmp a128x

a128:
	MoveW_   r5, VDCMem
a128x:
	tya
	pha
	txa
	pha
	DecW    VDCMem
	jsr @setadr
    IncW    VDCMem

    ldx #$1f
    jsr GetReg
    jsr GetReg
    eor r1L
    pha
    jsr @setadr
    pla
    ldx #$1f
    jsr SetReg
    ldx #$12
    jsr SetReg
    pla
    tax
    pla
    tay
    rts

@setadr:
    tya
    clc
    adc VDCMem
    php
    ldx #$13
    jsr SetReg
    dex
    plp
    lda VDCMem+1
    adc #0
    jmp SetReg

VDCMem:  .word  0
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

	