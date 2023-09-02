.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"
.include "geosmac.inc"


.export __STARTUP_RUN__

.segment "STARTUP"

DateTimeString:
		.byte	PLAINTEXT
TagZehner:	.byte	"0"
		.byte	PLAINTEXT
TagEiner:	.byte	"0"
		.byte	PLAINTEXT
		.byte	"."
		.byte	PLAINTEXT
MonZehner:	.byte	"0"
		.byte	PLAINTEXT
MonEiner:	.byte	"0"
		.byte	PLAINTEXT
		.byte	"."
		.byte	PLAINTEXT
JahZehner:	.byte	"0"
		.byte	PLAINTEXT
JahEiner:	.byte	"0"
		.byte	PLAINTEXT
		.byte	"  "
		.byte	PLAINTEXT
StdZehner:	.byte	"0"
		.byte	PLAINTEXT
StdEiner:	.byte	"0"
		.byte	PLAINTEXT
		.byte	":"
		.byte	PLAINTEXT
MinZehner:	.byte	"0"
		.byte	PLAINTEXT
MinEiner:	.byte	"0"
		.byte	PLAINTEXT
		.byte	":"
		.byte	PLAINTEXT
SecZehner:	.byte	"0"
		.byte	PLAINTEXT
SecEiner:	.byte	"0"
		.byte	PLAINTEXT
		.byte	"  "
		.byte	NULL

__STARTUP_RUN__:
		lda	firstBoot
		cmp	#$FF
		bne	@1

		; show dialog to operate the mounts
		LoadW	r0, SelectDialog
		jsr	DoDlgBox

		jmp	EnterDeskTop

@1:		jsr	GetRTC
		bcs	@2	; branch if no valid GetRTC

		jsr	SetTime
@2:
		jmp	EnterDeskTop


GetRTC:
		; check if clock is running by checking
		; if seconds are changing for 3s
		LoadW	r0, $7110
		LoadW	r1, $0FFD

		jsr	GetLongUnbounced
		sta	MySec
		cli	; enable interrupts to operate dblClickCount
		lda	#30
		sta	dblClickCount
@1:
		jsr	GetLongUnbounced

		ldx	dblClickCount
		beq	@2
		cmp	MySec
		beq	@1

		; seconds changed, so read the rtc time now
		inc	r0L
		jsr	GetLongUnbounced
		sta	MyMin

		inc	r0L
		jsr	GetLongUnbounced
		sta	MyStd

		and	#$80
		beq	@10		; branch if 12h time

		lda	MyStd
		and	#$3F
		sta	MyStd
		bra	@20
@10:
		lda	MyStd
		and	#$20
		beq	@30

		; pm
		PushW	r0
		PushW	r1
		lda	MyStd
		and	#$1F
		jsr	BcdToDec

		clc
		adc	#12
		jsr	DezBCD
		sta	MyStd

		PopW	r1
		PopW	r0
		bra	@20

@30:		; am
		lda	MyStd
		and	#$1F
		sta	MyStd
@20:
		inc	r0L
		jsr	GetLongUnbounced
		sta	MyTag

		inc	r0L
		jsr	GetLongUnbounced
		sta	MyMonat

		inc	r0L
		jsr	GetLongUnbounced
		sta	MyJahr

		clc
		rts
@2:
		sec     ; signal error
		rts

SetRTC:
		LoadW	r0, $7118
		LoadW	r1, $0FFD

		jsr	GetLongUnbounced
		pha
		lda	#$41
		jsr	SetLong
		jsr	Wait

		LoadW	r0, $7110
		LoadW	r1, $0FFD

		; enable setting the RTC

		lda	MySec	;s
		jsr	SetLong
		jsr 	Wait

		lda	MyMin	;m
		inc	r0L
		jsr	SetLong
		jsr 	Wait

		inc	r0L

		;lda	MyStd	;h
		jsr	GetLongUnbounced
		and	#$80
		beq	@10

		lda	MyStd
		ora	#$80
		bra	@30
