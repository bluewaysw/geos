; Makrodefinitionen
; Revision 28.06.89

:LoadB	m
	lda	#@1
	sta	@0
	/

:LoadW	m
	lda	#<@1
	sta	@0
	lda	#>@1
	sta	@0+1
	/

:MoveB	m
	lda	@0
	sta	@1
	/

:MoveW	m
	lda	@0
	sta	@1
	lda	@0+1
	sta	@1+1
	/

:add	m
	clc
	adc	#@0
	/

:adda	m
	clc
	adc	@0
	/

:AddB	m
	clc
	lda	@0
	adc	@1
	sta	@1
	/

:AddW	m
	lda	@0
	clc
	adc	@1
	sta	@1
	lda	@0+1
	adc	@1+1
	sta	@1+1
	/

:AddVB	m
	lda	@1
	clc
	adc	#@0
	sta	@1
	/

:AddVW	m
	lda	#<@0
	clc
	adc	@1
	sta	@1
	lda	#>@0
	adc	@1+1
	sta	@1+1
	/

:sub	m
	sec
	sbc	#@0
	/

:suba	m
	sec
	sbc	@0
	/

:SubB	m
	sec
	lda	@1
	sbc	@0
	sta	@1
	/

:SubW	m
	lda	@1
	sec
	sbc	@0
	sta	@1
	lda	@1+1
	sbc	@0+1
	sta	@1+1
	/

:SubVB	m
	sec
	lda	@1
	sbc	#@0
	sta	@1
	/

:SubVW	m
	lda	@1
	sec
	sbc	#<@0
	sta	@1
	lda	@1+1
	sbc	#>@0
	sta	@1+1
	/

:CmpB	m
	lda	@0
	cmp	@1
	/

:CmpBI	m
	lda	@0
	cmp	#@1
	/

:CmpW	m
	lda	@0+1
	cmp	@1+1
	bne	:ende
	lda	@0
	cmp	@1
::ende
	/


:CmpWI	m
	lda	@0+1
	cmp	#>@1
	bne	:ende1
	lda	@0
	cmp	#<@1
::ende1
	/

:PushB	m
	lda	@0
	pha
	/

:PushW	m
	lda	@0+1
	pha
	lda	@0
	pha
	/


:PopB	m
	pla
	sta	@0
	/

:PopW	m
	pla
	sta	@0
	pla
	sta	@0+1
	/

:bra	m
	clv
	bvc	@0
	/

:bge	m
	bcs	@0
	/

:bgt	m
	beq	:done
	bcs	@0
::done
	/

:blt	m
	bcc	@0
	/

:ble	m
	beq	@0
	bcc	@0
	/

:sbn	m
	ora	#2^@0
	/

:sbBn	m
	lda	@0
	ora	#2^@1
	sta	@0
	/

:sbWn	m
	lda	@0
	ora	#<2^@1
	sta	@0
	lda	@0+1
	ora	#>2^@1
	sta	@0+1
	/

:cbn	m
	and	#$ff-2^@0
	/

:cbBn	m
	lda	@0
	and	#$ff-2^@1
	sta	@0
	/

:cbWn	m
	lda	@0
	and	#<$ffff-2^@1
	sta	@0
	lda	@0+1
	and	#>$ffff-2^@1
	sta	@0+1
	/

:roln	m
	ldx	#@0
	beq	:done
::10	rol
	dex
	bne	:10
::done
	/

:rolBn	m
	ldx	#@1
	beq	:done
::10	rol	@0
	dex
	bne	:10
::done
	/

:rolWn	m
	ldx	#@1
	beq	:done
::10	rol	@0
	rol	@0+1
	dex
	bne	:10
::done
	/

:rorn	m
	ldx	#@0
	beq	:done
::10	ror
	dex
	bne	:10
::done
	/

:rorBn	m
	ldx	#@1
	beq	:done
::10	ror	@0
	dex
	bne	:10
::done
	/

:rorWn	m
	ldx	#@1
	beq	:done
::10	ror	@0+1
	ror	@0
	dex
	bne	:10
::done
	/

:asln	m
	ldx	#@0
	beq	:done
::10	asl
	dex
	bne	:10
::done
	/

:aslBn	m
	ldx	#@1
	beq	:done
::10	asl	@0
	dex
	bne	:10
::done
	/

:aslWn	m
	ldx	#@1
	beq	:done
::10	asl	@0
	rol	@0+1
	dex
	bne	:10
::done
	/

:lsrn	m
	ldx	#@0
	beq	:done
::10	lsr
	dex
	bne	:10
::done
	/


:lsrBn	m
	ldx	#@1
	beq	:done
::10	lsr	@0
	dex
	bne	:10
::done
	/

:lsrWn	m
	ldx	#@1
	beq	:done
::10	lsr	@0+1
	ror	@0
	dex
	bne	:10
::done
	/


