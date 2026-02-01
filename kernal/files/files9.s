; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; BAM/VLIR filesystem driver

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.import Add2

.global _BldGDirEntry

.segment "files9"

_BldGDirEntry:
	ldy #$1d
	lda #0
@1:	sta dirEntryBuf,y
	dey
	bpl @1
.ifdef wheels
	ldy #1
	lda (r9),y
	sta r3H
	dey
	lda (r9),y
	sta r3L
.ifdef mega65
	PushW r4
	ldz #0
@2:
	EOM
	lda (r3),Z
	sta dirEntryBuf+OFF_FNAME,z
	inz
	cpz #16
	bcc @2
	bcs @5a
@3:	lda #$a0
@4:	sta dirEntryBuf+OFF_FNAME,z
	inz
	cpz #16
	bcc @4
@5a:
	PopW r4
.else
@2:	lda (r3),y
	beq @3
	sta dirEntryBuf+OFF_FNAME,y
	iny
	cpy #16
	bcc @2
	bcs @5
@3:	lda #$a0
@4:	sta dirEntryBuf+OFF_FNAME,y
	iny
	cpy #16
	bcc @4
.endif
.else
.ifdef mega65
	PushW r9
	PushW r10
	LoadW r10, 0
	ldz #0
	EOM
	lda (r9),z
	sta r3L
	IncW r9
	EOM
	lda (r9),z
	sta r3H
	PopW r10
	PopW r9
	ldy #0

	PushW r4
	PushW r3
	LoadW r4, 0
	ldz #0
@2:
	EOM
	lda (r3),Z
	beq @3
	sta dirEntryBuf+OFF_FNAME,y
	IncW r3
	iny
	cpy #16
	bcc @2
	bcs @5a
@3:	lda #$a0
@4:	sta dirEntryBuf+OFF_FNAME,y
	iny
	cpy #16
	bcc @4
@5a:
	PopW r3
	PopW r4
.else
	tay
	lda (r9),y
	sta r3L
	iny
	lda (r9),y
	sta r3H
	sty r1H
	dey
	ldx #OFF_FNAME
@2:	lda (r3),y
	bne @4
	sta r1H
@3:	lda #$a0
@4:	sta dirEntryBuf,x
	inx
	iny
	cpy #16
	beq @5
	lda r1H
	bne @2
	beq @3
.endif
.endif
@5:
	PushW r9
	PushW r10
	AddVW O_GHCMDR_TYPE, r9
	LoadW r10, 0
	ldz #0
	EOM
	lda (r9),z
	sta dirEntryBuf+OFF_CFILE_TYPE
	PopW r10
	PopW r9

.ifndef wheels
	PushW r9
	PushW r10
	AddVW O_GHSTR_TYPE, r9
	LoadW r10, 0
	ldz #0
	EOM
	lda (r9),z
	sta dirEntryBuf+OFF_GSTRUC_TYPE
	PopW r10
	PopW r9
.endif
	ldy #NULL
	sty fileHeader
	dey
	sty fileHeader+1
	MoveW fileTrScTab, dirEntryBuf+OFF_GHDR_PTR
	jsr Add2
	MoveW fileTrScTab+2, dirEntryBuf+OFF_DE_TR_SC
.ifdef wheels
	ldy #O_GHSTR_TYPE
	EOM
	lda (r9),y
	sta dirEntryBuf+OFF_GSTRUC_TYPE
	cmp #VLIR
.else
	CmpBI dirEntryBuf+OFF_GSTRUC_TYPE, VLIR
.endif
	bne @6
	jsr Add2
@6:
	PushW r9
	PushW r10
	LoadW r10, 0
	AddVW O_GHGEOS_TYPE, r9
	ldz #0
	EOM
	lda (r9),z
	sta dirEntryBuf+OFF_GFILE_TYPE
	PopW r10
	PopW r9

	MoveW r2, dirEntryBuf+OFF_SIZE
	rts

