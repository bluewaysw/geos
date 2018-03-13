; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; C64/REU driver

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

; syscalls
.global _DoRAMOp
.global _FetchRAM
.global _StashRAM
.global _SwapRAM
.global _VerifyRAM

.segment "reu"

.ifdef mega65

_StashRAM:
	START_IO_X
	MoveW r2, opLength
	MoveW r0, opFromAddr
	lda r1L
	sta	opToAddr
	lda r1H
	and #$7f
	sta opToAddr+1

	lda #>opddmalist
	ldy #<opddmalist
	
	jmp _DoRAMOp
	
_FetchRAM:
	START_IO_X

	LDA #$A5      ; C65: VIC-III enable sequence
	STA $D02F
	LDA #$96
	STA $D02F     ; C65: VIC-III enabled

	MoveW r2, opLength_fetch
	MoveW r0, opToAddr_fetch
	lda r1L
	sta	opFromAddr_fetch
	lda r1H
	and #$7f
	sta opFromAddr_fetch+1
	
	lda #>opddmalist_fetch
	ldy #<opddmalist_fetch
	
_DoRAMOp:

	sta $d701
	lda #0
	sta	$d702
	sta $d704	;	enhanced bank
	sty	$d705

	END_IO_X

_VerifyRAM:
_SwapRAM:
@3:	rts

opddmalist:
	; enchanced dma mode header
	.byte	$0a
	.byte	$80, $00
	.byte	$81, $FF
	.byte 	0
	.byte	0	; swap
opLength:
	.word	DISK_DRV_LGH
opFromAddr:
	.word	DISK_BASE
	.byte	0				; bank 0
opToAddr:
	.word	DISK_SWAPBASE+DISK_DRV_LGH
	.byte	8				; bank 1
	.word	0				; unsued mod

opddmalist_fetch:
	; enchanced dma mode header
	.byte	$0a
	.byte	$80, $ff
	.byte	$81, $00
	.byte	0
	.byte	0	; swap
opLength_fetch:
	.word	DISK_DRV_LGH
opFromAddr_fetch:
	.word	DISK_BASE
	.byte	8				; bank 0
opToAddr_fetch:
	.word	DISK_SWAPBASE+DISK_DRV_LGH
	.byte	0				; bank 1
	.word	0				; unsued mod

.else

.ifdef REUPresent
_VerifyRAM:
	ldy #$93
.ifdef wheels_size
	.byte $2c
.else
	bne _DoRAMOp
.endif
_StashRAM:
	ldy #$90
.ifdef wheels_size
	.byte $2c
.else
	bne _DoRAMOp
.endif
_SwapRAM:
	ldy #$92
.ifdef wheels_size
	.byte $2c
.else
	bne _DoRAMOp
.endif
_FetchRAM:
	ldy #$91
_DoRAMOp:
	ldx #DEV_NOT_FOUND
	lda r3L
	cmp ramExpSize
	bcs @3 ; beyond end of REU
.ifdef wheels
	php
	sei
	START_IO

	PushB clkreg
	LoadB clkreg, 0
	ldx #4
@1:	lda r0L-1,x
	sta EXP_BASE+1,x
	dex
	bne @1
	MoveW r2, EXP_BASE+7
	lda r3L
	sta EXP_BASE+6
	stx EXP_BASE+9
	stx EXP_BASE+10
	sty EXP_BASE+1
	ldx EXP_BASE+1
	PopB clkreg
	END_IO
	plp
	txa
	and #%01100000
	cmp #%01100000
	beq @2
	ldx #0
	.byte $2c
@2:	ldx #WR_VER_ERR
.else
.ifdef bsw128
	ldx clkreg
	LoadB clkreg, 0
.endif
	START_IO_X
	MoveW r0, EXP_BASE+2
	MoveW r1, EXP_BASE+4
	MoveB r3L, EXP_BASE+6
	MoveW r2, EXP_BASE+7
	lda #0
	sta EXP_BASE+9
	sta EXP_BASE+10
	sty EXP_BASE+1
@1:	lda EXP_BASE
	and #%01100000
	beq @1
.ifdef bsw128
	stx clkreg
.endif
	END_IO_X
	ldx #0
.endif
@3:	rts
.endif ; REUPresent
.endif

