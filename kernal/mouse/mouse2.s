; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Mouse: MouseUp, MouseOff, StartMouseMode, ClearMouseMode syscalls


.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"
.include "inputdrv.inc"

.import _DoPreviousMenu
.import menuOptNumber
.import ProcessClick
.import Menu_5
.import menuRight
.import menuLeft
.import menuBottom
.import menuTop
.import _DisablSprite

.import CallRoutine
.import PosSprite
.import DrawSprite
.import MouseUp
.import NormalizeX
.ifndef bsw128
.import EnablSprite
.endif
.ifdef mega65
.import UncompactXY
.import i_FillRam
.import i_MoveData
.endif

.global _MouseOff
.global _StartMouseMode
.global ProcessMouse
.global _ClearMouseMode
.global _MouseUp
.global _ProcessMouseInt
.global _SetMsePic

.ifdef wheels
.global ResetMseRegion
.endif

.segment "mouse2int"
_SetMsePic:
	lda	r0L
	ora	r0H
	sta	VDCMouseSet

	AddVW	16, r0
	ldy	#0	; input offset
	ldx	#0	; output offset
@1:
	lda	(r0), y
	sta	VDCPointer, x
	inx
	iny
	lda	(r0), y
	sta	VDCPointer, x
	inx
	iny
	lda	#0
	sta	VDCPointer, x
	inx
	cpx	#24
	bne	@1
	rts

.segment "mouse2"

_ProcessMouseInt:
.if .defined(bsw128) 
	bbsf 7, graphMode, @X
.endif
.if .defined(mega65) 
	lda	VDCMouseSet
	beq	@X3
	bbsf 7, graphMode, @X2
@X3b:
.endif
	MoveW msePicPtr, r4
@X3c:
	jsr DrawSprite
.if .defined(mega65) 
	bra @X1
@X3:
	bbrf 7, graphMode, @X3b	
	LoadW r4, mousePicData
	bra @X3c
@X2:
	jsr i_FillRam
	.word 63
	.word spr0pic
	.byte 0
	jsr i_MoveData
	.word VDCPointer
	.word spr0pic
	.word 24
@X1:
.endif
	
@X:	MoveW mouseXPos, r4
	MoveB mouseYPos, r5L
	jsr PosSprite
.ifndef bsw128
	jmp EnablSprite
.else
	rts
.endif


VDCMouseSet:	
	.byte	0

_StartMouseMode:
	bcc @1
	lda r11L
	ora r11H
	beq @1
.if .defined(bsw128) || .defined(mega65)
	ldx #r11
	jsr NormalizeX
.endif
	MoveW r11, mouseXPos
	sty mouseYPos
	jsr SlowMouse
@1:	LoadW mouseVector, CheckClickPos
	LoadW mouseFaultVec, DoMouseFault
	LoadB faultData, NULL
	jmp MouseUp

_ClearMouseMode:
	LoadB mouseOn, NULL
CMousMd1:
	LoadB r3L, NULL
	jmp _DisablSprite

_MouseOff:
	rmbf MOUSEON_BIT, mouseOn
	jmp CMousMd1

_MouseUp:
	smbf MOUSEON_BIT, mouseOn
.ifdef bsw128
	smbf_ 0, mobenble
.endif
	rts

ProcessMouse:
	; uncompact mouse position first
	lda mouseXPos+1
	jsr	UncompactXY
	sty r3H
	sta	mouseXPos+1

.ifdef wheels_bad_ideas
	; While the mouse pointer is not showing,
	; Wheels doesn't call the mouse driver.
	; For a joystick, this means that the
	; pointer can't be moved while it's
	; invisible, and for a 1531 mouse, it means
	; the input registers may overflow in the
	; worst case, causing the pointer to jump.
	;
	; This is probably not a good idea.
	bbrf MOUSEON_BIT, mouseOn, @1

	; disable 40 mhz mode from the outside to
	; stay compatible with C64 input drivers
	PushB $d054
	and #%10111111
	sta $d054
	jsr UpdateMouse
	PopB $d054
.else

	; disable 40 mhz mode from the outside to
	; stay compatible with C64 input drivers
	PushB $d054
	and #%10111111
	sta $d054
	jsr UpdateMouse
	PopB $d054

	bbrf MOUSEON_BIT, mouseOn, @1
