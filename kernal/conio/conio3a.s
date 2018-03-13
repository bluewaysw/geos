; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Console I/O: PutString syscall

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.import _PutChar
.global _PutString

.ifdef mega65
.import _MapLow
.import _UnmapLow
.endif

.segment "conio3a"

_PutString:
;;    ldy #1
 ;   jsr _MapLow
	ldy #0
	lda (r0),y
	beq @2
	jsr _PutChar
	inc r0L
	bne @1
	inc r0H
@1:	bra _PutString
@2:
;	jsr _UnmapLow
	rts

