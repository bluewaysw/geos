;	a	"DPT KnCiGo"
;	z	$c0	; ehem. $40
;	i
;	p	Start
.feature force_range

.segment "STARTUP"


;if .p
.include "topdesk/Include/Symbol/TopSym.inc"
.include "geosmac.inc"
.include "topdesk/Include/Symbol/Sym128.erg.inc"
.include "topdesk/Include/Symbol/CiSym.inc"
.include "topdesk/Include/Symbol/CiMac.inc"
;.include "topdesk/Main/DeskWindows.ext.inc"
;endif
;	d	"DeskWin $400"

.include "topdesk/Main/DeskWindows.akt.inc"


;	n	"Dos.res"
;	c	"TopDesk     V1.3"
__NewSetDevice:
	jmp	NewSetDevice
__DispMarking:
	jmp	DispMarking
__ClearMultiFile:
	jmp	ClearMultiFile

.include "topdesk/DeskInclude/CopyFile.inc"
.include "topdesk/DeskInclude/SearchDisk.inc"
.include "topdesk/DeskInclude/SizeRectangle.inc"
.include "topdesk/Include/SubDir.src.inc"

.global __NewSetDevice
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
.global MultiFileTab
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

.global NewSearchDisk
.global GetWinDisk

.global CopyService
.global FindDirFiles
.global MoveFileInDir
.global subTab

.global Start
.global RegBuf
.global FileTab1
.global PruefSumme
.global RamStart
.global ModStartAdress
.global MainAdr
.global MyName
.global SearchDeskTop
.global __STARTUP_RUN__

.ifdef topdesk128
.global TypTab
.global SchmalFlag
.endif


__STARTUP_RUN__:

Start:
.ifdef topdesk128
    jsr SetMyNewMode
.endif
.ifdef topdesk13
	lda	RamTopFlag
.ifdef topdesk128
	beq @05
	lda oldGraphMode
	cmp graphMode
	beq @10
	jsr SwitchWin
	jmp @10
@05:
    jsr StartWin
.endif
	ldy	#4
@tloop:	lda	@t,y
	cmp	$81a0,y
	bne	@10
	dey
	bpl	@tloop
	LoadB	SureFlag,1
.endif
@10:
.ifdef topdesk128
    MoveB   graphMode, oldGraphMode
.endif
	lda	mouseData
	ora	#$80
	sta	mouseData

	LoadW___	ModStartAdress,ModStart
	LoadB	dispBufferOn,%10000000
	ldy	#0
@loop:	lda	$8403,y
	cmp	#$a0
	bne	@01
	lda	#0
	sta	MyName,y
	beq	@02
@01:	sta	MyName,y
	iny
	bne	@loop
@02:
    jmp	StartUp

.ifdef topdesk13
 @t:	.byte	"SURE",$0d
.endif

Loadr0AX:	sta	r0L
	stx	r0H
	rts

MoveWr0r1:	MoveW_	r0,r1
	rts
MoveWr1r0:	MoveW_	r1,r0
	rts
OpenDiskFlag:	.byte	0
DiskDriverFlag:	.byte	0

NewSetDevice:
.ifdef topdesk128
    jmp SetDevice
.else
	ldy	DiskDriverFlag
	bpl	@04
	rts
@04:	bne	@10
@05:	jmp	SetDevice
@10:	tay
	lda	driveType-8,y
	bne	@15
	tya
	bne	@05
@15:	cmp	DiskDriverFlag
	beq	@21
	tya
	bne	@05
@21:	ldx	#29
@20:	lda	r0L,x
	pha
	dex
	bpl	@20
	tya
	pha
	jsr	ExitTurbo
	LoadW___	r0,$7200
	LoadW___	r1,$9000
	ldy	#0
@loop:	lda	(r0),y
	tax
	lda	(r1),y
	sta	(r0),y
	txa
	sta	(r1),y
	IncW	r0
	IncW	r1
	CmpWI	r1,$9d80
	bne	@loop
	MoveB	curType,DiskDriverFlag
	pla
	tax
	ldy	#0
@30:	pla
	sta	r0L,y
	iny
	cpy	#30
	bcc	@30
	txa
	jmp	SetDevice
.endif

CopyMemHigh:	.byte	$7f
CopyMemLow:		.byte	$60
SetCopyMemLow:	ldx	#>(ModStart+$100)

SCML:	stx	CopyMemLow
	rts

GetPrefs2:
	ldx	activeWindow
	lda	windowsOpen,x
	beq	GetPrefs
	jsr	GetWinDisk
GetPrefs:	LoadW___	r6,@name
	jsr	FindFile
	txa
	beq	@10
	rts
@10:	MoveW_	$8401,r1
	LoadW___	r4,$8000
	jsr	GetBlock
	txa
	beq	@20
	rts
@20:	ldy	#2
@25:	lda	$8000+2,y
	sta	$8501,y	; maxMouseSpeed
	dey
	bpl	@25
	jsr	InitForIO
	lda	$8005
	ora	$8006
	sta	screencolors
	MoveB	$8000+5,$d021
	MoveB	$8000+7,$d027
	MoveB	$8000+71,$d020
	lda	$8001
	cmp	#73	; c128-Preferences ?
	bne	@26	; >nein
	MoveB	$8000+72,$88bd	; scr80colors
	MoveB	$8000+73,$88bc	; scr80polar
@26:	jsr	DoneWithIO
	ldy	#62
@30:	lda	$8000+8,y
	sta	$84c1,y	; mousePicData
	dey
	bpl	@30
	jmp	SetColor
@name:	.byte	"Preferences",0
SetColor:	lda	screencolors	; Farben wiederherstellen
	sta	@col
	jsr	i_FillRam
	.word	1000,$8c00
@col:	.byte	0
	rts

University:	;d	"University 6"
.incbin "topdesk/university6.fnt"

BitMap:	;j
.incbin "topdesk/BitMap.bf"
BitX	= 3
BitY	= 15
.ifdef topdesk128
    .byte   21
.endif
TrashMap:	;j
.incbin "topdesk/TrashMap.bf"
TrashX	= 3
TrashY	= 21
PrintMap:	;j
.incbin "topdesk/PrintMap.bf"
PrintX	= 3
PrintY	= 21

Start2:
    lda	RamTopFlag
	bne	@10
	lda	ramExpSize
	beq	@09
	jsr	SearchDeskTop
	bcs	@08
	lda	#' '
	ldx	$8091
	beq	@05
	lda	#'*'
@05:	sta	AutoSwapFlag
	lda	$8090
	beq	@08
	CmpWI	$88ee,$ffa0	; DrDCurDkNm
	bne	@07

	LoadW___	$8090,0
	MoveW_	$8400+19,r1
	LoadW___	r4,$8000
	jmp	PutBlock
@07:	jmp	MakeRamTop
@08:	rts
@09:	jmp	GetDiskDrivers
@10:	jmp	ReLoadAll2
;	jmp	GetWindowStat
;	jmp	OpenNext

JmpSub2:	pha
	txa
	pha
	jsr	GotoFirstMenu
	ldx	activeWindow
	lda	windowsOpen,x
	bne	@geht
	pla
	pla
	rts

@geht:	pla
	tax
	pla
JmpSub:	pha
	txa
	jsr	GetModule
	bcs	@10
	pla
	sta	r0L
	clc
	adc	r0L
	adc	r0L
	adc	ModStartAdress
	sta	r0L
	lda	ModStartAdress+1
	adc	#0
	sta	r0H
	jmp	(r0)
@10:	pla
	rts
StartUp:	lda	#7
	jsr	GetModule
	MoveW_	ModStart+3*3+1,r1
	SubVW_	2,r1
	ldy	#0
	lda	(r1),y
	iny
	ora	(r1),y
	beq	@10
	jsr	@sub
	AddVW__	2,r1
	jmp	(r1)
@10:	lda	r7L
	sec
	sbc	#<ModStart
	sta	r2L
	lda	r7H
	sbc	#>ModStart
	sta	r2H
	LoadW___	r7,ModStart
	MoveW_	ModStart+3*3+1,r1
	SubVW_	2,r1
	jsr	GetSerialNumber
	ldy	#0
	lda	r0L
	sta	(r1),y
	iny
	lda	r0H
	sta	(r1),y
	jsr	@sub
	LoadW___	r0,MyName
	jsr	OpenRecordFile
	lda	#7
	jsr	PointRecord
	jsr	WriteRecord
	jsr	CloseRecordFile
	jmp	StartUp
@sub:	ldy	#0
@loop:	lda	(r1),y
	eor	#%1011101
	sta	(r1),y
	iny
	bne	@loop
	rts
ModDepth:	.byte	0
RamTopFlag:	.byte	0
.ifdef topdesk13
SureFlag:	.byte	0
.endif

GetTextService:	ldx	#6	; im Akku Nr. des Anzeigemodus
	.byte	$2c	; }bergeben
GetIconService:	ldx	#5	; im Akku 0 }bergeben
	pha
	txa
	pha
	jsr	GotoFirstMenu
	LoadW___	ModStartAdress,DispJumpTable
ServiceMod:	pla
	jsr	GetModule
	LoadW___	ModStartAdress,ModStart
	bcs	@10
	pla
	sta	DispMode
	jmp	ReLoadAll
@10:	pla
	rts
DispMode:	.byte	0
.macro JmpMod para1, para2		; 7 Bytes
	ldx	#para1
	lda	#para2
	jmp	JmpSub
.endmacro

.macro JmpMod2	para1, para2	; 7 Bytes
	ldx	#para1
	lda	#para2
	jmp	JmpSub2
.endmacro

.if 0
SaveWindowStat:	jsr	GotoFirstMenu
	lda	#9	; ramDrive
	bne	@05
	rts
@05:	jsr	SetDevice
	jsr	OpenDisk
	ldy	#0
@10:	lda	SubDir1List,y
	sta	$6000,y
	dey
	bne	@10
	LoadW___	a2,$6100
	ldx	#3
@loop2:	stx	a1L
	jsr	GetWinDisk
	ldy	#16
@loop:	lda	DiskName+2,y
	sta	(a2),y
	dey
	bpl	@loop
	AddVB	16,a2L
	ldx	a1L
	dex
	bpl	@loop2
	jsr	i_MoveData
	.word	windowsOpen,$6140,4
	jsr	i_MoveData
	.word	WindowTab,$6140+4,6
	jsr	i_MoveData
	.word	WindowTab+11,$6140+4+6,6
	jsr	i_MoveData
	.word	WindowTab+22,$6140+4+12,6
	jsr	i_MoveData
	.word	WindowTab+33,$6140+4+18,6
	LoadW___	r0,StatName
	jsr	DeleteFile
	LoadW___	$8100,StatName
	LoadB	$8102,$03
	LoadB	$8103,$15
	LoadB	$8104,$bf
	LoadB	$8144,$82	; USR
	LoadB	$8145,3	; DATA
	LoadB	$8146,0	; SEQ
	LoadW___	$8147,$6000	; LadrAdr
	LoadW___	$8149,$61f0	; = 2 Bl|cke
	LoadB	$81a0,0	; kein Info
	LoadW___	r9,$8100
	LoadB	r10L,0
	jmp	SaveFile
StatName:	.byte	"TopDesk.inf",0
.endif

DeskDosNew:	JmpMod2	1,0
DValidate:	JmpMod2	1,1
GetWindowStat:	JmpMod	1,2
GetDiskDrivers:	JmpMod	1,3
;SelectPage:	JmpMod2	2,0
EmptyAllDirs:	JmpMod2	2,1
DispInfo:	jsr	GotoFirstMenu
	JmpMod	2,2
DeskRename:	JmpMod2	2,3
DeskDuplicate:	JmpMod2	2,4
;SelectAll:	JmpMod2	2,5
GetTime:	jsr	GotoFirstMenu
	JmpMod	3,0
