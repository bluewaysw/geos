if .p
	t	"TopSym"
	t	"TopMac(a)"
endif
	n	"SetBAM"
:Start	jsr	i_GraphicsString
	NewPattern	2
	MovePenTo	0,0
	RectangleTo	319,199
	NewPattern	0
	MovePenTo	64,14
	RectangleTo	255,28
	FrameRecTo	64,14
	EscPutstring	68,25
	b	PLAINTEXT,OUTLINEON,"SetBAM",PLAINTEXT," v. V. Goehrke",0
	lda	driveType
	beq	:next
	and	#%1000 1111
	cmp	#3
	bcs	:next
	lda	#8
	jsr	SetDevice
	jmp	SetCopy
::next	lda	driveType+1
	beq	:next2
	and	#%1000 1111
	cmp	#3
	bcs	:next2
	lda	#9
	jsr	SetDevice
	jmp	SetCopy
::next2	LoadW	r0,:db
	jsr	DoDlgBox
	jmp	EnterDeskTop
::db	b	$81
	b	DBTXTSTR,8,$10
	w	:t1
	b	DBTXTSTR,8,$20
	w	:t2
	b	OK,1,72
	b	0
::t1	b	PLAINTEXT,"Auf Lfwerk 8 oder 9 keine",0
::t2	b	"1541 oder 1571 vorhanden.",0
:SetCopy	jsr	OpenDisk
	stx	Fehler
	lda	curDrive
	clc
	adc	#"A"-8
	sta	:lfwerk
	MoveW	r5,r0
	LoadW	r1,:name
	LoadW	r2,16
	jsr	MoveData
	ldy	#15
::loop	lda	:name,y
	cmp	#$a0
	bne	:noa0
	lda	#0
	sta	:name,y
::noa0	dey
	bpl	:loop
::dodb	LoadW	r0,:db
	jsr	DoDlgBox
	lda	r0L
	cmp	#CANCEL
	beq	:end
	lda	r0L
	cmp	#DISK
	beq	SetCopy
	jsr	OpenDisk
	jsr	SetBAM
	stx	Fehler
	jmp	:dodb
::end	jmp	EnterDeskTop
::db	b	$81
	b	DBTXTSTR,8,$10
	w	:t1
	b	DBTXTSTR,8,$20
	w	:t2
	b	DBTXTSTR,8,$30
	w	:t3
	b	DB_USR_ROUT
	w	:usrrout
	b	OK,1,72
	b	DISK,9,72
	b	CANCEL,17,72
	b	0
::t1	b	PLAINTEXT,"Systemdiskette einlegen",0
::t2	b	"Disk "
::lfwerk	b	"X:"
::name	s	17
::t3	b	"Fehlernummer:",0
::usrrout	MoveB	Fehler,r0L
	LoadB	r0H,0
	LoadW	r11,140
	LoadB	r1H,32+$30
	lda	#$c0
	jmp	PutDecimal
:Fehler	b	0
:SetBAM	LoadB	r6L,20
	LoadB	r6H,0
::next	PushW	r6
	jsr	:alloc
	PopW	r6
	inc	r6H
	lda	r6H
	cmp	#19
	bcc	:next
	jmp	PutDirHead
::alloc	ldy	curType
	and	#%0000 1111
	cmp	#2
	bcc	:alloc1541
	jmp	AllocateBlock
::alloc1541	jsr	FindBAMBit
	beq	:10
	MoveW	r6,r3
	jsr	SetNextFree
::10	rts
