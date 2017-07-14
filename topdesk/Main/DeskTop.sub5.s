.segment "OVERLAY5"
;	n	"DeskMod E"
;if .p
.include "topdesk/Include/Symbol/TopSym.inc"
.include "geosmac.inc"
.include "topdesk/Include/Symbol/Sym128.erg.inc"
.include "topdesk/Include/Symbol/CiSym.inc"
.include "topdesk/Include/Symbol/CiMac.inc"
;	t	"DeskWindows..ext"
;	t	"DeskTop.main.ext"
;endif
;	o	DispJumpTable

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
.ifdef topdesk128
.global SchmalFlag
.endif

FILE_ANZ = 16

	jmp	_MyDispFiles
	jmp	_DispFiles
	jmp	_MyCheckFiles
	jmp	_CheckFiles
	jmp	_GetFileRect
_MyDispFiles:	jsr	MyDCFilesSub
_DispFiles:	; Darstellung von FILE_ANZ Fileintr{gen im Textwindow
	; Par: r0: Zeiger auf File/Icontabelle (Aufbau s. Tabelle)
	;      a5: x-Koordinate
	;      r2L y-Koordinate der linken oberen Ecke der Darstellung
	;      Icon wird ggf. nachgeladen
	;      messageBuffer+1 : WindowNummer
	; Des: a1, a2, a3, a4, a5
	ldx	messageBuffer+1
	lda	winMode,x
	cmp	DispMode
	beq	@0009
	ldx	#0
	rts
@0009:	MoveB	r2L,a3H
	lda	#0
	jsr	SetPattern
	jsr	NewRectangle
	jsr	SetTextWin
	LoadB	a3L,0	; a3L = Nummer des aktl. Files
	AddVB	10,a3H	; a3H = n{chste y-Koordinate
	PushW	r0
	LoadW___	r0,University
	jsr	LoadCharSet
	jsr	@sub1	; a4 = xk := auf Zeilenanfang
	PopW	r0
	lda	r0L	; a1 = r0
	sta	a1L	; a2 = r0 + FILE_ANZ * 18
	clc
	adc	#<(FILE_ANZ*18)
	sta	a2L
	lda	r0H
	sta	a1H
	adc	#>(FILE_ANZ*18)
	sta	a2H
	; Darstellung des Icons, auf dessen Bitmap a2 zeigt, an der Position
	; a4/a3H
@05:	ldy	#00	; Eintrag aktiv ?
	lda	(a1),y
	bne	@05a	; >ja
	jmp	@010
@05a:	lda	(a2),y	; Bitmap vorhanden?
	cmp	#$bf
	beq	@004	; >ja   
	jsr	@geticon
	txa
	beq	@004
	txa
	pha
	jsr	UseSystemFont
	jsr	ClearMultiFile
	pla
	tax
	rts
@004:	lda	a4L
	sta	r3L
	clc
	adc	#24
	sta	r4L
	lda	a4H
	sta	r3H
	adc	#0
	sta	r4H
	lda	a3H
	sta	r2L
	clc
	adc	#21
	sta	r2H
	jsr	GetClipRec
.ifdef topdesk128
    lda SchmalFlag
    cmp #'*'
    beq @sc10
    lda r3H
    ora #$80
    sta r3H
    lda r4H
    ora #$a0
    sta r4H
    ldx #r3
    jsr NormalizeX
    ldx #r4
    jsr NormalizeX
@sc10:
.endif
	jsr	CutRec
	bcs	@005
	MoveW_	a2,r0
	MoveW_	a4,r10
	LoadB	r13L,3	; Breite immer 3
	LoadB	r13H,21	; H|he immer 21
.ifdef topdesk128
    lda SchmalFlag
    cmp #'*'
    beq @sc20
    lda r10H
    ora #$80
    sta r10H
    LoadB   r13L, $83
@sc20:
.endif

	ldx	a3H
	jsr	DrawMap
	; Darstellung des Filenames, auf dessen Text a1 zeigt, zentriert
	; an der Position a4+12, a3H+27
@005:
    lda	a4L
	clc
	adc	#12
	sta	r11L
	lda	a4H
	adc	#00
	sta	r11H
.ifdef topdesk128
    lda SchmalFlag
    cmp #'*'
    beq @sc30
    lda r11H
    ora #$80
    sta r11H
    ldx #r11
    jsr NormalizeX
    LoadB   @scy, 27
    lda graphMode
    bpl @sc30
    lda SchmalFlag
    cmp #'*'
    beq @sc30
    jsr UseSystemFont
    inc @scy
@sc30:
.endif

	MoveW_	a1,r0	; Filenamenzeiger setzen
	ldy	#16
	lda	(r0),y
	pha
	lda	#00
	sta	(r0),y
	jsr	StringLen	; L{nge ermitteln
	MoveW_	r1,r4
	lsr	r1H	; L{nge durch 2
	ror	r1L
	SubW	r1,r11	; xk:=xk-Len / 2
	lda	a3H	; yk:=a3H + 27
	clc
.ifdef topdesk128
	adc	@scy
.else
	adc	#27
.endif
	sta	r1H
	lda	r11L
	sta	r3L
	clc
	adc	r4L
	sta	r4L
	lda	r11H
	sta	r3H
	adc	r4H
	sta	r4H
	lda	r1H
	clc
	adc	#1
	sta	r2H
	sec
	sbc	#6
	sta	r2L
	jsr	GetClipRec
	jsr	CutRec
	bcs	@nicht
	jsr	NewPutString	; String ausgeben
@nicht:	ldy	#16	; Stringende wiederherstellen
	pla
	sta	(a1),y
@010:	ldx	a3L
	inx
	stx	a3L
	cpx	#FILE_ANZ
	beq	@end
	txa
	and	#%11	; durch 4 teilbar ?
	bne	@10	; >nein
	AddVB	33,a3H	; yk=yk+33
	jsr	@sub1	; xk auf Zeilenanfang
	jmp	@20
@10:	AddvW	60,a4
@20:	AddvW	18,a1	; n{chsten Namen und
	AddvW	64,a2	; n{chstes Icon einstellen
	jmp	@05	; Icon darstellen
.ifdef topdesk128
@scy:   .byte   27
.endif
@end:	lda	messageBuffer+1
	cmp	activeWindow
	bne	@e10
	jsr	DispMarking
@e10:	jsr	UseSystemFont
	ldx	#0
	rts
@sub1:	lda	a5L
	clc
	adc	#30
	sta	a4L
	lda	a5H
	adc	#00
	sta	a4H
.ifdef topdesk128
    lda graphMode
    bpl @send
    lda SchmalFlag
    cmp #'*'
    beq @send
    AddVW__    5, a4
	jsr	DispNumber
    AddVW__  25, a4
    lsr a4H
    ror a4L
	rts
@send:
.endif
	jsr	DispNumber
    rts
@geticon:	; Icon nachladen
	ldy	#16
	lda	(a1),y
	beq	@g2
	sta	r1L
	iny
	lda	(a1),y
	sta	r1H
	LoadW___	r4,$8000
	jsr	GetBlock
	txa
	beq	@g0
	rts
@g0:	ldy	#63
@g1:	lda	$8000+4,y
	sta	(a2),y
	dey
	bpl	@g1
	rts
@g2:	ldy	#63
@g3:	lda	C64Icon,y
	sta	(a2),y
	dey
	bne	@g3
	lda	#$bf
	sta	(a2),y
	ldx	#0
	rts

DispNumber:	; Darstellung der aktuellen Filenummer an der Position a4-20/a3H+6
.ifdef topdesk128
    lda graphMode
    bpl @10
    lda SchmalFlag
    cmp #'*'
    beq @10
    jsr UseSystemFont
@10:
.endif
	lda	a3L	; Nummer (0-15) holen
	ldx	messageBuffer+1	; Windownummer holen
	clc
	adc	windowOffs,x	; Nummer angleichen (0-143)
	sta	r0L
	LoadB	r0H,0
	lda	a4L
	sec
	sbc	#20
	sta	r11L
	lda	a4H
	sbc	#00
	sta	r11H
	lda	a3H
	clc
	adc	#10
	sta	r1H
	lda	#%11000000
	jmp	PutDecimal

_MyCheckFiles:	jsr	MyDCFilesSub
_CheckFiles:	; Auswertung eines Mausklicks innerhalb des Textfenstern im Bezug
	; auf die von DispFiles dargestellten Files
	; Par:	Textfenster (windowTop-RightMargin)
	; 	Mauskoordinaten ($3a-$3c)
	;	a5/r2L linke obere Ecke der Darstellung
	; Ret:	x : Nummer des Eintrags (0-FILE_ANZ, $ff f}r None)
	; 	r2-r4: Rechteck des Icons
	; Des:	a2,a3
	MoveB	r2L,a2L
	MoveW_	a5,a3
	lda	#00
@05:	jsr	GetFileRect	; Iconrechteck holen
	bcs	@06	; g}ltig? >nein
	pha
	jsr	IsMseInRegion
	bne	@10
	pla
@06:	clc
	adc	#1
	cmp	#FILE_ANZ
	bne	@05
	ldx	#$ff
	rts
@10:	pla
	tax
	rts

_GetFileRect:	; Ermittlung des Iconrechtecks eines Files einer DispFile-Darstellung
	; im Bezug auf das Textfenster
	; Par:	Textfenster (windowTop-rightMargin)
	;	a: Nummer des Files (0-(FILE_ANZ-1))
	;	a2L,a3: linkere oberere Ecke der Darstellung
	; Ret:	r2-r4: Rechteck-Koordinaten
	; Des:	x,y,r1,...
	pha
	and	#%11
	sta	r3L
	LoadB	r3H,0
	LoadW___	r4,60
	ldx	#r3
	ldy	#r4
	jsr	DMult
	AddvW	30,r3
	; Jetzt steht in r3 die linke x-Koordinate
	pla		; Nummer holen
	pha
	lsr		; durch 4
	lsr
	sta	r2L
	LoadB	r2H,0
	LoadW___	r4,33
	ldx	#r2
	ldy	#r4
	jsr	DMult
	lda	r2L
	clc
	adc	#10
	sta	r2L
	; Jetzt steht in r2L die obere y-Koordinate
.ifndef topdesk128
	AddW	a3,r3
.endif
	AddB_	a2L,r2L
	bcs	@err	; y-Koordinate zu gro~!
	clc
	adc	#20
	sta	r2H
	; Jetzt steht in r2H die untere y-Koordinate
	lda	r3L
	clc
	adc	#23
	sta	r4L
	lda	r3H
	adc	#00
	sta	r4H
	; Jetzt steht in r4 die rechte x-Koordinate
.ifdef topdesk128
    lda SchmalFlag
    cmp #'*'
    beq @sc10
    lda r3H
    ora #$80
    sta r3H
    lda r4H
    ora #$a0
    sta r4H
    ldx #r3
    jsr NormalizeX
    ldx #r4
    jsr NormalizeX
@sc10:
    AddW    a3, r3
    AddW    a3, r4
.endif

	jsr	GetClipRec
	jsr	CutRec	; Schnittfl{che berechnen, Ende
	pla
	rts
@err:	pla
	sec		; Rechteck ung}ltig
	rts
C64Icon:	;j 
.incbin "topdesk/C64Icon.bf"

