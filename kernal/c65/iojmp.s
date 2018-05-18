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
.global __io_SetPattern
.global __io_GetRealSize

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

.segment "iojmp"

; DBIcPicOK                 00CFA2 RLA    
; BSWFont                   00D5AC RLA 
; BSWFont80                 00D894 RLA
; InitRamTab                00DC39 RLA  

__io_HorizontalLine:
    tax
    PushB  CPU_DATA
    LoadB CPU_DATA, RAM_64K
    txa
    jsr _HorizontalLine
__io_ret:
    PopB   CPU_DATA
    rts

__io_InvertLine:
    PushB  CPU_DATA
    LoadB CPU_DATA, RAM_64K
    jsr _InvertLine
    jmp __io_ret

__io_RecoverLine:
    PushB  CPU_DATA
    LoadB CPU_DATA, RAM_64K
    jsr _RecoverLine
    jmp __io_ret

__io_VerticalLine:
    tax
    PushB  CPU_DATA
    LoadB CPU_DATA, RAM_64K
    txa
    jsr _VerticalLine
    jmp __io_ret

__io_Rectangle:
    PushB  CPU_DATA
    LoadB CPU_DATA, RAM_64K
    jsr _Rectangle
    jmp __io_ret

__io_InvertRectangle:
    PushB  CPU_DATA
    LoadB CPU_DATA, RAM_64K
    jsr _InvertRectangle
    jmp __io_ret

__io_RecoverRectangle:
    PushB  CPU_DATA
    LoadB CPU_DATA, RAM_64K
    jsr _RecoverRectangle
    jmp __io_ret

__io_ImprintRectangle:
    PushB  CPU_DATA
    LoadB CPU_DATA, RAM_64K
    jsr _ImprintRectangle
    jmp __io_ret

__io_FrameRectangle:
    tax
    PushB  CPU_DATA
    LoadB CPU_DATA, RAM_64K
    txa
    jsr _FrameRectangle
    jmp __io_ret

__io_GraphicsString:
    PushB  CPU_DATA
    LoadB CPU_DATA, RAM_64K
    jsr _GraphicsString
    jmp __io_ret

__io_SetPattern:
    PushB  CPU_DATA
    LoadB CPU_DATA, RAM_64K
    jsr _SetPattern
    jmp __io_ret

__io_GetRealSize:
    ldy     CPU_DATA
    sty     @1 +1
    ldy     #RAM_64K
    sty     CPU_DATA
    jsr _GetRealSize
    pha
@1:
    lda #0
    sta CPU_DATA
    pla
    rts



