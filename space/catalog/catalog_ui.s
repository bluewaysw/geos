;**
;* GeoSpace download catalog (VLIR record 2)
;*
;* Normal start of GEOSPACE: menu (geos: info, file: quit), an alphabetical,
;* scrollable list of all catalog entries sized to the screen, a detail
;* area for the selected entry, a "Download" button and a target drive
;* button. Download fetches the CVT file from www.pagetable.com via the
;* resident HTTP client and converts it on the target drive.
;*
;* Memory: this overlay runs at $3F00-$4FFF. While browsing, two catalog
;* pages are cached in the (then unused) network buffers at $5000/$5800.
;* A download overwrites them, so the entry's data is copied first and the
;* cache is invalidated afterwards.
;*
;* GEOS65 640x400: y coordinates above 255 carry bit 8 in the upper nibble
;* of the x coordinate's high byte (see kernal/graph/normalize.s); the
;* helpers setPos / setRect do that packing.
;*

.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"
.include "geosmac.inc"
.include "diskdrv.inc"
.include "../ip/defs.inc"
; catalog files (GEOS VLIR data files, class "GSCatalog   V1.0", made by
; mkcatalog.py): record 0 info, 1 disk path table, 2 patch table,
; 3.. catalog pages
CAT_PAGE_SIZE	= 2048
CAT_REC_INFO	= 0
CAT_REC_DISKS	= 1
CAT_REC_PATCH	= 2		; patch table (patch.s)
CAT_REC_FIRST	= 3
CAT_MAX_LOC	= 160		; buffer sizes (mkcatalog.py checks them)
CAT_MAX_FILE	= 31
CAT_MAX_PAGES	= 64
CAT_MAX_HOST	= 39
MAX_CATS	= 8		; catalog files listed in file > open

.import LoadRecord, appDrive, lastConvertErr, reqLocPtr, reqLocLen, reqSufPtr, reqSufLen
.import prepare_network, HTTP_GET, runRequest, requestCancel, MyInt, progressVec
.import downloadState, initCounter, ip_address, requestComplete, downloadTimeout
.import backoffTimer, rl_pending, ratelimit_count, kbytes, current_name, http_state
.import MyRecover, last_status, bodyVec, tempName2
.import dhcp_configured, dhcp_autoconfig, dns_hostname_to_ip, dns_run, dns_result
.import task_periodic
.export CatStart, dlName, targetDrive, appDisk
.import PatchStart
PATCH_REC	= 3		; patch overlay (patch.s), runs at $6800
PATCH_ADDR	= $6800
PATCH_SIZE	= $0400
PATCH_TABLE	= $6C00		; patch table of the catalog (record 2)
PATCH_TSIZE	= $1400
CATDATA_REC	= 4		; catalog data (menus, dialogs, texts, variables)
CATDATA_ADDR	= $6000
CATDATA_SIZE	= $0800
D64_REC		= 5		; D64 extraction overlay (d64.s), jump table at $7400
D64_ADDR	= $7400
D64_SIZE	= $0C00
D64_INIT	= D64_ADDR
D64_BEGIN	= D64_ADDR+3
D64_NEXT	= D64_ADDR+6
D64_ABORT	= D64_ADDR+9

; same values as in main.s
DL_STATE_IDLE	= 0
DL_STATE_INIT	= 1
DL_STATE_DHCP	= 2
DL_STATE_DNS	= 3
DL_STATE_HTTP	= 4

DTAB		= $7000		; disk path table while browsing ($7000-$7BFF)
URLBUF		= $7C00		; full URL for the detail area
LINEBUF		= $7D00
CATNAMES	= $5C00		; file > open: catalog names (17*8) and the
openMenu	= $5C88		; submenu table; rebuilt every time ($5C00-$5CBB is free
				; while browsing, the rx buffer only during a download)
catNames	= CATNAMES
SLOT1		= $6800		; second page buffer $6800-$6FFF (survives downloads)
SLOT0		= $5400		; catalog page buffer $5400-$5BFF, disk table $5400-$5FFF
				; (not $5000-$53BC: GEOS65 ReadFile runs its code there)
PAGE_READ_MAX	= ((CAT_PAGE_SIZE + 253) / 254) * 254	; ReadFile checks whole blocks
ROWH		= 10		; list row height
LIST_Y0		= 26		; top of the first list row (header below the menu)
SBAR_W		= 14		; scroll bar width
COL_CLASS	= 120		; list columns (x)
COL_KB		= 268
COL_DATE	= 300
COL_AUTHOR	= 372
COL_PATCH	= 580		; "M65": a GEOS65 patch is available (flag bit 3)
MAX_RETRIES	= 3

ptr	= a4			; zero page pointers (unused by the resident code)
ptrL	= a4L
ptrH	= a4H
ptr2	= a5
ptr2L	= a5L
ptr2H	= a5H

.segment "OVERLAY2"

;---------------------------------------------------------------------------
CatStart:
	LoadW	r7, CATDATA_ADDR		; menus, dialogs, texts, variables
	LoadW	r2, CATDATA_SIZE
	lda	#CATDATA_REC
	jsr	LoadRecord
	txa
	beq	@data
	jmp	EnterDeskTop
@data:	LoadB	dispBufferOn, ST_WR_FORE
	LoadW	RecoverVector, MyRecover
	LoadW	progressVec, catProgress
	MoveB	appDrive, targetDrive
	LoadB	slotPage, $FF
	sta	slotPage+1
	LoadW	topIdx, 0
	LoadW	selIdx, $FFFF
	LoadB	busy, 0
	jsr	closeCat
	jsr	calcLayout
	jsr	drawScreen
	LoadW	r0, catMenu
	lda	#1
	jsr	DoMenu
	LoadW	otherPressVec, catClick
	LoadW	keyVector, catKey
	jmp	autoOpen

;---------------------------------------------------------------------------
; layout from the screen size
calcLayout:
	MoveW	screenMaxX, scrR		; right edge
	MoveW	screenMaxY, scrB		; bottom edge
	MoveW	scrB, btnY			; button row: bottom 14 lines
	SubVW	14, btnY
	MoveW	btnY, detY			; detail area: 6 lines above
	SubVW	66, detY
	; rows = (detY - 4 - LIST_Y0) / ROWH
	MoveW	detY, r0
	SubVW	LIST_Y0+4, r0
	ldx	#0
@div:	CmpWI	r0, ROWH
	bcc	@d1
	SubVW	ROWH, r0
	inx
	bne	@div
@d1:	stx	rows
	; list bottom = LIST_Y0 + rows*ROWH - 1
	LoadW	listB, LIST_Y0-1
@mul:	txa
	beq	@m1
	AddVW	ROWH, listB
	dex
	jmp	@mul
