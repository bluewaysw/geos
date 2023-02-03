; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Michael Steil, Maciej Witkowiak, Falk Rehwagen

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.global __io_HorizontalLine
.global __io_InvertLine
.global __io_RecoverLine
.global __io_VerticalLine
.global __io_Rectangle
.global __io_InvertRectangle
.global __io_RecoverRectangle
.global __io_ImprintRectangle
.global __io_FrameRectangle
.global __io_GraphicsString
.global __io_DrawLine
.global __io_DrawPoint
.global __io_TestPoint

.global __io_SetPattern
.import _HorizontalLine
.import _InvertLine
.import _RecoverLine
.import _VerticalLine
.import _Rectangle
.import _InvertRectangle
.import _RecoverRectangle
.import _ImprintRectangle
.import _FrameRectangle
.import _GraphicsString
.import _SetPattern
.import _GetScanLine
.import _GetRealSize
.import _DrawLine
.import _DrawPoint
.import _TestPoint

.segment "iojmp"

; DBIcPicOK                 00CFA2 RLA
; BSWFont                   00D5AC RLA
; BSWFont80                 00D894 RLA
; InitRamTab                00DC39 RLA

__io_loadRAM:
	LoadB CPU_DATA, RAM_64K
	rts

__io_HorizontalLine:
	tax
	PushB  CPU_DATA
	;LoadB CPU_DATA, RAM_64K
	jsr __io_loadRAM
	txa
	jsr _HorizontalLine
	bra __io_ret

__io_InvertLine:
	PushB  CPU_DATA
	;LoadB CPU_DATA, RAM_64K
	jsr __io_loadRAM
	jsr _InvertLine
	bra __io_ret

__io_RecoverLine:
	ldx	#7
	bra	callRoutineTab

__io_VerticalLine:
	tax
	PushB  CPU_DATA
	;LoadB CPU_DATA, RAM_64K
	jsr __io_loadRAM
	txa
	jsr _VerticalLine
__io_ret:
	PopB   CPU_DATA
	rts

__io_Rectangle:
	ldx	#7
	bra	callRoutineTab

__io_InvertRectangle:
	ldx	#6
	bra	callRoutineTab

__io_RecoverRectangle:
	ldx	#5
	bra	callRoutineTab

__io_ImprintRectangle:
	ldx 	#4
	bra	callRoutineTab

__io_FrameRectangle:
	tax
	PushB  CPU_DATA
	;LoadB CPU_DATA, RAM_64K
	jsr __io_loadRAM
	txa
	jsr _FrameRectangle
	bra __io_ret

__io_GraphicsString:
	ldx	#3
	bra	callRoutineTab

__io_SetPattern:
	PushB  CPU_DATA
	;LoadB CPU_DATA, RAM_64K
	jsr __io_loadRAM
	jsr _SetPattern
	bra __io_ret

__io_DrawLine:
	ldx	#0
	bra	callRoutineTab
__io_DrawPoint:
	ldx	#1
	bra	callRoutineTab
__io_TestPoint:
	ldx	#2
callRoutineTab:
	PushB  	CPU_DATA
	;LoadB 	CPU_DATA, RAM_64K
	jsr 	__io_loadRAM
	PushW	returnAddress
	lda	RoutineTabL, x
	sta	returnAddress
	lda	RoutineTabH, x
	sta	returnAddress+1
	jsr 	(returnAddress)
	PopW	returnAddress
	bra 	__io_ret

RoutineTabL:
	.byte	<_DrawLine, <_DrawPoint, <_TestPoint, <_GraphicsString, <_ImprintRectangle, <_RecoverRectangle, <_InvertRectangle, <_Rectangle, <_RecoverLine
RoutineTabH:
	.byte	>_DrawLine, >_DrawPoint, >_TestPoint, >_GraphicsString, >_ImprintRectangle, >_RecoverRectangle, >_InvertRectangle, >_Rectangle, >_RecoverLine
