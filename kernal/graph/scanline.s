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
.global _GetScanLineExt
.ifdef mega65
.global InitScanLineTab
.global LineTabH
.global LineTabL
.global _GetScanLine_HR
.global _EndScanLine
.endif

.segment "graph2n"

.ifdef mega65
; C65/M65 bank 1 addresses
SCREEN_BASE65           =       $0000
BACK_SCR_BASE65         =       $9000

.import _MapHigh
.import _MapLow
.import MapUnderlay
.import UnmapUnderlay
.endif

; API call of this function in 80 col GEOS 128 compatibility
; mode, should map $A000-$C000 to second background buffer
; area.

_col80MemLayout:
	.byte	0	; $FF means 80 cols are mapped
			; and active

_GetScanLineExt:
	bit	graphMode
	bpl	_GetScanLine

	; if 80 col compat mode
	jsr	MapUnderlay
	jsr	Ensure80ColMemLayout
	jsr	GSC80
	jsr	UnmapUnderlay
	txa

_EndScanLine:
	bit	graphMode
	bpl	@1
	pha
	lda	#$00
	tax
	jsr	_MapHigh
	;ldx	#$00
	;lda	#$80

	lda	#$00
	tax
	jsr	_MapLow
	pla
	tax
@1:
	rts

;---------------------------------------------------------------
; GetScanLine_HR
;
; Function:  Returns the address of the beginning of a scanline

; Pass:      r11L lower byte of y coordinates
;            r3H  upper 4 bits are high bit of y coordinate
; Return:    r5  add of 1st byte of foreground scr
;            r6  add of 1st byte of background scr
; Destroyed: a, r11L
;---------------------------------------------------------------
_GetScanLine_HR:
	lda	r11L
	pha
	lda 	r3H
	lsr
	lsr
	lsr
	lsr
	ldx 	#5
@21:
	asl 	r11L
	rol
	dex
	bne 	@21
	tay
	pla
	sta	r11L
	and 	#$07
	ora 	#$f8
	tax

;---------------------------------------------------------------
; GetScanLine                                             $C13C
;
; Function:  Returns the address of the beginning of a scanline

; Pass:      x   scanline nbr
;                 highres mode: %11111xyz, while xyz is the lower
;                 3 bits
;            y   scanline, div by 8 (if highres mode)
; Return:    r5  add of 1st byte of foreground scr
;            r6  add of 1st byte of background scr
; Destroyed: a
;---------------------------------------------------------------
_GetScanLine:
.ifdef mega65
	PushB	CPU_DATA
	LoadB	CPU_DATA, RAM_64K

	lda	_col80MemLayout
	beq	@memLayoutDone

	jsr	MapUnderlay
	jsr	SwitchToStandardMemLayout
	jsr	UnmapUnderlay

@memLayoutDone:
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
.ifdef mega65
	;and #%11111000
	cmp #%11111000
	bcc	@_1		; branch if not high res

	; we are in high res mode
	;txa
	and #%00000111
	sta r6H			; card inline offset

	tya
	; card line in A now
	bra	@_2
@_1:
	; we are in standard (non-hig-res mode)
	;txa
.endif
	and #%00000111
	sta r6H			; card inline offset
.ifdef wheels_size_and_speed
	txa
.else
	pla
.endif
	lsr
	lsr
	lsr

	; card line in A now
.ifdef mega65
@_2:
	; A is card line
	; r6H card inline offset
.endif
.ifdef mega65
	;bit grapeMode
	;bne @X	; branch  if not mode 0
	;bbrf 7, graphMode, @X
		;ora #$20
@X:
.endif
	tax		; scan line in cards in x now

	lda LineTabL,x
	ora r6H
	sta r5L
	sta r6L
	lda LineTabH,x
	sta r5H
	sta r6H

	tya
	pha
	tza
	pha

	lda	graphMode
	bne	@slow

	lda	#$B0		; of $c0 -> background fix map $12000
	ldx	#1
	jsr	_MapHigh

	lda	#0		; of $c0 -> background fix map $12000
	tax
	jsr	_MapLow

	ldx	#$60	; r6 off
	ldy	#$a0	; r5 off
	bbsf	6, dispBufferOn, @2_A ; ST_WR_BACK
	ldx	#$a0	; non-back
@2_A:
	bbsf	7, dispBufferOn, @2_B ; ST_WR_FORE
	ldy	#$60	; non-fore
@2_B:
	tya
	clc
	adc	r5H
	sta	r5H
	txa
	clc
	adc	r6H
	bra	gslend


@slow:

	; screen buffer offset in r5H/r6H now

	bbrf 7, dispBufferOn, @2 ; ST_WR_FORE


.ifdef bsw128
	bvs @1
.else
	bbrf 6, dispBufferOn, @3 ; ST_WR_BACK
.endif
	jmp @1
@3:
;
; 	foreground only
;
.ifdef bsw128
	jmp GSC80_6
.else

.ifdef mega65
	; map foregroud and translate ptrs
	;tya
	;pha
	;tza
	;pha

	; a/x lower, y/z highter
	lda	r5H
	ldx 	#2
	add	#$60		; add the base address
	bcc	@Y2
	clc
	;ror
	bra	@Y1

@Y2:
	dex	;ldx	#1
	sec
	;ror
@Y1:
	ror
    	jsr	_MapHigh

	lda	r5H
	and	#%00000001
	add	#$a0
	sta 	r5H
	bra	gslend
.else

	pla
	tax
	PopB	CPU_DATA
	rts
.endif
.endif

;
; background only
;
@2:
.ifdef bsw128
	jmp 	GSC80_6
.else