@m1:	MoveW	scrR, sbarX			; scroll bar left edge
	SubVW	SBAR_W, sbarX
	jmp	calcCols

;---------------------------------------------------------------------------
; position helpers: tx/ty (words) -> r11/r1H, packing y bit 8
setPos:
	MoveW	tx, r11
	lda	ty+1
	asl
	asl
	asl
	asl
	ora	r11H
	sta	r11H
	MoveB	ty, r1H
	rts

; rx1/ry1/rx2/ry2 (words) -> r3/r2L/r4/r2H
setRect:
	MoveW	rx1, r3
	lda	ry1+1
	asl
	asl
	asl
	asl
	ora	r3H
	sta	r3H
	MoveB	ry1, r2L
	MoveW	rx2, r4
	lda	ry2+1
	asl
	asl
	asl
	asl
	ora	r4H
	sta	r4H
	MoveB	ry2, r2H
	rts

; clear rectangle rx1..ry2
clearRect:
	lda	#0
	jsr	SetPattern
	jsr	setRect
	jmp	Rectangle

; PutString of (r0) at tx/ty
putAt:
	PushW	r0
	jsr	setPos
	PopW	r0
	jmp	PutString

;---------------------------------------------------------------------------
drawScreen:
	LoadW	rx1, 0
	LoadW	ry1, 15
	MoveW	scrR, rx2
	MoveW	scrB, ry2
	jsr	clearRect
	; column headers
	LoadW	ty, LIST_Y0-3		; one string, columns by GOTOX
	LoadW	tx, 4
	LoadW	r0, hdrLine
	jsr	putAt
	; frames: list, scroll bar
	LoadW	rx1, 0
	LoadW	ry1, LIST_Y0-1
	MoveW	scrR, rx2
	MoveW	listB, ry2
	IncW	ry2
	jsr	setRect
	lda	#$FF
	jsr	FrameRectangle
	MoveW	sbarX, rx1
	jsr	setRect
	lda	#$FF
	jsr	FrameRectangle
	jsr	drawButtons
	jsr	drawList
	jsr	drawDetail
	jmp	drawDocName

;---------------------------------------------------------------------------
; list rows topIdx .. topIdx+rows-1
drawList:
	LoadB	rowNo, 0
@row:	lda	rowNo
	cmp	rows
	bcc	@1
	jmp	drawScrollBar
@1:	jsr	drawRow
	inc	rowNo
	jmp	@row

; row rectangle of rowNo -> rx1..ry2 (inside the frame, left of the bar)
rowRect:
	jsr	rowTop
	LoadW	rx1, 1
	MoveW	sbarX, rx2
	DecW	rx2
	MoveW	ry1, ry2
	AddVW	ROWH-1, ry2
	rts

; draw row rowNo (index topIdx+rowNo), inverted if selected
drawRow:
	jsr	rowRect
	jsr	clearRect
	lda	rowNo
	clc
	adc	topIdx
	sta	curIdx
	lda	topIdx+1
	adc	#0
	sta	curIdx+1
	CmpW	curIdx, catEntries
	bcc	@have
	rts
@have:	MoveW	curIdx, r0
	jsr	catEntry		; ptr -> entry
	bcc	@ok
	rts
@ok:	MoveW	ry1, ty
	AddVW	7, ty			; baseline
	ldx	#0			; columns, each clipped at the next one
	jsr	colAt
	jsr	entryName		; r0 -> name
	jsr	putClip
	ldx	#1
	jsr	colAt
	jsr	entryName
	jsr	nextStr			; r0 -> class
	jsr	putClip
	ldx	#2
	jsr	colAt
	jsr	typeText
	jsr	putClip
	ldx	#3
	jsr	colAt
	jsr	setPos
	jsr	putKB
	ldx	#4
	jsr	colAt
	jsr	setPos
	jsr	putDate
	ldx	#5
	jsr	colAt
	jsr	entryName
	jsr	nextStr
	jsr	nextStr			; r0 -> author
	jsr	putClip
	ldx	#6
	jsr	colAt
	jsr	m65Text
	beq	@noPatch
	jsr	putClip
@noPatch:
	CmpW	curIdx, selIdx
	bne	@done
	jsr	rowRect
	jsr	setRect
	jsr	InvertRectangle
@done:	rts

; ry1 = LIST_Y0 + rowNo*ROWH
rowTop:
	LoadW	ry1, LIST_Y0
	ldx	rowNo
@1:	beq	@2
	AddVW	ROWH, ry1
	dex
	jmp	@1
@2:	rts

; scroll bar: up/down arrows and a position marker
drawScrollBar:
	MoveW	sbarX, rx1
	IncW	rx1
	MoveW	scrR, rx2
	DecW	rx2
	LoadW	ry1, LIST_Y0
	MoveW	listB, ry2
	jsr	clearRect
	MoveW	sbarX, tx
	AddVW	4, tx
	LoadW	ty, LIST_Y0+7
	LoadW	r0, txtUp
	jsr	putAt
	MoveW	listB, ty
	SubVW	2, ty
	LoadW	r0, txtDown
	jsr	putAt
	rts

;---------------------------------------------------------------------------
; detail area for selIdx
drawDetail:
	LoadW	rx1, 0
	MoveW	detY, ry1
	MoveW	scrR, rx2
	MoveW	btnY, ry2
	DecW	ry2
	jsr	clearRect
	LoadW	tx, 4
	MoveW	detY, ty
	AddVW	9, ty
	LoadW	r0, txtNoCat
	lda	noCat
	bne	@txt
	lda	selIdx+1
	cmp	#$FF
	bne	@sel
	LoadW	r0, txtSelect
@txt:	jmp	putAt
@sel:	MoveW	selIdx, r0
	jsr	catEntry
	bcc	@ok
	rts
@ok:	; line 1: name - class
	jsr	entryName
	jsr	putAt
	LoadW	r0, txtSep
	jsr	PutString
	jsr	entryName
	jsr	nextStr
	jsr	PutString
	LoadW	r0, txtSep
	jsr	PutString
	jsr	typeText
	jsr	PutString
	; line 2: author - date - size structure
	AddVW	10, ty
	jsr	entryName
	jsr	nextStr
	jsr	nextStr
	jsr	putAt
	LoadW	r0, txtSep
	jsr	PutString
	jsr	putDate
	LoadW	r0, txtSep
	jsr	PutString
	jsr	putKB
	LoadW	r0, txtKB
	jsr	PutString
	; line 3: info text of the GEOS file (clipped at the right margin)
	jsr	entryName
	jsr	nextStr
	jsr	nextStr
	jsr	nextStr
	AddVW	10, ty
	jsr	putAt
	jmp	drawUrl			; lines 4-6: download URL

; size of entry (ptr) at the current position
putKB:
	ldy	#1
	lda	(ptr), y
	sta	r0L
	LoadB	r0H, 0
	lda	#SET_SURPRESS|SET_LEFTJUST
	jmp	PutDecimal

