:SaveDriver	; Speichert einen Diskdriver
	; Par:	r0: Zeiger auf Driver
	; 	a - DriveType (keine RAM und kein Shadow!)
	tay
	MoveW	r0,DriverAdr
	AddVW	$d80,r0
	MoveW	r0,DriverAdr+2
	lda	HighDrives-1,y
	sta	DriverVersion
	lda	LowDrives-1,y
	sta	DriverVersion+1
	LoadW	r0,DriverName
	jsr	DeleteFile
	txa
	beq	:10
	cpx	#5
	beq	:10
	rts
::10	LoadB	r10L,0
	LoadW	r9,Header
	jmp	SaveFile

:Header
	w	DriverName
	b	3,21
	j
		b	$80!USR
	b	DATA
	b	SEQUENTIAL
:DriverAdr	w	$9000,$9d80,0
:DriverName
	b	"Drive 15"
:DriverVersion
	b	"41",0,0
	s	255

:HighDrives
	b	"478",0
:LowDrives
	b	"111",0
