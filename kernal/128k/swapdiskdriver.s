; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Michael Steil, Maciej Witkowiak
;
; Disk driver management on 128K systems

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.segment "swapdiskdriver"

.global _SwapDiskDriver
_SwapDiskDriver:
.ifdef mega65
@HOHO:
inc $d020
jmp @HOHO
	; use DMAgic for swapping memory
	START_IO

	lda #0
	sta	$d702
	lda #>swapdddmalist
	sta $d701
	lda	#<swapdddmalist
	sta $d700

	; wait until done

	END_IO
.else
	lda config
	ora #1
	sta config ; disable I/O
	jsr PrepForFetch2
	jsr SwapMemory
	jsr PrepForFetch2
	lda config
	and #$FE
	sta config ; enable I/O
.endif
	rts

.ifdef mega65
swapdddmalist:
	.byte	4	; swap
	.word	DISK_DRV_LGH
	.word	DISK_BASE
	.byte	0				; bank 0
	.word	DISK_SWAPBASE+DISK_DRV_LGH
	.byte	1				; bank 1
	.word	0				; unsued mod

	.byte	4	; swap
	.word	DISK_DRV_LGH
	.word	DISK_SWAPBASE
	.byte	1				; bank 0
	.word	DISK_BASE
	.byte	0				; bank 1
	.word	0				; unsued mod

	.byte	0	; swap
	.word	DISK_DRV_LGH
	.word	DISK_SWAPBASE+DISK_DRV_LGH
	.byte	1				; bank 0
	.word	DISK_SWAPBASE
	.byte	1				; bank 1
	.word	0				; unsued mod
.endif

.if !.defined(mega65)
; XXX almost a copy of PrepForFetch
PrepForFetch2:
	ldy #5
@1:	lda r0,y
	tax
	lda SetDevTab2,y
	sta r0,y
	txa
	sta SetDevTab2,y
	dey
	bpl @1
	rts

SetDevTab2:
	.word DISK_BASE
	.word DISK_SWAPBASE
	.word DISK_DRV_LGH

; swap r2 bytes between r0 and r1
SwapMemory:
	PushB r0H
	PushB r1H
	PushB r2H
	ldy #$00
LF72E:	lda r2H
	beq LF748
LF732:	lda (r0),y
	tax
	lda (r1),y
	sta (r0),y
	txa
	sta (r1),y
	iny
	bne LF732
	inc r0H
	inc r1H
	dec r2H
	bra LF72E
LF748:	cpy  LF759
	lda (r0),y
	taxr2L
	beq
	lda (r1),y
	sta (r0),y
	txa
	sta (r1),y
	iny
	bne LF748
LF759:	PopB r2H
	PopB r1H
	PopB r0H
	rts
.endif
