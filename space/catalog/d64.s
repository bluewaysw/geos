;**
;* GeoSpace: extract a GEOS file from a .d64 image while it is downloaded
;* (VLIR record 5, runs at $7400; tables in $6800-$73FF)
;*
;* The image is read as an HTTP stream several times; nothing of it is
;* stored on disk:
;*   pass 1  link bytes of all 683 sectors, directory (track 18) -> entry,
;*           VLIR index block if it comes after the directory
;*   pass 2  (only if needed) VLIR index block
;*   plan    target blocks for header, index and all record chains
;*           (SetNextFree, BAM written at once)
;*   pass 3  every needed sector is written to its target block as it
;*           arrives, links / index entries rewritten; then the directory
;*           entry is created
;* On any error all allocated blocks are freed again.
;*
;* Entries (jump table at $7400):
;*   D64Init   once per download: A/X = GEOS file name in the image
;*   D64Begin  before every request: restart the stream, set bodyVec
;*   D64Next   request complete: A = 1 another pass, A = 0 done
;*             (lastConvertErr = 0 ok, $FD error)
;*   D64Abort  download cancelled: free allocated blocks
;*

.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"
.include "geosmac.inc"

.import bodyVec, lastConvertErr, downloadTimeout, kbytes, callProgress

LINKS	= $6800			; 683 * (track, sector) of every source sector
MAPT	= $6D60			; 683 * target (track, sector), 0 = not needed
SECBUF	= $72C0			; current sector (256 bytes)
NSEC	= 683			; 35 tracks

lp	= a6			; LINKS + 2*sector
lpL	= a6L
lpH	= a6H
mp	= a7			; MAPT + 2*sector
mpL	= a7L
mpH	= a7H

.segment "OVERLAY5"

	jmp	D64Init
	jmp	D64Begin
	jmp	D64Next
	jmp	D64Abort

;---------------------------------------------------------------------------
D64Init:
	sta	r9L			; copy the name (A/X) to nameBuf
	stx	r9H
	ldy	#0
@nm:	lda	(r9), y
	sta	nameBuf, y
	beq	@nmE
	iny
	cpy	#16
	bne	@nm
	lda	#0
	sta	nameBuf, y
@nmE:
	LoadB	pass, 1
	lda	#0
	sta	found
	sta	idxGot
	sta	allocated
	rts

D64Begin:
	lda	#0
	sta	secIdx
	sta	secIdx+1
	sta	byteIdx
	sta	err
	sta	kbCnt
	LoadW	bodyVec, d64Body
	rts

;---------------------------------------------------------------------------
; body data from the HTTP callback: r0 = available, r1 = used, r2 = pointer
d64Body:
	php
	sei
	LoadW	downloadTimeout, 50*30
	plp
@loop:	CmpW	r1, r0
	beq	@done
	ldy	#0
	lda	(r2), y
	jsr	doByte
	IncW	r1
	IncW	r2
	jmp	@loop
@done:	rts

; one byte of the image
doByte:	sta	cur
	lda	secIdx+1		; beyond the 683 sectors (error info): ignore
	cmp	#>NSEC
	bcc	@inImg
	bne	@out
	lda	secIdx
	cmp	#<NSEC
	bcc	@inImg
@out:	rts
@inImg:	ldy	byteIdx
	bne	@body
	jsr	secStart		; first byte of a sector
	ldy	#0
@body:	lda	pass
	cmp	#1
	beq	@scan
	cmp	#2
	beq	@idx
	; pass 3: needed sectors to SECBUF, written at their end
	lda	isNeeded
	beq	@next
	lda	cur
	sta	SECBUF, y
	cpy	#255
	bne	@next
	jsr	flushSector
	jmp	@next
@scan:	cpy	#2			; link bytes of every sector
	bcs	@noLink
	lda	cur
	sta	(lp), y
@noLink:
	lda	isDir
	beq	@sIdx
	lda	cur
	sta	SECBUF, y
	cpy	#255
	bne	@sIdx
	jsr	scanDir
	ldy	#255
@sIdx:
@idx:	lda	isIdx			; VLIR index block
	beq	@next
	lda	cur
	sta	idxBuf, y
	cpy	#255
	bne	@next
	LoadB	idxGot, 1
@next:	inc	byteIdx
	bne	@r
@skip:	IncW	secIdx			; next sector
	inc	kbCnt			; progress every 4 sectors (1 KB)
	lda	kbCnt
	and	#3
	bne	@r
	IncW	kbytes
	jsr	callProgress
@r:	rts

; at the first byte of a sector: pointers and flags
secStart:
	lda	secIdx			; lp/mp = table + 2*sector
	asl
	sta	r9L
	lda	secIdx+1
	rol
	sta	r9H
	lda	r9L
	clc
	adc	#<LINKS
	sta	lpL
	lda	r9H
	adc	#>LINKS
	sta	lpH
	lda	r9L
	clc
	adc	#<MAPT
	sta	mpL
	lda	r9H
	adc	#>MAPT
	sta	mpH
	ldy	#0			; needed: target block assigned
	lda	(mp), y
	sta	isNeeded
	lda	#0			; index block (once the entry is known)
	sta	isIdx
	lda	found
	beq	@noI
	lda	idxGot
	bne	@noI
	CmpW	secIdx, idxL
	bne	@noI
	LoadB	isIdx, 1
