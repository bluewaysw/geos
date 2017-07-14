.segment "OVERLAY4"

; Datum: 6.8.91
curHeight	=	$29
;	n	"DeskMod D"
;if .p
.include "topdesk/Include/Symbol/TopSym.inc"
.include "geosmac.inc"
.include "topdesk/Include/Symbol/Sym128.erg.inc"
.include "topdesk/Include/Symbol/CiSym.inc"
.include "topdesk/Include/Symbol/CiMac.inc"
;	t	"DeskWindows..ext"
;	t	"DeskTop.main.ext"
;endif
;	o	ModStart
;	jmp	FileInfo

.global NewDoDlgBox
.global SearchDisk
.global ReloadActiveWindow
.global FehlerAusgabe
.global GetAktlDisk
.global ClearMultiFile2
.global SubDir1List
.global GetAktlWinDisk
.global RecoverActiveWindow
.global DialBoxFlag
.global RemSubName
.global aktl_Sub
.global ClearList
.global GetSubDirXList
.global activeWindow
.global CopyMemHigh
.global MaxTextWin
.global DiskDriverFlag

.global CopyFile
.global CopyMemLow
.global DestinationDir
.global messageBuffer
.global GetFileName
.global GetMark
.global MultiCount

.global MinEiner
.global MinZehner
.global StdEiner
.global StdZehner
.global JahEiner
.global JahZehner
.global MonEiner
.global MonZehner
.global TagEiner
.global TagZehner
.global ShowClock
.global ModDepth
.global ClearMultiFile
.global Loadr0AX

.global KBytesFlag
.global StringLen
.global RecoverLast

.ifdef topdesk128
.global TypTab
.endif

SubDir2List	= SubDir1List + 64
SubDir3List	= SubDir2List + 64
SubDir4List	= SubDir3List+ 64
MultiFileTab	= SubDir4List+64
Name	= MultiFileTab + 145

; FileBox-Position:
FIB_OBEN	=	40
FIB_UNTEN	=	180
.ifdef topdesk128
FIB_LINKS	=	70+DOUBLE_W
FIB_RECHTS	=	250+DOUBLE_W
.else
FIB_LINKS	=	70
FIB_RECHTS	=	250
.endif
FileInfo:	jsr	GetAktlDisk
	tax
	beq	@05
	jsr	ClearMultiFile2
	cpx	#12
	beq	@07
	jmp	FehlerAusgabe
@05:	ldx	MultiCount
	dex
	bpl	@geht
@07:	rts
@geht:	LoadW___	r2,MultiFileTab
@10:	jsr	GetMark
	tax
	bmi	@20
	jsr	GetFileName
	LoadB	DialBoxFlag,2
	jsr	DispThisInfo
	txa
	beq	@10
	jmp	FehlerAusgabe
@20:	LoadB	DialBoxFlag,0
	jmp	RecoverLast
.macro DbText x0, y0, adr
	.byte	$0b,x0,y0
	.word	adr
.endmacro

Text	= fileHeader+$a0
AlternateFlag:	.byte	0
DispThisInfo:	; File-Info des Files Name darstellen
	LoadW___	r6,Name
	jsr	FindFile
	txa
	bne	@err
	PushW	r1
	PushW	r5
	jsr	i_FillRam
	.word	$ff,$8100
	.byte	0
	lda	$8400+22
	beq	@10
	MoveW_	$8400+19,r1
	LoadW___	r4,$8100
	jsr	GetBlock
	txa
	beq	@10
	PopW	r5
	PopW	r1
@err:	rts
@10:	LoadW___	r0,Name
	jsr	StringLen
	lsr	r1L
	lda	#(FIB_RECHTS-FIB_LINKS)/2-10
	sec
	sbc	r1L
	sta	@titelpos+1	
	LoadW___	a1,$8100+77
	LoadW___	a3,$8100+97
	LoadW___	a4,@ta
	ldx	$8100+70
	beq	@20
	LoadW___	a4,@tb
@20:	lda	$8400+22
	tay
	lda	AutTab,y
	bne	@22
	LoadW___	a3,@tn	; kein Autor anzeigen
@22:	tya
	asl
	tay
	lda	TypTab,y
	sta	a2L
	lda	TypTab+1,y
	sta	a2H
	LoadB	AlternateFlag,0
	LoadW___	r0,@db
	jsr	NewDoDlgBox
	PopW	r5
	PopW	r1
	ldx	AlternateFlag
	beq	@err2
	ldy	#0
	lda	$8400
	sta	(r5),y
	sta	fileHeader+68
	LoadW___	r4,$8000
	jsr	PutBlock
	txa
	bne	@err2
	MoveW_	dirEntryBuf+19,r1
	lda	$8400+22
	beq	@err2
	LoadW___	r4,fileHeader
	jmp	PutBlock
@err2:	rts
@ta:	.byte	"sequentiell",0
@tb:	.byte	"VLIR"
@tn:	.byte	0
@db:	.byte	$01
	.byte	FIB_OBEN,FIB_UNTEN
	.word	FIB_LINKS,FIB_RECHTS
	DbText	50,10,@boldtext
