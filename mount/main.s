.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"
.include "geosmac.inc"
.include "diskdrv.inc"


.export __STARTUP_RUN__
.export EndOfCode

.segment "STARTUP"

	; memory layout
	; 0400-2000 code
	; 2000-5000 file list (192*64)

ICON_X	= 2
ICON_Y	= 16


DirEntry:
	.repeat	64+1+11+4+4+1
		.byte 0
	.endrep

__STARTUP_RUN__:
	LoadW	r0, EndOfCode
	
	lda	firstBoot
	cmp	#$FF
	beq	@1b

	jmp	@1
@1b:
	; init for mountable drives
	jsr	InitMountableDrives

	lda	dialogDrive
	bne	@2

	; no mountable drive found
	LoadW	r0, NoDriveDialog
	jsr	DoDlgBox

	jmp	@1
@2b:
	jsr	InitDriveButtons
@2:
	lda	dialogDrive
	clc
	adc	#'A'-8
	sta	driveLetter

	lda	curDrive
	pha

	lda	dialogDrive
	jsr	SetDevice

	jsr	GetImageFile

	ldx	#r0
	ldy	#r1
	LoadW	r1, imageName
	jsr	CopyString

	pla
	jsr	SetDevice

	; show dialog to operate the mounts
	LoadW	r0, SelectDialog
	jsr	DoDlgBox

	lda	r0L
	cmp	#OK
	bne	@1

	; mount new image for selected drive
	lda	curDrive
	pha

	lda	dialogDrive
	jsr	SetDevice

	; mount selected image
	lda	selectedEntry
	sta	r13L

	jsr	GetEntryString

	jsr	SetImageFile

	pla
	jsr	SetDevice
	bra	@end
@1:
	cmp	#'A'
	beq	@2b
@end:
	jmp	EnterDeskTop


serialText:
	.byte 	BOLDON, "No mountable drive configured.", NULL
NoDriveDialog:
	.byte	$81	; standard dialog, light bachground

	.byte	OK
	.byte	17, 70

	.byte	DBTXTSTR, 10,20
	.word	serialText

	.byte	NULL

SelectDialog:
	.byte	$81	; standard dialog, light bachground

	.byte	OK
	.byte	17, 42
	;.byte	DBUSRICON,17,42
	;.word	mountButton

	;.byte	YES
	;.byte	17, 59

	.byte	CANCEL
	.byte	17, 76

	;.byte	DBTXTSTR, 17*8-5,11
	;.word	driveText

	;.byte	DBTXTSTR, 17*8-5,21
	;.word	imageName

	;.byte	DBUSRICON,26,26
	;.word	@icon4

	.byte	DB_USR_ROUT
	.word	DrawDialog

	.byte	DBOPVEC
	.word	DialogMouse

	; up to 3 drive change icons, this
	; changes the mountable drives
driveButton1:
	.byte	DBUSRICON,17,25
	.word	driveAButton

driveButton2:
	.byte	DBUSRICON,19,25
	.word	driveBButton

driveButton3:
	.byte	DBUSRICON,21,25
	.word	driveCButton
endButton:
	.byte	NULL

driveButtons:
	.word driveAButton, driveBButton, driveCButton, driveDButton

mountButton:
	.word	mountIcon,0
	.byte	2, 16
	.word	mountButton+8
	LoadB	sysDBData, OK
	jmp	RstrFrmDialogue

mountIcon:
	.byte %11111111, %11111111
	.byte %10000000, %00000000
	.byte %10000000, %01111110
	.byte %10000001, %10011001
	.byte %10000011, %00000001
	.byte %10000111, %10011000
	.byte %10001000, %01011000
	.byte %10001000, %00111000
	.byte %10001100, %00011000
	.byte %10001000, %00001000
	.byte %10000110, %00000000
	.byte %10000010, %10000001
	.byte %10000001, %10011001
	.byte %10000000, %01111110
	.byte %10000000, %00000000
	.byte %10000000, %00000000

