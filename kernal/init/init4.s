; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Machine initialization: RAM initialization

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.import NumTimers
.import _Panic
.import _InterruptMain
.import clkBoxTemp
.ifdef mega65
.import __io_RecoverRectangle
.else
.import _RecoverRectangle
.endif

.global InitRamTab

.segment "init4"

InitRamTab:
	.word currentMode
	.byte 12
	.byte 0                       ; currentMode
	.byte ST_WR_FORE | ST_WR_BACK ; dispBufferOn
	.byte 0                       ; mouseOn
	.word mousePicData            ; msePicPtr
	ByteCY 0, 0                   ; windowTop
	ByteCY SC_FROM_END|0, SC_FROM_END|0
	                              ; windowBottom
	WordCX 0, 0                   ; leftMargin
	WordCX SC_FROM_END|0, SC_FROM_END|0
				      ; rightMargin
	.byte 0                       ; pressFlag

	.word appMain
	.byte 28
	.word 0                       ; appMain
	.word _InterruptMain          ; intTopVector
	.word 0                       ; intBotVector
	.word 0                       ; mouseVector
	.word 0                       ; keyVector
	.word 0                       ; inputVector
	.word 0                       ; mouseFaultVec
	.word 0                       ; otherPressVec
	.word 0                       ; StringFaultVec
	.word 0                       ; alarmTmtVector
	.word _Panic                  ; BRKVector
.ifdef mega65
	.word __io_RecoverRectangle       ; RecoverVector
.else
	.word _RecoverRectangle       ; RecoverVector
.endif
	.byte SelectFlashDelay        ; selectionFlash
	.byte 0                       ; alphaFlag
	.byte ST_FLASH                ; iconSelFlg
	.byte 0                       ; faultData

	.word NumTimers
	.byte 2
	.byte 0                       ; NumTimers
	.byte 0                       ; menuNumber

.ifdef bsw128
	.word clkBoxTemp
	.byte 2                       ; clkBoxTemp and L881A
	.word 0
.else
	.word clkBoxTemp
	.byte 1
	.byte 0                       ; clkBoxTemp

	.word IconDescVecH
	.byte 1
	.byte 0                       ; IconDescVecH
.endif

.ifdef wheels_dlgbox_dblclick
	.word   dblDBData
	.byte   1
	.byte   OPEN
.endif
	.word obj0Pointer
	.byte 8
	.byte $28, $29, $2a, $2b
	.byte $2c, $2d, $2e, $2f

	.word 0