Ordnen:	JmpMod2	3,1
ThreeDrives:	rts
;	JmpMod	3,0
DispFileInfo:	JmpMod2	4,0
;SwapFile:	JmpMod	7,0
DeskRelabel:	JmpMod2	7,1
DeskFormat:	jsr	GotoFirstMenu
	JmpMod	7,2
InstallDriver:	JmpMod	7,4
DCopy:	JmpMod2	8,0
;SetWindows:	JmpMod2	8,1
NeuerOrdner:	JmpMod2	9,0
CopyDir:	JmpMod	9,1
;DeleteDir:	JmpMod	9,2
MakeRamTop:	jsr	GotoFirstMenu
	LoadB	MyCurRec,0
	ldx	#10
	lda	#0
	jsr	JmpSub
	txa
	beq	@10
	rts
@10:	jmp	ReLoadAll

StashMain:	lda	RamTopFlag
	bne	@geht
	rts
@geht:	LoadB	MyCurRec,0
	ldy	#r15H-r0L
@loop:	lda	r0L,y
	sta	RegBuf,y
	dey
	bpl	@loop
	JmpMod	10,2
.ifdef topdesk128

oldGraphMode:    .byte   0

.macro wb argx, argy
    .word   argx
    .byte   argy
.endmacro

.macro ww arg1, arg2
    wb   arg1, <(arg2)
    wb   arg1+1, >(arg2)
.endmacro

Switch:
    jsr GotoFirstMenu
    lda graphMode
    eor #$80
    sta graphMode
    sta oldGraphMode
    jsr SetNewMode
    jsr SetMyNewMode
    jsr SetColor
    jsr RedrawHead
    jsr DispMultiCount
    jsr SwitchWin
    jmp RedrawAll
SwitchWin:
    lda graphMode
    bpl @g40
    jsr G80
    jmp @10
@g40:
    lda #' '
    sta SchmalFlag
    jsr G40
@10:
    rts
G40:
    LoadW___   r0, Window1
    jsr Halbieren
    LoadW___   r0, Window2
    jsr Halbieren
    LoadW___   r0, Window3
    jsr Halbieren
    LoadW___   r0, Window4
    jmp Halbieren
G80:
    LoadW___   r0, Window1
    jsr Doppeln
    LoadW___   r0, Window2
    jsr Doppeln
    LoadW___   r0, Window3
    jsr Doppeln
    LoadW___   r0, Window4
    jmp Doppeln
SetMyNewMode:
    lda graphMode
    bpl @40
@80:
    LoadW___   r0, @tab2
    jmp @10
@40:
    LoadW___   r0, @tab1
@10:
    ldy #0
    lda (r0),y
    sta r1L
    iny
    lda (r0),y
    sta r1H
    ora r1L
    beq @end
    iny
    lda (r0),y
    ldy #0
    sta (r1),y
    AddvW   3, r0
    jmp @10
@end:
    rts

@tab1:
    wb  IconTab+6,-4|128
    wb  IconTab+14,2|128
    wb  IconTab+22,STARTA_X
    wb  IconTab+30,STARTB_X
    wb  IconTab+38,STARTC_X
    wb  IconTab+46,STARTD_X
    ww  RightMax, 639
    wb  GraphIndex, 8
.ifdef lang_de
    ww  HauptMenu+4,214
.else
    ww  HauptMenu+4,182
.endif
.ifdef lang_de
    ww  DispMenuRight,214
.else
    ww  DispMenuRight,182
.endif
    ww	modeunten+1, 80
    ww	modeunten+3, 171
    ww  geosoben+4,80
    ww  Datei_Menue+2+3,28
    ww  Datei_Menue+4+3,112
.ifdef lang_de
    ww  Anzeige_Menue+2+3,57
.else
    ww  Anzeige_Menue+2+3,48
.endif
.ifdef lang_de
    ww  Anzeige_Menue+4+3,170
.else
    ww  Anzeige_Menue+4+3,161
.endif
.ifdef lang_de
    ww  Disk_Menue+2+3,98
.else
    ww  Disk_Menue+2+3,79
.endif
.ifdef lang_de
    ww  Disk_Menue+4+3,180
.else
    ww  Disk_Menue+4+3,161
.endif
.ifdef lang_de
    ww  WindowMenue+2+3,137
.else
    ww  WindowMenue+2+3,103
.endif
.ifdef lang_de
    ww  WindowMenue+4+3,256
.else
    ww  WindowMenue+4+3,222
.endif
.ifdef lang_de
    ww  Speziell_Menue+2+15,174
.else
    ww  Speziell_Menue+2+15,145
.endif
.ifdef lang_de
    ww  Speziell_Menue+4+15,267
.else
    ww  Speziell_Menue+4+15,238
.endif
    .word   0

@tab2:
    wb  IconTab+6,-4|128
    wb  IconTab+14,2|128
    wb  IconTab+22,STARTA_X
    wb  IconTab+30,STARTB_X
    wb  IconTab+38,STARTC_X
    wb  IconTab+46,STARTD_X
    ww  RightMax,639
.ifdef mega65
    wb  GraphIndex,8
.else
    wb  GraphIndex,1
.endif
.ifdef lang_de
    ww  HauptMenu+4,286
.else
    ww  HauptMenu+4,237
.endif
.ifdef lang_de
    ww  DispMenuRight,286
.else
    ww  DispMenuRight,237
.endif
    ww	modeunten+1, 104
    ww	modeunten+3, 235
    ww  geosoben+4,104
.ifdef lang_de
    ww  Datei_Menue+2+3,36
.else
    ww  Datei_Menue+2+3,37
.endif
.ifdef lang_de
    ww  Datei_Menue+4+3,145
.else
    ww  Datei_Menue+4+3,149
.endif
.ifdef lang_de
    ww  Anzeige_Menue+2+3,73
.else
    ww  Anzeige_Menue+2+3,63
.endif
.ifdef lang_de
    ww  Anzeige_Menue+4+3,224
.else
    ww  Anzeige_Menue+4+3,214
.endif
.ifdef lang_de
    ww  Disk_Menue+2+3,127
.else
    ww  Disk_Menue+2+3,103
.endif
.ifdef lang_de
    ww  Disk_Menue+4+3,234
.else
    ww  Disk_Menue+4+3,213
.endif
.ifdef lang_de
    ww  WindowMenue+2+3,177+7
.else
    ww  WindowMenue+2+3,134
.endif
.ifdef lang_de
    ww  WindowMenue+4+3,332+7
.else
    ww  WindowMenue+4+3,293
.endif
.ifdef lang_de
    ww  Speziell_Menue+2+15,226+8
.else
    ww  Speziell_Menue+2+15,189
.endif
.ifdef lang_de
    ww  Speziell_Menue+4+15,346+8
.else
    ww  Speziell_Menue+4+15,314
.endif
    .word   0
.endif



STARTA_X	=	-4 | 128
STARTA_Y	=	4
STARTB_X	=	-4 | 128
STARTB_Y	=	8
STARTC_X	=	-4 | 128
STARTC_Y	=	12
STARTD_X	=	-4 | 128
STARTD_Y	=	16

IconTab:
.ifdef topdesk128
	.byte	0,0,0,0	; Anzahl wird berechnet
	.word	TrashMap
	.byte	-4|128,-4,TrashX+DOUBLE_B,TrashY
	.word	TrashService
	.word	PrintMap
	.byte	2|128,-4,PrintX+DOUBLE_B,PrintY
	.word	PrintService
	.word	BitMap
	.byte	STARTA_X,STARTA_Y,BitX+DOUBLE_B,BitY
	.word	OpenD8
	.word	BitMap
	.byte	STARTB_X,STARTB_Y,BitX+DOUBLE_B,BitY
	.word	OpenD9
	.word	BitMap
	.byte	STARTC_X,STARTC_Y,BitX+DOUBLE_B,BitY
	.word	OpenD10
	.word	BitMap
	.byte	STARTD_X,STARTD_Y,BitX+DOUBLE_B,BitY
	.word	OpenD11
.else
	.byte	0,0,0,0	; Anzahl wird berechnet
	.word	TrashMap
	.byte	-4|128,-4,TrashX,TrashY
	.word	TrashService
	.word	PrintMap
	.byte	2|128,-4,PrintX,PrintY
	.word	PrintService
	.word	BitMap
	.byte	STARTA_X,STARTA_Y,BitX,BitY
	.word	OpenD8
	.word	BitMap
	.byte	STARTB_X,STARTB_Y,BitX,BitY
	.word	OpenD9
	.word	BitMap
	.byte	STARTC_X,STARTC_Y,BitX,BitY
	.word	OpenD10
	.word	BitMap
	.byte	STARTD_X,STARTD_Y,BitX,BitY
	.word	OpenD11
.endif

OpenD11:	lda	#11
	.byte	$2c
OpenD10:	lda	#10
	.byte	$2c
OpenD9:	lda	#9
	.byte	$2c
OpenD8:	lda	#8
OpenDa:	pha
	lda	numDrives
	cmp	#2
	bcc	@10
	lda	KSFlag
	bne	@09
	jsr	CheckKlick
	bcs	@10
@09:	pla
	sta	@dr
	LoadW___	r4,BitMap+1
.ifdef topdesk128
	LoadB	r3L,2
.else
	LoadB	r3L,1
.endif
	jsr	DrawSprite
.ifdef topdesk128
    jsr HideOnlyMouse
.endif
	LoadB	ghostFile,$ff
	jsr	InitForIO
.ifdef topdesk128
	MoveB	$d027,$d029	; Farbe des Ghost-Sprites von Mauszeiger
.else
	MoveB	$d027,$d028	; Farbe des Ghost-Sprites von Mauszeiger
.endif
.ifdef topdesk128
    lda graphMode
    bmi @g80
    lda $d01d
    and #%11111011
    sta $d01d
    jmp @gend
@g80:
.ifdef mega65
    lda $d01d
    and #%11111011
    sta $d01d
.else
    lda $d01d
    ora #%100
    sta $d01d
.endif
@gend:
.endif
	jsr	DoneWithIO
	LoadB	KSFlag,0
	rts
@10:
	lda	@dr
	beq	@20
	lda	ghostFile
	bpl	@20
	ldx	@dr
	pla
	jsr	ChangeDrive
	LoadB	@dr,0
	LoadB	AskDiskFlag,0
	ldx	#3
@loop:	lda	windowsOpen,x
	beq	@15
	txa
	pha
	jsr	GetDisk
	pla
	tax
@15:	dex
	bpl	@loop
	LoadB	AskDiskFlag,$ff
	jmp	RedrawAll
@20:
	ldx	numDrives	; bei numDrives=1 kein Laufwerkswechsel
	dex
	bne	@25
	pla
	cmp	curDrive
	beq	@26
@24:	rts
@25:	pla
	pha
	tay
	lda	driveType-8,y
	beq	@27
	pla
@26:	jsr	NewSetDevice

	jmp	OpenNext

@27:	pla
	rts

@dr:	.byte	0
DeskMain:	lda	ghostFile
	beq	@rts
	lda	$3a
	sec
	sbc	#10
	sta	r4L
	lda	$3b
	sbc	#00
	sta	r4H
	lda	$3c
	sec
	sbc	#10
	sta	r5L
.ifdef topdesk128
	LoadB	r3L,2
.else
	LoadB	r3L,1
.endif
	jsr	PosSprite
	jsr	EnablSprite
	LoadB	mouseTop,15
@rts:	rts
DeskOther:	lda	mouseData
	bpl	@10
	rts