; date of entry (ptr) at the current position: YYYY-MM-DD
putDate:
	ldy	#2
	lda	(ptr), y
	clc
	adc	#<1900
	sta	r0L
	lda	#>1900
	adc	#0
	sta	r0H
	lda	#SET_SURPRESS|SET_LEFTJUST
	jsr	PutDecimal
	ldy	#3
	jsr	@two
	ldy	#4
@two:	sty	dateIdx
	lda	#'-'
	jsr	PutChar
	ldy	dateIdx
	lda	(ptr), y
	cmp	#10
	bcs	@nz
	pha
	lda	#'0'
	jsr	PutChar
	pla
@nz:	sta	r0L
	LoadB	r0H, 0
	lda	#SET_SURPRESS|SET_LEFTJUST
	jmp	PutDecimal

;---------------------------------------------------------------------------
BTN_DL_X1	= 4
BTN_DL_X2	= 92
BTN_DRV_X1	= 100
BTN_DRV_X2	= 188

drawButtons:
	LoadW	rx1, 0
	MoveW	btnY, ry1
	MoveW	scrR, rx2
	MoveW	scrB, ry2
	jsr	clearRect
	LoadW	rx1, BTN_DL_X1
	LoadW	rx2, BTN_DL_X2
	jsr	btnFrame
	LoadW	rx1, BTN_DRV_X1
	LoadW	rx2, BTN_DRV_X2
	jsr	btnFrame
	MoveW	btnY, ty
	AddVW	10, ty
	LoadW	tx, BTN_DL_X1+10
	LoadW	r0, txtDownload
	lda	busy
	beq	@1
	LoadW	r0, txtCancel
@1:	jsr	putAt
	LoadW	tx, BTN_DRV_X1+10
	LoadW	r0, txtDrive
	jsr	putAt
	MoveB	targetDrive, r0L		; device number (GEOS65 may use other
	LoadB	r0H, 0			; numbers than 8-11)
	lda	#SET_SURPRESS|SET_LEFTJUST
	jsr	PutDecimal
@2:	rts

btnFrame:
	MoveW	btnY, ry1
	IncW	ry1
	MoveW	scrB, ry2
	DecW	ry2
	jsr	setRect
	lda	#$FF
	jmp	FrameRectangle

; status text (r0) right of the buttons
status:
	PushW	r0
	LoadW	rx1, BTN_DRV_X2+8
	MoveW	btnY, ry1
	IncW	ry1
	MoveW	scrR, rx2
	MoveW	scrB, ry2
	jsr	clearRect
	LoadW	tx, BTN_DRV_X2+12
	MoveW	btnY, ty
	AddVW	10, ty
	PopW	r0
	jmp	putAt

;---------------------------------------------------------------------------
; catalog access
; in: r0 = entry index   out: ptr = entry, carry set on error
catEntry:
	ldx	#0			; page = last page with first <= index
@find:	cpx	lastPage
	beq	@got
	lda	pageFirstLo+1, x
	sta	r1L
	lda	pageFirstHi+1, x
	sta	r1H
	CmpW	r0, r1
	bcc	@got
	inx
	jmp	@find
@got:	stx	curPage
	lda	r0L			; k = index - first[page]
	sec
	sbc	pageFirstLo, x
	sta	curK
	ldy	#0			; cached in one of the two page buffers?
	cpx	slotPage
	beq	@hit
	iny
	cpx	slotPage+1
	beq	@hit
	lda	lastSlot		; load into the buffer not used last
	eor	#1
	sta	curSlot
	ldy	curSlot
	lda	slotLo, y
	sta	r7L
	lda	slotHi, y
	sta	r7H
	LoadW	r2, PAGE_READ_MAX
	lda	curPage
	clc
	adc	#CAT_REC_FIRST
	jsr	LoadCatRecord
	ldy	curSlot
	lda	#$FF
	sta	slotPage, y
	txa
	beq	@loaded
	sec
	rts
@loaded:
	lda	curPage
	sta	slotPage, y
@hit:	sty	lastSlot
	lda	slotLo, y
	sta	ptr2L
	lda	slotHi, y
	sta	ptr2H
	lda	curK			; ptr = slot + offset[k]
	asl
	tay
	iny
	lda	(ptr2), y
	clc
	adc	ptr2L
	sta	ptrL
	iny
	lda	(ptr2), y
	adc	ptr2H
	sta	ptrH
	clc
	rts

; r0 = name of entry ptr
entryName:
	lda	ptrL
	clc
	adc	#6
	sta	r0L
	lda	ptrH
	adc	#0
	sta	r0H
	rts

; r0 = string after the one r0 points to
nextStr:
	ldy	#0
@1:	lda	(r0), y
	beq	@2
	iny
	bne	@1
@2:	iny
	tya
	clc
	adc	r0L
	sta	r0L
	bcc	@3
	inc	r0H
@3:	rts

; make sure the drive GEOSPACE was started from is current
appDisk:
	lda	curDrive
	cmp	appDrive
	beq	@1
	lda	appDrive
	jsr	SetDevice
	jsr	OpenDisk
@1:	rts

;---------------------------------------------------------------------------
; input
catClick:
	lda	mouseData
	bpl	@press
	rts
@press:	jsr	mouseXY
	CmpW	my, btnY
	bcc	@list
	; button row
	CmpWI	mx, BTN_DL_X2+1
	bcs	@notDl
	lda	busy
	beq	@dl
	jmp	cancelDl
@dl:	jmp	startDl
@notDl:	lda	busy
	bne	@r
	CmpWI	mx, BTN_DRV_X1
	bcc	@r
	CmpWI	mx, BTN_DRV_X2+1
	bcs	@r
	jmp	nextDrive
@r:	rts
@list:	lda	busy
	bne	@r
	CmpWI	my, LIST_Y0
	bcc	@r
	CmpW	my, listB
	bcs	@r
	CmpW	mx, sbarX
	bcc	@row
	; scroll bar: first row up, last row down, otherwise by pages
	CmpWI	my, LIST_Y0+ROWH
	bcs	@notUp
	lda	#1
	jmp	scrollUp
@notUp:	MoveW	listB, r1
	SubVW	ROWH, r1
	CmpW	my, r1
	bcc	@page
	lda	#1
	jmp	scrollDown
@page:	MoveW	listB, r1		; upper half: page up, lower: page down
	AddVW	LIST_Y0, r1
	lsr	r1H
	ror	r1L
	CmpW	my, r1
	lda	rows
	bcs	@pgDn
	jmp	scrollUp
@pgDn:	jmp	scrollDown
@row:	MoveW	my, r0			; row = (my - LIST_Y0) / ROWH
	SubVW	LIST_Y0, r0
	ldx	#0
