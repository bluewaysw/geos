.ifdef topdesk128
MultiFileFlag:	.byte	0
MultiCount:	.byte	0
CheckDispMark:	; Test ob File a markiert ist
	; Par:	a: Nummer des Files (0-15)
	; 	x: Nummer des Windows
	; Ret:	c: 0: Markierung    vorhanden
	; 	   1:      "    nicht    "
	; 	a: Filenummer (0-143)
	; 	x: unchanged
	; Des: 	y
	pha
	lda	DispMode
	beq	@110
	pla
	stx	@x
	jsr	GetRealPos
	ldx	@x
	jmp	CheckMark
@x:	.byte	0
@110:	pla
	clc
	adc	windowOffs,x
CheckMark:	; Test ob File a markiert ist
	; Par:	a: Nummer des Files (0-143)
	; Ret:	c: 0: Markierung    vorhanden
	; 	   1:      "    nicht    "
	; 	a: unchanged
	; Des: 	y
	ldy	#144
@10:	cmp	MultiFileTab-1,y
	beq	@20
	dey
	bne	@10
	sec
	rts
@20:	clc
	rts
DispMultiCount:	txa
	pha
	ldy	#5
@loop1:	lda	windowTop,y
	pha
	dey
	bpl	@loop1
	jsr	MaxTextWin
	lda	#0
	jsr	SetPattern
	jsr	i_Rectangle
	.byte	2,12
	.word	222+DOUBLE_W,236+DOUBLE_W
	MoveB	MultiCount,r0L
	LoadB	r0H,0
	LoadW___	r11,223+DOUBLE_W
	LoadB	r1H,9
	lda	#%11000000
	jsr	PutDecimal
	ldy	#0
@loop2:	pla
	sta	windowTop,y
	iny
	cpy	#6
	bne	@loop2
	pla
	tax
	rts
.endif

.ifdef topdesk128
DispMarking:	; File-Markierungen darstellen
	; Par:	messageBuffer+1 : Window-Nummer
	jsr	MyDCFilesSub
	MoveW_	a5,a3
	MoveB	r2L,a2L
	lda	#00
@e0:	pha
	ldx	messageBuffer+1
	jsr	CheckDispMark
	bcs	@e1
	ldx	messageBuffer+1
	pla
	cmp	fileNum,x
	bcs	@e2
	pha
	jsr	GetFileRect
	bcs	@e1
	jsr	InvertRectangle
@e1:	pla
@e2:	clc
	adc	#01
	cmp	#16
	bne	@e0
	rts
MyDCFilesSub:	ldx	messageBuffer+1
	jsr	GetWorkArea
	ldx	messageBuffer+1
	lda	xOffsL,x
	clc
	adc	r3L
	sta	a5L
	lda	xOffsH,x
	adc	r3H
	sta	a5H
	lda	r2L
	sec
	sbc	#5
	sta	r2L
	AddVW__	6,r3
	rts

GetZielPos:
    ldx #6
    jsr GetPos
    ldx #r6
    jsr NormalizeX
    ldx #r7
    jsr NormalizeX
    rts

GetStartPos:
    ldx #00
    jsr GetPos
    ldx #r3
    jsr NormalizeX
    ldx #r4
    jsr NormalizeX
    rts

GetPos:
    ldy curDrive
    lda @xL-8,y
    sta r3L,x
    clc
    adc #21
    sta r4L,x
    lda @xH-8,y
    sta r3H,x
    adc #0
    sta r4H,x
    lda @y-8,y
    sta r2L,x
    clc
    adc #21
    sta r2H,x
    rts
@xL:    .byte   <(STARTA_X*8),<(STARTB_X*8),<(STARTC_X*8),<(STARTD_X*8)
@xH:    .byte   (>(STARTA_X*8))
        .byte   (>(STARTB_X*8))
        .byte   (>(STARTC_X*8))
        .byte   (>(STARTD_X*8))
@y:     .byte   STARTA_Y, STARTB_Y, STARTC_Y, STARTD_Y
.endif

SetWindows:	jsr	GotoFirstMenu
	PushW	a0
	LoadB	a2L,$ff
	ldy	#3
@05:	lda	windowsOpen,y
	beq	@10
	inc	a2L
@10:	dey
	bpl	@05
	lda	a2L
	bpl	@20
	PopW	a0
	rts
@20:	asl
	tay
.ifdef topdesk128
    LoadW___   a1, Gentab
    lda graphMode
    bpl @40z
    LoadW___   a1, Gentab80
@40z:
    lda  (a1),y
    tax
    iny
    lda (a1),y
    stx a1L