@10:	LoadW___	r3,ClxL
	LoadW___	r4,ClxR
	LoadB	r2L,ClyO
	LoadB	r2H,ClyU
	jsr	IsMseInRegion
	bne	@20
	jmp	EndGhost
@20:	jmp	GetTime

KSFlag:	.byte	0
KS8:	lda	#8
	.byte	$2c
KS9:	lda	#9
	.byte	$2c
KS10:	lda	#10
	.byte	$2c
KS11:	lda	#11
	ldx	#1
	stx	KSFlag
	jmp	OpenDa

.macro mpt p1, p2, p3
	.word	p1
	.byte	p2
	.word	p3
.endmacro

MAIN_RIGHT	= 214

HauptMenu:	.byte	0,13
	.word	0,MAIN_RIGHT
	.byte	6
	mpt	@t1,DYN_SUB_MENU,geos_Menue
	mpt	@t2,DYN_SUB_MENU,Datei_Menue
	mpt	@t3,DYN_SUB_MENU,Anzeige_Menue
	mpt	@t4,DYN_SUB_MENU,Disk_Menue
	mpt	@t6,DYN_SUB_MENU,WindowMenue
	mpt	@t5,DYN_SUB_MENU,Speziell_Menue
@t1:	.byte	"geos",NULL
.ifdef lang_de
@t2:	.byte	"Datei",NULL
.else
@t2:	.byte	"file",NULL
.endif
.ifdef lang_de
@t3:	.byte	"Anzeige",NULL
.else
@t3:	.byte	"show",NULL
.endif
.ifdef lang_de
@t4:	.byte	"Diskette",NULL
.else
@t4:	.byte	"disk",NULL
.endif
.ifdef lang_de
@t5:	.byte	"Speziell",NULL
.else
@t5:	.byte	"special",NULL
.endif
.ifdef lang_de
@t6:	.byte	"Fenster",NULL
.else
@t6:	.byte	"window",NULL
.endif

DISKRIGHT	=	177
Disk_Menue:	jsr	MySubMenu
	.byte	13,84
	.word	98,DISKRIGHT
	.byte	$85
	mpt	@t1,MENU_ACTION,DeskRelabel
	mpt	@t2,MENU_ACTION,DeskDosNew
	mpt	@t3,MENU_ACTION,DeskFormat
	mpt	@t4,MENU_ACTION,DCopy
	mpt	@t5,MENU_ACTION,DValidate
.ifdef lang_de
@t1:	.byte	"Umbenennen",GOTOX
.else
@t1:	.byte	"rename",GOTOX
.endif
	.word	DISKRIGHT-20
	.byte	128,BOLDON,"N",PLAINTEXT,0
.ifdef lang_de
@t2:	.byte	"L|schen",GOTOX
.else
@t2:	.byte	"erase",GOTOX
.endif
	.word	DISKRIGHT-20
	.byte	128,BOLDON,"E",PLAINTEXT,0
.ifdef lang_de
@t3:	.byte	"Formatieren",GOTOX
.else
@t3:	.byte	"format",GOTOX
.endif
	.word	DISKRIGHT-20
	.byte	128,BOLDON,"F",PLAINTEXT,0
.ifdef lang_de
@t4:	.byte	"Kopieren",GOTOX
.else
@t4:	.byte	"copy",GOTOX
.endif
	.word	DISKRIGHT-20
	.byte	128,BOLDON,"K",PLAINTEXT,0
.ifdef lang_de
@t5:	.byte	"Aufr{umen",GOTOX
.else
@t5:	.byte	"validate",GOTOX
.endif
	.word	DISKRIGHT-20
	.byte	128,BOLDON,"V",PLAINTEXT,0
DATEIRIGHT	= 112
Datei_Menue:	jsr	MySubMenu
	.byte	13,98+14
	.word	28,DATEIRIGHT
	.byte	$87
	mpt	@t1,MENU_ACTION,DateiOeffnen
	mpt	@t2,MENU_ACTION,DeskDuplicate
	mpt	@t3,MENU_ACTION,DeskRename
	mpt	@t4,MENU_ACTION,DispFileInfo
	mpt	@t5,MENU_ACTION,DateiDrucken
	mpt	@t6,MENU_ACTION,DeskDelete
	mpt	@t7,MENU_ACTION,Ordnen
.ifdef lang_de
@t1:	.byte	"\ffnen",GOTOX
.else
@t1:	.byte	"open",GOTOX
.endif
	.word	DATEIRIGHT-22
	.byte	128,BOLDON,"Z",PLAINTEXT,0
.ifdef lang_de
@t2:	.byte	"Duplizieren",GOTOX
.else
@t2:	.byte	"duplicate",GOTOX
.endif
	.word	DATEIRIGHT-22
	.byte	128,BOLDON,"H",PLAINTEXT,0
.ifdef lang_de
@t3:	.byte	"Umbenennen",GOTOX
.else
@t3:	.byte	"rename",GOTOX
.endif
	.word	DATEIRIGHT-22
	.byte	128,BOLDON,"M",PLAINTEXT,0
.ifdef lang_de
@t4:	.byte	"Info",GOTOX
.else
@t4:	.byte	"info",GOTOX
.endif
	.word	DATEIRIGHT-22
	.byte	128,BOLDON,"Q",PLAINTEXT,0
.ifdef lang_de
@t5:	.byte	"Drucken",GOTOX
.else
@t5:	.byte	"print",GOTOX
.endif
	.word	DATEIRIGHT-22
	.byte	128,BOLDON,"P",PLAINTEXT,0
.ifdef lang_de
@t6:	.byte	"L|schen",GOTOX
.else
@t6:	.byte	"delete",GOTOX
.endif
	.word	DATEIRIGHT-22
	.byte	128,BOLDON,"D",PLAINTEXT,0
.ifdef lang_de
@t7:	.byte	"Vorsortieren",GOTOX
.else
@t7:	.byte	"presort",GOTOX
.endif
	.word	DATEIRIGHT-22
	.byte	128,BOLDON,"T",PLAINTEXT,0
Anzeige_Menue:	jsr	MySubMenu
.ifdef topdesk128
	.byte	13,8*14+14
.else
	.byte	13,7*14+14
.endif
.ifdef topdesk128
	.word	57,180
.else
	.word	57,132
.endif
.ifdef topdesk128
	.byte	$88
.else
	.byte	$87
.endif
	mpt	@t1,$00,@rout
	mpt	@t2,$00,@rout
	mpt	@t3,$00,@rout
	mpt	@t4,$00,@rout
	mpt	@t5,$00,@rout
	mpt	KBytesFlag,$00,@rout2
	mpt	@t7,$00,@rout3
.ifdef topdesk128
	mpt SchmalFlag,$00,SwapSchmal
.endif
.ifdef lang_de
@t1:	.byte	"* Icons",0
@t2:	.byte	"  nach Namen",0
@t3:	.byte	"  nach Datum",0
@t4:	.byte	"  nach Gr|~e",0
@t5:	.byte	"  nach Typ",0
@t7:	.byte	"* in KBytes",0
.else
@t1:	.byte	"* icons",0
@t2:	.byte	"  by name",0
@t3:	.byte	"  by date",0
@t4:	.byte	"  by size",0
@t5:	.byte	"  by types",0
@t7:	.byte	"* in KBytes",0
.endif
@rout:	pha
	lda	#' '
	sta	@t1
	sta	@t2
	sta	@t3
	sta	@t4
	sta	@t5
	pla
	pha
	asl
	tay
	lda	@tab,y
	sta	r0L
	lda	@tab+1,y
	sta	r0H
	ldy	#0
	lda	#'*'
	sta	(r0),y
	pla
	bne	@r10
	jmp	GetIconService
@r10:	jmp	GetTextService
@tab:	.word	@t1,@t2,@t3,@t4,@t5
@rout2:	lda	#' '
	ldx	#'*'
@rout23:	sta	@t7
	stx	KBytesFlag
	jsr	GotoFirstMenu
	jmp	RedrawAll
@rout3:	lda	#'*'
	ldx	#' '
	jmp	@rout23

.ifdef topdesk128
SwapSchmal:
    lda SchmalFlag
    cmp #'*'
    beq @10
    jsr G40
    ldx #'*'
    jmp @20
@10:
    jsr G80
    ldx #' '
@20:
    stx SchmalFlag
    jsr GotoFirstMenu
    jsr CheckAll
    jmp RedrawAll
.endif

.ifdef lang_de
KBytesFlag:	.byte	"  in Bl|cken",0
.else
KBytesFlag:	.byte	"  in blocks",0
.endif
.ifdef topdesk128
.ifdef lang_de
SchmalFlag: .byte   "  schmale Anzeige",GOTOX
.else
SchmalFlag: .byte   "  smal display",GOTOX
.endif
    .word   180-22
    .byte   128, BOLDON, "G", PLAINTEXT, 0

CheckAll:
    LoadW___    r0,Window1
    jsr CheckOne
    LoadW___    r0,Window2
    jsr CheckOne
    LoadW___    r0,Window3
    jsr CheckOne
    LoadW___    r0,Window4
    jmp CheckOne
.endif

WINWDOWRIGHT	=	256
WindowMenue:	jsr	MySubMenu
	.byte	13,28+28+14
	.word	137,WINWDOWRIGHT
	.byte	$84
	mpt	@t1,MENU_ACTION,SetWindows
	mpt	@t2,MENU_ACTION,CloseAll
	mpt	@t3,MENU_ACTION,SelectAll
	mpt	@t4,MENU_ACTION,SelectPage
.ifdef lang_de
@t1:	.byte	"plazieren",GOTOX
.else
@t1:	.byte	"place",GOTOX
.endif
	.word	WINWDOWRIGHT-22
	.byte	128,BOLDON,"S",PLAINTEXT,0
.ifdef lang_de
@t2:	.byte	"alle schlie~en",GOTOX
.else
@t2:	.byte	"close all",GOTOX
.endif
	.word	WINWDOWRIGHT-22
	.byte	128,BOLDON,"C",PLAINTEXT,0
.ifdef lang_de
@t3:	.byte	"Inhalt anw{hlen",GOTOX
.else
@t3:	.byte	"select contents",GOTOX
.endif
	.word	WINWDOWRIGHT-22
	.byte	128,BOLDON,"W",PLAINTEXT,0
.ifdef lang_de
@t4:	.byte	"Ausschnitt anw{hlen",GOTOX
.else
@t4:	.byte	"select certain files",GOTOX
.endif
	.word	WINWDOWRIGHT-22
	.byte	128,BOLDON,"X",PLAINTEXT,0

SPCRIGHT	=	267

Speziell_Menue:	lda	#PLAINTEXT
	ldx	RamTopFlag
	beq	@10
	lda	#ITALICON
@10:	sta	@t3
	jsr	MySubMenu
	.byte	13,28+28+14+14+14
	.word	174,SPCRIGHT
	.byte	$86
	mpt	@t1,MENU_ACTION,NeuerOrdner
	mpt	@t2,MENU_ACTION,GetTime
	mpt	@t3,MENU_ACTION,MakeRamTop
	mpt	@t4,MENU_ACTION,Reset
	mpt	AutoSwapFlag,MENU_ACTION,AutoSwap
	mpt	@t5,MENU_ACTION,GoToBasic
;	mpt	@t2,MENU_ACTION,EmptyAllDirs
;	mpt	@t4,MENU_ACTION,SaveWindowStat
.ifdef lang_de
@t1:	.byte	"Neuer Ordner",GOTOX
.else
@t1:	.byte	"new folder",GOTOX
.endif
	.word	SPCRIGHT-20
	.byte	128,BOLDON,"O",PLAINTEXT,0
.ifdef lang_de
@t2:	.byte	"Uhr stellen",GOTOX
.else
@t2:	.byte	"set clock",GOTOX
.endif
	.word	SPCRIGHT-20
	.byte	128,BOLDON,"A",PLAINTEXT,0