@noI:	lda	#0			; directory: track 18, sectors 1-18
	sta	isDir
	lda	found
	bne	@noD
	lda	secIdx
	sec
	sbc	#<(T18+1)
	tax
	lda	secIdx+1
	sbc	#>(T18+1)
	bne	@noD
	cpx	#18
	bcs	@noD
	LoadB	isDir, 1
@noD:	rts

T18	= 17*21			; first sector of track 18

;---------------------------------------------------------------------------
; directory sector in SECBUF: look for the file
scanDir:
	ldx	#0			; entry offset
@entry:	lda	SECBUF+2, x		; file type (0 = free)
	beq	@nextE
	ldy	#0
@cmp:	lda	nameBuf, y
	beq	@end
	cmp	SECBUF+5, x
	bne	@nextE
	inx
	iny
	cpy	#16
	bne	@cmp
	beq	@match
@end:	lda	SECBUF+5, x		; rest of the 16 characters: $A0
	cmp	#$A0
	bne	@nextE
	inx
	iny
	cpy	#16
	bne	@end
@match:	txa				; back to the entry start
	sec
	sbc	#16
	tax
	ldy	#0
@copy:	lda	SECBUF+2, x
	sta	dirEnt, y
	inx
	iny
	cpy	#30
	bne	@copy
	lda	dirEnt+1		; index block
	ldx	dirEnt+2
	jsr	secOf
	MoveW	r9, idxL
	lda	dirEnt+19		; header block
	ldx	dirEnt+20
	jsr	secOf
	MoveW	r9, hdrL
	LoadB	found, 1
	rts
@nextE:	txa				; next entry (x may have advanced)
	and	#$E0
	clc
	adc	#32
	tax
	bne	@entry
	rts

; A = track, X = sector -> r9 = sector number in the image, carry set if invalid
secOf:	cmp	#1
	bcc	@bad
	cmp	#36
	bcs	@bad
	tay
	stx	r9L
	txa
	cmp	sectors-1, y
	bcs	@bad
	lda	r9L
	clc
	adc	tstartL-1, y
	sta	r9L
	lda	tstartH-1, y
	adc	#0
	sta	r9H
	clc
	rts
@bad:	sec
	rts

;---------------------------------------------------------------------------
; pass 3: write the sector in SECBUF to its target block
flushSector:
	CmpW	secIdx, idxL
	bne	@data
	ldx	#2			; index block: map every record start
@rec:	lda	SECBUF, x
	beq	@nr
	stx	recX
	ldy	SECBUF+1, x
	jsr	mapTS
	ldx	recX
	sta	SECBUF, x
	tya
	sta	SECBUF+1, x
@nr:	inx
	inx
	bne	@rec
	jmp	@write
@data:	CmpW	secIdx, hdrL		; header block: link 00 FF, keep
	beq	@write
	lda	SECBUF			; data block: map the link
	beq	@write
	ldy	SECBUF+1
	jsr	mapTS
	sta	SECBUF
	sty	SECBUF+1
@write:	PushW	r0
	PushW	r1
	PushW	r2
	ldy	#0
	lda	(mp), y
	sta	r1L
	iny
	lda	(mp), y
	sta	r1H
	LoadW	r4, SECBUF
	jsr	PutBlock
	txa
	beq	@ok
	LoadB	err, 1
@ok:	IncW	written
	PopW	r2
	PopW	r1
	PopW	r0
	rts

; A/Y = source track/sector -> A/Y = target track/sector (err if unknown)
mapTS:	pha
	tya
	tax				; X = sector
	pla				; A = track
	jsr	secOf
	bcs	@bad
	jsr	mapPtr			; r8 -> MAPT entry of r9
	ldy	#0
	lda	(r8), y
	beq	@bad
	pha
	iny
	lda	(r8), y
	tay
	pla
	rts
@bad:	LoadB	err, 1
	lda	#0
	tay
	rts

; r8 = MAPT + 2 * r9
mapPtr:	lda	r9L
	asl
	sta	r8L
	lda	r9H
	rol
	sta	r8H
	AddVW	MAPT, r8
	rts

;---------------------------------------------------------------------------
; request complete
D64Next:
	lda	err
	bne	@fail
	lda	pass
	cmp	#3
	beq	@final
	lda	found			; pass 1 / 2
	beq	@fail
	lda	idxGot
	bne	@plan
	lda	pass
	cmp	#2
	beq	@fail			; index block not found in pass 2 either
	LoadB	pass, 2
	lda	#1
	rts
@plan:	jsr	plan
	bcs	@fail
	LoadB	pass, 3
	lda	#1
	rts
@final:	CmpW	written, count		; every block written?
	bne	@fail
	jsr	dirEntry
	bcs	@fail
	LoadB	lastConvertErr, 0
	LoadW	bodyVec, 0
	lda	#0
	rts
