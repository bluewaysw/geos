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
.ifdef mega65
; MEGA65: F011-Laufwerke (echtes Floppy, SD-Mount, virtuell) werden nativ
; formatiert (Quick-Format: Header, BAM und Directory eines D81 neu
; schreiben), ohne CBM-DOS-Kommandokanal. Die Diskette muss bereits
; D81-formatiert sein (z.B. mit HEADER "name" im BASIC). Ein
; Low-Level-Format (HEADER "name",I42) ist noch nicht implementiert.
; Alle anderen Typen benutzen weiter den IEC-Weg weiter unten.

DosFormat:	lda	curType
	and	#DRIVE_MASK
	cmp	#DRV_SD_81
	beq	@nat
	cmp	#DRV_F011_0
	beq	@nat
	cmp	#DRV_F011_1
	beq	@nat
	cmp	#DRV_F011_V
	bne	DosFormatIEC
@nat:	jmp	DosFormatNative
DosFormatIEC:
.else
DosFormat:
.endif
	PushW	r0
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

.ifdef mega65
;DosFormatNative
; Par:	r0: Zeiger auf Name als Geos-String (max. 16 Zeichen)
; Ret:	x = 0 : ok, sonst Fehlercode des Treibers
; Des:	a,y,r1,r4,diskBlkBuf
; Layout wie c1541/1581: 40/0 Header, 40/1 BAM Spur 1-40,
; 40/2 BAM Spur 41-80, 40/3 erster Directory-Block.
; Die ID ist "TD" wie beim IEC-Weg.
DosFormatNative:
	jsr	PurgeTurbo
	; --- 40/3: leeres Directory ---
	jsr	@clear
	lda	#$ff
	sta	diskBlkBuf+1
	ldx	#3
	jsr	@put
	beq	:+
	rts
:
	; --- 40/2: BAM Spur 41-80 ---
	jsr	@clear
	lda	#$ff
	sta	diskBlkBuf+1
	jsr	@bamhdr
	jsr	@bamfill
	ldx	#2
	jsr	@put
	beq	:+
	rts
:
	; --- 40/1: BAM Spur 1-40 ---
	jsr	@clear
	lda	#40
	sta	diskBlkBuf
	lda	#2
	sta	diskBlkBuf+1
	jsr	@bamhdr
	jsr	@bamfill
	lda	#36	; Spur 40: 36 frei, Sektoren 0-3 belegt
	sta	diskBlkBuf+$10+39*6
	lda	#$f0
	sta	diskBlkBuf+$10+39*6+1
	ldx	#1
	jsr	@put
	beq	:+
	rts
:
	; --- 40/0: Header ---
	; ACHTUNG: der F011-Treiber (ReadBlockDirBlock) vertauscht beim
	; Lesen/Schreiben von 40/0 die Bytes $04-$1C mit $90-$A8. Der Puffer
	; muss daher im GEOS-Layout vorliegen: DOS-Header-Bytes $04-$1C
	; stehen hier bei $90-$A8 (auf der Disk landen sie bei $04-$1C).
	jsr	@clear
	lda	#40
	sta	diskBlkBuf
	lda	#3
	sta	diskBlkBuf+1
	lda	#'D'
	sta	diskBlkBuf+2
	ldy	#$18
	lda	#$a0
@h1:	sta	diskBlkBuf+$90,y	; Name + Fuellbytes (Disk $04-$1C) mit $A0
	dey
	bpl	@h1
	ldy	#0
@h2:	lda	(r0),y		; Name kopieren (max. 16)
	beq	@h3
	sta	diskBlkBuf+$90,y
	iny
	cpy	#16
	bne	@h2
@h3:	lda	#'T'
	sta	diskBlkBuf+$a2
	lda	#'D'
	sta	diskBlkBuf+$a3
	lda	#'3'
	sta	diskBlkBuf+$a5
	lda	#'D'
	sta	diskBlkBuf+$a6
	lda	#$a0
	sta	diskBlkBuf+$a7
	sta	diskBlkBuf+$a8
	ldx	#0
	jsr	@put
	beq	:+
	rts
:
	; --- Disk neu einlesen und als GEOS-Disk kennzeichnen ---
	jsr	OpenDisk
	txa
	beq	:+
	rts
:
	jmp	SetGEOSDisk
@ret:	rts

@clear:	ldy	#0
	tya
@c1:	sta	diskBlkBuf,y
	iny
	bne	@c1
	rts

; x = Sektor auf Spur 40; Ergebnis: x = Fehlercode, Z-Flag gesetzt wenn ok
@put:	LoadB	r1L,40
	stx	r1H
	LoadW___	r4,diskBlkBuf
	jsr	PutBlock
	txa
	rts

; gemeinsamer BAM-Kopf (Bytes 2-6); Bytes 0/1 setzt der Aufrufer
@bamhdr:
	lda	#'D'
	sta	diskBlkBuf+2
	lda	#$bb
	sta	diskBlkBuf+3
	lda	#'T'
	sta	diskBlkBuf+4
	lda	#'D'
	sta	diskBlkBuf+5
	lda	#$c0	; I/O-Byte wie bei c1541
	sta	diskBlkBuf+6
	rts

; 40 Spureintraege ab $10: 40 freie Sektoren, alle Bits gesetzt
@bamfill:
	ldy	#$10
	ldx	#40
@b1:	lda	#40
	sta	diskBlkBuf,y
	iny
	lda	#$ff
	sta	diskBlkBuf,y
	iny
	sta	diskBlkBuf,y
	iny
	sta	diskBlkBuf,y
	iny
	sta	diskBlkBuf,y
	iny
	sta	diskBlkBuf,y
	iny
	dex
	bne	@b1
	rts
.endif
