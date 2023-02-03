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
.ifdef topdesk128
.ifndef mega65
        lda     graphMode
        bpl     @z40
        rts
.endif
@z40:
.endif

	; **** Verschiebung von r5-r7 nach r10-r12
	ldx	#5
@e10:	lda	r5L,x
	sta	r10L,x
	dex
	bpl	@e10

	; ****
        ; r13L bottom y diff
        ; r10L top y diff
        ldx     r3H
        lda     r4H
        lsr
        lsr
        lsr
        lsr
        sta     r3H
        and     #%00001000
        beq     @f4
        lda     r3H
        ora     #$F0
        sta     r3H
@f4:
        lda	r10H
	sec
	sbc	r2H
	sta	r13L
        php
	lda	r12H
        lsr
        lsr
        lsr
        lsr
        plp
	sbc	r3H
	sta	r13H
        and     #%00001000
        beq     @f1
        lda     r13H
        ora     #$F0
        sta     r13H
@f1:
        txa
        lsr
        lsr
        lsr
        lsr
        sta     r3H
        and     #%00001000
        beq     @f3
        lda     r3H
        ora     #$F0
        sta     r3H
@f3:

        lda	r10L
	sec
	sbc	r2L
	sta	r10L
        php
	lda	r11H
        lsr
        lsr
        lsr
        lsr
        plp
	sbc	r3H
	sta	r10H
        and     #%00001000
        beq     @f2
        lda     r10H
        ora     #$F0
        sta     r10H
@f2:
        stx     r3H

        PushW   r3
        PushW   r4

        lda     r11H
        bpl     @20a
        ora     #$F0
        bra     @20b
@20a:
        and     #$0F
@20b:
        sta     r11H

        lda     r12H
        bpl     @20c
        ora     #$F0
        bra     @20d
@20c:
        and     #$0F
@20d:
        sta     r12H

        lda     r3H
        bpl     @21a
        ora     #$F0
        bra     @21b
@21a:
        and     #$0F
@21b:
        sta     r3H

        lda     r4H
        bpl     @21c
        ora     #$F0
        bra     @21d
@21c:
        and     #$0F
@21d:
        sta     r4H


        ; x left/right from to diff
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
        PopW    r4
        PopW    r3

        ; div r10, r11 by steps
	LoadB	r0L,Schrw
	LoadB	r0H,0
	ldx	#r10
	ldy	#r0
@30:	jsr	DSdiv
	inx
	inx
	cpx	#r14
	bcc	@30

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

        ; advance y coordinates
        lda     r3H
        lsr
        lsr
        lsr
        lsr
        tay
        lda     r3H
        and     #$0F
        sta     r3H
        and     #%00001000
        beq     @f5
        lda     r3H
        ora     #$F0
        sta     r3H
@f5:

	lda	r2L
	clc
	adc	r10L
	sta	r2L
        tya
        adc     r10H
        asl
        asl
        asl
        asl
        ora     r3H
        sta     r3H

        lda     r4H
        lsr
        lsr
        lsr
        lsr
        tay
        lda     r4H
        and     #$0F
        sta     r4H
        and     #%00001000
        beq     @f6
        lda     r4H
        ora     #$F0
        sta     r4H
@f6:


	lda	r2H
	clc
	adc	r13L
	sta	r2H
        tya
        adc     r13H
        asl
        asl
        asl
        asl
        ora     r4H
        sta     r4H

	ldy	#2
@120:	lda	r3L,y
	clc
	adc	r11L,y
	sta	r3L,y

	lda	r3H,y
        and     #$F0
        tax
        lda	r3H,y
        bpl     @120a
        ora     #$f0
        bra     @120b
@120a:
        and     #$0F
@120b:
	adc	r11H,y
        and     #$0F
        sta	r3H,y
        txa
        ora	r3H,y
        sta     r3H,y
	dey
	dey
	bpl	@120

	lda 	dblClickCount
	bne     @w1
	LoadB   dblClickCount, 1
@w1:	lda     dblClickCount
        bne     @w1
	dec	r8L
	beq	@100a
        jmp     @100
@100a:
	rts