@10:
		LoadB	r2L, 0
		PushW	r0
		PushW	r1
		lda	MyStd
		jsr	BcdToDec
		cmp	#12
		blt	@31
		sec
		sbc	#12
		tax
		LoadB	r2L, $20
		txa
@31:
		jsr	DezBCD
		tax
		PopW	r1
		PopW	r0
		txa
		ora	r2L
@30:
		jsr	SetLong
		jsr 	Wait

		lda	MyTag	;d
		inc	r0L
		jsr	SetLong
		jsr 	Wait

		lda	MyMonat	;m
		inc	r0L
		jsr	SetLong
		jsr 	Wait

		lda	MyJahr	;y
		inc	r0L
		jsr	SetLong
		jsr 	Wait

		lda	#$02	;wd
		inc	r0L
		jsr	SetLong
		jsr 	Wait

		lda	#$02	;ids
		inc	r0L
		jsr	SetLong
		jsr 	Wait

		pla
		inc	r0L
		jsr	SetLong
		jsr 	Wait

		rts

SetTime:
		jsr	RunClock
		rts

GetTime:
		MoveW_	keyVector,Oldkey
		LoadW	keyVector,Mykey
		ldx	#0
		stx	TabZeiger
		LoadB	TagZehner-1,REV_ON
		jsr	ShowClock
@20:		rts

Oldkey:		.word	0


; Mykey
Mykey:		lda	keyData
		cmp	Obergrenze
		bgt	@5
		cmp	#$30
		blt	@5
		pha
		jsr	SetPlain
		pla
		sta	TagZehner,x
		jmp	@7
@5:		cmp	#KEY_RIGHT
		bne	@10
		jsr	SetPlain
@7:		iny
		cpy	#12
		bne	@15
		ldy	#0
@15:		jmp	SetRev
@10:		cmp	#KEY_DELETE
		beq	@11
		cmp	#KEY_LEFT
		bne	@100
@11:		jsr	SetPlain
		dey
		bpl	@25
		ldy	#9
@25:		jmp	SetRev
@100:		cmp	#CR
		bne	@1000
		jsr	SetPlain
		jsr	GetTimeString
		jsr	TestTime
		beq	@120
		tya
		pha
		lda	#2
		jsr	Beep
		pla
		tay
		jmp	SetRev
@120:		jsr	RunClock
		jsr	ShowClock
		;jsr	MouseUp
		;ldx	#1
		;jsr	UnblockProcess
		MoveW_	Oldkey,keyVector
		;LoadB	ModDepth,0
		jsr	SetRTC
		jsr	RstrFrmDialogue
@1000:		rts


SetPlain:
		ldy	TabZeiger
		ldx	RevTab,y
		lda	#PLAINTEXT
		sta	TagZehner-1,x
		rts

SetRev:
		ldx	RevTab,y
		lda	#REV_ON
		sta	TagZehner-1,x
		sty	TabZeiger
		jsr	SetTime
		jsr	DoneWithIO
		jsr	SetObUn
		jmp	ShowClock

SetObUn:
		ldy	TabZeiger
		lda	ObTab,y
		sta	Obergrenze
		rts

ObTab:		.byte	$33,$39,$31,$39
		.byte	$39,$39,$32,$39,$35,$39, $35,$39

; TestTime
; ]berpr}fung
; return
; a = 0 OK
; a = $ff false; y Wert f}r TabZeiger

TestTime:
		lda	MyTag
		jsr	BcdToDec
		cmp	#0
		bne	@10
		ldy	#1
@00:
		lda	#$ff
		rts
@10:		cmp	#32
		blt	@05
		ldy	#0
		beq	@00

@05:		lda	MyMonat
		jsr	BcdToDec
		cmp	#0
		bne	@20
