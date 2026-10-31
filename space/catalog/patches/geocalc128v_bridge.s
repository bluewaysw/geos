; GeoCalc 128 ROM bridge for GEOS65, older build (vtda GEOCALC128.D64):
; replaces $041F-$05AB of VLIR record 0. Same as geocalc128_bridge.s with
; the addresses of this build; it has no L08E0 call.
;
; GeoCalc calls the BASIC floating point routines. On the C128 it banked
; the BASIC ROM in with the MMU ($FF00/$D501). Under GEOS65 the C64 ROMs
; of the MEGA65 ROM image are mapped in with MAP instead:
;   $A000-$BFFF -> $2A000 (C64 BASIC), $E000-$FFFF -> $2E000 (C64 KERNAL)
; (upper MAP: blocks 5 and 7, offset $20000), lower MAP unchanged.
; Afterwards the GEOS65 mapping is rebuilt exactly like the kernal's
; ApplyMapping (kernal/c65/map.s) from its variables.
; Entry points used from outside stay at their original addresses:
;   $041F enter, $04BC call routine ($0E/$0F), $04D5 leave,
;   $051A BASIC error handler, $0528 power (x^y)
.setcpu "4510"

lowMapBnk	= $8892
highMapBnk	= $8893
lowMap		= $8897
highMap		= $8898

; C64 BASIC/KERNAL ROM routines
FIN		= $BCF3
FOUT		= $BDDD
FPWRT		= $BF7B
CHRGET_ROM	= $E3A2		; CHRGET template, copied to $0073

; GeoCalc 128 routines outside the bridge (unchanged)
L05B2		= $05AC		; $08/$09 = $0100 (number text buffer)
L05CA		= $05C4
L06D8		= $06D2
L0E1C		= $0DF5
SAVE_ZP		= $B0D7		; $12-$8F are saved here (126 bytes, up to $B154)
SAVE_FF		= $B156
irqSave		= $0414		; old $FFFE/$FFFF (2 bytes)
RTI_STUB	= $041E		; contains $40 (rti)
POW_BUF		= $0228

.org $041F
;--------------------------------------------------------------------------
; enter: save zero page and IRQ vector, map the C64 ROMs in
L041F:	sei
	lda	$FFFF
	sta	irqSave+1
	lda	$FFFE
	sta	irqSave
	lda	#>RTI_STUB
	sta	$FFFF
	lda	#<RTI_STUB
	sta	$FFFE
	lda	$FF
	sta	SAVE_FF
	ldx	#$7D			; $12-$8F (the C64 float package uses up to $8F)
@save:	lda	$12, x
	sta	SAVE_ZP, x
	dex
	bpl	@save
	lda	#>L051A			; BASIC errors (IERROR) end up in L051A
	sta	$0301
	lda	#<L051A
	sta	$0300
	tsx
	inx
	inx
	stx	L051B			; stack pointer for the error handler
mapRom:	jsr	lowCalc
	ldy	#$00			; offset $20000 ...
	ldz	#$A2			; ... for blocks 5 and 7
	map
	eom
	rts

; X/A = lower MAP as GEOS65 has it (see ApplyMapping)
lowCalc:
	lda	lowMap
	asl
	pha
	lda	lowMapBnk
	rol
	ora	#$80
	tax
	pla
	rts

; restore the GEOS65 mapping (ApplyMapping)
unmapRom:
	lda	highMap
	asl
	pha
	lda	highMapBnk
	rol
	ora	#$20
	taz
	pla
	tay
	jsr	lowCalc
	map
	eom
	ldz	#0
	rts

; same check as the original
L04A7_new:
	ldx	#$00
	stx	$0A
	and	#$7F
	beq	@r
	cmp	#$1B
	bcc	@err
	cmp	#$68
	bcc	@r
@err:	pla
	pla
	jmp	L0E1C
@r:	rts

	.res	$04BC - *, $EA
;--------------------------------------------------------------------------
; call the ROM routine in $0E/$0F with the cell value(s)
L04BC:	lda	$0F
	sta	$03
	lda	$0E
	sta	$02
	lda	$D0
	jsr	L04A7_new
	jsr	L041F
	jsr	L0563
	jsr	L0525
	jsr	L0593
	.assert * = $04D5, error, "L04D5 moved"
;--------------------------------------------------------------------------
; leave: GEOS65 mapping back, zero page and IRQ vector restored
L04D5:	sei
	jsr	unmapRom
	lda	SAVE_FF
	sta	$FF
	ldx	#$7D
@rest:	lda	SAVE_ZP, x
	sta	$12, x
	dex
	bpl	@rest
	inx				; X = 0 (as before)
	lda	irqSave+1
	sta	$FFFF
	lda	irqSave
	sta	$FFFE
	cli
	rts

	.res	$051A - *, $EA
;--------------------------------------------------------------------------
; BASIC error: back to the caller of L041F with error $C2
L051A:	.byte	$A2			; ldx #
L051B:	.byte	$FF			;      (stack pointer, set in L041F)
	txs
	jsr	L04D5
	lda	#$C2
	sta	$0A
	rts
	.assert * = $0525, error, "L0525 moved"
L0525:	jmp	($0002)
;--------------------------------------------------------------------------
; x^y: first number -> POW_BUF, second number -> FAC, ARG = first
	.assert * = $0528, error, "L0528 moved"
L0528:	lda	$D0
	jsr	L04A7_new
	lda	$D9
	jsr	L04A7_new
	jsr	L041F
	jsr	L0563
	ldx	#$05
@a:	lda	$61, x			; C64 FAC1
	sta	POW_BUF, x
	dex
	bpl	@a
	ldx	#$06
@b:	lda	$D3, x
	sta	$CA, x
	dex
	bpl	@b
	jsr	L0563
	ldx	#$05
@c:	lda	POW_BUF, x
	sta	$69, x			; C64 ARG
	dex
	bpl	@c
	lda	$61
	jsr	FPWRT
	jsr	L0593
	jmp	L04D5
;--------------------------------------------------------------------------
; number text at $0100 -> FAC (CHRGET + FIN, as GeoCalc 64)
L0563:	jsr	L05B2
	txa
	jsr	L06D8
	ldx	#$17
@chr:	lda	CHRGET_ROM, x
	sta	$73, x
	dex
	bpl	@chr
	lda	#$00
	sta	$7B
	lda	#$FF
	sta	$7A			; TXTPTR = $00FF
	jsr	$0073
	jmp	FIN
;--------------------------------------------------------------------------
; FAC -> number text at $0100
L0593:	ldx	#$04
@l:	lda	$61, x
	cmp	#$FF
	bne	@n
	dex
	bne	@l
	beq	@f
@n:	lda	$65
	and	#$FD
	sta	$65
@f:	jsr	FOUT
	jsr	L05B2
	jmp	L05CA
	.assert * <= $05AC, error, "bridge too long"
	.res	$05AC - *, $EA