@titelpos:	DbText	70,12,Name
	DbText	10,30,@t1
	DbText	10,40,@t2
	DbText	10,50,@t3
	DbText	10,60,@t7
	DbText	10,70,@t4
	DbText	10,80,@t5
	DbText	60,91,@t6
	.byte	$0c,55,30,a1	; Klasse
	.byte	$0c,55,40,a2	; Filetyp
	.byte	$0c,55,50,a3	; Autor
	.byte	$0c,55,60,a4	; Struktur
	.byte	$13
	.word	@PutSize
	.byte	$13
	.word	@PutDate
	.byte	$13
	.word	@Layout
	.byte	17
	.word	@Check
	.byte	$13
	.word	EditText
	.byte	18,21,4
	.word	CloseIcon
	.byte	NULL
@boldtext:	.byte	BOLDON,0
@t1:	.byte	PLAINTEXT,"Klasse:",0
@t2:	.byte	"FileTyp:",0
@t3:	.byte	"Autor:",0
@t4:	.byte	"Datum:",0
@t5:	.byte	"Gr|~e: ",0
@t6:	.byte	"Schreibschutz",BOLDON,0
@t7:	.byte	"Struktur:",0
@PutSize:	MoveW_	$8400+28,r0
	LoadW___	r11,FIB_LINKS+55
	LoadB	r1H,FIB_OBEN+80
	lda	KBytesFlag
	cmp	#'*'
	beq	@ps10
	lda	r0L
	pha
	lsr	r0H
	ror	r0L
	lsr	r0H
	ror	r0L
	pla
	and	#%00000011
	beq	@noround
	inc	r0L
	lda	r0L
	bne	@noround
	inc	r0H
@noround:	lda	#%11000000
	jsr	PutDecimal
	LoadW___	r0,@KBytes
	jmp	PutString
@ps10:	lda	#%11000000
	jsr	PutDecimal
	LoadW___	r0,@Blocks
	jmp	PutString
@Blocks:	.byte	" Bl|cke",0
@KBytes:	.byte	" KByte(s)",0
@PutDate:	LoadW___	r11,FIB_LINKS+55
	LoadB	r1H,FIB_OBEN+70
	ldy	#0
	sty	a4L
@pd05:	lda	@tab1,y
	tay
	lda	$8400,y
	sta	r0L
	LoadB	r0H,0
	ldy	a4L
	lda	@tab3,y
	beq	@pd07
	lda	r0L
	cmp	#10
	bcs	@pd07
	lda	#'0'
	jsr	PutChar
@pd07:	lda	#%11000000
	jsr	PutDecimal
	ldy	a4L
	lda	@tab2,y
	beq	@pd10
	jsr	PutChar
	inc	a4L
	ldy	a4L
	bne	@pd05
@pd10:	lda	#PLAINTEXT
	jmp	PutChar
@tab1:	.byte	25,24,23,26,27
@tab2:	.byte	".","."," ",":",0
@tab3:	.byte	0,0,1,0,1
@Layout:	jsr	i_FrameRectangle
	.byte	FIB_OBEN+2,FIB_UNTEN-2
	.word	FIB_LINKS+2,FIB_RECHTS-2
	.byte	%11111111
	jsr	i_FrameRectangle
	.byte	FIB_OBEN+4,FIB_OBEN+16
	.word	FIB_LINKS+2,FIB_RECHTS-2
	.byte	%11111111
	jsr	i_FrameRectangle
	.byte	FIB_OBEN+85,FIB_OBEN+92
	.word	FIB_LINKS+50,FIB_LINKS+57
	.byte	%11111111
	lda	$8400
	and	#$40
	beq	@l10
	jsr	InvertRectangle
@l10:	rts
@Check:	lda	mouseData
	bne	@c05
	rts
@c05:	LoadB	r2L,FIB_OBEN+85
	LoadB	r2H,FIB_OBEN+92
	LoadW___	r3,FIB_LINKS+50
	LoadW___	r4,FIB_LINKS+57
	jsr	IsMseInRegion
	beq	@c10
	LoadB	AlternateFlag,$ff
	lda	$8400
	eor	#$40
	sta	$8400
	jmp	InvertRectangle
@c10:	rts
CloseRoutine:	jmp	RstrFrmDialog

.include "topdesk/DeskInclude/EditText.inc"
AutTab:	.byte	0,1,1,0,1,1,1,0,0,1,1,0,1,0,1,1

.ifndef topdesk128
TypTab:	.word	@t0,@t1,@t2,@t3,@t4,@t5,@t6,@t7,@t8,@t9,@ta,@tb,@tc,@td,@te,@tf
@t0:	.byte	"Nicht-GEOS",0
@t1:	.byte	"BASIC",0
@t2:	.byte	"Assembler",0
@t3:	.byte	"Data",0
@t4:	.byte	"Systemdatei",0
@t5:	.byte	"Hilfsprogramm",0
@t6:	.byte	"Anwendung",0
@t7:	.byte	"Dokument",0
@t8:	.byte	"Zeichensatzdatei",0
@t9:	.byte	"Druckertreiber",0
@ta:	.byte	"Eingabetreiber (64)",0
@tb:	.byte	"Directory",0
@tc:	.byte	"Startprogramm",0
@td:	.byte	"Tempor{r",0
@te:	.byte	"selbstausf}hrend",0
@tf:	.byte	"Eingabetreiber (128)",0
.endif

CloseMap:
.incbin "topdesk/CloseMap.map"
;CloseX	= .x
;CloseY	= .y-3
CloseX	= 2
CloseY	= 16-3

CloseIcon:	.word	CloseMap
	.byte	0,0
	.byte	CloseX,CloseY
	.word	CloseRoutine
