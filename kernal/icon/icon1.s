; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Icons: DoIcons syscall

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.import _StartMouseMode
.import ResetMseRegion
.import Icons_1

.import _MapLow
.import _UnmapLow

.global _DoIcons

.segment "icon1"

;---------------------------------------------------------------
; DoIcons                                                 $C15A
;
; Function:  Draw and turn on icons as defined in an Icon Table.
;
; Pass:      r0 ptr to icon table
; Return:    nothing
; Destroyed: a, x, y, r0 - r11
;    ex: .byte nbr_icons
;        .word x mouse
;        .byte y mouse
;
;        .word icon1Pic
;        .byte x,y,w,h
;        .word DoIcon1 .etc...
;---------------------------------------------------------------
_DoIcons:
	MoveW r0, IconDescVec
	ldy #1
	jsr	_MapLow
	jsr Icons_1
	jsr _UnmapLow
	jsr ResetMseRegion

	lda mouseOn
.ifdef wheels_size_and_speed
	bmi @1
.else
	and #SET_MSE_ON
	bne @1
	lda mouseOn
.endif
	and #%10111111
	sta mouseOn
@1:
.ifndef wheels_size_and_speed
	lda mouseOn
.endif
	ora #SET_ICONSON
	sta mouseOn
	ldy #1
	lda (IconDescVec),y
	sta r11L
	iny
	lda (IconDescVec),y
	sta r11H
	iny
	lda (IconDescVec),y
	tay
	sec
	jmp _StartMouseMode