@31:		ldy	#3
		bne	@00
@20:		cmp	#13
		blt	@30
		ldy	#2
		bne	@00
@30:		cmp	#2	; Feb
		bne	@40
		lda	MyTag
		jsr	BcdToDec
		cmp	#29
		beq	@35
		bgt	@31
		jmp	@th
@35:		lda	MyJahr
		jsr	BcdToDec
		ror		; /2
		bcc	@32
@33:		ldy	#1
		jmp	@00
@32:		ror		; /4
		bcs	@33
		jmp	@th
@40:		cmp	#8
		bge	@45
		ror
		bcc	@42
@43:		jmp	@th	; ungerade
@42:		lda	MyTag
		jsr	BcdToDec
		cmp	#31
		bne	@43
		ldy	#1
		jmp	@00
@45:		ror
		bcs	@42
@th:		clc
		lda	MyStd
		jsr	BcdToDec
		cmp	#24
		bge	@th1
		lda	#$00
		rts
@th1:		ldy	#6
		jmp	@00

; Beep
; a - Anzahl Beep
Beep:		sta	@AnzBeep
		lda 	#$0f
		jsr	InitForIO
		sta 	$d418
		lda 	#$00
		sta 	$d405
		lda 	#$f7
		sta 	$d406
		lda 	#$11
		sta 	$d404
		lda 	#$32
		sta 	$d401
		lda 	#$00
		sta 	$d400
@10:		lda	#$0f
		sta	$d418
		jsr	@Wait
		lda 	#$00
		sta 	$d418
		jsr	@Wait
		dec	@AnzBeep
		bne	@10
		lda 	#$10
		sta 	$d404
		lda 	#$00
		sta 	$d418
		jsr	DoneWithIO
		rts
@Wait:
		jsr	DoneWithIO
		ldx	#3
		stx	dblClickCount
@20:
		ldx	dblClickCount
		bne	@20
		jsr	InitForIO
		rts
@AnzBeep:	.byte	2

TabZeiger:
		.byte	0
RevTab:
		.byte	0,2,6,8,12,14
		.byte	19,21,25,27,31,33

Obergrenze:
		.byte	"3"

SelectDialog:
		.byte	$81	; standard dialog, light bachground

		.byte	DBTXTSTR
		.byte	10, 25
		.word	Text1

		.byte	CANCEL
		.byte	17, 70

		.byte	DB_USR_ROUT
		.word	DrawDialog

		.byte	NULL

Text1:
		.byte	BOLDON, "Set RTC and system date/time:", NULL

EntryX:
		WordCX	%101100000000 | ((-96+24) & $FF), %101100000000 | ((-48+50) & $FF)
EntryY:
		ByteCY	%101100000000 | ((-96+24) & $FF), %101100000000 | ((-48+50) & $FF)


DrawDialog:
		jsr	GetDateTimeString
		jsr	GetTime

ShowClock:
		LoadW	r0, DateTimeString

		MoveW	EntryX, r11
		MoveB	EntryY, r1H
		jsr	PutString
		rts


GetDateTimeString:
		jsr	GetRTC
		bcc	@2

		; init from GEOS time
		lda	day
		jsr	DezBCD
		sta	MyTag
		lda	month
		jsr	DezBCD
		sta	MyMonat
		lda	year
		jsr	DezBCD
		sta	MyJahr
		lda	hour
		jsr	DezBCD
		sta	MyStd
		lda	minutes
		jsr	DezBCD
		sta	MyMin
		lda	seconds
		jsr	DezBCD
		sta	MySec
@2:
		ldx	MyTag
		lda	#TagZehner-TagZehner
		jsr	DivnSet
		ldx	MyMonat
		lda	#MonZehner-TagZehner
		jsr	DivnSet
		ldx	MyJahr
		lda	#JahZehner-TagZehner
		jsr	DivnSet
		ldx	MyStd
		lda	#StdZehner-TagZehner
		jsr	DivnSet
		ldx	MyMin
		lda	#MinZehner-TagZehner
		jsr	DivnSet
		ldx	MySec
		lda	#SecZehner-TagZehner
		jsr	DivnSet

		rts

