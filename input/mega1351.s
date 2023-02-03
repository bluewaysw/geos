; GEOS by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Commodore 1531 mouse input driver

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "c64.inc"

.export __VLIR0_START__
.export __STARTUP_RUN__

.segment "mega1351"
__STARTUP_RUN__:
__VLIR0_START__:

MouseInit:
	jmp _MouseInit
SlowMouse:
	jmp _SlowMouse
UpdateMouse:
	jmp _UpdateMouse
SetMouse:

;tmpFire:
;	.byte 0
;mseX:
;	.byte 0
;mseY:
;	.byte 0

buttonLeft	=	$10
buttonRight	=	$01

SID		=	$D400	   		; SID REGISTERS
SID_ADConv1   	=	SID + $19
SID_ADConv2   	=	SID + $1A

CIA1_DDRA	=	$DC02
CIA1_DDRB	=	$DC03
CIA1_PRB	=	$DC01

DirectionTemp	=	r4H
XPosNew		=	r5
YPosNew		=	r6
XPosPending	=	r7
YPosPending	=	r8
XDirection	=	r9L
YDirection	=	r9H
OldPotX		=	r10L	; Old hw counter values
OldPotY		=	r10H
Buttons		=	r11L	; button status bits
ButtonsOld	=	r11H
;ButtonLClick	=	r12L
;ButtonRClick	=	r12H

VarBuffer:	.repeat 15
			.byte	0
		.endrep


;mouseCheck:	.byte		$00

_MouseInit:
	lda	#8
	sta	mouseXPos
	sta	mouseYPos
	lda	#0
	sta	mouseXPos+1
_SlowMouse:
	rts

_UpdateMouse:
	jsr UM_END

	bbsf MOUSEON_BIT, mouseOn, UM_1
	jmp UM_END

UM_1:
	MoveW	mouseXPos, XPosNew
	MoveB	mouseYPos, YPosNew
	MoveB	r3H, YPosNew+1

	PushB CPU_DATA
	LoadB CPU_DATA, IO_IN
	PushW cia1base+2
	PushB cia1base+0

; Record the state of the buttons.
; Avoid crosstalk between the keyboard and the mouse.
	LDY	#%00000000		    ;Set ports A and B to input
	STY	CIA1_DDRB
	STY	CIA1_DDRA			;Keyboard won't look like mouse
	LDA	CIA1_PRB			 ;Read Control-Port 1
	;DEC	CIA1_DDRA			;Set port A back to output
	;STA	Buttons
	;EOR	#%11111111		    ;Bit goes up when button goes down
	;BEQ	@L0				 ;(bze)
	;DEC	CIA1_DDRB			;Mouse won't look like keyboard
	;STY	CIA1_PRB			 ;Set "all keys pushed"

@L0:
	JSR	ButtonCheck

	LDA	SID_ADConv1		   ;Get mouse X movement
	;LDY	flgMse1351
	;BEQ	@full_x

	AND	#$7E

@full_x:
	LDY	OldPotX
	JSR	MoveCheck			;Calculate movement vector
	STY	OldPotX

; Skip processing if nothing has changed
	BCC	@SkipX

; Calculate the new X coordinate (--> a/y)
	ASL
	PHA
	TXA
	ROL
	TAX
	PLA

	CLC
	ADC	XPosNew

	TAY					    ;Remember low byte
	TXA
	ADC	XPosNew+1

; Limit the X coordinate to the bounding box

	;CPY	#0
	;SBC	#0
	BPL	@L1
	;LDA	#0
	;TAY
	;BRA	@L2
@L1:
	;TXA

	;CPY	screenMaxX
	;SBC	screenMaxX+1
	;BMI	@L2
	;LDY	screenMaxX
	;LDX	screenMaxX+1
@L2:
	STY	XPosNew
	STA	XPosNew+1
	jsr 	historesisCheck

; Move the mouse pointer to the new X pos

	TYA
	;JSR	CMOVEX

	;LDA	mouseCheck
	;BNE	@SkipX

	;LDA	#$01
	;STA	mouseCheck

; Calculate the Y movement vector

@SkipX:
	LDA	SID_ADConv2		   ;Get mouse Y movement
	;LDY	flgMse1351
	;BEQ	@full_y

	AND	#$7E

@full_y:
	LDY	OldPotY
	JSR	MoveCheck			;Calculate movement
	STY	OldPotY

; Skip processing if nothing has changed

	BCC	@SkipY

; Calculate the new Y coordinate (--> a/y)

	ASL
	PHA
	TXA
	ROL
	TAX
	PLA

	STA	r1L
	LDA	YPosNew
	SEC
	SBC	r1L

	TAY
	STX	r1L
	LDA	YPosNew+1
	SBC	r1L
	;TAX

