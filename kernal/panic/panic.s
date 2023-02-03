; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Panic

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"

.segment "panic1"

.import DoDlgBox
.import Ddec
.import EnterDeskTop
.import UnmapUnderlay
.import DebugMain
.import _MapLow
.import tempIRQAcc

; syscall
.global _Panic

.ifdef gateway
_Panic:
	; On the gateWay KERNAL, the "Panic" syscall points to
	; the EnterDesktop implementation. The BRK vector still
	; points here though.
	;
	; This seems to deal with swapping the disk driver from
	; and to the REU, triggered by the RESTORE key.
	sei
	pha
	txa
	pha
	tya
	pha
	lda CPU_DATA
	pha
	ldx StackPtr
	bne @1
	tsx
@1:	txs
	stx StackPtr
	ldx #0
@2:	dex
	bne @2
	jsr SwapMemory
	jmp DISK_BASE

; ??? no entry?
	ldx StackPtr
	txs
	jsr SwapMemory
	stx StackPtr
	LoadW NMI_VECTOR, _Panic
	PopB CPU_DATA
	pla
	tay
	pla
	tax
	pla
	rti

SwapRegs:
	ldx #6
@1:	lda r0,x
	tay
	lda SwapRAMArgs,x
	sta r0,x
	tya
	sta SwapRAMArgs,x
	dex
	bpl @1
	rts

SwapMemory:
	jsr SwapRegs
	jsr SwapRAM
	jsr SwapRegs
	inx
	rts

SwapRAMArgs:
	.word DISK_BASE ; CBM addr
	.word dum$c000     ; REU addr
	.word 0         ; count
	.byte 0         ; REU bank

	.byte 0, 0 ; XXX

StackPtr:
	.byte 0

	.byte 0, 0, 0 ; PADDING

.else ; gateway
;---------------------------------------------------------------
; Panic                                                   $C2C2
;
; Pass:      nothing
; Return:    does not return
;---------------------------------------------------------------
_Panic:
.ifdef debugger

  pha   ; flags
  lda tempIRQAcc
  pha
  txa
  pha
  tya
  pha
  tza
  pha

  lda lowMap
  pha
  lda lowMapBnk
  pha

  lda #$80
  ldx #0
  jsr _MapLow

  ; unmap to $6000
  jsr DebugMain

  pla
  tax
  pla
  jsr _MapLow 

  pla
  taz
  pla
  tay
  pla
  tax
  pla

  rti

.else ; debugger
	inc $d020
	bra _Panic
.ifdef wheels
	sec
	pla
	sbc #2
	tay
	pla
	sbc #0
.else ; wheels
.ifdef mega65
	;LoadB CPU_DATA, IO_IN
@13:
	;lda countHighMap
	;beq @12
	;jsr UnmapUnderlay
	;bra @13
@12:
.endif ; mega65
.ifdef bsw128
	pla
	pla
	pla
	pla
	pla
	pla
	pla
	pla
.endif ; bsw128
	;PopW r0
.ifdef bsw128
	ldx #r0
	jsr Ddec
	ldx #r0
	jsr Ddec
.else ; bsw128
	SubVW 2, r0
.endif ; bsw128
	;lda r0H
.endif ; mega65
	;ldx #0
	jsr @1
.ifdef wheels
	tya
.else ; wheels
	lda r0L
.endif ; wheels
	jsr @1
	LoadW r0, _PanicDB_DT
	jsr DoDlgBox
.ifdef wheels
	jmp EnterDeskTop
.endif ; wheels
@1:	;pha
	;lsr
	;lsr
	;lsr
	;lsr
	;jsr @2
	inx
	pla
	and #%00001111
	jsr @2
	inx
	rts
@2:	cmp #10
	bcs @3
	addv '0'
	bne @4
@3:	addv '0'+7
@4:	sta _PanicAddr,x
	rts
.segment "panic2"

_PanicDB_DT:
	.byte DEF_DB_POS | 1
	.byte DBTXTSTR, TXT_LN_X, TXT_LN_1_Y
	.word _PanicDB_Str
.ifdef wheels
	.byte DBSYSOPV
.endif ; wheels
	.byte NULL

.segment "panic3"

_PanicDB_Str:
	;.byte BOLDON
.ifdef wheels_size
	;.byte ""
.else
	.byte "System error near "
.endif
.endif

	.byte "$"
_PanicAddr:
	.byte "xxxx"
	.byte NULL

.endif ; debugger
