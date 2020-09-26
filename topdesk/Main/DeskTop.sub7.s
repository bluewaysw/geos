.segment "OVERLAY7"
;	n	"DeskMod G"
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

.global GetFileRect
.global windowOffs
.global DispMarking
.global NewPutString
.global DrawMap
.global CutRec
.global GetClipRec
.global University
.global SetTextWin
.global NewRectangle
.global DispMode
.global winMode
.global MyDCFilesSub

.global fileNum
.global GetWinTabAdr
.global NewPutDecimal

.global GetWinName
.global GetEqualWindows
.global MyCurRec
.global NewSetDevice
.global Start2
.global SetCopyMemLow
.global NewGetFile
.global GetPrefs2
.global GetIconService
.global DispJumpTable
.global DeskOther
.global newAppMain
.global DeskMain
.global NewDoIcons
.global IconTab
.global SetNumDrives
.global KeyHandler
.global backPattern
.global RedrawHead
.global DoWindows
.global WindowTab
.global windowsOpen
.global RamTopFlag
.global PrintDriveNames
.global RedrawAll
.global FileClassNr

SubDir2List	= SubDir1List + 64
SubDir3List	= SubDir2List + 64
SubDir4List	= SubDir3List+ 64
MultiFileTab	= SubDir4List+64
Name	= MultiFileTab + 145
DiskName	= Name + 19

;	jmp	_SwapFile
	nop
	nop
	nop
	jmp	DeskRelabel
	jmp	DeskFormat
	jmp	StartUp
	jmp	InstallDriver
InstallDriver:	
	lda	firstBoot
	bpl	@10
	jsr	GetAktlDisk
	tax
	beq	@10
	cpx	#12
	beq	@05
	jmp	FehlerAusgabe
@05:	rts
@10:	lda	FileClassNr
	cmp	#PRINTER
	bne	@Prnt6
	LoadW___	@Prnt3,PrntFileName
	LoadW___	r14,@PrntZeile1_1
	jmp	@Prnt7
@Prnt6:	LoadW___	@Prnt3,inputDevName
	LoadW___	r14,@PrntZeile1_2
@Prnt7:	lda	firstBoot
	beq	@Prnt1
	PushW	r15
	LoadW___	r0,@PrntDial
	jsr	NewDoDlgBox
	PopW	r15
	lda	r0L
	cmp	#OK
	beq	@Prnt1
	rts
@Prnt1:	lda	FileClassNr
	cmp	#PRINTER
	beq	@Prnt8
	jsr	DA1
	txa
	bne	@rts
	jsr	@Prnt8a
	jsr	StashDrivers
	jsr	InitMouse
	ldx	#0		
@rts:	rts
@Prnt8:
	lda	c128Flag
	bpl	@Prnt8a
	jsr	DA1
.ifndef mega65
	LoadW___	r0,$7900
	LoadW___	r1,$d9c0
	LoadW___	r2,$640
	LoadB	r3L,$01
	sta	r3H	; FrontRam nach FrontRam
	PushW	r15
	jsr	MoveBData
	dec	r1H	; r1 = $d8c0
	LoadB	r0H,$81
	LoadW___	r2,$100
	jsr	MoveBData
	PopW	r15
.endif
@Prnt8a:	
	MoveW_	r15,@Prnt2
	jsr	i_MoveData
@Prnt2:	.word	0
@Prnt3:	.word	PrntFileName
	.word	16
	lda	firstBoot
	bpl	@Prnt8b
	jsr	RedrawAll
	jmp	StashDrivers
@Prnt8b:	jsr	PrintDriveNames
	jmp	StashDrivers
@PrntDial:
	.byte	$81
	.byte	DBTXTSTR,$10,$10
	.word	@PrntZeile1
	.byte	DBVARSTR,$10,$20,r14
	.byte	DBVARSTR,$10,$30,r15
	.byte	DBTXTSTR,$10,$40
	.word	@PrntZeile2
	.byte	OK,1,76
	.byte	CANCEL,16,76
	.byte	NULL
.ifdef lang_de
@PrntZeile1:	.byte	BOLDON,"Neuen ",0
@PrntZeile1_1:	.byte	"Druckertreiber",0
@PrntZeile1_2:	.byte	"Eingabetreiber",0
@PrntZeile2:	.byte	"installieren?",0
.else
@PrntZeile1:	.byte	BOLDON,"Install new ",0
@PrntZeile1_1:	.byte	"Printer driver?",0
@PrntZeile1_2:	.byte	"Input driver?",0
@PrntZeile2:	.byte	" ",0
.endif
DA1:	MoveW_	r15,r6
	lda	#$00
	sta	r0L
	sta	r10L
	jmp	GetFile
	
StashDrivers:	
	rts
	lda	sysRAMFlg
	and	#%00100000
	bne	@10
