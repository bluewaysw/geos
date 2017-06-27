.segment "OVERLAY3"

;	n	"DeskMod C"
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
	jmp	GetTime
;	jmp	Ordnen
;	jmp	_ThreeDrives

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


KEY_RIGHT	= 30
KEY_LEFT	= 8
KEY_DELETE	= 29
CR	= $0d
month	= $8517
year	= $8516
hour	= $8519
minutes	= $851a

Ordnen:	; alle selektierten Files nach vorne ins Inhaltsverzeichnis ordnen
	; 1. Dir-Track einlesen
	tsx
	stx	@sp
	jsr	GetAktlDisk
	tax
	beq	@10
@err:	txa
	ldx	@sp
	txs
	tax
	jsr	ClearMultiFile2
	cpx	#12
	beq	@05
	jmp	FehlerAusgabe
@05:	rts
@sp:	.byte	0
@10:	lda	curDirHead+189
	cmp	#$50
	beq	@11
	cmp	#$42
	bne	@12
@11:	LoadWr0	@db
	jsr	NewDoDlgBox
	ldx	#12
	bne	@err
@12:	ldx	activeWindow
	lda	aktl_Sub,x
	sta	@dir
	MoveW_	curDirHead,r1
	LoadW___	r4,DataSpace
	lda	#$fe
	pha
@loop:	jsr	GetBlock
	txa
	bne	@err
	ldy	#0
	lda	(r4),y
	pha
	sta	r1L
	lda	#0
	sta	(r4),y
	iny
	lda	(r4),y
	pha
	sta	r1H
	ldy	#$20
	lda	(r4),y
	tax
	lda	#0
	sta	(r4),y
	ldy	#1
	txa
	sta	(r4),y
	dey
	tya
	sta	(r4),y
	ldy	r4H
	iny
	cpy	CopyMemHigh
	bcc	@20
	ldx	#11
@err2:	bne	@err
@20:	sty	r4H
	lda	r1L
	bne	@loop
	lda	isGEOS
	bne	@30
	dec	r4H
	bne	@40
@30:	MoveB	curDirHead+171,r1L
	pha
	MoveB	curDirHead+172,r1H
	pha
	jsr	GetBlock
	txa
@err4:	bne	@err2
@40:	; 2. Ordnen
	ldy	#0
@loop2:	lda	MultiFileTab,y
	bmi	@50
	iny
	bne	@loop2
@50:	cpy	#0
	beq	@65
	dey
@loop3:	lda	MultiFileTab,y
	sta	r5H
	lda	#$ff
	sta	MultiFileTab,y
	sty	r5L
	lda	r5H
	jsr	@sub
	ldy	#0
@loop4:	lda	MultiFileTab,y
	bmi	@63
	cmp	r5H
	bcs	@60
	clc
	adc	#1
	sta	MultiFileTab,y
@60:	iny
	bne	@loop4
@63:	ldy	r5L
	dey
	cpy	#$ff
	bne	@loop3
	; 3. Dir-Track wieder schreiben
@65:	lda	isGEOS	; Borderblock
	bpl	@71
	pla
	sta	r1H
	pla
	sta	r1L
	; r4 ist noch gesetzt
	jsr	PutBlock
	txa
@err3:	bne	@err4
	dec	r4H
@71:	ldy	#1
	lda	(r4),y
	ldy	#$20
	sta	(r4),y
	ldy	#1
	pla	
	sta	(r4),y
	pla
	dey
	sta	(r4),y	; $00,$ff Setktorverkettung des letzten DirBlks
@loop5:	dec	r4H
	pla
	cmp	#$fe
	bne	@75
	inc	r4H
	MoveW_	curDirHead,r1
	jsr	PutBlock
	txa
	bne	@err3
	beq	@end
@75:	pha
	ldy	#1
	lda	(r4),y
	ldy	#$20
	sta	(r4),y
	ldy	#1
	pla
	sta	r1H
	sta	(r4),y
	dey
	pla
	sta	r1L
	sta	(r4),y
	inc	r4H
	jsr	PutBlock
	dec	r4H
	txa
	bne	@err3
	beq	@loop5