.ifdef lang_de
@t3:	.byte	PLAINTEXT,"RamDeskTop",GOTOX
.else
@t3:	.byte	PLAINTEXT,"RamDeskTop",GOTOX
.endif
	.word	SPCRIGHT-20
	.byte	128,BOLDON,"L",PLAINTEXT,0
.ifdef lang_de
@t4:	.byte	"Reset",GOTOX
.else
@t4:	.byte	"reset",GOTOX
.endif
	.word	SPCRIGHT-20
	.byte	128,BOLDON,"R",PLAINTEXT,0
@t5:	.byte	"Basic",0
;@t2:	.byte	"Ordner entleeren",0
;@t4:	.byte	"Arbeit sichern",0
.ifdef lang_de
AutoSwapFlag:	.byte	"  autom. Tauschen",0
.else
AutoSwapFlag:	.byte	"  automatic swap",0
.endif
CloseAll:	jsr	GotoFirstMenu
	lda	#0
	ldx	#3
@loop:	sta	windowsOpen,x
	dex
	bpl	@loop
	jsr	ClearMultiFile
	jmp	RedrawAll

AutoSwap:	jsr	GotoFirstMenu
	ldx	#$2a
	lda	AutoSwapFlag
	cmp	#$20
	beq	@10
	ldx	#$20
@10:	stx	AutoSwapFlag
	lda	RamTopFlag
	bne	@15
	jsr	SearchDeskTop
	bcc	@20
@15:	rts
@20:	MoveB	RamTopFlag,$8090	; immer 0, aber egal
	MoveB	AutoSwapFlag,$8091
	MoveW_	$8400+19,r1
	LoadW___	r4,$8000
	jsr	PutBlock
	rts

RecoverActiveWindow:	ldx	activeWindow
	jsr	GetEqualWindows
	ldx	#3
@loop:	lda	a6L,x
	bne	ReloadActiveWindow2
	dex
	bpl	@loop
	ldx	activeWindow
	jsr	ReLoad2
	bcc	@10
	jsr	FehlerAusgabe
@10:	jmp	RecoverLast

ReloadActiveWindow:	ldx	activeWindow
	jsr	GetEqualWindows
ReloadActiveWindow2:	ldx	#3
@g20:	lda	a6L,x
	bne	@g10
	dex
	bpl	@g20
	jmp	@10	; nur aktives Window aktualisieren
@g10:	ldx	#3
@g30:	lda	a6L,x
	beq	@g40	; > bei ungleich
	txa
	pha
	jsr	ReLoad2
	bcc	@e10
	jsr	FehlerAusgabe
	pla
	rts
@e10:	pla
	tax
@g40:	dex
	bpl	@g30
@09:	ldx	activeWindow
	jsr	ReLoad2
	bcc	@e20
	jsr	FehlerAusgabe
@e20:	jmp	RedrawAll
@10:	ldx	activeWindow
	jsr	ReLoad2
	bcc	@e30
	jsr	FehlerAusgabe
@e30:	jmp	Redraw
EndGhost:	ldx	#0
	stx	ghostFile
	stx	mouseTop
	pha
.ifdef topdesk128
	lda	#2
.else
	lda	#1
.endif
	sta	r3L
	jsr	DisablSprite
	pla
	rts

GoToBasic:	jsr	GotoFirstMenu
	lda	#0
	sta	r5L
	sta	r5H
	sta	$5000
	LoadW___	r0,$5000
	lda	c128Flag
	bpl	@10
	lda	#0
	sta	$1c00
	sta	$1c01
	sta	$1c02
	sta	$1c03
	beq	@20
@10:	lda	#0
	sta	$800
	sta	$801
	sta	$802
	sta	$803
@20:	jmp	ToBasic

TestTopDesk:	lda	c128Flag
	bpl	@11
	lda	graphMode
	bpl	@11
@05:	clc
	rts
@11:	lda	driveType
	and	#$80
	beq	@05
	lda	driveType+1
	and	#$80
	beq	@05
	ldy	#r15H-r0L
@loop:	lda	r0L,y
	pha
	dey
	bpl	@loop
	PushB	curDrive
	LoadB	sysDBData,1
	lda	#8
	jsr	@sub
	txa
	beq	@15
	lda	#9
	jsr	@sub
	txa
	beq	@15
	LoadW___	r0,@db
	jsr	NewDoDlgBox
@15:	pla
	jsr	SetDevice
	jsr	OpenDisk
	ldy	#0
@loop2:	pla
	sta	r0L,y
	iny
	cpy	#r15H-r0L+1
	bne	@loop2
	lda	sysDBData
	cmp	#1
	bne	@20
	clc
	rts
@20:	sec
	rts
@sub:	jsr	SetDevice
	jsr	OpenDisk
	LoadW___	r6,MyName
	jmp	FindFile
@db:	.byte	$81
	.byte	$0b,$10,$10
	.word	@t1
	.byte	$0b,$10,$20
	.word	@t2
	.byte	OK,2,72,CANCEL,17,72,NULL
.ifdef lang_de
@t1:	.byte	"Kein DeskTop auf den",0
@t2:	.byte	"RAM-Disks A und B!",0
.else
@t1:	.byte	"DeskTop not present on",0
@t2:	.byte	"RAM-Disks A or B!",0
.endif

AskDiskFlag:	.byte	$ff
ReLoadAll:	ldy	#3
@loop:	lda	windowsOpen,y
	bne	Reset2
	dey
	bpl	@loop
	bmi	ReLoadAll2
Reset:	jsr	GotoFirstMenu
Reset2:	jsr	ClearScreen
ReLoadAll2:

	ldx	#03
@10:	txa
	pha
	lda	activeWindow,x
	pha
	tax
	lda	windowsOpen,x
	beq	@15
	LoadB	AskDiskFlag,0
	jsr	ReLoad2
	LoadB	AskDiskFlag,$ff
	bcc	@13
	pla
	tax
	lda	#0
	sta	windowsOpen,x
	beq	@17
@13:	pla
	pha
	tax
	jsr	DrawWindow
@15:	pla
@17:	pla
	tax
	dex
	bpl	@10
;Rts:
	rts

RedrawHead:
	lda	#2
	jsr	SetPattern
	jsr	i_Rectangle
.ifdef scalable_coords
	ByteCY	0, 0
	ByteCY	SC_FROM_END+0, 15
	WordCX	0, 0
	WordCX  SC_FROM_END+0, 15
.else
	.byte	0,15
.ifdef topdesk128
	.word	0+DOUBLE_W,319+DOUBLE_W+ADD1_W
.else
	.word	0,319
.endif
.endif
	jsr	MaxTextWin

	jsr	DoHauptMenu
	lda	#0
	jsr	SetPattern
	jsr	i_Rectangle
	.byte	1,13
.ifdef topdesk128
	.word	221+DOUBLE_W,237+DOUBLE_W
.else
	.word	221,237
.endif
	lda	#$ff
	jsr	FrameRectangle
	jmp	InitClock

mode_Menue:
	jsr	MySubMenuDA2
modeoben:	.byte 13+13+1
modeunten:	.byte 8*14+13+13+1+1		; wird berechnet!
		.word 80,171
		.byte 8 | VERTICAL
		mpt	Mode40Text,MENU_ACTION,Mode_Call
		mpt	Mode80Text,MENU_ACTION, Mode_Call
		mpt	ModeNSText,MENU_ACTION,Mode_Call
		mpt	ModeHRText,MENU_ACTION,Mode_Call
		mpt	ModeHRSText,MENU_ACTION,Mode_Call
		mpt	ModeSRText,MENU_ACTION,Mode_Call
		mpt	ModeSRSText,MENU_ACTION,Mode_Call
		mpt	ModeHCText,MENU_ACTION,Mode_Call
Mode40Text:	.byte "  40-cols",0
Mode80Text:	.byte "  80-cols",0
ModeNSText:	.byte ITALICON, "  nice scale",PLAINTEXT,0
ModeHRText:	.byte "* high-res",0
ModeHRSText:	.byte ITALICON, "  high-res scaled",PLAINTEXT,0
ModeSRText:	.byte ITALICON, "  super-res",PLAINTEXT,0
ModeSRSText:	.byte ITALICON, "  super-res scaled",PLAINTEXT,0
ModeHCText:	.byte ITALICON, "  high-color",PLAINTEXT,0

Mode_Call:
	sta	graphMode
	cmp	#1
	bne     @10
	lda     #$80
	sta	graphMode

@10:
	jsr	GotoFirstMenu

        lda graphMode
        sta oldGraphMode
        jsr SetNewMode
        jsr SetMyNewMode
        jsr SetColor
        jsr RedrawHead
        jsr DispMultiCount
        ;jsr SwitchWin
        jmp RedrawAll

	rts


geos_Menue:
	jsr	DA_Init
	txa
	beq	@05
	brk
@05:	jsr	MySubMenuDA
geosoben:	.byte 13
geosunten:	.byte 28		; wird berechnet!
	.word 0,80
geosanz:	.byte 1		; wird eingesetzt!
	mpt	DeskInfoText,MENU_ACTION,DispInfo
.ifdef topdesk128
	mpt	SwitchText,DYN_SUB_MENU, mode_Menue
.endif
	mpt	DASpace + 0*17,MENU_ACTION,DA_Call
	mpt	DASpace + 1*17,MENU_ACTION,DA_Call
	mpt	DASpace + 2*17,MENU_ACTION,DA_Call
	mpt	DASpace + 3*17,MENU_ACTION,DA_Call
	mpt	DASpace + 4*17,MENU_ACTION,DA_Call
	mpt	DASpace + 5*17,MENU_ACTION,DA_Call
	mpt	DASpace + 6*17,MENU_ACTION,DA_Call
	mpt	DASpace + 7*17,MENU_ACTION,DA_Call
DeskInfoText:	.byte	"TopDesk Info",0
.ifdef topdesk128
SwitchText:  .byte   "switch mode",0
.endif

maxDesks	= 8	; maximale Anzahl der angezeigten DA's
DA_Init:	; Erstellung der Liste der DA's
	; der aktuellen Diskette
	LoadB	MyCurRec,0	; da DASpace=$6000
	ldx	activeWindow
	lda	windowsOpen,x
	beq	@l05
	LoadB	AskDiskFlag,0
	jsr	GetAktlDisk
	ldx	#$ff
	stx	AskDiskFlag
	tax
	bne	@l05
@10:	ldy	#3
@dloop:	lda	@data,y
	sta	r6L,y
	dey
	bpl	@dloop
	LoadW___	r10,0	; Keine Class-Angabe
	jsr	FindFTypes
	txa
	beq	@l10
@l05:	LoadB	r7H,maxDesks
@l10:	lda	#maxDesks	; Anzahl ermitteln
	sec
	sbc	r7H
	clc
.ifdef topdesk128
	adc	#02; Men}punktanzahl ermitteln
.else
	adc	#01; Men}punktanzahl ermitteln
.endif
	sta	a0	; und merken
	ora	#$80
	sta	geosanz	; und speichern
	LoadB	a1,14	; Untere Men}grenze
	ldx	#a0	; berechnen
	ldy	#a1
	jsr	BBMult
	ldx	a0
	inx
	txa		; Ergebnis zur
	clc		; oberen Grenze aufaddieren
	adc	geosoben
	sta	geosunten	; und speichern
	ldx	#0
@err:	rts
@data:	.word	DASpace
	.byte	DESK_ACC,maxDesks
DA_Call:	; Nummer des Men}punktes in a
	tax
	dex		; minus 1
.ifdef topdesk128
    dex
