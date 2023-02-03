;letzte Modifizierungen der Routinen: 21.06.1991
dir3Head	=	$9c80
.if 0
:UndeleteFile
; Par:	r5 - Zeiger auf den Directory-Eintrag
;	     (wird aktualisiert)
; Ret:	x - Fehlernummer
; Des:	diskBlkBuf,fileTrScTab,a,y,r7,r8H,r2,r4,r1
	jsr	EnterTurbo
	txa
	beq	@05
	rts
@05:	jsr	InitForIO
	jsr	ValidateFile
	txa
	bne	@err
	ldx	#$82
	ldy	#21
	lda	(r5),y
	beq	@10
	inx
@10:	txa
	ldy	#0
	sta	(r5),y
	ldx	#0
@err:	jmp	DoneWithIO
.endif

Validate:
;Des: diskBlkBuf,fileTrScTab,curDirHead,fileHeader,ValidateBuffer,a,y,r1-r2,r4-r8
	jsr	OpenDisk
	txa
	bne	@10
	jsr	ClearBAM
	txa
	bne	@10
	jsr	EnterTurbo
	txa
	beq	@20
@10:	rts
@20:	jsr	InitForIO
	ldy	#63
	lda	#0
@15:	sta	ValidateBuffer,y
	dey
	bpl	@15
	lda	curType
	jsr	Get1stDirBlock
@70:	jsr	@ValidateDirBlock
	txa
	bne	@err
	MoveB	fileHeader+1,r1H
	MoveB	fileHeader,r1L
	bne	@70
	lda	isGEOS
	bmi	@80
	MoveB	curDirHead+172,r1H
	MoveB	curDirHead+171,r1L
	beq	@80
	jsr	@ValidateDirBlock
	txa
	beq	@80
@err:	jmp	DoneWithIO
@80:	lda	curType
	jsr	Get1stDirBlock
	jsr	@200
	txa
	bne	@err
	lda	isGEOS
	bmi	@85
	MoveB	curDirHead+172,r1H
	MoveB	curDirHead+171,r1L
	beq	@85
	jsr	@200
	txa
	bne	@err
@85:	jsr	DoneWithIO
	jmp	PutDirHead
@200:	LoadW___	r4,fileHeader
@110:	jsr	ReadBlock
	txa
	bne	@err2
	PushB	fileHeader+1
	MoveB	fileHeader+32,fileHeader+1
	lda	#2
@90:	tay
	lda	(r4),y
	beq	@100
	dey
	lda	(r4),y
	tax
	lda	ValidateBuffer,x
	bne	@95
	sta	(r4),y
@95:	iny
@100:	tya
	clc
	adc	#32
	bcc	@90
	MoveB	fileHeader+1,fileHeader+32
	PopB	fileHeader+1
	jsr	WriteBlock
	txa
	bne	@err2
	jsr	VerWriteBlock
	txa
	bne	@err2
	MoveB	fileHeader+1,r1H
	MoveB	fileHeader,r1L
	bne	@110
@err2:	rts
@ValidateDirBlock:	LoadW___	r4,fileHeader
	PushW	r1
	jsr	ReadBlock
	txa
	bne	@err3
	lda	r4L
	clc
	adc	#2
	sta	r5L
	lda	r4H
	adc	#00
	sta	r5H
@360:	ldy	#0
	lda	(r5),y
	beq	@350
	ldy	#22
	lda	(r5),y
	cmp	#11
	bne	@340
	ldy	#19
	lda	(r5),y
	sta	r1L
	iny
	lda	(r5),y
	sta	r1H
	LoadW___	r4,diskBlkBuf
	jsr	ReadBlock
	txa
	bne	@err3
	ldx	diskBlkBuf+117
	inc	ValidateBuffer,x
@340:	jsr	ValidateFile
	txa
	bne	@err3
@350:	lda	r5L
	clc
	adc	#32
	sta	r5L
	bcc	@360
	PopW	r1
	LoadW___	r4,fileHeader
	jsr	WriteBlock
	txa
	bne	@err4
	jmp	VerWriteBlock