driveAButton:	.word	IconA,0
	.byte	ICON_X,ICON_Y
	.word	driveAButton+8
	;LoadB	@dr,'A'
	LoadB	dialogDrive, 8
	LoadB	sysDBData, 'A'
	jmp	RstrFrmDialogue
driveBButton:	.word	IconB,0
	.byte	ICON_X,ICON_Y
	.word	driveBButton+8
	;LoadB	@dr,'B'
	LoadB	dialogDrive, 9
	LoadB	sysDBData, 'A'
	jmp	RstrFrmDialogue
driveCButton:	.word	IconC,0
	.byte	ICON_X,ICON_Y
	.word	driveCButton+8
	;LoadB	@dr,'C'
	LoadB	sysDBData, 'A'
	LoadB	dialogDrive, 10
	jmp	RstrFrmDialogue
driveDButton:	.word	IconD,0
	.byte	ICON_X,ICON_Y
	.word	driveDButton+8
	;LoadB	@dr,'D'
	LoadB	sysDBData, 'A'
	LoadB	dialogDrive, 11
	jmp	RstrFrmDialogue

driveText:
	.byte	BOLDON, "Drive "
driveLetter:
	.byte	"A:", PLAINTEXT, NULL
imageName:
	.byte	"IMAGE.D81sdfsdfsdfsdfsdfsdf     "
	.byte	"IMAGE.D81sdfsdfsdfsdfsdfsdf     ", NULL

SelectionX:
	WordCX	%101100000000 | ((-96+5) & $FF), %101100000000 | ((-48+3) & $FF)
SelectionY:
	ByteCY	%101100000000 | ((-96+5) & $FF), %101100000000 | ((-48+3) & $FF)

DialogMouse:
	lda	mouseData
	bpl	@0
	rts
@0:
	MoveW	SelectionX, r3
	MoveB	SelectionY, r2L

	ldx	#r3
	jsr	NormalizeX
	ldy	#r2L
	jsr	NormalizeY

	MoveW	r3, r4
	AddVW	124, r4
	lda	graphMode
	cmp	#$41
	bne	@100
	AddVW	124, r4	
@100:
	clc
	lda	r2L
	adc	#88
	sta	r2H
	bcc	@10
	clc
	lda	r4H
	adc	#16
	sta	r4H
@10:
	jsr	IsMseInRegion
	cmp	#$FF
	beq	@1a
	jmp	@1
@1a:
	PushW	r2
	PushW	r3
	PushW	r4

	lda	r2L
	clc
	adc	#73
	sta	r2L
	bcc	@600
	clc
	lda	r3H
	adc	#16
	sta	r3H
@600:
	; check up
	AddVW	73, r3
	SubVW	16, r4
	lda	graphMode
	cmp	#$41
	bne	@200
	AddVW	73, r3
	SubVW	16, r4
@200:
	jsr	IsMseInRegion
	cmp	#$FF
	bne	@3

	lda	topIndex
	beq	@3a
	dec	topIndex

	MoveW	SelectionX, r3
	MoveB	SelectionY, r2L

	ldx	#r3
	jsr	NormalizeX
	ldy	#r2L
	jsr	NormalizeY
	jsr	DrawSelectionBox
@3a:
	PopW	r4
	PopW	r3
	PopW	r2
	rts

	; check down
@3:
	AddVW	16, r3
	AddVW	16, r4
	lda	graphMode
	cmp	#$41
	bne	@201
	AddVW	16, r3
	AddVW	16, r4
@201:
	jsr	IsMseInRegion
	cmp	#$FF
	bne	@4

	lda	topIndex
	clc
	adc	#6
	cmp	entryCount
	bcs	@4a
	inc	topIndex

	MoveW	SelectionX, r3
	MoveB	SelectionY, r2L
	ldx	#r3
	jsr	NormalizeX
	ldy	#r2L
	jsr	NormalizeY
	jsr	DrawSelectionBox
@4a:
	PopW	r4
	PopW	r3
	PopW	r2
	rts
