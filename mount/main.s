.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"
.include "geosmac.inc"


.export __STARTUP_RUN__

.segment "STARTUP"

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
	
	jsr	LoadImages
	
	jsr	DrawImageList
	
	rts
	
LoadImageList:
	rts
	
DrawImageList:
	rts
	
	
ImageList:
	.repeat	100
		.byte 0
	.endrep
	