@err3:	PopW	r1
@err4:	rts
; ClearBAM
; l|scht alle Bl|cke in der BAM
; Par: curDirHead
; Ret: x - Fehlernummer
; Des: a,y,r1,r4,r5-r8
ClearBAM:	lda	curType
	and	#DRIVE_MASK
	cmp	#3 ;DRV_1581
	beq	@is1581
	cmp	#4 ;DRV_F011_0
	beq	@is1581
	cmp	#5 ;DRV_F011_1
	beq	@is1581
	cmp	#6 ;DRV_SD_81
	beq	@is1581
	cmp	#8 ;DRV_F011_V
	bne	@no1581
@is1581:
	ldy	#16
@3a:	lda	#40
	sta	dir2Head,y
	sta	dir3Head,y
	iny
	ldx	#4
	lda	#$ff
@3b:	sta	dir2Head,y
	sta	dir3Head,y
	iny
	dex
	bpl	@3b
	tya
	bne	@3a
	LoadB	dir2Head,40
	LoadB	dir2Head+1,2
	LoadB	dir3Head,0
	LoadB	dir3Head+1,$ff
	LoadB	dir2Head+250,37
	LoadB	dir2Head+251,%11111000
	jmp	@allocdir
@no1581:	pha
	LoadB	r1L,1
	ldy	#4
@1a:	sty	r0L
	jsr	GetSectors
	ldy	r0L
	lda	r1H
	sta	curDirHead,y
	lda	#$ff
	sta	curDirHead+1,y
	sta	curDirHead+2,y
	lda	r1H
	sec
	sbc	#16
	tax
	lda	@setbits-1,x
	sta	curDirHead+3,y
	iny
	iny
	iny
	iny
	inc	r1L
	cpy	#144
	bcc	@1a
	dec	curDirHead+72
	LoadB	curDirHead+73,%11111110
	pla
	cmp	#2
	bne	@allocdir
	lda	curDirHead+3
	beq	@allocdir
	jsr	i_FillRam
	.word	256,dir2Head
	.byte	0
	jsr	i_FillRam
	.word	105,dir2Head
	.byte	$ff
	LoadB	r1L,36
	LoadB	r0H,2
	ldy	#221
@2a:	sty	r0L
	jsr	GetSectors
	ldy	r0L
	lda	r1H
	sta	curDirHead,y
	lda	r1H
	sec
	sbc	#16
	tax
	lda	@setbits-1,x
	ldx	r0H
	sta	dir2Head,x
	AddVB	3,r0H
	inc	r1L
	iny
	bne	@2a
	LoadB	curDirHead+238,0
	sta	dir2Head+51
	sta	dir2Head+52
	sta	dir2Head+53
@allocdir:	lda	curType
	jsr	Get1stDirBlock
	MoveW_	r1,curDirHead
	jsr	EnterTurbo
	txa
	bne	@err
	jsr	InitForIO
	jsr	AllocChain
	jsr	DoneWithIO
	txa
	bne	@err
	lda	isGEOS
	beq	@err
	MoveW_	curDirHead+171,r6
	jmp	AllocAllDrives
@err:	rts
@setbits:	.byte	1,3,7,15,31
ValidateFile:
; Par:	r5 - Zeiger auf den Directory-Eintrag
;	     (wird aktualisiert)
; Ret:	x - Fehlernummer
; Des:	diskBlkBuf,fileTrScTab,a,y,r7,r8H,r2,r4,r1
	lda	#0
	sta	r2L
	sta	r2H
	ldy	#22
	lda	(r5),y
	beq	@10	;>nicht GEOS
	ldy	#19
	jsr	@100
	jsr	AllocChain	;Info-Block
	txa
	bne	@err
	ldy	#21
	lda	(r5),y
	beq	@10
	ldy	#1
	jsr	@100
	LoadW___	r4,fileTrScTab
	jsr	ReadBlock
	txa
	bne	@err
	ldy	#2
@25:	lda	fileTrScTab,y
	sta	r1L
	iny
	ldx	fileTrScTab,y
	stx	r1H
	cpy	#1
	beq	@10
	iny
	lda	r1L
	beq	@15