.else
	lda	Gentab,y
	sta	a1L
	lda	Gentab+1,y
.endif
	sta	a1H
	ldy	#03
@25:	sty	@y
	lda	activeWindow,y
	tax
	lda	windowsOpen,x
	beq	@40
	txa
	jsr	GetWinAdr
	ldy	#5
@35:	lda	(a1),y
	sta	(a0),y
	dey
	bpl	@35
	AddVW__	6,a1
@40:	ldy	@y
	dey
	bpl	@25
	PopW	a0
	jmp	RedrawAll
@y:	.byte	0
.macro WindPos	p1, p2, p3, p4
	.byte	p1,p2
	.word	p3,p4
.endmacro

Gentab:	.word	@tab1,@tab2,@tab3,@tab4
@tab1:	WindPos	15,197,2,272
@tab2:	WindPos	107,197,2,272
	WindPos	15,105,2,272
@tab3:	WindPos	15,105,138,272
	WindPos	15,105,2,136
	WindPos	107,197,2,272
@tab4:	WindPos	15,105,2,136
	WindPos	15,105,138,272
	WindPos	107,197,2,136
	WindPos	107,197,138,272

.ifdef topdesk128
Gentab80:	.word	@tab5,@tab6,@tab7,@tab8
@tab5:	WindPos	15,197,2*2,272*2
@tab6:	WindPos	107,197,2*2,272*2
	WindPos	15,105,2*2,272*2
@tab7:	WindPos	15,105,138*2,272*2
	WindPos	15,105,2*2,136*2
	WindPos	107,197,2*2,272*2
@tab8:	WindPos	15,105,2*2,136*2
	WindPos	15,105,138*2,272*2
	WindPos	107,197,2*2,136*2
	WindPos	107,197,138*2,272*2
.endif

SwapFile:	jsr	GetAktlDisk
	tax
	beq	@05
	jsr	ClearMultiFile2
	cpx	#12
	beq	@03
	jmp	FehlerAusgabe
@03:	rts
@05:	lda	a1L
	jsr	GetName2
	LoadW___	r6,Name
	jsr	FindFile	; 1. Name suchen
	PushW	r1	; Track/Sektor und
	PushB	r5L	; Index merken
	ldy	#0	; Dir-Block nach $8300
@20:	lda	$8000,y
	sta	$8300,y
	iny
	bne	@20
	jsr	GetMark	; Nummer des 2. Namens holen
	jsr	GetFileName	; 2. Name holen
	LoadW___	r6,Name
	jsr	FindFile	; 2. Name suchen
	PopB	r6L
	PopW	a7
	CmpW	r1,a7	; Name 1 und Name 2 im gleichen Dir-
	bne	@25	; Block ? >nein
	LoadB	r6H,$80	; Dir-Block in $8000 benutzen
	bne	@26	; sonst
@25:	LoadB	r6H,$83	; r6 als Zeiger auf 1. Eintrag in $8300
@26:	ldy	#29	
@30:	lda	(r5),y	; Dir-Eintr{ge austauschen
	pha
	lda	(r6),y
	sta	(r5),y
	pla
	sta	(r6),y
	dey
	bpl	@30
	LoadW___	r4,$8000
	jsr	PutBlock	; 2. Dir-Block schreiben
	CmpW	r1,a7
	beq	@40
	LoadW___	r4,$8300
	MoveW_	a7,r1
	jsr	PutBlock	; 1. Dir-Block schreiben
@40:	jmp	ReloadActiveWindow
SelectAll:	lda	#1
	.byte	$2c
SelectPage:	lda	#0
	sta	@m
	jsr	GotoFirstMenu
	ldx	activeWindow
	lda	windowsOpen,x
	bne	@05
	rts
@05:	stx	messageBuffer+1
	jsr	MyDCFilesSub
	MoveB	r2L,a2L
	MoveW_	a5,a3
	jsr	DispMarking
	lda	#0
@loop:	pha
	ldx	activeWindow
	ldy	@m
	beq	@08
	cmp	fileAnz,x
	bcs	@10
	jsr	CheckMark
	bcc	@10
	bcs	@09
@08:	cmp	fileNum,x
	bcs	@10
	jsr	CheckDispMark
	bcc	@10
@09:	tax
	jsr	MarkFile
@10:	pla
	clc
	adc	#1
	ldy	@m
	bne	@20
	cmp	#16
	bne	@loop
@15:	jmp	DispMarking
@20:	cmp	#144+8
	bne	@loop
	beq	@15
@m:	.byte	0
DeleteDir:	; Unterverzeichnis mit Kenn-Nr. a1L l|schen
	ldx	activeWindow
	lda	aktl_Sub,x
	pha
	lda	a1L
	sta	aktl_Sub,x
@10:	lda	#0
	jsr	DeleteSub
	txa
	bne	@20
	bcc	@10
@20:	txa
	tay
	ldx	activeWindow
	pla
	sta	aktl_Sub,x
	tya
	tax
	rts

NewPutDecimal:	; Par:	r0	Zahl
	;	r11/r1H	Position
	;	 a Bit 7: 0 - rechstb}ndig, Bit 0-5 Breite des Ausgabefeldes
	;	         1 - linksb}ndig
	;	   Bit 6: wird nicht beachtet (!)
	tax
	PushB	r1H
	txa
	pha