.endif
	stx	a0L
	jsr	GotoFirstMenu
	LoadB	a1,17
	ldx	#a0
	ldy	#a1
	jsr	BBMult	; mal 17
	lda	a0L
	clc
	adc	#<DASpace	; plus #DASpace
	sta	r6L
	lda	a0H
	adc	#>DASpace
	sta	r6H	; ergibt Filenamen des DA's
	LoadW___	r0,Name
	ldx	#r6
	ldy	#r0
	jsr	CopyString
	LoadW___	r6,Name
	LoadB	r0L,0
	jsr	StashMain
DA_Call2:	jsr	GetFile	; DA laden und ausf}hren
DAReturn:	txa
	pha
.ifdef topdesk128
    jsr SetMyNewMode
.else
	lda	c128Flag
	bpl	@04
	lda	graphMode
	bpl	@04
	eor	#$80
	sta	graphMode
	jsr	SetNewMode
.endif
@04:	jsr	SetColor
	jsr	RedrawHead
	pla
	tax
	bne	@05
	ldx	activeWindow
	jsr	ReLoad2
	bcc	@10
@05:	jsr	FehlerAusgabe
	ldx	#0
	rts
@10:	jsr	RedrawAll
	ldx	#0
	rts

KeyHandler:	lda	menuNumber
	beq	@05
	rts
@05:	ldy	#0
@10:	lda	KeyTab,y
	beq	@20
	cmp	keyData
	beq	@30
	iny
	bne	@10
@20:	lda	keyData
	bpl	@25
	and	#$7f
	cmp	#$30
	bcc	@25
	cmp	#$3a
	bcs	@25
	sec
	sbc	#$31
	bpl	@24
	lda	#9
@24:	jmp	SelectFileA
@25:	rts
@30:	tya
	asl
	tay
	lda	KeyServiceTab+1,y
	tax
	lda	KeyServiceTab,y
	jmp	CallRoutine
.macro ShortCutKey	value
	.byte	value+$80
.endmacro

KeyTab:	ShortCutKey	'm'
	ShortCutKey	'd'
	ShortCutKey	'r'
	ShortCutKey	'q'
	ShortCutKey	'v'
	ShortCutKey 's'
	ShortCutKey 'n'
	ShortCutKey 'f'
	ShortCutKey 'e'
	ShortCutKey 'z'
	ShortCutKey 'h'
	ShortCutKey 'k'
	ShortCutKey 'p'
	ShortCutKey 'o'
	.byte	1,3,5,14	; F1,F3,F5,F7
	ShortCutKey	1
	ShortCutKey	3
	ShortCutKey	5
	ShortCutKey	14
	ShortCutKey	'w'
	ShortCutKey	'x'
	ShortCutKey	'c'
	ShortCutKey	'l'
	ShortCutKey	't'
	ShortCutKey	'a'
	.byte	16,17,8,30	; CRSR
	ShortCutKey	20	; Pfeil nach links - Taste
	ShortCutKey	'b'
.ifdef topdesk128
	ShortCutKey	'g'
.endif
	.byte	NULL
KeyServiceTab:	.word	DeskRename,DeskDelete,Reset,DispFileInfo
	.word	DValidate,SetWindows,DeskRelabel,DeskFormat
	.word	DeskDosNew,DateiOeffnen,DeskDuplicate,DCopy
	.word	PrintService,NeuerOrdner
	.word	OpenD8,OpenD9,OpenD10,OpenD11,KS8,KS9,KS10,KS11
	.word	SelectAll,SelectPage,CloseAll,MakeRamTop
	.word	Ordnen,GetTime
	.word	ScrollUp,ScrollDown,ScrollLeft,ScrollRight
	.word	CloseService2,BackWindow
.ifdef topdesk128
    .word   SwapSchmal
.endif
ScrollUp:	lda	#WN_SCROLL_U
	.byte	$2c
ScrollDown:	lda	#WN_SCROLL_D
	.byte	$2c
ScrollLeft:	lda	#WN_SCROLL_L
	.byte	$2c
ScrollRight:	lda	#WN_SCROLL_R
	sta	messageBuffer
	MoveB	activeWindow,messageBuffer+1
	tax
	lda	windowsOpen,x
	beq	@10
	jmp	Handler
@10:	rts

SelectFileA:	pha
	ldy	activeWindow
	lda	windowsOpen,y
	bne	@10
	pla
	rts
@10:	sty	messageBuffer+1
	jsr	MyDCFilesSub
	MoveB	r2L,a2L
	MoveW_	a5,a3
	pla
	pha
	jsr	GetFileRect
	pla
	tax
	jmp	File_Selected
BackWindow2:	LoadB	messageBuffer,WN_HIDE
	MoveB	activeWindow,messageBuffer+1
	tax
	lda	windowsOpen,x
	beq	@10
	jmp	BackWindow
@10:	rts

.ifdef topdesk128
TypTab:	.word	@t0,@t1,@t2,@t3,@t4,@t5,@t6,@t7,@t8,@t9,@ta,@tb,@tc,@td,@te,@tf
.ifdef lang_de
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
.else
@t0:	.byte	"Non-GEOS",0
@t1:	.byte	"BASIC",0
@t2:	.byte	"Assembler",0
@t3:	.byte	"Data",0
@t4:	.byte	"System file",0
@t5:	.byte	"Desk Accessory",0
@t6:	.byte	"Application",0
@t7:	.byte	"Document",0
@t8:	.byte	"Font file",0
@t9:	.byte	"Printer driver",0
@ta:	.byte	"Input driver (64)",0
@tb:	.byte	"Directory",0
@tc:	.byte	"Boot file",0
@td:	.byte	"temporary",0
@te:	.byte	"auto exec",0
@tf:	.byte	"Input driver (128)",0
.endif
.endif


OpenNext:	ldx	activeWindow	; eventuell selektierte Files
	lda	windowsOpen,x	; deselektieren
	beq	@05
	stx	messageBuffer+1
	jsr	DispMarking
	jsr	ClearMultiFile
@05:
	jsr	GetNext	; freie WindowNummer holen
	bcc	@11
	jmp	OpenNext10	; >keine mehr frei
@11:
	txa
	pha
	jsr	GetDiskName
	txa
	beq	@0xx
	pla
	jmp	FehlerAusgabe
@0xx:	ldx	curType
	dex
	bne	@0x1
	lda	curDirHead+3
	bpl	@0x1
	pla
	ldx	#$80
	jmp	FehlerAusgabe
@0x1:	pla
	pha
	jsr	GetDiskInfo
	pla
	pha
	tax
	lda	curDrive	; Laufwerk merken
	sta	winDrives,x
	lda	#0
	sta	windowOffs,x
	sta	xOffsL,x
	sta	xOffsH,x
	jsr	GetSubDirXList
	jsr	ClearList
	pla
	tax

OpenNextNr:	lda	#0
	sta	aktl_Sub,x	; aktl Ebene setzen
	txa
	pha
	jsr	ReLoad2
	txa
	beq	@0xx
	pla
	jmp	FehlerAusgabe
@0xx:	jsr	GetStartPos
	pla
	pha
	tax
	sec
	jsr	SpeedWinMax
	;@HOHO:
	;inc $d020
	;jmp @HOHO
	pla
	tax
	jsr	OpenWindow
	jsr	GetPrefs
	lda	DiskDriverFlag
	bpl	OpenNext10
	lda	MyCurRec
	cmp	#1
	bne	OpenNext10
	jsr	GetDiskDrivers
OpenNext10:	rts

.ifndef topdesk128
GetZielPos:	ldx	#6
	.byte	$2c
GetStartPos: ldx	#00
	ldy	curDrive
	lda	@xL-8,y
	sta	r3L,x
	clc
	adc	#21
	sta	r4L,x
	lda	@xH-8,y
	sta	r3H,x
	adc	#0
	sta	r4H,x
	lda	@y-8,y
	sta	r2L,x
	clc
	adc	#21
	sta	r2H,x
	rts
@xL:	.byte	<(STARTA_X*8),<(STARTB_X*8),<(STARTC_X*8),<(STARTD_X*8)
@xH:	.byte	>(STARTA_X*8),>(STARTB_X*8),>(STARTC_X*8),>(STARTD_X*8)
@y:	.byte	STARTA_Y,STARTB_Y,STARTC_Y,STARTD_Y
.endif

ReLoad2:
	jsr	GetWinTabAdr
	pha
	LoadWr0	FILE_ANZ*82
	jsr	ClearRam
	pla
	tax
ReLoad:	; NeuEinladen der Files / Icons
	; Par:	x : WindowNummer (0-3)
	; Ret:	x : Fehlernummer, bei x=0 ist c=0, sonst 1
	txa
	pha
	jsr	GetDisk
	bcc	@f10
	pla
	rts
@f10:	pla
	tax
	jsr	GetWinTabAdr
	pha		; ehem. x-Reg. retten
	PushW	r1
	LoadWr0	FILE_ANZ*18
	jsr	ClearRam
	PopW	r3
	pla
	pha
	tax
	lda	aktl_Sub,x	; aktuelles Verzeichnis
	sta	r10L
	lda	windowOffs,x
	sta	r11H	; aktueller Offset
	LoadB	r11L,16	; Anzahl der Files
	LoadB	r12L,%11000000	; gel|schte Files nicht einlesen
	LoadB	r12H,$80	; alle Filetypen
	ldx	#4
	lda	DispMode
	beq	@10
	lda	#0
	sec
	sbc	#<ModStart
	sta	r0L
	lda	CopyMemHigh
	sbc	#>ModStart
	sta	r0H
	LoadW___	r1,ModStart
	jsr	ClearRam
	LoadB	MyCurRec,0
	LoadW___	r3,ModStart+2
	ldx	#01
	LoadB	r11L,144	; Anzahl der Files korrigieren
	LoadB	r11H,0	; OffSet auf 0 setzen
	lda	#30
	.byte	$2c
@10:	lda	#18
	sta	r13L	; Anzahl der Bytes pro Eintrag
	stx	r13H	; davon x }berlesen
	jsr	FindDirFiles
	txa
	beq	@15
	pla
	cmp	#11	; Puffer}berlauf?
	bne	@14
	ldy	#3
	lda	#0
@14a:	sta	windowsOpen,y
	dey
	bpl	@14a
	jsr	FehlerAusgabe
	sec
	rts
@14:	sec
	rts
@15:	pla
	tax
	lda	r14L
	clc
	adc	windowOffs,x
	sta	fileAnz,x
	lda	#16
	sec
	sbc	r11L
	sta	fileNum,x
	txa
	pha
	jsr	GetDiskInfo
	pla
	pha
	tax
	lda	DispMode
	beq	@20
	lda	windowOffs,x
	jsr	SortFileBuffer
@20:	pla
	tax
	lda	DispMode
	sta	winMode,x
	ldx	#0
	clc
	rts
;Stashdata:	.word	$6000,$2000,8000
;	.byte	0
MainAdr:	.word 	0

.ifndef topdesk128

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

.endif

WindowTab:
.ifdef topdesk128
Window1:
.endif
	.byte	15	; y oben
	.byte	15+90	; y unten
	.word	2	; x links
.ifdef topdesk128
WR1:
.endif
	.word	2+270	; x rechts
	.byte	$ff	; alle Gadgets
	.word	WinName1
	.word	Handler
.ifdef topdesk128
Window2:
.endif
	.byte	107	; y oben
	.byte	107+90	; y unten
	.word	2	; x links
.ifdef topdesk128
WR2:
.endif
	.word	2+270	; x rechts
	.byte	$ff	; alle Gadgets
	.word	WinName2
	.word	Handler
.ifdef topdesk128
Window3:
.endif
	.byte	24	; y oben
	.byte	24+90	; y unten
	.word	30	; x links
