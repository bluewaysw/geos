; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Michael Steil, Maciej Witkowiak, Falk Rehwagen
;
; C65 memory mapping utils
;
;   GEOS for C65 maps 2 memory areas:
;       4000-6000    (Low) Temporarily maps code/data to be used by the kernel (underlay from A000-C000)
;       A000-C000    (High) To map to video memory for for and background screen
;
;   Depending of how often this will be used, we migt make it macros later on

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.segment "map"

.global _MapLow
.global _UnmapLow
.global _TempUnmapLow
.global _MapHigh


;---------------------------------------------------------------
; MapHigh
;
; Maps the high area at $a000 according to the paramter
; Also remaps low area at $4000 even if tempUnMap was called.
;
; Pass:      y  page offset from $a000
; Return:    Nothing
; Destroyed: x, a, z
;---------------------------------------------------------------
_MapHigh:

    ; A low offset
    ; Y high offest
    ; X low map/offset high
    ; Z high map/offset hight

    ; y offset as parameter
	ldz #$20	; map $a000-$c000

    lda lowMap
    cmp #0
    beq @1

    ; setup low map state
    ldx #$40
    bra @2
@1:
	lda	#0	; don't map lower in this case
	tax
@2:

	map
	eom

    ; remember
    sty highMap

	rts


;---------------------------------------------------------------
; MapLow
;
; Pass:      y  0   restore last state (after temp unmap)
;               1   map from $a000 (underlay) to $4000
; Return:    Nothing
; Destroyed: x, a, z, y
;---------------------------------------------------------------
_MapLow:

    ; A low offset
    ; Y high offest
    ; X low map/offset high
    ; Z high map/offset hight

    ; y offset as parameter

    cpy #0
    bne @2

    ; use last map
    ldx #0      ; don't map
    lda lowMap
    beq @1
    ldx #$40
    bra @1

@2:
    ; assume y 1, so map
    lda #$60
    sta lowMap
    ldx #$40

@1:
    ; config High
	ldz #$20	; map $a000-$c000
    ldy highMap
	map
	eom

	rts


;---------------------------------------------------------------
; UnmapLow
;
; Pass:      Nothing
; Return:    Nothing
; Destroyed: x, a, z, y
;---------------------------------------------------------------
_UnmapLow:

    ; A low offset
    ; Y high offest
    ; X low map/offset high
    ; Z high map/offset hight

    ; y offset as parameter

    lda #0
    sta lowMap
    tax

    ; config High
	ldz #$20	; map $a000-$c000
    ldy highMap
	map
	eom

	rts


;---------------------------------------------------------------
; TempUnmapLow
;
; Pass:      Nothing
; Return:    Nothing
; Destroyed: x, a, z, y
;---------------------------------------------------------------
_TempUnmapLow:

    ; A low offset
    ; Y high offest
    ; X low map/offset high
    ; Z high map/offset hight

    ; y offset as parameter

    lda #0
    tax

    ; config High
	ldz #$20	; map $a000-$c000
    ldy highMap
	map
	eom

	rts
