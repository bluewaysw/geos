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
.global _MapHigh

.import UNK_4
.import UNK_5
.import EnterDeskTop
.import StartAppl
.import GetFHdrInfo
.import A885E
.ifdef bsw128
.import CheckAppCompat
.import _LdFile2
.else
.import LdFile
.endif


.import _FollowChain
.import _FindFTypes
.import _FindFile
.import _SetDevice
.import _GetFHdrInfo
.import _LdDeskAcc
.import _RstrAppl
.import _LdApplic
.import _SaveFile
.import _SetGDirEntry
.import _BldGDirEntry
.import _DeleteFile
.import _FreeFile
.import _FastDelFile
.import _RenameFile
.import _OpenRecordFile
.import _CloseRecordFile
.import _UpdateRecordFile
.import _NextRecord
.import _PreviousRecord
.import _PointRecord
.import _DeleteRecord
.import _InsertRecord
.import _AppendRecord
.import _ReadRecord
.import _WriteRecord
.import _ReadByte
.import __CRC
.import _SetNewMode
.import _GetRealSize
.import _EndScanLine

.global _map_FollowChain
.global _map_FindFTypes
.global _map_FindFile
.global _map_SetDevice
.global _map_GetFHdrInfo
.global _map_LdDeskAcc
.global _map_RstrAppl
.global _map_LdApplic
.global _map_SaveFile
.global _map_SetGDirEntry
.global _map_BldGDirEntry
.global _map_DeleteFile
.global _map_FreeFile
.global _map_FastDelFile
.global _map_RenameFile
.global _map_OpenRecordFile
.global _map_CloseRecordFile
.global _map_UpdateRecordFile
.global _map_NextRecord
.global _map_PreviousRecord
.global _map_PointRecord
.global _map_DeleteRecord
.global _map_InsertRecord
.global _map_AppendRecord
.global _map_ReadRecord
.global _map_WriteRecord
.global _map_ReadByte
.global _map__CRC
.global _map_SetNewMode
.global _map_GetRealSize

.global MapUnderlay
.global UnmapUnderlay


;---------------------------------------------------------------
; MapHigh
;
; Maps area from $a000 to $c000
;
; Pass:      a  page offset from $a000
;            x  bank offset
;
; Return:    nothing
; Destroyed: a x y z
;---------------------------------------------------------------
_MapHigh:
    cmp highMap
    bne @not_done
    cpx highMapBnk
    beq @done

@not_done:
    cmp #0
    beq @0
    pha
    lda countHighMap
    cmp #0
    beq @2
@1:
    jmp @1
@2: pla

@0:
    sta highMap
    stx highMapBnk
    lda countHighMap
    sta $8895
    jsr ApplyMapping
@done:
	rts


;---------------------------------------------------------------
; MapLow
;
; Maps area from $6000 to $8000
;
; Pass:      a  page offset from $6000
;            x  bank offset
;
; Return:    nothing
; Destroyed: a x y z
;---------------------------------------------------------------
_MapLow:
    cmp lowMap
    bne @not_done
    cpx lowMapBnk
    beq @done
@not_done:
    beq @done

    sta lowMap
    stx lowMapBnk
    jsr ApplyMapping

@done:
	rts


ApplyMapping:

    ; A low offset
    ; Y high offest
    ; X low map/offset high
    ; Z high map/offset hight

    ; config High
    lda highMap
    asl
    pha
    lda highMapBnk
    rol
    ora #$20
    taz
    pla
    tay

    ; config Low
    lda lowMap
    asl
    pha
    lda lowMapBnk
    rol
    ora #$80
    tax
    pla

	map
	eom

    rts



_map_FollowChain:
    jsr MapUnderlay
    jsr _FollowChain
    jmp UnmapUnderlay
_map_FindFTypes:
    jsr MapUnderlay
    jsr _FindFTypes
    jmp UnmapUnderlay
_map_FindFile:
    jsr MapUnderlay
    jsr _FindFile
    jmp UnmapUnderlay
_map_SetDevice:
    jsr MapUnderlay
    jsr _SetDevice
    jmp UnmapUnderlay
_map_GetFHdrInfo:
    jsr MapUnderlay
    jsr _GetFHdrInfo
    jmp UnmapUnderlay