.ifdef topdesk128
    ldx #r11
    jsr NormalizeX
.endif
	lda	#0
	pha
	LoadW___	r1,10
@loop:	ldx	#r0
	ldy	#r1
	jsr	Ddiv
	lda	r8L
	clc
	adc	#$30
	pha
	lda	r0L
	ora	r0H
	bne	@loop
	ldy	#$ff
@loop2:	iny
	pla
	sta	@zahl,y
	bne	@loop2
	pla
	bpl	@10
	PopB	r1H
	LoadW___	r0,@zahl
	jmp	NewPutString
@10:	pha
	LoadW___	r0,@zahl
	jsr	StringLen
	pla
	and	#%00111111
	clc
	adc	r11L
	sta	r11L
	bcc	@20
	inc	r11H
@20:	lda	r11L
	sec
	sbc	r1L
	sta	r11L
	lda	r11H
	sbc	r1H
	sta	r11H
	PopB	r1H
	jmp	NewPutString
@zahl:	.byte	0,0,0,0,0,0

GetWinName:	; Ermittlung des Fenstertitelstring
	; Par:	a: Fensternummer
	; Ret:	r1: Pointer auf String
	;	y: Index auf das letzte Zeichen (=Endekennz.=0-Byte)
	; Des:	a,x
	asl
	tax
	lda	NameTab,x
	sta	r1L
	lda	NameTab+1,x
	sta	r1H
	ldy	#00
@10:	lda	(r1),y
	beq	@end
	iny
	bne	@10
@end:	rts
GetSubDirXList:	; Ermittlung der SubDirXList
	; Par: x: Nummer (0-3)
	; Ret: r0: Adresse der SubDirXList
	; Des: a
	lda	SubDirListTabL,x
	sta	r0L
	lda	SubDirListTabH,x
	sta	r0H
	rts
GetWinTabAdr:	; x : Nummer (bleibt erhalten und in a)   r1: Adresse
	txa
	asl		; File/Icontabellenadresse nach r0
	tay
	lda	WinTabAdr,y
	sta	r1L
	iny
	lda	WinTabAdr,y
	sta	r1H
	txa
	rts
GetAktlWinDisk:	; wie GetWinDisk, jedoch immer f}r das aktuelle Fenster
	; Par: ---
	ldx	activeWindow
GetWinDisk:	; Diskettennamen aus dem Pfadnamen eines Fensters ermitteln
	; Par:	x: Fensternummer
	; Ret:	Diskettenname abgelegt in DiskName
	;	z-Flag gesetzt, wenn DiskName mit Diskname des aktl. 
	; 	Fensters identisch
	;	r0: Zeiger auf Disknamen (nicht DiskName) des Fensters x
	txa
	asl
	tay
	lda	NameTab,y
	sta	r0L
	lda	NameTab+1,y
	sta	r0H
	lda	activeWindow
	asl
	tay
	lda	NameTab,y
	sta	r1L
	lda	NameTab+1,y
	sta	r1H
	ldy	#0
	sty	r2L
@10:	lda	(r0),y
	cmp	(r1),y
	beq	@11
	cpy	#18	; "x:" + Diskname
	beq	@11
	ldx	#01
	stx	r2L
@11:	tax
	beq	@20
	cmp	#PLAINTEXT
	beq	@20
	cmp	#'/'+$80
	beq	@20
	sta	DiskName,y
	iny
	bne	@10
@20:	lda	#00
	sta	DiskName,y
	lda	r2L
	rts

GetEqualWindows:	; Ermittlung der Fensternummern, deren Pfadname genau mit dem
	; Pfadnamen eines bestimmten Fensters }bereinstimmt
	; Par:	x: FensterNummer
	; Ret:	ab a6L stehen 4 FlagBytes $01 bei gleich, sonst $00
	; Des:	a,x,y,a2-a7
	ldy	#07
