; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Machine initialization

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.import InitRamTab
.import _DoFirstInitIO
.import _InitRam

.global InitGEOEnv
.global _InitMachine
.ifdef bsw128
.global _InitMachine2
.endif
.ifdef mega65
.import MapUnderlay
.import UnmapUnderlay
.endif

.segment "init1"

_InitMachine:
.ifdef mega65
    jsr MapUnderlay
.endif
	jsr _DoFirstInitIO
.ifdef mega65
    jsr UnmapUnderlay
.endif
.if .defined(bsw128) || .defined(mega65)
.import SetRightMargin
.import SetNewMode0
_InitMachine2:
	jsr InitGEOEnv
	jmp SetNewMode0
.endif
InitGEOEnv:
	LoadW r0, InitRamTab
.if .defined(bsw128) || .defined(mega65)
	LoadB	CPU_DATA, RAM_64K
	jsr _InitRam
	LoadB	CPU_DATA, IO_IN
	jmp SetRightMargin
.else
.ifdef wheels
	.assert * = _InitRam, error, "Code must run into _InitRam"
.else
	jmp _InitRam
.endif
.endif