@4:
	PopW	r4
	PopW	r3
	PopW	r2

	LoadB	r13L, 0
	LoadB	r5L, 6

	MoveW	r3, r4
	AddVW	122, r4
	lda	graphMode
	cmp	#$41
	bne	@300
	AddVW	124, r4
@300:
	clc
	lda	r2L
	adc	#11
	sta	r2H
	bcc	@500
	clc
	lda	#16
	adc	r4H
	sta	r4H
@500:

@loop:
	jsr	IsMseInRegion
	cmp	#$FF
	bne	@2

	; clicked in line
	lda	r13L
	clc
	adc	topIndex
	sta	selectedEntry

	MoveW	SelectionX, r3
	MoveB	SelectionY, r2L

	ldx	#r3
	jsr	NormalizeX
	ldy	#r2L
	jsr	NormalizeY
	jsr	DrawSelectionBox
	rts
@2:
	clc
	lda 	r2L
	adc	#12
	sta	r2L
	bcc	@401
	clc	
	lda	r3H
	adc	#16
	sta	r3H
@401:
	clc
	lda 	r2H
	adc	#12
	sta	r2H
	bcc	@402
	clc	
	lda	r4H
	adc	#16
	sta	r4H
@402:
	inc	r13L
	dec	r5L
	bne	@loop

@1:
	rts

DrawDialog:

	;jsr	TestSomething

	jsr	OpenDir

	sta	fileDesc
	LoadB	entryCount, 0
	LoadW	r1, $2000
	LoadW	r2, $1F00
@next:
	lda	fileDesc
	jsr	ReadDir
	bcc	@ok
	jmp	@end
	lda	entryCount
	brk

	lda	fileDesc
	jsr	ReadDir
	bcs	@end
@ok:
	MoveB	entryCount, r13L
	jsr	GetEntryString

	ldy	#0
@nextLen:
	lda	(r0), y
	beq	@len
	iny	
	bra	@nextLen
@len:
	cpy	#4
	bcc	@next

	dey	
	lda	(r0), y
	cmp	#'1'
	bne	@next
	dey
	lda	(r0), y
	cmp	#'8'
	bne	@next
	dey
	lda	(r0), y
	cmp	#'D'
	beq	@good
	cmp	#'d'
	bne	@next
@good:
	dey
	lda	(r0), y
	cmp	#'.'
	bne	@next

	AddVW	64, r1
	AddVW	4, r2
	
	inc	entryCount
	lda	entryCount
	cmp	#192
	bne	@next
@end:
	jsr	SortImageList
	
	MoveW	SelectionX, r11
	MoveB	SelectionY, r1H

	ldx	#r11
	jsr	NormalizeX
	ldy	#r1H
	jsr	NormalizeY
	
	AddVW	130, r11
	lda	graphMode
	cmp	#$41
	bne	@101
	AddVW	130, r11

@101:
	AddVB	6, r1H
	bcc	@11
	AddVB	16, r11H
@11:
	LoadW	r0, driveText
	PushW	r11
	jsr	PutString
	PopW	r11
	AddVB	10, r1H
	bcc	@12
	AddVB	16, r11H
@12:
	LoadW	r0, imageName
	jsr 	PutString

	LoadB	selectedEntry, 0
	MoveW	SelectionX, r3
	MoveB	SelectionY, r2L

	ldx	#r3
	jsr	NormalizeX
	ldy	#r2L
	jsr	NormalizeY
	jsr	DrawSelectionBox

	ldx	fileDesc
	jsr	CloseDir

	rts

SortImageList:
	LoadB	a0L, 0

@loop:
	LoadB	a1L, 0
@loop2:
	MoveB	a0L, r13L
	jsr	GetEntryString
	MoveW	r0, r5

	MoveB	a1L, r13L
	jsr	GetEntryString
	MoveW	r0, r6

	ldx	#r5
	ldy	#r6
	jsr	CmpString

	bcs	@keep

	; swap
	MoveB	a0L, a2L
	LoadB	a2H, 0
	
	; by 64
	clc
	ldx	#6
	beq	@10
