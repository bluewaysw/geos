.segment "OVERLAY8"

; 	n	"DeskMod H"
;if .p
.include "topdesk/Include/Symbol/TopSym.inc"
.include "geosmac.inc"
.include "topdesk/Include/Symbol/Sym128.erg.inc"
.include "topdesk/Include/Symbol/CiSym.inc"
.include "topdesk/Include/Symbol/CiMac.inc"
;	t	"DeskWindows..ext"
;	t	"DeskTop.main.ext"
;endif
;	o	ModStart

.global NewDoDlgBox
.global SearchDisk
.global ReloadActiveWindow
.global FehlerAusgabe
.global GetAktlDisk
.global ClearMultiFile2
.global SubDir1List
.global GetAktlWinDisk
.global RecoverActiveWindow
.global DialBoxFlag
.global RemSubName
.global aktl_Sub
.global ClearList
.global GetSubDirXList
.global activeWindow
.global CopyMemHigh
.global MaxTextWin
.global DiskDriverFlag

.global CopyFile
.global CopyMemLow
.global DestinationDir
.global messageBuffer
.global GetFileName
.global GetMark
.global MultiCount

.global MinEiner
.global MinZehner
.global StdEiner
.global StdZehner
.global JahEiner
.global JahZehner
.global MonEiner
.global MonZehner
.global TagEiner
.global TagZehner
.global ShowClock
.global ModDepth
.global ClearMultiFile
.global Loadr0AX

.global KBytesFlag
.global StringLen
.global RecoverLast

.global GetFileRect
.global windowOffs
.global DispMarking
.global NewPutString
.global DrawMap
.global CutRec
.global GetClipRec
.global University
.global SetTextWin
.global NewRectangle
.global DispMode
.global winMode
.global MyDCFilesSub

.global fileNum
.global GetWinTabAdr
.global NewPutDecimal

.global GetWinName
.global GetEqualWindows
.global MyCurRec
.global NewSetDevice
.global Start2
.global SetCopyMemLow
.global NewGetFile
.global GetPrefs2
.global GetIconService
.global DispJumpTable
.global DeskOther
.global newAppMain
.global DeskMain
.global NewDoIcons
.global IconTab
.global SetNumDrives
.global KeyHandler
.global backPattern
.global RedrawHead
.global DoWindows
.global WindowTab
.global windowsOpen
.global RamTopFlag
.global PrintDriveNames
.global RedrawAll
.global FileClassNr

.global NewSearchDisk
.global GetWinDisk

SubDir2List	= SubDir1List + 64
SubDir3List	= SubDir2List + 64
SubDir4List	= SubDir3List+ 64
MultiFileTab	= SubDir4List+64
Name	= MultiFileTab + 145
DiskName	= Name + 19

	jmp	_BackUp
;	jmp	_SetWindows

;:INV_TRACK	= 2
;CopyDisk
; Date: 5.9.1990
; Par:	r6 - Zeiger auf den SourceDiskNamen (mu~ nicht unbedingt eingelegt sein)
; Ret:	x - Fehlernummer
; Des:	alles

_RTS:	rts
_BackUp:	PushW	RecoverVector
	jsr	ClearMultiFile2
	lda	#0
	sta	MyCurRec
	LoadW___	RecoverVector,_RTS
	jsr	GetAktlWinDisk
	LoadW___	r6,DiskName+2
	jsr	CopyDisk
	PopW	RecoverVector
	txa
	beq	@10
	cmp	#CANCEL_ERR
	beq	@end
	jmp	FehlerAusgabe
@10:	ldx	#3
@loop2:	stx	a7L
	jsr	GetWinDisk
	ldy	#2
@loop:	lda	DestinationName-2,y
;	cmp	#$a0
	beq	@20
	cmp	(r0),y
	bne	@nicht
	iny
	bne	@loop
@20:	lda	(r0),y
	cmp	#PLAINTEXT
	beq	@doch
	cmp	#'/'+$80
	beq	@doch
@nicht:	ldx	a7L
	dex
	bpl	@loop2
@end:	jmp	RedrawAll
@doch:	ldx	a7L
	lda	#0
	sta	windowsOpen,x
	beq	@nicht
;	t	"DiskCopy"	; mu~ letzte Zeile sein
.include "topdesk/DeskInclude/DiskCopy.inc"