.ifdef topdesk128
WR3:
.endif
	.word	30+270	; x rechts
	.byte	$ff	; alle Gadgets
	.word	WinName3
	.word	Handler
.ifdef topdesk128
Window4:
.endif
	.byte	44	; y oben
	.byte	44+90	; y unten
	.word	50	; x links
.ifdef topdesk128
WR4:
.endif
	.word	50+265	; x rechts
	.byte	$ff	; alle Gadgets
	.word	WinName4
	.word	Handler
.ifdef topdesk128

StartWin:
    lda @f
    beq @10
@05: rts
@10:
    lda graphMode
    bpl @05
    LoadW___   WR1, 2+270*2
    LoadW___   WR2, 2+270*2
    LoadW___   WR3, 30+270*2
    LoadW___   WR4, 50+265*2
    LoadB   @f, 1
    rts
@f: .byte   0

.endif
FILE_ANZ	= 16	; nicht {ndern !
MOVE_OFFS	= 60

WinTabAdr:	.word	FileTab1,FileTab2,FileTab3,FileTab4
winDrives:	.byte	0,0,0,0
windowOffs:	.byte	0,0,0,0
xOffsL:	.byte	0,0,0,0
xOffsH:	.byte	0,0,0,0
fileNum:	.byte	0,0,0,0
fileAnz:	.byte	0,0,0,0
aktl_Sub:	.byte	0,0,0,0
subTab:	.byte	0,0,0,0,0,0,0,0
freeAnz:	.byte	0,0,0,0,0,0,0,0
maxAnz:	.byte	0,0,0,0,0,0,0,0
winMode:	.byte	0,0,0,0
NameTab:	.word	WinName1,WinName2,WinName3,WinName4
WinName1:	.byte	"x:"
	.repeat	78
	.byte 0	; Pfadname: "D:Disk/Sub1/Sub2/Sub3"
	.endrep
WinName2:	.byte	"x:"	; beim "/" bit 7 gesetzt!
	.repeat	78
	.byte 0	; Pfadname: "D:Disk/Sub1/Sub2/Sub3"
	.endrep
WinName3:	.byte	"x:"
	.repeat	78
	.byte 0	; Pfadname: "D:Disk/Sub1/Sub2/Sub3"
	.endrep
WinName4:	.byte	"x:"
	.repeat	78
	.byte 0	; Pfadname: "D:Disk/Sub1/Sub2/Sub3"
	.endrep
SubDirListTabL:	.byte	<SubDir1List,<SubDir2List,<SubDir3List,<SubDir4List
SubDirListTabH:	.byte	>SubDir1List,>SubDir2List,>SubDir3List,>SubDir4List

GetDiskName:	; Einlesen des Diskettennamens
	; Par:	x: WindowNummer
	; Alt:	WinNameX
	; Des:	a,x,y,diskBlkBuf
	txa
	pha
	jsr	OpenDisk
	txa
	beq	@10
	pla
	rts
@10:	pla
	jsr	GetWinName
	lda	curDrive
	clc
	adc	#57
	ldy	#0
	sta	(r1),y

	AddvW	2,r1
	ldy	#00
@20:	lda	(r5),y
	cmp	#$a0
	bne	@30
	lda	#$1b
@30:	sta	(r1),y
	iny
	cpy	#16
	bne	@20
	lda	#00
	sta	(r1),y
	ldx	#0
	rts

GetSubName:	; Der Name, der in Name steht, wird als Subdirectory-Name im
	; Titelstring des aktuellen Fensters eingetragen
	lda	activeWindow
GetSubName2:	jsr	GetWinName
	lda	#'/'+$80
	sta	(r1),y
	iny
	tya
	clc
	adc	r1L
	sta	r1L
	bcc	@10
	inc	r1H
@10:	LoadWr0	Name
	LoadB	r2L,17
	jmp	FormString

RemSubName:	; Der zuletzt im Titelstring des aktuellen Fensters eingetragene SubDir-
	; Name wird entfernt
	lda	activeWindow
	jsr	GetWinName
@10:	lda	(r1),y
	cmp	#'/'+$80
	beq	@20
	dey
	bne	@10
	sec
	rts
@20:	lda	#0
	sta	(r1),y
	clc
	rts

PrintDiskInfo:	PushW	r0
	ldx	messageBuffer+1
	jsr	GetWorkArea
	bcs	@10
	jsr	RestoreTextWin
@10:	SubVW_	10,r4
	ldx	r2H
	inx
	inx
	stx	r2L
	txa
	clc
	adc	#8
	sta	r2H
	lda	r3L
	clc
	adc	#10
	sta	r11L
	lda	r3H
	adc	#00
	sta	r11H
	ldx	r2H
	dex
	stx	r1H
	jsr	SetTextWin
	bcs	@21
	lda	messageBuffer+1
	asl
	pha
	tax
	lda	freeAnz,x
	sta	r0L
	lda	freeAnz+1,x
	sta	r0H
	jsr	@sub
	LoadWr0	@t4
	jsr	NewPutString
	pla
	tax
	lda	maxAnz,x
	sec
	sbc	freeAnz,x
	sta	r0L
	lda	maxAnz+1,x
	sbc	freeAnz+1,x
	sta	r0H
	jsr	@sub
	LoadWr0	@t3
	jsr	NewPutString
@20:	jsr	RestoreTextWin
@21:	PopW	r0
	rts
	; 		==>

@sub:	lda	KBytesFlag
	cmp	#' '
	beq	@kbytes
	lda	#%11000000
	jsr	NewPutDecimal
	LoadWr0	@t1
	jmp	NewPutString
@kbytes:	lsr	r0H
	ror	r0L
	lsr	r0H
	ror	r0L
	lda	#%11000000
	jsr	NewPutDecimal
	LoadWr0	@t2
	jmp	NewPutString
.ifdef lang_de
@t1:	.byte	" Bl|cke",0
@t2:	.byte	" KBytes",0
@t3:	.byte	" belegt ",0
@t4:	.byte	" frei    ",0
.else
@t1:	.byte	" blocks",0
@t2:	.byte	" KBytes",0
@t3:	.byte	" used ",0
@t4:	.byte	" free    ",0
.endif

GetAkltDiskInfo:	lda	activeWindow
GetDiskInfo:	pha
	LoadW___	r5,curDirHead
	jsr	CalcBlksFree
	pla
	asl
	tax
	lda	r4L
	sta	freeAnz,x
	lda	r4H
	sta	freeAnz+1,x
	lda	r3L
	sta	maxAnz,x
	lda	r3H
	sta	maxAnz+1,x
	rts

NormHandler:	; Behandlung der Messages Activate,Close,Restore
	lda	messageBuffer
@20:	cmp	#WN_CLOSE
	bne	@40
	jsr	DispMarking
	jsr	ClearMultiFile
	ldx	activeWindow
	lda	winDrives,x
	jsr	SetDevice
	ldx	activeWindow
	jsr	CloseWindow
	jsr	GetZielPos
	ldx	activeWindow
	clc
	jsr	SpeedWinMax	; actives Win. nach Ziel bewegen
	ldy	#00	; n{chstes Window aktivieren
@w10:	lda	activeWindow,y
	tax
	lda	windowsOpen,x
	bne	@w15
	iny
	cpy	#4
	bne	@w10
	ldx	#$ff
@w15:	txa
	bmi	@w19
	clc
	jmp	FrontWindow
@w19:	rts
@40:	cmp	#WN_RESTORE
	bne	@99
	jsr	PrintDriveNames
@99:	rts


PrintDriveNames:	MoveB	numDrives,a7L
	LoadWr0	University
	jsr	LoadCharSet
.ifdef topdesk128
    lda graphMode
    bpl @40
    jsr UseSystemFont
@40:
.endif
	dec	a7L
@loop:	ldx	a7L
	lda	@data,x
	sta	r1H
.ifdef topdesk128

.ifdef scalable_coords
	LoadW___	r11,(SC_FROM_END | 32)
	;LoadW___	r11,272+16
.else
	LoadW___	r11,272+16+DOUBLE_W
.endif
.else
	LoadW___	r11,272+16
.endif
	jsr	PutDrive
	dec	a7L
	bpl	@loop
	jsr	i_PutString
.ifdef topdesk128
	.word	5 +DOUBLE_W
	.byte	198,0
.else
	.word	5
	.byte	196,0
.endif
	LoadW___	r0,PrntFileName
	jsr	NewPutString

	jmp	UseSystemFont

@data:	.byte	55,87,119,151
PutDrive:	; schreibt DriveName
; Par:	x: Index f}r driveType  / r11;r1H f}r NewPutStr
; Ret:	r0 - Zeiger auf den String
	txa
	pha
	lda	driveType,x
	and	#%00000011
	tay
	dey
	bne	@10
	LoadB	@ty,'4'
	bne	@30
@10:	dey
	bne	@20
	LoadB	@ty,'7'
	bne	@30
	dey
	bne	@30
@20:	LoadB	@ty,'8'
@30:	lda	driveType,x
	bpl	@40
	lda	#PLAINTEXT
	sta	@nr
	sta	@nr+1
	LoadW___ r0, @dr
	SubVB	10,r11L	; nur low, da immer noch }ber 256
	jmp	@50
@40:	LoadB	@nr+1,':'
	LoadW___ r0, @nr
@50:	pla
	ldy	#0
	clc
	adc	#'A'
	sta	(r0),y
	jmp	NewPutString
@dr:	.byte	"x:RAM "
@nr:	.byte	PLAINTEXT,PLAINTEXT,"15"
@ty:	.byte	"41",0

CheckKlick:	; Ermittlung, ob Knopf gehalten oder nicht
	LoadB	dblClickCount,20
@10:	lda	dblClickCount
	beq	@30
	lda	mouseData
	bpl	@10
	sec	; Maus-Knopf nicht gehalten
	rts
@30:	clc	; Maus-Knopf gehalten
	rts

Handler:	ldx	messageBuffer+1	; File/Icontabellenadresse nach r0
	jsr	GetWinTabAdr
	jsr	MoveWr1r0
	lda	messageBuffer
	cmp	#WN_ACTIVATE
	beq	@002
	cmp	#WN_ACTIVATE2
	bne	@03
	lda	ghostFile
	beq	@002
	bpl	@02
;	clc
;	ldx	messageBuffer+1
;	jsr	FrontWindow
@002:	lda	messageBuffer+1
	pha
	MoveB	activeWindow,messageBuffer+1
	jsr	DispMarking
	pla
	sta	messageBuffer+1
	jsr	ClearMultiFile
	jsr	EndGhost
	ldx	messageBuffer+1
	lda	winMode,x
	cmp	DispMode
	beq	@n10
	jsr	ReLoad2
	bcc	@n05
	jmp	FehlerAusgabe
@n05:	sec
	bcs	@n20
@n10:	clc
@n20:	jsr	FrontWindow
	ldx	activeWindow
	lda	winDrives,x
	jmp	NewSetDevice
@02:	jmp	MoveService
@03:	cmp	#WN_USER
	bne	@03a
	jmp	@10
@03a:	jsr	EndGhost
	cmp	#WN_REDRAW
	beq	@05
	cmp	#WN_SCROLL_D
	bne	@03b
	jmp	@30
@03b:	cmp	#WN_SCROLL_U
	bne	@03c
	jmp	@50
@03c:	cmp	#WN_SCROLL_L
	beq	@06
	cmp	#WN_SCROLL_R
	beq	@08
	cmp	#WN_CLOSE
	bne	@04
	jmp	CloseService
@04:	jmp	NormHandler
@05:	jsr	PrintDiskInfo
	ldx	messageBuffer+1
	jsr	GetWorkArea
	bcs	@05a
	jsr	DispSizeRectangle
	jsr	MyDispFiles
	txa
	beq	@05a
	jsr	FehlerAusgabe2
