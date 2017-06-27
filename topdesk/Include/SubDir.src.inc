; FindDirFiles
; Parameter
; r3   - Zeiger auf einen Puffer f}r kompl. FileEintr{ge
; r10L - Nummer des Verzeichnisses
;      - b7=1 alle Verzeichnisse
; r11L - Anzahl der einzulesenden Files im akt. Dir
;        
; r11H - Anzahl der zu }berlesenden Eintr{ge
;        0 f}r keinen Eintrag }berlesen
; r12L - b7=1 b6=1 gel|schte Files und Leereintr{ge 
;                  }berlesen
;      - b7=1 b6=0 gel|schte Files einlesen,
;                  Leereintr{ge }berlesen
;      - b7=0      auch gel|schte Files und Leereintr{ge
;                  einlesen
; r12H - GEOS-Filetyp oder
;        b7=1 - alle Filetypen
; r13L - Anzahl der Bytes eines Fileeintrages, die
;        eingelesen werden sollen
; r13H - Anzahl der zu }berlesenden Bytes im Eintrag
; CopyMemHigh	; Obergrenze des Puffers in r3 (HighByte)
;
; Returns
; x = 0 (No Error)
; x = 11 (Puffer}berlauf beim Laden, CopyMemHigh w}rde }berschritten)
; r11L - vermindert um die Anzahl der eingelesenen Files
;        bzw. 0
; r14L - Anzahl der vorhandenen Files im (Sub)-Dir
;
; Destroys
; r0-r5,r11H,
; a,x,y
;
; Uses
; - DiskInitTurboIO
; - ReadTrScBlock
; - SortDirFiles
; - SortInBuffer
;
; Description
;
; Ab dem Puffer, auf den r3 zeigt, sind alle Files
; in der gleichen Reihenfolge abgelegt.
; Jeder Fileeintrag ist auf Diskette 31 Bytes lang.
; Sofern r13H = 0 ist, wird als erstes Byte die Nummer
; des Unterverzeichnisses abgelegt.
; Die restlichen Bytes sind genauso abgelegt, wie
; sie im Directory stehen!
; Es wird solange eingelesen bis CopyMemHigh erreicht ist (Kn 22.5.91)
; OpenDisk wird nicht aufgerufen !!! (Kn 7.5.91)
;
; FindDirFiles sucht auch auf dem BorderBlock
; evtl. Verzeichnisnummern sind auch hier
; g}ltig!

FindDirFiles:
;XXX	MoveW_	r3,@r3	; Kn 22.9.91
@10:	
;XXX	MoveW_	@r3,r3
	LoadB	r14L,0
	jsr	DiskInitTurboIO
	txa
	bne	@100	; DoneWithIO beq	:20
@20:	jsr	@200
	txa
	bne	@100
	lda	r11L
	beq	@allesvoll
; jetzt BorderBlock
	lda	isGEOS
	beq	@allesvoll
	MoveW_	curDirHead+171,TrSc
	jsr	@200
	txa
	bne	@100
@allesvoll:	ldx	#$00
@100:	jsr	DoneWithIO
;XXX	cpx	#$50	; Kn 22.9.91
;XXX	bne	@125
;XXX	jmp	@10
;XXX@125:
	rts
@200:	jsr	ReadTrScBlock
	txa
	bne	@1000
	jsr	SortDirFiles
	jsr	SortInBuffer
	txa		; Kn 22.5.91
	bne	@1000
	lda	TrSc
	bne	@200	; Kn 7.5.91
@99:	ldx	#$00
@1000:	rts
;XXX	@r3:	.word	0	; Kn 22.9.91
TrSc:	.word	0

; SortDirFiles		; (Kn 7.5.91  Copy31Byte weggek}rzt!)
; internal Routine
; - CopyFW
;
; Destroys
; r0,r5
; a,x,y

SortDirFiles:
	LoadW___	r0,diskBlkBuf ;MyBuffer
	LoadW___	r5,diskBlkBuf+2
	ldx	#6
	ldy	#0
	lda	diskBlkBuf+32
	sta	(r0),y
	AddVW__	1,r0
	ldy	#30
	jsr	CopyFW
	LoadW___	r5,diskBlkBuf+33
	SubVW_	1,r0
@20:	AddVW__	32,r0
	ldy	#31

	jsr	CopyFW

	AddVW__ 32,r5
	dex
	bpl	@20
	rts

