; GEOS by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Joystick input driver

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "jumptab.inc"
.include "c64.inc"

.segment "megaphn"

MouseInit:
	jmp _MouseInit
SlowMouse:
	jmp _SlowMouse
UpdateMouse:
	jmp _UpdateMouse
SetMouse:

joyStat0:
	.byte 0
joyStat1:
	.byte 0
joyStat2:
	.byte 0
joyStat3:
	.byte 0
joyStat4:
	.byte 0
joyStat5:
	.byte 0
joyStat6:
	.byte 0
joyStat7:
	.byte 0

isDown:
	.byte 0
potentialClick:
	.byte 0
downX:
	.word 0
downY:
	.word 0
clickState:
	.byte 0

; GS $D6B0.0 - Touch event 1 in progress
; GS $D6B9 - Touch pad touch #1 X LSB
; GS $D6BA - Touch pad touch #1 Y LSB
; GS $D6BB.0-1 - Touch pad touch #1 X MSBs
; GS $D6BB.5-4 - Touch pad touch #1 Y MSBs

TOUCH_X_OFF 	= 	-40
TOUCH_Y_OFF	=	-(4*8+16)

_MouseInit:
	jsr _SlowMouse
	sta joyStat2
	sta mouseXPos
	sta mouseXPos+1
	sta mouseYPos
	LoadB inputData, $ff
	rts
	;jmp JProc1_4

_SlowMouse:
	LoadB mouseSpeed, NULL
SlowMse0:
	rts

; starting GEOS 6.0 the high byte of Y positiokn is passed and update in r3H
; after uncompacting mouseXPos/mouseYPos
_UpdateMouse:
	lda	clickState
	beq	@3
	lda	#$00
	sta 	mouseData
	smbf 	MOUSE_BIT, pressFlag
	LoadB	clickState, 0

@3:
	bbsf 	0, $D6B0, @4
	jmp	@1
@4:
	; move current physical pos to r0, r1
	MoveB 	$D6B9, r0L
	lda	$D6BB
	and	#$0f
	sta	r0H

	MoveB 	$D6BA, r1L
	lda	$D6BB
	lsr
	lsr
	lsr
	lsr
	sta	r1H

	lda	isDown
	bne 	@ongoing

	; new touch, remember the positiokn
	MoveW	r0, downX
	MoveW	r1, downY

	LoadB	isDown, $FF
	LoadB	potentialClick, $FF

@ongoing:
	clc
	lda	r0L
	adc     #<(TOUCH_X_OFF)
	sta     mouseXPos
	lda	r0H
	adc	#>(TOUCH_X_OFF)
	sta	mouseXPos+1

	clc
	lda	r1L
	adc     #<(TOUCH_Y_OFF)
	sta     mouseYPos
	lda	r1H
	adc	#>(TOUCH_Y_OFF)
	sta	r3H

	; actual Click, if not substantially away from the start pos
	SubW	downX, r0
	ldx	#r0
	jsr	Dabs
	CmpW	r0, 4
	bcs	@off

	SubW	downY, r1
	ldx	#r1
	jsr	Dabs
	CmpW	r1, 4
	bcs	@off
	rts
@off:
	;LoadB	potentialClick, 0
	rts
@1:
	lda	isDown
	beq	@2
	lda	potentialClick
	beq	@2

	LoadB	clickState, $FF
	lda	#$80
	sta 	mouseData
	smbf 	MOUSE_BIT, pressFlag

@2:
	LoadB	isDown, 0
	rts

.if 0
	jsr JoyProc3
	bbrf MOUSEON_BIT, mouseOn, SlowMse0
	jsr JoyProc1
	jsr JoyProc2
	ldy #0
	lda joyStat4
	bpl UpdMse0
	dey
UpdMse0:
	sty r1H
	asl
	rol r1H
	asl
	rol r1H
	asl
	rol r1H
	add joyStat1
	sta joyStat1
	lda r1H
	adc mouseYPos
	sta mouseYPos
	tya
	adc r3H
	sta r3H
	rts

JoyProc1:
	ldx inputData
	bmi JProc1_2
	CmpB maxMouseSpeed, mouseSpeed
	bcc JProc1_1
	AddB mouseAccel, joyStat2
	bcc JProc1_4
	inc mouseSpeed
	bra JProc1_4
JProc1_1:
	sta mouseSpeed
JProc1_2:
	CmpB minMouseSpeed, mouseSpeed
	bcs JProc1_3
	SubB mouseAccel, joyStat2
	bcs JProc1_4
	dec mouseSpeed
	bra JProc1_4
JProc1_3:
	sta mouseSpeed
JProc1_4:
	ldx inputData
	bmi JProc1_5
	ldy mouseSpeed
	sty r0L
	jsr JoyProc4
	MoveB r1H, joyStat3
	MoveB r2H, joyStat4
	rts
JProc1_5:
	LoadB joyStat3, 0
	sta joyStat4
	rts

JoyProc2:
	ldy #$ff
	lda joyStat3
	bmi JProc2_1
	iny
JProc2_1:
	sty r11H
	asl
	rol r11H
	asl
	rol r11H
	asl
	rol r11H
	add joyStat0
	sta joyStat0
	lda r11H
	adc mouseXPos
	sta mouseXPos
	tya
	adc mouseXPos+1
	sta mouseXPos+1
	rts

JoyProc3:
	LoadB cia1base, $ff
	lda cia1base+1
	eor #$ff
	cmp joyStat7
	sta joyStat7
	bne JProc3_2
	and #%00001111
	cmp joyStat6
	beq JProc3_1
	sta joyStat6
	tay
	lda JoyDirectionTab,y
	sta inputData
	smbf INPUT_BIT, pressFlag
	jsr JProc1_4
JProc3_1:
	lda joyStat7
	and #%00010000
	cmp joyStat5
	beq JProc3_2
	sta joyStat5
	asl
	asl
	asl
	eor #%10000000
	sta mouseData
	smbf MOUSE_BIT, pressFlag
JProc3_2:
	rts

JoyDirectionTab:
	.byte $ff, $02, $06, $ff
	.byte $04, $03, $05, $ff
	.byte $00, $01, $07, $ff
	.byte $ff, $ff, $ff, $ff

JoyProc4:
	lda JoyTab1,x
	sta r1L
	lda JoyTab1+2,x
	sta r2L
	lda JoyTab2,x
	pha
	ldx #r1
	ldy #r0
	jsr BBMult
	ldx #r2
	jsr BBMult
	pla
	pha
	bpl JProc4_1
	ldx #r1
	jsr Dnegate
JProc4_1:
	pla
	and #%01000000
	beq JProc4_2
	ldx #r2
	jsr Dnegate
JProc4_2:
	rts

JoyTab1:
	.byte $ff, $b5, $00, $b5
	.byte $ff, $b5, $00, $b5
	.byte $ff, $b5
JoyTab2:
	.byte $00, $40, $40, $c0
	.byte $80, $80, $00, $00
.endif