@05:	rts
@10:	lda	c128Flag
	bpl	@15
	lda	sysRAMFlg	; Flag f}r Getfile setzen
	ora	#$10
	sta	sysRAMFlg
	ldy	#7
@12:	lda	@tab2,y
	sta	r0L,y
	dey
	bpl	@12
	jsr	StashRAM	; Druckertreiber nach REU

	LoadW___	r0,$fd00	; Input 128
	LoadW___	r1,$f940
	jmp	@20

@15:	LoadW___	r0,$fe80	; bzw. Input 64 nach REU
	LoadW___	r1,$fac0
@20:	LoadW___	r2,$0180
	LoadB	r3L,0
	jsr	StashRAM
	lda	sysRAMFlg
	and	#%00100000
	beq	@05
	ldy	#7
@22:	lda	@tab2,y
	sta	r0L,y
	dey
	bpl	@22
	jmp	StashRAM

@tab1:	.word	$d8c0,$d500,$e000-$d8c0
	.byte	0
@tab2:	.word	$8400,$7900,$0500
	.byte	0
myserial:	.word	0

	;.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
StartUp:
	lda	RamTopFlag
	beq	@norm
	lda	sysRAMFlg	; REU-MoveData ausschalten
	and	#$7f
	sta	sysRAMFlg
@norm:	
.ifndef topdesk128
 	lda	c128Flag
	bpl	@010
	lda	graphMode
	bpl	@010
	and	#$7f
	sta	graphMode
	jsr	SetNewMode
.endif
@010:	LoadB	iconSelFlag,0
	ldy	#3
@loop2:	lda	windowsOpen,y
	pha
	lda	#0
	sta	windowsOpen,y
	dey
	bpl	@loop2
	LoadWr0	WindowTab
	jsr	DoWindows
	jsr	RedrawHead
	lda	screencolors
	sta	@col
	jsr	i_FillRam
	.word	1000,$8c00
@col:	.byte	0
	ldx	#$c0
	lda	#$95
	sec
	adc	#0
	inx
	jsr	CallRoutine
	CmpW	r0,myserial
	bne	@neu
	jmp	@allesok
@neu:	LoadW___	r0,@neudb
	LoadB	RecoverVector,0
	sta	RecoverVector+1
	jsr	DoDlgBox
	jmp	EnterDeskTop
@neudb:	.byte	$81
	.byte	$0b,$10,$10
	.word	@t1
	.byte	$0b,$10,$20
	.word	@t2
	.byte	$0b,$10,$30
	.word	@t3
	.byte	OK,14,72,NULL
.ifdef lang_de
@t1:	.byte	BOLDON,"Bitte neu starten. Gleiche",0
@t2:	.byte	"Systemdiskette verwenden wie",0
@t3:	.byte	"bei Installation von TopDesk.",0
.else
@t1:	.byte	BOLDON,"Please start again. Use",0
@t2:	.byte	"the same Bootdisk as",0
@t3:	.byte	"with TopDesk installation.",0
.endif
@allesok:
	LoadB	backPattern,2
	LoadW___	keyVector,KeyHandler
	jsr	SetNumDrives
	ldx	numDrives
	inx
	inx
	stx	IconTab
	LoadWr0	IconTab
	jsr	NewDoIcons
	LoadW___	newAppMain,DeskMain
	LoadW___	otherPressVec,DeskOther
	jsr	ClearMultiFile
	lda	DispJumpTable
	bne	@10
	jsr	GetIconService
@10:	LoadB	firstBoot,0
	lda	inputDevName
	bne	@30
	jsr	GetPrefs2
.ifdef mega65
	lda	#10	; Input 64
.else
	lda	#10	; Input 64
	ldx	c128Flag
	bpl	@20
	lda	#15	; Input 128
.endif
@20:	sta	r7L
	LoadB	r7H,1
	LoadB	Name,0
	LoadW___	r6,Name
	jsr	FindFTypes
	lda	Name
	beq	@30
	LoadB	r1L,0
	LoadW___	r6,Name
	jsr	NewGetFile
@30:	lda	PrntFileName
	bne	@40
	LoadB	r7L,9	; Printer
	LoadB	r7H,1
	LoadB	Name,0
	LoadW___	r6,Name
	jsr	FindFTypes
	lda	Name
	beq	@40
	LoadB	r1L,0
	LoadW___	r6,Name
	jsr	NewGetFile
@40:	LoadB	firstBoot,$ff
	jsr	SetCopyMemLow
	ldy	#0
@loop3:	pla
	sta	windowsOpen,y
	iny
	cpy	#4
	bne	@loop3
	jmp	Start2

.include "topdesk/DeskInclude/DosFormat.s.inc"