.endif
	jsr CheckMsePos
	jsr	@1

	LoadB r3L, 0

	jmp _ProcessMouseInt
@1:
	; compact mouse position
	lda mouseXPos+1
	and	#$0F
	sta mouseXPos+1
	lda r3H
	asl
	asl
	asl
	asl
	ora mouseXPos+1
	sta mouseXPos+1
	rts

CheckMsePos:
.ifdef mega65
	lda mouseLeft+1
	jsr	UncompactXY
	sta r4L
	sty	r4H

	lda mouseRight+1
	jsr	UncompactXY
	sta r5L
	sty	r5H
.endif

	ldy mouseLeft
	ldx r4L	;mouseLeft+1
	lda mouseXPos+1
	bmi @2
	cpx mouseXPos+1
	bne @1
	cpy mouseXPos
@1:	bcc @3
	beq @3
@2:	smbf OFFLEFT_BIT, faultData
	sty mouseXPos
	stx mouseXPos+1
@3:	ldy mouseRight
	ldx r5L	;mouseRight+1
	cpx mouseXPos+1
	bne @4
	cpy mouseXPos
@4:	bcs @5
	smbf OFFRIGHT_BIT, faultData
	sty mouseXPos
	stx mouseXPos+1
@5:	ldy mouseTop
	ldx r4H
	lda r3H
	bmi @6
	;CmpBI mouseYPos, 228
	;bcs @6
	cpx r3H
	bne @11
	cpy mouseYPos
@11:
	bcc @7
	beq @7
@6:	smbf OFFTOP_BIT, faultData
	sty mouseYPos
	stx r3H
@7:	ldy mouseBottom
	ldx r5H
	cpx r3H
	bne @12
	cpy mouseYPos
@12:
	bcs @8
	smbf OFFBOTTOM_BIT, faultData
	sty mouseYPos
	stx r3H
@8:	bbrf MENUON_BIT, mouseOn, @B
	lda mouseYPos
	cmp menuTop
	bcc @A
	cmp menuBottom
	beq @9
	bcs @A
@9:	CmpW mouseXPos, menuLeft
	bcc @A
	CmpW mouseXPos, menuRight
	bcc @B
	beq @B
@A:	smbf OFFMENU_BIT, faultData
@B:
	rts

.ifdef wheels ; this got moved :(
.import ScreenDimensions
ResetMseRegion:
	ldy #5
@1:	lda ScreenDimensions,y
	sta mouseTop,y
	dey
	bpl @1
	rts
.endif

CheckClickPos:
	lda mouseData
	bmi @4
.ifdef wheels_size_and_speed
	bit mouseOn
	bpl @4
	bvc @3
.else
	lda mouseOn
	and #SET_MSE_ON
	beq @4
	lda mouseOn
	and #SET_MENUON
	beq @3
.endif
	CmpB mouseYPos, menuTop
	bcc @3
	cmp menuBottom
	beq @1
	bcs @3
@1:	CmpW mouseXPos, menuLeft
	bcc @3
	CmpW mouseXPos, menuRight
	beq @2
	bcs @3
@2:	jmp Menu_5
@3:	bbrf ICONSON_BIT, mouseOn, @4
	jmp ProcessClick
@4:	lda otherPressVec
	ldx otherPressVec+1
	jmp CallRoutine

.ifndef wheels_size
	rts ; ???
.endif

DoMouseFault:
.ifdef wheels_size_and_speed
	bit mouseOn
	bpl @3
	bvc @3
.else
	lda #$c0
	bbrf MOUSEON_BIT, mouseOn, @3
	bvc @3
.endif
	lda menuNumber
	beq @3
	bbsf OFFMENU_BIT, faultData, @2

.ifdef wheels_size_and_speed
	lda #SET_OFFTOP
	bit menuOptNumber
	bmi @X
	lda #SET_OFFLEFT
@X:	and faultData
.else
	ldx #SET_OFFTOP
	lda #$C0
	tay
	bbsf 7, menuOptNumber, @1
	ldx #SET_OFFLEFT
@1:	txa
	and faultData
.endif
	bne @2
.ifndef wheels_size_and_speed ; seems unnecessary?
	tya
.endif
	bbsf 6, menuOptNumber, @3
@2:	jsr _DoPreviousMenu
@3:	rts

VDCPointer:	
	.byte	$f0
	.repeat 23
		.byte 0
	.endrep