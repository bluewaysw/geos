; da65 V2.13.2 - (C) Copyright 2000-2009,  Ullrich von Bassewitz
; Created:    2010-05-27 22:13:16
; Input file: configure.cvt.record.2
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
L033A           := $033A
L0340           := $0340
L037B           := $037B
L0389           := $0389
L03BE           := $03BE
L03CB           := $03CB
L0443           := $0443
L0494           := $0494
L04D3           := $04D3
L04DF           := $04DF
L04F6           := $04F6
L0518           := $0518
L051D           := $051D
L0525           := $0525
L0529           := $0529
L052D           := $052D
L0534           := $0534
L0548           := $0548
L0599           := $0599
L05A5           := $05A5
L0632           := $0632
L063B           := $063B
L064A           := $064A
L49AA           := $49AA
L6040           := $6040
_InitForIO      := $9000
_DoneWithIO     := $9002
_ExitTurbo      := $9004
_PurgeTurbo     := $9006
_EnterTurbo     := $9008
_ChangeDiskDevice:= $900A
_NewDisk        := $900C
_ReadBlock      := $900E
_WriteBlock     := $9010
_VerWriteBlock  := $9012
_OpenDisk       := $9014
_GetBlock       := $9016
_PutBlock       := $9018
_GetDirHead     := $901A
_PutDirHead     := $901C
_GetFreeDirBlk  := $901E
_CalcBlksFree   := $9020
_FreeBlock      := $9022
_SetNextFree    := $9024
_FindBAMBit     := $9026
_NxtBlkAlloc    := $9028
_BlkAlloc       := $902A
_ChkDkGEOS      := $902C
_SetGEOSDisk    := $902E
Get1stDirEntry  := $9030
GetNxtDirEntry  := $9033
GetBorder       := $9036
AddDirBlock     := $9039
ReadBuff        := $903C
WriteBuff       := $903F
AllocateBlock   := $9048
ReadLink        := $904B
L9053           := $9053
L9070           := $9070
L908E           := $908E
L909D           := $909D
L90A7           := $90A7
L91CF           := $91CF
L9219           := $9219
L92D0           := $92D0
L930C           := $930C
L937B           := $937B
L938E           := $938E
L939C           := $939C
L9549           := $9549
L9591           := $9591
L9598           := $9598
L95AF           := $95AF
L95F2           := $95F2
L9622           := $9622
L962A           := $962A
L962E           := $962E
L964F           := $964F
L965C           := $965C
L96C1           := $96C1
L96DF           := $96DF
L971E           := $971E
L976E           := $976E
L97D4           := $97D4
L9887           := $9887
L988E           := $988E
L9C09           := $9C09
L9C0F           := $9C0F
L9C3C           := $9C3C
L9C4C           := $9C4C
L9C54           := $9C54
L9C56           := $9C56
bootName        := $C006
version         := $C00F
nationality     := $C010
sysFlgCopy      := $C012
c128Flag        := $C013
dateCopy        := $C018
InterruptMain   := $C100
InitProcesses   := $C103
RestartProcess  := $C106
EnableProcess   := $C109
BlockProcess    := $C10C
UnBlockProcess  := $C10F
FreezeProcess   := $C112
UnFreezeProcess := $C115
HorizontalLine  := $C118
InvertLine      := $C11B
RecoverLine     := $C11E
VerticalLine    := $C121
Rectangle       := $C124
FrameRectangle  := $C127
InvertRectangle := $C12A
RecoverRectangle:= $C12D
DrawLine        := $C130
DrawPoint       := $C133
GraphicsString  := $C136
SetPattern      := $C139
GetScanLine     := $C13C
TestPoint       := $C13F
BitmapUp        := $C142
PutChar         := $C145
PutString       := $C148
UseSystemFont   := $C14B
StartMouseMode  := $C14E
DoMenu          := $C151
RecoverMenu     := $C154
RecoverAllMenus := $C157
DoIcons         := $C15A
DShiftLeft      := $C15D
BBMult          := $C160
BMult           := $C163
DMult           := $C166
Ddiv            := $C169
DSdiv           := $C16C
Dabs            := $C16F
Dnegate         := $C172
Ddec            := $C175
ClearRam        := $C178
FillRam         := $C17B
MoveData        := $C17E
InitRam         := $C181
PutDecimal      := $C184
GetRandom       := $C187
MouseUp         := $C18A
MouseOff        := $C18D
DoPreviousMenu  := $C190
ReDoMenu        := $C193
GetSerialNumber := $C196
Sleep           := $C199
ClearMouseMode  := $C19C
i_Rectangle     := $C19F
i_FrameRectangle:= $C1A2
i_RecoverRectangle:= $C1A5
i_GraphicsString:= $C1A8
i_BitmapUp      := $C1AB
i_PutString     := $C1AE
GetRealSize     := $C1B1
i_FillRam       := $C1B4
i_MoveData      := $C1B7
GetString       := $C1BA
GotoFirstMenu   := $C1BD
InitTextPrompt  := $C1C0
MainLoop        := $C1C3
DrawSprite      := $C1C6
GetCharWidth    := $C1C9
LoadCharSet     := $C1CC
PosSprite       := $C1CF
EnablSprite     := $C1D2
DisablSprite    := $C1D5
CallRoutine     := $C1D8
CalcBlksFree    := $C1DB
ChkDkGEOS       := $C1DE
NewDisk         := $C1E1
GetBlock        := $C1E4
PutBlock        := $C1E7
SetGEOSDisk     := $C1EA
SaveFile        := $C1ED
SetGDirEntry    := $C1F0
BldGDirEntry    := $C1F3
GetFreeDirBlk   := $C1F6
WriteFile       := $C1F9
BlkAlloc        := $C1FC
ReadFile        := $C1FF
SmallPutChar    := $C202
FollowChain     := $C205
GetFile         := $C208
FindFile        := $C20B
CRC             := $C20E
LdFile          := $C211
EnterTurbo      := $C214
LdDeskAcc       := $C217
ReadBlock       := $C21A
LdApplic        := $C21D
WriteBlock      := $C220
VerWriteBlock   := $C223
FreeFile        := $C226
GetFHdrInfo     := $C229
EnterDeskTop    := $C22C
StartAppl       := $C22F
ExitTurbo       := $C232
PurgeTurbo      := $C235
DeleteFile      := $C238
FindFTypes      := $C23B
RstrAppl        := $C23E
ToBASIC         := $C241
FastDelFile     := $C244
GetDirHead      := $C247
PutDirHead      := $C24A
NxtBlkAlloc     := $C24D
ImprintRectangle:= $C250
i_ImprintRectangle:= $C253
DoDlgBox        := $C256
RenameFile      := $C259
InitForIO       := $C25C
DoneWithIO      := $C25F
DShiftRight     := $C262
CopyString      := $C265
CopyFString     := $C268
CmpString       := $C26B
CmpFString      := $C26E
FirstInit       := $C271
OpenRecordFile  := $C274
CloseRecordFile := $C277
NextRecord      := $C27A
PreviousRecord  := $C27D
PointRecord     := $C280
DeleteRecord    := $C283
InsertRecord    := $C286
AppendRecord    := $C289
ReadRecord      := $C28C
WriteRecord     := $C28F
SetNextFree     := $C292
UpdateRecordFile:= $C295
GetPtrCurDkNm   := $C298
PromptOn        := $C29B
PromptOff       := $C29E
OpenDisk        := $C2A1
DoInlineReturn  := $C2A4
GetNextChar     := $C2A7
BitmapClip      := $C2AA
FindBAMBit      := $C2AD
SetDevice       := $C2B0
IsMseInRegion   := $C2B3
ReadByte        := $C2B6
FreeBlock       := $C2B9
ChangeDiskDevice:= $C2BC
RstrFrmDialogue := $C2BF
Panic           := $C2C2
BitOtherClip    := $C2C5
StashRAM        := $C2C8
FetchRAM        := $C2CB
SwapRAM         := $C2CE
VerifyRAM       := $C2D1
DoRAMOp         := $C2D4
TempHideMouse   := $C2D7
SetMousePicture := $C2DA
SetNewMode      := $C2DD
NormalizeX      := $C2E0
MoveBData       := $C2E3
SwapBData       := $C2E6
VerifyBData     := $C2E9
DoBOp           := $C2EC
AccessCache     := $C2EF
HideOnlyMouse   := $C2F2
SetColorMode    := $C2F5
ColorCard       := $C2F8
ColorRectangle  := $C2FB
LF24B           := $F24B
LF3B1           := $F3B1
LF4CA           := $F4CA
LF510           := $F510
LF5E9           := $F5E9
LF78F           := $F78F
LF97E           := $F97E
LF98F           := $F98F
LFF93           := $FF93
LFFA8           := $FFA8
LFFAE           := $FFAE
LFFB1           := $FFB1
; ----------------------------------------------------------------------------
        adc     L0494,y                         ; 3C80 79 94 04                 y..
        sta     $4B,x                           ; 3C83 95 4B                    .K
        .byte   $97                             ; 3C85 97                       .
        pla                                     ; 3C86 68                       h
        .byte   $97                             ; 3C87 97                       .
        pla                                     ; 3C88 68                       h
        stx     $A6,y                           ; 3C89 96 A6                    ..
        .byte   $97                             ; 3C8B 97                       .
        .byte   $77                             ; 3C8C 77                       w
        .byte   $97                             ; 3C8D 97                       .
        .byte   $D4                             ; 3C8E D4                       .
        .byte   $97                             ; 3C8F 97                       .
        .byte   $1F                             ; 3C90 1F                       .
        tya                                     ; 3C91 98                       .
        pha                                     ; 3C92 48                       H
        tya                                     ; 3C93 98                       .
        tsx                                     ; 3C94 BA                       .
        bcc     L3CF2                           ; 3C95 90 5B                    .[
        bcc     L3D11                           ; 3C97 90 78                    .x
        bcc     L3CE9                           ; 3C99 90 4E                    .N
        bcc     L3D08                           ; 3C9B 90 6B                    .k
        bcc     L3D0E                           ; 3C9D 90 6F                    .o
        .byte   $92                             ; 3C9F 92                       .
        sbc     $93,x                           ; 3CA0 F5 93                    ..
        cmp     $1C93,x                         ; 3CA2 DD 93 1C                 ...
        .byte   $93                             ; 3CA5 93                       .
        ldx     $93,y                           ; 3CA6 B6 93                    ..
        .byte   $1C                             ; 3CA8 1C                       .
        sta     ($15),y                         ; 3CA9 91 15                    ..
        sta     ($3F),y                         ; 3CAB 91 3F                    .?
        .byte   $92                             ; 3CAD 92                       .
        asl     $4C94,x                         ; 3CAE 1E 94 4C                 ..L
        ldx     $91,y                           ; 3CB1 B6 91                    ..
        jmp     L91CF                           ; 3CB3 4C CF 91                 L..
; ----------------------------------------------------------------------------
        jmp     L9219                           ; 3CB6 4C 19 92                 L..
; ----------------------------------------------------------------------------
        jmp     L92D0                           ; 3CB9 4C D0 92                 L..
; ----------------------------------------------------------------------------
        jmp     L9053                           ; 3CBC 4C 53 90                 LS.
; ----------------------------------------------------------------------------
        jmp     L9070                           ; 3CBF 4C 70 90                 Lp.
; ----------------------------------------------------------------------------
        jmp     L962E                           ; 3CC2 4C 2E 96                 L..
; ----------------------------------------------------------------------------
        jmp     L9887                           ; 3CC5 4C 87 98                 L..
; ----------------------------------------------------------------------------
        jmp     L939C                           ; 3CC8 4C 9C 93                 L..
; ----------------------------------------------------------------------------
        jmp     L97D4                           ; 3CCB 4C D4 97                 L..
; ----------------------------------------------------------------------------
        jsr     L908E                           ; 3CCE 20 8E 90                  ..
        bne     L3CDB                           ; 3CD1 D0 08                    ..
        lda     #$80                            ; 3CD3 A9 80                    ..
        sta     $0B                             ; 3CD5 85 0B                    ..
        lda     #$00                            ; 3CD7 A9 00                    ..
        sta     $0A                             ; 3CD9 85 0A                    ..
L3CDB:  jsr     EnterTurbo                      ; 3CDB 20 14 C2                  ..
        txa                                     ; 3CDE 8A                       .
        bne     L3CEA                           ; 3CDF D0 09                    ..
        jsr     InitForIO                       ; 3CE1 20 5C C2                  \.
        jsr     ReadBlock                       ; 3CE4 20 1A C2                  ..
        .byte   $20                             ; 3CE7 20                        
        .byte   $5F                             ; 3CE8 5F                       _
L3CE9:  .byte   $C2                             ; 3CE9 C2                       .
L3CEA:  rts                                     ; 3CEA 60                       `
; ----------------------------------------------------------------------------
        jsr     L908E                           ; 3CEB 20 8E 90                  ..
        bne     L3CF8                           ; 3CEE D0 08                    ..
        lda     #$80                            ; 3CF0 A9 80                    ..
L3CF2:  sta     $0B                             ; 3CF2 85 0B                    ..
        lda     #$00                            ; 3CF4 A9 00                    ..
        sta     $0A                             ; 3CF6 85 0A                    ..
L3CF8:  jsr     EnterTurbo                      ; 3CF8 20 14 C2                  ..
        txa                                     ; 3CFB 8A                       .
        bne     L3D0D                           ; 3CFC D0 0F                    ..
        jsr     InitForIO                       ; 3CFE 20 5C C2                  \.
        jsr     WriteBlock                      ; 3D01 20 20 C2                   .
        txa                                     ; 3D04 8A                       .
        bne     L3D0A                           ; 3D05 D0 03                    ..
        .byte   $20                             ; 3D07 20                        
L3D08:  .byte   $23                             ; 3D08 23                       #
        .byte   $C2                             ; 3D09 C2                       .
L3D0A:  jsr     DoneWithIO                      ; 3D0A 20 5F C2                  _.
L3D0D:  rts                                     ; 3D0D 60                       `
; ----------------------------------------------------------------------------
L3D0E:  lda     #$12                            ; 3D0E A9 12                    ..
        .byte   $85                             ; 3D10 85                       .
L3D11:  .byte   $04                             ; 3D11 04                       .
        lda     #$00                            ; 3D12 A9 00                    ..
        sta     $05                             ; 3D14 85 05                    ..
        sta     $0A                             ; 3D16 85 0A                    ..
        lda     #$82                            ; 3D18 A9 82                    ..
        sta     $0B                             ; 3D1A 85 0B                    ..
        rts                                     ; 3D1C 60                       `
; ----------------------------------------------------------------------------
        bit     $88C6                           ; 3D1D 2C C6 88                 ,..
        bvc     L3D27                           ; 3D20 50 05                    P.
        jsr     L9C4C                           ; 3D22 20 4C 9C                  L.
        beq     L3D38                           ; 3D25 F0 11                    ..
L3D27:  lda     #$00                            ; 3D27 A9 00                    ..
        sta     $9D07                           ; 3D29 8D 07 9D                 ...
        ldx     #$02                            ; 3D2C A2 02                    ..
        lda     $04                             ; 3D2E A5 04                    ..
        beq     L3D38                           ; 3D30 F0 06                    ..
        cmp     #$24                            ; 3D32 C9 24                    .$
        bcs     L3D38                           ; 3D34 B0 02                    ..
        sec                                     ; 3D36 38                       8
        rts                                     ; 3D37 60                       `
; ----------------------------------------------------------------------------
L3D38:  clc                                     ; 3D38 18                       .
        rts                                     ; 3D39 60                       `
; ----------------------------------------------------------------------------
        ldy     $8489                           ; 3D3A AC 89 84                 ...
        lda     $8486,y                         ; 3D3D B9 86 84                 ...
        sta     $9114                           ; 3D40 8D 14 91                 ...
        and     #$BF                            ; 3D43 29 BF                    ).
        sta     $8486,y                         ; 3D45 99 86 84                 ...
        jsr     NewDisk                         ; 3D48 20 E1 C1                  ..
        txa                                     ; 3D4B 8A                       .
        bne     L3D8A                           ; 3D4C D0 3C                    .<
        jsr     GetDirHead                      ; 3D4E 20 47 C2                  G.
        txa                                     ; 3D51 8A                       .
        bne     L3D8A                           ; 3D52 D0 36                    .6
        bit     $9114                           ; 3D54 2C 14 91                 ,..
        bvc     L3D67                           ; 3D57 50 0E                    P.
        jsr     L9C4C                           ; 3D59 20 4C 9C                  L.
        beq     L3D67                           ; 3D5C F0 09                    ..
        jsr     L9C0F                           ; 3D5E 20 0F 9C                  ..
        jsr     L908E                           ; 3D61 20 8E 90                  ..
        jsr     L9C54                           ; 3D64 20 54 9C                  T.
L3D67:  lda     #$82                            ; 3D67 A9 82                    ..
        sta     $0D                             ; 3D69 85 0D                    ..
        lda     #$00                            ; 3D6B A9 00                    ..
        sta     $0C                             ; 3D6D 85 0C                    ..
        jsr     ChkDkGEOS                       ; 3D6F 20 DE C1                  ..
        lda     #$82                            ; 3D72 A9 82                    ..
        sta     $0B                             ; 3D74 85 0B                    ..
        lda     #$90                            ; 3D76 A9 90                    ..
        sta     $0A                             ; 3D78 85 0A                    ..
        ldx     #$0C                            ; 3D7A A2 0C                    ..
        jsr     GetPtrCurDkNm                   ; 3D7C 20 98 C2                  ..
        ldx     #$0A                            ; 3D7F A2 0A                    ..
        ldy     #$0C                            ; 3D81 A0 0C                    ..
        lda     #$12                            ; 3D83 A9 12                    ..
        jsr     CopyFString                     ; 3D85 20 68 C2                  h.
        ldx     #$00                            ; 3D88 A2 00                    ..
L3D8A:  lda     $9114                           ; 3D8A AD 14 91                 ...
        ldy     $8489                           ; 3D8D AC 89 84                 ...
        sta     $8486,y                         ; 3D90 99 86 84                 ...
        rts                                     ; 3D93 60                       `
; ----------------------------------------------------------------------------
        brk                                     ; 3D94 00                       .
        ldy     #$01                            ; 3D95 A0 01                    ..
        sty     $08                             ; 3D97 84 08                    ..
        dey                                     ; 3D99 88                       .
        sty     $09                             ; 3D9A 84 09                    ..
        lda     $15                             ; 3D9C A5 15                    ..
        pha                                     ; 3D9E 48                       H
        lda     $14                             ; 3D9F A5 14                    ..
        pha                                     ; 3DA1 48                       H
        lda     $09                             ; 3DA2 A5 09                    ..
        pha                                     ; 3DA4 48                       H
        lda     $08                             ; 3DA5 A5 08                    ..
        pha                                     ; 3DA7 48                       H
        lda     #$00                            ; 3DA8 A9 00                    ..
        sta     $09                             ; 3DAA 85 09                    ..
        lda     #$FE                            ; 3DAC A9 FE                    ..
        sta     $08                             ; 3DAE 85 08                    ..
        ldx     #$06                            ; 3DB0 A2 06                    ..
        ldy     #$08                            ; 3DB2 A0 08                    ..
        jsr     Ddiv                            ; 3DB4 20 69 C1                  i.
        lda     $12                             ; 3DB7 A5 12                    ..
        beq     L3DC1                           ; 3DB9 F0 06                    ..
        inc     $06                             ; 3DBB E6 06                    ..
        bne     L3DC1                           ; 3DBD D0 02                    ..
        inc     $07                             ; 3DBF E6 07                    ..
L3DC1:  lda     #$82                            ; 3DC1 A9 82                    ..
        sta     $0D                             ; 3DC3 85 0D                    ..
        lda     #$00                            ; 3DC5 A9 00                    ..
        sta     $0C                             ; 3DC7 85 0C                    ..
        jsr     CalcBlksFree                    ; 3DC9 20 DB C1                  ..
        pla                                     ; 3DCC 68                       h
        sta     $08                             ; 3DCD 85 08                    ..
        pla                                     ; 3DCF 68                       h
        sta     $09                             ; 3DD0 85 09                    ..
        ldx     #$03                            ; 3DD2 A2 03                    ..
        lda     $07                             ; 3DD4 A5 07                    ..
        cmp     $0B                             ; 3DD6 C5 0B                    ..
        bne     L3DDE                           ; 3DD8 D0 04                    ..
        lda     $06                             ; 3DDA A5 06                    ..
        cmp     $0A                             ; 3DDC C5 0A                    ..
L3DDE:  beq     L3DE2                           ; 3DDE F0 02                    ..
        bcs     L3E2F                           ; 3DE0 B0 4D                    .M
L3DE2:  lda     $0F                             ; 3DE2 A5 0F                    ..
        sta     $0B                             ; 3DE4 85 0B                    ..
        lda     $0E                             ; 3DE6 A5 0E                    ..
        sta     $0A                             ; 3DE8 85 0A                    ..
        lda     $07                             ; 3DEA A5 07                    ..
        sta     $0D                             ; 3DEC 85 0D                    ..
        lda     $06                             ; 3DEE A5 06                    ..
        sta     $0C                             ; 3DF0 85 0C                    ..
L3DF2:  jsr     SetNextFree                     ; 3DF2 20 92 C2                  ..
        txa                                     ; 3DF5 8A                       .
        bne     L3E2F                           ; 3DF6 D0 37                    .7
        ldy     #$00                            ; 3DF8 A0 00                    ..
        lda     $08                             ; 3DFA A5 08                    ..
        sta     ($0A),y                         ; 3DFC 91 0A                    ..
        iny                                     ; 3DFE C8                       .
        lda     $09                             ; 3DFF A5 09                    ..
        sta     ($0A),y                         ; 3E01 91 0A                    ..
        clc                                     ; 3E03 18                       .
        lda     #$02                            ; 3E04 A9 02                    ..
        adc     $0A                             ; 3E06 65 0A                    e.
        sta     $0A                             ; 3E08 85 0A                    ..
        bcc     L3E0E                           ; 3E0A 90 02                    ..
        inc     $0B                             ; 3E0C E6 0B                    ..
L3E0E:  lda     $0C                             ; 3E0E A5 0C                    ..
        bne     L3E14                           ; 3E10 D0 02                    ..
        dec     $0D                             ; 3E12 C6 0D                    ..
L3E14:  dec     $0C                             ; 3E14 C6 0C                    ..
        lda     $0C                             ; 3E16 A5 0C                    ..
        ora     $0D                             ; 3E18 05 0D                    ..
        bne     L3DF2                           ; 3E1A D0 D6                    ..
        ldy     #$00                            ; 3E1C A0 00                    ..
        tya                                     ; 3E1E 98                       .
        sta     ($0A),y                         ; 3E1F 91 0A                    ..
        iny                                     ; 3E21 C8                       .
        lda     $12                             ; 3E22 A5 12                    ..
        bne     L3E28                           ; 3E24 D0 02                    ..
        lda     #$FE                            ; 3E26 A9 FE                    ..
L3E28:  clc                                     ; 3E28 18                       .
        adc     #$01                            ; 3E29 69 01                    i.
        sta     ($0A),y                         ; 3E2B 91 0A                    ..
        ldx     #$00                            ; 3E2D A2 00                    ..
L3E2F:  pla                                     ; 3E2F 68                       h
        sta     $14                             ; 3E30 85 14                    ..
        pla                                     ; 3E32 68                       h
        sta     $15                             ; 3E33 85 15                    ..
        rts                                     ; 3E35 60                       `
; ----------------------------------------------------------------------------
        lda     #$12                            ; 3E36 A9 12                    ..
        sta     $04                             ; 3E38 85 04                    ..
        lda     #$01                            ; 3E3A A9 01                    ..
        sta     $05                             ; 3E3C 85 05                    ..
        jsr     ReadBuff                        ; 3E3E 20 3C 90                  <.
        lda     #$80                            ; 3E41 A9 80                    ..
        sta     $0D                             ; 3E43 85 0D                    ..
        lda     #$02                            ; 3E45 A9 02                    ..
        sta     $0C                             ; 3E47 85 0C                    ..
        lda     #$00                            ; 3E49 A9 00                    ..
        sta     $9D0A                           ; 3E4B 8D 0A 9D                 ...
        rts                                     ; 3E4E 60                       `
; ----------------------------------------------------------------------------
        ldx     #$00                            ; 3E4F A2 00                    ..
        ldy     #$00                            ; 3E51 A0 00                    ..
        clc                                     ; 3E53 18                       .
        lda     #$20                            ; 3E54 A9 20                    . 
        adc     $0C                             ; 3E56 65 0C                    e.
        sta     $0C                             ; 3E58 85 0C                    ..
        bcc     L3E5E                           ; 3E5A 90 02                    ..
        inc     $0D                             ; 3E5C E6 0D                    ..
L3E5E:  lda     $0D                             ; 3E5E A5 0D                    ..
        cmp     #$80                            ; 3E60 C9 80                    ..
        bne     L3E68                           ; 3E62 D0 04                    ..
        lda     $0C                             ; 3E64 A5 0C                    ..
        cmp     #$FF                            ; 3E66 C9 FF                    ..
L3E68:  bcc     L3E98                           ; 3E68 90 2E                    ..
        ldy     #$FF                            ; 3E6A A0 FF                    ..
        lda     $8001                           ; 3E6C AD 01 80                 ...
        sta     $05                             ; 3E6F 85 05                    ..
        lda     $8000                           ; 3E71 AD 00 80                 ...
        sta     $04                             ; 3E74 85 04                    ..
        bne     L3E8B                           ; 3E76 D0 13                    ..
        lda     $9D0A                           ; 3E78 AD 0A 9D                 ...
        bne     L3E98                           ; 3E7B D0 1B                    ..
        lda     #$FF                            ; 3E7D A9 FF                    ..
        sta     $9D0A                           ; 3E7F 8D 0A 9D                 ...
        jsr     GetBorder                       ; 3E82 20 36 90                  6.
        txa                                     ; 3E85 8A                       .
        bne     L3E98                           ; 3E86 D0 10                    ..
        tya                                     ; 3E88 98                       .
        bne     L3E98                           ; 3E89 D0 0D                    ..
L3E8B:  jsr     ReadBuff                        ; 3E8B 20 3C 90                  <.
        ldy     #$00                            ; 3E8E A0 00                    ..
        lda     #$80                            ; 3E90 A9 80                    ..
        sta     $0D                             ; 3E92 85 0D                    ..
        lda     #$02                            ; 3E94 A9 02                    ..
        sta     $0C                             ; 3E96 85 0C                    ..
L3E98:  rts                                     ; 3E98 60                       `
; ----------------------------------------------------------------------------
        jsr     GetDirHead                      ; 3E99 20 47 C2                  G.
        txa                                     ; 3E9C 8A                       .
        bne     L3EBE                           ; 3E9D D0 1F                    ..
        lda     #$82                            ; 3E9F A9 82                    ..
        sta     $0D                             ; 3EA1 85 0D                    ..
        lda     #$00                            ; 3EA3 A9 00                    ..
        sta     $0C                             ; 3EA5 85 0C                    ..
        jsr     ChkDkGEOS                       ; 3EA7 20 DE C1                  ..
        bne     L3EB0                           ; 3EAA D0 04                    ..
        ldy     #$FF                            ; 3EAC A0 FF                    ..
        bne     L3EBC                           ; 3EAE D0 0C                    ..
L3EB0:  lda     $82AC                           ; 3EB0 AD AC 82                 ...
        sta     $05                             ; 3EB3 85 05                    ..
        lda     $82AB                           ; 3EB5 AD AB 82                 ...
        sta     $04                             ; 3EB8 85 04                    ..
        ldy     #$00                            ; 3EBA A0 00                    ..
L3EBC:  ldx     #$00                            ; 3EBC A2 00                    ..
L3EBE:  rts                                     ; 3EBE 60                       `
; ----------------------------------------------------------------------------
        ldy     #$AD                            ; 3EBF A0 AD                    ..
        ldx     #$00                            ; 3EC1 A2 00                    ..
        lda     #$00                            ; 3EC3 A9 00                    ..
        sta     $848B                           ; 3EC5 8D 8B 84                 ...
L3EC8:  lda     ($0C),y                         ; 3EC8 B1 0C                    ..
        cmp     $925E,x                         ; 3ECA DD 5E 92                 .^.
        bne     L3EDA                           ; 3ECD D0 0B                    ..
        iny                                     ; 3ECF C8                       .
        inx                                     ; 3ED0 E8                       .
        cpx     #$0B                            ; 3ED1 E0 0B                    ..
        bne     L3EC8                           ; 3ED3 D0 F3                    ..
        lda     #$FF                            ; 3ED5 A9 FF                    ..
        sta     $848B                           ; 3ED7 8D 8B 84                 ...
L3EDA:  lda     $848B                           ; 3EDA AD 8B 84                 ...
        rts                                     ; 3EDD 60                       `
; ----------------------------------------------------------------------------
        .byte   "GEOS format V1.0"              ; 3EDE 47 45 4F 53 20 66 6F 72  GEOS for
                                                ; 3EE6 6D 61 74 20 56 31 2E 30  mat V1.0
        .byte   $00                             ; 3EEE 00                       .
; ----------------------------------------------------------------------------
        php                                     ; 3EEF 08                       .
        sei                                     ; 3EF0 78                       x
        lda     $0E                             ; 3EF1 A5 0E                    ..
        pha                                     ; 3EF3 48                       H
        lda     $07                             ; 3EF4 A5 07                    ..
        pha                                     ; 3EF6 48                       H
        lda     $06                             ; 3EF7 A5 06                    ..
        pha                                     ; 3EF9 48                       H
        ldx     $16                             ; 3EFA A6 16                    ..
        inx                                     ; 3EFC E8                       .
        stx     $0E                             ; 3EFD 86 0E                    ..
        lda     #$12                            ; 3EFF A9 12                    ..
        sta     $04                             ; 3F01 85 04                    ..
        lda     #$01                            ; 3F03 A9 01                    ..
        sta     $05                             ; 3F05 85 05                    ..
L3F07:  jsr     ReadBuff                        ; 3F07 20 3C 90                  <.
L3F0A:  txa                                     ; 3F0A 8A                       .
        bne     L3F45                           ; 3F0B D0 38                    .8
        dec     $0E                             ; 3F0D C6 0E                    ..
        beq     L3F26                           ; 3F0F F0 15                    ..
L3F11:  lda     $8000                           ; 3F11 AD 00 80                 ...
        bne     L3F1C                           ; 3F14 D0 06                    ..
        jsr     AddDirBlock                     ; 3F16 20 39 90                  9.
        clv                                     ; 3F19 B8                       .
        bvc     L3F0A                           ; 3F1A 50 EE                    P.
L3F1C:  sta     $04                             ; 3F1C 85 04                    ..
        lda     $8001                           ; 3F1E AD 01 80                 ...
        sta     $05                             ; 3F21 85 05                    ..
        clv                                     ; 3F23 B8                       .
        bvc     L3F07                           ; 3F24 50 E1                    P.
L3F26:  ldy     #$02                            ; 3F26 A0 02                    ..
        ldx     #$00                            ; 3F28 A2 00                    ..
L3F2A:  lda     $8000,y                         ; 3F2A B9 00 80                 ...
        beq     L3F45                           ; 3F2D F0 16                    ..
        tya                                     ; 3F2F 98                       .
        clc                                     ; 3F30 18                       .
        adc     #$20                            ; 3F31 69 20                    i 
        tay                                     ; 3F33 A8                       .
        bcc     L3F2A                           ; 3F34 90 F4                    ..
        lda     #$01                            ; 3F36 A9 01                    ..
        sta     $0E                             ; 3F38 85 0E                    ..
        ldx     #$04                            ; 3F3A A2 04                    ..
        ldy     $16                             ; 3F3C A4 16                    ..
        iny                                     ; 3F3E C8                       .
        sty     $16                             ; 3F3F 84 16                    ..
        cpy     #$12                            ; 3F41 C0 12                    ..
        bcc     L3F11                           ; 3F43 90 CC                    ..
L3F45:  pla                                     ; 3F45 68                       h
        sta     $06                             ; 3F46 85 06                    ..
        pla                                     ; 3F48 68                       h
        sta     $07                             ; 3F49 85 07                    ..
        pla                                     ; 3F4B 68                       h
        sta     $0E                             ; 3F4C 85 0E                    ..
        plp                                     ; 3F4E 28                       (
        rts                                     ; 3F4F 60                       `
; ----------------------------------------------------------------------------
        lda     $0F                             ; 3F50 A5 0F                    ..
        pha                                     ; 3F52 48                       H
        lda     $0E                             ; 3F53 A5 0E                    ..
        pha                                     ; 3F55 48                       H
        ldy     #$48                            ; 3F56 A0 48                    .H
        ldx     #$04                            ; 3F58 A2 04                    ..
        lda     $8200,y                         ; 3F5A B9 00 82                 ...
        beq     L3F85                           ; 3F5D F0 26                    .&
        lda     $05                             ; 3F5F A5 05                    ..
        sta     $09                             ; 3F61 85 09                    ..
        lda     $04                             ; 3F63 A5 04                    ..
        sta     $08                             ; 3F65 85 08                    ..
        jsr     SetNextFree                     ; 3F67 20 92 C2                  ..
        lda     $09                             ; 3F6A A5 09                    ..
        sta     $8001                           ; 3F6C 8D 01 80                 ...
        lda     $08                             ; 3F6F A5 08                    ..
        sta     $8000                           ; 3F71 8D 00 80                 ...
        jsr     WriteBuff                       ; 3F74 20 3F 90                  ?.
        txa                                     ; 3F77 8A                       .
        bne     L3F85                           ; 3F78 D0 0B                    ..
        lda     $09                             ; 3F7A A5 09                    ..
        sta     $05                             ; 3F7C 85 05                    ..
        lda     $08                             ; 3F7E A5 08                    ..
        sta     $04                             ; 3F80 85 04                    ..
        jsr     L930C                           ; 3F82 20 0C 93                  ..
L3F85:  pla                                     ; 3F85 68                       h
        sta     $0E                             ; 3F86 85 0E                    ..
        pla                                     ; 3F88 68                       h
        sta     $0F                             ; 3F89 85 0F                    ..
        rts                                     ; 3F8B 60                       `
; ----------------------------------------------------------------------------
        lda     #$00                            ; 3F8C A9 00                    ..
        tay                                     ; 3F8E A8                       .
L3F8F:  sta     $8000,y                         ; 3F8F 99 00 80                 ...
        iny                                     ; 3F92 C8                       .
        bne     L3F8F                           ; 3F93 D0 FA                    ..
        dey                                     ; 3F95 88                       .
        sty     $8001                           ; 3F96 8C 01 80                 ...
        jmp     WriteBuff                       ; 3F99 4C 3F 90                 L?.
; ----------------------------------------------------------------------------
        lda     $09                             ; 3F9C A5 09                    ..
        clc                                     ; 3F9E 18                       .
        adc     $848C                           ; 3F9F 6D 8C 84                 m..
        sta     $0F                             ; 3FA2 85 0F                    ..
        lda     $08                             ; 3FA4 A5 08                    ..
        sta     $0E                             ; 3FA6 85 0E                    ..
        cmp     #$19                            ; 3FA8 C9 19                    ..
        bcc     L3FAE                           ; 3FAA 90 02                    ..
        dec     $0F                             ; 3FAC C6 0F                    ..
L3FAE:  cmp     #$12                            ; 3FAE C9 12                    ..
        beq     L3FB8                           ; 3FB0 F0 06                    ..
L3FB2:  lda     $0E                             ; 3FB2 A5 0E                    ..
        cmp     #$12                            ; 3FB4 C9 12                    ..
        beq     L3FD5                           ; 3FB6 F0 1D                    ..
L3FB8:  asl     a                               ; 3FB8 0A                       .
        asl     a                               ; 3FB9 0A                       .
        tax                                     ; 3FBA AA                       .
        lda     $8200,x                         ; 3FBB BD 00 82                 ...
        beq     L3FD5                           ; 3FBE F0 15                    ..
        lda     $0E                             ; 3FC0 A5 0E                    ..
        jsr     L937B                           ; 3FC2 20 7B 93                  {.
        lda     $938A,x                         ; 3FC5 BD 8A 93                 ...
        sta     $10                             ; 3FC8 85 10                    ..
        tay                                     ; 3FCA A8                       .
L3FCB:  jsr     L938E                           ; 3FCB 20 8E 93                  ..
        beq     L3FED                           ; 3FCE F0 1D                    ..
        inc     $0F                             ; 3FD0 E6 0F                    ..
        dey                                     ; 3FD2 88                       .
        bne     L3FCB                           ; 3FD3 D0 F6                    ..
L3FD5:  inc     $0E                             ; 3FD5 E6 0E                    ..
        lda     $0E                             ; 3FD7 A5 0E                    ..
        cmp     #$24                            ; 3FD9 C9 24                    .$
        bcs     L3FF8                           ; 3FDB B0 1B                    ..
        sec                                     ; 3FDD 38                       8
        sbc     $08                             ; 3FDE E5 08                    ..
        sta     $0F                             ; 3FE0 85 0F                    ..
        asl     a                               ; 3FE2 0A                       .
        adc     #$04                            ; 3FE3 69 04                    i.
        adc     $848C                           ; 3FE5 6D 8C 84                 m..
        sta     $0F                             ; 3FE8 85 0F                    ..
        clv                                     ; 3FEA B8                       .
        bvc     L3FB2                           ; 3FEB 50 C5                    P.
L3FED:  lda     $0E                             ; 3FED A5 0E                    ..
        sta     $08                             ; 3FEF 85 08                    ..
        lda     $0F                             ; 3FF1 A5 0F                    ..
        sta     $09                             ; 3FF3 85 09                    ..
        ldx     #$00                            ; 3FF5 A2 00                    ..
        rts                                     ; 3FF7 60                       `
; ----------------------------------------------------------------------------
L3FF8:  ldx     #$03                            ; 3FF8 A2 03                    ..
        rts                                     ; 3FFA 60                       `
; ----------------------------------------------------------------------------
        ldx     #$00                            ; 3FFB A2 00                    ..
L3FFD:  cmp     $9386,x                         ; 3FFD DD 86 93                 ...
        bcc     L4005                           ; 4000 90 03                    ..
        inx                                     ; 4002 E8                       .
        bne     L3FFD                           ; 4003 D0 F8                    ..
L4005:  rts                                     ; 4005 60                       `
; ----------------------------------------------------------------------------
        .byte   $12                             ; 4006 12                       .
        ora     $241F,y                         ; 4007 19 1F 24                 ..$
        ora     $13,x                           ; 400A 15 13                    ..
        .byte   $12                             ; 400C 12                       .
        ora     ($A5),y                         ; 400D 11 A5                    ..
        .byte   $0F                             ; 400F 0F                       .
L4010:  cmp     $10                             ; 4010 C5 10                    ..
        bcc     L401A                           ; 4012 90 06                    ..
        sec                                     ; 4014 38                       8
        sbc     $10                             ; 4015 E5 10                    ..
        clv                                     ; 4017 B8                       .
        bvc     L4010                           ; 4018 50 F6                    P.
L401A:  sta     $0F                             ; 401A 85 0F                    ..
        jsr     FindBAMBit                      ; 401C 20 AD C2                  ..
        beq     L4033                           ; 401F F0 12                    ..
        lda     $13                             ; 4021 A5 13                    ..
        eor     #$FF                            ; 4023 49 FF                    I.
        and     $8200,x                         ; 4025 3D 00 82                 =..
        sta     $8200,x                         ; 4028 9D 00 82                 ...
        ldx     $11                             ; 402B A6 11                    ..
        dec     $8200,x                         ; 402D DE 00 82                 ...
        ldx     #$00                            ; 4030 A2 00                    ..
        rts                                     ; 4032 60                       `
; ----------------------------------------------------------------------------
L4033:  ldx     #$06                            ; 4033 A2 06                    ..
        rts                                     ; 4035 60                       `
; ----------------------------------------------------------------------------
        lda     $0E                             ; 4036 A5 0E                    ..
        asl     a                               ; 4038 0A                       .
        asl     a                               ; 4039 0A                       .
        sta     $11                             ; 403A 85 11                    ..
        lda     $0F                             ; 403C A5 0F                    ..
        and     #$07                            ; 403E 29 07                    ).
        tax                                     ; 4040 AA                       .
        lda     $93D5,x                         ; 4041 BD D5 93                 ...
        sta     $13                             ; 4044 85 13                    ..
        lda     $0F                             ; 4046 A5 0F                    ..
        lsr     a                               ; 4048 4A                       J
        lsr     a                               ; 4049 4A                       J
        lsr     a                               ; 404A 4A                       J
        sec                                     ; 404B 38                       8
        adc     $11                             ; 404C 65 11                    e.
        tax                                     ; 404E AA                       .
        lda     $8200,x                         ; 404F BD 00 82                 ...
        and     $13                             ; 4052 25 13                    %.
        rts                                     ; 4054 60                       `
; ----------------------------------------------------------------------------
        ora     ($02,x)                         ; 4055 01 02                    ..
        .byte   $04                             ; 4057 04                       .
        php                                     ; 4058 08                       .
        bpl     L407B                           ; 4059 10 20                    . 
        rti                                     ; 405B 40                       @
; ----------------------------------------------------------------------------
        .byte   $80                             ; 405C 80                       .
        jsr     FindBAMBit                      ; 405D 20 AD C2                  ..
        bne     L4072                           ; 4060 D0 10                    ..
        lda     $13                             ; 4062 A5 13                    ..
        eor     $8200,x                         ; 4064 5D 00 82                 ]..
        sta     $8200,x                         ; 4067 9D 00 82                 ...
        ldx     $11                             ; 406A A6 11                    ..
        inc     $8200,x                         ; 406C FE 00 82                 ...
        ldx     #$00                            ; 406F A2 00                    ..
        rts                                     ; 4071 60                       `
; ----------------------------------------------------------------------------
L4072:  ldx     #$06                            ; 4072 A2 06                    ..
        rts                                     ; 4074 60                       `
; ----------------------------------------------------------------------------
        lda     #$00                            ; 4075 A9 00                    ..
        sta     $0A                             ; 4077 85 0A                    ..
        sta     $0B                             ; 4079 85 0B                    ..
L407B:  ldy     #$04                            ; 407B A0 04                    ..
L407D:  lda     ($0C),y                         ; 407D B1 0C                    ..
        clc                                     ; 407F 18                       .
        adc     $0A                             ; 4080 65 0A                    e.
        sta     $0A                             ; 4082 85 0A                    ..
        bcc     L4088                           ; 4084 90 02                    ..
        inc     $0B                             ; 4086 E6 0B                    ..
L4088:  tya                                     ; 4088 98                       .
        clc                                     ; 4089 18                       .
        adc     #$04                            ; 408A 69 04                    i.
        tay                                     ; 408C A8                       .
        cpy     #$48                            ; 408D C0 48                    .H
        beq     L4088                           ; 408F F0 F7                    ..
        cpy     #$90                            ; 4091 C0 90                    ..
        bne     L407D                           ; 4093 D0 E8                    ..
        lda     #$02                            ; 4095 A9 02                    ..
        sta     $09                             ; 4097 85 09                    ..
        lda     #$98                            ; 4099 A9 98                    ..
        sta     $08                             ; 409B 85 08                    ..
        rts                                     ; 409D 60                       `
; ----------------------------------------------------------------------------
        .byte   $20                             ; 409E 20                        
        .byte   $47                             ; 409F 47                       G
L40A0:  .byte   $C2                             ; 40A0 C2                       .
        txa                                     ; 40A1 8A                       .
        bne     L40F8                           ; 40A2 D0 54                    .T
        lda     #$82                            ; 40A4 A9 82                    ..
        sta     $0D                             ; 40A6 85 0D                    ..
        lda     #$00                            ; 40A8 A9 00                    ..
        sta     $0C                             ; 40AA 85 0C                    ..
        jsr     CalcBlksFree                    ; 40AC 20 DB C1                  ..
        ldx     #$03                            ; 40AF A2 03                    ..
        lda     $0A                             ; 40B1 A5 0A                    ..
        ora     $0B                             ; 40B3 05 0B                    ..
        beq     L40F8                           ; 40B5 F0 41                    .A
        lda     #$13                            ; 40B7 A9 13                    ..
        sta     $08                             ; 40B9 85 08                    ..
        lda     #$00                            ; 40BB A9 00                    ..
        sta     $09                             ; 40BD 85 09                    ..
        jsr     SetNextFree                     ; 40BF 20 92 C2                  ..
        txa                                     ; 40C2 8A                       .
        beq     L40CF                           ; 40C3 F0 0A                    ..
        lda     #$01                            ; 40C5 A9 01                    ..
        sta     $08                             ; 40C7 85 08                    ..
        jsr     SetNextFree                     ; 40C9 20 92 C2                  ..
        txa                                     ; 40CC 8A                       .
        bne     L40F8                           ; 40CD D0 29                    .)
L40CF:  lda     $09                             ; 40CF A5 09                    ..
        sta     $05                             ; 40D1 85 05                    ..
        lda     $08                             ; 40D3 A5 08                    ..
        sta     $04                             ; 40D5 85 04                    ..
        jsr     L930C                           ; 40D7 20 0C 93                  ..
        txa                                     ; 40DA 8A                       .
        bne     L40F8                           ; 40DB D0 1B                    ..
        lda     $05                             ; 40DD A5 05                    ..
        sta     $82AC                           ; 40DF 8D AC 82                 ...
        lda     $04                             ; 40E2 A5 04                    ..
        sta     $82AB                           ; 40E4 8D AB 82                 ...
        ldy     #$BC                            ; 40E7 A0 BC                    ..
        ldx     #$0F                            ; 40E9 A2 0F                    ..
L40EB:  lda     $925E,x                         ; 40EB BD 5E 92                 .^.
        sta     $8200,y                         ; 40EE 99 00 82                 ...
        dey                                     ; 40F1 88                       .
        dex                                     ; 40F2 CA                       .
        bpl     L40EB                           ; 40F3 10 F6                    ..
        jsr     PutDirHead                      ; 40F5 20 4A C2                  J.
L40F8:  rts                                     ; 40F8 60                       `
; ----------------------------------------------------------------------------
        php                                     ; 40F9 08                       .
        pla                                     ; 40FA 68                       h
        sta     $9CFC                           ; 40FB 8D FC 9C                 ...
        sei                                     ; 40FE 78                       x
        lda     $01                             ; 40FF A5 01                    ..
        sta     $9CFE                           ; 4101 8D FE 9C                 ...
        lda     #$36                            ; 4104 A9 36                    .6
        sta     $01                             ; 4106 85 01                    ..
        lda     $D01A                           ; 4108 AD 1A D0                 ...
        sta     $9CFD                           ; 410B 8D FD 9C                 ...
        lda     $D030                           ; 410E AD 30 D0                 .0.
        sta     $9CFB                           ; 4111 8D FB 9C                 ...
        ldy     #$00                            ; 4114 A0 00                    ..
        sty     $D030                           ; 4116 8C 30 D0                 .0.
        sty     $D01A                           ; 4119 8C 1A D0                 ...
        lda     #$7F                            ; 411C A9 7F                    ..
        sta     $D019                           ; 411E 8D 19 D0                 ...
        sta     $DC0D                           ; 4121 8D 0D DC                 ...
        sta     $DD0D                           ; 4124 8D 0D DD                 ...
        lda     #$94                            ; 4127 A9 94                    ..
        sta     $0315                           ; 4129 8D 15 03                 ...
        lda     #$FE                            ; 412C A9 FE                    ..
        sta     $0314                           ; 412E 8D 14 03                 ...
        lda     #$95                            ; 4131 A9 95                    ..
        sta     $0319                           ; 4133 8D 19 03                 ...
        lda     #$03                            ; 4136 A9 03                    ..
        sta     $0318                           ; 4138 8D 18 03                 ...
        lda     #$3F                            ; 413B A9 3F                    .?
        sta     $DD02                           ; 413D 8D 02 DD                 ...
        lda     $D015                           ; 4140 AD 15 D0                 ...
        sta     $9CFF                           ; 4143 8D FF 9C                 ...
        sty     $D015                           ; 4146 8C 15 D0                 ...
        sty     $DD05                           ; 4149 8C 05 DD                 ...
        iny                                     ; 414C C8                       .
        sty     $DD04                           ; 414D 8C 04 DD                 ...
        lda     #$81                            ; 4150 A9 81                    ..
        sta     $DD0D                           ; 4152 8D 0D DD                 ...
        lda     #$09                            ; 4155 A9 09                    ..
        sta     $DD0E                           ; 4157 8D 0E DD                 ...
        ldy     #$2C                            ; 415A A0 2C                    .,
L415C:  lda     $D012                           ; 415C AD 12 D0                 ...
        cmp     $8F                             ; 415F C5 8F                    ..
        beq     L415C                           ; 4161 F0 F9                    ..
        sta     $8F                             ; 4163 85 8F                    ..
        dey                                     ; 4165 88                       .
        bne     L415C                           ; 4166 D0 F4                    ..
        lda     $DD00                           ; 4168 AD 00 DD                 ...
        and     #$07                            ; 416B 29 07                    ).
        sta     $8E                             ; 416D 85 8E                    ..
        sta     $9D05                           ; 416F 8D 05 9D                 ...
        ora     #$30                            ; 4172 09 30                    .0
        sta     $8F                             ; 4174 85 8F                    ..
        lda     $8E                             ; 4176 A5 8E                    ..
        ora     #$10                            ; 4178 09 10                    ..
        sta     $9D06                           ; 417A 8D 06 9D                 ...
        rts                                     ; 417D 60                       `
