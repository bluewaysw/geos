	n	"Desksub0"
if .p
	t	"TopSym"
	t	"TopMac(a)"
endif
	; o	9806
	s	9806-$400
:Start	LoadW	r0,:menu
	lda	#0
	jsr	DoMenu
	LoadW	appMain,:10
	rts
::menu	b	0,14
	w	0,100
	b	1
	w	:t1
	b	MENU_ACTION
	w	ReDoMenu
::t1	b	"geos",0
::10	jsr	DeProtectDisk
	LoadW	r6,TopName
	LoadB	r0L,0
	jsr	GetFile
	jmp	EnterDeskTop
:TopName	b	"TopDesk",0

	t	"RemProtection.s"

:CopyProtection	d	"RemProt.mod"
:CopyProtectionEnd
