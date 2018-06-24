; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Graphics library: GetScanLine syscall

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.global _GetScanLine

.segment "graph2n"

.ifdef mega65
; C65/M65 bank 1 addresses
SCREEN_BASE65           =       $0000
BACK_SCR_BASE65         =       $9000

.import _MapHigh
.import _MapLow
.endif


;---------------------------------------------------------------
; GetScanLine                                             $C13C
;
; Function:  Returns the address of the beginning of a scanline

; Pass:      x   scanline nbr
; Return:    r5  add of 1st byte of foreground scr
;            r6  add of 1st byte of background scr
; Destroyed: a
;---------------------------------------------------------------
_GetScanLine:
.ifdef mega65
	PushB	CPU_DATA
	LoadB	CPU_DATA, RAM_64K
.endif
.ifdef bsw128
	bbrf 7, graphMode, @X
	jmp GSC80
@X:
.endif
	txa
	pha
.ifndef wheels_size_and_speed
	pha
.endif
	and #%00000111
	sta r6H
.ifdef wheels_size_and_speed
	txa
.else
	pla
.endif
	lsr
	lsr
	lsr
.ifdef mega65
	bbrf 7, graphMode, @X
;;	ora #$20
@X:
.endif
	tax
	bbrf 7, dispBufferOn, @2 ; ST_WR_FORE
.ifdef bsw128
	bvs @1
.else
	bbsf 6, dispBufferOn, @1 ; ST_WR_BACK
.endif

;
; 	foreground only
;
	lda LineTabL,x
	ora r6H
	sta r5L
.ifdef wheels_size_and_speed
	sta r6L
.endif
	lda LineTabH,x
	sta r5H
.ifdef bsw128
	jmp GSC80_6
.else
.ifdef wheels_size_and_speed
	sta r6H
.else
	MoveW r5, r6
.endif

.ifdef mega65
	; map foregroud and translate ptrs
	tya
	pha
	tza
	pha

	; a/x lower, y/z highter
	lda r5H
	bbsf 7, graphMode, @X1
	;;and	#%11100000
@X1:
	sub	#$60
	lsr

	ldx	#0
    jsr _MapHigh

	lda	r5H
	and	#%00011111
	;;bbrf 7, graphMode, @X2
	and #%00000001
@X2:
	add	#$a0
	sta r5H
	sta	r6H

	pla
	taz
	pla
	tay

.endif

	pla
	tax
.ifdef mega65
	PopB	CPU_DATA
.endif
	rts
.endif

;
; background only
;
@2:	
.ifdef bsw128
	bvc @3
.else
	bbrf 6, dispBufferOn, @3 ; ST_WR_BACK
.endif
	lda LineTabL,x
	ora r6H
	sta r6L
.ifdef wheels_size_and_speed
	sta r5L
.endif
	lda LineTabH,x
	subv >(SCREEN_BASE-BACK_SCR_BASE)
	sta r6H
.ifdef bsw128
	jmp GSC80_5
.else
.ifdef wheels_size_and_speed
	sta r5H
.else
	MoveW r6, r5
.endif
	pla
	tax
	rts
.endif
@3:	LoadB r5L, <$AF00
	sta r6L
	LoadB r5H, >$AF00
	sta r6H
	pla
	tax
.ifdef mega65
	PopB	CPU_DATA
.endif
	rts

;
;  background and foreground
;

@1:	lda LineTabL,x
	ora r6H
	sta r5L
	sta r6L
	lda LineTabH,x
	sta r5H
	subv >(SCREEN_BASE-BACK_SCR_BASE)
	sta r6H

.ifdef mega65
	; map foregroud and translate ptrs
	tya
	pha
	tza
	pha

	; a/x lower, y/z highter
	lda r5H
	bbsf 7, graphMode, @X1_
	;;and	#%11100000
@X1_:
	pha
	sub	#$60
	lsr

	ldx	#0
    jsr _MapHigh
	;sub #$40
	;lsr
	pla
	lsr
	add #$90		; back buffer is at $18000

	ldx #4
    jsr _MapLow

	lda	r5H
	and	#%00011111
	;;bbrf 7, graphMode, @X2_
	and #%00000001