@03:	lda	NameTab,y	; Nametab nach a2-a5 }bertragen
	sta	a2L,y
	dey
	bpl	@03
	txa		; a2 <=> a2,x
	asl	a
	tay
	txa
	pha
	lda	a2L,y
	ldx	a2L
	stx	a2L,y
	sta	a2L
	lda	a2H,y
	ldx	a2H
	stx	a2H,y
	sta	a2H
	; Zeiger auf Source: in a2
	; a3: 2. Window, wenn S <> 2, sonst 1. Window
	; a4: 3. Window, wenn S <> 3, sonst 1. Window
	; a5: 4. Window, wenn S <> 4, sonst 1. Window
	lda	#01
	sta	a6H
	sta	a7L
	sta	a7H
	ldx	#00
	ldy	#00
@05:	lda	(a2),y	; S-Zeichen holen
	cmp	(a3),y	; Mit D1 vergleichen
	beq	@10
	stx	a6H	; D1 ungleich
@10:	cmp	(a4),y	; Mit D2 vergleichen
	beq	@20
	stx	a7L	; D2 ungleich
@20:	cmp	(a5),y	; Mit D3 vergleichen
	beq	@30
	stx	a7H	; D3 ungleich
@30:	cmp	#00
	beq	@40
	iny
	bne	@05
@40:	pla
	tax
	lda	a6L,x	; Ordnung in a6-a7 wiederherstellen
	sta	a6L
	ldy	#00
	sty	a6L,x
	; Jetzt stehen in a6-a7 4 Flagbytes der jeweiligen Fenster
	; $01 : Fenster-Name gleich Source, beim Source ist $00 eingetragen
	ldy	#3
@loop:	lda	windowsOpen,y
	bne	@50
	sta	a6L,y
@50:	dey
	bpl	@loop
	rts

.ifdef topdesk128
.ifdef scalable_coords
ClxL	= SC_FROM_END |  79
ClxR	= SC_FROM_END |  0
.else
ClxL	= 240 + DOUBLE_W
ClxR	= 319 + DOUBLE_W
.endif
.else
ClxL	= 240
ClxR	= 319
.endif
ClyO	= 1
ClyU	= ClyO+12
TimeX	= 55
TimeY	= 9 
DateX	= 5
DateY	= TimeY
; InitClock
; Bereich festlegen
; Prozess initialisieren
; Prozess starten
; otherPressVector auf IsClock
InitClock:
	jsr	i_GraphicsString
	.byte	NEWPATTERN,0
	.byte	MOVEPENTO
	.word	ClxL
	.byte	ClyO
	.byte	RECTANGLETO
	.word	ClxR
	.byte	ClyU
	.byte	FRAME_RECTO
	.word	ClxL
	.byte	ClyO
	.byte	NULL
	LoadW___	r0,ProzessTab
	lda	#1
	jsr	InitProcesses
	ldx	#$00
	jsr	RestartProcess
	jsr	EnableProcess
	
	rts
ProzessTab:	.word	ShowClock
	.word	500
year	= $8516
ShowClock:	
	LoadB	dispBufferOn,%10000000
	php
	sei	
	ldy	#4
@10:	lda	year,y
	sta	MyJahr,y
	dey
	bpl	@10
	plp
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
@Ausg:
	LoadW___	rightMargin,ClxR-1
	jsr	i_PutString
	.word	ClxL-DateX
	.byte	ClyO+DateY
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
	.byte	GOTOXY
	.word	ClxL-TimeX
	.byte	ClyO+TimeY
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
	.byte	"  "	
	.byte	NULL
	LoadW___	rightMargin,319
	rts
DivnSet:	pha
	stx	r0L
Div10:	LoadB	r0H,0
	ldx	#r0L
	LoadW___	r1,10
	ldy	#r1L
	jsr	Ddiv
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
MyJahr:	.byte	0
MyMonat:	.byte	0
MyTag:	.byte	0
MyStd:	.byte	0
MyMin:	.byte	0

CopyService:	pha
	ldx	messageBuffer+1
	jsr	GetWinDisk
	ldy	#18
@10:	lda	DiskName,y	; Name2:=DiskName
	sta	Name2,y
	dey
	bpl	@10
	jsr	GetAktlWinDisk	; aktl Disknamen nach DiskName
	pla
	jsr	GetFileName
	bcc	@13	; Name vorhanden?
	txa
	bne	@err
	lda	#$ff
	rts		; Nein, also mit C=1 zur}ck