@fail:	jsr	D64Abort
	LoadB	lastConvertErr, $FD
	lda	#0
	rts

; download cancelled or failed: free the allocated blocks
D64Abort:
	LoadW	bodyVec, 0
	lda	allocated
	beq	@r
	LoadW	abortIdx, 0
@loop:	MoveW	abortIdx, r9
	jsr	mapPtr
	ldy	#0
	lda	(r8), y
	beq	@next
	sta	r6L
	iny
	lda	(r8), y
	sta	r6H
	jsr	FreeBlock
@next:	IncW	abortIdx
	CmpWI	abortIdx, NSEC
	bne	@loop
	jsr	PutDirHead
	LoadB	allocated, 0
@r:	rts

;---------------------------------------------------------------------------
; allocate target blocks for header, index and all record chains
plan:	LoadW	r0, NSEC*2		; clear the target table
	LoadW	r1, MAPT
	jsr	ClearRam
	lda	#0
	sta	count
	sta	count+1
	sta	written
	sta	written+1
	sta	r3L			; search free blocks from the start
	sta	r3H
	LoadB	allocated, 1
	MoveW	hdrL, r9
	jsr	alloc
	bcs	@err
	MoveW	idxL, r9
	jsr	alloc
	bcs	@err
	ldx	#2			; every record chain
@rec:	lda	idxBuf, x
	beq	@nextR
	stx	recX
	pha
	lda	idxBuf+1, x
	tax				; X = sector
	pla				; A = track
@chain:	jsr	secOf
	bcs	@err
	jsr	alloc
	bcs	@err
	lda	r9L			; next sector from the link table
	asl
	sta	r8L
	lda	r9H
	rol
	sta	r8H
	AddVW	LINKS, r8
	ldy	#0
	lda	(r8), y
	beq	@endC			; last block of the chain
	pha
	iny
	lda	(r8), y
	tax
	pla
	jmp	@chain
@endC:	ldx	recX
@nextR:	inx
	inx
	bne	@rec
	jsr	PutDirHead		; keep the allocation on disk
	txa
	bne	@err
	clc
	rts
@err:	sec
	rts

; target block for source sector r9 (error if used twice)
alloc:	jsr	mapPtr
	ldy	#0
	lda	(r8), y
	bne	@err			; loop or cross-linked chain
	PushW	r8
	PushW	r9
	jsr	SetNextFree		; r3 = next free block
	PopW	r9
	PopW	r8
	txa
	bne	@err
	ldy	#0
	lda	r3L
	sta	(r8), y
	iny
	lda	r3H
	sta	(r8), y
	IncW	count
	clc
	rts
@err:	sec
	rts

;---------------------------------------------------------------------------
; directory entry of the new file
dirEntry:
	LoadB	r10L, 0
	jsr	GetFreeDirBlk		; r1 = directory block, Y = entry in diskBlkBuf
	txa
	bne	@err
	sty	dirY			; (mapPtr uses r8)
	MoveW	idxL, r9		; new index and header blocks
	jsr	mapPtr
	ldy	#0
	lda	(r8), y
	sta	dirEnt+1
	iny
	lda	(r8), y
	sta	dirEnt+2
	MoveW	hdrL, r9
	jsr	mapPtr
	ldy	#0
	lda	(r8), y
	sta	dirEnt+19
	iny
	lda	(r8), y
	sta	dirEnt+20
	MoveW	count, dirEnt+28	; size in blocks
	ldx	dirY
	ldy	#0
@copy:	lda	dirEnt, y
	sta	diskBlkBuf, x
	inx
	iny
	cpy	#30
	bne	@copy
	LoadW	r4, diskBlkBuf
	jsr	PutBlock
	txa
	bne	@err
	jsr	PutDirHead
	txa
	bne	@err
	LoadB	allocated, 0		; the blocks belong to the file now
	clc
	rts
@err:	sec
	rts

;---------------------------------------------------------------------------
sectors:	.byte	21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21
		.byte	19,19,19,19,19,19,19
		.byte	18,18,18,18,18,18
		.byte	17,17,17,17,17
.define TSTART 0,21,42,63,84,105,126,147,168,189,210,231,252,273,294,315,336,357,376,395,414,433,452,471,490,508,526,544,562,580,598,615,632,649,666
tstartL:	.lobytes TSTART
tstartH:	.hibytes TSTART

pass:		.byte	0
found:		.byte	0
idxGot:		.byte	0
allocated:	.byte	0
err:		.byte	0
cur:		.byte	0
byteIdx:	.byte	0
secIdx:		.word	0
kbCnt:		.byte	0
isDir:		.byte	0
isIdx:		.byte	0
isNeeded:	.byte	0
idxL:		.word	0
hdrL:		.word	0
count:		.word	0
written:	.word	0
recX:		.byte	0
dirY:		.byte	0
abortIdx:	.word	0
nameBuf:	.res	17
dirEnt:		.res	30
idxBuf:		.res	256
