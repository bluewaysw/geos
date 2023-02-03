.segment "OVERLAY10"
;	n	"DeskMod J"
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



SubDir2List	= SubDir1List + 64
SubDir3List	= SubDir2List + 64
SubDir4List	= SubDir3List+ 64
MultiFileTab	= SubDir4List+64
Name	= MultiFileTab + 145
DiskName	= Name + 19
Name2	= DiskName + 19

	jmp	MakeRamTop
	jmp	LoadRest
	jmp	StashMain
MakeRamTop:	lda	RamTopFlag
	beq	@geht
	ldy	#6
@dl:	lda	@dd,y
	sta	r0L,y
	dey
	bpl	@dl
	jsr	StashRAM
	lda	curDrive
	and	#%00001101
	jsr	SetDevice
	LoadW___	$88ee,$ffa0	; DrDCurDkNm
	jmp	EnterDeskTop
@dd:	.word	$0400,$0400,$3900-$400	; MoveData-Bereich einfach
	.byte	0	; ]berschreiben
@gehtnicht:	ldx	#13
	rts
@geht:	lda	ramExpSize
	beq	@gehtnicht
	LoadB	RamTopFlag,1
	jsr	SearchDeskTop
	bcc	@10
	rts
@10:	MoveB	RamTopFlag,$8090
	MoveW_	$8400+19,r1
	LoadW___	r4,$8000
	jsr	PutBlock
	LoadWr0	MyName
	jsr	OpenRecordFile
	lda	#1
	jsr	PointRecord
	LoadW___	a0,$0420
	LoadB	a1L,0

@loop:	LoadW___	r7,DataSpace
	LoadW___	r2,$2000
	jsr	ReadRecord
	SubVW_	DataSpace,r7
	LoadW___	r0,DataSpace
	MoveW_	a0,r1
	MoveW_	r7,r2
	LoadB	r3L,0
	jsr	StashRAM
	jsr	@stashadr
	AddW	r7,a0
	jsr	NextRecord
	txa
	beq	@loop
	jsr	@stashadr
	MoveB	a0L,StashMainAdr
	sta	MainAdr
	MoveB	a0H,StashMainAdr+1
	sta	MainAdr+1
	ldy	#6
@dloop:	lda	@data,y
	sta	r0L,y
	dey
	bpl	@dloop
	jsr	StashRAM
	lda	sysRAMFlg	; REU-MoveData ausschalten
	and	#$7f
	sta	sysRAMFlg
	jsr	i_MoveData
	.word	NewGetModule,SearchDeskTop,NewGetModuleEnd-NewGetModule
	jmp	StashMain
@stashadr:	ldy	a1L
	lda	a0L
	sta	ModTab,y
	iny
	lda	a0H
	sta	ModTab,y
	iny
	sty	a1L
	rts
@data:	.word	StashMainAdr,$0400,$1e
	.byte	0
StashMainAdr:	.word	0
ModTab:	.word	0,0,0,0,0,0,0,0,0,0,0,0


;  NewGetModule mu~ positionsunabh{ngig sein!
NewGetModule:	rts	; f}r SearchDeskTop-Einsprung
	nop
	nop
	; Par: a - Modulnummer
	; Ret: r7 - Adresse des letzten geladenen Byte +1
	cmp	MyCurRec	; eigentlicher GetModule-Einsprung
	bne	@nichtmehrda
	clc
	rts
@nichtmehrda:	sta	MyCurRec
	pha
	MoveW_	ModStartAdress,r0
	LoadW___	r1,$0400
	LoadB	r2L,$1e
	LoadB	r2H,0
	sta	r3L
	jsr	FetchRAM
	pla
	asl
	tay
	lda	(r0),y
	sta	r1L
	iny
	lda	(r0),y
	sta	r1H
	iny
	lda	(r0),y
	sec
	sbc	r1L
	sta	r2L
	iny
	lda	(r0),y
	sbc	r1H
	sta	r2H
;	MoveW_	ModStartAdress,r0	; noch gesetzt
;	LoadB	r3L,0
	jsr	FetchRAM
	lda	r0L
	clc
	adc	r2L
	sta	r7L
	lda	r0H
	clc
	adc	r2H
	sta	r7H
	clc
	rts
NewGetModuleEnd:

SearchRAMDisk:	ldy	#8	; SearchRAMDisk + 2 = :loop !!
@loop:	lda	driveType-8,y
	beq	@keinsda
	bmi	@habeins
	iny
	bne	@loop
@keinsda:	ldx	#13	; DEV_NOT_FOUND
	rts
@habeins:	tya
	jsr	NewSetDevice
	jmp	OpenDisk
StashMain:	LoadB	r2H,$78
	lda	c128Flag
	bpl	@64
	LoadB	r2H,$38
