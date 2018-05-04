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
.ifdef mega65
.import _PutChar2
.endif
.global _PutString

.segment "conio3a"

_PutString:
.ifdef mega65
	PushB CPU_DATA
	LoadB	CPU_DATA, RAM_64K
.endif
@3:
	ldy #0
	lda (r0),y
	beq @2
.ifdef mega65
	jsr _PutChar2
.else
	jsr _PutChar
.endif
	inc r0L
	bne @1
	inc r0H
@1:	bra @3
@2:
.ifdef mega65
	PopB CPU_DATA
.endif
	rts

