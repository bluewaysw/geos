;	n	"DeskWin $400"
;	c	"Windows     V1.0"
;	a	"Walter Knupe"
;	o	$400
;	f	3 	; DATA

;if .p
;	t	"TopSym"
;	t	"TopMac"
;	t	"Sym128.erg"
;	t	"CiSym"
;	t	"CiMac"
;endif

Grenze_oben	= 15
GD_CLOSE	= $02
GD_HIDE	= $40
GD_MAX	= $04
GD_MOVE	= $01
GD_SCROLL_LR	= $10
GD_SCROLL_UD	= $20
GD_SIZE	= $08
WN_REDRAW	= $01
WN_MOVE	= $02
WN_SIZE	= $03
WN_CLOSE	= $04
WN_MAX	= $05
WN_ACTIVATE	= $06
WN_RESTORE	= $07
WN_SCROLL_R	= $08
WN_SCROLL_L	= $09
WN_SCROLL_U	= $0a
WN_SCROLL_D	= $0b
WN_HIDE	= $0c
WN_USER	= $0d
WN_ACTIVATE2	= $0e

PruefSumme:	.word	0
RamStart:	LoadB	MyCurRec,0
	lda	#10
	jsr	GetModule
	MoveW_	ModStartAdress,r0
	AddVW__	3,r0
	jmp	(r0)

MyName:	.byte	"Dos",0,0,0,0,0,0,0,0,0,0,0,0,0
.ifdef topdesk128
.ifdef topdesk13
.ifdef mega65
MyClass:	.byte	"TopDesk65   V1.3",0
.else
MyClass:	.byte	"TopDesk128  V1.3",0
.endif
.else
MyClass:	.byte	"TopDesk128  V1.2",0
.endif

.else
.ifdef topdesk13
MyClass:	.byte	"TopDesk     V1.3",0
.else
MyClass:	.byte	"TopDesk     V1.2",0
.endif
.endif
MyCurRec:	.byte	0
ghostFile:	.byte	0

ModStartAdress:	.word	0
SearchDeskTop:	jmp	SearchDeskTop2
GetModule:	cmp	MyCurRec
	beq	@10
	pha
	jsr	SearchDeskTop
	bcc	@20
	pla
	rts
@20:	LoadW___	r0,MyName
	jsr	OpenRecordFile
	pla
	sta	MyCurRec
	jsr	PointRecord
	MoveW_	ModStartAdress,r7
	LoadW___	r2,$2000
	jsr	ReadRecord
@10:	clc
	rts
SearchDeskTop2:	MoveB	curDrive,@a
@loop:	jsr	OpenDisk
	LoadW___	r6,MyName
	jsr	FindFile
	jsr	TestDisk
	ldx	numDrives
	dex
	beq	@40
	lda	curDrive
	tax
	sec
	sbc	#7
	cmp	$848d
	bne	@30
	ldx	#07
@30:	inx
	txa
	pha
	jsr	__NewSetDevice
	pla
	cmp	@a
	bne	@loop
@40:	LoadW___	r0,@db
	jsr	NewDoDlgBox
	lda	r0L
	cmp	#1
	bne	@50
	jmp	SearchDeskTop
@50:	sec
	rts
@a:	.byte	$08
@db:	.byte	$81
	.byte	$0b,$10,$10
	.word	@t1
	.byte	$0b,$10,$20
	.word	@t2
	.byte	OK,2,72,CANCEL,14,72,NULL
@t1:	.byte	"Bitte eine Diskette mit",0
@t2:	.byte	"TopDesk einlegen!",0

TestDisk:	txa
	beq	@10
	rts
@10:	MoveW_	$8400+19,r1
	LoadW___	r4,$8000
	jsr	GetBlock
	ldy	#0
@tloop: lda	MyClass,y
	beq	@t20
	cmp	$804d,y
	bne	@t30
	iny
	bne	@tloop
@t20:	pla
	pla
@t30:	clc
	rts

; Systemvariablen
activeWindow:	.byte	0,2,3,1
messageBuffer:		
	.repeat	10
	.byte 0
	.endrep
backPattern:	.byte 2
curWinData:	.word	0
windowsOpen: 	.byte 0, 0, 0, 0
newAppMain:	.word	0
iconTab:	.word	0
NameIndex:	.byte 0, 0, 0, 0

.ifdef topdesk128
RightMax:   .word   639
GraphIndex: .byte   1
.endif

DoWindows:	lda	curWinData
	ora	curWinData+1
	beq	@10
	MoveW_	curWinData,a0
	bne	@20
@10:	lda	r0L
	sta	a0L
	sta	curWinData
	lda	r0H
	sta	a0H
	sta	curWinData+1
	lda	#0
	sta	windowsOpen
	sta	windowsOpen+1
	sta	windowsOpen+2
	sta	windowsOpen+3
@20:	MoveW_	appMain,newAppMain
	LoadW___	appMain,MyAppMain
	MoveW_	mouseVector,oldMsVec
	LoadW___	mouseVector,NewMouseService
	MoveW_	RecoverVector,oldRecoverVec
	LoadW___	RecoverVector,MyRecoverService
	rts
.if 0
DoneWindows:
	; Zur}cksetzung des Systems
	MoveW_	newAppMain,appMain
	MoveW_	oldMsVec,mouseVector
	MoveW_	oldRecoverVec,RecoverVector
	rts
.endif
MyAppMain:	LoadW___	mouseVector,NewMouseService
	jsr	MaxTextWin
	jsr	AppMoveFrame
	lda	newAppMain
	ldx	newAppMain+1
	jmp	CallRoutine
GetWinAdrRecImp:	jsr	GetWinAdrRec
	jmp	ImprintRectangle
GetWinAdrRec:	jsr	GetWinAdr
	jmp	GetWinRec
GetWinAdr:
	; Umrechnung: WindowNummer nach Speicheradresse
	; Par:	Nummer (0-3) in x.
	; Ret:	Adresse in a0
	; Des:	a
	lda	winOffs,x
	clc
	adc	curWinData
	sta	a0L
	lda	curWinData+1
	adc	#00
	sta	a0H
	rts
winOffs:	.byte	0*11,1*11,2*11,3*11

GetWinRec3:	lda	#a4L
	.byte	$2c
GetWinRec:	; ]bertragung des Window-Rechtecks nach r2-r4
	; Parameter:	Window-Datenadresse in a0
	; zur}ck:	r2-r4 : Window-Rechteck
	; zerst|rt:	a,y
	lda	#r2L
	.byte	$2c	; Skip
GetWinRec2:	; ]bertragung des Window-Rechtecks nach r5-r7
	; Parameter:	Window-Datenadresse in a0
	; zur}ck:	r5-r7 : Window-Rechteck
	; zerst|rt:	a,y
	lda	#r5L
	sta	@des+1
	ldy	#5
@10:	lda	(a0),y
@des:	sta	r2L,y
	dey
	bpl	@10
	rts
GetClipRec:	ldy	#5
@loop:	lda	windowTop,y
	sta	r5L,y
	dey
	bpl	@loop
	rts
NoClipFlag:	.byte	0
BREITE	= 10
DrawWindow2:	; Par: a4-a6: Window-Rechteck
	ldy	#5
@loop0:	lda	a4L,y
	sta	r2L,y
	dey
	bpl	@loop0
	lda	#0
	sta	NoClipFlag
	jsr	SetPattern
	jsr	GetClipRec
	jsr	CutRec
	bcc	@n10
	rts
@n10:	ldy	#5
@nloop:	lda	r2L,y
	cmp	a4L,y
	bne	@n20
	dey
	bpl	@nloop
	LoadB	NoClipFlag,1
@n20:	jsr	Rectangle
	LoadW___	a1,WindowData
@loop2:	MoveB	a2H,r11L
	MoveW_	a3,r3
	ldy	#2
@loop:	lda	(a1),y
	sta	a2H,y
	dey
	bpl	@loop
	lda	a3H
	cmp	#$ff
	bne	@05
	clc
	rts
@05:	tax
	and	#%11100000
	sta	a2L
	txa
	and	#%00011111
	sta	a3H
	bit	a2L
	bvs	@rechts
@links:	AddW	a5,a3
	jmp	@10