@end:	jsr	ClearMultiFile
	jmp	ReloadActiveWindow
@dir:	.byte	0
@sub:	; File Nr. a des Ordners :dir ordnen
	tax
	inx
	LoadW___	r0,DataSpace
@sloop:	ldy	#02
	lda	(r0),y
	bne	@s04
	dey
	lda	#0
	sta	(r0),y	; bei gel|schten Files 0 als DirNum schreiben
	beq	@s05	; und nicht mitz{hlen
@s04:	dey
	lda	(r0),y
	cmp	@dir
	bne	@s05
	dex
	beq	@habs
@s05:	AddvW	$20,r0
	jmp	@sloop
@habs:	LoadW___	r1,$8000
	LoadW___	r2,$20
	jsr	MoveData	; zu ordnenden Fileeintrag merken
	lda	r0L
	sec
	sbc	#<DataSpace
	sta	r2L
	lda	r0H
	sbc	#>DataSpace
	sta	r2H
	LoadB	r0L,<DataSpace
	clc
	adc	#$20
	sta	r1L
	LoadB	r0H,>DataSpace
	adc	#0
	sta	r1H
	jsr	MoveData
	jsr	i_MoveData
	.word	$8000,DataSpace,32
	rts
@db:	.byte	$81
	.byte	$0b,$10,$10
	.word	@t1
	.byte	$0b,$10,$20
	.word	@t2
	.byte	$0b,$10,$30
	.word	@t3
	.byte	OK,17,72,NULL
@t1:	.byte	"Diese Operation darf nicht auf",0
@t2:	.byte	"System- oder Hauptdisketten",0
@t3:	.byte	"angewendet werden.",0
GetTime:	LoadB	ModDepth,1
	jsr	StopClock
	jsr	MouseOff
	ldx	#1
	jsr	BlockProcess
	MoveW_	keyVector,Oldkey
	LoadW___	keyVector,Mykey
	LoadB	Obergrenze,$33
	ldx	#0
	stx	TabZeiger
	LoadB	TagZehner-1,REV_ON
	jsr	ShowClock
@20:	rts
Oldkey:	.word	0
; Mykey
Mykey:	lda	keyData
	cmp	Obergrenze
	bgt	@5
	cmp	#$30
	blt	@5
	pha
	jsr	SetPlain
	pla
	sta	TagZehner,x
	jmp	@7
@5:	cmp	#KEY_RIGHT
	bne	@10
	jsr	SetPlain
@7:	iny
	cpy	#10
	bne	@15
	ldy	#0
@15:	jmp	SetRev
@10:	cmp	#KEY_DELETE
	beq	@11
	cmp	#KEY_LEFT
	bne	@100
@11:	jsr	SetPlain
	dey
	bpl	@25
	ldy	#9
@25:	jmp	SetRev
@100:	cmp	#CR
	bne	@1000
	jsr	SetPlain
	jsr	TestTime
	beq	@120
	tya
	pha
	lda	#2
	jsr	Beep
	pla
	tay
	jmp	SetRev	
@120:	jsr	RunClock
	jsr	ShowClock
	jsr	MouseUp
	ldx	#1
	jsr	UnblockProcess
	MoveW_	Oldkey,keyVector
	LoadB	ModDepth,0
@1000:	rts
DPA	= $dc00
ampm:	.byte	0

SetTime:
	jsr	InitForIO
	lda	TagZehner
	ldx	TagEiner
	jsr	ASCDEZ
	sta	day
	lda	MonZehner
	ldx	MonEiner
	jsr	ASCDEZ
	sta	month
	lda	JahZehner
	ldx	JahEiner
	jsr	ASCDEZ
	sta	year
	LoadB	ampm,0
	lda	StdZehner
	ldx	StdEiner
	jsr	ASCDEZ
	cmp	#24
	bne	@ci
	lda	#0
@ci:	sta	hour
	cmp	#12
	blt	@am
	pha
	LoadB	ampm,$80
	pla
	sec
	sbc	#12
@am:	jsr	DezBCD
	clc
	adc	ampm
	sta	DPA+$0b

	lda	MinZehner
	ldx	MinEiner
	jsr	ASCDEZ
	sta	minutes
	jsr	DezBCD
	sta	DPA+$0a
	rts
RunClock:
	jsr	SetTime
	lda	#$00
	sta	DPA+$09
	sta	DPA+$08
	jsr	DoneWithIO
	rts
	

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

ObTab:	.byte	$33,$39,$31,$39
	.byte	$39,$39,$32,$39,$35,$39


;ASCDEZ
; a High
; x Low
; Return a

ASCDEZ:
	sec
	sbc	#$30
	sta	@Dings
	asl
	asl
	asl
	clc
	adc	@Dings
	adc	@Dings
	sta	@Dings
	txa
	sec
	sbc	#$30
	clc
	adc	@Dings
	rts

@Dings:	.byte	0
StopClock:
	jsr	InitForIO
	LoadB	ampm,0
	lda	hour
	cmp	#12
	blt	@am
	LoadB	ampm,$80
	lda	hour
	sec
	sbc	#12
@am:
	jsr	DezBCD
	clc
	adc	ampm
	sta	DPA+$0b
	jsr	DoneWithIO
	rts

DezBCD:
	sta	r0L
	LoadB	r0H,0
	ldx	#r0L
	LoadW___	r1,10
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
; TestTime
; ]berpr}fung
; return
; a = 0 OK
; a = $ff false; y Wert f}r TabZeiger