@div:	CmpWI	r0, ROWH
	bcc	@d
	SubVW	ROWH, r0
	inx
	bne	@div
@d:	txa
	clc
	adc	topIdx
	sta	r0L
	lda	topIdx+1
	adc	#0
	sta	r0H
	CmpW	r0, catEntries
	bcs	@r9
	jmp	select
@r9:	rts

; mx/my from mouseXPos/mouseYPos (y bit 8 in the upper nibble of x high)
mouseXY:
	lda	mouseXPos
	sta	mx
	lda	mouseXPos+1
	and	#$0F
	sta	mx+1
	lda	mouseXPos+1
	lsr
	lsr
	lsr
	lsr
	sta	my+1
	MoveB	mouseYPos, my
	rts

catKey:
	lda	busy
	ora	noCat
	bne	@r
	lda	keyData
	cmp	#KEY_UP
	beq	@up
	cmp	#KEY_DOWN
	beq	@down
	cmp	#KEY_HOME
	beq	@home
	cmp	#CR
	bne	@r
	jmp	startDl
@r:	rts
@home:	LoadW	r0, 0
	jmp	select
@up:	lda	selIdx+1
	cmp	#$FF
	beq	@home
	lda	selIdx
	ora	selIdx+1
	beq	@r
	MoveW	selIdx, r0
	DecW	r0
	jmp	select
@down:	lda	selIdx+1
	cmp	#$FF
	beq	@home
	MoveW	selIdx, r0
	IncW	r0
	CmpW	r0, catEntries
	bcs	@r
	jmp	select

; select entry r0 and scroll it into view
select:
	MoveW	r0, selIdx
	jsr	buildUrl		; URL shown in the detail area
	MoveW	selIdx, r0
	CmpW	r0, topIdx
	bcs	@notAbove
	MoveW	r0, topIdx
	jmp	@redraw
@notAbove:
	lda	topIdx			; r1 = topIdx + rows
	clc
	adc	rows
	sta	r1L
	lda	topIdx+1
	adc	#0
	sta	r1H
	CmpW	r0, r1
	bcc	@redraw
	lda	r0L			; topIdx = sel - rows + 1
	sec
	sbc	rows
	sta	topIdx
	lda	r0H
	sbc	#0
	sta	topIdx+1
	IncW	topIdx
@redraw:
	jsr	drawList
	jsr	drawButtons
	jmp	drawDetail

; scroll up by A rows
scrollUp:
	sta	r0L
	lda	topIdx
	sec
	sbc	r0L
	sta	topIdx
	lda	topIdx+1
	sbc	#0
	sta	topIdx+1
	bcs	@ok
	LoadW	topIdx, 0
@ok:	jmp	drawList

; scroll down by A rows, keep the last page full
scrollDown:
	clc
	adc	topIdx
	sta	topIdx
	lda	topIdx+1
	adc	#0
	sta	topIdx+1
	lda	catEntries		; max top = entries - rows (>= 0)
	sec
	sbc	rows
	sta	r1L
	lda	catEntries+1
	sbc	#0
	sta	r1H
	bcs	@max
	LoadW	r1, 0
@max:	CmpW	topIdx, r1
	bcc	@ok
	MoveW	r1, topIdx
@ok:	jmp	drawList

; next drive: the drive GEOSPACE runs from and every existing drive 8-11
nextDrive:
	ldx	targetDrive
@next:	inx
	cpx	#12
	bcc	@1
	ldx	#8
@1:	cpx	targetDrive
	beq	@done
	cpx	appDrive
	beq	@take
	lda	driveType-8, x
	beq	@next
@take:	stx	targetDrive
@done:	jmp	drawButtons

;---------------------------------------------------------------------------
; table columns and the URL display (record 4 at $6000)
.segment "OVERLAY4"

; column x positions from the screen width; header GOTOX operands
calcCols:
	ldx	#1
@c:	MoveW	scrR, r0		; (width/4 * frac) / 64
	lsr	r0H
	ror	r0L
	lsr	r0H
	ror	r0L
	lda	colFrac, x
	sta	r1L
	txa
	pha
	ldx	#r0
	ldy	#r1
	jsr	BMult
	ldx	#6
@s:	lsr	r0H
	ror	r0L
	dex
	bne	@s
	pla
	tax
	asl
	tay
	lda	r0L
	sta	colPos, y
	lda	r0H
	sta	colPos+1, y
	inx
	cpx	#7
	bne	@c
	LoadW	colPos, 4
	MoveW	sbarX, colPos+14
	MoveW	colPos+2, hdrX1		; header positions
	MoveW	colPos+4, hdrX2
	MoveW	colPos+6, hdrX3
	MoveW	colPos+8, hdrX4
	MoveW	colPos+10, hdrX5
	MoveW	colPos+12, hdrX6
@url:	MoveW	scrR, r0		; URL characters per line: (width-8) / 7
	SubVW	8, r0
	ldx	#0
@d:	CmpWI	r0, 7
	bcc	@dd
	SubVW	7, r0
	inx
	bne	@d
@dd:	stx	urlN
	rts

; X = column: tx = its x, clipX = next column - 4
colAt:	txa
	asl
	tay
	lda	colPos, y
	sta	tx
	lda	colPos+1, y
	sta	tx+1
	lda	colPos+2, y		; text of this column ends 4 pixels before
	sec				; the next one (putClip)
	sbc	#4
	sta	clipX
	lda	colPos+3, y
	sbc	#0
	sta	clipX+1
	rts

; lines 4-6 of the detail area: http://host + location + file, wrapped
drawUrl:
	ldx	#0
	LoadW	r0, txtHttp
	jsr	urlAdd
	LoadW	r0, hostBuf
	jsr	urlAdd
	ldy	#0			; location (dlLocLen bytes)
@l:	cpy	dlLocLen
	beq	@f
	lda	dlLoc, y
	sta	URLBUF, x
	inx
	iny
	bne	@l
@f:	LoadW	r0, dlFile
	jsr	urlAdd
	lda	#0
	sta	URLBUF, x
	LoadB	urlOff, 0
	LoadB	urlLines, 3		; at most 3 lines
@line:	AddVW	10, ty
	ldx	urlOff
	ldy	#0
@c:	lda	URLBUF, x
	sta	LINEBUF, y
	beq	@last
	inx
	iny
	cpy	urlN
	bne	@c
	lda	#0
	sta	LINEBUF, y
	stx	urlOff
	LoadW	r0, LINEBUF
	jsr	putAt
	ldx	urlOff
	lda	URLBUF, x
	beq	@r
	dec	urlLines
	bne	@line
@r:	rts
@last:	LoadW	r0, LINEBUF
	jmp	putAt

; append the string at r0 to URLBUF at X
urlAdd:	ldy	#0
@1:	lda	(r0), y
	beq	@2
	sta	URLBUF, x
	inx
	iny
	bne	@1
