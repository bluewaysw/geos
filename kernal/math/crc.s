; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Math library: CRC syscall

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.import Ddec

.global _CRC

.segment "math2"

;---------------------------------------------------------------
; CRC                                                     $C20E
;
; Function:  CRC performs a checksum on specified data
;
; Pass:      r0  ptr to data
;            r1  nbr of bytes to check
; Return:    r2  checksum
; Destroyed: a, x, y, r0, r1, r3l
;---------------------------------------------------------------
_CRC:
.ifdef mega65
	; The data at r0 belongs to the application and may live at
	; $A000-$BFFF, which is hidden by the kernel underlay while this
	; code runs. Read it through the flat 32-bit pointer r4/r5 (bank 0);
	; r1 holds the count, so r0/r1 can't be used as the pointer.
	PushW r4
	PushW r5
	MoveW r0, r4
	LoadW r5, 0
.endif
	ldy #$ff
	sty r2L
	sty r2H
	iny
@1:	lda #$80
	sta r3L
@2:	asl r2L
	rol r2H
.ifdef mega65
	phy
	plz
	EOM
	lda (r4),z
.else
	lda (r0),y
.endif
	and r3L
	bcc @3
	eor r3L
@3:	beq @4
	lda r2L
	eor #$21
	sta r2L
	lda r2H
	eor #$10
	sta r2H
@4:	lsr r3L
	bcc @2
	iny
	bne @5
	inc r0H
.ifdef mega65
	inc r4H
.endif
@5:	ldx #r1
	jsr Ddec
	lda r1L
	ora r1H
	bne @1
.ifdef mega65
	ldz #0
	PopW r5
	PopW r4
.endif
	rts