TestTime:
	lda	day
	bne	@10
	ldy	#1
@00:
	lda	#$ff
	rts
@10:	cmp	#32
	blt	@05
	ldy	#0
	beq	@00

@05:	lda	month
	bne	@20
@31:	ldy	#3
	bne	@00
@20:	cmp	#13
	blt	@30
	ldy	#2
	bne	@00
@30:	cmp	#2	; Feb
	bne	@40
	lda	day
	cmp	#29
	beq	@35
	bgt	@31
	jmp	@th
@35:	lda	year
	ror		; /2
	bcc	@32
@33:	ldy	#1
	jmp	@00
@32:	ror		; /4
	bcs	@33
	jmp	@th
@40:	cmp	#8
	bge	@45
	ror
	bcc	@42
@43:	jmp	@th	; ungerade
@42:	lda	day
	cmp	#31
	bne	@43
	ldy	#1
	jmp	@00
@45:	ror
	bcs	@42
@th:	clc
	lda	hour
	cmp	#24
	bge	@th1
	lda	#$00
	rts
@th1:	ldy	#6
	jmp	@00
; Beep
; a - Anzahl Beep
Beep:	sta	@AnzBeep
	jsr	InitForIO
	lda #$0f
	sta $d418
	lda #$00
	sta $d405
	lda #$f7
	sta $d406
	lda #$11
	sta $d404
	lda #$32
	sta $d401
	lda #$00
	sta $d400
@10:	lda	#$0f
	sta	$d418
	jsr	@Wait
	lda #$00
	sta $d418
	jsr	@Wait
	dec	@AnzBeep
	bne	@10
	lda #$10
	sta $d404
	lda #$00
	sta $d418
	jsr	DoneWithIO
	rts
@Wait:	ldy #$80
@loop1:	ldx #$ff
@loop2:	dex
	bne @loop2
	dey
	bne @loop1
	rts
@AnzBeep:	.byte	2
TabZeiger:
	.byte	0
RevTab:
	.byte	0,2,6,8,12,14
	.byte	23,25,29,31
OldmouseOn:
	.byte	0
Obergrenze:
	.byte	"3"
.if 0
; kann in DiskDriver Lfwk 2 No Ram Disk
ThreeDrives:
	rts
	jsr	GetAktlDisk
	PushW	r15
	jsr	:Appl2
	PopW	r15
	rts
@Appl2:	bit	ChangeDiskFlag
	bmi	@Appl10
	rts

@Appl10:	ldy	curDrive
	lda	@DrDialTabLo-8,y
	sta	@Appl3
	lda	@DrDialTabHi-8,y
	sta	@Appl3+1
	lda	@DrDialCountTabLo-8,y
	sta	@Appl4
	lda	@DrDialCountTabHi-8,y
	sta	@Appl4+1
	jsr	i_MoveData