Wait:
		LoadW	r2, $71FF
		LoadW	r3, $0FFD

@10:
		LDZ	#0
		EOM
		lda 	(r2), Z
		bne	@10

		rts

GetLongUnbounced:
		LDZ	#0
		EOM
		lda 	(r0), Z
		EOM
	 	cmp	(r0), Z
		bne 	GetLongUnbounced
		EOM
	 	cmp	(r0), Z
		bne 	GetLongUnbounced
		rts

SetLong:
		LDZ	#0
		EOM
		sta 	(r0), Z
		RTS

DivnSet:	pha
		txa
		lsr
		lsr
		lsr
		lsr
		sta	r0L
		txa
		and	#$0F
		sta	r8L
		pla
		tax
		lda	r0L
		clc
		adc	#$30
		sta	TagZehner,x
		inx
		inx
		lda	r8L
		adc	#$30
		sta	TagZehner,x
		rts

MyJahr:		.byte	0
MyMonat:	.byte	0
MyTag:		.byte	0
MyStd:		.byte	0
MyMin:		.byte	0
MySec:		.byte 	0


DPA	= $dc00
ampm:		.byte	0

GetTimeString:
		lda	TagZehner
		ldx	TagEiner
		jsr	ASCBCD
		sta	MyTag

		lda	MonZehner
		ldx	MonEiner
		jsr	ASCBCD
		sta	MyMonat

		lda	JahZehner
		ldx	JahEiner
		jsr	ASCBCD
		sta	MyJahr

		lda	StdZehner
		ldx	StdEiner
		jsr	ASCBCD
		sta	MyStd

		lda	MinZehner
		ldx	MinEiner
		jsr	ASCBCD
		sta	MyMin

		lda	SecZehner
		ldx	SecEiner
		jsr	ASCBCD
		sta	MySec

		rts

SetTime2:
		jsr	InitForIO

		lda	MyTag
		jsr	BcdToDec
		sta	day

		lda	MyMonat
		jsr	BcdToDec
		sta	month

		lda	MyJahr
		jsr	BcdToDec
		sta	year

		LoadB	ampm,0
		lda	MyStd
		jsr	BcdToDec

		cmp	#24	; accept 24 to be 0 o'clock
		bne	@ci
		lda	#0
@ci:		sta	hour

		cmp	#12
		blt	@am
		pha
		LoadB	ampm,$80
		pla
		sec
		sbc	#12

@am:		jsr	DezBCD
		clc
		adc	ampm
		sta	DPA+$0b

		lda	MyMin
		jsr	BcdToDec
		sta	minutes
		jsr	DezBCD
		sta	DPA+$0a

		lda	MySec
		jsr	BcdToDec
		sta	seconds
		jsr	DezBCD
		sta	DPA+$09

		rts

RunClock:
		jsr	SetTime2
		lda	#$00
		sta	DPA+$08
		jsr	DoneWithIO
		rts
;ASCBCD
; a High
; x Low
; Return a

ASCBCD:
		asl
		asl
		asl
		asl
		sta	r0L
		txa
		and	#$0f
		ora	r0L
		rts

DezBCD:
		sta	r0L
		LoadB	r0H,0
		ldx	#r0L
		LoadW	r1,10
		ldy	#r1L
		jsr	Ddiv
		lda	r0L
		asl
		asl
		asl
		asl
		clc
		adc	r8L
		rts

BcdToDec:
		tax
		and	#$0F
		sta	r0L
		txa
		and	#$F0
		lsr
		; by 8 plus by 2
		sta	r0H
		lsr
		lsr
		clc
		adc	r0H
		clc
		adc	r0L

		rts