@2:	rts

;---------------------------------------------------------------------------
; catalog files: this code is part of record 4 at $6000 (overlay 2 is full).
; It is safe there because GeoSpace only draws into the foreground screen;
; GEOS65 maps the background screen to $6000-$7FFF only while drawing into it.
.segment "OVERLAY4"

; A = record of the opened catalog, r7 = destination, r2 = max. size
; out: X = GEOS error
LoadCatRecord:
	pha
	PushW	r7
	PushW	r2
	jsr	catDisk
	LoadW	r0, catName
	jsr	OpenRecordFile
	PopW	r2
	PopW	r7
	pla
	cpx	#0
	bne	@r
	jsr	PointRecord
	jsr	ReadRecord
	txa
	pha
	jsr	CloseRecordFile
	pla
	tax
@r:	rts

; make the catalog's drive current
catDisk:
	lda	curDrive
	cmp	catDrive
	beq	@1
	lda	catDrive
	jsr	SetDevice
	jsr	OpenDisk
@1:	rts

; at the start: one catalog on the drive -> open it, several -> ask
autoOpen:
	jsr	findCats
	beq	@none
	lda	#0			; the first catalog of the drive
	jmp	openSel2
@none:	LoadW	r0, txtNoCatF
	jmp	status

; catalog files of the current drive -> catNames (max 8), A = count (Z flag)
findCats:
	LoadW	r6, catNames
	LoadB	r7L, APPL_DATA
	LoadB	r7H, MAX_CATS
	LoadW	r10, catClass
	jsr	FindFTypes
	lda	#0
	cpx	#0
	bne	@r
	lda	#MAX_CATS
	sec
	sbc	r7H
@r:	sta	nCats
	cmp	#0
	rts

; file > open: dynamic submenu with the catalogs of the current drive
buildOpenMenu:
	jsr	findCats
	bne	@have
	LoadW	r0, txtNoCatF
	jsr	status
	LoadW	r0, 0			; no submenu
	rts
@have:	ora	#VERTICAL | UN_CONSTRAINED
	sta	openMenu+6
	LoadB	openMenu, 15		; top, left 81, right 200
	LoadW	openMenu+2, 81
	LoadW	openMenu+4, 200
	lda	nCats			; bottom = 15 + 14 * n
	asl
	sta	r0L
	asl
	asl
	asl
	sec
	sbc	r0L
	clc
	adc	#15
	sta	openMenu+1
	LoadW	r1, openMenu+7		; items: name, MENU_ACTION, openSel
	LoadW	r2, catNames
	ldx	nCats
@it:	ldy	#0
	lda	r2L
	sta	(r1), y
	iny
	lda	r2H
	sta	(r1), y
	iny
	lda	#MENU_ACTION
	sta	(r1), y
	iny
	lda	#<openSel
	sta	(r1), y
	iny
	lda	#>openSel
	sta	(r1), y
	AddVW	5, r1
	AddVW	17, r2
	dex
	bne	@it
	LoadW	r0, openMenu
	rts

; A = item of the open submenu
openSel:
	pha
	jsr	GotoFirstMenu
	pla
openSel2:
	sta	r0L			; catNames + 17 * A -> catName
	asl
	asl
	asl
	asl
	clc
	adc	r0L
	tax
	ldy	#0
@cp:	lda	catNames, x
	sta	catName, y
	inx
	iny
	cpy	#17
	bne	@cp
	MoveB	curDrive, catDrive
	jmp	openCat

closeCat:
	LoadB	dtValid, 0
	LoadB	noCat, 1
	LoadW	catEntries, 0
	LoadW	topIdx, 0
	LoadW	selIdx, $FFFF
	LoadB	slotPage, $FF
	sta	slotPage+1
	rts

; open catalog catName on catDrive: info record -> entries, pages, host
openCat:
	jsr	closeCat
	LoadW	r7, SLOT1
	LoadW	r2, $0400
	lda	#CAT_REC_INFO
	jsr	LoadCatRecord
	cpx	#0
	beq	@read
@bad0:	jmp	@bad
@read:	ldx	#3			; "GSC", version 1
@id:	lda	SLOT1, x
	cmp	catId, x
	bne	@bad0
	dex
	bpl	@id
	MoveW	SLOT1+4, catEntries
	lda	SLOT1+6
	beq	@bad0
	cmp	#CAT_MAX_PAGES+1
	bcs	@bad
	sta	catPages
	sec
	sbc	#1
	sta	lastPage
	ldx	#0			; host
@h:	lda	SLOT1+7, x
	sta	hostBuf, x
	beq	@hd
	inx
	cpx	#CAT_MAX_HOST
	bne	@h
	beq	@bad
@hd:	txa			; first entry of every page (lo, then hi)
	clc
	adc	#<(SLOT1+8)
	sta	r0L
	lda	#>(SLOT1+8)
	adc	#0
	sta	r0H
	ldy	#0
@lo:	lda	(r0), y
	sta	pageFirstLo, y
	iny
	cpy	catPages
	bne	@lo
	lda	r0L
	clc
	adc	catPages
	sta	r0L
	bcc	@h2
	inc	r0H
@h2:	ldy	#0
@hi:	lda	(r0), y
	sta	pageFirstHi, y
	iny
	cpy	catPages
	bne	@hi
	ldx	#0			; request suffix with the Host: header
	LoadW	r0, sufHead
	jsr	sufCopy
	LoadW	r0, hostBuf
	jsr	sufCopy
	LoadW	r0, sufTail
	jsr	sufCopy
	stx	sufLen
	LoadB	noCat, 0
	LoadB	slotPage+1, $FF		; SLOT1 held the info record
	jmp	drawScreen
@bad:	jsr	closeCat
	jsr	drawScreen
	LoadW	r0, txtNoCatF
	jmp	status

; append the string at r0 to sufBuf at X
sufCopy:
	ldy	#0
@1:	lda	(r0), y
	beq	@2
	sta	sufBuf, x
	inx
	iny
	bne	@1
@2:	rts

.segment "OVERLAY2"

doClose:
	jsr	GotoFirstMenu
	jsr	closeCat
	jmp	drawScreen

; r0 = string at tx/ty, only the part that ends before clipX
putClip:
	MoveW	r0, a6
	MoveW	tx, clipW
	ldy	#0
@l:	lda	(a6), y
	beq	@p
	sty	clipN
	jsr	GetCharWidth
	clc
	adc	clipW
	sta	clipW
	bcc	@w
	inc	clipW+1
@w:	CmpW	clipW, clipX
	ldy	clipN
	bcs	@p
	lda	(a6), y
	sta	LINEBUF, y
	iny
	bne	@l
@p:	lda	#0
	sta	LINEBUF, y
	LoadW	r0, LINEBUF
	jmp	putAt