@05a:	jmp	MaxTextWin

@06:	; Scroll-Links-Bearbeitung
	ldy	#0
	.byte	$2c
@08:	; Scroll-Rechts-Bearbeitung
	ldy	#6
	jsr	CheckKlick
	bcs	@08a
	ldx	messageBuffer+1
	lda	@tab1,y
	sta	xOffsL,x
	iny
	lda	@tab1,y
	sta	xOffsH,x
	iny
	jmp	@09
@08a:	iny
	iny
	ldx	messageBuffer+1
	lda	xOffsL,x
	cmp	@tab1,y
	bne	@08a1
	iny
	lda	xOffsH,x
	cmp	@tab1,y
	beq	@09
	dey
@08a1:	iny
	iny
	lda	xOffsL,x
	clc
	adc	@tab1,y
	sta	xOffsL,x
	iny
	lda	xOffsH,x
	adc	@tab1,y
	sta	xOffsH,x
@09:	jsr	GetWorkArea
	jsr	MyDispFiles
	txa
	beq	@e10
	jsr	FehlerAusgabe2
@e10:	rts
.ifdef topdesk128
@tab1:	.word	0,(6*MOVE_OFFS),MOVE_OFFS
	.word	-(6*MOVE_OFFS),-(6*MOVE_OFFS),-MOVE_OFFS
.else
@tab1:	.word	0,(3*MOVE_OFFS),MOVE_OFFS
	.word	-(3*MOVE_OFFS),-(3*MOVE_OFFS),-MOVE_OFFS
.endif
@10:	jsr	MyCheckFiles
	txa
	bmi	@20
	pha
	jsr	MyDCFilesSub
	MoveB	r2L,a2L
	MoveW_	a5,a3
	pla
	pha
	jsr	GetFileRect
	pla
	tax
	jmp	File_Selected
@20:	jsr	TestCBMKey
	bcs	@25
	jsr	EndGhost
	jsr	DispMarking
	jsr	ClearMultiFile
@25:	rts
@30:	; Scroll-down-Bearbeitung
	jsr	GetAktlDisk
	bcc	@31
	rts
@31:	jsr	CheckKlick
	bcs	@33
	ldx	messageBuffer+1
	lda	fileNum,x
	cmp	#16
	beq	@31a
	rts
@31a:	lda	#12
	clc
	adc	windowOffs,x
	sta	windowOffs,x
	PushW	r0
	jsr	MoveWr0r1
	LoadWr0	FILE_ANZ*82
	jsr	ClearRam
	PopW	r0
@33:	ldx	messageBuffer+1
	lda	fileNum,x
	cmp	#5
	bcs	@33a
	rts
@33a:	PushW	r0
	AddVW__	FILE_ANZ*18,r0	; r0>Anfang Icons
	jsr	MoveWr0r1	; r1=r0
	inc	r0H	; r0=r0+4*64
	LoadW___	r2,(FILE_ANZ-4)*64
	jsr	MoveData
	PopW	r1
	PushW	r1
	AddVW__	FILE_ANZ*18+(FILE_ANZ-4)*64,r1
	LoadWr0	4*64
	jsr	ClearRam
	ldx	messageBuffer+1
	lda	#4
	clc
	adc	windowOffs,x
	sta	windowOffs,x
	sta	r11H
	jsr	GetWorkArea
	ldx	activeWindow
	jsr	ReLoad
	PopW	r0
	jsr	MyDispFiles
	txa
	beq	@e20
	jsr	FehlerAusgabe2
@e20:	rts
@50:	; Scroll-up-Bearbeitung
	ldx	messageBuffer+1
	lda	windowOffs,x
	bne	@53
	rts
@53:	jsr	GetAktlDisk
	bcc	@53a
	rts
@53a:	jsr	CheckKlick
	bcs	@54
	ldx	messageBuffer+1
	lda	windowOffs,x
	sec
	sbc	#12
	sta	windowOffs,x
	PushW	r0
	jsr	MoveWr0r1
	LoadWr0	FILE_ANZ*82
	jsr	ClearRam
	PopW	r0
@54:	PushW	r0
	AddVW__	FILE_ANZ*18,r0	; r0>Anfang Icons
	jsr	MoveWr0r1	; r1=r0
	inc	r1H	; r1=r1+4*64
	LoadW___	r2,(FILE_ANZ-4)*64
	jsr	MoveData
	PopW	r1
	PushW	r1
	AddVW__	FILE_ANZ*18,r1
	LoadWr0	4*64
	jsr	ClearRam
	ldx	messageBuffer+1	;CheckKlick
	lda	windowOffs,x
	sec
	sbc	#4
	bpl	@55
	lda	#0
@55:	sta	windowOffs,x
	sta	r11H
	jsr	GetWorkArea
	ldx	activeWindow
	jsr	ReLoad
	PopW	r0
	jsr	MyDispFiles
	txa
	beq	@e30
	jsr	FehlerAusgabe2
@e30:	rts

MultiFileIcon:	;j
.incbin "topdesk/MultiFileIcon.bf"


PrintFlag:	.byte	0
PrintService:
DateiDrucken:	lda	#$ff
	.byte	$2c
DateiOeffnen:	lda	#0
	sta	PrintFlag
	jsr	GotoFirstMenu
	ldx	MultiCount
	dex
	bmi	@15
	bne	@10
	jsr	DispMarking
	jsr	GetMark
	jsr	GetFileName
	bcs	@15
	jmp	OpenFile
@10:	LoadB	DialBoxFlag,0
	LoadWr0	NoMultiFileBox
	jmp	NewDoDlgBox
@15:	rts
NoMultiFileBox:	.byte	$81
	.byte	$0b,$10,$10
	.word	@t1
	.byte	$0b,$10,$20
	.word	@t2
	.byte	$0b,$10,$30
	.word	@t3
	.byte	OK,17,72
	.byte	NULL
.ifdef lang_de
@t1:	.byte	BOLDON,"Diese Operation kann nicht",0
@t2:	.byte	"mit Multi-File ausgef}hrt",0
@t3:	.byte	"werden",0
.else
@t1:	.byte	BOLDON,"This function can not be",0
@t2:	.byte	"carried out under",0
@t3:	.byte	"Multi-File",0
.endif

;SizeRectangle
;Par: r0  - Zahl, die der Maximalgr|~e entspricht
;     r1  - Darzustellende Zahl
;     r2-r4 Rechteck
DispSizeRectangle:	PushW	r0
	lda	messageBuffer+1
	asl
	tax
	lda	maxAnz,x
	sta	r0L
	sec
	sbc	freeAnz,x
	sta	r1L
	lda	maxAnz+1,x
	sta	r0H
	sbc	freeAnz+1,x
	sta	r1H
	lda	r3L
	clc
	adc	#5
	sta	r4L
	lda	r3H
	adc	#00
	sta	r4H
	jsr	SizeRectangle
	PopW	r0
	rts

DispJumpTable:
	.repeat	$500
	.byte 0
	.endrep

.export __DISPJUMPTABLE__ := DispJumpTable

MyDispFiles	=	DispJumpTable
DispFiles	=	MyDispFiles+3
MyCheckFiles	=	DispFiles+3
CheckFiles	=	MyCheckFiles+3
GetFileRect	=	CheckFiles+3
SortFileBuffer	=	GetFileRect+3	; nur im Text-Modus
GetRealPos	=	SortFileBuffer+3	; nur im Text-Modus

GetFileName:	; Einlesen eines Filenames des aktuellen Fensters
	; Par:	a : Nummer (0-143)
	; Ret:	r0: Adresse (Name)
	; 	c = 1: Name mit Nummer a nicht vorhanden
	; 	(Dir hat weniger als a Files oder Diskettenfehler)
	pha
	jsr	GetAktlDisk
	tax
	beq	@05
	pla
	sec
	rts
@05:	pla
	sta	r11H
	LoadB	Name,0
	ldx	activeWindow
	LoadB	r11L,1
	LoadW___	r3,Name
	ldy	#3
@dloop:	lda	@data,y
	sta	r12L,y
	dey
	bpl	@dloop
	lda	aktl_Sub,x
	sta	r10L
	jsr	FindDirFiles
	lda	Name
	beq	@10
	ldy	#15
@loop:	lda	Name,y
	cmp	#$a0
	bne	@f10
	dey
	bpl	@loop
@f10:	lda	#0
	sta	Name+1,y
	clc
	rts
@10:	sec
	rts
@data:	.byte	%11000000,$80,16,4

File_Selected:	; Auswertung einer File-Selection
	;      x: Nummer des Files in der Darstellung (0-15)
	MoveB	dblClickCount,a9L
	stx	a1L
	ldx	activeWindow
	lda	a1L
	cmp	fileNum,x
	bcc	@002
@001:	jsr	EndGhost
	jsr	DispMarking
	jmp	ClearMultiFile
@0015:	lda	MultiCount
	cmp	#01
	bne	@001
	jsr	GetIndex
	cmp	MultiFileTab
	beq	@001
	jsr	SwapFile
	jmp	@001
@002:	lda	ghostFile
	bne	@0015
	ldx	a1L
	jsr	TestCBMKey
	bcc	@003
	jmp	Multi_Select
@003:	lda	a9L	; DoppelKlick ?
	bne	@004	; >ja
	txa
	ldx	activeWindow
	jsr	CheckDispMark
	bcs	@004
	jmp	@p_d_k
@004:	jsr	DispMarking
	jsr	ClearMultiFile
	jsr	GetIndex
	pha
	jsr	MarkFile
	jsr	DispMarking
	lda	a9L	; DoppelKlick?
	bne	@020	; >ja
	pla
	sta	@dbl
	LoadB	dblClickCount,20
@112:	rts
@dbl:	.byte	0
@020:	pla
	cmp	@dbl	; DoppelKlick auf gleichem File?
	bne	@112	; >nein
	lda	a1L
	jsr	GetName2
	LoadB	PrintFlag,0
	jmp	OpenFile
@p_d_k:	; Pause-Doppelklick
	lda	DispMode
	beq	@p10
	LoadW___	a2,TextSprite+1
	jmp	@p20
@p10:	LoadB	a2H,0
	sta	a3H
	lda	a1L
	sta	a2L
	LoadB	a3L,64
	ldx	#a2
	ldy	#a3
	jsr	DMult
	ldx	activeWindow
	jsr	GetWinTabAdr
	AddVW__	FILE_ANZ*18+1,r1
	AddW	r1,a2
@p20:
.ifdef topdesk128
    LoadB	r3L,2
.else
    LoadB	r3L,1
.endif
	MoveW_	a2,r4
	lda	MultiCount
	cmp	#1
	beq	@p20a
	LoadW___	r4,MultiFileIcon+1
@p20a:
.ifdef topdesk128
    ldy #63
    lda (r4),y
    pha
    lda #21
    sta (r4),y
.endif
    jsr	DrawSprite
.ifdef topdesk128
    jsr HideOnlyMouse
    pla
    ldy #63
    sta (r4),y
.endif
	jsr	InitForIO
	jsr	DoneWithIO
	LoadB	ghostFile,1
	jsr	InitForIO
.ifdef topdesk128
	MoveB	$d027,$d029	; Farbe des Ghost-Sprites von Mauszeiger
.else
	MoveB	$d027,$d028	; Farbe des Ghost-Sprites von Mauszeiger
.endif
.ifdef topdesk128
    lda graphMode
    bmi @q80
@q40:
    lda $d01d
    and #%11111011
    sta $d01d
    jmp @qend
@q80:
.ifdef mega65
    lda $d01d
    and #%11111011
    sta $d01d
.else
    lda SchmalFlag
    cmp #'*'
    beq @q40
    lda $d01d
    ora #%100
    sta $d01d