@20:	tya
	pha
	jsr	AllocChain
	pla
	tay
	txa
	bne	@err
	beq	@25
@15:	txa
	bne	@25
@10:	ldy	#1
	jsr	@100
	jsr	AllocChain
	txa
	bne	@err
@30:	ldy	#28
	lda	r2L
	sta	(r5),y
	iny
	lda	r2H
	sta	(r5),y
	ldx	#0
@err:	rts
@100:	lda	(r5),y
	sta	r1L
	iny
	lda	(r5),y
	sta	r1H
	rts
AllocChain:
; Date: 5.9.1990
; Par:	r1 - Track/Sektor des ersten Blocks
;	r2 - f}r Anzahl belegter Bl|cke
; Ret:	x - Fehlernummer
;	r2 - hier wurden die allokierten Bl|cke addiert
; Des:	diskBlkBuf,a,y,r7,r8H
	lda	r1L
	tax
	beq	@err
	LoadW___	r4,diskBlkBuf
@10:	ldx	#>ReadLink
	ldy	#<ReadLink
	lda	curType
	and	#DRIVE_MASK & %11111110
	bne	@12
	ldx	#>ReadBlock
	ldy	#<ReadBlock
@12:	tya
	jsr	CallRoutine
	txa
	bne	@err
	MoveW_	r1,r6
	jsr	AllocAllDrives
	txa
	bne	@err
	inc	r2L
	bne	@20
	inc	r2H
@20:	MoveB	diskBlkBuf+1,r1H
	lda	diskBlkBuf
	sta	r1L
	bne	@10
@err:	rts
; AllocAllDrives
; AllocateBlock f}r alle Floppy typen
; Par:	r6L Track
;	r6H Sector des zu belegenden Blocks
; 	curDirHead aktuelle BAM
; Ret:	x Fehlernummer
; Des:	a,y,r7,r8H
AllocAllDrives:
	lda	curType
	and	#DRIVE_MASK
	cmp	#01
	beq	@05
	jmp	AllocateBlock
@05:	jsr	FindBAMBit	;pr}fen, ob bereits belegt
	beq	@10	;ja :10
	lda	r8H
	eor	#$ff
	and	curDirHead,x
	sta	curDirHead,x
	ldx	r7H
	dec	curDirHead,x
	ldx	#0	;kein Fehler
	rts
@10:	ldx	#6	;BAD_BAM
	rts
;INV_TRACK	= 2
;GetSectors gibt zu einem bestimmten Track die Anzahl der
;m|glichen Sektoren.
;Par: r1L - Track
;Ret: r1H - Sektoren
;     x   - Fehlernummer:
;           $00 - kein Fehler
;Des: a,y
GetSectors:
	lda	curType
	and	#DRIVE_MASK
	tay
	lda	r1L
	beq	@err
	dey
	bne	@10
	cmp	#36	;1541
	bcc	@20
@err:	ldx	#INV_TRACK
	rts
@10:	dey
	bne	@50
	cmp	#71	;1571
	bcs	@err
@20:	ldy	#7	;1571/41
@30:	cmp	Tracks,y
	bcs	@40
	dey
	bpl	@30
	bmi	@err
@40:	tya
	and	#%00000011
	tay
	lda	Sectors,y
@45:	sta	r1H
	ldx	#0
	rts
@50:	cmp	#81
	bcs	@err
	lda	#40
	bne	@45

Tracks:	.byte	1,18,25,31,36,53,60,66
Sectors:	.byte	21,19,18,17
;Get1stDirBlock
; Par: a - DriveTyp
; Ret: r1 - Track/Sector des ersten Directoryblocks
; Des: a,y
Get1stDirBlock:
	and	#DRIVE_MASK
	tay
	dey
	bne	@10
@05:	LoadB	r1L,18
	LoadB	r1H,01
	rts
@10:	dey
	beq	@05
	LoadB	r1L,40
	LoadB	r1H,03
	rts
ValidateBuffer:	;64-Byte gro~er Validatebuffer