@X2_:
	add	#$a0
	sta r5H
	sub #$40
	sta	r6H

	pla
	taz
	pla
	tay

.endif

	pla
	tax
.ifdef mega65
	PopB	CPU_DATA
.endif
	rts


.ifdef bsw128
GSC80:
	txa
	pha
	stx r5H
	lda #$00
	lsr r5H
	ror a
	lsr r5H
	ror a
	sta r5L
	ldx r5H
	stx r6L
	lsr r5H
	ror a
	lsr r5H
	ror a
	clc
	adc r5L
	sta r5L
	lda r6L
	adc r5H
	sta r5H
	bbrf 7, dispBufferOn, LF6A6
	bvs @1
	bra GSC80_6
@1:	pla
	tax
LF687:	lda r5H
	add #$60
	sta r6H
	MoveB r5L, r6L
	CmpWI r6, $7f40
	bcc @1
	AddVB $21, r6H
@1:	rts

LF6A6:	bvc GSC80_6
	jsr LF687
GSC80_5:
	lda r6H
	sta r5H
	lda r6L
	sta r5L
	pla
	tax
	rts

GSC80_6:
	lda r5H
	sta r6H
	lda r5L
	sta r6L
	pla
	tax
	rts
.endif

.segment "graph2o"

.ifdef mega65