.ifdef mega65
; map foregroud and translate ptrs
	;tya
	;pha
	;tza
	;pha

; a/x lower, y/z highter
	LDX	#0
	lda	r5H
	add	#$60
	bcs	@Y2__
	sec
	;ror			; div page by 2 for map offset
	;ldx 	#0		; map bank offset
	bra	@Y1__

@Y2__:
	clc
	;ror			; div page by 2 for map offset
	inx	;ldx	#1		; map bank offset
@Y1__:
	ror
	ldz	#0		;
	bra 	gslend2

;	jsr	_MapLow

;	lda	r5H
;	and	#%00011111
;	ldx	graphMode
;	beq	@X2__
;	and	#%00000001
;@X2__:
;	add	#$60
;	sta 	r5H
;	bra 	gslend
.else

	pla
	tax
	rts
.endif
.endif


;
;  background and foreground
;

@1:
.ifdef mega65
	; map foregroud and translate ptrs
	;tya
	;pha
	;tza
	;pha

	; a/x lower, y/z highter
	lda	r5H
	pha

	ldx	#1
	add	#$60
	bcc	@Y2_
	clc
	;ror
	inx	;ldx 	#2
	bra	@Y1_

@Y2_:
	sec
	;ror
	;ldx	#1
@Y1_:
	ror
	jsr	_MapHigh

	;sub #$40
	;lsr
	pla
	add	#$60
	bcs	@Y2___
	sec
	;ror
	ldx 	#0
	bra	@Y1___

@Y2___:
	clc
	;ror
	ldx	#1
@Y1___:
	ror
	ldz	#$40
gslend2:
	stz	r6H
    	jsr 	_MapLow

	lda	r5H
	and 	#%00000001
	add	#$60		; add back buffer base
	add	r6H		; add offset between front and back buffer
	sta 	r5H		;

	sub 	r6H		; sub offset between front and back buffer
gslend:
	sta	r6H

	pla
	taz
	pla
	tay

	pla
	tax
	PopB	CPU_DATA
	rts
.else

	pla
	tax
	rts
.endif


.if .defined(bsw128) || .defined(mega65)
.segment "graph2nu"
Ensure80ColMemLayout:
	lda	_col80MemLayout
	bne	@1
	jsr	SwitchTo80ColMemLayout
@1:
	rts

SwitchToStandardMemLayout:
	pha
	txa
	pha
	tya
	pha
	tza
	pha
	PushW	r0
	PushW	r1
	PushW	r2
	PushW	r3

	LoadW	r0, $6000
	LoadW	r1, $0000

	LoadW	r2, $C000
	LoadW	r3, $0001

	;inc	$D020

	ldy	#0
@1:
	cpy	#100
	bne	@3
	LoadW	r0, $A040
@3:
	ldx	#0
@2:
	LDZ	#0
	EOM
	lda 	(r0), Z
	EOM
	sta 	(r2), Z

	IncW	r0
	AddVW	8, r2

	inx
	cpx	#80
	bne	@2

	iny
	tya
	and	#7
	beq	@4

	SubVW	639, r2
	bra	@5
@4:
	SubVW	7, r2
@5:
	cpy	#200
	bne	@1

	PopW	r3
	PopW	r2
	PopW	r1
	PopW	r0

	LoadB	_col80MemLayout, 0

	pla
	taz
	pla
	tay
	pla
	tax
	pla

	rts

SwitchTo80ColMemLayout:
	pha
	txa
	pha
	tya
	pha
	tza
	pha
	PushW	r0
	PushW	r1
	PushW	r2
	PushW	r3

	LoadW	r0, $6000
	LoadW	r1, $0000

	LoadW	r2, $C000
	LoadW	r3, $0001

	;inc	$D020

	ldy	#0
@1:
	cpy	#100
	bne	@3
	LoadW	r0, $A040
@3:
	ldx	#0
@2:
	LDZ	#0
	EOM
	lda 	(r2), Z
	EOM
	sta 	(r0), Z

	IncW	r0
	AddVW	8, r2

	inx
	cpx	#80
	bne	@2

	iny
	tya
	and	#7
	beq	@4

	SubVW	639, r2
	bra	@5
@4:
	SubVW	7, r2
@5:
	cpy	#200
	bne	@1

	PopW	r3
	PopW	r2
	PopW	r1
	PopW	r0

	LoadB	_col80MemLayout, $FF

	pla
	taz
	pla
	tay
	pla
	tax
	pla

	rts

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
	;.lobytes LineTab
	.repeat	128
		.byte 0
	.endrep
LineTabH:
	;.hibytes LineTab
	.repeat	128
		.byte 0
	.endrep



.else

.define LineTab SCREEN_BASE+0*320, SCREEN_BASE+1*320, SCREEN_BASE+2*320, SCREEN_BASE+3*320, SCREEN_BASE+4*320, SCREEN_BASE+5*320, SCREEN_BASE+6*320, SCREEN_BASE+7*320, SCREEN_BASE+8*320, SCREEN_BASE+9*320, SCREEN_BASE+10*320, SCREEN_BASE+11*320, SCREEN_BASE+12*320, SCREEN_BASE+13*320, SCREEN_BASE+14*320, SCREEN_BASE+15*320, SCREEN_BASE+16*320, SCREEN_BASE+17*320, SCREEN_BASE+18*320, SCREEN_BASE+19*320, SCREEN_BASE+20*320, SCREEN_BASE+21*320, SCREEN_BASE+22*320, SCREEN_BASE+23*320, SCREEN_BASE+24*320
LineTabL:
	.lobytes LineTab
LineTabH:
	.hibytes LineTab

.endif
