if .p
:WaitTime	=	$2000
:SetFilePar	=	$ffba
:SetFileName	=	$ffbd
:Open	=	$ffc0
:Close	=	$ffc3
:Listen	=	$ffb1
:SecListen	=	$ff93
:UnListen	=	$ffae
:Talk	=	$ffb4
:SecTalk	=	$ff96
:UnTalk	=	$ffab
:IECIn	=	$ffa5
:IECOut	=	$ffa8
endif
:ProtectDisk	lda	#8
	jsr	SetDevice
	jsr	PurgeTurbo
	jsr	InitForIO
	lda	#$01	;Open
	ldx	curDrive
	ldy	#$6f
	jsr	SetFilePar
	lda	#$00
	jsr	SetFileName
	jsr	Open
	LoadW	a0,CopyProtection
	LoadW	a1,$0300
::loop	lda	curDrive
	jsr	Listen
	lda	#$6f
	jsr	SecListen
	lda	#"M"
	jsr	IECOut
	lda	#"-"
	jsr	IECOut
	lda	#"W"
	jsr	IECOut
	lda	a1L
	jsr	IECOut
	lda	a1H
	jsr	IECOut
	lda	#1
	jsr	IECOut
	ldy	#0
	lda	(a0),y
	jsr	IECOut
	lda	curDrive
	jsr	UnListen
	IncW	a0
	IncW	a1
	CmpWI	a0,CopyProtectionEnd
	bcc	:loop
	lda	curDrive
	jsr	Listen
	lda	#$6f
	jsr	SecListen
	lda	#"M"
	jsr	IECOut
	lda	#"-"
	jsr	IECOut
	lda	#"E"
	jsr	IECOut
	lda	#0
	jsr	IECOut
	lda	#3
	jsr	IECOut
	lda	curDrive
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
::40	jsr	IECIn
	bit	$90
	bvc	:40
	lda	curDrive
	jsr	UnTalk
	lda	#$01
	jsr	Close
	jsr	DoneWithIO
	ldx	a1H
	bne	:err
	LoadW	r0,WaitTime
::waitloop	ldx	#r0L
	jsr	Ddec
	bne	:waitloop
	jmp	OpenDisk
::err	rts
