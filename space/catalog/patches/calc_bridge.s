; Calculator 128 V2.0 (David Durran) for GEOS65: C64 BASIC float routines
; of the MEGA65 ROM image, mapped in with MAP (as the GeoCalc 128 patch).
; Code at $1E80 (was the $0380 save area, no longer needed).
.setcpu "4510"
lowMapBnk	= $8892
highMapBnk	= $8893
lowMap		= $8897
highMap		= $8898
CHRGET_ROM	= $E3A2
.org $1E80
mapC64:	sei
	jsr	lowCalc
	ldy	#$00			; $A000 -> $2A000, $E000 -> $2E000
	ldz	#$A2
	map
	eom
	ldx	#$17			; CHRGET for STRVAL
@c:	lda	CHRGET_ROM, x
	sta	$73, x
	dex
	bpl	@c
	rts
unmapC64:
	lda	highMap			; GEOS65 mapping (ApplyMapping)
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
	.assert * <= $1F00, error, "calc bridge too long"