@11:
	rol	a2L
	rol	a2H
	dex
	bne	@11
@10:
	AddVW	$2000, a2

	MoveB	a1L, a3L
	LoadB	a3H, 0

	; by 64
	clc
	ldx	#6
	beq	@20
@21:
	rol	a3L
	rol	a3H
	dex
	bne	@21
@20:
	AddVW	$2000, a3

	ldy	#0
@swap1:
	lda	(a2), y
	tax
	lda	(a3), y
	sta	(a2), y
	txa
	sta	(a3), y
	iny
	cpy	#64
	bne	@swap1

@keep:
	inc 	a1L
	lda	a1L
	cmp	entryCount
	beq	@_loop2
	jmp	@loop2
@_loop2:
	inc 	a0L
	lda	a0L
	cmp	entryCount
	beq	@_loop
	jmp	@loop
@_loop:
	rts

GetEntryString:
	MoveB	r13L, r0L
	LoadB	r0H, 0
	asl	r0L
	rol	r0H
	asl	r0L
	rol	r0H
	asl	r0L
	rol	r0H
	asl	r0L
	rol	r0H
	asl	r0L
	rol	r0H
	asl	r0L
	rol	r0H
	AddVW	$2000, r0
	rts

testName:
	.byte	"Testname", NULL

DrawSelectionBox:
	MoveW	r3, r4
	AddVW	124, r4
	lda	graphMode
	cmp	#$41
	bne	@100
	AddVW	124, r4
@100:

	clc
	lda	r2L
	adc	#88
	sta	r2H
	bcc	@10
	clc
	lda	r4H
	adc	#16
	sta	r4H
@10:

	lda	#$FF
	jsr	FrameRectangle

	PushW	r2
	PushW	r3
	PushW	r4

	lda	r2L
	clc
	adc	#73
	sta	r11L
	bcc	@20

	lda	r3H
	clc
	adc	#16
	sta	r3H
@20:
	PushW	r2
	PushW	r3
	PushW	r4
	PushB	r11L

	MoveB	r11L, r2L

	AddVW	(124-32), r3
	SubVW	16, r4
	lda	graphMode
	cmp	#$41
	bne	@101
	AddVW	(124-32), r3	
	SubVW	16, r4
@101:

	lda	#$FF
	jsr	FrameRectangle

	MoveB	r2, r11L
	AddVW	4, r3
	lda	graphMode
	cmp	#$41
	bne	@202
	AddVW	4, r3
@202:
	AddVB	10, r11L
	bcc	@21
	AddVB	16, r3H
@21:
	LoadB	r0L, $FF
	PushW	r3
	PushB	r11L
	jsr	DrawArrow
	PopB	r11L
	PopW	r3

	AddVW	16, r3
	lda	graphMode
	cmp	#$41
	bne	@203
	AddVW	16, r3
@203:
	sec
	lda	r11L
	sbc	#3
	sta	r11L
	bcs	@22
	sec
	lda	r3H
	sbc	#16
	sta	r3H
@22:	
	LoadB	r0L, 0
	jsr	DrawArrow

	PopB	r11L
	PopW	r4
	PopW	r3
	PopW	r2

	lda	#%11111111
	jsr	HorizontalLine
.if 0
	sta	r3L
	lda	r11L
	clc
	adc	#15
	sta	r3H

	SubVW	16, r4
	lda	#%11111111
	jsr	VerticalLine

	SubVW	16, r4
	lda	#%11111111
	jsr	VerticalLine
.endif
	PopW	r4
	PopW	r3
	PopW	r2

.if 1
	inc	r2L
	IncW	r3

	MoveW	r3, r4
	AddVW	122, r4
	lda	graphMode
	cmp	#$41
	bne	@107
	AddVW	124, r4
@107:
	clc
	lda	r2L
	adc	#11
	sta	r2H

	MoveB	topIndex, r13L
	lda	#6
	cmp	entryCount
	bcc	@1
	lda	entryCount
@1:
	sta	r5L
	beq	@2

@loop:
	PushB	r5L
	jsr	OutputLine
	PopB	r5L

	clc
	lda 	r2L
	adc	#12
	sta	r2L
	bcc	@400
	clc
	lda	r3H
	adc	#16
	sta	r3H
@400:
	clc
	lda 	r2H
	adc	#12
	sta	r2H
	bcc	@401
	clc
	lda	r4H
	adc	#16
	sta	r4H
@401:

	inc	r13L
	dec	r5L
	bne	@loop
.endif
@2:
	rts

OutputLine:
	PushB	currentMode
	ldy	#0
	lda	currentMode
	ora	#SET_BOLD
	ldx	r13L
	cpx	selectedEntry
	bne	@1
	ora	#SET_REVERSE
	ldy	#1
@1:
	sta	currentMode
	tya
	jsr	SetPattern
	jsr	Rectangle
	PushB	r13L
	PushW	r2
	PushW	r3
	PushW	r4

	MoveW	r3, r11
	AddVW	1, r11
	lda	r2L
	clc
	adc	#8
	sta	r1H
	bcc	@20
	clc
	lda	r11H
	adc	#16
	sta	r11H
@20:
	jsr	GetEntryString

	jsr	PutString
	PopW	r4
	PopW	r3
	PopW	r2
	PopB	r13L
	PopB	currentMode
	rts

DrawArrow:
	LoadB	r2H, 4
	
	MoveW	r3, r4
	AddVW	7, r4
	lda	graphMode
	cmp	#$41
	bne	@100
	AddVW	7, r4
@100:
@20:
	lda	#%11111111
	jsr	HorizontalLine
	
	IncW	r3
	DecW	r4
	lda	graphMode
	cmp	#$41
	bne	@101
	DecW	r4
	IncW	r3
@101:
	lda	r0L
	bne	@11
	inc	r11L
	bne	@10
	AddVB	16, r3H
@10:
	bra	@21
@11:
	lda	r11L
	bne	@22
	sec
	lda	r3H
	sbc	#16
	sta	r3H
@22:
	dec	r11L
@21:
	dec	r2H
	bne	@20
	rts
fileDesc:
	.byte	0
entryCount:
	.byte	0
topIndex:
	.byte	0
loopCount:
	.byte	0
selectedEntry:
	.byte	0

CloseDir:
	LDA #$16
	STA $D640
	NOP

	rts

OpenDir:
	;; Opendir takes no arguments and returns File descriptor in A
	LDA #$12
	STA $D640
	NOP
	LDX #$00
	RTS


	;; readdir takes the file descriptor returned by opendir as argument
	;; and gets a pointer to a MEGA65 DOS dirent structure.
	;; Again, the annoyance of the MEGA65 Hypervisor requiring a page aligned
	;; transfer area is a nuisance here. We will use $0400-$04FF, and then
	;; copy the result into a regular C dirent structure
	;;
	;; d_ino = first cluster of file
	;; d_off = offset of directory entry in cluster
	;; d_reclen = size of the dirent on disk (32 bytes)
	;; d_type = file/directory type
	;; d_name = name of file

	; input:
	;  A  - file descritpr
	;  r1 - pointer to 64 byte buffer for name
	;  r2 - pointer to 4 byte for cluster
	; return:
	;  A
	;  X
	;  CARRY: clear = success, set = error
ReadDir:
	pha

	;; First, clear out the dirent
	ldx #64+1+11+4+4
	lda #0
@l1:	sta DirEntry,x
	dex
	bne @l1

	;; Third, call the hypervisor trap
	;; File descriptor gets passed in in X.
	;; Result gets written to transfer area we setup at $0400


	plx
	;tax
	ldy #>DirEntry 		; write dirent to DirEntry

	lda #$14
	STA $D640
	NOP

	bcs @readDirSuccess

	;;  Return end of directory
	lda #$00
	ldx #$00
	sec
	RTS

@readDirSuccess:
	;;  Copy file name
	ldy #0
@l2:	lda DirEntry,y
	sta (r1),y
	beq @eofile
	iny
	cpy #63
	bne @l2
	lda #$00
	sta (r1),y
@eofile:

	ldy #3
@l3:	lda $0477,y
	sta (r2),y
	dey
	bpl @l3

.if 0
	;; Inode = cluster from offset 64+1+12 = 77
	ldx #$03
@l3:	lda $0477,x
	sta _readdir_dirent+0,x
	dex
	bpl @l3

	;; d_off stays zero as it is not meaningful here

	;; d_reclen we preload with the length of the file (this saves calling stat() on the MEGA65)
	ldx #3
@l4:	lda $0400+64+1+12+4,x
	sta _readdir_dirent+4+2,x
	dex
	bpl @l4

	;; File type and attributes
	;; XXX - We should translate these to C style meanings
	lda $0400+64+1+12+4+4
	sta _readdir_dirent+4+2+4

	;; Return address of dirent structure
	lda #<_readdir_dirent
	ldx #>_readdir_dirent
.endif
	clc
	RTS

InitMountableDrives:
	; check if current drive is mountable
	ldx	curDrive
	jsr	IsMountableDrive
	bcc	@1
	stx	dialogDrive
	bra	@2
@1:
	; no current drive, choose mountable
	ldx	#8
@4:
	jsr	IsMountableDrive
	bcc	@3
	stx	dialogDrive
	bra	@2
@3:
	inx
	cpx	#12
	bne	@4
@2:
InitDriveButtons:
	; setup drive change buttons
	LoadW	r10, driveButton1
	ldx	#8
@7:
	cpx	dialogDrive
	beq	@5
	jsr	IsMountableDrive

	bcc	@5

	; add drive
	AddVW	3,r10
	txa
	sec
	sbc	#8
	asl
	tay
	txa
	pha
	tya
	tax
	ldy	#0
	lda	driveButtons,x
	sta	(r10),y
	lda	driveButtons+1,x
	iny
	sta	(r10),y
	pla
	tax

	AddVW	2, r10
	CmpWI	r10, endButton
	beq	@6
@5:
	inx
	cpx	#12
	bne	@7

@6:	lda	#NULL
	ldz	#0
	sta	(r10), z

	rts

; X = drive no 8,9,10,11
; result: c set if mountable
; destroy A reg
IsMountableDrive:
	lda	driveType-8,x
	cmp	#DRV_SD_81
	beq	@yes
	;cmp	#DRV_SD_71
	;beq	@yes
	clc
	rts
@yes:
	sec
	rts

dialogDrive:
	.byte	0

emptyString:
	.byte	"   ", NULL
TestSomething:
	lda	#9
	jsr	SetDevice
	jsr	OpenDisk

	; enumerate over all sectors
	LoadB	r15L,1
	LoadB	r15H,0
	LoadW	r4, $5000

@1:
	PushW	r15
	PushW	r4

	; write track to screen

	LoadW	r11, 100
	LoadB	r1H, 100
	MoveB	r15L, r0L
	LoadB	r0H, 0
	lda	#0
	jsr	PutDecimal
	LoadW	r0, emptyString
	jsr	PutString

	; write sector to screen
	LoadW	r11, 100
	LoadB	r1H, 120
	MoveB	r15H, r0L
	LoadB	r0H, 0
	lda	#0
	jsr	PutDecimal
	LoadW	r0, emptyString
	jsr	PutString

	PopW	r4
	PopW	r15
	MoveW	r15, r1
	PushW	r15
	jsr	GetBlock
	PopW	r15

	inc	r15L
	lda	r15L
	cmp	#81
	bne	@1
	LoadB	r15L, 1
	inc	r15H
	lda	r15H
	cmp	#40
	beq	@2
	jmp	@1
@2:
	inc	$d020
	bra	@2
	rts

IconA:
	.incbin "mount/IconA.map"
IconB:
	.incbin "mount/IconB.map"
IconC:
	.incbin "mount/IconC.map"
IconD:
	.incbin "mount/IconD.map"

EndOfCode:
	.byte 0
