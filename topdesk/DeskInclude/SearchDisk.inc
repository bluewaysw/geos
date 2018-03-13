; SearchDisk (11.02.1991) sucht nach der korrekten Diskette
; NewSearchDisk sucht nach der korrekten Diskette, ohne DirHead zu zerst|ren
; Par:	r6: Diskettenname als String
; Ret:	curType: (1571 einseitig=1541) ???
;	x: Fehlernummer
;	x: CANCEL_ERR Vorgang abgebrochen
; Des: a,y,curDirHead(SearchDisk),diskBlkBuf(NewSearchDisk)
;DRIVE_MASK	= %00011111
;CANCEL_ERR	= $0c
SearchDisk:	LoadB	OpenDiskFlag,1
	jsr	MemSearchDisk
	jsr	DriveSearchDisk
	txa
	bne	Ende
	lda	curType
	cmp	#2	; 1571	 ?
	bne	@10
	LoadB	interleave,8
@10:	jmp	OpenDisk
.if 0
	jsr	MemSearchDisk
	lda	OpenDiskFlag
	beq	@03
	LoadB	OpenDiskFlag,0
	jsr	OpenDisk
	clc
@03:	bcc	@05
	php
	jsr	NewDisk
	plp
@05:	php
	jsr	DriveSearchDisk
	txa
	bne	@end
	bcs	@10	; wenn kein SetDevice u. NewDisk ausgef}hrt
	plp
	bcc	Ende
	bcs	@20
@10:	pla
@20:	jmp	OpenDisk	; wurde, braucht auch kein OpenDisk ausgef}hrt
@end:	pla
.endif
Ende:	rts		; zu werden

NewSearchDisk:	LoadB	OpenDiskFlag,0
	jsr	MemSearchDisk
	txa
	bne	DriveSearchDisk
	lda	curType
	cmp	#2	; 1571	 ?
	bne	Ende
	LoadB	interleave,8
	bne	Ende
DriveSearchDisk:	ldx	#1
	.byte	$2c
MemSearchDisk:	ldx	#0
	LoadB	@d,0
	ldy	#29
@20:	lda	r0L,y
	pha
	dey
	bpl	@20
	stx	r7H
@50:	ldy	curDrive
	sty	r7L
@10:	tya
	jsr	@TestDisk
	txa
	beq	@end
	ldy	numDrives
	dey
	beq	@19
	ldy	curDrive
@18:	iny
	lda	driveType-8,y
	beq	@18
	cpy	#12
	bcc	@17
	ldy	#8
@17:	cpy	r7L
	bne	@10
@19:	lda	r7H
	beq	@err
	lda	AskDiskFlag
	beq	@err
	PushW	r6
	PushW	r7
	LoadW___	r0,@insertdial
	jsr	NewDoDlgBox
	ldx	r0L
	PopW	r7
	PopW	r6
	cpx	#CANCEL
	bne	@50
@err:	ldx	#CANCEL_ERR
@end:	ldy	#0
@30:	pla
	sta	r0L,y
	iny
	cpy	#30
	bcc	@30
	lda	@d
	bne	@n30
	clc
@n30:	rts
@insertdial:
	.byte	$81
	.byte	$0b,$10,$10
	.word	@t1
	.byte	$0c,$10,$20,r6
	.byte	$0b,$10,$30
	.word	@t2	
	.byte	OK
	.byte	1,72
	.byte	CANCEL
	.byte	17,72
	.byte	NULL
@t1:	.byte	$18,"Bitte legen Sie die Disk",$1b,NULL
@t2:	.byte	$18,"ein.",$1b,NULL

@TestDisk:
;	cmp	curDrive
;	beq	@n10
;	inc	@d
	jsr	NewSetDevice
	ldy	r7H
	beq	@110	;beq	:n10
	lda	OpenDiskFlag
	beq	@n01
	jsr	OpenDisk
	txa
	beq	@n10
	jmp	@240
@n01:	jsr	NewDisk
@n10:	ldy	r7H
	beq	@110
	LoadB	r1H,0
	lda	curType
	and	#DRIVE_MASK
	cmp	#2
	beq	@d05
	cmp	#1
	bne	@d10
@d05:	LoadB	r1L,18
	bne	@d20
@d10:	cmp	#3
    beq @d11
	cmp #4
	bne	@d05	; bei unbek. Laufwerk wird von 1541 ausgegangen
@d11:
	LoadB	r1L,40
@d20:	LoadW___	r4,$8000
	jsr	GetBlock
	LoadW___	r5,$8000+144
	txa
	bne	@240
	beq	@120
@110:	ldx	#r5L
	jsr	GetPtrCurDkNm
@120:	;jsr	ConvCurType
	ldy	#0
@210:	lda	(r6),y
	beq	@220
	cmp	(r5),y
	bne	@240
	iny
	cpy	#16
	bne	@210
	beq	@230
@220:	lda	(r5),y
	cmp	#$a0
	bne	@240
@230:	jsr	@sub
	ldx	#0
	rts
@240:	jsr	@sub
	ldx	#1
	rts
@d:	.byte	0
@sub:	lda	r7H
	beq	@e10
	ldx	#r4
	jsr	GetPtrCurDkNm
	ldy	#15
@loop:	lda	$8000+144,y
	sta	(r4),y
	dey
	bpl	@loop
@e10:	rts

.if 0
ConvCurType:
;Par: r4 - Zeiger auf den ersten BAM-Block einer Diskette
;Ret: curType (1571 einseitig = 1541)
;Des: a,y
	lda	curType
	and	#DRIVE_MASK
	cmp	#2
	bne	@10
	ldy	#3
	lda	(r4),y
	bne	@10
	lda	curType
	and	#%1100 0000
	ora	#1
	sta	curType
@10:	rts
.endif
