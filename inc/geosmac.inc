; GEOS macros
; reassembled for 6502TASM/MMS by Maciej 'YTM/Alliance' Witkowiak

.include "config.inc"

.macro LoadB dest, value
	lda #value
	sta dest
.endmacro

.macro LoadW dest, value
	LoadB dest+1, >(value)
	.if (.not .const(value)) .or (>(value))<>(<(value))
	lda #<(value)
	.endif
	sta dest+0
.endmacro

.macro LoadW_ dest, value
	LoadB dest+0, <(value)
	.if (.not .const(value)) .or (>(value))<>(<(value))
	lda #>(value)
	.endif
	sta dest+1
.endmacro

.macro LoadW__ dest, value
	LoadB dest+1, >(value)
	LoadB dest+0, <(value)
.endmacro

.macro LoadW___ dest, value
	LoadB dest+0, <(value)
	LoadB dest+1, >(value)
.endmacro

.macro MoveB source, dest
	lda source
	sta dest
.endmacro

.macro MoveW source, dest
	MoveB source+1, dest+1
	MoveB source+0, dest+0
.endmacro

.macro MoveW_ source, dest
	MoveB source+0, dest+0
	MoveB source+1, dest+1
.endmacro

.macro add source
	clc
	adc source
.endmacro

.macro AddB source, dest
	lda source
	add dest
	sta dest
.endmacro

.macro AddB_ source, dest
	clc
	lda source
	adc dest
	sta dest
.endmacro

.macro AddW source, dest
	AddB source+0, dest+0
	lda source+1
	adc dest+1
	sta dest+1
.endmacro

.macro AddVB value, dest
	lda dest
	clc
	adc #value
	sta dest
.endmacro

.macro AddVW value, dest
	.local @j
	clc
	lda #<(value)
	adc dest
	sta dest
	.if (>(value))=0
	bcc @j
	inc dest+1
@j:
	.else
	lda #>(value)
	adc dest + 1
	sta dest + 1
	.endif
.endmacro

.macro AddVW_ value, dest
	.local j
	lda dest
	clc
	adc #<(value)
	sta dest
	.if (>(value))=0
	bcc j
	inc dest+1
	j:
	.else
	lda #>(value)
	adc dest + 1
	sta dest + 1
	.endif
.endmacro

.macro AddVW__ value, dest
	lda #<(value)
	clc
	adc dest
	sta dest
	lda #>(value)
	adc dest + 1
	sta dest + 1
.endmacro

.macro sub source
	sec
	sbc source
.endmacro

.macro SubB source, dest
	lda dest
	sub source
	sta dest
.endmacro

.macro SubW source, dest
	SubB source+0, dest+0
	lda dest+1
	sbc source+1
	sta dest+1
.endmacro

.macro SubVW value, dest
	sec
	lda dest+0
	sbc #<(value)
	sta dest+0
	lda dest+1
	sbc #>(value)
	sta dest+1
.endmacro

.macro SubVW_ value, dest
	lda dest+0
	sec
	sbc #<(value)
	sta dest+0
	lda dest+1
	sbc #>(value)
	sta dest+1
.endmacro

.macro CmpB source, dest
	lda source
	cmp dest
.endmacro

.macro CmpBI source, immed
	lda source
	cmp #immed
.endmacro

.macro CmpW source, dest
	.local @j
	CmpB source+1, dest+1
	bne @j
	CmpB source+0, dest+0
@j:
.endmacro
	
.macro CmpWI source, immed
	.local @j
	CmpBI source+1, >(immed)
	bne @j
	CmpBI source+0, <(immed)
@j:
.endmacro

.macro PushB source
	lda source
	pha
.endmacro

.macro PushW source
	PushB source+1
	PushB source+0
.endmacro

.macro PopB dest
	pla
	sta dest
.endmacro

.macro PopW dest
	PopB dest+0
	PopB dest+1
.endmacro

.ifndef mega65
.macro bra addr
	clv
	bvc addr
.endmacro
.endif

.macro bra_ addr
	clv
	bvc addr
.endmacro

.macro smb bitN, dest
	pha
	lda #1 << bitN
	ora dest
	sta dest
	pla
.endmacro

.macro smbf bitN, dest
	lda #1 << bitN
	ora dest
	sta dest
.endmacro

.macro smbf_ bitN, dest
	lda dest
	ora #1 << bitN
	sta dest
.endmacro

.macro rmb bitN, dest
	pha
	lda #(1 << bitN) ^ $ff
	and dest
	sta dest
	pla
.endmacro

.macro rmbf bitN, dest
	lda #(1 << bitN) ^ $ff
	and dest
	sta dest
.endmacro

.macro bbs bitN, source, addr
	.local @j
	php
	pha
	lda source
	and #1 << bitN
	beq @j
	pla
	plp
	bra addr
@j:
	pla
	plp
.endmacro

.macro bbsf bitN, source, addr
	.if (bitN = 7)
		bit source
		bmi addr
	.else
		.if (bitN = 6)
			bit source
			bvs addr
		.else
			lda source
			and #1 << bitN
			bne addr
		.endif
	.endif
.endmacro

.macro bbr bitN, source, addr
	.local @j
	php
	pha
	lda source
	and #1 << bitN
	bne @j
	pla
	plp
	bra addr
@j:
	pla
	plp
.endmacro

.macro bbrf bitN, source, addr
	.if (bitN = 7)
		bit source
		bpl addr
	.else
		.if (bitN = 6)
			bit source
			bvc addr
		.else
			lda source
			and #1 << bitN
			beq addr
		.endif
	.endif
.endmacro

; not part of original macro set
; by Maciej Witkowiak

.macro addv value
	clc
	adc #value
.endmacro

.macro subv value
	sec
	sbc #value
.endmacro

.macro bnex addr
	txa
	bne addr
.endmacro

.macro beqx addr
	txa
	beq addr
.endmacro

.macro IncW addr
	.local @j
	inc addr
	bne @j
	inc addr+1
	@j:
.endmacro


.macro ASSERT_NOT_BELOW_IO
	.assert * < $D000 || * >= $E000, error, "This code can't run below the C64 I/O area."
.endmacro

.ifdef bsw128
.macro START_IO
.endmacro
.macro END_IO
.endmacro
.macro START_IO_X
.endmacro
.macro END_IO_X
.endmacro
.macro START_IO_Y
.endmacro
.macro END_IO_Y
.endmacro
.macro START_IO_128
	PushB config
	LoadB config, CIOIN
.endmacro
.macro END_IO_128
	PopB config
.endmacro
.else
.ifdef mega65
.macro START_IO
.endmacro
.macro END_IO
.endmacro
.macro START_IO_X
.endmacro
.macro END_IO_X
.endmacro
.macro START_IO_Y
.endmacro
.macro END_IO_Y
.endmacro
.macro START_IO_128
.endmacro
.macro END_IO_128
.endmacro
.else
.macro START_IO
	PushB CPU_DATA
ASSERT_NOT_BELOW_IO
	LoadB CPU_DATA, IO_IN
.endmacro
.macro END_IO
	PopB CPU_DATA
ASSERT_NOT_BELOW_IO
.endmacro
.macro START_IO_X
	ldx CPU_DATA
ASSERT_NOT_BELOW_IO
	LoadB CPU_DATA, IO_IN
.endmacro
.macro END_IO_X
	stx CPU_DATA
ASSERT_NOT_BELOW_IO
.endmacro
.macro START_IO_Y
	ldy CPU_DATA
ASSERT_NOT_BELOW_IO
	LoadB CPU_DATA, IO_IN
.endmacro
.macro END_IO_Y
	sty CPU_DATA
ASSERT_NOT_BELOW_IO
.endmacro
.macro START_IO_128
.endmacro
.macro END_IO_128
.endmacro
.endif
.endif

.macro bge addr
	bcs	addr
.endmacro

.macro bgt	addr
    .local @done
	beq	@done
	bcs	addr
@done:
.endmacro

.macro blt addr
	bcc	addr
.endmacro

.macro ble	addr
	beq	addr
	bcc	addr
.endmacro
	
.ifdef scalable_coords

.macro ByteCY xc, yc
	.byte	(yc & $FF)
.endmacro

.macro WordCX xc, yc
	.word	xc + (yc/256)*16	
.endmacro

.endif