; r0 = "APPL" / "DA" for entry (ptr)
typeText:
	LoadW	r0, txtAppl
	ldy	#0
	lda	(ptr), y
	and	#4
	beq	@r
	LoadW	r0, txtDAt
@r:	rts

; r0 = "PATCH" / "TESTED" for entry (ptr), Z set if neither
m65Text:
	ldy	#0
	lda	(ptr), y
	and	#8
	beq	@t
	LoadW	r0, txtPatch
	rts
@t:	lda	(ptr), y
	and	#32
	beq	@r
	LoadW	r0, txtTested
	lda	#1
@r:	rts

; name of the opened catalog at the top right (like geoWrite's document)
drawDocName:
	LoadW	rx1, 62			; top line right of the menu
	LoadW	ry1, 0
	MoveW	scrR, rx2
	LoadW	ry2, 14
	jsr	clearRect
	lda	noCat
	bne	@r
	MoveW	scrR, tx		; right-aligned
	SubVW	6, tx
	ldy	#0
@w:	lda	catName, y
	beq	@put
	sty	dateIdx
	jsr	GetCharWidth
	sta	r0L
	lda	tx
	sec
	sbc	r0L
	sta	tx
	bcs	@nb
	dec	tx+1
@nb:	ldy	dateIdx
	iny
	cpy	#16
	bne	@w
@put:	LoadW	ty, 10
	LoadW	r0, catName
	jmp	putAt
@r:	rts

;---------------------------------------------------------------------------
; menu actions
doQuit:
	jsr	GotoFirstMenu
	jmp	EnterDeskTop

doInfo:
	jsr	GotoFirstMenu
	LoadW	r0, infoDialog
	jmp	DoDlgBox

;---------------------------------------------------------------------------
; download of the selected entry
.segment "OVERLAY2"
buildUrl:
	lda	selIdx+1
	cmp	#$FF
	bne	@1
@no:	sec
	rts
@1:	MoveW	selIdx, r0
	jsr	catEntry
	bcs	@no
@2:	jsr	entryName		; GEOS file name (progress, "replace?")
	ldy	#0
@cpn:	lda	(r0), y
	sta	dlName, y
	beq	@cpd
	iny
	cpy	#16
	bne	@cpn
	lda	#0
	sta	dlName, y
@cpd:	ldy	#5
	lda	(ptr), y
	sta	dlDisk
	ldy	#0			; M65 patch for this entry?
	lda	(ptr), y
	and	#8
	sta	dlPatch
	lda	(ptr), y		; GEOS file from a .d64 image?
	and	#16
	sta	d64Mode
	beq	@notD64
	LoadB	dlFile, 0		; the request is the image path itself
	jmp	@fileOk
@notD64:
	ldy	#0			; download file: explicit or quote(name).cvt
	lda	(ptr), y
	and	#2
	beq	@quote
	jsr	entryName
	jsr	nextStr
	jsr	nextStr
	jsr	nextStr
	jsr	nextStr			; r0 -> explicit file name
	ldy	#0
@cpf:	lda	(r0), y
	sta	dlFile, y
	beq	@fileOk
	iny
	bne	@cpf
@quote:	ldx	#0
	ldy	#0
@q:	lda	dlName, y
	beq	@qe
	jsr	isUnreserved
	bcc	@lit
	pha
	lda	#'%'
	sta	dlFile, x
	inx
	pla
	pha
	lsr
	lsr
	lsr
	lsr
	jsr	hexDigit
	sta	dlFile, x
	inx
	pla
	and	#$0F
	jsr	hexDigit
@lit:	sta	dlFile, x
	inx
	iny
	jmp	@q
@qe:	ldy	#0
@ext:	lda	txtCvt, y
	sta	dlFile, x
	beq	@fileOk
	inx
	iny
	jmp	@ext
@fileOk:
	; location: url prefix + disk path + "/"
	lda	dtValid			; disk table at $7000 (kept while browsing)
	bne	@dt
	LoadW	r7, DTAB
	LoadW	r2, $0C00
	lda	#CAT_REC_DISKS
	jsr	LoadCatRecord
	txa
	beq	@dtok
	sec
	rts
@dtok:	LoadB	dtValid, 1
@dt:	LoadW	r0, DTAB+1		; url prefix, then the disk paths
	ldx	#0
	jsr	copyLoc
	stx	r4L
	ldx	dlDisk
	inx
@skip:	dex
	beq	@found
	txa
	pha
	jsr	nextStr
	pla
	tax
	jmp	@skip
@found:	ldx	r4L
	ldy	#0
	lda	(r0), y
	cmp	#'/'			; absolute path: without the url prefix
	bne	@rel
	ldx	#0
@rel:	jsr	copyLoc
	lda	d64Mode
	bne	@noSl
@slash:	lda	#'/'
	sta	dlLoc, x
	inx
@noSl:
	stx	dlLocLen
	clc
	rts

startDl:
	lda	noCat
	beq	@open
	rts
@open:	jsr	buildUrl		; (fails without a selection)
	bcc	@built
	LoadW	r0, txtDiskErr
	jmp	status
@built:	lda	d64Mode
	beq	@nd
	LoadB	slotPage+1, $FF		; $6800-$73FF: D64 tables
@nd:	ldx	dlLocLen
	stx	reqLocLen
	LoadB	reqLocLen+1, 0
	LoadW	reqLocPtr, dlLoc
	LoadW	reqSufPtr, sufBuf		; Host: header of the catalog
	MoveB	sufLen, reqSufLen
	LoadB	reqSufLen+1, 0
	lda	d64Mode			; D64: extraction overlay to $7400
	beq	@noOvl
	jsr	appDisk			; (from GEOSPACE)
	LoadW	r7, D64_ADDR
	LoadW	r2, D64_SIZE
	lda	#D64_REC
	jsr	LoadRecord
	txa
	beq	@d64ok
	LoadW	r0, txtDiskErr
	jmp	status
@d64ok:	lda	#<dlName
	ldx	#>dlName
	jsr	D64_INIT
@noOvl:
	; target drive; replace an existing file?
	lda	targetDrive
	jsr	SetDevice
	jsr	OpenDisk
	txa
	beq	@disk
	jsr	appDisk
	LoadW	r0, txtNoDisk
	jmp	status
@disk:	LoadW	r6, dlName
	jsr	FindFile
	txa
	bne	@new
	LoadW	r0, replaceDialog
	jsr	DoDlgBox
	lda	r0L
	cmp	#YES
	beq	@del
	jmp	appDisk
@del:	LoadW	r0, dlName
	jsr	DeleteFile
@new:	LoadB	busy, 1
	LoadB	retries, 0
	LoadB	lastConvertErr, $FF
	lda	#'-'			; no HTTP answer yet
	sta	last_status
	sta	last_status+1
	sta	last_status+2
	LoadW	current_name, dlName
	LoadW	kbytes, 0
	jsr	drawButtons
	LoadW	r0, txtConnect
	jsr	status
	LoadW	intTopVector, MyInt
	LoadW	appMain, catRun
	jmp	prepare_network		; -> DL_STATE_INIT

; append the string at r0 to dlLoc at X; r0 -> next string
copyLoc:
	ldy	#0
@1:	lda	(r0), y
	beq	@2
	sta	dlLoc, x
	inx
	iny
	bne	@1
@2:	jmp	nextStr

; carry clear if A is unreserved in URLs: A-Z a-z 0-9 _ . - ~
isUnreserved:
	cmp	#'-'
	beq	@ok
	cmp	#'.'
	beq	@ok
	cmp	#'_'
	beq	@ok
	cmp	#'~'
	beq	@ok
	cmp	#'0'
	bcc	@esc
	cmp	#'9'+1
	bcc	@ok
	cmp	#'A'
	bcc	@esc
	cmp	#'Z'+1
	bcc	@ok
	cmp	#'a'
	bcc	@esc
	cmp	#'z'+1
	bcc	@ok
@esc:	sec
	rts
@ok:	clc
	rts

hexDigit:
	cmp	#10
	bcc	@1
	adc	#'A'-10-1
	rts
@1:	adc	#'0'
	rts

;---------------------------------------------------------------------------
; appMain while downloading: DHCP -> DNS -> HTTP, like runDownload
catRun:
	jsr	task_periodic
	LoadB	dblClickCount, 1
@wait:	lda	dblClickCount
	bne	@wait
	lda	downloadState
	cmp	#DL_STATE_INIT
	bne	@dhcp
	dec	initCounter
	bne	@r
	LoadB	downloadState, DL_STATE_DHCP
	LoadB	dhcp_configured, 0
	jmp	dhcp_autoconfig
@r:	rts
@dhcp:	cmp	#DL_STATE_DHCP
	bne	@dns
	lda	dhcp_configured
	beq	@r
	LoadW	r0, hostBuf
	LoadW	r1, hostIPbuf
	lda	#$FF
	jsr	dns_hostname_to_ip
	LoadB	downloadState, DL_STATE_DNS
	rts
@dns:	cmp	#DL_STATE_DNS
	bne	@http
	jsr	dns_run
	bcc	@dnsDone
	rts
@dnsDone:
	jsr	dns_result
	MoveW	r0, ip_address
	MoveW	r1, ip_address+2
	LoadB	downloadState, DL_STATE_HTTP
	jmp	sendGet
@http:	cmp	#DL_STATE_HTTP
	bne	@r
	lda	backoffTimer		; rate limited: wait
	ora	backoffTimer+1
	bne	@r
	lda	requestComplete
	beq	@running
	lda	d64Mode
	beq	@done
	jsr	D64_NEXT		; D64: A = 1 another pass
	cmp	#1
	bne	@done
	jmp	sendGet
@done:	jmp	dlDone
@running:
	lda	downloadTimeout
	ora	downloadTimeout+1
	beq	@timeout
	jmp	runRequest
@timeout:
	jsr	requestCancel
	lda	rl_pending		; rate limited: retry without counting
	beq	@count
	LoadB	rl_pending, 0
	jmp	sendGet
@count:	inc	retries
	lda	retries
	cmp	#MAX_RETRIES
	bcc	sendGet
	jmp	dlDone

sendGet:
	lda	d64Mode
	beq	@plain
	jsr	D64_BEGIN		; restart the image stream
@plain:	MoveW	ip_address, r0
	MoveW	ip_address+2, r1
	LoadW	r2, dlFile
	ldy	#0
@len:	lda	dlFile, y
	beq	@l
	iny
	bne	@len
@l:	sty	r3L
	LoadB	r3H, 0
	LoadB	a9L, 0			; no folder
	jsr	HTTP_GET
	php
	sei
	LoadW	downloadTimeout, 50*30
	plp
	rts

cancelDl:
	jsr	requestCancel
	lda	d64Mode
	beq	@c
	jsr	D64_ABORT
@c:	LoadB	lastConvertErr, $FE	; cancelled
dlDone:
	LoadB	downloadState, DL_STATE_IDLE
	LoadW	appMain, 0
	LoadB	busy, 0
	LoadB	dtValid, 0		; $7000: D64 overlay / patch table
	LoadB	slotPage, $FF		; network buffers / ReadFile overwrote the cache
	lda	d64Mode			; D64: clean up on the target drive
	beq	@noD64
	lda	lastConvertErr
	beq	@d64ok
	jsr	D64_ABORT		; free allocated blocks (if any)
@d64ok:	LoadW	bodyVec, 0
	LoadW	r0, tempName2		; temp file of the last request
	jsr	DeleteFile
	LoadB	d64Mode, 0
@noD64:
	jsr	appDisk
	lda	lastConvertErr		; converted: patch for GEOS65 if the
	bne	@noPatch		; entry is marked M65
	lda	dlPatch
	beq	@noPatch
	LoadB	slotPage+1, $FF		; (the patch overlay uses page buffer 1)
	LoadW	r7, PATCH_ADDR
	LoadW	r2, PATCH_SIZE
	lda	#PATCH_REC
	jsr	LoadRecord
	txa
	bne	@noPatch
	LoadW	r7, PATCH_TABLE		; the catalog's patch table
	LoadW	r2, PATCH_TSIZE
	lda	#CAT_REC_PATCH
	jsr	LoadCatRecord
	txa
	bne	@noPatch
	jsr	PatchStart
@noPatch:
	jsr	drawScreen
	LoadW	r0, txtDone
	lda	lastConvertErr
	beq	@msg
	LoadW	r0, txtCancelled
	cmp	#$FE
	beq	@msg
	LoadW	r0, txtFailed
	jsr	status
	LoadW	r0, last_status		; "Failed. HTTP 301" / "HTTP ---" = no answer
	jmp	PutString
@msg:	jmp	status

; progress, called from the resident HTTP callback per KByte
; (the callback keeps its state in r0-r15: save all of them)
catProgress:
	ldx	#0
@save:	lda	r0, x
	pha
	inx
	cpx	#32
	bne	@save
	LoadW	r0, txtLoading
	jsr	status
	LoadW	r0, dlName
	jsr	PutString
	LoadW	r0, txtSep
	jsr	PutString
	MoveW	kbytes, r0
	lda	#SET_SURPRESS|SET_LEFTJUST
	jsr	PutDecimal
	LoadW	r0, txtKB
	jsr	PutString
	ldx	#31
@rest:	pla
	sta	r0, x
	dex
	bpl	@rest
	rts

;---------------------------------------------------------------------------
; data: VLIR record 4, loaded to $6000 by CatStart. $6000-$7FFF is free for
; applications under GEOS65 at a normal start (the kernal maps the
; background screen there only while drawing into it; the boot path saves
; and restores $5000-$7FFF). Overlay 2 itself only holds code.
.segment "OVERLAY4"
pageFirstLo:	.res	CAT_MAX_PAGES	; first entry of every page (from the catalog)
pageFirstHi:	.res	CAT_MAX_PAGES

catMenu:
	.byte	0, 14
	.word	0, 61
	.byte	HORIZONTAL | UN_CONSTRAINED | 2
	.word	txtGeos
	.byte	SUB_MENU
	.word	geosMenu
	.word	txtFile
	.byte	SUB_MENU
	.word	fileMenu
geosMenu:
	.byte	15, 29
	.word	0, 115
	.byte	VERTICAL | UN_CONSTRAINED | 1
	.word	txtInfo
	.byte	MENU_ACTION
	.word	doInfo
fileMenu:
	.byte	15, 57
	.word	26, 80
	.byte	VERTICAL | UN_CONSTRAINED | 3
	.word	txtOpen
	.byte	DYN_SUB_MENU
	.word	buildOpenMenu
	.word	txtClose
	.byte	MENU_ACTION
	.word	doClose
	.word	txtQuit
	.byte	MENU_ACTION
	.word	doQuit


infoDialog:
	.byte	$81
	.byte	OK
	.byte	17, 74
	.byte	DBTXTSTR, 10, 14
	.word	txtInfo1
	.byte	NULL

replaceDialog:
	.byte	$81
	.byte	YES
	.byte	1, 72
	.byte	NO
	.byte	17, 72
	.byte	DBTXTSTR, 10, 16
	.word	dlName
	.byte	DBTXTSTR, 10, 30
	.word	txtExists
	.byte	NULL

txtGeos:	.byte	"geos", NULL
txtFile:	.byte	"file", NULL
txtInfo:	.byte	"GeoSpace info", NULL
txtQuit:	.byte	"quit", NULL
txtInfo1:	.byte	BOLDON, "GeoSpace catalog", PLAINTEXT, NULL
txtExists:	.byte	"Replace?", NULL
hdrLine:	.byte	BOLDON, "Name", GOTOX
hdrX1:		.word	0
		.byte	"Class", GOTOX
hdrX2:		.word	0
		.byte	"Type", GOTOX
hdrX3:		.word	0
		.byte	"KB", GOTOX
hdrX4:		.word	0
		.byte	"Date", GOTOX
hdrX5:		.word	0
		.byte	"Author", GOTOX
hdrX6:		.word	0
		.byte	"M65 GEOS Ready", PLAINTEXT, NULL
txtPatch:	.byte	"PATCH", NULL
txtTested:	.byte	"TESTED", NULL
txtAppl:	.byte	"APPL", NULL
txtDAt:		.byte	"DA", NULL
txtHttp:	.byte	"http://", NULL
colFrac:	.byte	0, 46, 95, 112, 124, 154, 208	; column x = width * n / 256
txtUp:		.byte	"^", NULL
txtDown:	.byte	"v", NULL
txtSelect:	.byte	"Select.", NULL
txtSep:		.byte	"  -  ", NULL
txtKB:		.byte	" KB", NULL
txtDownload:	.byte	"Download", NULL
txtCancel:	.byte	"Cancel", NULL
txtDrive:	.byte	"Drive: ", NULL
txtConnect:	.byte	"Connecting", NULL
txtLoading:	.byte	"Get ", NULL
txtDone:	.byte	"Done.", NULL
txtFailed:	.byte	"Failed. HTTP ", NULL
txtCancelled:	.byte	"Stopped.", NULL
txtNoDisk:	.byte	"No disk.", NULL
txtDiskErr:	.byte	"Catalog error.", NULL
txtCvt:		.byte	".cvt", NULL
catClass:	.byte	"GSCatalog   V1.0", NULL
catId:		.byte	"GSC", 2		; catalog format version 2
sufHead:	.byte	" HTTP/1.0", CR, LF, "Host: ", NULL
sufTail:	.byte	CR, LF, "Connection: Close", CR, LF, CR, LF, NULL
txtOpen:	.byte	"open  >", NULL
txtClose:	.byte	"close", NULL
txtNoCat:	.byte	"No catalog open (file: open).", NULL
txtNoCatF:	.byte	"No catalog.", NULL

; variables and buffers (also in record 26 at $6000): during a download every
; byte of $5000-$5FFF is in use (network buffers, tx frame buffer $5800+,
; request buffer $5D00) and GEOS65 ReadFile uses $5000-$53BC.
scrR:		.word	0
scrB:		.word	0
btnY:		.word	0
detY:		.word	0
listB:		.word	0
sbarX:		.word	0
rows:		.byte	0
rowNo:		.byte	0
topIdx:		.word	0
selIdx:		.word	0
curIdx:		.word	0
curPage:	.byte	0
curK:		.byte	0
slotPage:	.byte	$FF, $FF	; page in buffer 0 ($5400) / 1 ($6800)
lastSlot:	.byte	0
curSlot:	.byte	0
slotLo:		.byte	<SLOT0, <SLOT1
slotHi:		.byte	>SLOT0, >SLOT1
tx:		.word	0
ty:		.word	0
rx1:		.word	0
ry1:		.word	0
rx2:		.word	0
ry2:		.word	0
mx:		.word	0
my:		.word	0
busy:		.byte	0
retries:	.byte	0
targetDrive:	.byte	8
dlDisk:		.byte	0
dateIdx:	.byte	0
noCat:		.byte	1		; 1: no catalog open
catDrive:	.byte	8
catEntries:	.word	0
catPages:	.byte	0
lastPage:	.byte	0
sufLen:		.byte	0
catName:	.res	17
nCats:		.byte	0
hostBuf:	.res	CAT_MAX_HOST+1
sufBuf:		.res	9+2+6+CAT_MAX_HOST+2+17+2+2+1
dlPatch:	.byte	0		; <> 0: entry marked M65 (patch step after the download)
d64Mode:	.byte	0		; <> 0: entry is a GEOS file in a .d64 image
dtValid:	.byte	0		; disk table loaded at DTAB
dlLocLen:	.byte	0
colPos:		.res	16		; x of the 7 columns + end
urlN:		.byte	0		; characters per URL line
clipX:		.word	0		; putClip: right limit
clipW:		.word	0
clipN:		.byte	0
urlOff:		.byte	0
urlLines:	.byte	0
hostIPbuf:	.res	4
dlName:		.res	17
dlFile:		.res	CAT_MAX_FILE+1		; download file name (URL encoded)
dlLoc:		.res	CAT_MAX_LOC+1		; "/docs/finke/<disk>/"