_map_LdDeskAcc:
    jsr MapUnderlay
    jsr _LdDeskAcc
    jmp UnmapUnderlay
_map_RstrAppl:
    jsr MapUnderlay
    jsr _RstrAppl
    jmp UnmapUnderlay
_map_LdApplic:

	jsr UNK_5
	jsr LdFile
	bnex @1
	bbsf 0, A885E, @1
	jsr UNK_4
	MoveW_ fileHeader+O_GHST_VEC, r7
	jmp StartAppl
@1:	rts
    ;jsr MapUnderlay
    ;jsr _LdApplic
    ;jmp UnmapUnderlay
_map_SaveFile:
    jsr MapUnderlay
    jsr _SaveFile
    jmp UnmapUnderlay
_map_SetGDirEntry:
    jsr MapUnderlay
    jsr _SetGDirEntry
    jmp UnmapUnderlay
_map_BldGDirEntry:
    jsr MapUnderlay
    jsr _BldGDirEntry
    jmp UnmapUnderlay
_map_DeleteFile:
    jsr MapUnderlay
    jsr _DeleteFile
    bra __unmap
_map_FreeFile:
    jsr MapUnderlay
    jsr _FreeFile
    bra __unmap
_map_FastDelFile:
    jsr MapUnderlay
    jsr _FastDelFile
    bra __unmap
_map_RenameFile:
    jsr MapUnderlay
    jsr _RenameFile
    bra __unmap
_map_OpenRecordFile:
    jsr MapUnderlay
    jsr _OpenRecordFile
    bra __unmap
_map_CloseRecordFile:
    jsr MapUnderlay
    jsr _CloseRecordFile
    bra __unmap
_map_UpdateRecordFile:
    jsr MapUnderlay
    jsr _UpdateRecordFile
    bra __unmap
_map_NextRecord:
    jsr MapUnderlay
    jsr _NextRecord
    bra __unmap
_map_PreviousRecord:
    jsr MapUnderlay
    jsr _PreviousRecord
    bra __unmap
_map_PointRecord:
    jsr MapUnderlay
    jsr _PointRecord
    bra __unmap
_map_DeleteRecord:
    jsr MapUnderlay
    jsr _DeleteRecord
    bra __unmap
_map_InsertRecord:
    jsr MapUnderlay
    jsr _InsertRecord
    bra __unmap
_map_AppendRecord:
    jsr MapUnderlay
    jsr _AppendRecord
    bra __unmap
_map_ReadRecord:
    jsr MapUnderlay
    jsr _ReadRecord
    bra __unmap
_map_WriteRecord:
    jsr MapUnderlay
    jsr _WriteRecord
    bra __unmap
_map_ReadByte:
    jsr MapUnderlay
    jsr _ReadByte
    bra __unmap
_map__CRC:
    jsr MapUnderlay
    jsr __CRC
__unmap:
    jmp UnmapUnderlay
_map_SetNewMode:
    jsr MapUnderlay
    jsr _SetNewMode
    jsr UnmapUnderlay
    jmp _EndScanLine
_map_GetRealSize:
    jsr MapUnderlay
    jsr _GetRealSize
    bra __unmap


MapUnderlay:
    pha
    txa
    pha
    tya
    pha
    tza
    pha
    bit countHighMap
    bne @1
    lda highMap
    sta lastHighMap
    lda highMapBnk
    sta lastHighMapBnk
    lda #0
    ldx #0
    jsr _MapHigh
    jmp @2
@1: lda highMap
    cmp #0
    beq @2
@3:
    jmp @3
@2:
    inc countHighMap
    pla
    taz
    pla
    tay
    pla
    tax
    pla
    rts

UnmapUnderlay:
    pha
    txa
    pha
    tya
    pha
    tza
    pha
    dec countHighMap
    bne @1
    lda lastHighMap
    ldx lastHighMapBnk
    jsr _MapHigh
    lda #0
    sta lastHighMap
    jmp @2
@1:
    lda highMap
    cmp #0
    beq @2
@3:
    jmp @3

@2:
    pla
    taz
    pla
    tay
    pla
    tax
    pla
    rts
