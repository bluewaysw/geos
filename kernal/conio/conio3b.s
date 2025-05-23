; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Console I/O: UseSystemFont, LoadCharSet, GetCharWidth syscalls

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.global _LoadCharSet

.import BSWFont

.if .defined(trap2) && (!.defined(trap2_alternate_location))
.import GetSerialNumber2
.import SerialHiCompare
.endif

.ifdef bsw128
.import BSWFont80
.endif
.ifdef mega65
.import BSWFont80
.endif

.ifdef bsw128
; XXX back bank, yet var lives on front bank!
PrvCharWidth = $880D
.else
.import PrvCharWidth
.endif

.global GetChWdth1
.global _UseSystemFont
.global _GetCharWidth

.segment "conio3b"

_UseSystemFont:
.if .defined(bsw128) || .defined(mega65)
	lda graphMode
	bmi @X
	cmp #$41
	beq @X
	LoadW r0, BSWFont
	bra _LoadCharSet
@X:	LoadW r0, BSWFont80
.else
	LoadW r0, BSWFont
.endif

_LoadCharSet:
	ldx	CPU_DATA
	LoadB	CPU_DATA, RAM_64K
	ldy #0
@1:	lda (r0),y
	sta baselineOffset,y
	iny
	cpy #8
	bne @1
	AddW r0, curIndexTable
	AddW r0, cardDataPntr

.if .defined(trap2) && (!.defined(trap2_alternate_location))
	; copy high-byte of serial
	lda SerialHiCompare
	bne @2
	jsr GetSerialNumber2
	sta SerialHiCompare
@2:
.endif
	stx	CPU_DATA
	rts

_GetCharWidth:
	subv $20
	bcs GetChWdth1
	lda #0
	rts
GetChWdth1:
	cmp #$5f
.ifdef bsw128 ; branch taken/not taken optimization
	beq @2
.else
	bne @1
	lda PrvCharWidth
	rts
@1:
.endif
	asl
	tay
	iny
	iny
.ifdef mega65
	PushB	CPU_DATA
	LoadB	CPU_DATA, RAM_64K
.endif
	lda (curIndexTable),y
	dey
	dey
	sec
	sbc (curIndexTable),y
.ifdef mega65
	tay
	PopB	CPU_DATA
	tya
.endif
	rts
.ifdef bsw128 ; branch taken/not taken optimization
@2:	lda PrvCharWidth
	rts
.endif