; SortInBuffer
; Internal Routine
; Ret: x - Fehlernummer	; Kn 22.05.91
SortInBuffer:
	ldx	#7
	LoadW___	r5,diskBlkBuf ;MyBuffer
;	AddSW__	r13H,r5
@10:	MoveB	r3L,r0L	; Kn 22.05.91
	MoveB	r3H,r0H
	cmp	CopyMemHigh
	bcc	@16
	ldx	#11
	rts
@16:	
;	MoveW_	r3,r0
	bit	r10L
	bmi	@15
.if 0
	ldy	#1	; Kn 22.9.91: autom. l|schen von 
	lda	(r5),y	; tempor{r-Dateien
	beq	@16a
	ldy	#23
	lda	(r5),y
	cmp	#13	; tempor{r-Filetyp
	bne	@16a
	ldy	#4
@16c:	lda	(r5),y
	sta	Name-4,y
	cmp	#$a0
	bne	@16b
@16d:	lda	#0
	sta	Name-4,y
	jsr	DoneWithIO
	LoadW___	r0,Name
	jsr	DeleteFile
	jsr	InitForIO
	ldx	#$50
	rts
@16b:	iny
	cpy	#16+4
	bne	@16c
	beq	@16d
@16a:	
.endif
	ldy	#$00
	lda	(r5),y
	cmp	r10L
	bne	@1000
@15:	bit	r12H
	bmi	@12
	ldy	#23
	lda	(r5),y
	cmp	r12H
	bne	@1000
@12:	ldy	#1
	lda	(r5),y	; CBM Filetyp = 0 (DEL)
	bne	@11
	bit	r12L
	bpl	@11
	bvs	@1000
	ldy	#4
	lda	(r5),y	; Filename = 0 
	bne	@11
	beq	@1000
@11:	lda	r11H
	beq	@20
	dec	r11H
	jmp	@1000

@20:	AddSW	r13H,r5
	inc	r14L
	ldy	r11L
	beq	@30
	ldy	r13L
	jsr	CopyFW
@30:	SubSW	r13H,r5
	AddSW	r13L,r3
	lda	r11L
	beq	@1000
	dec	r11L
@1000:	AddVW__	32,r5
	dex
	bmi	@9999
	jmp	@10
@9999:	ldx	#0	; Kn 22.05.91
	rts

; DiskInitTurboIO	; (Kn 7.5.91: CopyFString2 entfernt!)
; Internal Routine
; - kein OpenDisk (Kn 7.5.91)
; - EnterTurbo
; - TrSc = First Track & Sector
; - InitForIO, if No Error (=0)

DiskInitTurboIO:
;	jsr	OpenDisk
	LoadW___	r4,diskBlkBuf
	jsr	EnterTurbo
	txa
	bne	@5
	MoveW_	curDirHead,TrSc
	lda	TrSc
	bne	@10
	ldx	#$02	; INV_TRACK
@5:	rts
@10:	jsr	InitForIO
	rts

; ReadTrScBlock
; Internal Routine
; - Kopiert TrSc nach r1
; - ReadBlock
; - setzt TrSc neu, falls x <> 0 
; Achtung!!!
; EnterTurbo und InitForIO m}ssen gesetzt sein !!

ReadTrScBlock:
	MoveW_	TrSc,r1
	jsr	ReadBlock
	txa
	bne	@100
	MoveW_	diskBlkBuf,TrSc
@100:	rts

;XXX>