@Appl3:	.word	0
	.word	@V1
@Appl4:	.word	0
	lda	curDrive
;	sta	@MycurDrive
	cmp	#10
	bne	@Appl5
	ora	#$80
@Appl5:	sta	@MycurDrive
	lda	curDrive
	clc
	adc	#$41-8
	sta	@Zeile2_1
	LoadW___	r0,DrACurDkNm
	LoadW___	r1,@DrANm
	LoadB	r2L,17
	jsr	FormString
	LoadW___	r0,DrBCurDkNm
	LoadW___	r1,@DrBNm
	jsr	FormString
	LoadW___	r0,DrCCurDkNm
	LoadW___	r1,@DrCNm
	jsr	FormString

	LoadW___	r0,@ChangeDial
	jsr	NewDoDlgBox
	lda	r0L
	cmp	#YES	; A <-> C
	bne	@Appl1
	lda	#8
	jsr	ChangeC
	jmp	@Appl7
@Appl1:	cmp	#DISK	; B <-> C
	bne	@Appl6
	lda	#9
	jsr	ChangeC
@Appl7:	jsr	OpenDisk
	lda	@MycurDrive
	bmi	@DA	; Drive C ausgetauscht
	bpl	@DA1
@Appl6:	lda	@MycurDrive
	bpl	@DA1
	and	#%01111111
@DA1:	sta	@MycurDrive
@DA:	lda	@MycurDrive
	jsr	SetDevice
	jsr	OpenDisk
	rts
@DrDialTabLo:
	.byte	<@ChBC,<@ChAC,<@ChAC
@DrDialTabHi:
	.byte	>@ChBC,>@ChAC,>@ChAC
@DrDialCountTabLo:
	.byte	<(@V2-@V1),<(@V2-@V1),<(@V3-@V1)
@DrDialCountTabHi:
	.byte	>(@V2-@V1),>(@V2-@V1),>(@V3-@V1)

@MycurDrive:
	.byte	0

@ChangeDial:
	.byte	$81
	.byte	DBTXTSTR
	.byte	4,10
	.word	@Zeile1
	.byte	DBVARSTR
	.byte	55,10
	.byte	r15
	.byte	DBTXTSTR
	.byte	4,22
	.word	@Zeile2
	.byte	DBTXTSTR
	.byte	4,34
	.word	@Zeile3
	.byte	NO
	.byte	1,76
	.byte	DBTXTSTR
	.byte	60,50
	.word	@Zeile4
	.byte	DBTXTSTR
	.byte	60,68
	.word	@Zeile5
	.byte	DBTXTSTR
	.byte	60,86
	.word	@Zeile6
@V1:	.byte	DBUSRICON
	.byte	1,40
	.word	@IconACTab
@V2	.byte	NULL
	.byte	DBUSRICON
	.byte	1,58
	.word	@IconBCTab
@V3:	.byte	NULL
	.byte	NULL

@Zeile1:	.byte	"Programm: ",0
@Zeile2:	.byte	"wurde von Drive "
@Zeile2_1:	.byte	"C gestartet!",0
@Zeile3:	.byte	BOLDON,"Tauschen ?",PLAINTEXT,0
@Zeile4:	.byte	"A:"
@DrANm:	.byte	"                 "
@Zeile5:	.byte	"B:"
@DrBNm:		.byte	"                 "
@Zeile6:	.byte	"C:"
@DrCNm:	.byte	"                 "

@ChAC:	.byte	DBUSRICON
	.byte	1,40
	.word	@IconACTab
@ChBC:	.byte	DBUSRICON
	.byte	1,58
	.word	@IconBCTab
@ChCC:	.byte	0
@IconACTab:
	.word	@IconAC
	.word	0
	.byte	6
	.byte	16
	.word	@IconACRout
@IconBCTab:
	.word	@IconBC
	.word	0
	.byte	6
	.byte	16
	.word	@IconBCRout

@IconAC:

@IconBC:

@IconACRout:
	lda	#YES
@ICgem:	sta	sysDBData
	jmp	RstrFrmDialog
@IconBCRout:
	lda	#DISK
	bne	@ICgem

.endif
DataSpace:
