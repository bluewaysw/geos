; 12.8.91 Kn:	Fehler bei leeren VLIR-Files behoben (S. 3/4)
; CopyFile (20.06.1991) dient zum kopieren/duplizieren von Files
; Par:	DestinationDir: Nummer des Zieldirectories
;	Achtung: Es findet keine Abfrage statt, ob Dir vorhanden ist.
;	CopyMemLow,CopyMemHigh: freier Speicher
;	r10: Zeiger auf SourceDisk
;	r11: Zeiger auf DestinationDisk
;	r12: Zeiger auf SourceName
;	r13: Zeiger auf DestinationName
;	r10=r11 f}r Duplicate, r12=r13 f}r CopyFile
; Ret:	x: Fehlernummer
; Des:	a,y,r0-r10L,r14-r15,diskBlkBuf,fileHeader,curDirHead,fileTrScBuf,dirEntryBuf

dir3Head	=	$9c80
SearchDrive:	.byte	0	;Offset der zu suchenden Disk (s. Search_Turbo)
Flag1581:	.byte	0	;Flag, ob dir3Head gerettet werden mu~
DestinationDir:	.byte	0

CopyFile:	MoveW_	r10,r6
	jsr	SearchDisk
	txa
	beq	@01
@err:	rts
@01:	MoveW_	r12,r6
	jsr	FindFile
	txa
	bne	@err
	jsr	EnterTurbo
	jsr	InitForIO
	LoadB	r9L,0
	sta	r4L
	lda	dirEntryBuf+22
	beq	CopySeq	;=>non Geos
	MoveB	CopyMemHigh,r4H
	MoveW_	dirEntryBuf+19,r1
	jsr	ReadBlock	;InfoBlock
	txa
	bne	@errD
	lda	dirEntryBuf+21
	beq	CopySeq	;=>VLIR
	jmp	CopyVLIR
@errD:	jmp	DoneWithIO

CopySeq:	MoveB	dirEntryBuf+2,r1H
	MoveB	dirEntryBuf+1,r1L
	beq	@90	;=>keine Daten
@10:	MoveB	CopyMemLow,r4H
	LoadB	r4L,0
	jsr	ReadChain
	txa
	bne	errD
	MoveW_	r1,r15
	ldx	#r11
	jsr	Search_Turbo
	txa
	bne	@err
	lda	r9L
	bne	@80
	jsr	Get1stBlock
	txa
	bne	errD
	MoveW_	r9,dirEntryBuf+1
@80:	MoveB	CopyMemLow,r4H
	LoadB	r4L,0
	PushW	r9
	jsr	WriteChain
	PopW	r1
	txa
	bne	errD
	MoveB	CopyMemLow,r4H
	LoadB	r4L,0
	jsr	VerifyChain
	txa
	bne	errD
	lda	r15L
	bne	@60
@90:	jmp	WriteInfo
@60:	ldx	#r10
	jsr	Search_Turbo
	txa
	bne	@err
	MoveW_	r15,r1
	jmp	@10
@err:	rts
errD:	jmp	DoneWithIO

CopyVLIR:	LoadB	r2L,$ff
	MoveW_	dirEntryBuf+1,r1
	LoadW___	r4,fileTrScTab	;Index-Block
	jsr	ReadBlock	;nach
	txa		;fileTrScTab
	bne	errD
	LoadB	r15L,$ff
	MoveB	CopyMemLow,r4H
	LoadB	r4L,0
	ldy	#2	;erstes Record
	sty	r14H	;letzter Zeiger
@10:	lda	fileTrScTab,y
	sta	r1L
	iny
	sty	r14L	;aktueller Zeiger	
	ldx	fileTrScTab,y
	stx	r1H
	tay
	bne	@20	;<leeres Record
	txa
	bne	@30
	LoadB	r14L,$ff	;<letztes Record
	bne	@30
@20:	jsr	ReadChain
	txa
	bne	errD
	MoveB	r1H,r15H
	MoveB	r1L,r15L
	bne	@40
	inc	r4H
	lda	r4H
	cmp	CopyMemHigh
	bcs	@40
@30:	ldy	r14L
	iny
	bne	@10

; r9 - n{chster freier Block
; r14L - Offset in fileTrScTab (aktuell ; lesen)
; r14H - Offset in fileTrScTab (erster ; lesen)
; r15 - Track/Sektor des zuletzt gelesenen Blocks
@40:	ldx	#r11
	jsr	Search_Turbo
	txa
	beq	@45
	rts
@45:	lda	r9L
	bne	@46	; :50
	jsr	Get1stBlock
	txa
	beq	@46
	jmp	@errD2
@46:	lda	r15L
	cmp	#$ff
	bne	@50
	jmp	WriteInfo
@50:	lda	r2L
	beq	@55
@51:	ldy	r14H
	lda	fileTrScTab,y
	bne	@52
	inc	r14H
	inc	r14H
	beq	@100
	bne	@51
@52:	lda	r9L
	sta	fileTrScTab,y
	lda	r9H
	sta	fileTrScTab+1,y
@55:	PushW	r9
	PushB	r14H
	MoveB	CopyMemLow,r4H
	LoadB	r4L,0
@60:	jsr	WriteChain
	txa
	bne	@100
	ldy	#0
	lda	(r4),y
	bne	@100	;=>Buffer voll
@70:	ldy	r14H
	iny
	iny
	sty	r14H
	beq	@100	;fertig
	lda	fileTrScTab,y
	bne	@80
	lda	fileTrScTab+1,y
	beq	@100
	bne	@70
@80:	inc	r4H
	lda	r4H
	cmp	CopyMemHigh
	bcs	@100
	lda	r9L
	sta	fileTrScTab,y
	lda	r9H
	sta	fileTrScTab+1,y
	jmp	@60
@100:	PopB	r14H
	PopW	r1
	txa
	bne	@errD2

	MoveB	CopyMemLow,r4H
	LoadB	r4L,0
@110:	jsr	VerifyChain
	txa
@errD2:	bne	@errD
	ldy	#0
	lda	(r4),y
	bne	@190	;=>Buffer voll
@120:	ldy	r14H
	iny
	iny
	sty	r14H
	beq	WriteInfo	;=>fertig
	ldx	fileTrScTab+1,y
	stx	r1H
	lda	fileTrScTab,y
	sta	r1L
	bne	@130	;<leeres Record
	txa
	bne	@120
	beq	WriteInfo
@130:	inc	r4H
	lda	r4H
	cmp	CopyMemHigh
	bcc	@110
	jsr	@160
	txa
	bne	@errD
	LoadB	r2L,$ff
	ldy	r14L
	iny
	jmp	@10
@190:	jsr	@160
	txa
	bne	@errD
	stx	r2L
	MoveB	r15H,r1H
	MoveB	r15L,r1L
	jmp	@20
@160:	ldx	#r10
	jsr	Search_Turbo
	MoveB	CopyMemLow,r4H
	LoadB	r4L,0
@err:	rts
@errD:	jmp	DoneWithIO

WriteInfo:	jsr	DoneWithIO
	lda	dirEntryBuf+22
	bne	@10
	MoveW_	r9,r6
	jsr	FreeBlock
	txa
	beq	@20
@err:	rts
@10:	MoveB	r9L,r1L
	sta	dirEntryBuf+19
	MoveB	r9H,r1H
	sta	dirEntryBuf+20
	MoveB	CopyMemHigh,r4H
	LoadB	r4L,0
	jsr	PutBlock
	txa
	bne	@err
	lda	dirEntryBuf+21
	beq	@20
	MoveW_	r9,r3
	jsr	SetNextFree
	txa
	bne	@err
	MoveB	r3L,r1L
	sta	dirEntryBuf+1
	MoveB	r3H,r1H
	sta	dirEntryBuf+2
	LoadW___	r4,fileTrScTab
	jsr	PutBlock
	txa
	bne	@err
@20:	LoadB	r10L,0
	jsr	GetFreeDirBlk
	txa
@err2:	bne	@err
	tya
	pha
	ldy	#0
@30:	lda	(r13),y
	beq	@40
	sta	dirEntryBuf+3,y
	iny
	bne	@30
@40:	cpy	#16
	bcs	@50
	lda	#$a0
	sta	dirEntryBuf+3,y
	iny
	bne	@40
@50:	pla
	pha
	tay
	ldx	#0
@60:	lda	dirEntryBuf,x
	sta	diskBlkBuf,y
	iny
	inx
	cpx	#$1e
	bcc	@60

	pla
	cmp	#2
	bne	@70
	clc
	adc	#30+1
@70:	tay
	dey
	lda	DestinationDir
	sta	diskBlkBuf,y
	LoadW___	r4,diskBlkBuf
	jsr	PutBlock
	txa
	bne	@err2
	jmp	PutDirHead

;ReadChain
;Par:	r1 - Track/Sektor des ersten zu lesenden Blocks
;	r4 - Zeiger auf den freien Speicherbereich
;Ret:	x - Fehlernummer
ReadChain2:	inc	r4H
ReadChain:	jsr	ReadBlock
	txa
	bne	@err
	ldy	#1
	lda	(r4),y
	sta	r1H
	dey
	lda	(r4),y
	sta	r1L
	beq	@err
	lda	r4H
	tay
	iny
	cpy	CopyMemHigh
	bcc	ReadChain2
@err:	rts

WriteChain:
;Par:	r9 - n{chster zu schreibender Block
;	r4 - Zeiger auf die zu schreibenden Bl|cke
;Ret:	r9 - s.o.
;	r1: TrSe des n{chsten Blocks
;	r4: Zeiger auf den Speicher des zulezt geschriebenen Blocks
;	x - Fehlernummer
	lda	r9L	;n{chster Block
	sta	r3L	;als aktueller
	sta	r1L
	lda	r9H
	sta	r3H
	sta	r1H
	dec	r4H
@20:	inc	r4H
	jsr	SetNextFree	;n{chsten Block
	txa
	bne	@err
	ldy	#0
	lda	(r4),y
	beq	@10	;=>letzter Block
	lda	r3L
	sta	(r4),y
	iny
	lda	r3H
	sta	(r4),y
@10:	jsr	WriteBlock
	txa
	bne	@err
	MoveB	r3L,r1L
	sta	r9L
	MoveB	r3H,r1H
	sta	r9H
	ldy	#0
	lda	(r4),y
	beq	@err	;=>letzter Block
	lda	r4H
	tay
	iny
	cpy	CopyMemHigh
	bcc	@20
@err:	rts

;Par:	r1 - Track/Sektor des ersten zu lesenden Blocks
;	r4 - Zeiger auf den freien Speicherbereich
;Ret:	x - Fehlernummer
VerifyChain2:	inc	r4H
VerifyChain:	jsr	VerWriteBlock
	txa
	bne	@err
	ldy	#1
	lda	(r4),y
	sta	r1H
	dey
	lda	(r4),y
	sta	r1L
	beq	@30
	lda	r4H
	tay
	iny
	cpy	CopyMemHigh
	bcc	VerifyChain2
@30:	ldx	#0
@err:	rts

Get1stBlock:	ldy	#1
	sty	r3L
	dey
	sty	r3H
	jsr	SetNextFree
	MoveW_	r3,r9
	rts
	
UeberschreibenBox:	.byte	$81
	.byte	DBVARSTR,$10,$10,r13
	.byte	DBTXTSTR,$10,$20
	.word	@t1
	.byte	DBTXTSTR,$10,$30
	.word	@t2
	.byte	DBTXTSTR,$10,$40
	.word	@t3
	.byte	YES,1,72
	.byte	NO,17,72
	.byte	NULL
@t1:	.byte	BOLDON,"ist bereits vorhanden.",0
@t2:	.byte	"Soll die Datei }berschrieben",0
@t3:	.byte	"werden ?",PLAINTEXT,0

nichtUeberschreibenbox:
	.byte	$81
	.byte	DBVARSTR,$10,$10,r13
	.byte	DBTXTSTR,$10,$20
	.word	@t1
	.byte	DBTXTSTR,$10,$30
	.word	@t2
	.byte	OK,17,72
	.byte	NULL
@t1:	.byte	BOLDON,"ist bereits vorhanden",0
@t2:	.byte	"und schreibgesch}tzt.",PLAINTEXT,0

Search_Turbo:	PushB	r2L
	lda	$00,x
	sta	r6L
	lda	$01,x
	sta	r6H
	stx	SearchDrive
	lda	Flag1581
	beq	@noretdir3
	cpx	#r10L
	bne	@noretdir3
	jsr	i_MoveData
	.word	dir3Head,fileHeader,256
@noretdir3:	jsr	DoneWithIO
	jsr	NewSearchDisk
	txa
	bne	@err
	lda	r9L
	bne	@noinit
	jsr	@initsearchturbo
	txa
	beq	@nogetdir3
@err:	PopB	r2L
@err2:	rts
@noinit:	lda	Flag1581
	beq	@nogetdir3
	lda	SearchDrive
	cmp	#r11L
	bne	@nogetdir3
	jsr	i_MoveData
	.word	fileHeader,dir3Head,256
@nogetdir3:	jsr	EnterTurbo
	txa
	bne	@err
	PopB	r2L
	jmp	InitForIO

@initsearchturbo:	jsr	OpenDisk	; BAM holen
	txa	
	bne	@err2
	ldx	#0	; Flag1581 entspr. setzen
	lda	curType
	and	#DRIVE_MASK
	cmp	#3
	bne	@no1581
	ldx	#$ff
@no1581:	stx	Flag1581
	ldy	#9	; Werte retten
@10:	lda	r9L,y
	pha
	dey
	bpl	@10
	ldy	#$1d	; dirEntryBuf retten
@20:	lda	dirEntryBuf,y
	pha
	dey
	bpl	@20

	MoveB	r13L,r6L	; Zeiger auf Filenamen
	sta	fileHeader
	MoveB	r13H,r6H
	sta	fileHeader+1
	jsr	FindFile
	cpx	#5
	bne	@evtlfehler
	ldx	#0	; File existiert noch nicht
	beq	@getwerte
@evtlfehler:	txa
	bne	@getwerte
	lda	dirEntryBuf
	and	#%01000000
	beq	@nocare
	
;XXX	LoadW___	r0, nichtUeberschreibenbox
	LoadWr0	nichtUeberschreibenbox
	jsr	NewDoDlgBox
	jmp	@dberr
@nocare:	
;XXX    lda	SureFlag
;XXX	beq	@notsure
;XXX	jmp	@delete

@notsure:	
;XXX	LoadW___	r0, UeberschreibenBox
	LoadWr0	UeberschreibenBox
	jsr	NewDoDlgBox
	lda	sysDBData
	cmp	#YES
	beq	@delete
@dberr:	ldx	#$41
	bne	@getwerte
@delete:	
	MoveW_	fileHeader,r0
	jsr	DeleteFile
@getwerte:	ldy	#0	; gerettete Werte holen
@30:	pla
	sta	dirEntryBuf,y
	iny
	cpy	#$1e
	bcc	@30
	ldy	#0
@40:	pla
	sta	r9L,y
	iny
	cpy	#10
	bcc	@40
	rts