; ----------------------------------------------------------------------------
        pla                                     ; 417E 68                       h
        tay                                     ; 417F A8                       .
        pla                                     ; 4180 68                       h
        tax                                     ; 4181 AA                       .
        pla                                     ; 4182 68                       h
        rti                                     ; 4183 40                       @
; ----------------------------------------------------------------------------
        sei                                     ; 4184 78                       x
        lda     $9CFB                           ; 4185 AD FB 9C                 ...
        sta     $D030                           ; 4188 8D 30 D0                 .0.
        lda     $9CFF                           ; 418B AD FF 9C                 ...
        sta     $D015                           ; 418E 8D 15 D0                 ...
        lda     #$7F                            ; 4191 A9 7F                    ..
        sta     $DD0D                           ; 4193 8D 0D DD                 ...
        lda     $DD0D                           ; 4196 AD 0D DD                 ...
        lda     $9CFD                           ; 4199 AD FD 9C                 ...
        sta     $D01A                           ; 419C 8D 1A D0                 ...
        lda     $9CFE                           ; 419F AD FE 9C                 ...
        sta     $01                             ; 41A2 85 01                    ..
        lda     $9CFC                           ; 41A4 AD FC 9C                 ...
        pha                                     ; 41A7 48                       H
        plp                                     ; 41A8 28                       (
        rts                                     ; 41A9 60                       `
; ----------------------------------------------------------------------------
        .byte   $0F                             ; 41AA 0F                       .
        .byte   $07                             ; 41AB 07                       .
        ora     $0B05                           ; 41AC 0D 05 0B                 ...
        .byte   $03                             ; 41AF 03                       .
        ora     #$01                            ; 41B0 09 01                    ..
        asl     $0C06                           ; 41B2 0E 06 0C                 ...
        .byte   $04                             ; 41B5 04                       .
        asl     a                               ; 41B6 0A                       .
        .byte   $02                             ; 41B7 02                       .
        php                                     ; 41B8 08                       .
        brk                                     ; 41B9 00                       .
        .byte   $80                             ; 41BA 80                       .
        jsr     L40A0                           ; 41BB 20 A0 40                  .@
        cpy     #$60                            ; 41BE C0 60                    .`
        cpx     #$10                            ; 41C0 E0 10                    ..
        bcc     L41F4                           ; 41C2 90 30                    .0
        bcs     L4216                           ; 41C4 B0 50                    .P
        bne     L4238                           ; 41C6 D0 70                    .p
        beq     L41EA                           ; 41C8 F0 20                    . 
        .byte   $5C                             ; 41CA 5C                       \
        stx     $48,y                           ; 41CB 96 48                    .H
        pla                                     ; 41CD 68                       h
        pha                                     ; 41CE 48                       H
        pla                                     ; 41CF 68                       h
        sty     $8D                             ; 41D0 84 8D                    ..
L41D2:  sec                                     ; 41D2 38                       8
L41D3:  lda     $D012                           ; 41D3 AD 12 D0                 ...
        sbc     #$31                            ; 41D6 E9 31                    .1
        bcc     L41DE                           ; 41D8 90 04                    ..
        and     #$06                            ; 41DA 29 06                    ).
        beq     L41D3                           ; 41DC F0 F5                    ..
L41DE:  lda     $8F                             ; 41DE A5 8F                    ..
        sta     $DD00                           ; 41E0 8D 00 DD                 ...
        lda     $8B                             ; 41E3 A5 8B                    ..
        lda     $8E                             ; 41E5 A5 8E                    ..
        sta     $DD00                           ; 41E7 8D 00 DD                 ...
L41EA:  dec     $8D                             ; 41EA C6 8D                    ..
        nop                                     ; 41EC EA                       .
        nop                                     ; 41ED EA                       .
        nop                                     ; 41EE EA                       .
        lda     $DD00                           ; 41EF AD 00 DD                 ...
        lsr     a                               ; 41F2 4A                       J
        lsr     a                               ; 41F3 4A                       J
L41F4:  nop                                     ; 41F4 EA                       .
        ora     $DD00                           ; 41F5 0D 00 DD                 ...
        lsr     a                               ; 41F8 4A                       J
        lsr     a                               ; 41F9 4A                       J
        lsr     a                               ; 41FA 4A                       J
        lsr     a                               ; 41FB 4A                       J
        ldy     $DD00                           ; 41FC AC 00 DD                 ...
        tax                                     ; 41FF AA                       .
        tya                                     ; 4200 98                       .
        lsr     a                               ; 4201 4A                       J
        lsr     a                               ; 4202 4A                       J
        ora     $DD00                           ; 4203 0D 00 DD                 ...
        and     #$F0                            ; 4206 29 F0                    ).
        ora     $952A,x                         ; 4208 1D 2A 95                 .*.
        ldy     $8D                             ; 420B A4 8D                    ..
        sta     ($8B),y                         ; 420D 91 8B                    ..
        bne     L41D2                           ; 420F D0 C1                    ..
L4211:  ldx     $9D06                           ; 4211 AE 06 9D                 ...
        .byte   $8E                             ; 4214 8E                       .
        brk                                     ; 4215 00                       .
L4216:  cmp     $2060,x                         ; 4216 DD 60 20                 .` 
        .byte   $5C                             ; 4219 5C                       \
        stx     $98,y                           ; 421A 96 98                    ..
        pha                                     ; 421C 48                       H
        ldy     #$00                            ; 421D A0 00                    ..
        jsr     L95AF                           ; 421F 20 AF 95                  ..
        pla                                     ; 4222 68                       h
        tay                                     ; 4223 A8                       .
        jsr     L965C                           ; 4224 20 5C 96                  \.
L4227:  dey                                     ; 4227 88                       .
        lda     ($8B),y                         ; 4228 B1 8B                    ..
        ldx     $8E                             ; 422A A6 8E                    ..
        stx     $DD00                           ; 422C 8E 00 DD                 ...
        tax                                     ; 422F AA                       .
        and     #$0F                            ; 4230 29 0F                    ).
        sta     $8D                             ; 4232 85 8D                    ..
        sec                                     ; 4234 38                       8
L4235:  lda     $D012                           ; 4235 AD 12 D0                 ...
L4238:  sbc     #$31                            ; 4238 E9 31                    .1
        bcc     L4240                           ; 423A 90 04                    ..
        and     #$06                            ; 423C 29 06                    ).
        beq     L4235                           ; 423E F0 F5                    ..
L4240:  txa                                     ; 4240 8A                       .
        ldx     $8F                             ; 4241 A6 8F                    ..
        stx     $DD00                           ; 4243 8E 00 DD                 ...
        and     #$F0                            ; 4246 29 F0                    ).
        ora     $8E                             ; 4248 05 8E                    ..
        sta     $DD00                           ; 424A 8D 00 DD                 ...
        ror     a                               ; 424D 6A                       j
        ror     a                               ; 424E 6A                       j
        and     #$F0                            ; 424F 29 F0                    ).
        ora     $9D05                           ; 4251 0D 05 9D                 ...
        sta     $DD00                           ; 4254 8D 00 DD                 ...
        ldx     $8D                             ; 4257 A6 8D                    ..
        lda     $9539,x                         ; 4259 BD 39 95                 .9.
        ora     $8E                             ; 425C 05 8E                    ..
        sta     $DD00                           ; 425E 8D 00 DD                 ...
        ror     a                               ; 4261 6A                       j
        ror     a                               ; 4262 6A                       j
        and     #$F0                            ; 4263 29 F0                    ).
        ora     $8E                             ; 4265 05 8E                    ..
        cpy     #$00                            ; 4267 C0 00                    ..
        sta     $DD00                           ; 4269 8D 00 DD                 ...
        bne     L4227                           ; 426C D0 B9                    ..
        nop                                     ; 426E EA                       .
        nop                                     ; 426F EA                       .
        beq     L4211                           ; 4270 F0 9F                    ..
        stx     $8C                             ; 4272 86 8C                    ..
        sta     $8B                             ; 4274 85 8B                    ..
        lda     #$00                            ; 4276 A9 00                    ..
        sta     $90                             ; 4278 85 90                    ..
        lda     $8489                           ; 427A AD 89 84                 ...
        jsr     LFFB1                           ; 427D 20 B1 FF                  ..
        bit     $90                             ; 4280 24 90                    $.
        bmi     L429C                           ; 4282 30 18                    0.
        lda     #$FF                            ; 4284 A9 FF                    ..
        jsr     LFF93                           ; 4286 20 93 FF                  ..
        bit     $90                             ; 4289 24 90                    $.
        bmi     L429C                           ; 428B 30 0F                    0.
        ldy     #$00                            ; 428D A0 00                    ..
L428F:  lda     ($8B),y                         ; 428F B1 8B                    ..
        jsr     LFFA8                           ; 4291 20 A8 FF                  ..
        iny                                     ; 4294 C8                       .
        cpy     #$05                            ; 4295 C0 05                    ..
        bcc     L428F                           ; 4297 90 F6                    ..
        ldx     #$00                            ; 4299 A2 00                    ..
        rts                                     ; 429B 60                       `
; ----------------------------------------------------------------------------
L429C:  jsr     LFFAE                           ; 429C 20 AE FF                  ..
        ldx     #$0D                            ; 429F A2 0D                    ..
        rts                                     ; 42A1 60                       `
; ----------------------------------------------------------------------------
        stx     $8C                             ; 42A2 86 8C                    ..
        sta     $8B                             ; 42A4 85 8B                    ..
        ldy     #$02                            ; 42A6 A0 02                    ..
        bne     L42BA                           ; 42A8 D0 10                    ..
        stx     $8C                             ; 42AA 86 8C                    ..
        sta     $8B                             ; 42AC 85 8B                    ..
        ldy     #$04                            ; 42AE A0 04                    ..
        lda     $05                             ; 42B0 A5 05                    ..
        sta     $9D04                           ; 42B2 8D 04 9D                 ...
        lda     $04                             ; 42B5 A5 04                    ..
        sta     $9D03                           ; 42B7 8D 03 9D                 ...
L42BA:  lda     $8C                             ; 42BA A5 8C                    ..
        sta     $9D02                           ; 42BC 8D 02 9D                 ...
        lda     $8B                             ; 42BF A5 8B                    ..
        sta     $9D01                           ; 42C1 8D 01 9D                 ...
        lda     #$9D                            ; 42C4 A9 9D                    ..
        sta     $8C                             ; 42C6 85 8C                    ..
        lda     #$01                            ; 42C8 A9 01                    ..
        sta     $8B                             ; 42CA 85 8B                    ..
        jmp     L9598                           ; 42CC 4C 98 95                 L..
; ----------------------------------------------------------------------------
        ldy     #$01                            ; 42CF A0 01                    ..
        jsr     L9549                           ; 42D1 20 49 95                  I.
        pha                                     ; 42D4 48                       H
        tay                                     ; 42D5 A8                       .
        jsr     L9549                           ; 42D6 20 49 95                  I.
        pla                                     ; 42D9 68                       h
        tay                                     ; 42DA A8                       .
        rts                                     ; 42DB 60                       `
; ----------------------------------------------------------------------------
        sei                                     ; 42DC 78                       x
        lda     $8E                             ; 42DD A5 8E                    ..
        sta     $DD00                           ; 42DF 8D 00 DD                 ...
L42E2:  bit     $DD00                           ; 42E2 2C 00 DD                 ,..
        bpl     L42E2                           ; 42E5 10 FB                    ..
        rts                                     ; 42E7 60                       `
; ----------------------------------------------------------------------------
        lda     $8489                           ; 42E8 AD 89 84                 ...
        jsr     SetDevice                       ; 42EB 20 B0 C2                  ..
        ldx     $8489                           ; 42EE AE 89 84                 ...
        lda     $848A,x                         ; 42F1 BD 8A 84                 ...
        bmi     L4304                           ; 42F4 30 0E                    0.
        jsr     L96DF                           ; 42F6 20 DF 96                  ..
        txa                                     ; 42F9 8A                       .
        bne     L433B                           ; 42FA D0 3F                    .?
        ldx     $8489                           ; 42FC AE 89 84                 ...
        lda     #$80                            ; 42FF A9 80                    ..
        sta     $848A,x                         ; 4301 9D 8A 84                 ...
L4304:  and     #$40                            ; 4304 29 40                    )@
        bne     L4334                           ; 4306 D0 2C                    .,
        jsr     InitForIO                       ; 4308 20 5C C2                  \.
        ldx     #$96                            ; 430B A2 96                    ..
        lda     #$BC                            ; 430D A9 BC                    ..
        jsr     L95F2                           ; 430F 20 F2 95                  ..
        txa                                     ; 4312 8A                       .
        bne     L4338                           ; 4313 D0 23                    .#
        jsr     LFFAE                           ; 4315 20 AE FF                  ..
        sei                                     ; 4318 78                       x
        ldy     #$21                            ; 4319 A0 21                    .!
L431B:  dey                                     ; 431B 88                       .
        bne     L431B                           ; 431C D0 FD                    ..
        jsr     L9591                           ; 431E 20 91 95                  ..
L4321:  bit     $DD00                           ; 4321 2C 00 DD                 ,..
        bmi     L4321                           ; 4324 30 FB                    0.
        jsr     DoneWithIO                      ; 4326 20 5F C2                  _.
        ldx     $8489                           ; 4329 AE 89 84                 ...
        lda     $848A,x                         ; 432C BD 8A 84                 ...
        ora     #$40                            ; 432F 09 40                    .@
        sta     $848A,x                         ; 4331 9D 8A 84                 ...
L4334:  ldx     #$00                            ; 4334 A2 00                    ..
        beq     L433B                           ; 4336 F0 03                    ..
L4338:  jsr     DoneWithIO                      ; 4338 20 5F C2                  _.
L433B:  rts                                     ; 433B 60                       `
; ----------------------------------------------------------------------------
        eor     L452D                           ; 433C 4D 2D 45                 M-E
        .byte   $E2                             ; 433F E2                       .
        .byte   $03                             ; 4340 03                       .
        jsr     InitForIO                       ; 4341 20 5C C2                  \.
        ldx     #$04                            ; 4344 A2 04                    ..
        lda     #$20                            ; 4346 A9 20                    . 
        jsr     L9622                           ; 4348 20 22 96                  ".
        jsr     L965C                           ; 434B 20 5C 96                  \.
        lda     $8489                           ; 434E AD 89 84                 ...
        jsr     LFFB1                           ; 4351 20 B1 FF                  ..
        lda     #$EF                            ; 4354 A9 EF                    ..
        jsr     LFF93                           ; 4356 20 93 FF                  ..
        jsr     LFFAE                           ; 4359 20 AE FF                  ..
        jmp     DoneWithIO                      ; 435C 4C 5F C2                 L_.
; ----------------------------------------------------------------------------
        jsr     InitForIO                       ; 435F 20 5C C2                  \.
        lda     #$98                            ; 4362 A9 98                    ..
        sta     $8E                             ; 4364 85 8E                    ..
        lda     #$BB                            ; 4366 A9 BB                    ..
        sta     $8D                             ; 4368 85 8D                    ..
        lda     #$03                            ; 436A A9 03                    ..
        sta     $974A                           ; 436C 8D 4A 97                 .J.
        lda     #$00                            ; 436F A9 00                    ..
        sta     $9749                           ; 4371 8D 49 97                 .I.
        lda     #$1A                            ; 4374 A9 1A                    ..
        sta     $8F                             ; 4376 85 8F                    ..
L4378:  jsr     L971E                           ; 4378 20 1E 97                  ..
        txa                                     ; 437B 8A                       .
        bne     L439B                           ; 437C D0 1D                    ..
        clc                                     ; 437E 18                       .
        lda     #$20                            ; 437F A9 20                    . 
        adc     $8D                             ; 4381 65 8D                    e.
        sta     $8D                             ; 4383 85 8D                    ..
        bcc     L4389                           ; 4385 90 02                    ..
        inc     $8E                             ; 4387 E6 8E                    ..
L4389:  clc                                     ; 4389 18                       .
        lda     #$20                            ; 438A A9 20                    . 
        adc     $9749                           ; 438C 6D 49 97                 mI.
        sta     $9749                           ; 438F 8D 49 97                 .I.
        bcc     L4397                           ; 4392 90 03                    ..
        inc     $974A                           ; 4394 EE 4A 97                 .J.
L4397:  dec     $8F                             ; 4397 C6 8F                    ..
        bpl     L4378                           ; 4399 10 DD                    ..
L439B:  jmp     DoneWithIO                      ; 439B 4C 5F C2                 L_.
; ----------------------------------------------------------------------------
        lda     $8F                             ; 439E A5 8F                    ..
        ora     $848D                           ; 43A0 0D 8D 84                 ...
        beq     L43C3                           ; 43A3 F0 1E                    ..
        ldx     #$97                            ; 43A5 A2 97                    ..
        lda     #$46                            ; 43A7 A9 46                    .F
        jsr     L95F2                           ; 43A9 20 F2 95                  ..
        txa                                     ; 43AC 8A                       .
        bne     L43C5                           ; 43AD D0 16                    ..
        lda     #$20                            ; 43AF A9 20                    . 
        jsr     LFFA8                           ; 43B1 20 A8 FF                  ..
        ldy     #$00                            ; 43B4 A0 00                    ..
L43B6:  lda     ($8D),y                         ; 43B6 B1 8D                    ..
        jsr     LFFA8                           ; 43B8 20 A8 FF                  ..
        iny                                     ; 43BB C8                       .
        cpy     #$20                            ; 43BC C0 20                    . 
        bcc     L43B6                           ; 43BE 90 F6                    ..
        jsr     LFFAE                           ; 43C0 20 AE FF                  ..
L43C3:  ldx     #$00                            ; 43C3 A2 00                    ..
L43C5:  rts                                     ; 43C5 60                       `
; ----------------------------------------------------------------------------
        eor     $572D                           ; 43C6 4D 2D 57                 M-W
        brk                                     ; 43C9 00                       .
        brk                                     ; 43CA 00                       .
        txa                                     ; 43CB 8A                       .
        pha                                     ; 43CC 48                       H
        ldx     $8489                           ; 43CD AE 89 84                 ...
        lda     $848A,x                         ; 43D0 BD 8A 84                 ...
        and     #$40                            ; 43D3 29 40                    )@
        beq     L43E5                           ; 43D5 F0 0E                    ..
        jsr     L96C1                           ; 43D7 20 C1 96                  ..
        ldx     $8489                           ; 43DA AE 89 84                 ...
        lda     $848A,x                         ; 43DD BD 8A 84                 ...
        and     #$BF                            ; 43E0 29 BF                    ).
        sta     $848A,x                         ; 43E2 9D 8A 84                 ...
L43E5:  pla                                     ; 43E5 68                       h
        tax                                     ; 43E6 AA                       .
        rts                                     ; 43E7 60                       `
; ----------------------------------------------------------------------------
        jsr     L9C09                           ; 43E8 20 09 9C                  ..
        jsr     ExitTurbo                       ; 43EB 20 32 C2                  2.
        ldy     $8489                           ; 43EE AC 89 84                 ...
        lda     #$00                            ; 43F1 A9 00                    ..
        sta     $848A,y                         ; 43F3 99 8A 84                 ...
        rts                                     ; 43F6 60                       `
; ----------------------------------------------------------------------------
        jsr     EnterTurbo                      ; 43F7 20 14 C2                  ..
        txa                                     ; 43FA 8A                       .
        bne     L4425                           ; 43FB D0 28                    .(
        jsr     L9C09                           ; 43FD 20 09 9C                  ..
        jsr     InitForIO                       ; 4400 20 5C C2                  \.
        lda     #$00                            ; 4403 A9 00                    ..
        sta     $9D07                           ; 4405 8D 07 9D                 ...
L4408:  lda     #$04                            ; 4408 A9 04                    ..
        sta     $8C                             ; 440A 85 8C                    ..
        lda     #$DC                            ; 440C A9 DC                    ..
        sta     $8B                             ; 440E 85 8B                    ..
        jsr     L962E                           ; 4410 20 2E 96                  ..
        jsr     L9887                           ; 4413 20 87 98                  ..
        beq     L4422                           ; 4416 F0 0A                    ..
        inc     $9D07                           ; 4418 EE 07 9D                 ...
        cpy     $9D07                           ; 441B CC 07 9D                 ...
        beq     L4422                           ; 441E F0 02                    ..
        bcs     L4408                           ; 4420 B0 E6                    ..
L4422:  jsr     DoneWithIO                      ; 4422 20 5F C2                  _.
L4425:  rts                                     ; 4425 60                       `
; ----------------------------------------------------------------------------
        pha                                     ; 4426 48                       H
        jsr     EnterTurbo                      ; 4427 20 14 C2                  ..
        txa                                     ; 442A 8A                       .
        bne     L4452                           ; 442B D0 25                    .%
        pla                                     ; 442D 68                       h
        pha                                     ; 442E 48                       H
        ora     #$20                            ; 442F 09 20                    . 
        sta     $04                             ; 4431 85 04                    ..
        jsr     InitForIO                       ; 4433 20 5C C2                  \.
        ldx     #$04                            ; 4436 A2 04                    ..
        lda     #$39                            ; 4438 A9 39                    .9
        jsr     L962A                           ; 443A 20 2A 96                  *.
        jsr     DoneWithIO                      ; 443D 20 5F C2                  _.
        jsr     L976E                           ; 4440 20 6E 97                  n.
        pla                                     ; 4443 68                       h
        tax                                     ; 4444 AA                       .
        lda     #$C0                            ; 4445 A9 C0                    ..
        sta     $848A,x                         ; 4447 9D 8A 84                 ...
        stx     $8489                           ; 444A 8E 89 84                 ...
        stx     $BA                             ; 444D 86 BA                    ..
        ldx     #$00                            ; 444F A2 00                    ..
        rts                                     ; 4451 60                       `
; ----------------------------------------------------------------------------
L4452:  pla                                     ; 4452 68                       h
        rts                                     ; 4453 60                       `
; ----------------------------------------------------------------------------
        jsr     L90A7                           ; 4454 20 A7 90                  ..
        bcc     L449C                           ; 4457 90 43                    .C
        bit     $88C6                           ; 4459 2C C6 88                 ,..
        bvc     L4463                           ; 445C 50 05                    P.
        jsr     L9C3C                           ; 445E 20 3C 9C                  <.
        bne     L449C                           ; 4461 D0 39                    .9
L4463:  ldx     #$05                            ; 4463 A2 05                    ..
        lda     #$8E                            ; 4465 A9 8E                    ..
        jsr     L962A                           ; 4467 20 2A 96                  *.
        ldx     #$03                            ; 446A A2 03                    ..
        lda     #$20                            ; 446C A9 20                    . 
        jsr     L9622                           ; 446E 20 22 96                  ".
        lda     $0B                             ; 4471 A5 0B                    ..
        sta     $8C                             ; 4473 85 8C                    ..
        lda     $0A                             ; 4475 A5 0A                    ..
        sta     $8B                             ; 4477 85 8B                    ..
        ldy     #$00                            ; 4479 A0 00                    ..
        jsr     L9549                           ; 447B 20 49 95                  I.
        jsr     L988E                           ; 447E 20 8E 98                  ..
        txa                                     ; 4481 8A                       .
        beq     L448E                           ; 4482 F0 0A                    ..
        inc     $9D07                           ; 4484 EE 07 9D                 ...
        cpy     $9D07                           ; 4487 CC 07 9D                 ...
        beq     L448E                           ; 448A F0 02                    ..
        bcs     L4463                           ; 448C B0 D5                    ..
L448E:  txa                                     ; 448E 8A                       .
        bne     L449C                           ; 448F D0 0B                    ..
        bit     $88C6                           ; 4491 2C C6 88                 ,..
        bvc     L449C                           ; 4494 50 06                    P.
        jsr     L9C54                           ; 4496 20 54 9C                  T.
        clv                                     ; 4499 B8                       .
        bvc     L449C                           ; 449A 50 00                    P.
L449C:  ldy     #$00                            ; 449C A0 00                    ..
        rts                                     ; 449E 60                       `
; ----------------------------------------------------------------------------
        jsr     L909D                           ; 449F 20 9D 90                  ..
        bcc     L44C7                           ; 44A2 90 23                    .#
L44A4:  ldx     #$05                            ; 44A4 A2 05                    ..
        lda     #$7C                            ; 44A6 A9 7C                    .|
        jsr     L962A                           ; 44A8 20 2A 96                  *.
        lda     $0B                             ; 44AB A5 0B                    ..
        sta     $8C                             ; 44AD 85 8C                    ..
        lda     $0A                             ; 44AF A5 0A                    ..
        sta     $8B                             ; 44B1 85 8B                    ..
        ldy     #$00                            ; 44B3 A0 00                    ..
        jsr     L9598                           ; 44B5 20 98 95                  ..
        jsr     L9887                           ; 44B8 20 87 98                  ..
        beq     L44C7                           ; 44BB F0 0A                    ..
        inc     $9D07                           ; 44BD EE 07 9D                 ...
        cpy     $9D07                           ; 44C0 CC 07 9D                 ...
        beq     L44C7                           ; 44C3 F0 02                    ..
        bcs     L44A4                           ; 44C5 B0 DD                    ..
L44C7:  rts                                     ; 44C7 60                       `
; ----------------------------------------------------------------------------
        jsr     L909D                           ; 44C8 20 9D 90                  ..
        bcc     L4506                           ; 44CB 90 39                    .9
L44CD:  lda     #$03                            ; 44CD A9 03                    ..
        sta     $9D09                           ; 44CF 8D 09 9D                 ...
L44D2:  ldx     #$05                            ; 44D2 A2 05                    ..
        lda     #$8E                            ; 44D4 A9 8E                    ..
        jsr     L962A                           ; 44D6 20 2A 96                  *.
        jsr     L9887                           ; 44D9 20 87 98                  ..
        txa                                     ; 44DC 8A                       .
        beq     L44FB                           ; 44DD F0 1C                    ..
        dec     $9D09                           ; 44DF CE 09 9D                 ...
        bne     L44D2                           ; 44E2 D0 EE                    ..
        ldx     #$25                            ; 44E4 A2 25                    .%
        inc     $9D07                           ; 44E6 EE 07 9D                 ...
        lda     $9D07                           ; 44E9 AD 07 9D                 ...
        cmp     #$05                            ; 44EC C9 05                    ..
        beq     L44FB                           ; 44EE F0 0B                    ..
        pha                                     ; 44F0 48                       H
        jsr     WriteBlock                      ; 44F1 20 20 C2                   .
        pla                                     ; 44F4 68                       h
        sta     $9D07                           ; 44F5 8D 07 9D                 ...
        txa                                     ; 44F8 8A                       .
        beq     L44CD                           ; 44F9 F0 D2                    ..
L44FB:  txa                                     ; 44FB 8A                       .
L44FC:  bne     L4506                           ; 44FC D0 08                    ..
        bit     $88C6                           ; 44FE 2C C6 88                 ,..
        bvc     L4506                           ; 4501 50 03                    P.
        jmp     L9C54                           ; 4503 4C 54 9C                 LT.
; ----------------------------------------------------------------------------
L4506:  rts                                     ; 4506 60                       `
; ----------------------------------------------------------------------------
        ldx     #$03                            ; 4507 A2 03                    ..
        lda     #$25                            ; 4509 A9 25                    .%
        jsr     L9622                           ; 450B 20 22 96                  ".
        lda     #$9D                            ; 450E A9 9D                    ..
        sta     $8C                             ; 4510 85 8C                    ..
        lda     #$08                            ; 4512 A9 08                    ..
        sta     $8B                             ; 4514 85 8B                    ..
        jsr     L964F                           ; 4516 20 4F 96                  O.
        lda     $9D08                           ; 4519 AD 08 9D                 ...
        pha                                     ; 451C 48                       H
        tay                                     ; 451D A8                       .
        lda     $98AF,y                         ; 451E B9 AF 98                 ...
        tay                                     ; 4521 A8                       .
        pla                                     ; 4522 68                       h
        cmp     #$01                            ; 4523 C9 01                    ..
        beq     L452C                           ; 4525 F0 05                    ..
        clc                                     ; 4527 18                       .
        adc     #$1E                            ; 4528 69 1E                    i.
        bne     L452E                           ; 452A D0 02                    ..
L452C:  .byte   $A9                             ; 452C A9                       .
L452D:  brk                                     ; 452D 00                       .
L452E:  tax                                     ; 452E AA                       .
        rts                                     ; 452F 60                       `
; ----------------------------------------------------------------------------
        ora     ($05,x)                         ; 4530 01 05                    ..
        .byte   $02                             ; 4532 02                       .
        php                                     ; 4533 08                       .
        php                                     ; 4534 08                       .
        ora     ($05,x)                         ; 4535 01 05                    ..
        ora     ($05,x)                         ; 4537 01 05                    ..
        ora     $05                             ; 4539 05 05                    ..
        .byte   $0F                             ; 453B 0F                       .
        .byte   $07                             ; 453C 07                       .
        ora     $0B05                           ; 453D 0D 05 0B                 ...
        .byte   $03                             ; 4540 03                       .
        ora     #$01                            ; 4541 09 01                    ..
        asl     $0C06                           ; 4543 0E 06 0C                 ...
        .byte   $04                             ; 4546 04                       .
        asl     a                               ; 4547 0A                       .
        .byte   $02                             ; 4548 02                       .
        php                                     ; 4549 08                       .
        brk                                     ; 454A 00                       .
        brk                                     ; 454B 00                       .
        .byte   $80                             ; 454C 80                       .
        jsr     L40A0                           ; 454D 20 A0 40                  .@
        cpy     #$60                            ; 4550 C0 60                    .`
        cpx     #$10                            ; 4552 E0 10                    ..
        bcc     L4586                           ; 4554 90 30                    .0
        bcs     L45A8                           ; 4556 B0 50                    .P
        bne     L45CA                           ; 4558 D0 70                    .p
        beq     L44FC                           ; 455A F0 A0                    ..
        brk                                     ; 455C 00                       .
        jsr     L033A                           ; 455D 20 3A 03                  :.
        ldy     #$00                            ; 4560 A0 00                    ..
        sty     $73                             ; 4562 84 73                    .s
        sty     $74                             ; 4564 84 74                    .t
        iny                                     ; 4566 C8                       .
        sty     $71                             ; 4567 84 71                    .q
        ldy     #$00                            ; 4569 A0 00                    ..
        jsr     L03CB                           ; 456B 20 CB 03                  ..
        lda     $71                             ; 456E A5 71                    .q
        jsr     L0340                           ; 4570 20 40 03                  @.
        ldy     $71                             ; 4573 A4 71                    .q
        jsr     L03CB                           ; 4575 20 CB 03                  ..
L4578:  dey                                     ; 4578 88                       .
        lda     ($73),y                         ; 4579 B1 73                    .s
        tax                                     ; 457B AA                       .
        lsr     a                               ; 457C 4A                       J
        lsr     a                               ; 457D 4A                       J
        lsr     a                               ; 457E 4A                       J
        lsr     a                               ; 457F 4A                       J
        sta     $70                             ; 4580 85 70                    .p
        txa                                     ; 4582 8A                       .
        and     #$0F                            ; 4583 29 0F                    ).
        tax                                     ; 4585 AA                       .
L4586:  lda     #$04                            ; 4586 A9 04                    ..
        sta     $1800                           ; 4588 8D 00 18                 ...
L458B:  bit     $1800                           ; 458B 2C 00 18                 ,..
        beq     L458B                           ; 458E F0 FB                    ..
        bit     $1800                           ; 4590 2C 00 18                 ,..
        bne     L4595                           ; 4593 D0 00                    ..
L4595:  bne     L4597                           ; 4595 D0 00                    ..
L4597:  stx     $1800                           ; 4597 8E 00 18                 ...
        txa                                     ; 459A 8A                       .
        rol     a                               ; 459B 2A                       *
        and     #$0F                            ; 459C 29 0F                    ).
        sta     $1800                           ; 459E 8D 00 18                 ...
        ldx     $70                             ; 45A1 A6 70                    .p
        lda     $0300,x                         ; 45A3 BD 00 03                 ...
        .byte   $8D                             ; 45A6 8D                       .
        brk                                     ; 45A7 00                       .
L45A8:  clc                                     ; 45A8 18                       .
        nop                                     ; 45A9 EA                       .
        rol     a                               ; 45AA 2A                       *
        and     #$0F                            ; 45AB 29 0F                    ).
        cpy     #$00                            ; 45AD C0 00                    ..
        sta     $1800                           ; 45AF 8D 00 18                 ...
        bne     L4578                           ; 45B2 D0 C4                    ..
        beq     L45F9                           ; 45B4 F0 43                    .C
        ldy     #$01                            ; 45B6 A0 01                    ..
        jsr     L0389                           ; 45B8 20 89 03                  ..
        sta     $71                             ; 45BB 85 71                    .q
        tay                                     ; 45BD A8                       .
        jsr     L0389                           ; 45BE 20 89 03                  ..
        ldy     $71                             ; 45C1 A4 71                    .q
        rts                                     ; 45C3 60                       `
; ----------------------------------------------------------------------------
        jsr     L03CB                           ; 45C4 20 CB 03                  ..
L45C7:  pha                                     ; 45C7 48                       H
        pla                                     ; 45C8 68                       h
        .byte   $A9                             ; 45C9 A9                       .
L45CA:  .byte   $04                             ; 45CA 04                       .
L45CB:  bit     $1800                           ; 45CB 2C 00 18                 ,..
        beq     L45CB                           ; 45CE F0 FB                    ..
        nop                                     ; 45D0 EA                       .
        nop                                     ; 45D1 EA                       .
        nop                                     ; 45D2 EA                       .
        lda     $1800                           ; 45D3 AD 00 18                 ...
        asl     a                               ; 45D6 0A                       .
        nop                                     ; 45D7 EA                       .
        nop                                     ; 45D8 EA                       .
        nop                                     ; 45D9 EA                       .
        nop                                     ; 45DA EA                       .
        ora     $1800                           ; 45DB 0D 00 18                 ...
        and     #$0F                            ; 45DE 29 0F                    ).
        tax                                     ; 45E0 AA                       .
        nop                                     ; 45E1 EA                       .
        nop                                     ; 45E2 EA                       .
        nop                                     ; 45E3 EA                       .
        lda     $1800                           ; 45E4 AD 00 18                 ...
        asl     a                               ; 45E7 0A                       .
        pha                                     ; 45E8 48                       H
        lda     $70                             ; 45E9 A5 70                    .p
        pla                                     ; 45EB 68                       h
        ora     $1800                           ; 45EC 0D 00 18                 ...
        and     #$0F                            ; 45EF 29 0F                    ).
        ora     $0310,x                         ; 45F1 1D 10 03                 ...
        dey                                     ; 45F4 88                       .
        sta     ($73),y                         ; 45F5 91 73                    .s
        bne     L45C7                           ; 45F7 D0 CE                    ..
L45F9:  ldx     #$02                            ; 45F9 A2 02                    ..
        stx     $1800                           ; 45FB 8E 00 18                 ...
        rts                                     ; 45FE 60                       `
; ----------------------------------------------------------------------------
L45FF:  dec     $48                             ; 45FF C6 48                    .H
        bne     L4606                           ; 4601 D0 03                    ..
        jsr     L0534                           ; 4603 20 34 05                  4.
L4606:  lda     #$C0                            ; 4606 A9 C0                    ..
        sta     $1805                           ; 4608 8D 05 18                 ...
L460B:  bit     $1805                           ; 460B 2C 05 18                 ,..
        bpl     L45FF                           ; 460E 10 EF                    ..
        lda     #$04                            ; 4610 A9 04                    ..
        bit     $1800                           ; 4612 2C 00 18                 ,..
        bne     L460B                           ; 4615 D0 F4                    ..
        lda     #$00                            ; 4617 A9 00                    ..
        sta     $1800                           ; 4619 8D 00 18                 ...
        rts                                     ; 461C 60                       `
; ----------------------------------------------------------------------------
        php                                     ; 461D 08                       .
        sei                                     ; 461E 78                       x
        lda     $49                             ; 461F A5 49                    .I
        pha                                     ; 4621 48                       H
        lda     $180F                           ; 4622 AD 0F 18                 ...
        and     #$DF                            ; 4625 29 DF                    ).
        sta     $180F                           ; 4627 8D 0F 18                 ...
        ldy     #$00                            ; 462A A0 00                    ..
L462C:  dey                                     ; 462C 88                       .
        bne     L462C                           ; 462D D0 FD                    ..
        jsr     L03BE                           ; 462F 20 BE 03                  ..
        lda     #$04                            ; 4632 A9 04                    ..
L4634:  bit     $1800                           ; 4634 2C 00 18                 ,..
        beq     L4634                           ; 4637 F0 FB                    ..
        jsr     L0529                           ; 4639 20 29 05                  ).
        lda     #$06                            ; 463C A9 06                    ..
        sta     $74                             ; 463E 85 74                    .t
        lda     #$4A                            ; 4640 A9 4A                    .J
        sta     $73                             ; 4642 85 73                    .s
        jsr     L037B                           ; 4644 20 7B 03                  {.
        jsr     L052D                           ; 4647 20 2D 05                  -.
        lda     #$07                            ; 464A A9 07                    ..
        sta     $74                             ; 464C 85 74                    .t
        lda     #$00                            ; 464E A9 00                    ..
        sta     $73                             ; 4650 85 73                    .s
        lda     #$03                            ; 4652 A9 03                    ..
        pha                                     ; 4654 48                       H
        lda     #$FD                            ; 4655 A9 FD                    ..
        pha                                     ; 4657 48                       H
        jmp     (L064A)                         ; 4658 6C 4A 06                 lJ.
; ----------------------------------------------------------------------------
        jsr     L03CB                           ; 465B 20 CB 03                  ..
        lda     #$00                            ; 465E A9 00                    ..
        sta     $33                             ; 4660 85 33                    .3
        sta     $1800                           ; 4662 8D 00 18                 ...
        jsr     LF98F                           ; 4665 20 8F F9                  ..
        lda     #$EC                            ; 4668 A9 EC                    ..
        sta     $1C0C                           ; 466A 8D 0C 1C                 ...
        pla                                     ; 466D 68                       h
        pla                                     ; 466E 68                       h
        pla                                     ; 466F 68                       h
        sta     $49                             ; 4670 85 49                    .I
        plp                                     ; 4672 28                       (
        rts                                     ; 4673 60                       `
; ----------------------------------------------------------------------------
        lda     $064C                           ; 4674 AD 4C 06                 .L.
        sta     $77                             ; 4677 85 77                    .w
        eor     #$60                            ; 4679 49 60                    I`
        sta     $78                             ; 467B 85 78                    .x
        rts                                     ; 467D 60                       `
; ----------------------------------------------------------------------------
        jsr     L0632                           ; 467E 20 32 06                  2.
        lda     $22                             ; 4681 A5 22                    ."
        beq     L468A                           ; 4683 F0 05                    ..
        ldx     $00                             ; 4685 A6 00                    ..
        dex                                     ; 4687 CA                       .
        beq     L46AA                           ; 4688 F0 20                    . 
L468A:  lda     $12                             ; 468A A5 12                    ..
        pha                                     ; 468C 48                       H
        lda     $13                             ; 468D A5 13                    ..
        pha                                     ; 468F 48                       H
        jsr     L04DF                           ; 4690 20 DF 04                  ..
        pla                                     ; 4693 68                       h
        sta     $13                             ; 4694 85 13                    ..
        tax                                     ; 4696 AA                       .
        pla                                     ; 4697 68                       h
        sta     $12                             ; 4698 85 12                    ..
        ldy     $00                             ; 469A A4 00                    ..
        cpy     #$01                            ; 469C C0 01                    ..
        bne     L46C9                           ; 469E D0 29                    .)
        cpx     $17                             ; 46A0 E4 17                    ..
        bne     L46CA                           ; 46A2 D0 26                    .&
        cmp     $16                             ; 46A4 C5 16                    ..
        bne     L46CA                           ; 46A6 D0 22                    ."
        lda     #$00                            ; 46A8 A9 00                    ..
L46AA:  pha                                     ; 46AA 48                       H
        lda     $22                             ; 46AB A5 22                    ."
        ldx     #$FF                            ; 46AD A2 FF                    ..
        sec                                     ; 46AF 38                       8
        sbc     $064C                           ; 46B0 ED 4C 06                 .L.
        beq     L46C8                           ; 46B3 F0 13                    ..
        bcs     L46BD                           ; 46B5 B0 06                    ..
        eor     #$FF                            ; 46B7 49 FF                    I.
        adc     #$01                            ; 46B9 69 01                    i.
        ldx     #$01                            ; 46BB A2 01                    ..
L46BD:  jsr     L0494                           ; 46BD 20 94 04                  ..
        lda     $064C                           ; 46C0 AD 4C 06                 .L.
        sta     $22                             ; 46C3 85 22                    ."
        jsr     L0518                           ; 46C5 20 18 05                  ..
L46C8:  pla                                     ; 46C8 68                       h
L46C9:  rts                                     ; 46C9 60                       `
; ----------------------------------------------------------------------------
L46CA:  lda     #$0B                            ; 46CA A9 0B                    ..
        sta     $00                             ; 46CC 85 00                    ..
        rts                                     ; 46CE 60                       `
; ----------------------------------------------------------------------------
        stx     $4A                             ; 46CF 86 4A                    .J
        asl     a                               ; 46D1 0A                       .
        tay                                     ; 46D2 A8                       .
        lda     $1C00                           ; 46D3 AD 00 1C                 ...
        and     #$FE                            ; 46D6 29 FE                    ).
        sta     $70                             ; 46D8 85 70                    .p
        lda     #$1E                            ; 46DA A9 1E                    ..
        sta     $71                             ; 46DC 85 71                    .q
L46DE:  lda     $70                             ; 46DE A5 70                    .p
        clc                                     ; 46E0 18                       .
        adc     $4A                             ; 46E1 65 4A                    eJ
        eor     $70                             ; 46E3 45 70                    Ep
        and     #$03                            ; 46E5 29 03                    ).
        eor     $70                             ; 46E7 45 70                    Ep
        sta     $70                             ; 46E9 85 70                    .p
        sta     $1C00                           ; 46EB 8D 00 1C                 ...
        lda     $71                             ; 46EE A5 71                    .q
        jsr     L04D3                           ; 46F0 20 D3 04                  ..
        lda     $71                             ; 46F3 A5 71                    .q
        cpy     #$05                            ; 46F5 C0 05                    ..
        bcc     L4701                           ; 46F7 90 08                    ..
        cmp     #$11                            ; 46F9 C9 11                    ..
        bcc     L4707                           ; 46FB 90 0A                    ..
        sbc     #$02                            ; 46FD E9 02                    ..
        bne     L4707                           ; 46FF D0 06                    ..
L4701:  cmp     #$1C                            ; 4701 C9 1C                    ..
        bcs     L4707                           ; 4703 B0 02                    ..
        adc     #$04                            ; 4705 69 04                    i.
L4707:  sta     $71                             ; 4707 85 71                    .q
        dey                                     ; 4709 88                       .
        bne     L46DE                           ; 470A D0 D2                    ..
        lda     #$4B                            ; 470C A9 4B                    .K
        sta     $1805                           ; 470E 8D 05 18                 ...
L4711:  lda     $1805                           ; 4711 AD 05 18                 ...
        bne     L4711                           ; 4714 D0 FB                    ..
        rts                                     ; 4716 60                       `
; ----------------------------------------------------------------------------
        jsr     L0632                           ; 4717 20 32 06                  2.
        ldx     $00                             ; 471A A6 00                    ..
        dex                                     ; 471C CA                       .
        beq     L4731                           ; 471D F0 12                    ..
        ldx     #$FF                            ; 471F A2 FF                    ..
        lda     #$01                            ; 4721 A9 01                    ..
        jsr     L0494                           ; 4723 20 94 04                  ..
        ldx     #$01                            ; 4726 A2 01                    ..
        txa                                     ; 4728 8A                       .
        jsr     L0494                           ; 4729 20 94 04                  ..
        lda     #$FF                            ; 472C A9 FF                    ..
        jsr     L04D3                           ; 472E 20 D3 04                  ..
L4731:  lda     #$04                            ; 4731 A9 04                    ..
        sta     $70                             ; 4733 85 70                    .p
L4735:  jsr     L0599                           ; 4735 20 99 05                  ..
        ldx     $18                             ; 4738 A6 18                    ..
        stx     $22                             ; 473A 86 22                    ."
        ldy     $00                             ; 473C A4 00                    ..
        dey                                     ; 473E 88                       .
        beq     L4752                           ; 473F F0 11                    ..
        dec     $70                             ; 4741 C6 70                    .p
        bmi     L474D                           ; 4743 30 08                    0.
        ldx     $70                             ; 4745 A6 70                    .p
        jsr     L051D                           ; 4747 20 1D 05                  ..
        sec                                     ; 474A 38                       8
        bcs     L4735                           ; 474B B0 E8                    ..
L474D:  lda     #$00                            ; 474D A9 00                    ..
        sta     $22                             ; 474F 85 22                    ."
        rts                                     ; 4751 60                       `
; ----------------------------------------------------------------------------
L4752:  txa                                     ; 4752 8A                       .
        jsr     LF24B                           ; 4753 20 4B F2                  K.
        sta     $43                             ; 4756 85 43                    .C
        lda     $1C00                           ; 4758 AD 00 1C                 ...
        and     #$9F                            ; 475B 29 9F                    ).
        ora     $0544,x                         ; 475D 1D 44 05                 .D.
L4760:  sta     $1C00                           ; 4760 8D 00 1C                 ...
        rts                                     ; 4763 60                       `
; ----------------------------------------------------------------------------
        lda     #$F7                            ; 4764 A9 F7                    ..
        bne     L4779                           ; 4766 D0 11                    ..
        lda     #$08                            ; 4768 A9 08                    ..
        ora     $1C00                           ; 476A 0D 00 1C                 ...
        bne     L4760                           ; 476D D0 F1                    ..
        lda     #$00                            ; 476F A9 00                    ..
        sta     $20                             ; 4771 85 20                    . 
        lda     #$FF                            ; 4773 A9 FF                    ..
        sta     $3E                             ; 4775 85 3E                    .>
        lda     #$FB                            ; 4777 A9 FB                    ..
L4779:  and     $1C00                           ; 4779 2D 00 1C                 -..
        jmp     L0525                           ; 477C 4C 25 05                 L%.
; ----------------------------------------------------------------------------
        brk                                     ; 477F 00                       .
        jsr     L6040                           ; 4780 20 40 60                  @`
        tax                                     ; 4783 AA                       .
        bit     $20                             ; 4784 24 20                    $ 
        bpl     L4791                           ; 4786 10 09                    ..
        jsr     L063B                           ; 4788 20 3B 06                  ;.
        lda     #$20                            ; 478B A9 20                    . 
        sta     $20                             ; 478D 85 20                    . 
        ldx     #$00                            ; 478F A2 00                    ..
L4791:  cpx     $22                             ; 4791 E4 22                    ."
        beq     L47B6                           ; 4793 F0 21                    .!
        jsr     L04F6                           ; 4795 20 F6 04                  ..
        cmp     #$01                            ; 4798 C9 01                    ..
        bne     L47B6                           ; 479A D0 1A                    ..
        ldy     $19                             ; 479C A4 19                    ..
        iny                                     ; 479E C8                       .
        cpy     $43                             ; 479F C4 43                    .C
        bcc     L47A5                           ; 47A1 90 02                    ..
        ldy     #$00                            ; 47A3 A0 00                    ..
L47A5:  sty     $19                             ; 47A5 84 19                    ..
        lda     #$00                            ; 47A7 A9 00                    ..
        sta     $45                             ; 47A9 85 45                    .E
        lda     #$00                            ; 47AB A9 00                    ..
        sta     $33                             ; 47AD 85 33                    .3
        lda     #$18                            ; 47AF A9 18                    ..
        sta     $32                             ; 47B1 85 32                    .2
        jsr     L05A5                           ; 47B3 20 A5 05                  ..
L47B6:  rts                                     ; 47B6 60                       `
; ----------------------------------------------------------------------------
        jsr     L0443                           ; 47B7 20 43 04                  C.
        ldx     $00                             ; 47BA A6 00                    ..
        dex                                     ; 47BC CA                       .
        bne     L47C2                           ; 47BD D0 03                    ..
        jsr     L0548                           ; 47BF 20 48 05                  H.
L47C2:  jsr     L037B                           ; 47C2 20 7B 03                  {.
        lda     #$10                            ; 47C5 A9 10                    ..
        bne     L47CE                           ; 47C7 D0 05                    ..
        jsr     L0443                           ; 47C9 20 43 04                  C.
        lda     #$00                            ; 47CC A9 00                    ..
L47CE:  ldx     $00                             ; 47CE A6 00                    ..
        dex                                     ; 47D0 CA                       .
        beq     L47D6                           ; 47D1 F0 03                    ..
        rts                                     ; 47D3 60                       `
; ----------------------------------------------------------------------------
        lda     #$30                            ; 47D4 A9 30                    .0
L47D6:  sta     $45                             ; 47D6 85 45                    .E
        lda     #$06                            ; 47D8 A9 06                    ..
        sta     $33                             ; 47DA 85 33                    .3
        lda     #$4C                            ; 47DC A9 4C                    .L
        sta     $32                             ; 47DE 85 32                    .2
        lda     #$07                            ; 47E0 A9 07                    ..
        sta     $31                             ; 47E2 85 31                    .1
        tsx                                     ; 47E4 BA                       .
        stx     $49                             ; 47E5 86 49                    .I
        ldx     #$01                            ; 47E7 A2 01                    ..
        stx     $00                             ; 47E9 86 00                    ..
        dex                                     ; 47EB CA                       .
        stx     $3F                             ; 47EC 86 3F                    .?
        lda     #$EE                            ; 47EE A9 EE                    ..
        sta     $1C0C                           ; 47F0 8D 0C 1C                 ...
        lda     $45                             ; 47F3 A5 45                    .E
        cmp     #$10                            ; 47F5 C9 10                    ..
        beq     L4803                           ; 47F7 F0 0A                    ..
        cmp     #$30                            ; 47F9 C9 30                    .0
        beq     L4800                           ; 47FB F0 03                    ..
        jmp     LF4CA                           ; 47FD 4C CA F4                 L..
; ----------------------------------------------------------------------------
L4800:  jmp     LF3B1                           ; 4800 4C B1 F3                 L..
; ----------------------------------------------------------------------------
L4803:  jsr     LF5E9                           ; 4803 20 E9 F5                  ..
        sta     $3A                             ; 4806 85 3A                    .:
        lda     $1C00                           ; 4808 AD 00 1C                 ...
        and     #$10                            ; 480B 29 10                    ).
        bne     L4813                           ; 480D D0 04                    ..
        lda     #$08                            ; 480F A9 08                    ..
        bne     L486A                           ; 4811 D0 57                    .W
L4813:  jsr     LF78F                           ; 4813 20 8F F7                  ..
        jsr     LF510                           ; 4816 20 10 F5                  ..
        ldx     #$09                            ; 4819 A2 09                    ..
L481B:  bvc     L481B                           ; 481B 50 FE                    P.
        clv                                     ; 481D B8                       .
        dex                                     ; 481E CA                       .
        bne     L481B                           ; 481F D0 FA                    ..
        lda     #$FF                            ; 4821 A9 FF                    ..
        sta     $1C03                           ; 4823 8D 03 1C                 ...
        lda     $1C0C                           ; 4826 AD 0C 1C                 ...
        and     #$1F                            ; 4829 29 1F                    ).
        ora     #$C0                            ; 482B 09 C0                    ..
        sta     $1C0C                           ; 482D 8D 0C 1C                 ...
        lda     #$FF                            ; 4830 A9 FF                    ..
        ldx     #$05                            ; 4832 A2 05                    ..
        sta     $1C01                           ; 4834 8D 01 1C                 ...
        clv                                     ; 4837 B8                       .
L4838:  bvc     L4838                           ; 4838 50 FE                    P.
        clv                                     ; 483A B8                       .
        dex                                     ; 483B CA                       .
        bne     L4838                           ; 483C D0 FA                    ..
        ldy     #$BB                            ; 483E A0 BB                    ..
L4840:  lda     $0100,y                         ; 4840 B9 00 01                 ...
L4843:  bvc     L4843                           ; 4843 50 FE                    P.
        clv                                     ; 4845 B8                       .
        sta     $1C01                           ; 4846 8D 01 1C                 ...
        iny                                     ; 4849 C8                       .
        bne     L4840                           ; 484A D0 F4                    ..
L484C:  lda     ($30),y                         ; 484C B1 30                    .0
L484E:  bvc     L484E                           ; 484E 50 FE                    P.
        clv                                     ; 4850 B8                       .
        sta     $1C01                           ; 4851 8D 01 1C                 ...
        iny                                     ; 4854 C8                       .
        bne     L484C                           ; 4855 D0 F5                    ..
L4857:  bvc     L4857                           ; 4857 50 FE                    P.
        lda     $1C0C                           ; 4859 AD 0C 1C                 ...
        ora     #$E0                            ; 485C 09 E0                    ..
        sta     $1C0C                           ; 485E 8D 0C 1C                 ...
        lda     #$00                            ; 4861 A9 00                    ..
        sta     $1C03                           ; 4863 8D 03 1C                 ...
        sta     $50                             ; 4866 85 50                    .P
        lda     #$01                            ; 4868 A9 01                    ..
L486A:  sta     $00                             ; 486A 85 00                    ..
        rts                                     ; 486C 60                       `
; ----------------------------------------------------------------------------
        lda     $20                             ; 486D A5 20                    . 
        and     #$20                            ; 486F 29 20                    ) 
        bne     L4880                           ; 4871 D0 0D                    ..
        jsr     LF97E                           ; 4873 20 7E F9                  ~.
        ldy     #$80                            ; 4876 A0 80                    ..
L4878:  dex                                     ; 4878 CA                       .
        bne     L4878                           ; 4879 D0 FD                    ..
        dey                                     ; 487B 88                       .
        bne     L4878                           ; 487C D0 FA                    ..
        sty     $3E                             ; 487E 84 3E                    .>
L4880:  lda     #$FF                            ; 4880 A9 FF                    ..
        sta     $48                             ; 4882 85 48                    .H
        rts                                     ; 4884 60                       `
; ----------------------------------------------------------------------------
        brk                                     ; 4885 00                       .
        brk                                     ; 4886 00                       .
        brk                                     ; 4887 00                       .
        brk                                     ; 4888 00                       .
        bit     $88C6                           ; 4889 2C C6 88                 ,..
        bvs     L488F                           ; 488C 70 01                    p.
        rts                                     ; 488E 60                       `
; ----------------------------------------------------------------------------
L488F:  lda     #$9C                            ; 488F A9 9C                    ..
        sta     $03                             ; 4891 85 03                    ..
        lda     #$07                            ; 4893 A9 07                    ..
        sta     $02                             ; 4895 85 02                    ..
        ldy     #$00                            ; 4897 A0 00                    ..
        sty     $04                             ; 4899 84 04                    ..
        sty     $05                             ; 489B 84 05                    ..
        sty     $07                             ; 489D 84 07                    ..
        iny                                     ; 489F C8                       .
        iny                                     ; 48A0 C8                       .
        sty     $06                             ; 48A1 84 06                    ..
        iny                                     ; 48A3 C8                       .
        sty     $09                             ; 48A4 84 09                    ..
        ldy     $8489                           ; 48A6 AC 89 84                 ...
        lda     $88BF,y                         ; 48A9 B9 BF 88                 ...
        sta     $08                             ; 48AC 85 08                    ..
L48AE:  jsr     StashRAM                        ; 48AE 20 C8 C2                  ..
        inc     $05                             ; 48B1 E6 05                    ..
        bne     L48AE                           ; 48B3 D0 F9                    ..
        inc     $08                             ; 48B5 E6 08                    ..
        dec     $09                             ; 48B7 C6 09                    ..
        bne     L48AE                           ; 48B9 D0 F3                    ..
        rts                                     ; 48BB 60                       `
; ----------------------------------------------------------------------------
        ldy     #$91                            ; 48BC A0 91                    ..
        jsr     L9C56                           ; 48BE 20 56 9C                  V.
        ldy     #$00                            ; 48C1 A0 00                    ..
        lda     ($0A),y                         ; 48C3 B1 0A                    ..
        iny                                     ; 48C5 C8                       .
        ora     ($0A),y                         ; 48C6 11 0A                    ..
        rts                                     ; 48C8 60                       `
; ----------------------------------------------------------------------------
        ldx     #$00                            ; 48C9 A2 00                    ..
        rts                                     ; 48CB 60                       `
; ----------------------------------------------------------------------------
        ldy     #$93                            ; 48CC A0 93                    ..
        jsr     L9C56                           ; 48CE 20 56 9C                  V.
        and     #$20                            ; 48D1 29 20                    ) 
        rts                                     ; 48D3 60                       `
; ----------------------------------------------------------------------------
        ldy     #$90                            ; 48D4 A0 90                    ..
        lda     $03                             ; 48D6 A5 03                    ..
        pha                                     ; 48D8 48                       H
        lda     $02                             ; 48D9 A5 02                    ..
        pha                                     ; 48DB 48                       H
        lda     $05                             ; 48DC A5 05                    ..
        pha                                     ; 48DE 48                       H
        lda     $04                             ; 48DF A5 04                    ..
        pha                                     ; 48E1 48                       H
        lda     $07                             ; 48E2 A5 07                    ..
        pha                                     ; 48E4 48                       H
        lda     $06                             ; 48E5 A5 06                    ..
        pha                                     ; 48E7 48                       H
        lda     $08                             ; 48E8 A5 08                    ..
        pha                                     ; 48EA 48                       H
        tya                                     ; 48EB 98                       .
        pha                                     ; 48EC 48                       H
        ldy     $04                             ; 48ED A4 04                    ..
        dey                                     ; 48EF 88                       .
        lda     $9CB3,y                         ; 48F0 B9 B3 9C                 ...
        clc                                     ; 48F3 18                       .
        adc     $05                             ; 48F4 65 05                    e.
        sta     $05                             ; 48F6 85 05                    ..
        lda     $9CD7,y                         ; 48F8 B9 D7 9C                 ...
        ldy     $8489                           ; 48FB AC 89 84                 ...
        adc     $88BF,y                         ; 48FE 79 BF 88                 y..
        sta     $08                             ; 4901 85 08                    ..
        ldy     #$00                            ; 4903 A0 00                    ..
        sty     $04                             ; 4905 84 04                    ..
        sty     $06                             ; 4907 84 06                    ..
        iny                                     ; 4909 C8                       .
        sty     $07                             ; 490A 84 07                    ..
        lda     $0B                             ; 490C A5 0B                    ..
        sta     $03                             ; 490E 85 03                    ..
        lda     $0A                             ; 4910 A5 0A                    ..
        sta     $02                             ; 4912 85 02                    ..
        pla                                     ; 4914 68                       h
        tay                                     ; 4915 A8                       .
        jsr     DoRAMOp                         ; 4916 20 D4 C2                  ..
        tax                                     ; 4919 AA                       .
        pla                                     ; 491A 68                       h
        sta     $08                             ; 491B 85 08                    ..
        pla                                     ; 491D 68                       h
        sta     $06                             ; 491E 85 06                    ..
        pla                                     ; 4920 68                       h
        sta     $07                             ; 4921 85 07                    ..
        pla                                     ; 4923 68                       h
        sta     $04                             ; 4924 85 04                    ..
        pla                                     ; 4926 68                       h
        sta     $05                             ; 4927 85 05                    ..
        pla                                     ; 4929 68                       h
        sta     $02                             ; 492A 85 02                    ..
        pla                                     ; 492C 68                       h
        sta     $03                             ; 492D 85 03                    ..
        txa                                     ; 492F 8A                       .
        ldx     #$00                            ; 4930 A2 00                    ..
        rts                                     ; 4932 60                       `
; ----------------------------------------------------------------------------
        brk                                     ; 4933 00                       .
        ora     $2A,x                           ; 4934 15 2A                    .*
        .byte   $3F                             ; 4936 3F                       ?
        .byte   $54                             ; 4937 54                       T
        adc     #$7E                            ; 4938 69 7E                    i~
        .byte   $93                             ; 493A 93                       .
        tay                                     ; 493B A8                       .
        lda     $E7D2,x                         ; 493C BD D2 E7                 ...
        .byte   $FC                             ; 493F FC                       .
        ora     ($26),y                         ; 4940 11 26                    .&
        .byte   $3B                             ; 4942 3B                       ;
        bvc     L49AA                           ; 4943 50 65                    Pe
        sei                                     ; 4945 78                       x
        .byte   $8B                             ; 4946 8B                       .
        .byte   $9E                             ; 4947 9E                       .
        lda     ($C4),y                         ; 4948 B1 C4                    ..
        .byte   $D7                             ; 494A D7                       .
        nop                                     ; 494B EA                       .
        .byte   $FC                             ; 494C FC                       .
        asl     $3220                           ; 494D 0E 20 32                 . 2
        .byte   $44                             ; 4950 44                       D
        lsr     $67,x                           ; 4951 56 67                    Vg
        sei                                     ; 4953 78                       x
        .byte   $89                             ; 4954 89                       .
        txs                                     ; 4955 9A                       .
        .byte   $AB                             ; 4956 AB                       .
        brk                                     ; 4957 00                       .
        brk                                     ; 4958 00                       .
        brk                                     ; 4959 00                       .
        brk                                     ; 495A 00                       .
        brk                                     ; 495B 00                       .
        brk                                     ; 495C 00                       .
        brk                                     ; 495D 00                       .
        brk                                     ; 495E 00                       .
        brk                                     ; 495F 00                       .
        brk                                     ; 4960 00                       .
        brk                                     ; 4961 00                       .
        brk                                     ; 4962 00                       .
        brk                                     ; 4963 00                       .
        ora     ($01,x)                         ; 4964 01 01                    ..
        ora     ($01,x)                         ; 4966 01 01                    ..
        ora     ($01,x)                         ; 4968 01 01                    ..
        ora     ($01,x)                         ; 496A 01 01                    ..
        ora     ($01,x)                         ; 496C 01 01                    ..
        ora     ($01,x)                         ; 496E 01 01                    ..
        ora     ($02,x)                         ; 4970 01 02                    ..
        .byte   $02                             ; 4972 02                       .
        .byte   $02                             ; 4973 02                       .
        .byte   $02                             ; 4974 02                       .
        .byte   $02                             ; 4975 02                       .
        .byte   $02                             ; 4976 02                       .
        .byte   $02                             ; 4977 02                       .
        .byte   $02                             ; 4978 02                       .
        .byte   $02                             ; 4979 02                       .
        .byte   $02                             ; 497A 02                       .
        brk                                     ; 497B 00                       .
        brk                                     ; 497C 00                       .
        brk                                     ; 497D 00                       .
        brk                                     ; 497E 00                       .
        brk                                     ; 497F 00                       .
        brk                                     ; 4980 00                       .
        brk                                     ; 4981 00                       .
        brk                                     ; 4982 00                       .
        brk                                     ; 4983 00                       .
        brk                                     ; 4984 00                       .
        brk                                     ; 4985 00                       .
        brk                                     ; 4986 00                       .
        brk                                     ; 4987 00                       .
        brk                                     ; 4988 00                       .
        brk                                     ; 4989 00                       .
        brk                                     ; 498A 00                       .
        .byte   $A2                             ; 498B A2                       .
