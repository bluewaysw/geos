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
.import __GetRandom

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
.global _map__GetRandom



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
    lda highMapBnk
    ora #$20
    taz
    lda highMap
    asl
    bcc @2
    inz
@2:
    tay

    ; config Low
    lda lowMapBnk
    ora #$80
    tax
    lda lowMap    
    asl
    bcc @1
    inx
@1:

	map
	eom

    rts



_map_FollowChain:   
    jsr MapUnterlay
    jsr _FollowChain
    jmp UnmapUnderlay
_map_FindFTypes:
    jsr MapUnterlay
    jsr _FindFTypes
    jmp UnmapUnderlay
_map_FindFile:
    jsr MapUnterlay
    jsr _FindFile
    jmp UnmapUnderlay
_map_SetDevice:    
    jsr MapUnterlay
    jsr _SetDevice
    jmp UnmapUnderlay
_map_GetFHdrInfo:    
    jsr MapUnterlay
    jsr _GetFHdrInfo
    jmp UnmapUnderlay
_map_LdDeskAcc:
    jsr MapUnterlay
    jsr _LdDeskAcc
    jmp UnmapUnderlay
_map_RstrAppl:    
    jsr MapUnterlay
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
    ;jsr MapUnterlay
    ;jsr _LdApplic
    ;jmp UnmapUnderlay
_map_SaveFile:    
    jsr MapUnterlay
    jsr _SaveFile
    jmp UnmapUnderlay
_map_SetGDirEntry:    
    jsr MapUnterlay
    jsr _SetGDirEntry
    jmp UnmapUnderlay
_map_BldGDirEntry:
    jsr MapUnterlay
    jsr _BldGDirEntry
    jmp UnmapUnderlay
_map_DeleteFile:    
    jsr MapUnterlay
    jsr _DeleteFile
    bra __unmap
_map_FreeFile:
    jsr MapUnterlay
    jsr _FreeFile
    bra __unmap
_map_FastDelFile:   
    jsr MapUnterlay
    jsr _FastDelFile
    bra __unmap
_map_RenameFile:
    jsr MapUnterlay
    jsr _RenameFile
    bra __unmap
_map_OpenRecordFile:    
    jsr MapUnterlay
    jsr _OpenRecordFile
    bra __unmap
_map_CloseRecordFile:
    jsr MapUnterlay
    jsr _CloseRecordFile
    bra __unmap
_map_UpdateRecordFile:    
    jsr MapUnterlay
    jsr _UpdateRecordFile
    bra __unmap
_map_NextRecord:
    jsr MapUnterlay
    jsr _NextRecord
    bra __unmap
_map_PreviousRecord:    
    jsr MapUnterlay
    jsr _PreviousRecord
    bra __unmap
_map_PointRecord:
    jsr MapUnterlay
    jsr _PointRecord
    bra __unmap
_map_DeleteRecord:    
    jsr MapUnterlay
    jsr _DeleteRecord
    bra __unmap
_map_InsertRecord:
    jsr MapUnterlay
    jsr _InsertRecord
    bra __unmap
_map_AppendRecord:    
    jsr MapUnterlay
    jsr _AppendRecord
    bra __unmap
_map_ReadRecord:
    jsr MapUnterlay
    jsr _ReadRecord
    bra __unmap
_map_WriteRecord:    
    jsr MapUnterlay
    jsr _WriteRecord
    bra __unmap
_map_ReadByte:
    jsr MapUnterlay
    jsr _ReadByte
    bra __unmap
_map__CRC:
    jsr MapUnterlay
    jsr __CRC
__unmap:
    jmp UnmapUnderlay
_map__GetRandom:
    jsr MapUnterlay
    jsr __GetRandom
    bra __unmap


MapUnterlay:
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
    lda countHighMap
    cmp #0
    bne @1
    lda lastHighMap
    ldx #0
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