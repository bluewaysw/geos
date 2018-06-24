; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; C128 graphics mode switching

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.import UseSystemFont
.ifndef mega65
.import SetColorMode
.endif

.global _GraphicsString
.global SetNewMode0

.segment "mode"

.ifndef mega65
.import SetVDCRegister
.endif
.global _SetNewMode
.global SetRightMargin
_SetNewMode:
	jsr SetRightMargin
SetNewMode0:
.ifdef bsw128
	lda grcntrl1
	bbrf 7, graphMode, @1
	and #%01101111
	sta grcntrl1
	lda vdcClrMode
	jmp SetColorMode
@1:	ora #%00010000
	and #%01111111
	sta grcntrl1
	ldx #26
	lda #0
	jsr SetVDCRegister
	dex
	lda #$80
	jmp SetVDCRegister
.else
	START_IO
    lda $d031
	bbrf 7, graphMode, @1

    ; 80 column mode
    ora #%10000000
    ;sta $d031
    END_IO
    rts
@1:
    ; 40 column mode
    and #%01111111
    ;sta $d031

    END_IO
    rts
.endif

SetRightMargin:
.ifdef bsw128
	lda #0
.endif
	ldx #>(SC_PIX_WIDTH-1)
	ldy #<(SC_PIX_WIDTH-1)
	bbrf 7, graphMode, @1
	LoadB L8890, $ff
.ifdef bsw128
	lda #1
.endif
	ldx #>(SCREENPIXELWIDTH-1)
	ldy #<(SCREENPIXELWIDTH-1)
@1:
.ifdef bsw128
	sta clkreg  ; D030
.endif
	stx rightMargin+1
	sty rightMargin
	jmp UseSystemFont