DeskFormat:	MoveB	curDrive,Name+2	; nur Zwischenspeicher
@dloop:	lda	curType
	and	#$80
	beq	@noram
	ldx	curDrive
	inx
	txa
	cmp	Name+2
	beq	@nodrive
	lda	driveType-8,x
	beq	@n8
	txa
	jsr	NewSetDevice
	txa
	beq	@dloop
@n8:	lda	#8
	cmp	Name+2
	beq	@nodrive
	jsr	NewSetDevice
	jmp	@dloop
@nodrive:	rts
@noram:	LoadB	Name+2,0
	PushB	numDrives
	cmp	#1
	bne	@05
	ldy	#0
	sty	@abhier
	beq	@08
@05:	LoadB	numDrives,4
	tay
	dey	; g}ltige Laufwerke ermitteln
@06:	lda	driveType,y
	tax
	beq	@06a	; d.h. keine nicht vorhandenen Laufwerke
	and	#%10000000	; und keine RAM-Disks
	bne	@06a
	sty	r1L
	jmp	@07
@06a:	dec	numDrives	; Eine ermittelte RAM-Disk wird nicht
	tya		; als zu formatierendes Laufwerk an-
	asl		; geboten, in dem das zugeh|rige
	tax		; Icon in der Dialogbox nicht
	lda	@icontab,x	; dargestellt wird, durch
	sta	r0L	; MoveW 0,:icontab+RamLaufw*2 .
	lda	@icontab+1,x
	sta	r0H
	ldy	#0
	tya
	sta	(r0),y
	iny
	sta	(r0),y
	sta	MyCurRec	; beim n{chsten Mal Modul erneut laden
	txa		; da Icontabelle modifiziert wurde
	lsr
	tay
@07:	dey
	bpl	@06
	ldx	numDrives	; nur ein g}ltiges Laufw. ?
	dex
	bne	@08	; >nein
	lda	#0
	sta	@abhier
	sta	MyCurRec	; beim n{chsten Mal Modul erneut laden
	lda	r1L	; da Icontabelle modifiziert wurde
	clc
	adc	#8
	jsr	NewSetDevice
@08:	PopB	numDrives
	lda	curDrive
@08geht:	clc
	adc	#57
	sta	@dr
@09:	LoadW___	a1,Name+2
	LoadW___	r0,@db
	inc	DialBoxFlag
	jsr	NewDoDlgBox
	lda	r0L
	cmp	#$02	; Abbruch-Feld geklickt?
	beq	@99	; >ja
	cmp	#$12	; Laufwerk ge{ndert ?
	bne	@10	; >nein
	jmp	@09
@10:	lda	@dr
	sec
	sbc	#57
	jsr	NewSetDevice
	lda	curType
	cmp	#2	; Soll auf 1571 formatiert werden ?
	bne	@99a	; >nein
	LoadW___	r0,@db2
	jsr	NewDoDlgBox	; "Doppelseitig formatieren?"
	LoadB	r1L,0	; Doppelseitig-Flag
	lda	r0L
	cmp	#2
	beq	@99	; Abbruch
	cmp	#YES
	bne	@99a
	LoadB	r1L,1	; Doppelseitig-Flag
@99a:	LoadW___	r0,Name+2
	jsr	DosFormat
	txa
	beq	@99
	inc	DialBoxFlag
	jmp	FehlerAusgabe
@99:	jmp	RedrawAll
@db:	.byte	$81
	.byte	$0b,$10,$10
	.word	@t1
	.byte	$0b,$10,$10+11
	.word	@t2
	.byte	$0b,$10,$10+22
	.word	@t3
	.byte	$0d,$10,$10+40,a1,16
	.byte	$02,17,72
@abhier:	.byte	$12,2,72
	.word	@icon1
	.byte	$12,5,72
	.word	@icon2
	.byte	$12,8,72
	.word	@icon3
	.byte	$12,11,72
	.word	@icon4
	.byte	NULL
.ifdef lang_de
@t1:	.byte	"Diskette zum Formatieren",0
@t2:	.byte	"in Laufwerk "
@dr:	.byte	". einlegen ",0
@t3:	.byte	"und Name eingeben:",0
.else
@t1:	.byte	"Insert disk to be formatted",0
@t2:	.byte	"in drive "
@dr:	.byte	". einlegen ",0
@t3:	.byte	"and enter name:",0
.endif
@icontab:	.word	@icon1,@icon2,@icon3,@icon4
@icon1:	.word	IconA,0
	.byte	ICON_X,ICON_Y
	.word	@icon1+8
	LoadB	@dr,'A'
	LoadB	$851d,$12
	jmp	RstrFrmDialogue
@icon2:	.word	IconB,0
	.byte	ICON_X,ICON_Y
	.word	@icon2+8
	LoadB	@dr,'B'
	LoadB	$851d,$12
	jmp	RstrFrmDialogue
@icon3:	.word	IconC,0
	.byte	ICON_X,ICON_Y
	.word	@icon3+8
	LoadB	@dr,'C'
	LoadB	$851d,$12
	jmp	RstrFrmDialogue
@icon4:	.word	IconD,0
	.byte	ICON_X,ICON_Y
	.word	@icon4+8
	LoadB	@dr,'D'
	LoadB	$851d,$12
	jmp	RstrFrmDialogue
@db2:	.byte	$81
	.byte	$0b,$10,$10
	.word	@2t1
	.byte	$0b,$10,$20
	.word	@2t2
	.byte	$0b,$10,$30
	.word	@2t3
	.byte	$02,17,72
	.byte	YES,2,72
	.byte	NO,9,72
	.byte	NULL
.ifdef lang_de
@2t1:	.byte	BOLDON,"Soll die Diskette",0
@2t2:	.byte	"doppelseitig formatiert ",0
@2t3:	.byte	"werden?",PLAINTEXT,0
.else
@2t1:	.byte	BOLDON,"Format the disk",0
@2t2:	.byte	"on both sides? ",0
@2t3:	.byte	PLAINTEXT,0
.endif
IconA:
.incbin "topdesk/IconA.map"
IconB:
.incbin "topdesk/IconB.map"
IconC:
.incbin "topdesk/IconC.map"
IconD:
.incbin "topdesk/IconD.map"

.ifdef topdesk128
ICON_X	= 2+DOUBLE_B
.else
ICON_X	= 2
.endif
ICON_Y	= 16

DeskRelabel:	ldx	activeWindow
	jsr	GetEqualWindows
	ldx	activeWindow
	lda	#1
	sta	a6L,x
	LoadB	DialBoxFlag,25	; irgendein Wert, m|glichst hoher Wert
	jsr	GetAktlWinDisk
	LoadW___	r6,DiskName+2
	jsr	Relabel
	txa
	bne	@end
	sta	a5H
	ldx	#3
@loop:	stx	a5L
	lda	a6L,x
	beq	@10
	inc	a5H
	txa
	jsr	GetWinName
	IncW	r1
	IncW	r1
	ldy	#00
@20:	lda	(r6),y
	beq	@30
	sta	(r1),y
	iny
	bne	@20
@30:	cpy	#16
	beq	@10
	lda	#PLAINTEXT
	sta	(r1),y
	iny
	bne	@30
@10:	ldx	a5L
	dex
	bpl	@loop
	ldx	a5H
	dex
	bne	@40
@end:	LoadB	DialBoxFlag,0
	jmp	RecoverLast
@40:	LoadB	DialBoxFlag,0
	jmp	RedrawAll
; Relabel
; belegt eine Diskette mit einem neuen Namen
; Par: r6 - Zeiger auf den Diskettennamen
; Ret: x=0 kein Fehler
;      r6 - neuer Diskettenname
; Des: a,y,r0-r5
Relabel:
	jsr	SearchDisk
	txa
	bne	@err
	ldy	#0
@a10:	lda	(r6),y
	sta	diskBlkBuf,y
	beq	@a20
	iny
	bne	@a10
@a20:	PushW	r6
	LoadW___	r5,diskBlkBuf	;DoDlgBox vorbereiten
	LoadW___	r0,@renbox
	jsr	NewDoDlgBox
	PopW	r6
	ldy	r0L	;auf Abbruch
	cpy	#CANCEL	;pr}fen
	beq	@13	;ja :13
	lda	diskBlkBuf	;auf Leerstring pr}fen
	bne	@15	;nein :15
@13:	ldx	#CANCEL_ERR
@err:	rts
@15:	jsr	GetDirHead	;
	txa
	bne	@err
	ldy	#15	;Diskname
@20:	lda	#$a0
	sta	curDirHead+144,y
	dey
	bpl	@20
	ldy	#0
@30:	lda	diskBlkBuf,y	;in die BAM
	sta	(r6),y	;und in die ]bergabe
	beq	@40	;}bertragen
	sta	curDirHead+144,y
	iny
	cpy	#16
	bne	@30
@40:	jmp	PutDirHead
@renbox:
	.byte	$81
	.byte	DBTXTSTR
	.byte	10,20
	.word	@rentext
	.byte	DBTXTSTR
	.byte	10,30
	.word	@rentxt2
	.byte	DBGETSTRING
	.byte	10,40,r5,16
	.byte	CANCEL
	.byte	16,72
	.byte	NULL

.ifdef lang_de
@rentext:	.byte	BOLDON,"Bitte geben Sie den neuen",0
@rentxt2:	.byte	"Diskettennamen ein:",PLAINTEXT,0
.else
@rentext:	.byte	BOLDON,"Please enter the new",0
@rentxt2:	.byte	"disk name:",PLAINTEXT,0
.endif
