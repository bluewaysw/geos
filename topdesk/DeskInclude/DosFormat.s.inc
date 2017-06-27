;DosFormat	(27.06.1991)
;formatiert die Diskette im aktuellen Laufwerk
;Das aktuelle Laufwerk darf keine RAM sein !!!
; Par:	r0: Zeiger auf Name als Geos-String
;	r1L: Flag bei 1571-Floppies
;	   = 0 -> ein- sonst doppelseitig formatieren
;Des: r0-r15 (Durch InitForIO und Kernalroutinen ?)
;    a0,a1,a,x,y
;if .p
WaitTime	=	$2000
SetFilePar	=	$ffba
SetFileName	=	$ffbd
Open	=	$ffc0
Close	=	$ffc3
Listen	=	$ffb1
SecListen	=	$ff93
UnListen	=	$ffae
Talk	=	$ffb4
SecTalk	=	$ff96
UnTalk	=	$ffab
IECIn	=	$ffa5
IECOut	=	$ffa8
;endif
DosFormat:	PushW	r0
	MoveB	r1L,a1L
	jsr	PurgeTurbo
	jsr	InitForIO
	lda	#$01	;Open
	ldx	curDrive
	ldy	#$6f
	jsr	SetFilePar
	lda	#$00
	jsr	SetFileName
	jsr	Open
	lda	curDrive
	jsr	Listen
	lda	#$6f
	jsr	SecListen
	lda	curType
	and	#DRIVE_MASK
	cmp	#02
	bne	@10
	LoadW___	a0,@u0mx
	LoadB	@u0mx+4,'0'
	lda	a1L
	beq	@20
	LoadB	@u0mx+4,'1'
@20:	jsr	SendString
@10:	lda	#'N'
	jsr	IECOut
	lda	#'0'
	jsr	IECOut
	lda	#':'
	jsr	IECOut
	PopW	a0
	jsr	SendString
	LoadW___	a0,@fm
	jsr	SendString
	lda	curType
	and	#DRIVE_MASK
	cmp	#2
	bne	@30
	lda	a1L
	bne	@30
	LoadW___	a0,@u0mx
	LoadB	@u0mx+4,'1'
	jsr	SendString
@30:	lda	curDrive
	jsr	UnListen
	LoadB	$90,0
	lda	curDrive
	jsr	Talk
	lda	#$6f
	jsr	SecTalk
	jsr	IECIn
	sec
	sbc	#$30
	asl
	sta	a1H
	asl
	asl
	clc
	adc	a1H
	sta	a1H
	jsr	IECIn
	sec
	sbc	#$30
	clc
	adc	a1H
	sta	a1H
@40:	jsr	IECIn
	bit	$90
	bvc	@40
	lda	curDrive
	jsr	UnTalk
	lda	#$01
	jsr	Close
	jsr	DoneWithIO
	ldx	a1H
	bne	@err
	LoadW___	r0,WaitTime
@waitloop:	ldx	#r0L
	jsr	Ddec
	bne	@waitloop
	jsr	OpenDisk
	txa
	bne	@err
	jmp	SetGEOSDisk
@err:	rts
@fm:	.byte	",TD",$0d,0
@u0mx:	.byte	"U0>MX",$0d,"I",$0d,0
SendString:	ldy	#0
@10:	lda	(a0),y
	beq	@20
	sty	a1H
	pha
	jsr	IECOut
	pla
	cmp	#$0d
	bne	@nocr
	lda	curDrive
	jsr	UnListen
	lda	curDrive
	jsr	Listen
	lda	#$6f
	jsr	SecListen
@nocr:	ldy	a1H
	iny
	bne	@10
@20:	rts