.endif
@qend:
.endif
	jsr	DoneWithIO
	rts

OpenFile:	jsr	ClearMultiFile2
	jsr	MaxTextWin
@04:	jsr	GetAktlDisk
	bcc	@05
	rts
@05:	LoadB	a7L,0
	jsr	CheckKlick
	bcs	@d10
	LoadB	a7L,1
@d10:	jsr	GetSubDirXList
	LoadW___	r6,Name
	MoveB	PrintFlag,r1L
	jsr	NewGetFile
	txa
	bne	@10a
	jmp	@10
@10a:	cmp	#SUB_DIR
	beq	@10b
	jmp	@15
@10b:	lda	a7L
	beq	@w10
	lda	r10L
	sta	OpenNextNr+1
	jsr	GetNext	; freie WindowNummer holen
	bcc	@11
	jmp	@w09	; >keine mehr frei
@11:	stx	 @new
	lda	#0
	sta	windowOffs,x
	jsr	GetSubDirXList
	ldx	activeWindow
	lda	SubDirListTabL,x
	sta	r1L
	lda	SubDirListTabH,x
	sta	r1H
	ldy	#63
@w05:	lda	(r1),y
	sta	(r0),y
	dey
	bpl	@w05
	lda	@new
	jsr	GetWinName
	jsr	MoveWr1r0
	lda	activeWindow
	jsr	GetWinName
@w07:	lda	(r1),y
	sta	(r0),y
	dey
	bpl	@w07
	ldx	activeWindow
	ldy	@new
	lda	winDrives,x
	sta	winDrives,y
	tya
	jsr	GetSubName2
	lda	r10L
	sta	OpenNextNr+1
	ldx	activeWindow
	jsr	GetSubDirXList
	jsr	UpperDir
	ldx	@new
	jsr	OpenNextNr
@w08:	LoadB	OpenNextNr+1,0
	rts
@w09:	ldx	activeWindow
	jsr	GetSubDirXList
	jsr	UpperDir
	LoadB	OpenNextNr+1,0
	rts
@new:	.byte	0
@w10:	ldx	activeWindow
	lda	r10L
	sta	aktl_Sub,x
	txa
	pha
	jsr	GetSubName
	pla
	tax
	jsr	NewDirLoad
	txa
	beq	@e10
	jsr	FehlerAusgabe
@e10:	; rts
@10:
@14:	rts
@15:	cmp	#14	; INCOMPATIBLE
	bne	@16
	jsr	StashMain
	jsr	TestTopDesk
	bcs	@18
	lda	graphMode
	eor	#$80
	sta	graphMode
	jsr	SetNewMode
	jmp	@04
@16:	cpx	#15
	bne	@17
	jsr	SetNumDrives
	jsr	MaxTextWin
	LoadWr0	@db
	jmp	NewDoDlgBox
@17:	cpx	#16
	bne	@18
	jsr	SetNumDrives
	jsr	MaxTextWin
	LoadWr0	@db2
	jmp	NewDoDlgBox
@18:	; bei x=18 ist auf RAM A und B kein DeskTop gewesen!
	jsr	SetNumDrives
	rts
@db:	.byte	$81
	.byte	$0b,$10,$10
	.word	@t1
	.byte	$0b,$10,$20
	.word	@t2
	.byte	OK,17,72,NULL
.ifdef lang_de
@t1:	.byte	"Dieses Programm ist nur",0
@t2:	.byte	"unter GEOS 64 lauff{hig.",0
.else
@t1:	.byte	"This programme only works",0
@t2:	.byte	"together with  GEOS 64.",0
.endif
@db2:	.byte	$81
	.byte	$0b,$10,$10
	.word	@t1b
	.byte	$0b,$10,$20
	.word	@t2b
	.byte	OK,17,72,NULL
.ifdef lang_de
@t1b:	.byte	"Programmstart von Laufwerk",0
@t2b:	.byte	"C bzw. D nicht m|glich.",0
.else
@t1b:	.byte	"A Programme start from either drive",0
@t2b:	.byte	"C or D is not possible.",0
.endif
activeFile:	.byte	$ff
Multi_Select:	jsr	InvertRectangle
	ldx	activeWindow
	lda	a1L
	jsr	CheckDispMark
	bcc	@10
	tax
	jmp	MarkFile
@10:	tax
	jmp	UnMarkFile

TextSprite:
;j
.incbin "topdesk/TextSprite.bf"

TestCBMKey:	jsr	InitForIO
	LoadB	$dc00,$7f
	lda	$dc01
	and	#$20
	pha
	jsr	DoneWithIO
	pla
	clc
	bne	@10
	sec
@10:	rts
GetIndex:	ldx	activeWindow
	lda	DispMode
	beq	@110
	lda	a1L
	jsr	GetRealPos
	tax
	jmp	@111
@110:	lda	a1L
	clc
	adc	windowOffs,x
	tax
@111:	rts

GetName2:	; Kopieren des Namens Nr. a (0-15) des aktuellen Fensters nach Name
	sta	r0L
	LoadB	r0H,0
	LoadW___	r1,18
	ldx	#r0
	ldy	#r1
	jsr	DMult
	ldx	activeWindow
	jsr	GetWinTabAdr
	AddW	r1,r0
	LoadW___	r1,Name
	LoadB	r2L,17
	jmp	FormString

CloseService2:	LoadB	messageBuffer,WN_CLOSE
	MoveB	activeWindow,messageBuffer+1
	tax
	lda	windowsOpen,x
	bne	CloseService
	rts

CloseService:	jsr	CheckKlick
	bcc	@05
	ldx	messageBuffer+1
	lda	aktl_Sub,x
	bne	@10
@05:	lda	activeWindow
	jsr	GetWinName
	lda	#'x'
	ldy	#00
	sta	(r1),y
	jmp	NormHandler
@10:	jsr	RemSubName
	ldx	messageBuffer+1
	jsr	GetSubDirXList
	jsr	UpperDir
	sta	aktl_Sub,x
	jsr	NewDirLoad
	txa
	beq	@e10
	jsr	FehlerAusgabe
@e10:	rts

MarkFile:	; Markierung eines Files in der Multi-File-Tabelle
	; Par: x: Nummer des Files (0-143)
	ldy	MultiCount
	txa
	sta	MultiFileTab,y
	inc	MultiCount
	jmp	DispMultiCount
UnMarkFile:	; L|schen der Markierung
	; Par: x: Nummer des Files (0-143)
	ldy	#144	; Nummer in MultiFileTab suchen
	txa
@10:	cmp	MultiFileTab-1,y
	beq	@20
	dey
	bne	@10
	rts
@20:	lda	MultiFileTab,y	; alle folgenden Eintr{ge nachr}cken
	sta	MultiFileTab-1,y
	iny
	cpy	#144
	bne	@20
	LoadB	MultiFileTab+143,$ff
	dec	MultiCount
	jmp	DispMultiCount
ClearMultiFile2:	txa
	pha
	jsr	DispMarking
	pla
	tax
ClearMultiFile:	; x bleibt erhalten !
	ldy	#145
	lda	#$ff
@10:	sta	MultiFileTab-1,y
	dey
	bne	@10
	LoadB	MultiCount,0
	jmp	DispMultiCount
GetMark:	; markierte Filenummer holen
	; Ret:	a : Filenummer
	lda	MultiFileTab
	bmi	@10
	pha
	tax
	jsr	UnMarkFile
	ldx	activeWindow
	pla
@10:	rts

.ifndef topdesk128
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
	.word	222,236
	MoveB	MultiCount,r0L
	LoadB	r0H,0
	LoadW___	r11,223
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

NewDirLoad:	ldx	activeWindow
	lda	#0
	sta	windowOffs,x
	sta	xOffsL,x
	sta	xOffsH,x
	jsr	ReLoad2
	bcs	@10
	jsr	Redraw
	ldx	#0
@10:	rts
MoveService:	; Verschieben/Kopieren von Files zwischen aktivem und
	; (messageBuffer+1)-Fenster mit Multi-File-Bearbeitung
	LoadB	DialBoxFlag,1
	PushB	messageBuffer+1
	MoveB	activeWindow,messageBuffer+1
	jsr	DispMarking
	PopB	messageBuffer+1
	LoadB	a8L,0
	ldx	messageBuffer+1
	jsr	GetWinDisk	; Kopieren ?
	beq	@05	; >nein
	LoadB	DialBoxFlag,120
@03:	LoadB	a8L,1
	bne	@10
@05:	LoadW___	r2,MultiFileTab
	jsr	BubbleSort
@10:	jsr	GetMark
	tax
	bpl	@c00
	jmp	@20
@c00:	pha
	ldy	a8L
	bne	@c01
	jmp	@c20
@c01:	jsr	CopyService
	bcc	@c05
	LoadB	DialBoxFlag,120
	bne	@c10
@c05:	lda	MultiFileTab
	bpl	@c20
@c10:	jsr	ClearMultiFile
	LoadB	MyCurRec,0
	jsr	SetCopyMemLow
	ldx	DialBoxFlag
	cpx	#120
	beq	@c20
	PushB	messageBuffer+1
	jsr	RecoverLast
	PopB	messageBuffer+1
@c20:	pla
	tax
	ldy	a8L
	bne	@10
	jsr	GetFileName
	bcc	@c20a
@err2:	jsr	FehlerAusgabe
	jsr	ClearMultiFile
	jmp	@10
@c20a:	ldx	messageBuffer+1
	lda	aktl_Sub,x
	sta	r10L
	LoadW___	r6,Name
	jsr	FindFile
	txa
	bne	@err2
	lda	$8400+22
	cmp	#11	; Directory
	bne	@d05
	MoveW_	$8400+19,r1
	LoadW___	r4,$8000
	jsr	GetBlock
	lda	$8000+OFF_DIR_NUM
	jsr	CheckDirNum
	bcs	@d10
@d05:	LoadW___	r6,Name
	jsr	MoveFileInDir
	txa
	bne	@err2
@d10:	jmp	@10
@20:	LoadB	DialBoxFlag,0
	lda	activeWindow
	pha
	ldx	messageBuffer+1
	jsr	GetDisk
	txa
	beq	@e10
@err:	pla
	jmp	FehlerAusgabe
@e10:	ldx	messageBuffer+1
	jsr	ReLoad2
	bcs	@err
	ldx	messageBuffer+1
	sec
	jsr	FrontWindow
	ldy	a8L
	beq	@010
	pla
	tax
	clc
	jsr	FrontWindow
	jmp	@020
@010:	pla
	pha
	tax
	jsr	ReLoad2
	bcs	@err
	pla
	tax
	sec
	jsr	FrontWindow
@020:	ldx	#0
	stx	ghostFile
.ifdef topdesk128
	lda	#2
.else
	lda	#1
.endif
	sta	r3L
	jsr	DisablSprite
DoHauptMenu:	php
	sei
	PushW	$3a
	PushB	$3c
	LoadWr0	HauptMenu
	jsr	DoMenu
	PopB	$3c
	PopW	$3a
	plp
	rts
CheckDirNum:	sta	r1L
	ldx	messageBuffer+1
	jsr	GetSubDirXList
	ldy	#0
@loop:	lda	(r0),y
	bmi	@geht
	cmp	r1L
	beq	@gehtnicht
	iny
	bne	@loop
@geht:	clc
	rts
@gehtnicht:	sec
	rts
.ifdef topdesk128
Doppeln:
    ldy #2
    lda (r0),y
    asl
    sta (r0),y
    iny
    lda (r0),y
    rol
    sta (r0),y
    ldy #4
    lda (r0),y
    asl
    sta (r0),y
    iny
    lda (r0),y
    rol
    sta (r0),y
    rts
.endif




.include "topdesk/Include/DeskMain2.inc"