; CopyFW
; Ersatz f}r CopyFString und CopyFString2
; funktioniert sicher auch, wenn InitForIO
; Im Gegensatz von CopyFString2 wird aufw{rts
; gez{hlt.
;
; Parameter
; r5	Source
; r0	Dest
; y	Count-1 (0 = 256)
;
; Destroys
; a,y, 

CopyFW:
	sty	@10+1
	ldy	#$00
@30:	lda	(r5),y
	sta	(r0),y
	iny
@10:	cpy	#00
	bne	@30
	rts

;XXX<

; FormString
;
; durchsucht einen Text auf $a0, setzt beim ersten $a0
; den Wert $00 als Stringendekennzeichen.
; Wird kein $a0 gefunden, wird das letzte Zeichen mit
; $00 belegt.
; Kopiert gleichzeitig den String durch Setzen von
; Dest = Source ist ein "In-sich-Kopieren" m|glich.
;
; Parameter
; r0   - Zeiger auf Source
; r1   - Zeiger auf Dest
; r2L  - Anzahl der zu durchsuchenden Bytes
;        Achtung r2L > 0 !!!
;
; Destroys
; y,a

FormString:
	ldy	#$00
@10:	cpy	r2L
	beq	@20
	lda	(r0),y
	cmp	#$a0
	beq	@30
	sta	(r1),y
	iny
	bne	@10
@20:	dey
@30:	lda	#$00
	sta	(r1),y
	rts

; MoveFileInDir
; schiebt ein File (auch Directory) in ein Verzeichnis
;
; Parameter
; r6   - Zeiger auf Filenamen
; r10L - Nummer des Dest-Dirs
;
;
; Returns
; x = 0 No Error
; r1   - Track und Sector des Directoryblocks der den 
;        Fileeintrag enth{lt
; r5   - Zeiger auf den Directoryeintrag
;        ohne (!) Dir-Ebene
;
; Destroys
; a,y,r4,r6
;

MoveFileInDir:
	jsr	FindFile
	txa
	bne	@1000
	CmpWI	r5,diskBlkBuf+2
	bne	@10
	ldy	#30
	bne	@20
@10:	DecW	r5
	ldy	#0
	jsr	@20
	IncW	r5
@1000:	rts
@20:	lda	r10L
	sta	(r5),y
	LoadW___	r4,diskBlkBuf
	jmp	PutBlock

ChangeC:	ldx	#10
; ChangeDrive	; tauscht Drive a gegen x
	; Par:	a,x    - DriveNummer (8,9,10,11)
	; Bem:	mind. 1. RAM-Disk bei 4 Laufwerken
ChangeDrive:	sta	@a
	stx	@x
	lda	numDrives
	cmp	#4
	bcs	@10
	LoadB	@y,11
	bne	@20
@10:	ldy	#0
@loop:	lda	driveType,y
	and	#%11000000
	cmp	#%10000000
	beq	@habneRam
	iny
	cpy	#3
	bne	@loop
	rts	; kein Tausch
@habneRam:	tya
	clc
	adc	#8
	tay
	sty	@y
	cpy	@x
	bne	@15	; falls :x die gefundene Ram ist,
	lda	@a	; :a mit :x tauschen
	sta	@x
	sty	@a
@15:	tya		; RAM-Disk vor}bergehend inaktivieren
	jsr	SetDevice
	jsr	i_MoveData	; RAM-Driver merken
	.word	$9000,$7ff0-$d80,$d80	
	ldy	curDrive
	lda	driveType-8,y
	sta	@ramdrivetyp
	lda	#0
	sta	driveType-8,y
	lda	ramBase-8,y
	sta	@rambase
	lda	#0
	sta	ramBase-8,y
	ldx	@x
@20:	txa
	jsr	SetDevice
	lda	@y
	jsr	Change
	lda	@a
	cmp	@y
	bne	@25
	ldy	@x
	bpl	@50
@25:	lda	@a
	jsr	SetDevice
	lda	@x
	jsr	Change
	lda	@y
	jsr	SetDevice
	lda	@a
	jsr	Change
	ldy	@y
@50:	lda	@ramdrivetyp
	sta	driveType-8,y
	lda	@rambase
	sta	ramBase-8,y
	lda	DriverHigh-8,y
	sta	r1H
	lda	DriverLow-8,y
	sta	r1L
	LoadW___	r0,$7ff0-$d80
	LoadW___	r2,$0d80
	LoadB	r3L,0
	jsr	StashRAM
	lda	sysRAMFlg
	and	#%00100000
	beq	@60
	lda	#8
	jsr	SetDevice
	LoadW___	r0,$8400
	LoadW___	r1,$7900
	LoadW___	r2,$500
	LoadB	r3L,0
	jsr	StashRAM
@60:	rts
@a:	.byte	0
@x:	.byte	0
@y:	.byte	0
@ramdrivetyp:	.byte	0
@rambase:	.byte	0
Change:	pha
	tay
	lda	DriverHigh-8,y
	sta	r1H
	lda	DriverLow-8,y
	sta	r1L
	LoadW___	r0,$9000
	LoadW___	r2,$0d80
	LoadB	r3L,0
	jsr	StashRAM
	pla
	sta	r0L
	lda	curDrive

	pha
	tay
	lda	ramBase-8,y
	pha
	lda	driveType-8,y
	pha
	bpl	@NoRAM
	lda	r0L
	jsr	SetDevice

	ldy	curDrive
	lda	driveType,y	
	sta	curType
	
	jmp	@RAM
@NoRAM:	
    lda	r0L
	jsr	ChangeDiskDevice
@RAM:	ldy	curDrive
	pla
	sta	driveType-8,y
;XXX	sta	curType
	pla
	sta	ramBase-8,y
	pla
	tay
	lda	#$00
	sta	ramBase-8,y
	sta	driveType-8,y
	rts

DriverHigh:	.byte	$83,$90,$9e,$ab
DriverLow:	.byte	$00,$80,$00,$80

; SubDirNrInList
; holt die Unterverzeichnisnummer
; schreibt Verzeichnis in SubDir-Tabelle
; Nur auf Unterverzeichnisse anwenden !!
;
; Parameter
; r0   - Zeiger auf die SubDir-Tabelle
; r6   - Zeiger auf den Filenamen
;
; Returns
; x = 0  No_Error
;        REKURSIV
;        NO_DIR_FREE
;        sonst x-Fehler durch 
;        - FindFile
;        - GetBlock
; r10L - Verzeichnisnummer (undefiniert, wenn Fehler!)
; y    - Schachteltiefe
; Destroys
; a
; r1,r4,r6,
;
; Description
; ]blicherweise }bergibt man in r0 einen
; Zeiger auf SubDirxList (x=1,2,3,4)
;

SubDirNrInList:
	jsr	GetSubDirNr
	txa
	bne	@error
	ldy	#$00
@1:	lda	(r0),y
	bmi	@10
	cmp	r10L	; rekursiv
	bne	@20
	ldx	#REKURSIV
@error:	rts

@20:	iny
	cpy	#63
	bne	@1
	ldx	#NO_DIR_FREE
	rts

@10:	lda	r10L
	sta	(r0),y
	rts

; UpperDir
; holt das dem aktuellen Directory vorangehende
; Directory und l|scht gleichzeitig den
; letzten Eintrag in der SubDirxList
;
; Parameter
; r0   - Zeiger auf Directory-Liste (SubDirxList)
;
; Returns
; r10L - Nummer des neuen Verzeichnisses
; a    - wie r10L
;
; Destroys
; y

UpperDir:
	ldy	#63
@10:	lda	(r0),y
	bpl	@20
	dey
	bne	@10
	lda	#$00
	sta	(r0),y
	jmp	@1000

@20:	lda	#$ff
	sta	(r0),y
	dey
	lda	(r0),y
@1000:	
	sta	r10L
	rts

; ClearList
; l|scht SubDirxList
; setzt Verzeichnisebene Main (0)
;
; Parameter
; r0   - Zeiger auf SubDirxList
;
; Destroys
; a,y

ClearList:
	ldy	#63
	lda	#$ff
@10:	sta	(r0),y
	dey
	bne	@10
	lda	#$00
	sta	(r0),y
	rts

; GetSubDirNr
; holt die Unterverzeichnisnummer
;
; Parameter
; r6   - Zeiger auf den Filenamen
;
; Returns
; x = 0  No_Error
; r10L - Verzeichnisnummer (undefiniert, wenn Fehler!)
; 
; Destroys
; a,y
; r1,r4,r6,
;

GetSubDirNr:
	jsr	GetInfoBlock
	MoveB	diskBlkBuf+OFF_DIR_NUM,r10L
	rts

; GetInfoBlock
; holt InfoBlock
;
; Parameter
; r6   - Zeiger auf den Filenamen
;
; Returns
; x = 0  No_Error
;
; Destroys
; a,y
; r1,r4,r6,
;

GetInfoBlock:
	jsr	FindFile
	txa
	bne	GetErr
GetInfo:
	ldy	#19
	lda	(r5),y
	sta	r1L
	iny
	lda	(r5),y
	sta	r1H
	LoadW___	r4,diskBlkBuf
	jsr	GetBlock
GetErr:	rts

; SetNumDrives	setzt die Anzahl der verf}gbaren Laufwerke
; Parameter	keine
; Alters	numDrives
; Uses: 	GetMaxDrives (s.u.)
; Destroys	 a,x,y