@rechts:	lda	a6L
	sec
	sbc	a3L
	sta	a3L
	lda	a6H
	sbc	a3H
	sta	a3H
@10:	bit	a2L
	bmi	@unten
@oben:	AddB_	a4L,a2H
	jmp	@20
@unten:	lda	a4H
	sec
	sbc	a2H
	sta	a2H
@20:	lda	a2L
	and	#%00100000
	bne	@line
	jmp	@weiter
@line:	MoveW_	a3,r4
	MoveB	a2H,r11H
	lda	NoClipFlag
	bne	@l40
	; ins ClipRect einpassen
	lda	r11H
	sta	r2L
	sta	r2H
	lda	r11L
	cmp	r11H
	bcc	@l10
	sta	r2H
	bcs	@l20
@l10:	sta	r2L
@l20:	lda	r3L
	sec
	sbc	r4L
	lda	r3H
	sbc	r4H
	bmi	@l30
	ldx	r3L
	MoveB	r4L,r3L
	stx	r4L
	ldx	r3H
	MoveB	r4H,r3H
	stx	r4H
@l30:	MoveW_	r2,r11
	jsr	GetClipRec
	jsr	CutRec
	bcs	@weiter
	MoveW_	r2,r11
	lda	r11L
	cmp	r11H
	bne	@l40
	lda	r3L
	cmp	r4L
	bne	@l40
	lda	r3H
	cmp	r4H
	bne	@l40
	lda	#0
	sec
	jsr	DrawPoint
	jmp	@weiter
@l40:	lda	#0
	sec
	jsr	DrawLine
@weiter:	lda	a1L
	clc
	adc	#3
	sta	a1L
	bcc	@30
	inc	a1H
@30:	jmp	@loop2

.macro Punkt x0, y0, b6, b7, b5
	.byte	y0
	.word	x0+b6*$4000+b7*$8000+b5*$2000
.endmacro

WindowData:	; LinienEndpunkte in Abh{ngigkeit von den Endpunkten
	; xk: Bit 7:	0 - oberer Eckpunkt
	;	1 - unterer Eckpunkt
	;     Bit 6:	0 - linker Eckpunkt
	; 	1 - rechter Eckpunkt
	;     Bit 5:	0 - nur neuer Ansatzpunkt
	; 	1 - Linienendpunkt & neuer Ansatzpunkt
	Punkt	0,0,0,0,0	; Rahmen
	Punkt	0,0,1,0,1
	Punkt	0,0,1,1,1
	Punkt	0,0,0,1,1
	Punkt	0,0,0,0,1
	Punkt	0,BREITE,0,0,0	; Titelrahmen
	Punkt	0,BREITE,1,0,1
	Punkt	0,BREITE,0,1,0	; unterer Rahmen
	Punkt	0,BREITE,1,1,1
	Punkt	BREITE,0,1,0,0	; rechter Rahmen eischl. Gadgetrahmen r
	Punkt	BREITE,0,1,1,1
	Punkt	BREITE,0,0,0,0	; Gadgetrahmen lo
	Punkt	BREITE,BREITE,0,0,1
	Punkt	0,BREITE,0,1,0
	Punkt	BREITE,BREITE,0,1,1	; Gadgetrahmen lu

	Punkt	4,4,0,0,0	; CloseGadget
	Punkt	6,4,0,0,1
	Punkt	6,6,0,0,1
	Punkt	4,6,0,0,1
	Punkt	4,4,0,0,1

	Punkt	2*BREITE,0,1,0,0	; Hide-Gadget
	Punkt	2*BREITE,BREITE,1,0,1
	Punkt	2*BREITE-2,2,1,0,0
	Punkt	BREITE+4,2,1,0,1
	Punkt	BREITE+4,BREITE-4,1,0,1
	Punkt	2*BREITE-2,BREITE-4,1,0,1
	Punkt	2*BREITE-2,2,1,0,1
	Punkt	2*BREITE-4,4,1,0,0
	Punkt	BREITE+2,4,1,0,1
	Punkt	BREITE+2,BREITE-2,1,0,1
	Punkt	2*BREITE-4,BREITE-2,1,0,1
	Punkt	2*BREITE-4,4,1,0,1
	Punkt	2*BREITE-5,5,1,0,0
	Punkt	BREITE+3,5,1,0,1
	Punkt	BREITE+3,BREITE-3,1,0,1
	Punkt	2*BREITE-5,BREITE-3,1,0,1
	Punkt	2*BREITE-5,5,1,0,1
	Punkt	BREITE-2,2,1,0,0	; Max-Gadget
	Punkt	2,2,1,0,1
	Punkt	2,BREITE-2,1,0,1
	Punkt	BREITE-2,BREITE-2,1,0,1
	Punkt	BREITE-2,2,1,0,1
	Punkt	6,BREITE+3,1,0,0	; Pfeil nach oben
	Punkt	6,BREITE+7,1,0,1
	Punkt	4,BREITE+7,1,0,1
	Punkt	4,BREITE+3,1,0,1
	Punkt	5,BREITE+2,1,0,0
	Punkt	5,BREITE+6,1,0,1
	Punkt	7,BREITE+4,1,0,0
	Punkt	3,BREITE+4,1,0,1
	Punkt	6,BREITE+3,1,1,0	; Pfeil nach unten
	Punkt	6,BREITE+7,1,1,1
	Punkt	4,BREITE+7,1,1,1
	Punkt	4,BREITE+3,1,1,1
	Punkt	5,BREITE+2,1,1,0
	Punkt	5,BREITE+6,1,1,1
	Punkt	7,BREITE+4,1,1,0
	Punkt	3,BREITE+4,1,1,1
	Punkt	BREITE-2,2,1,1,0	; Size-Gadget
	Punkt	2,2,1,1,1
	Punkt	2,BREITE-2,1,1,1
	Punkt	BREITE-2,BREITE-2,1,1,1
	Punkt	BREITE-2,2,1,1,1
	Punkt	BREITE-5,BREITE-2,1,1,0
	Punkt	BREITE-5,BREITE-5,1,1,1
	Punkt	BREITE-2,BREITE-5,1,1,1
	Punkt	3,6,0,1,0	; Pfeil nach links
	Punkt	7,6,0,1,1
	Punkt	7,4,0,1,1
	Punkt	3,4,0,1,1
	Punkt	2,5,0,1,0
	Punkt	6,5,0,1,1
	Punkt	4,7,0,1,0
	Punkt	4,3,0,1,1
	Punkt	BREITE+3,6,1,1,0	; Pfeil nach rechts
	Punkt	BREITE+7,6,1,1,1
	Punkt	BREITE+7,4,1,1,1
	Punkt	BREITE+3,4,1,1,1
	Punkt	BREITE+2,5,1,1,0
	Punkt	BREITE+6,5,1,1,1
	Punkt	BREITE+4,7,1,1,0
	Punkt	BREITE+4,3,1,1,1
	Punkt	-1,0,0,0,0	; Ende

MaxTextWin:	; Ret: x unver{ndert
.ifdef topdesk128
	ldy	#3
.else
	ldy	#5
.endif
@10:	lda	@b,y
	sta	windowTop,y
	dey
	bpl	@10
.ifdef topdesk128
	MoveW_  RightMax, rightMargin
.endif
	rts
@b:	.byte	0,199
.ifdef topdesk128
    .byte   0, 0
.else
	.word	0,319
.endif
SetTextWin:	; Par: r2-r4 zu setzendes Textfenster
	jsr	GetClipRec
	jsr	CutRec
	bcs	@end
	ldy	#5
@loop:	lda	windowTop,y
	sta	OldClip,y
	lda	r2L,y
	sta	windowTop,y
	dey
	bpl	@loop
	clc
@end:	rts
RestoreTextWin:	ldy	#5
@loop:	lda	OldClip,y
	sta	windowTop,y
	dey
	bpl	@loop
	rts

OldClip:	.word	0,0,0
BREITEX	= BREITE	; Mu~ durch 2 teilbar sein!
BREITEY	= BREITEX	; Mu~ durch 2 teilbar sein!
DrawWindow:	;Darstellung eines Windows.
	; Parameter:	Window-Nummer in x
	; Zur}ck:	---
	; Zerst|rt:	a,x,y,a1 .....

DrawWindowB:	cpx	activeWindow
	bne	DrawWindowC
	jsr	MaxTextWin
	lda	#0
	.byte	$2c
DrawWindowC:	lda	#1
	sta	@flag
	stx	@num
	jsr	GetWinAdr
	jsr	GetWinRec3
	jsr	DrawWindow2
	bcc	@geht
	rts
@geht:	MoveB	a4L,r2L	; Textfenster f}r Titelstring setzen
	clc
	adc	#BREITEY-1
	sta	r2H
	lda	a5L
	clc
	adc	#3+BREITEX
	sta	r3L
	lda	a5H
	adc	#0
	sta	r3H
	lda	a6L
	sec
	sbc	#1+BREITEX*2
	sta	r4L
	lda	a6H
	sbc	#0
	sta	r4H
	MoveW_	r3,r11	; Titeltext einzeichnen
	lda	r2L
	clc
	adc	#8
	sta	r1H
	jsr	SetTextWin
	bcs	@gn
	ldy	#7
	lda	(a0),y
	sta	r0L
	iny
	lda	(a0),y
	sta	r0H
	ldx	@num
	jsr	PutTitle	; PrintTitle
	jsr	RestoreTextWin
@gn:	ldy	#05
@ploop1:	lda	windowTop,y
	pha
	dey
	bpl	@ploop1
	ldx	@num
	jsr	GetWorkArea
	bcs	@30
	jsr	RestoreTextWin
@30:	lda	#01	; Redraw
	ldx	@num
	jsr	SendMessage
	jsr	RestoreTextWin
	ldy	#0
@ploop2:	pla
	sta	windowTop,y
	iny
	cpy	#6
	bne	@ploop2
	lda	@num
	cmp	activeWindow
	bne	@end
	lda	@flag
	bne	@end
	jsr	DrawShadow
@end:	clc
	rts
@num:	.byte	0
@flag:	.byte	0
PutTitle:	jmp	NewPutString
.if 0
	stx	r14L
	PushB	r1H
	lda	rightMargin
	sec
	sbc	leftMargin
	sta	r12L
	lda	rightMargin+1
	sbc	leftMargin+1
	sta	r12H
	SubVW_	6,r12	; Breite von drei Punkten ("...")
	ldx	r14L
	lda	#0
	sta	NameIndex,x
	jsr	StringLen
@loop:	CmpW	r1,r12
	bcc	@geht
	ldy	#0
	lda	(r0),y
	ldx	currentMode
	jsr	GetRealSize	; Zeichenbreite holen
	tya
	sta	r14H
	lda	r1L
	sec
	sbc	r14H
	sta	r1L
	lda	r1H
	sbc	#0
	sta	r1H
	IncW	r0
	ldx	r14L
	inc	NameIndex,x
	bne	@loop
@geht:	PopB	r1H
	ldx	r14L
	lda	NameIndex,x
	beq	@ganz
	LoadB	r14L,3
@ploop	lda	#"."
	jsr	SmallPutChar
	dec	r14L
	bne	@ploop
@ganz:	jmp	NewPutString
.endif
NewRectangle:	jsr	GetClipRec
	jsr	CutRec
	bcs	@nicht
	jsr	Rectangle
	clc
@nicht:	rts
ClearScreen:	; L|schen des ganzen Bildschirms (mit Ausnahme von Zeile 0-14)
	; Und einzeichnen von Icons
	jsr	MaxTextWin
	lda	#Grenze_oben
	sta	r2L
	lda	#0
	sta	r3L
	sta	r3H
	LoadB	r2H,199
	LoadW___	r4,319
.ifdef topdesk128
    MoveW_   RightMax, r4
.endif
	jmp	BackgroundRectangle

RedrawAll:	; Redraw des ganzen Bildschirms (mit Ausnahme von Zeile 0-14)
	jsr	ClearScreen
	ldy	#3
@loop:	tya
	pha
	lda	activeWindow,y
	tay
	tax
	lda	windowsOpen,y
	beq	@10
	jsr	DrawWindow
@10:	pla
	tay
	dey
	bpl	@loop
	rts
Move1stWin:	ldy	#5
@loop:	lda	r2L,y
	pha
	sta	r5L,y
	dey
	bpl	@loop
	jsr	RemoveShadow
	jsr	GetWinRec
	jsr	RestoreRectangle
	ldy	#0
@loop2:	pla
	sta	(a0),y
	iny
	cpy	#6
	bne	@loop2
	ldx	activeWindow
	jmp	DrawWindow

Redraw:	ldy	activeWindow
	lda	windowsOpen,y
	bne	@10
	rts
@10:	ldx	activeWindow
	jmp	DrawWindow
RestoreRectangle:	; Wiederstellung des Bereichs r2-r4 durch evtl. teilweises Einzeichnen aller
	; Windows mit Ausnahme des aktiven Windows
	PushW	a0
	jsr	MaxTextWin
	jsr	SetTextWin
	jsr	BackgroundRectangle
	ldy	#3
@loop:	tya
	pha
	lda	activeWindow,y
	tax
	lda	windowsOpen,x
	beq	@nicht
	jsr	DrawWindow
@nicht:	pla
	tay
	dey
	bne	@loop
	jsr	MaxTextWin
	PopW	a0
	rts

DoMove:	; Bewegung eines Rahmens an Abh{ngigkeit der Mauszeiger-Koordinaten
	; (Initialisierung)
	; Par: r2-r4 Rechteck
	;      r0 : R}cksprung
	; Des: a,x,y,r0,r1,r5-r12
	; Alt: mouseTop-mouseRight
	MoveW_	r0,moveVector
	jsr	InvFrame
	ldy	#05
@10:	lda	r2,y
	sta	moveKoords,y
	dey
	bpl	@10
	php
	sei
	lda	$3a
	sec
	sbc	r3L
	sta	moveKoords+7
	lda	$3b
	sbc	r3H
	sta	moveKoords+8
	lda	$3c
	sec
	sbc	r2L
	sta	moveKoords+6
	plp
	; rechter Rand = MausXOffset
	MoveW_	moveKoords+7,mouseLeft
	; linker Rand = 319-(xr-xl)+MausXOffset
	; 	= 319-xr+xl+MausXOffSet
.ifdef topdesk128
    MoveW_   RightMax, mouseRight
.else
	LoadW___	mouseRight,319
.endif
	SubW	moveKoords+4,mouseRight
	AddW	moveKoords+2,mouseRight
	AddW	moveKoords+7,mouseRight
	; oberer Rand = MausYOffset+Grenze_oben
	lda	moveKoords+6
	clc
	adc	#Grenze_oben
	sta	mouseTop
	; unterer Rand = 199 - (yu-yo) + MausYOffSet
	;	  = 199 - yu + yo + MausYOffSet
	lda	#199
	sec
	sbc	moveKoords+1
	clc
	adc	moveKoords
	clc
	adc	moveKoords+6
	sta	mouseBottom

	LoadB	moveFlag,$ff
	rts
moveKoords:	.byte	0, 0, 0, 0, 0, 0, 0, 0, 0
moveVector:	.word	0
moveFlag:	.byte	0
AppMoveFrame:	; Bewegung eines Rahmens an Abh{ngigkeit der Mauszeiger-Koordinaten
	; (MainLoop-Routine)
	lda	moveFlag
	cmp	#$ff
	beq	@10
	jmp	AppRubberFrame
@10:	php		; Mauszeiger bewegt?
	sei
	CmpW	$3a,@mx
	bne	@20	; >ja
	lda	$3c
	cmp	@my
	beq	@30	; >nein
@20:	ldy	#05	; Altes Rechteck l|schen
@25:	lda	moveKoords,y
	sta	r2,y
	dey
	bpl	@25
	jsr	InvFrame
	lda	r2H	; aus yu/xr mach h/b
	sec
	sbc	r2L
	sta	r2H
	SubW	r3,r4
	MoveW_	$3a,r3	; neues x holen
	SubW	moveKoords+7,r3	; minus Mausabstandx
	AddW	r3,r4	; aus b mach xr
	lda	$3c	; neues y holen
	sec
	sbc	moveKoords+6	; minus Mausabstandy
	sta	r2L
	clc
	adc	r2H	; aus h mach yu
	sta	r2H
	ldy	#05	; Neues Rechteck zeichnen
@27:	lda	r2,y
	sta	moveKoords,y
	dey
	bpl	@27
	jsr	InvFrame
	MoveW_	$3a,@mx
	MoveB	$3c,@my
@30:	plp
	jmp	AppRubberFrame
@mx:	.word	0
@my:	.byte	0
DoRubber:	; Gr|~enver{nderung eines Rahmens an Abh{ngigkeit der 
	; Mauszeiger-Koordinaten
	; (Initialisierung)
	MoveW_	r0,moveVector
	php
	sei
	ldy	#05
@10:	lda	r2,y
	sta	moveKoords,y
	dey
	bpl	@10
	MoveW_	r4,$3a	; mouseX
	MoveB	r2H,$3c	; mouseY
	; oberer Rand = yo + 40
	lda	r2L
	clc
	adc	#40
	sta	mouseTop
	sta	r2H
	; unterer Rand und rechter Rand auf Maximum
.ifdef topdesk128
    MoveW_   RightMax, mouseRight
.else
	LoadW___	mouseRight,319
.endif
	LoadB	mouseBottom,199
	; linker Rand = ml + 40
	lda	moveKoords+2
	clc
	adc	#40
	sta	mouseLeft
	lda	moveKoords+3
	adc	#00
	sta	mouseLeft+1
	MoveB	$3c,r2H
	sta	moveKoords+1
	lda	$3a
	sta	moveKoords+4
	sta	r4L
	lda	$3b
	sta	moveKoords+5
	sta	r4H
	plp
	jsr	InvFrame
	LoadB	moveFlag,$80
	rts
AppRubberFrame:	; Bewegung eines Rahmens an Abh{ngigkeit der Mauszeiger-Koordinaten
	; (MainLoop-Routine)
	lda	moveFlag
	cmp	#$80
	beq	@10
	rts
@10:	php		; Mauszeiger bewegt?
	sei
	CmpW	$3a,@mx
	bne	@20	; >ja
	lda	$3c
	cmp	@my
	beq	@30	; >nein
@20:	ldy	#05	; Altes Rechteck l|schen
@25:	lda	moveKoords,y
	sta	r2,y
	dey
	bpl	@25
	jsr	InvFrame
	MoveW_	$3a,r4
	MoveB	$3c,r2H
	
	ldy	#05	; Neues Rechteck zeichnen
@27:	lda	r2,y
	sta	moveKoords,y
	dey
	bpl	@27
	jsr	InvFrame
	MoveW_	$3a,@mx
	MoveB	$3c,@my
@30:	plp
	rts
@mx:	.word	0
@my:	.byte	0

SendMessage2:	jsr	SendMessage
	jmp	MaxTextWin
SendMessage:	; a = Kommando , x = WindowNr (0-3)
	sta	messageBuffer
	stx	messageBuffer+1
	ldy	#10
	lda	(a0),y
	tax
	dey
	lda	(a0),y
	jmp	CallRoutine
GetNext:	ldx	#0
@10:	lda	windowsOpen,x
	beq	@20
	inx
	cpx	#4
	bne	@10
	sec
	rts
@20:	clc
	rts
OpenWindow:	lda	windowsOpen,x
	beq	@10
	sec
	rts
@10:	txa
	pha
	jsr	RemoveShadow
	pla
	tax
	lda	#$ff
	sta	windowsOpen,x
	stx	r0L
	cpx	activeWindow
	beq	@13
	ldy	#0
	txa
@11:	ldx	activeWindow,y
	sta	activeWindow,y
	tya
	beq	@11a
	cpx	r0L
	beq	@13
@11a:	txa
	iny
	cpy	#04
	bne	@11
@13:	ldx	activeWindow
	jsr	DrawWindow
	ldx	r0L
	clc
	rts
CloseWindow:	; aktives Window schlie~en
	; Des: a,x,y, r5-r8, r11L
	jsr	RemoveShadow
	ldx	activeWindow
	lda	#00
	sta	windowsOpen,x
	jsr	GetWinAdrRec
	jsr	RestoreRectangle
	ldy	#00
@10:	lda	activeWindow,y
	tax
	lda	windowsOpen,x
	bne	@15
	iny
	cpy	#3
	bpl	@10
	ldx	#$ff
@15:	txa
	bmi	@19
	clc
	jsr	FrontWindow
	jmp	SendActivate
@19:	rts

SendActivate:	lda	#WN_ACTIVATE
	ldx	activeWindow
	jmp	SendMessage2
oldMsVec:	.word	0
NewMouseService:
    lda	mouseData	; Maus-Release?
	bpl	@10	; >nein
@05:	jmp	@35
@10:	lda	menuNumber	; Men} downgepullt ?
	bne	@05	; >ja
	lda	moveFlag	; MoveFrame aktiv?
	cmp	#$ff
	beq	@20	; >ja
	cmp	#$80	; RubberFrame aktiv?
	bne	@30	; >nein
@20:	ldy	#05
@22:	lda	moveKoords,y
	sta	r2L,y
	dey
	bpl	@22
	jsr	InvFrame
	LoadB	moveFlag,0
.ifdef topdesk128
	ldy	#03
.else
	ldy	#05
.endif
@29:	lda	@d,y
	sta	mouseTop,y
	dey
	bpl	@29
.ifdef topdesk128
    MoveW_   RightMax, mouseRight
.endif
	lda	moveVector
	ldx	moveVector+1
	jmp	CallRoutine
@30:	jsr	CheckWindows
	ldx	activeWindow
	lda	windowsOpen,x
	beq	@35
	lda	ghostFile
	bne	@34
	jsr	GetWinAdr
	jsr	CheckClose
	jsr	CheckMax
	jsr	CheckHide
	jsr	CheckMove
	jsr	CheckSize
	jsr	CheckScroll_LR
	jsr	CheckScroll_UD
@34:	jsr	CheckUser
@35:	jsr	MaxTextWin
	lda	oldMsVec
	ldx	oldMsVec+1
	jmp	CallRoutine
@d:	.byte	0,199
.ifdef topdesk128
    .byte  0, 0
.else
	.word	0,319
.endif
CheckUser:	ldx	activeWindow
	jsr	GetWorkArea
	jsr	IsMseInRegion	; Maus innerhalb der Arbeitsfl{che?
	bne	@10	; >ja
	jsr	GetWinRec	; Maus trotzdem auf aktuellem Window?
	jsr	IsMseInRegion
	bne	@20	; >ja, also otherPress u. {. umgehen
	rts		; >otherPress u. {. bearbeiten
@10:	lda	$3a	; Mauskoordinaten relativ zum 
	sec		; Arbeitsrechteck ermitteln
	sbc	r3L
	sta	r3L
	lda	$3b
	sbc	r3H
	sta	r3H
	lda	$3c
	sbc	r2L
	sta	r2L
	lda	#WN_USER
	ldx	activeWindow
	jsr	SendMessage2
@20:	pla
	pla
	rts
IsMseOnGad:	lda	r2L
	clc
	adc	#BREITEY
	sta	r2H
	lda	r3L
	clc
	adc	#BREITEX
	sta	r4L
	lda	r3H
	adc	#00
	sta	r4H
	jmp	IsMseInRegion
CheckClose:	jsr	GetWinRec
	jsr	IsMseOnGad	; Close-Gadget angeklickt
	bne	@10	; >ja
@05:	rts
@10:	pla
	pla
	lda	#WN_CLOSE
	ldx	activeWindow
	jmp	SendMessage2
CheckMax:	jsr	GetWinRec
	lda	r4L
	sec
	sbc	#BREITEX
	sta	r3L
	lda	r4H
	sbc	#00
	sta	r3H
	jsr	IsMseOnGad	; Maximal-Gadget angeklickt
	bne	@10	; >ja
@05:	rts
@10:	pla
	pla
	jsr	MaxWindow
	jmp	Move1stWin
CheckHide:	jsr	GetWinRec
	lda	r4L
	sec
	sbc	#BREITEX*2
	sta	r3L
	lda	r4H
	sbc	#00
	sta	r3H
@07:	jsr	IsMseOnGad	; Hide-Gadget angeklickt?
	bne	@10	; >ja
@05:	rts
@10:	pla
	pla
	ldx	activeWindow
	jmp	BackWindow
	
CheckSize:	jsr	GetWinRec
	lda	r2H
	sec
	sbc	#BREITEY
	sta	r2L
	lda	r4L
	sec
	sbc	#BREITEX
	sta	r3L
	lda	r4H
	sbc	#00
	sta	r3H
	jsr	IsMseInRegion	; Size-Gadget angeklickt
	bne	@10	; >ja
@05:	rts
@10:	pla
	pla
	jsr	GetWinRec
	LoadW___	r0,Move1stWin
	jmp	DoRubber
CheckScroll_LR:	jsr	GetWinRec
	lda	r2H
	sec
	sbc	#BREITEY
	sta	r2L
	jsr	IsMseOnGad	; Scroll_L -Gadget angeklickt
	bne	@10	; >ja
	beq	@20
@05:	rts
@10:	lda	#WN_SCROLL_L
	.byte	$2c
@30:	lda	#WN_SCROLL_R
	tax
	pla
	pla
	txa
	ldx	activeWindow
	jsr	SendMessage2
	rts
@20:	jsr	GetWinRec
	lda	r2H
	sec
	sbc	#BREITEY
	sta	r2L
	lda	r4L
	sec
	sbc	#BREITEX*2
	sta	r3L
	lda	r4H
	sbc	#00
	sta	r3H
	jsr	IsMseOnGad	; Scroll_R -Gadget angeklickt
	bne	@30	; >ja
	rts
CheckScroll_UD:	jsr	GetWinRec
	lda	r2L
	clc
	adc	#BREITEY
	sta	r2L
	lda	r4L
	sec
	sbc	#BREITEX
	sta	r3L
	lda	r4H
	sbc	#00
	sta	r3H
	jsr	IsMseOnGad	; Scroll_U -Gadget angeklickt
	bne	@10	; >ja
	beq	@20
@05:	rts
@10:	pla
	pla
	lda	#WN_SCROLL_U
	ldx	activeWindow
	jmp	SendMessage2
@20:	jsr	GetWinRec
	lda	r2H
	sec
	sbc	#BREITEY*2
	sta	r2L
	lda	r4L
	sec
	sbc	#BREITEX
	sta	r3L
	lda	r4H
	sbc	#00
	sta	r3H
	jsr	IsMseOnGad	; Scroll_D -Gadget angeklickt
	bne	@30	; >ja
	rts
@30:	pla
	pla
	lda	#WN_SCROLL_D
	ldx	activeWindow
	jmp	SendMessage2
CheckMove:	jsr	GetWinRec
	lda	r2L
	clc
	adc	#BREITEY
	sta	r2H
	jsr	IsMseInRegion	; Move-Balken angeklickt
	bne	@10	; >ja
@05:	rts
@10:	pla
	pla
	jsr	GetWinRec
	LoadW___	r0,Move1stWin
	jmp	DoMove
CheckWindows:	lda	#0
	sta	r0L
	tay
@10:	lda	activeWindow,y
	tax
	lda	windowsOpen,x
	beq	@13
	jsr	GetWinAdrRec
	jsr	IsMseInRegion
	bne	@20
@13:	inc	r0L
	ldy	r0L
	cpy	#4
	bne	@10
@15:	rts
@20:	ldy	r0L
	beq	@15
	ldx	activeWindow,y
	lda	#WN_ACTIVATE2
	jsr	SendMessage
;	jmp	SendMessage		; Window aktivieren und GD's bearbeiten
	pla		; Window aktivieren und GD-Bearbeitung
	pla		; umgehen
	rts
FrontWindow:	; Window nach vorne holen, Nummer in x
	; bei Carry = 1 wird Window x in jedem Fall neu eingezeichnet
	php
	txa
	pha
	jsr	RemoveShadow
	pla
	tax
	plp
FrontWindow2:
	php
	LoadB	r1H,0
	sta	@zw
	sta	@zw+1
	sta	@zw+2
	sta	@zw+3
	stx	r1L
	jsr	GetWinAdr
	jsr	GetWinRec2
	ldy	#3
	sty	r0H
@10:	lda	r1L
	cmp	activeWindow,y
	bne	@10a
	sty	@y
	lda	r1H
	sta	r0L
	lda	#00
	sta	r1H
	beq	@11
@10a:	lda	activeWindow,y
	tax
	lda	windowsOpen,x
	beq	@11
	jsr	GetWinAdrRec
	jsr	CutRec	; Schneidet anderes Window? 
	bcs	@11	; > nein
	ldy	r0H
	lda	#1
	sta	@zw,y
	inc	r1H
@11:	dec	r0H
	ldy	r0H
	bpl	@10
@20:	; jetzt ist in r0L die Anzahl der offenen Windows, die hinter (unter) dem 
	; nach vorne zu holenden Fenster liegen, und in r1H die Anzahl der 
	; offenen Windows, die vor (}ber) dem nach vorne zu holenden 
	; Window liegen.
	; in r1L steht die Nummer des neuen Front-Windows, in :y dessen
	; alter (noch aktueller) Platz in activeWindow
	; Test, ob das Window x sich mit einem anderen Window }berlappt
	lda	r1H	; Schneidendes Window vorhanden?
	beq	@26	; >nein
	plp
	sec
	php
@26:	ldx	r1L
	ldy	@y
	jsr	@sub	; activeWindow korrigieren
	plp
	bcc	@25a
	ldx	activeWindow
	jmp	DrawWindow
@25a:	jsr	DrawShadow
	rts
@y:	.byte	0
@sub:	; alle vor (y) liegenden Pl{tze in activeWindows r}cken um eins nach 
	; hinten
	cpx	activeWindow
	beq	@s20
@s10:	lda	activeWindow-1,y
	sta	activeWindow,y
	dey
	bne	@s10
	stx	activeWindow
@s20:	rts
@zw:	.byte 0, 0, 0, 0

BackWindow:	; aktuelles Window nach hinten setzen
	ldy	#3
@loop0:	lda	windowsOpen,y
	bne	@geht
	dey
	bne	@loop0
	rts
@geht:	jsr	__DispMarking
	jsr	__ClearMultiFile
	jsr	RemoveShadow
	jsr	MaxTextWin
	ldx	activeWindow
	jsr	GetWinAdr
	jsr	GetWinRec
	lda	activeWindow
	pha
@59:	ldy	#00
@60:	lda	activeWindow+1,y
	sta	activeWindow,y
	iny
	cpy	#03
	bne	@60
	pla
	sta	activeWindow+3
	tax
	lda	windowsOpen,x
	beq	@20
	jsr	SetTextWin
	ldy	#2
@loop:	tya
	pha
	lda	activeWindow,y
	tax
	lda	windowsOpen,x
	beq	@10
	jsr	DrawWindowC
@10:	pla
	tay
	dey
	bpl	@loop
@20:	ldx	activeWindow
	lda	windowsOpen,x
	bne	@70
	txa
	pha
	jmp	@59
@70:	jsr	DrawShadow
	jmp	SendActivate
CutRec:	; Schnittfl{che zwischen zwei Rechtecken berechnen
	; Rechteck 1: r2-r4
	; Rechteck 2: r5-r7	( bleibt unver{ndert )
	; Ergebnis-Rechteck: r2-r4
	; bei c = 1 keine Schnittfl{che vorhanden
	; zerst|rt: A

	; r3 = MAX(r3,r6)
	lda	r6L
	sec
	sbc	r3L
	lda	r6H
	sbc	r3H
	bmi	@10
@05:	MoveW_	r6,r3
@10:	; r2L = MAX (r2L,r5L)
	lda	r5L
	sec
	sbc	r2L
	lda	#00
	sbc	#00
	bmi	@20
	MoveB	r5L,r2L
@20:	; r4 = MIN (r4,r7)
	lda	r7L
	sec
	sbc	r4L
	lda	r7H
	sbc	r4H
	bpl	@30
	MoveW_	r7,r4
@30:	; r2H = MIN (r2H,r5H)
	lda	r5H
	sec
	sbc	r2H
	lda	#00
	sbc	#00
	bpl	@40
	MoveB	r5H,r2H
@40:	; Schnittfl{che jetzt in r2-r4
	; wenn r4<r3 oder r2H<r2L, dann existiert keine Schnittfl{che
	lda	r4L
	sec
	sbc	r3L
	lda	r4H
	sbc	r3H
	bpl	@50
@49:	sec
	rts
@50:	lda	r2H
	sec
	sbc	r2L
	lda	#00
	sbc	#00
	bmi	@49
@60:	clc
	rts
DrawShadow:
RemoveShadow:	PushW	a0
	ldx	activeWindow
	lda	windowsOpen,x
	beq	@01
	jsr	GetWinAdr
	jsr	ToggleTitel
@01:	PopW	a0
	rts
GetWorkArea:	; Ermittlung des Arbeitsbereiches von Window x (0-3)
	PushW	a0
	jsr	@sub
	ldy	#5
@loop:	lda	r2L,y
	pha
	dey
	bpl	@loop
	jsr	SetTextWin
	php
	pla
	tax
	ldy	#0
@loop2:	pla
	sta	r2L,y
	iny
	cpy	#6
	bne	@loop2
	PopW	a0
	txa
	pha
	plp
	rts
@sub:	jsr	GetWinAdrRec	; WindowRechteck holen
	IncW	r3	; Rand abziehen
	DecW	r4
	dec	r2H
	lda	r2L	; MoveBalken abziehen
	clc
	adc	#BREITEY+1
	sta	r2L
	lda	r2H
	sec
	sbc	#BREITEY
	sta	r2H
	SubVW_	BREITEX,r4	; rechten Scrollrand abziehen
@19:	rts
ToggleTitel:	; Anbringen bzw. Entfernen eines Stricherasters im Titelbalken des
	; aktiven Windows
	jsr	GetWinRec
	lda	r2L
	clc
	adc	#BREITEY
	sta	r2H
	inc	r2L
	inc	r2L
	IncW	r3
	DecW	r4
	AddVW__	BREITEX,r3
@10:	SubVW_	BREITEX*2,r4
@30:	ldx	activeWindow
	ldy	#7
	lda	(a0),y
	clc
	adc	NameIndex,x
	sta	r0L
	iny
	lda	(a0),y
	adc	#00
	sta	r0H
	jsr	StringLen	; r1 := LEN (Titelstring) (in Pixel)
	ldx	activeWindow
	lda	NameIndex,x
	beq	@ganz
	AddVW__	6,r1	; "..."
@ganz:	AddW	r3,r1	; r1 := xr (TitelString)
	IncW	r1
	ldy	#r1L
	sec		; (r4 = xr (Titelbalken))
	lda	r1L
	sbc	r4L
	lda	r1H
	sbc	r4H
	bmi	@20
	ldy	#r4L
@20:	lda	$0,y	; r1 = MIN (r1,r4)
	sta	r1L
	lda	$1,y
	sta	r1H
	MoveB	r2L,r11L
@33:	jsr	InvertLine	; Invert (r3,r4)  (= Titelbalken inv.)
	PushW	r4
	MoveW_	r1,r4
	IncW	r3
	IncW	r3
	jsr	InvertLine	; Invert (r3+2,r1) (= Titelstring wiederh.)
	DecW	r3
	DecW	r3
	PopW	r4
	ldx	r11L
	inx
	inx
	stx	r11L
	cpx	r2H
	bne	@33
	rts
UnPackMap:
	ldy	r3L
	iny
.ifdef topdesk128
    sty r3L
    lda MapBreite
    bmi @10
.endif
	lda	(r0),y
.ifndef topdesk128
	sty	r3L
.endif
	rts
.ifdef topdesk128
@10:
    tya
    lsr
    tay
    lda (r0),y
    ldy #7
@loop:
    asl
    php
    rol @b2
    rol @b1
    plp
    rol @b2
    rol @b1
    dey
    bpl @loop

    lda r3L
    and #1
    tay
    lda @b1,y
    rts
@b1:    .byte   0
@b2:    .byte   0

DispTest:
    rts
MapBreite:  .byte   0

.endif

DrawMap:	; entpackte Bitmap auf Bit-Grenzen mit Clipping darstellen
	; Par:
	; x	y-Koordinate
	; r10	x-Koordinate
	; r13L	BitmapBreite
	; r13H	BitmapH|he
	; r0	Zeiger auf Bitmap
	; windowTop-rightmargin: Clipping Window
.ifdef topdesk128
    txa
    pha
    ldx #r10
    jsr NormalizeX
    LoadB   @off80, 0
    lda graphMode
    bmi @n80
    lda r13L
    and #$7f
    sta MapBreite
    bne @schmal
@n80:
    lda r13L
    sta MapBreite
    bpl @schmal
    ldx #1
    stx @off80
    and #$7f
    asl
@schmal:
    sta r13L
    pla
    tax
.endif

	lda	leftMargin+1	; r10>=leftMargin?
	cmp	r10H
	bcc	@x0	; >nein
	lda	r10L
	cmp	leftMargin
	bcs	@x1	; >ja
@x0:	lda	leftMargin	; r14 = leftMargin-r10
	ora	#%111
	sec
	sbc	r10L
	sta	r14L
	lda	leftMargin+1
	sbc	r10H
	sta	r14H
	bpl	@a0
@x1:	LoadW___	r14L,0	; kein Clipping links
	beq	@c0
@a0:	lsr	r14H
	ror	r14L
	lsr	r14H
	ror	r14L
	lsr	r14H
	ror	r14L
	inc	r14L
	lda	leftMargin
	and	#%111
	eor	#%111
	sta	r14H

	; jetzt steht in r14L die Anzahl der zu }berspringenden Bytes +1, und in 
	; r14H die Nummer des Bits, ab dem einmaskiert werden soll
@c0:	lda	rightMargin	; r15 = rightMargin-r10
	ora	#%111
	sec
	sbc	r10L
	sta	r15L
	lda	rightMargin+1
	sbc	r10H
	sta	r15H
	bpl	@a1	; wenn rightMargin < r10
	rts		; dann keine Bitmapdarstellung
.ifdef topdesk128
@off80: .byte   0
.endif
@a1:	lsr	r15H
	ror	r15L
	lsr	r15H
	ror	r15L
	lsr	r15H
	ror	r15L
	inc	r15L
	lda	rightMargin
	and	#%111
	eor	#%111
	sta	r15H
	; jetzt steht in r15L die max. Anzahl der darzustellen Bytes+1, und 
	; in r15H die Nummer des Bits, ab dem ausmaskiert werden soll

	LoadB	r9H,0
.ifdef topdesk128
	sta	r4L
	lda @off80
	sta r3L
.else
	sta	r3L
	sta	r4L
.endif
	inc	windowBottom
@01:	LoadB	winOutFlag,0	; Zeile unter windowTop?
	txa
	pha
	sec
	sbc	windowTop
	lda	#00
	sbc	#00
	bmi	@02	; >nein
	pla
	pha
	sec		; Zeile }ber windowBottom
	sbc	windowBottom
	lda	#00
	sbc	#00
	bmi	@03	; >ja
	LoadB	r13H,1	; Anzeige anbrechen 
@02:	LoadB	winOutFlag,1	; Zeile nicht anzeigen
@03:	PushW	r13
	PushB	r14L
	PushB	r15L
	jsr	@sub	; Zeile ggf. darstellen 
	PopB	r15L
	PopB	r14L
	PopW	r13
	pla
	tax
	inx		; n{chste Zeile
	dec	r13H
	bne	@01
	dec	windowBottom
	rts
@sub:
.ifdef topdesk128
    jsr DispTest
.endif

	jsr	GetScanLine	; Zeilenadresse holen
.ifdef topdesk13
	lda	r5H	; 80-Zeichen ?
	bmi	@s10	; >nein
.ifdef topdesk128
    MoveB   r10H, r6H
    lda r10L
    lsr r6H
    ror
    lsr r6H
    ror
    lsr r6H
    ror
    sta r11L
    tay
    jmp @s11
.endif

@s10:
.endif
	lda	r10H
	clc
	adc	r5H
	sta	r5H


;XXX>
.ifndef topdesk13
	lda	r10H
	clc
	adc	r6H
	sta	r6H
.endif
;<XXX
	lda	r10L
	and	#%11111000
	sta	r11L
	tay
@s11:
	lda	r10L	; x = r10 AND 7
	and	#%111
	sta	r11H
	tax
.ifdef topdesk128
    lda r5H
    bmi @64a
    jsr ldar5y
    jmp @64b

@64a:
.endif

	lda	(r5),y	; zu }berschreibende Bits am linken Rand
@64b:
	and	BitMaske2,x	; ausmaskieren
	pha

	jsr	UnPackMap	; Datenbyte holen
	ldx	#0
	ldy	r11H
	jsr	Rotieren	; Bits verschieben
	ldy	r11L
	sta	r11L
	pla
	ora	r11L	; mit Hintergrund verkn}pfen
	jsr	StoreBits	; und als 1. Byte der Zeile schreiben
	dec	r13L	; Breite verringern
@20:	tya		; y auf n{chstes Byte einstellen
	clc
.ifdef topdesk128
    adc GraphIndex
.else
	adc	#8
.endif
	tay
	bcc	@30
	inc	r5H

;XXX>
.ifndef topdesk13
    inc r6H
.endif
;<XXX

@30:	sty	r11L
	txa
	pha
	jsr	UnPackMap	; Datenbyte holen
	tay
	pla
	tax
	tya
	ldy	r11H
	jsr	Rotieren	; Bits verschieben
	ldy	r11L
	jsr	StoreBits	; und Datenbyte schreiben
	dec	r13L	; Breite verringern
	bne	@20	
	tya		; y auf n{chstes Byte einstellen
	clc
.ifdef topdesk128
    adc GraphIndex
.else
	adc	#8
.endif
	tay
	bcc	@50
	inc	r5H
;XXX>
.ifndef topdesk13
	inc r6H
.endif
;<XXX
@50:	sty	r11L
	stx	r13H
	lda	r11H
	eor	#%111
	tax
.ifdef topdesk128
    lda r5H
    bmi @64c
    jsr ldar5y
    jmp @64d
@64c:
.endif
	lda	(r5),y
@64d:
	and	BitMaske1,x	; Bits am rechten Rand ausmaskieren
	pha
	lda	#00	; Pseudo-Datenbyte
	ldx	r13H
	ldy	r11H
	jsr	Rotieren	; restliche Bits holen
	ldy	r11L
	sta	r11L
	pla
	ora	r11L	; mit Hintergrund verkn}pfen
	jsr	StoreBits	; und das letztes Byte der Zeile schreiben
	sty	r11L	
	rts

.ifdef topdesk128
ldar5y:
    ;lda    (r5),y
    DecW    r5
    jsr @sub
    IncW    r5
    rts
@sub:
    stx     @x
    tya
    clc
    adc r5L
    ldx #$13
    jsr SetReg
    dex
    lda r5H
    adc #0
    jsr SetReg
    ldx #$1f
    jsr GetReg
    jsr GetReg
    ldx @x
    rts
@x: .byte   0

star5y:
    ;sta    (r5),y
    pha
    tya
    clc
    adc r5L
    ldx #$13
    jsr SetReg
    dex
    lda r5H
    adc #0
    jsr SetReg
    ldx #$1f
    pla
    ldx #$1f
    jsr SetReg
    ldx #$12
    jmp SetReg

.endif

Rotieren:	; Das Word a (hi) /x (lo) wird um y Schritte rechts rotiert
	; anschlie~end wird x um (8-y) Schritte nach rechts verschoben
	pha
	tya
	beq	@30
	pla
	sty	@y
	stx	@x
@05:	lsr	a
	ror	@x
	bcc	@10	;Bei c=1 mu~ Bit 7 von a gesetzt werden
	ora	#%10000000
@10:	dey
	bne	@05
	pha
	lda	#8
	sec
	sbc	@y
	tay
	lda	@x
@20:	lsr	a
	dey
	bne	@20
	tax
@30:	pla
	rts
@y:	.byte	0
@x:	.byte	0

winOutFlag:	.byte	0
StoreBits:	; Speichern von a im Grafikschirm, falls innerhalb der Windowgrenzen
	dec	winOutFlag
	bmi	@ja
	inc	winOutFlag
	rts

@ja:
.ifdef topdesk128
    stx @x
.endif
    inc	winOutFlag
	dec	r15L	; Behandlung des rechten Randes
	beq	@01	; >Letztes Byte maskieren
	bpl	@05	; >normal ausgeben
	LoadB	r15L,0	; nicht mehr ausgeben
	rts
@01:
.ifndef topdesk128
    stx	@x
.endif
	sta	r15L
	ldx	r15H

.ifdef topdesk128
    lda r5H
    bmi @64a
    jsr ldar5y
    jmp @64b
@64a:
.endif
	lda	(r5),y
.ifdef topdesk128
@64b:
.endif
	and	BitMaske0,x
	pha
	txa
	eor	#%111
	tax
	lda	r15L
	and	BitMaske2,x
	sta	r15L
	pla
	ora	r15L
	ldx	#00
	stx	r15L
	ldx	@x
@05:	dec	r14L	; Behandlung des linken Randes
	beq	@20	; >erstes Byte maskieren
	bpl	@10	; >noch nicht ausgeben
	inc	r14L	; normal ausgeben
.ifdef topdesk128
    ldx r5H
    bmi @64g
    jsr star5y
    jmp @64h
@64g:
.endif
	sta	(r5),y
.ifndef topdesk128
	sta	(r6),y
.endif
@64h:
.ifdef topdesk128
    ldx @x
.endif
@10:	rts
@20:
.ifndef topdesk128
	stx	@x
.endif
	sta	r14L
	lda	r14H
	eor	#%111
	tax
.ifdef topdesk128
    lda r5H
    bmi @64c
    jsr ldar5y
    jmp @64d
@64c:
.endif
	lda	(r5),y
.ifdef topdesk128
@64d:
.endif
	and	BitMaske3,x
	pha
	txa
	eor	#%111
	tax
	lda	r14L
	and	BitMaske1,x
	sta	r14L
	pla
	ora	r14L
.ifdef topdesk128
    ldx r5H
    bmi @64e
    jsr star5y
    jmp @64f
@64e:
.endif

	sta	(r5),y
.ifndef topdesk128
	sta	(r6),y
.else
@64f:
.endif
	LoadB	r14L,0
	ldx	@x
	rts
@x:	.byte	0
BitMaske0:	.byte	0
BitMaske1:	.byte	%1,%11,%111,%1111,%11111,%111111,%1111111,%11111111
BitMaske3:	.byte	0
BitMaske2:	.byte	%10000000,%11000000,%11100000,%11110000
	.byte	%11111000,%11111100,%11111110,%11111111
.if 0
MyGetScanLine:	jsr	GetScanLine
	MoveW_	r5,Scanr5
	MoveW_	r6,Scanr6
	rts
@Scanr5:	w	0
@Scanr6:	w	0
star5:

	; nur mit x = r5 oder x = r6 aufrufen!
Sub80:	lda	$00,x
	pha
	sec
	sbc	Scanr5-r5,x
	sta	$00,x
	lda	$01,x
	pha
	sbc	Scanr5-r5+1,x
	sta	$00,x
	tya
	clc
	adc	$00,x
	sta	$00,x
	bcc	:10
	inc	$01,x
10:	lsr	$01,x
	ror	$00,x
	lsr	$01,x
	ror	$00,x
	lsr	$01,x
	ror	$00,x
	lda	$00,x
	sec
	sbc	Scanr5-r5,x
	sta	$00,x
	lda	$01,x
	sbc	Scanr5-r5+1,x
	sta	$00,x
	ldy	ScanMode
	beq	@store
	

	pla
	sta	$01,x
	pla
	sta	$00,x
	rts

.endif
SpeedWin:	; Aufruf von SpeedFrame mit Window x als
	; 	Startrechteck	c = 0
	; 	Zielrechteck	c = 1
	jsr	SpWinFrame
	jmp	SpeedFrame
SpeedWinMax:	jsr	SpWinFrame
	jmp	SpeedFrame
SpWinFrame:	PushW	a0
	php
	jsr	GetWinAdr
	plp
	bcs	@10
	jsr	GetWinRec
	jmp	@20
@10:	jsr	GetWinRec2
@20:	PopW	a0
	rts
NewDoIcons:	MoveW_	oldMsVec,mouseVector
	MoveW_	r0,iconTab
	jsr	DoIcons
	MoveW_	curWinData,a0
	MoveW_	mouseVector,oldMsVec
	LoadW___	mouseVector,NewMouseService
	jmp	RedrawAll
NewDoDlgBox:	inc	DialBoxFlag
	PushW	r6
	PushB	r7L
	jsr	DoDlgBox
	PopB	r7L
	PopW	r6
	rts
BackgroundRectangle:	; Wiederherstellung des Hintergrundes im Rechteck r2-r4
	lda	backPattern
	jsr	SetPattern
	jsr	Rectangle
	; Einzeichnen der Icons der iconTab nur innerhalb des Rechtecks r2-r4
	ldy	#05	; Rette Textwindow
@10:	lda	windowTop,y	; Textwindow := r2-r4
	pha
	lda	r2L,y
	sta	windowTop,y
	dey
	bpl	@10
	PushW	a0
	MoveW_	iconTab,a0
	ldy	#0
	lda	(a0),y
	sta	@num
	iny
	iny	; x-K. }berlesen (low)
	iny	; x-K. }berlesen (high)
	iny	; y-K. }berlesen
	.byte	$2c	; Skip
@20:	ldy	#0	; Daten des aktl. Icons auslesen:
	lda	(a0),y	; Bitmapadresse
	sta	r0L
	jsr	@next
	sta	r0H
	jsr	@next
	sta	r10L	; x-Koordinate
	jsr	@next
	tax		; y-Koordinate
	jsr	@next
	sta	r13L	; Breite
	jsr	@next
	sta	r13H	; H|he
	iny		; Routinenadresse }berlesen
	iny
	iny
	tya
	clc
	adc	a0L
	sta	a0L
	lda	#00
	adc	a0H
	sta	a0H
	LoadB	r10H,0	; xk:=xk*8
	asl	r10L
	rol	r10H
	asl	r10L
	rol	r10H
	asl	r10L
	rol	r10H
	jsr	DrawMap	; Bitmap darstellen
	dec	@num
	bne	@20	; und mit n{chstem Icon weitermachen
	MoveW_	curWinData,a0	; weitere Background-Rekonstruktionen
	lda	#WN_RESTORE	; einleiten
	ldx	#0
	jsr	SendMessage
	PopW	a0
	ldy	#00
@30:	lda	windowTop,y	; windowTop und r2-r4 wiederherstellen
	sta	r2L,y
	pla
	sta	windowTop,y
	iny
	cpy	#06
	bne	@30
	rts
@next:	iny
	lda	(a0),y
	rts
@num:	.byte	0
MaxWindow:	; actives Window auf Maximalgr|~e setzen / bzw. zur}ck
	; neue Gr|~e wird in r2-r4 }bergeben
.ifdef topdesk128
    LoadW___    r0, @w2
    jsr CheckOne
    lda graphMode
    bpl @03
    LoadW___    @wx,270*2
    bne @05
@03:
    LoadW___   @wx,270
@05:
.endif
	ldy	#5
@10:	lda	(a0),y
	cmp	@w,y
	bne	@20
	dey
	bpl	@10
	; gerettete Gr|~e setzen
	ldy	#05
@15:	lda	@w2,y
	sta	r2L,y
	dey
	bpl	@15
	rts
@20:	; Maximalgr|~e setzen
	ldy	#05
@25:	lda	(a0),y
	sta	@w2,y
	lda	@w,y
	sta	r2L,y
	dey
	bpl	@25
	rts
@w:	.byte	Grenze_oben,197
.ifdef topdesk128
	.word	0
.else
	.word	0,270
.endif
.ifdef topdesk128
@wx:    .word   270*2
.endif
@w2:	.byte	50,150
	.word	100,219

NewPutString:
.ifdef topdesk128
    ldx #r11
    jsr NormalizeX
.endif
	ldy	#00
	lda	(r0),y
	beq	@10
	cmp	#$1b
	beq	@05
	and	#$7f
	cmp	#$7f
	beq	@03
	cmp	#$20
	bcs	@04
@03:	lda	#'*'
@04:	jsr	SmallPutChar
@05:	IncW	r0
	jmp	NewPutString
@10:	rts
oldRecoverVec:	.word	0
MyRecoverService:	ldy	#5
@loop0:	lda	r2L,y
	sta	LastRec,y
	dey
	bpl	@loop0
	lda	DialBoxFlag
	bne	@10
	jmp	Recover
@10:	dec	DialBoxFlag
	rts

.ifdef topdesk128
CheckOne:
    ldy #4+1
    lda (r0),y
    cmp RightMax+1
    bcc @geht
    bne @gehtnicht
    dey
    lda (r0),y
    cmp RightMax
    bcc @geht
    bne @gehtnicht
@geht:
    rts
@gehtnicht:
    ;jmp    Halbieren

Halbieren:
    ldy #3
    lda (r0),y
    lsr
    sta (r0),y
    dey
    lda (r0),y
    ror
    sta (r0),y

    ldy #5
    lda (r0),y
    lsr
    sta (r0),y
    dey
    lda (r0),y
    ror
    sta (r0),y

    rts
.endif


DialBoxFlag:	.byte	0
LastRec:	.word	0,0,0
RecoverLast:	ldy	#5
@loop:	lda	LastRec,y
	sta	r2L,y
	dey
	bpl	@loop
Recover:	lda	c128Flag
	bpl	@10
	ldx	#r3
	jsr	NormalizeX
	ldx	#r4
	jsr	NormalizeX
@10:	AddVB	8,r2H
	AddVW__	8,r4
.ifdef topdesk128
    lda graphMode
    bpl @z40
    AddVW__ 8, r4
@z40:
.endif
	ldy	#5
@loop:	lda	windowTop,y
	pha
	dey
	bpl	@loop
	jsr	RestoreRectangle
	ldy	#0
@loop2:	pla
	sta	windowTop,y
	iny
	cpy	#6
	bne	@loop2
	ldx	activeWindow
	lda	windowsOpen,x
	bne	@geht
	rts
@geht:	jsr	DrawWindowC
	jmp	DrawShadow

StringLen:
	; Ermittlung einer Stringl{nge in Zeichen und in Pixels
	; Par:	r0 : Zeiger auf String, max. 256 Zeichen lang.
	; 	     ( Als Endekennzeichen dient ein 0 oder ein $a0 - Byte)
	; Ret:	x  : Anzahl der Zeichen
	;	r1  : Breite in Pixels
	; Des:	a,y,r13
	lda	#0	; Arbeitsvariablen initialisieren
	sta	r1L
	sta	r1H
	sta	r13H
	sta	r13L
@10:	ldy	r13L	; aktl. Index holen
	lda	(r0),y	; aktl. Zeichen holen
	beq	@90	; Ende ? >ja
	cmp	#$a0
	beq	@90	; Ende ? >ja
	inc	r13H	; Anzahl erh|hen
.ifdef topdesk128
    cmp #$1b
    bne @15
    ldy #0
    beq @17
@15:
.endif
	ldx	currentMode
	jsr	GetRealSize	; Zeichenbreite holen
.ifdef topdesk128
@17:
.endif
	tya
	clc
	adc	r1L	; Und zur Stringl{nge aufaddieren
	sta	r1L
	bcc	@20
	inc	r1H
@20:	inc	r13L	; Index erh|hen
	bne	@10
@90:	ldx	r13H
	rts

;InvFrame	; Parameter: r2-r4
	; Zur}ck: r2-r4 unver{ndert
	; Zerst|rt: a,x,y,r0,r1,r5-r12
	;t	"InvFrame"
.include "topdesk/WinInclude/InvFrame.inc"

;SpeedFrame	; Parameter : r2-r4 Start r5-r7 Ende r8 Min Breite r9L Min H|he r9H Temp.
	; Des: a,x,y,r0-r12
	;t	"SpeedFrame"
.include "topdesk/WinInclude/SpeedFrame.inc"

;.Windows_End
;:NewSetDevice	=	Windows_End
;:DispMarking	=	NewSetDevice+3
;:ClearMultiFile	=	DispMarking+3