@13:	sec
	jsr	DispDCFName
	ldx	#5
@dloop:	lda	@data,x
	sta	r10L,x
	dex
	bpl	@dloop
	ldx	messageBuffer+1
	lda	aktl_Sub,x
	sta	DestinationDir
	MoveB	r12L,r13L
	sta	r6L
	MoveB	r12H,r13H
	sta	r6H
	jsr	FindFile
	txa
	beq	@14
@err:	txa
	pha
	jsr	DoHauptMenu
	pla
	tax
	cpx	#$41
	bne	@e10
	clc
	rts
@e10:	jsr	FehlerAusgabe
	lda	#$00
	sec
	rts
@14:	lda	$8400+22
	cmp	#11	; Directory
	bne	@15
	jmp	CopyDir
@15:	jsr	CopyFile
	txa
	bne	@err
	lda	#$00
	clc
	rts
@data:	.word	DiskName+2,Name2+2,Name

DispDCFName:	PushB	dispBufferOn
	php
	LoadB	dispBufferOn,%10000000
	lda	#0
	jsr	SetPattern
	jsr	i_Rectangle
	.byte	0,13
.ifdef topdesk128
	.word	0
DispMenuRight:
	.word   214
.else
	.word	0,MAIN_RIGHT
.endif
	lda	#$ff
	jsr	FrameRectangle
	jsr	MaxTextWin
	jsr	i_PutString
	.word	3
	.byte	9,BOLDON,0
	LoadWr0	Name
	jsr	PutString
	plp
	bcc	@10
	LoadWr0	@t1
	jmp	@20
@10:	LoadWr0	@t2
@20:	jsr	PutString
	PopB	dispBufferOn
	rts
.ifdef lang_de
@t1:	.byte	PLAINTEXT," wird kopiert",0
@t2:	.byte	PLAINTEXT," wird gel|scht",0
.else
@t1:	.byte	PLAINTEXT," beeing copied",0
@t2:	.byte	PLAINTEXT," beeing deleted",0
.endif

TrashService:	
DeskDelete:	jsr	GotoFirstMenu
	ldx	MultiCount
	dex
	bpl	@geht
	rts
@geht:	LoadB	DialBoxFlag,5
	LoadW___	r2,MultiFileTab
	jsr	BubbleSort
@10:	jsr	GetMark
	tax
	bmi	@20
	jsr	DeleteSub
	txa
	beq	@15
	cmp	#12	; Schreibschutz-Fehler?
	beq	@20	; >ja
	txa
	pha
	jsr	FehlerAusgabe
	pla
	cmp	#6	; bei BAD_BAM Dir erneut
	beq	@30	; einlesen
	jmp	DoHauptMenu
	jmp	@20
@15:	bcc	@10
@20:	ldx	DialBoxFlag
	LoadB	DialBoxFlag,0
	cpx	#5
	beq	@30
	jsr	RecoverActiveWindow
	jmp	DoHauptMenu
@30:	jsr	ReloadActiveWindow
	jmp	DoHauptMenu
DeleteSub:	; Par: a: File-Nummer
	; Ret: c = 1 : File Nr. a nicht mehr vorhanden oder Diskettenfehler
	pha
	jsr	GetFileName
	bcc	@10
	jmp	@20
@10:	jsr	DispDCFName	; Carry is clear!
	LoadW___	r6,Name
	jsr	FindFile
	txa
	bne	@20a
	lda	$8400
	and	#$40
	beq	@geht
	LoadW___	r0,@db
	jsr	NewDoDlgBox
	pla
	ldx	#12
	rts
@geht:	lda	$8400+22
	cmp	#$0b	; Sub-Dir
	bne	@ns	; >nein
	MoveW_	$8400+19,r1
	LoadW___	r4,$8000
	jsr	GetBlock
	lda	$8000+OFF_DIR_NUM
	sta	a1L
	jsr	DeleteDir	; SubDir-Inhalt l|schen
	txa
@20a:	bne	@20
@ns:	pla
	pha
	jsr	GetFileName
	LoadW___	r6,Name
	LoadW___	r10L,0
	jsr	MoveFileInDir
	LoadWr0	Name
	jsr	DeleteFile
	txa
	beq	@19
	lda	$8400+22	; Sub-Dir gel|scht ?
	cmp	#$0b
	bne	@20	; >nein, Fehler da x <> 0
	jsr	GetDirHead	; DeleteFile-Fehler bei SubDirs
	txa
	bne	@19a
	MoveW_	$8400+19,r6	; korrigieren (BAM einlesen,
	jsr	FreeBlock	; Infoblock freigeben, BAM schreiben)
	jsr	PutDirHead
	txa
	beq	@19
@19a:	sec
	pla
	rts
@19:	ldx	#0
	clc
@20:	pla
	rts
@db:	.byte	$81
	.byte	$0b,$10,$10
	.word	@t1
	.byte	$0b,$10,$20
	.word	@t2
	.byte	$0b,$10,$30
	.word	@t3
	.byte	$0b,$10,$40
	.word	@t4
	.byte	$0b,$10+40,$10
	.word	Name
	.byte	OK,17,72,NULL
.ifdef lang_de
@t1:	.byte	"Die Datei ",0
@t2:	.byte	"ist schreibgesch}tzt",0
@t3:	.byte	"und kann nicht gel|scht",0
@t4:	.byte	"werden.",0
.else
@t1:	.byte	"The file ",0
@t2:	.byte	"is write protected",0
@t3:	.byte	"and cannot be deleted.",0
@t4:	.byte	" ",0
.endif

BubbleSort:	; Sortieren von Byte-Werten in absteigender Reihenfolge
	; Par:	r2: Zeiger auf zu sortierenden Bereich
	;	    EndeKennzeichen: $ff
	; Des:	a,y,a2L
	LoadB	a2L,0
	ldy	#01
@10:	lda	(r2),y
	cmp	#$ff
	beq	@30
	dey
	cmp	(r2),y
	bcc	@19
	; austauschen
	lda	(r2),y
	pha
	iny
	lda	(r2),y
	dey
	sta	(r2),y
	iny
	pla
	sta	(r2),y
	LoadB	a2L,1
	bne	@20
@19:	iny
@20:	iny
	bne	@10
@30:	lda	a2L
	bne	BubbleSort
	rts
GetAktlDisk:	; Die Diskette des aktuellen Fensters wird zur Verf}gung gestellt
	; Par:	---
	; Ret:	curDrive
	; 	x : aktuelle Fensternummer
	; 	a : Fehlernummer (!), bei 0 ist C=0 , sonst C=1
	; Des:	a,x,y,r1-r5,r7-r15 (u.a. wegen DoDlgBox!)
	; Alt:	Laufwerks-, u. Diskparameter (OpenDisk wird ausgef}hrt!)
	ldx	activeWindow
	PushW	r0
	PushW	r6
	jsr	GetDisk
	stx	a9H
	PopW	r6
	PopW	r0
	ldx	activeWindow
	clc
	lda	a9H
	beq	@10
	sec
@10:	rts
GetDisk:	;Die einem Fenster zugeh|rige Diskette wird zur Verf}gung gestellt
	; Par:	x : Fensternummer
	; Ret:	curDrive
	; 	x : Fehlernummer, bei 0 ist C=0 , sonst C=1
	; Des:	a,y
	; Alt:	Laufwerks-, u. Diskparameter (OpenDisk wird ausgef}hrt?)
	txa
	pha
	jsr	GetWinDisk
	PushW	r0
	LoadW___	r6,DiskName+2
	jsr	SearchDisk
	PopW	r0
	clc
	txa
	beq	@10
	pla
	sec
	rts
@10:	pla
	tax
	lda	curDrive
	sta	winDrives,x
	clc
	adc	#57
	ldy	#0
	sta	(r0),y
	ldx	#0
	clc
	rts

FehlerAusgabe2:	; Fehler, mit autom. Schlie~en des Fensters messageBuffer+1
	ldy	messageBuffer+1
	lda	#0
	sta	windowsOpen,y
FehlerAusgabe:	; Dialogbox-Anzeige f}r Diskettenfehlermeldungen
	; Par:	x: Fehlernummer
	; 	bei x = $80 Doppelseitig-Fehler
	cpx	#$80
	bne	@05
	LoadWr0	@db2
	jmp	@30
@05:	cpx	#12
	beq	@40
	lda	curDrive
	clc
	adc	#57
	sta	@dr
	txa
	and	#$f0
	lsr
	lsr
	lsr
	lsr
	clc
	adc	#$30
	cmp	#$3a
	bcc	@10
	adc	#$06
@10:	sta	@nr
	txa
	and	#$0f
	clc
	adc	#$30
	cmp	#$3a
	bcc	@20
	adc	#$06
@20:	sta	@nr+1
	txa
	ldy	#3
@loop:	cmp	@errtab,y
	beq	@22
	dey
	bpl	@loop
	LoadW___	a2,@notext
	jmp	@24
@22:	tya
	asl
	tax
	lda	@tab,x
	sta	a2L
	inx
	lda	@tab,x
	sta	a2H
@24:	LoadWr0	@db
@30:	LoadB	DialBoxFlag,2
	jsr	DoDlgBox
@40:	jsr	ClearMultiFile
	jsr	MaxTextWin
	PushB	messageBuffer+1
	jsr	RedrawAll
	PopB	messageBuffer+1
	rts

@db:	.byte	$81
	.byte	$01,17,72
	.byte	$0b,$10,14
	.word	@t1
	.byte	$0b,$10,28
	.word	@t2
	.byte	$0b,$10,42
	.word	@t3
	.byte	$0c,$10,56,a2
	.byte	$0b,$10,70
	.word	@t4
	.byte	NULL
.ifdef lang_de
@t1:	.byte	BOLDON,"Achtung!",PLAINTEXT,0
@t2:	.byte	"Operation abgebrochen aufgrund",0
@t3:	.byte	"des Diskettenfehlers $"
@nr:	.byte	"..",0
@t4:	.byte	"auf Laufwerk "
@dr:	.byte	".",0
.else
@t1:	.byte	BOLDON,"Attention!",PLAINTEXT,0
@t2:	.byte	"function aborted due to",0
@t3:	.byte	"disk error $"
@nr:	.byte	"..",0
@t4:	.byte	"auf Laufwerk "
@dr:	.byte	".",0
.endif
@db2:	.byte	$81
	.byte	$0b,$10,$10
	.word	@t1b
	.byte	$0b,$10,$20
	.word	@t2b
	.byte	OK,17,72,0
.ifdef lang_de
@t1b:	.byte	BOLDON,"Fehler!",0
@t2b:	.byte	"Doppelseitige Disk in 1541.",0
.else
@t1b:	.byte	BOLDON,"Error!",0
@t2b:	.byte	"Double sided disk in 1541.",0
.endif

@errtab:	.byte	$21,FILE_EXISTS,3,10
@tab:	.word	@et1,@et2,@et3,@et4
.ifdef lang_de
@et1:	.byte	"keine formatierte Diskette",0
@et2:	.byte	"Name bereits vergeben",0
@et3:	.byte	"Diskette voll",0
@et4:	.byte	"unpassende Dateistruktur",0
.else
@et1:	.byte	"No formatted disk",0
@et2:	.byte	"Name already in use",0
@et3:	.byte	"Disk full",0
@et4:	.byte	"incorrect file structure",0
.endif
@notext:	.byte	0
GenTab:	.byte	0,0,0,0
.ifdef topdesk128
GenData:	.word	GenTab,DARecSpace
.else
GenData:	.word	GenTab,$7f80
.endif

MySubMenuDA:	LoadW___	GenData+2,DARecSpace
	bne	MySub2
.ifdef topdesk128
MySubMenu:	LoadW___	GenData+2,DARecSpace
.else
MySubMenu:	LoadW___	GenData+2,$7f80
.endif
MySub2:
.ifdef topdesk128
    LoadB    MyCurRec, 0
.endif
    pla
	clc
	adc	#1
	sta	@r0
	sta	r0L
	pla
	adc	#0
	sta	@r0+1
	sta	r0H
.ifdef topdesk128
    jsr MoveShortCuts
.endif
	LoadB	OpenDiskFlag,1
	ldy	#00
	lda	(r0),y
	sta	GenTab+1
	iny
	lda	(r0),y
	clc
	adc	#01
	sta	GenTab+3
	iny
	lda	(r0),y
	sta	r1L
	iny
	lda	(r0),y
	lsr
	lda	r1L
	ror
	lsr
	lsr
	sta	GenTab+0
	iny
	lda	(r0),y
	sta	r1L
	iny
	lda	(r0),y
	lsr
	lda	r1L
	ror
	lsr
	lsr
	clc
	adc	#01
	sta	GenTab+2
	ldy	#3
@dloop:	lda	GenData,y
	sta	r0L,y
	dey
	bpl	@dloop
	jsr	SaveFG
	MoveW_	@r0,r0
	MoveW_	RecoverVector,@r0
	LoadW___	RecoverVector,@10
	rts
@10:	ldy	#3
@dloop2:	lda	GenData,y
	sta	r0L,y
	dey
	bpl	@dloop2
	jsr	RecvFG
	MoveW_	@r0,RecoverVector
	rts
@r0:	.word 0

SaveFG:	; Vordergrundbereich retten
	; r0: Zeiger auf Tabelle der Rechteckdaten
	; r1: Zeiger auf Ablagebereich
	; Zerst|rt: r2,r3,r5,r6
	lda	#<(-1)
	.byte	$2c