SetNumDrives:
	jsr	GetMaxDrives
	sta	numDrives
	rts
	
; GetMaxDrives
; Parameter - keine
; R}ckgabewert
; a - Anzahl der verf}gbaren Drives
GetMaxDrives:	ldy	numDrives
	cpy	#2
	bge	@10
	lda	curDrive
	eor	#1	; aus 8 mach 9 und umgekehrt
	tax
	lda	driveType-8,x
	beq	@05
	iny
@05:	tya
	rts
@10:	ldy	#2
	bit	sysRAMFlg
	bvs	@20
	lda	driveType
	cmp	driveType+2	; C
	bne	@30
	iny
	cmp	driveType+3	; D
	bne	@30
	iny
@30:	tya
	rts
@20:	lda	driveType+2
	beq	@30
	iny
	lda	driveType+3
	beq	@30
	iny
	bne	@30
	rts
	
TestNumDrives:
	lda	DiskDriverFlag
	beq	@10
	LoadB	numDrives,1
	rts
@10:	LoadB	numDrives,2
	rts

; NewGetFile
; Parameter
; r6   - Filename
; r0   - Zeiger auf SubDirxList
; r1L  - PrintFlag (negativ = Drucken!)
; Returns
; x = 0 No_Error (DA,Printer,Input)
; x = SUB_DIR, UNDEFINED_CLASS,NOT_PRINTING_FILE
; r10L  - bei SubDirs Nummer
; FileClassNr enth{lt die Class auch
; wenn x = UNDEFINED_CLASS
; Destroys
; a,y
; r1,r4,r6,r0,r15,r0-r15
NewGetFile:
	MoveB	r1L,XPrintFlag
	MoveW_	r6,r15
	jsr	FindFile
	txa
	bne	XError
	ldy	dirEntryBuf+22
	sty	FileClassNr
	cpy	#16
	bcc	X50
;	ldy	#15
;X10:	sty	FileClassNr
;	cpy	dirEntryBuf+22
;	beq	X50
;	dey
;	bpl	X10
;	lda	dirEntryBuf+22
;	sta	FileClassNr
	ldx	#UNDEFINED_CLASS
XError:	rts
X50:	bit	XPrintFlag
	bpl	X60
	cpy	#APPL_DATA
	beq	X60
	ldx	#NOT_PRINTING_FILE
	rts
X60:	ldx	XJumpTabHi,y
	lda	XJumpTabLo,y
	jmp	CallRoutine
XJumpTabHi:
	.byte	>XOld,>XBasic,>XAssembly,>XData
	.byte	>XSystem,>XDAcc,>XAppl,>XDocument
	.byte	>XFont,>XPrinter,>XInput64,>XSubDir
	.byte	>XStart,>XSwap,>XAutoExec,>XInput128
XJumpTabLo:
	.byte	<XOld,<XBasic,<XAssembly,<XData
	.byte	<XSystem,<XDAcc,<XAppl,<XDocument
	.byte	<XFont,<XPrinter,<XInput64,<XSubDir
	.byte	<XStart,<XSwap,<XAutoExec,<XInput128

XOld:
XBasic:
XData:
XFont:
XSystem:
XStart:
XSwap:
XDispErr:	jsr	MaxTextWin
	LoadW___	r0,XErrorDial
	jsr	NewDoDlgBox
	rts
	
XErrorDial:
	.byte	$81
	.byte	OK
	.byte	16,76
	.byte	DBTXTSTR,$10,$10
	.word	XErrZeile1
	.byte	DBVARSTR,70,$10,r15
	.byte	DBTXTSTR,$10,$20
	.word	XErrZeile2
	.byte	DBTXTSTR,$10,$30
	.word	XErrZeile3
	.byte	NULL
XErrZeile1:	.byte	BOLDON,"Die Datei",0
XErrZeile2:	.byte	"kann von TopDesk aus ",0
XErrZeile3:	.byte	"nicht ge|ffnet werden",PLAINTEXT,0

XDAcc:	jmp	DA0
XAssembly:
XAutoExec:
XAppl:	lda	curDrive
	cmp	#10
	bcc	XAppl2
	lda	AutoSwapFlag
	cmp	#$20
	beq	XError2
	ldx	#8
	lda	curDrive
	jsr	ChangeDrive
	lda	#8
	jsr	SetDevice
XAppl2:	jsr	TestNumDrives
	jmp	DA0
XError1:	rts
XError2:	ldx	#16
	rts
XSubDir:	MoveW_	r15,r6
	jsr	SubDirNrInList
	txa
	bne	XError1
	ldx	#SUB_DIR
	rts
	
XInput64:	lda	c128Flag
	bpl	XPrinter
	jmp	XDispErr
XInput128:	lda	c128Flag
	bmi	XPrinter
	jmp	XDispErr
XPrinter:	jmp	InstallDriver

XDocument:	lda	curDrive
	cmp	#10
	bcc	Xw
	lda	AutoSwapFlag
	cmp	#$2a
	beq	Xw
	jmp	XError2
Xw:	jsr	GetInfo
	ldx	#r0L
	jsr	GetPtrCurDkNm
	LoadW___	r1,DiskNm
	LoadW___	r2,18
	jsr	MoveData
	jsr	i_MoveData
	.word	diskBlkBuf+$75,SearchOrgClass,13
	lda	SearchOrgClass
	bne	Xne
	jmp	XDispErr
Xne:	lda	curDrive
	sta	XMycurDrive
	lda	ramExpSize
	beq	XDoc12
;	bit	ChangeDiskFlag
;	bvc	XDoc12
	ldy	#8
XDoc11:	lda	driveType-8,y
	bmi	XDoc10
XDoc11a:	iny
	cpy	#12
	bne	XDoc11
	beq	Xs90
XDoc10:	tya
	pha
	jsr	XSearchDrive
	pla
	tay
	lda	r7H
	bne	XDoc11a
	jmp	XApplLoad10
Xs90:	lda	XMycurDrive
	jsr	NewSetDevice
XDoc12:	jsr	XSearchAppl
	lda	r7H
	beq	XDoc12a
	ldy	#8
Xs92:	lda	driveType-8,y
	beq	Xs93
	bmi	Xs93
	cmp	XMycurDrive
	bne	XDoc10a
Xs93:	iny
	cpy	#12
	bne	Xs92
	jmp	XDocErr
XDoc10a:	tya
	pha
	jsr	XSearchDrive
	pla
	tay
	lda	r7H
	bne	Xs93
	jmp	XApplLoad10
XDoc12a:	lda	numDrives
	cmp	#3
	bcc	XApplLoad
	jmp	XApplLoad11

XApplLoad:	LoadW___	r6,SearchName
	jsr	FindFile
	jsr	TestGraphMode
	txa
	beq	Xs60
	rts
Xs60:	LoadW___	r6,SearchName
	bit	XPrintFlag
	bpl	XApplLoad_1
	LoadB	r0L,%11000000
	jmp	XApplLoad_2
XApplLoad_1:	LoadB	r0L,$80
XApplLoad_2:
	LoadW___	r2,DiskNm
	MoveW_	r15,r3
	jsr	StashMain
	jsr	TestTopDesk
	bcc	Xtd10
	ldx	#18
	rts
Xtd10:	jsr	TestNumDrives
	lda	#$c2
	pha
	lda	#$2b
	pha		; im Fehlerfalle direkt nach $c22c einspringen
	jsr	CLS
	jmp	GetFile
XSearchAppl:	LoadW___	r6,SearchName
	LoadW___	r10,SearchOrgClass
	LoadB	r7H,1
	LoadB	r7L,APPLICATION
	jsr	FindFTypes
	rts
XApplLoad10:	lda	numDrives
	cmp	#3
	bcs	Xw10
	jmp	XApplLoad0
Xw10:	lda	curDrive
	cmp	XMycurDrive
	beq	XApplLoad11
	cmp	#10
	bcc	XApplLoad0
	bcs	XApplLoad1x
XApplLoad11:
	lda	curDrive
	cmp	#10
	bcc	Xl10
	ldx	#8
	jsr	ChangeDrive
	lda	#8
	jsr	SetDevice
Xl10:	jmp	XApplLoad
XApplLoad1x:	lda	XMycurDrive
	cmp	#10
	bcs	Xs39
	jmp	XApplLoad1
Xs39:	lda	AutoSwapFlag
	cmp	#$2a
	beq	Xs40
	jmp	XError2
Xs40:	lda	curDrive
	pha
	lda	#10
	ldx	#8
	jsr	ChangeDrive
	lda	#11
	ldx	#9
	jsr	ChangeDrive
	pla
	and	#%11111101
	jsr	SetDevice
	jmp	XApplLoad

XDocErr:	MoveB	curDrive,XMycurDrive
	lda	numDrives
	cmp	#1
	beq	XDocErr1
	lda	#8
	jsr	XSearchDrive		
	lda	r7H
	beq	XApplLoad0
	lda	#9
	jsr	XSearchDrive		
	lda	r7H
	beq	XApplLoad0
	lda	#10
	jsr	XSearchDrive
	lda	r7H
	beq	XApplLoad1
XDocErr1:	rts
XApplLoad0:	lda	XMycurDrive
	cmp	#10
	bcs	XApplLoad2
	jmp	XApplLoad
XApplLoad2:	lda	AutoSwapFlag
	cmp	#$20
	beq	Xs15
	lda	#8
	cmp	curDrive
	bne	XApplLoad3
	lda	curDrive
	pha
	lda	#9
XApplLoad4:	ldx	XMycurDrive
	jsr	ChangeDrive
	jsr	OpenDisk
	pla
	jsr	NewSetDevice
	jmp	XApplLoad
XApplLoad3:	lda	curDrive
	pha
	lda	#8
	bne	XApplLoad4
XApplLoad1:	lda	AutoSwapFlag
	cmp	#$2a
	beq	Xs20
Xs15:	jmp	XError2
Xs20:	lda	XMycurDrive
	cmp	#8
	bne	XApplLoad5
	lda	#9
	bne	XApplLoad6
XApplLoad5:	lda	#8
XApplLoad6:	pha
	ldx	curDrive
	jsr	ChangeDrive
	pla
	jsr	SetDevice
	jmp	XApplLoad
XSearchDrive:	ldy	DiskDriverFlag
	bne	Xs10
	jsr	SetDevice
Xs10:	jsr	OpenDisk
	jsr	XSearchAppl
	rts
XMycurDrive:	.byte	0
XPrintFlag:	.byte	0

FileClassNr:	.byte	0
DiskNm:	.byte 0,0,0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0,0,0
	;s	20
SearchOrgClass:	.byte 0,0,0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0,0,0
	.byte 0,0,0
	;s	23
SearchName:	.byte 0,0,0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0,0,0
	;s	20

DA0:
	jsr	TestGraphMode
	txa
	beq	@10
	rts
@10:	MoveW_	r15,r6
	lda	#$00
	sta	r0L
	sta	r10L
	jsr	StashMain
	lda	FileClassNr
	cmp	#05
	bne	@20
	lda	c128Flag
	bpl	@19
	lda	graphMode
	bpl	@19
	jsr	CLS
@19:	jmp	DA_Call2
@20:	jsr	TestTopDesk
	bcc	@td10
	ldx	#18
	rts
@td10:	lda	#$c2
	pha
	lda	#$2b
	pha		; im Fehlerfalle direkt nach $c22c einspringen
	jsr	CLS
	jmp	GetFile
TestGraphMode:
	lda	c128Flag
	bpl	@10
	LoadW___	r9,$8400
	jsr	GetFHdrInfo
	lda	$8160
	cmp	#$80
	bne	@05
	ldx	#15
	rts
@05:	cmp	#$40
	beq	@10
;	lda	$d505
;	bmi	@05a	; 40/80-Zeichentaste gedr}ckt?
;	lda	#$c0
;	bne	@06
;@05a:	lda	#$00
@06:	cmp	#$00
	bne	@07
	lda	graphMode
	bpl	@10
@06a:	ldx	#INCOMPATIBLE
	rts
@07:	cmp	#$c0
	bne	@10
	lda	graphMode
	bpl	@06a
@10:	ldx	#0
	rts

CLS:	ldy	#r15H-r0L
@loop:	lda	r0L,y
	pha
	dey
	bpl	@loop
	jsr	@sub
	ldy	#0
@loop2:	pla
	sta	r0L,y
	iny
	cpy	#r15H-r0L+1
	bne	@loop2
	rts
@sub:	lda	#2
	jsr	SetPattern
	lda	c128Flag
	bpl	@64
	jsr	i_Rectangle
	.byte	0,199
	.word	0,319|DOUBLE_W|ADD1_W	
	rts
@64:	jsr	i_Rectangle
	.byte	0,199
	.word	0,319
	rts

ChangeDiskFlag:
	.byte	$ff

	