; this is the table for the 640 pix width resolution, 320 is needed as well
;.define LineTab SCREEN_BASE65+0*320, SCREEN_BASE65+1*320, SCREEN_BASE65+2*320, SCREEN_BASE65+3*320, SCREEN_BASE65+4*320, SCREEN_BASE65+5*320, SCREEN_BASE65+6*320, SCREEN_BASE65+7*320, SCREEN_BASE65+8*320, SCREEN_BASE65+9*320, SCREEN_BASE65+10*320, SCREEN_BASE65+11*320, SCREEN_BASE65+12*320, SCREEN_BASE65+13*320, SCREEN_BASE65+14*320, SCREEN_BASE65+15*320, SCREEN_BASE65+16*320, SCREEN_BASE65+17*320, SCREEN_BASE65+18*320, SCREEN_BASE65+19*320, SCREEN_BASE65+20*320, SCREEN_BASE65+21*320, SCREEN_BASE65+22*320, SCREEN_BASE65+23*320, SCREEN_BASE65+24*320, SCREEN_BASE65+0*320,SCREEN_BASE65+0*320,SCREEN_BASE65+0*320,SCREEN_BASE65+0*320,SCREEN_BASE65+0*320,SCREEN_BASE65+0*320,SCREEN_BASE65+0*320, SCREEN_BASE65+0*640, SCREEN_BASE65+1*640, SCREEN_BASE65+2*640, SCREEN_BASE65+3*640, SCREEN_BASE65+4*640, SCREEN_BASE65+5*640, SCREEN_BASE65+6*640, SCREEN_BASE65+7*640, SCREEN_BASE65+8*640, SCREEN_BASE65+9*640, SCREEN_BASE65+10*640, SCREEN_BASE65+11*640, SCREEN_BASE65+12*640, SCREEN_BASE65+13*640, SCREEN_BASE65+14*640, SCREEN_BASE65+15*640, SCREEN_BASE65+16*640, SCREEN_BASE65+17*640, SCREEN_BASE65+18*640, SCREEN_BASE65+19*640, SCREEN_BASE65+20*640, SCREEN_BASE65+21*640, SCREEN_BASE65+22*640, SCREEN_BASE65+23*640, SCREEN_BASE65+24*640, SCREEN_BASE65+25*640, SCREEN_BASE65+26*640, SCREEN_BASE65+27*640, SCREEN_BASE65+28*640, SCREEN_BASE65+29*640, SCREEN_BASE65+30*640, SCREEN_BASE65+31*640, SCREEN_BASE65+32*640, SCREEN_BASE65+33*640, SCREEN_BASE65+34*640, SCREEN_BASE65+35*640, SCREEN_BASE65+36*640, SCREEN_BASE65+37*640, SCREEN_BASE65+38*640, SCREEN_BASE65+39*640, SCREEN_BASE65+40*640, SCREEN_BASE65+41*640, SCREEN_BASE65+42*640, SCREEN_BASE65+43*640, SCREEN_BASE65+44*640, SCREEN_BASE65+45*640,SCREEN_BASE65+46*640, SCREEN_BASE65+47*640, SCREEN_BASE65+48*640, SCREEN_BASE65+49*640
.define LineTab SCREEN_BASE65+0*800, SCREEN_BASE65+1*800, SCREEN_BASE65+2*800, SCREEN_BASE65+3*800, SCREEN_BASE65+4*800, SCREEN_BASE65+5*800, SCREEN_BASE65+6*800, SCREEN_BASE65+7*800, SCREEN_BASE65+8*800, SCREEN_BASE65+9*800, SCREEN_BASE65+10*800, SCREEN_BASE65+11*800, SCREEN_BASE65+12*800, SCREEN_BASE65+13*800, SCREEN_BASE65+14*800, SCREEN_BASE65+15*800, SCREEN_BASE65+16*800, SCREEN_BASE65+17*800, SCREEN_BASE65+18*800, SCREEN_BASE65+19*800, SCREEN_BASE65+20*800, SCREEN_BASE65+21*800, SCREEN_BASE65+22*800, SCREEN_BASE65+23*800, SCREEN_BASE65+24*800, SCREEN_BASE65+0*800,SCREEN_BASE65+0*800,SCREEN_BASE65+0*800,SCREEN_BASE65+0*800,SCREEN_BASE65+0*800,SCREEN_BASE65+0*800,SCREEN_BASE65+0*800, SCREEN_BASE65+0*800, SCREEN_BASE65+1*800, SCREEN_BASE65+2*800, SCREEN_BASE65+3*800, SCREEN_BASE65+4*800, SCREEN_BASE65+5*800, SCREEN_BASE65+6*800, SCREEN_BASE65+7*800, SCREEN_BASE65+8*800, SCREEN_BASE65+9*800, SCREEN_BASE65+10*800, SCREEN_BASE65+11*800, SCREEN_BASE65+12*800, SCREEN_BASE65+13*800, SCREEN_BASE65+14*800, SCREEN_BASE65+15*800, SCREEN_BASE65+16*800, SCREEN_BASE65+17*800, SCREEN_BASE65+18*800, SCREEN_BASE65+19*800, SCREEN_BASE65+20*800, SCREEN_BASE65+21*800, SCREEN_BASE65+22*800, SCREEN_BASE65+23*800, SCREEN_BASE65+24*800, SCREEN_BASE65+0*800,SCREEN_BASE65+0*800,SCREEN_BASE65+0*800,SCREEN_BASE65+0*800,SCREEN_BASE65+0*800,SCREEN_BASE65+0*800,SCREEN_BASE65+0*800

LineTabL:
	.lobytes LineTab
LineTabH:
	.hibytes LineTab



.else

.define LineTab SCREEN_BASE+0*320, SCREEN_BASE+1*320, SCREEN_BASE+2*320, SCREEN_BASE+3*320, SCREEN_BASE+4*320, SCREEN_BASE+5*320, SCREEN_BASE+6*320, SCREEN_BASE+7*320, SCREEN_BASE+8*320, SCREEN_BASE+9*320, SCREEN_BASE+10*320, SCREEN_BASE+11*320, SCREEN_BASE+12*320, SCREEN_BASE+13*320, SCREEN_BASE+14*320, SCREEN_BASE+15*320, SCREEN_BASE+16*320, SCREEN_BASE+17*320, SCREEN_BASE+18*320, SCREEN_BASE+19*320, SCREEN_BASE+20*320, SCREEN_BASE+21*320, SCREEN_BASE+22*320, SCREEN_BASE+23*320, SCREEN_BASE+24*320
LineTabL:
	.lobytes LineTab
LineTabH:
	.hibytes LineTab

.endif
