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

REU_BASE_BANK = $00

_StashRAM:
	lda	#0
	sta	opFromBankLow
	sta	opFromBankHigh+1


	;LDA #$A5      ; C65: VIC-III enable sequence
	;STA $D02F
	;LDA #$96
	;STA $D02F     ; C65: VIC-III enabled

	jsr	_GetBankParams
	sty	opToBankLow
	sta	opToBankHigh+1
	
	lda	r0L
	sta	opFromAddr
	lda	r0H
	;ldx	r1L
	ldy	r1H


_RamOp:
	sta	opFromAddr+1
	stx	opToAddr
	sty	opToAddr+1
	MoveW r2, opLength

	START_IO_X

	lda	#>opddmalist
	ldy	#<opddmalist

	sta	$d701
	;lda	#0
	sty	$d705

	END_IO_X

	rts

; input: A=0
_GetBankParams:
	sta	$d702
	sta 	$d704	;	enhanced bank
	;ldy	#5
	;lda	#0
	;bne	@1
	
	lda	r3L

	tax	
	and	#$0F
	;lda	#5
	tay
	txa
	lsr	
	lsr
	lsr
	lsr
	
	ora	#$80
	;lda	#0
@1:
	ldx	r1L
	rts


_DoRAMOp:
	cpy	#%10010000
	beq	_StashRAM
_FetchRAM:
	lda	#0
	sta	opToBankLow
	sta	opToBankHigh+1

	jsr	_GetBankParams
	sty	opFromBankLow
	sta	opFromBankHigh+1

	;lda	r1L
	stx	opFromAddr
	lda	r1H
	ldx	r0L
	ldy	r0H

	bra	_RamOp
	
	
_VerifyRAM:
_SwapRAM:
@3:	rts

opddmalist:
	; enchanced dma mode header
	.byte	$0a
opFromBankHigh:
	.byte	$80, $00
opToBankHigh:
	.byte	$81, $00
	.byte 	0
	.byte	0	; swap
opLength:
	.word	DISK_DRV_LGH
opFromAddr:
	.word	DISK_BASE
opFromBankLow:
	.byte	0				; bank 0
opToAddr:
	.word	DISK_SWAPBASE+DISK_DRV_LGH
opToBankLow:
	.byte	5				; bank 1
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