RecvFG:	; Vordergrundbereich wiederherstellen
	; r0: Zeiger auf Tabelle der Rechteckdaten
	; r1: Zeiger auf Ablagebereich
	; Zerst|rt: r2,r3,r5,r6
	lda	#00
	sta	r3L
	lda	dispBufferOn
	pha
	LoadB	dispBufferOn,%10000000
.ifdef topdesk128
    jsr HideOnlyMouse
.endif
	ldy	#01
	lda	(r0),y
	sta	r2L
@05:	tax
	jsr	GetScanLine
	ldy	#00
	lda	(r0),y
	sta	r2H
@10:
.ifdef topdesk128
    ldx r5H
    bmi @11
    tay
    clc
    bcc @12
@11:
.endif
	asl
	asl
	asl
	tay
.ifdef topdesk128
@12:
.endif
	PushW	r5
	bcc	@14
	inc r5H
@14:	lda	r3L
	beq	@15
.ifdef topdesk128
	lda	r5H
    bmi @64a
    jsr ldar5yM
    jmp @n10
@64a:
    lda (r5),y
@n10:
.else
    lda (r5),y
.endif
	ldy	#00
	sta	(r1),y
	jmp	@16
@15:	sty	r3H
	ldy	#00
	lda	(r1),y
	ldy	r3H
.ifdef topdesk128
	tax
	lda r5H
	bmi @64b
	txa
	jsr star5yM
	jmp @16
@64b:
    txa
.endif
    sta (r5),y
@16:	PopW	r5
	IncW	r1
	inc	r2H
	ldy	#2
	lda	r2H
	cmp	(r0),y
	bne	@10
	inc	r2L
	lda	r2L
	ldy	#3
	cmp	(r0),y
	bne	@05
	pla
	sta	dispBufferOn
	rts

.ifdef topdesk128

ldar5yM:
    tya
    pha
    txa
    pha
    DecW    r5
    ;lda    (r5),y
    tya
    clc
    adc r5L
    php
    ldx #$13
    jsr SetReg
    dex
    plp
    lda r5H
    adc #0
    jsr SetReg
    ldx #$1f
    jsr GetReg
    jsr GetReg
    sta @b
    IncW    r5
    pla
    tax
    pla
    tay
    lda @b
    rts
@b: .byte 0

star5yM:
    sta @b
    tya
    pha
    txa
    pha
    ;sta    (r5), y
    tya
    clc
    adc r5L
    php
    ldx #$13
    jsr SetReg
    dex
    plp
    lda r5H
    adc #0
    jsr SetReg
    ldx #$1f
    lda @b
    jsr SetReg
    ldx #$12
    jsr GetReg
    pla
    tax
    pla
    tay
    rts
@b: .byte 0

MoveShortCuts:
    ldy #4
    lda (r0),y
    sta r3L
    iny
    lda (r0),y
    sta r3H
    iny
    lda (r0),y
    and #$3f
    sta r2H
    iny
    SubVW_   25,r3
@loop2:
    sty r2L
    lda (r0),y
    sta r1L
    iny
    lda (r0),y
    sta r1H
    ldy #0
@loop:
    lda (r1),y
    beq @next
    cmp #GOTOX
    beq @habs
    iny
    bne @loop
@habs:
    iny
    lda r3L
    sta (r1),y
    iny
    lda r3H
    sta (r1),y
@next:
    lda r2L
    clc
    adc #5
    tay
    dec r2H
    bne @loop2
    rts
.endif

SubDir1List:	; SubDirxLists m}ssen aufeinander folgen!
SubDir2List	= SubDir1List + 64
SubDir3List	= SubDir2List + 64
SubDir4List	= SubDir3List+ 64
MultiFileTab	= SubDir4List+64
Name	= MultiFileTab + 145
DiskName	= Name + 19
Name2	= DiskName + 19
RegBuf	= Name2 + 19
FileTab1	= RegBuf + r15H
	; Aufbau:	16 Eintr{ge mit jew.	16 Bytes Filename
	; 		2  Bytes Info-Tr/Sc
	; 	16 Eintr{ge mit jew. 64 Bytes Icon
FileTab2	= FileTab1+16*18+16*64
FileTab3	= FileTab2+16*18+16*64
FileTab4	= FileTab3+16*18+16*64
ModStart	= FileTab4+16*18+16*64
DASpace	= ModStart	; s 137
DARecSpace	= DASpace+137

.export __MODSTART__ := ModStart