; Limit the Y coordinate to the bounding box

	;CPY	#0
	;SBC	#0
	BPL	@L3
	LDA	#0
	TAY
	;BRA	@L4
@L3:
	;TXA

	;CPY	screenMaxY
	;SBC	screenMaxY+1
	;BMI	@L4
	;LDY	screenMaxY
	;LDX	screenMaxY+1
@L4:
	STY	YPosNew
	STA	YPosNew+1

	jsr 	historesisCheck

; Move the mouse pointer to the new Y pos

	TYA
	;JSR	CMOVEY

	;LDA	mouseCheck
	;BNE	@SkipY

	;LDA	#$01
	;STA	mouseCheck

; Done

@SkipY:
	PopB cia1base
	PopW cia1base+2
	PopB	CPU_DATA

UM_END:
	ldx	#15
@10:
	lda	VarBuffer,x
	tay
	lda	r4H,x
	sta	VarBuffer, x
	tya
	sta	r4H,x
	dex
	bne	@10

	rts

historesisCheck:
	;; Dont actually update mouse unless it has moved more than 1 px in the same direction

	lda XPosNew
	cmp XPosPending
	bne @XChanged
	lda XPosNew+1
	cmp XPosPending+1
	beq @updatedXDirection
@XChanged:
	;;  Get sign of difference between XPos and XPosNew
	lda XPosNew
	sta XPosPending
	lda XPosNew+1
	sta XPosPending+1

	lda XPosNew
	sec
	sbc XPosPending
	lda XPosNew+1
	sbc XPosPending+1

	;; Is the direction different to last time?
	and #$80
	sta DirectionTemp
	eor XDirection
	bne @UpdateXDirection
	;; Direction same, so update X position
	lda mouseXPos+1
	and #$F0
	ora XPosNew+1
	sta mouseXPos+1
	lda XPosNew
	sta mouseXPos
	bra @updatedXDirection
@UpdateXDirection:
	;;  Don't update X, but do update the direction of last movement
	lda DirectionTemp
	sta XDirection
@updatedXDirection:

	lda YPosNew
	cmp YPosPending
	bne @YChanged
	lda YPosNew+1
	cmp YPosPending+1
	beq @updatedYDirection
@YChanged:

	;;  Get sign of difference between YPos and YPosNew
	lda YPosNew
	sta YPosPending
	lda YPosNew+1
	sta YPosPending+1

	lda YPosNew
	sec
	sbc YPosPending
	lda YPosNew+1
	sbc YPosPending+1

	;; Is the direction different to last time?
	and #$80
	sta DirectionTemp
	eor YDirection
	bne @UpdateYDirection
	;; Direction same, so update Y position
	lda YPosNew+1
	sta r3H
	lda YPosNew
	sta mouseYPos
	bra @updatedYDirection
@UpdateYDirection:
	;;  Don't update Y, but do update the direction of last movement
	lda DirectionTemp
	sta YDirection
@updatedYDirection:

	rts

;-------------------------------------------------------------------------------
ButtonCheck:
;-------------------------------------------------------------------------------
	;LDA	Buttons
	and 	#$10
	CMP	ButtonsOld
	BEQ	@done
	STA	ButtonsOld
	asl
	asl
	asl
	sta 	mouseData

	; left button state changed
	smbf 	MOUSE_BIT, pressFlag

.if 0
	AND	#buttonLeft
	BNE	@testRight

	LDA	ButtonsOld
	AND	#buttonLeft
	BEQ	@testRight

	LDA	#$01
	STA	ButtonLClick
.endif

@testRight:
.if 0
	AND	#buttonRight
	BNE	@done

	LDA	ButtonsOld
	AND	#buttonRight
	BEQ	@done

	LDA	#$01
	STA	ButtonRClick
.endif

@done:
	RTS

;-------------------------------------------------------------------------------
MoveCheck:
; Move check routine, called for both coordinates.
;
; Entry:	   y = old value of pot register
;			a = current value of pot register
; Exit:	    y = value to use for old value
;			x/a = delta value for position
;-------------------------------------------------------------------------------
	STY	r0L
	STA	r0H
	LDX	#$00

	SEC				; a = mod64 (new - old)
	SBC	r0L

	cmp #$3f
	bcs @notPositiveMovement
	LDY r0H
	LDX #0
	SEC
	RTS
@notPositiveMovement:
	cmp #$c0
	bcc @notNegativeMovement
	LDY	r0H
	ldx #$ff
	SEC
	RTS

@notNegativeMovement:
	ldy r0H
	TXA					    ; A = $00
	CLC
	RTS
