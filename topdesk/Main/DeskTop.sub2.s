.segment "OVERLAY2"

;	n	"DeskMod B"
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

SubDir2List	= SubDir1List + 64
SubDir3List	= SubDir2List + 64
SubDir4List	= SubDir3List+ 64
MultiFileTab	= SubDir4List+64
Name	= MultiFileTab + 145
DiskName	= Name + 19
Name2	= DiskName + 19

;	jmp	SelectPage
	nop
	nop
	nop
	jmp	EmptyAllDirs
	jmp	DispInfo
	jmp	Rename
	jmp	Duplicate
;	jmp	SelectAll
DispInfo:	LoadW___	r0,@db
	jmp	NewDoDlgBox
@db:	.byte	$01
.ifdef topdesk128
;	.word	54+DOUBLE_W,265+DOUBLE_W
;	.word	54,265
	;ByteCY	54, 32
	;ByteCY	265, 138
	;WordCX	54, 32
	;WordCX	265, 138
	ByteCY	%101100000000 | ((-(13*8)) & $FF), %101100000000 | ((-8*8) & $FF)
	ByteCY	%101100000000 | (((13*8)-1) & $FF), %101100000000 | (((5*8)-1) & $FF)
	WordCX 	%101100000000 | ((-(13*8)) & $FF), %101100000000 | ((-(8*8)) & $FF)
	WordCX	%101100000000 | (((13*8)-1) & $FF), %101100000000 | (((5*8)-1) & $FF)

.else
	.byte	32,138
	.word	54,265
.endif
	.byte	$0b,$10,$10
	.word	@t1
	.byte	$0b,$10,$20
	.word	@t2
	.byte	$0b,$10,$30
	.word	@t3
	.byte	$0b,$10,$30+10
	.word	@t4
	.byte	$0b,$10,$30+20
	.word	@t5
	.byte	$0b,$0a,$5e
	.word	@t7
	.byte	$0e,NULL
.ifdef lang_de
@t1:	.byte	BOLDON,"TopDesk",PLAINTEXT," Version 6.0",0
@t2:	.byte	"geschrieben von",BOLDON,0
@t3:	.byte	"Walter Knupe",0
@t4:	.byte	"H.J. Ciprina",0
@t5:	.byte	"Volker Goehrke",PLAINTEXT,0
@t7:	.byte	"(C) 1991 by GEOS-USER-CLUB, GbR",0
.else
@t1:	.byte	BOLDON,"TopDesk",PLAINTEXT," Version 6.0",0
@t2:	.byte	"written by",BOLDON,0
@t3:	.byte	"Walter Knupe",0
@t4:	.byte	"H.J. Ciprina",0
@t5:	.byte	"Volker Goehrke",PLAINTEXT,0
@t7:	.byte	"(C) 1991 by GEOS-USER-CLUB, GbR",0
.endif

EmptyAllDirs:	rts
.if 0
	jsr	GotoFirstMenu
	jsr	GetAktlDisk
@05:	lda	curDirHead
	bne	@10
	jsr	GetDirHead
	jmp	ReLoadAll
@10:	sta	r1L
	MoveB	curDirHead+1,r1H
	LoadW___	r4,$8000
	jsr	GetBlock
	lda	#00
	sta	$8020
	ldy	#$21
@20:	lda	#00
	sta	$8000,y
	tya
	clc
	adc	#$20
	bcs	@30
	tay
	bne	@20
@30:	jsr	PutBlock
	MoveW_	$8000,curDirHead
	jmp	@05
.endif
RenameFlag:	.byte	0
Duplicate:	ldx	MultiCount
	dex
	bpl	@geht
	rts
@geht:	lda	#$ff
	bne	RenameDupl
Rename:	ldx	MultiCount
	dex
	bpl	@geht
	rts
@geht:	lda	#0
RenameDupl:	sta	RenameFlag
	jsr	GetAktlDisk
	tax
	beq	@05
	jsr	ClearMultiFile2
	cpx	#12
	beq	@15
	jmp	FehlerAusgabe
@05:	LoadW___	r2,MultiFileTab
@10:	jsr	GetMark
	tax
	bmi	@20
	jsr	GetFileName
	jsr	MyRename
	bcc	@10
@15:	rts
@20:	LoadB	DialBoxFlag,0
	jmp	RecoverActiveWindow

MyRename:	lda	RenameFlag
	beq	@05
	LoadW___	r6,Name
	jsr	FindFile
	txa
	bne	@err
	lda	$8400+22
	cmp	#11	; Directory
	bne	@05
	ldx	#10
	bne	@err
@05:	LoadB	@t2,0
	ldy	#0
@10:	lda	Name,y
	sta	Name2,y
	beq	@20
	iny
	bne	@10
@20:	LoadB	DialBoxFlag,2
	LoadW___	a1,Name2
	LoadW___	r0,@db
	jsr	NewDoDlgBox
	lda	r0L
	cmp	#2
	bne	@22
	clc
	rts
@22:	LoadW___	r6,Name2
	jsr	FindFile
	txa
	beq	@schonda
	cpx	#5
	beq	@geht
@err:	jsr	FehlerAusgabe
	sec
	rts
@schonda:	LoadB	@t2,BOLDON
	bne	@20
@geht:	lda	RenameFlag
	beq	@25
	LoadW___	r12,Name	; Filename
	LoadW___	r10,DiskName+2	; SourceDisk (ohne 'x:')
	MoveW_	r10,r11
	LoadW___	r13,Name2	; NewFilename 
	ldx	messageBuffer+1
	lda	aktl_Sub,x
	sta	DestinationDir	; Ziel-Dir setzen
	PushB	CopyMemLow
	LoadB	CopyMemLow,<(DuplCopyMem)
	jsr	CopyFile
	PopB	CopyMemLow
	txa
	bne	@err
	clc
	rts

@25:	LoadW___	r0,Name2
	LoadW___	r6,Name
	jsr	RenameFile
	txa
	beq	@30
	jmp	@err
@30:	clc
	rts
@db:	.byte	$81
	.byte	$0b,$10,$10
	.word	@t2
	.byte	$0b,$10,$20
	.word	@t1
	.byte	$0d,$10,$35,a1,16
	.byte	$02,17,72
	.byte	NULL
.ifdef lang_de
@t1:	.byte	"Neuen Filenamen eingeben:",0
@t2:	.byte	0,"Name schon vergeben!",PLAINTEXT,0
.else
@t1:	.byte	"Enter new file name:",0
@t2:	.byte	0,"Name already in use!",PLAINTEXT,0
.endif

ModEnde:
DuplCopyMem	= >(ModEnde+$100)
