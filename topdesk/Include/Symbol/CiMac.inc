
.macro DecW addr
    .local @10
	dec	addr
	lda	addr
	cmp	#$ff
	bne	@10
	dec	addr+1
@10:
.endmacro


;.macro IncW addr
;	inc	addr
;	bne	@10
;	inc	addr+1
;@10:
;.endmacro

; AddSW
; Addiert inhalt einer Adresse (Byte)
; zu einem Wortwert
;

.macro AddSW source, dest
	AddB source+0, dest+0
	lda dest+1
	adc #$00
	sta dest+1
.endmacro

.macro SubSW source, dest
	SubB source+0, dest+0  
	lda dest+1
	sbc #$00
	sta dest+1
.endmacro


.macro AddvW data, dest
    .local @10
	lda	#data
	clc
	adc	dest
	sta	dest
	bcc	@10
	inc	dest+1
@10:
.endmacro

.macro LoadWr0 data
	lda	#<(data)
	ldx	#>(data)
	jsr	Loadr0AX
.endmacro

.macro SubVB data, data2
	sec
	lda	data2
	sbc	#data
	sta	data2
.endmacro