@64:	LoadB	r2L,$ff
	MoveW_	MainAdr,r1
	LoadW___	r0,$400
	SubW	r1,r2
	MoveW_	r1,TopMainAnf
	MoveW_	r2,TopMainLen
	LoadW___	r1,$100
	LoadW___	r0,RamStart
	jsr	CRC
	MoveW_	r2,PruefSumme
	LoadW___	r0,$400
	MoveW_	TopMainAnf,r1
	MoveW_	TopMainLen,r2
	jsr	StashRAM
	PushB	curDrive
	jsr	SearchRAMDisk
	txa
	beq	@05
	jmp	@gehtnicht
@d:	.byte	0
@05:	LoadB	@d,0
	LoadW___	r6,MyName
	jsr	FindFile
	txa
	bne	@06
	lda	r5L
	cmp	#2
	beq	@05a
	DecW	r5
	jmp	@05b
@05a:	AddVW__	$1e,r5
@05b:	ldy	#0
	lda	(r5),y
	sta	@d
	LoadW___	r6,MyName
	LoadB	r10L,0
	jsr	MoveFileInDir
	LoadW___	r0,MyName
	jsr	DeleteFile
@06:	LoadW___	r9,TopInfo
	LoadB	r10L,0
	jsr	SaveFile
	txa
	beq	@ne1
	jmp	@err
@err2:	jsr	CloseRecordFile
@err:	LoadW___	r6,MyName
	LoadB	r10L,0
	jsr	MoveFileInDir
	LoadW___	r0,MyName
	jsr	DeleteFile
	ldy	curDrive
	iny
	jsr	SearchRAMDisk+2
	txa
	bne	@ne0
	jmp	@05
@ne0:	jmp	@gehtnicht
@ne1:	LoadW___	r6,MyName
	MoveB	@d,r10L
	jsr	MoveFileInDir
	LoadW___	r0,MyName
	jsr	OpenRecordFile
	jsr	AppendRecord
	LoadW___	r7,NewEDT128
	LoadW___	r2,NewEDT128Len
	jsr	WriteRecord
	txa
@err1:	bne	@err2
	jsr	AppendRecord
	MoveB	TopMainLen,r7L	; LadeAdr = Stashl{nge + $400
	lda	TopMainLen+1
	clc
	adc	#4
	sta	r7H
	PushW	r7
	lda	#<FileTab1
	sec
	sbc	r7L
	sta	r2L
	lda	#>FileTab1
	sbc	r7H
	sta	r2H
	bmi	@10	; kein 2. Datensatz erzeugen
	jsr	WriteRecord
	txa
	beq	@10
	pla
	pla
	jmp	@err1
@10:	jsr	CloseRecordFile
	MoveW_	$8400+19,r1
	LoadW___	r4,$8000
	jsr	GetBlock
	LoadB	$8047,<NewEDT128
	sta	$804b
	LoadB	$8048,>NewEDT128
	sta	$804c
	LoadB	$8060,$40	; lauff{hig unter Geos 64 u. 128 (40/80)
	lda	#0
	sta	$8061	; kein Autor
	sta	$80a0	; kein Infotext
	PopW	$8086	; Ladeadresse 2. Datensatz
	jsr	PutBlock
@gehtnicht:	stx	@x
	pla
	jsr	NewSetDevice
@20:	ldy	#r15-2
@loop:	lda	RegBuf,y
	sta	r0L,y
	dey
	bpl	@loop
	ldx	@x
	rts
@x:	.byte	0
TopInfo:	.word	MyName
	.byte	3,21
	;j
.incbin "topdesk/Temp.bf"	
	.byte	$83,6,1
	.word	0,0,0
	.byte	"TopDeskTemp V1.0",0

LoadRest:	LoadW___	r6,MyName
	jsr	FindFile
	txa
	beq	@10
	rts	; Load NormTopDesk
@10:	MoveW_	$8400+19,r1
	LoadW___	r4,$8100
	jsr	GetBlock
	PushW	$8186
	LoadW___	r0,MyName
	jsr	OpenRecordFile
	jsr	NextRecord
	PopW	r7
	LoadW___	r2,-1
	jsr	ReadRecord
	jmp	Start

NewEDT128:
@05:	ldx	#6
@loop2:	lda	TopData,x
	sta	r0L,x
	dex
	bpl	@loop2
	jsr	FetchRAM
	txa
	bne	@NormTop
	LoadW___	r1,$100
	LoadW___	r0,RamStart
	jsr	CRC
	CmpW	r2,PruefSumme
	bne	@NormTop
@10:	jmp	RamStart
@name:	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
@NormTop:	ldy	#0
@loop:	lda	$8400+3,y
	cmp	#$0a
	beq	@03
	sta	@name,y
	iny
	cpy	#16
	bne	@loop
@03:	lda	#0
	sta	@name,y
	LoadW___	r0,@name
	jsr	DeleteFile
	LoadW___	$88ee,$ffa0	; DrDCurDkNm
	jmp	EnterDeskTop
TopData:	.word	$0400
TopMainAnf:	.word	0
TopMainLen:	.word	0
	.byte	0
NewEDT128End:
NewEDT128Len	= NewEDT128End-NewEDT128

DataSpace:
