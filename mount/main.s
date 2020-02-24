.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"
.include "geosmac.inc"


.export __STARTUP_RUN__

.segment "STARTUP"

DirEntry:
	.repeat	64+1+11+4+4+1
		.byte 0
	.endrep

__STARTUP_RUN__:

	lda	firstBoot
	cmp	#$FF
	bne	@1

	; show dialog to operate the mounts
	LoadW	r0, SelectDialog
	jsr	DoDlgBox
@1:
	jmp	EnterDeskTop
	
SelectDialog:
	.byte	$81	; standard dialog, light bachground

	.byte	DBTXTSTR
	.byte	10, 25
	.word	Text1
	
	.byte	OK
	.byte	16, 70
	
	.byte	DB_USR_ROUT
	.word	DrawDialog

	.byte	NULL
	
Text1:
	.byte	"Hello World!", NULL
	
	
DrawDialog:
	lda	#3
	jsr	SetPattern
	
	LoadW	r3, 50
	LoadW	r4, 100
	LoadB	r2L, 50
	LoadB	r2H, 100
	jsr	Rectangle
	
	jsr	LoadImageList
	
	jsr	DrawImageList
	
	;jsr	OpenDir
	;jsr	ReadDir
	
	;LoadW	r0, DirEntry
	;LoadW	r11, 70
	;LoadB	r1H, 100
	;jsr	PutString
	rts
	
LoadImageList:
	rts
	
DrawImageList:
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
ReadDir:
.if 0
	pha
	
	;; First, clear out the dirent
	ldx #0
	txa
@l1:	sta @dirent,x	
	dex
	bne @l1

	;; Third, call the hypervisor trap
	;; File descriptor gets passed in in X.
	;; Result gets written to transfer area we setup at $0400


	plx
.endif
	tax
	ldy #>DirEntry 		; write dirent to DirEntry 

	lda #$14
	STA $D640
	NOP

	bcs @readDirSuccess

	;;  Return end of directory
	lda #$00
	ldx #$00
	RTS

@readDirSuccess:
.if 0	
	;;  Copy file name
	ldx #$3f
@l2:	lda $0400,x
	sta _readdir_dirent+4+2+4+2,x
	dex
	bpl @l2
	;; make sure it is null terminated
	ldx $0400+64
	lda #$00
	sta _readdir_dirent+4+2+4+2,x

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
	RTS

	
	
ImageList:
	.repeat	100
		.byte 0
	.endrep
	