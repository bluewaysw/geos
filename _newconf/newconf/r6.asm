; da65 V2.15
; Created:    2017-06-30 23:59:27
; Input file: configure.cvt.record.6
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
CPU_DDR         := $0000
CPU_DATA        := $0001
r0L             := $0002
r0H             := $0003
r1L             := $0004
r1H             := $0005
r2L             := $0006
r2H             := $0007
r3L             := $0008
r3H             := $0009
r4L             := $000A
r4H             := $000B
r5L             := $000C
r5H             := $000D
r6L             := $000E
r6H             := $000F
r7L             := $0010
r7H             := $0011
r8L             := $0012
r8H             := $0013
r9L             := $0014
r9H             := $0015
r10L            := $0016
r10H            := $0017
r11L            := $0018
r11H            := $0019
r12L            := $001A
r12H            := $001B
r13L            := $001C
r13H            := $001D
r14L            := $001E
r14H            := $001F
r15L            := $0020
r15H            := $0021
curPattern      := $0022
string          := $0024
baselineOffset  := $0026
curSetWidth     := $0027
curHeight       := $0029
curIndexTable   := $002A
cardDataPntr    := $002C
currentMode     := $002E
dispBufferOn    := $002F
mouseOn         := $0030
msePicPtr       := $0031
windowTop       := $0033
windowBottom    := $0034
leftMargin      := $0035
rightMargin     := $0037
pressFlag       := $0039
mouseXPos       := $003A
mouseYPos       := $003C
returnAddress   := $003D
graphMode       := $003F
a2L             := $0070
a2H             := $0071
a3L             := $0072
a3H             := $0073
a4L             := $0074
a4H             := $0075
a5L             := $0076
a5H             := $0077
a6L             := $0078
a6H             := $0079
a7L             := $007A
a7H             := $007B
a8L             := $007C
a8H             := $007D
a9L             := $007E
a9H             := $007F
TURBO_DD00      := $008E                        ; from 1541 turbo
TURBO_DD00_CPY  := $008F                        ; from 1541 turbo
STATUS          := $0090
curDevice       := $00BA
a0L             := $00FB
a0H             := $00FC
a1L             := $00FD
a1H             := $00FE
irqvec          := $0314
bkvec           := $0316
nmivec          := $0318
APP_RAM         := $0400
BACK_SCR_BASE   := $6000
L6216           := $6216
PRINTBASE       := $7900
diskBlkBuf      := $8000
fileHeader      := $8100
curDirHead      := $8200
fileTrScTab     := $8300
dirEntryBuf     := $8400
DrACurDkNm      := $841E
DrBCurDkNm      := $8430
dataFileName    := $8442
dataDiskName    := $8453
PrntFilename    := $8465
PrntDiskName    := $8476
curDrive        := $8489
diskOpenFlg     := $848A
isGEOS          := $848B
interleave      := $848C
NUMDRV          := $848D
driveType       := $848E
turboFlags      := $8492
curRecord       := $8496
usedRecords     := $8497
fileWritten     := $8498
fileSize        := $8499
appMain         := $849B
intTopVector    := $849D
intBotVector    := $849F
mouseVector     := $84A1
keyVector       := $84A3
inputVector     := $84A5
mouseFaultVec   := $84A7
otherPressVec   := $84A9
StringFaultVec  := $84AB
alarmTmtVector  := $84AD
BRKVector       := $84AF
RecoverVector   := $84B1
selectionFlash  := $84B3
alphaFlag       := $84B4
iconSelFlg      := $84B5
faultData       := $84B6
menuNumber      := $84B7
mouseTop        := $84B8
mouseBottom     := $84B9
mouseLeft       := $84BA
mouseRight      := $84BC
stringX         := $84BE
stringY         := $84C0
mousePicData    := $84C1
maxMouseSpeed   := $8501
minMouseSpeed   := $8502
mouseAccel      := $8503
keyData         := $8504
mouseData       := $8505
inputData       := $8506
mouseSpeed      := $8507
random          := $850A
saveFontTab     := $850C
dblClickCount   := $8515
year            := $8516
month           := $8517
day             := $8518
hour            := $8519
minutes         := $851A
seconds         := $851B
alarmSetFlag    := $851C
sysDBData       := $851D
screencolors    := $851E
dlgBoxRamBuf    := $851F                        ; to $8697
savedmoby2      := $88BB
scr80polar      := $88BC
scr80colors     := $88BD
vdcClrMode      := $88BE
driveData       := $88BF
ramExpSize      := $88C3
sysRAMFlg       := $88C4
firstBoot       := $88C5
curType         := $88C6
ramBase         := $88C7
inputDevName    := $88CB
memBase         := $88CF                        ; ???
DrCCurDkNm      := $88DC
DrDCurDkNm      := $88EE
dir2Head        := $8900
spr0pic         := $8A00
spr1pic         := $8A40
spr2pic         := $8A80
spr3pic         := $8AC0
spr4pic         := $8B00
spr5pic         := $8B40
spr6pic         := $8B80
spr7pic         := $8BC0
COLOR_MATRIX    := $8C00
obj0Pointer     := $8FF8
obj1Pointer     := $8FF9
obj2Pointer     := $8FFA
obj3Pointer     := $8FFB
obj4Pointer     := $8FFC
obj5Pointer     := $8FFD
obj6Pointer     := $8FFE
obj7Pointer     := $8FFF
SCREEN_BASE     := $A000
OS_ROM          := $C000
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
vicbase         := $D000
mob0ypos        := $D001
mob1xpos        := $D002
mob1ypos        := $D003
mob2xpos        := $D004
mob2ypos        := $D005
mob3xpos        := $D006
mob3ypos        := $D007
mob4xpos        := $D008
mob4ypos        := $D009
mob5xpos        := $D00A
mob5ypos        := $D00B
mob6xpos        := $D00C
mob6ypos        := $D00D
mob7xpos        := $D00E
mob7ypos        := $D00F
msbxpos         := $D010
grcntrl1        := $D011
rasreg          := $D012
lpxpos          := $D013
lpypos          := $D014
mobenble        := $D015
grcntrl2        := $D016
moby2           := $D017
grmemptr        := $D018
grirq           := $D019
grirqen         := $D01A
mobprior        := $D01B
mobmcm          := $D01C
mobx2           := $D01D
mobmobcol       := $D01E
mobbakcol       := $D01F
extclr          := $D020
bakclr0         := $D021
bakclr1         := $D022
bakclr2         := $D023
bakclr3         := $D024
mcmclr0         := $D025
mcmclr1         := $D026
mob0clr         := $D027
mob1clr         := $D028
mob2clr         := $D029
mob3clr         := $D02A
mob4clr         := $D02B
mob5clr         := $D02C
mob6clr         := $D02D
mob7clr         := $D02E
keyreg          := $D02F
clkreg          := $D030
sidbase         := $D400
mmu             := $D500
vdcreg          := $D600
vdcdata         := $D601
ctab            := $D800
cia1base        := $DC00
cia2base        := $DD00
RAMC_BASE       := $DE00
EXP_BASE        := $DF00
MOUSE_BASE      := $FE80
config          := $FF00
CINT            := $FF81
IOINIT          := $FF84
RAMTAS          := $FF87
RESTOR          := $FF8A
VECTOR          := $FF8D
SETMSG          := $FF90
SECOND          := $FF93
TKSA            := $FF96
MEMTOP          := $FF99
MEMBOT          := $FF9C
SCNKEY          := $FF9F
SETTMO          := $FFA2
ACPTR           := $FFA5
CIOUT           := $FFA8
UNTLK           := $FFAB
UNLSN           := $FFAE
LISTEN          := $FFB1
TALK            := $FFB4
READST          := $FFB7
SETLFS          := $FFBA
SETNAM          := $FFBD
OPEN            := $FFC0
CLOSE           := $FFC3
CHKIN           := $FFC6
CKOUT           := $FFC9
CLRCH           := $FFCC
BASIN           := $FFCF
BSOUT           := $FFD2
LOAD            := $FFD5
SAVE            := $FFD8
SETTIM          := $FFDB
RDTIM           := $FFDE
STOP            := $FFE1
GETIN           := $FFE4
CLALL           := $FFE7
UDTIM           := $FFEA
SCREEN          := $FFED
IOBASE          := $FFF3
NMI_VECTOR      := $FFFA
RESET_VECTOR    := $FFFC
IRQ_VECTOR      := $FFFE
; ----------------------------------------------------------------------------

.segment        "record6": absolute

_InitForIO:
        .addr   __InitForIO                     ; 9000 DF 94                    ..
_DoneWithIO:
        .addr   __DoneWithIO                    ; 9002 55 95                    U.
_ExitTurbo:
        .addr   __ExitTurbo                     ; 9004 84 95                    ..
_PurgeTurbo:
        .addr   __ExitTurbo                     ; 9006 84 95                    ..
_EnterTurbo:
        .addr   __EnterTurbo                    ; 9008 7B 95                    {.
_ChangeDiskDevice:
        .addr   __ChangeDiskDevice              ; 900A 8A 95                    ..
_NewDisk:
        .addr   __NewDisk                       ; 900C 92 95                    ..
_ReadBlock:
        .addr   __ReadBlock                     ; 900E 96 95                    ..
_WriteBlock:
        .addr   __WriteBlock                    ; 9010 AC 95                    ..
_VerWriteBlock:
        .addr   __VerWriteBlock                 ; 9012 B5 95                    ..
_OpenDisk:
        .addr   __OpenDisk                      ; 9014 E5 90                    ..
_GetBlock:
        .addr   __GetBlock                      ; 9016 6E 90                    n.
_PutBlock:
        .addr   __PutBlock                      ; 9018 9E 90                    ..
_GetDirHead:
        .addr   __GetDirHead                    ; 901A 4F 90                    O.
_PutDirHead:
        .addr   __PutDirHead                    ; 901C 7B 90                    {.
_GetFreeDirBlk:
        .addr   __GetFreeDirBlk                 ; 901E 93 92                    ..
_CalcBlksFree:
        .addr   __CalcBlksFree                  ; 9020 54 94                    T.
_FreeBlock:
        .addr   __FreeBlock                     ; 9022 0A 94                    ..
_SetNextFree:
        .addr   __SetNextFree                   ; 9024 3E 93                    >.
_FindBAMBit:
        .addr   __FindBAMBit                    ; 9026 12 94                    ..
_NxtBlkAlloc:
        .addr   __NxtBlkAlloc                   ; 9028 3D 91                    =.
_BlkAlloc:
        .addr   __BlkAlloc                      ; 902A 10 91                    ..
_ChkDkGEOS:
        .addr   __ChkDkGEOS                     ; 902C 65 92                    e.
_SetGEOSDisk:
        .addr   __SetGEOSDisk                   ; 902E 93 94                    ..
; ----------------------------------------------------------------------------
Get1stDirEntry:
        jmp     _Get1stDirEntry                 ; 9030 4C EE 91                 L..

; ----------------------------------------------------------------------------
GetNxtDirEntry:
        jmp     _GetNxtDirEntry                 ; 9033 4C FA 91                 L..

; ----------------------------------------------------------------------------
GetBorder:
        jmp     _GetBorder                      ; 9036 4C 44 92                 LD.

; ----------------------------------------------------------------------------
AddDirBlock:
        jmp     _AddDirBlock                    ; 9039 4C F4 92                 L..

; ----------------------------------------------------------------------------
ReadBuff:
        jmp     _ReadBuff                       ; 903C 4C 66 90                 Lf.

; ----------------------------------------------------------------------------
WriteBuff:
        jmp     _WriteBuff                      ; 903F 4C 96 90                 L..

; ----------------------------------------------------------------------------
        nop                                     ; 9042 EA                       .
        nop                                     ; 9043 EA                       .
        rts                                     ; 9044 60                       `

; ----------------------------------------------------------------------------
        nop                                     ; 9045 EA                       .
        nop                                     ; 9046 EA                       .
        rts                                     ; 9047 60                       `

; ----------------------------------------------------------------------------
AllocateBlock:
        jmp     _AllocateBlock                  ; 9048 4C C9 93                 L..

; ----------------------------------------------------------------------------
ReadLink:
        jmp     _ReadLink                       ; 904B 4C A1 95                 L..

; ----------------------------------------------------------------------------
        .byte   $83                             ; 904E 83                       .
__GetDirHead:
        jsr     L90B1                           ; 904F 20 B1 90                  ..
        jsr     __GetBlock                      ; 9052 20 6E 90                  n.
        txa                                     ; 9055 8A                       .
        bne     L9065                           ; 9056 D0 0D                    ..
        jsr     L90B9                           ; 9058 20 B9 90                  ..
        jsr     __GetBlock                      ; 905B 20 6E 90                  n.
        bne     L9065                           ; 905E D0 05                    ..
        jsr     L90C1                           ; 9060 20 C1 90                  ..
        bne     __GetBlock                      ; 9063 D0 09                    ..
L9065:  rts                                     ; 9065 60                       `

; ----------------------------------------------------------------------------
_ReadBuff:
        lda     #$80                            ; 9066 A9 80                    ..
        sta     r4H                             ; 9068 85 0B                    ..
        lda     #$00                            ; 906A A9 00                    ..
        sta     r4L                             ; 906C 85 0A                    ..
__GetBlock:
        jsr     EnterTurbo                      ; 906E 20 14 C2                  ..
        txa                                     ; 9071 8A                       .
        bne     L907A                           ; 9072 D0 06                    ..
        php                                     ; 9074 08                       .
        sei                                     ; 9075 78                       x
        jsr     ReadBlock                       ; 9076 20 1A C2                  ..
        plp                                     ; 9079 28                       (
L907A:  rts                                     ; 907A 60                       `

; ----------------------------------------------------------------------------
__PutDirHead:
        php                                     ; 907B 08                       .
        sei                                     ; 907C 78                       x
        jsr     L90B1                           ; 907D 20 B1 90                  ..
        jsr     WriteBlock                      ; 9080 20 20 C2                   .
        txa                                     ; 9083 8A                       .
        bne     L9094                           ; 9084 D0 0E                    ..
        jsr     L90B9                           ; 9086 20 B9 90                  ..
        jsr     WriteBlock                      ; 9089 20 20 C2                   .
        bne     L9094                           ; 908C D0 06                    ..
        jsr     L90C1                           ; 908E 20 C1 90                  ..
        jsr     WriteBlock                      ; 9091 20 20 C2                   .
L9094:  plp                                     ; 9094 28                       (
        rts                                     ; 9095 60                       `

; ----------------------------------------------------------------------------
_WriteBuff:
        lda     #$80                            ; 9096 A9 80                    ..
        sta     r4H                             ; 9098 85 0B                    ..
        lda     #$00                            ; 909A A9 00                    ..
        sta     r4L                             ; 909C 85 0A                    ..
__PutBlock:
        jsr     EnterTurbo                      ; 909E 20 14 C2                  ..
        txa                                     ; 90A1 8A                       .
        bne     L90B0                           ; 90A2 D0 0C                    ..
        php                                     ; 90A4 08                       .
        sei                                     ; 90A5 78                       x
        jsr     WriteBlock                      ; 90A6 20 20 C2                   .
        txa                                     ; 90A9 8A                       .
        bne     L90AF                           ; 90AA D0 03                    ..
        jsr     VerWriteBlock                   ; 90AC 20 23 C2                  #.
L90AF:  plp                                     ; 90AF 28                       (
L90B0:  rts                                     ; 90B0 60                       `

; ----------------------------------------------------------------------------
L90B1:  ldx     #$82                            ; 90B1 A2 82                    ..
        ldy     #$00                            ; 90B3 A0 00                    ..
        lda     #$00                            ; 90B5 A9 00                    ..
        beq     L90C7                           ; 90B7 F0 0E                    ..
L90B9:  ldx     #$89                            ; 90B9 A2 89                    ..
        ldy     #$00                            ; 90BB A0 00                    ..
        lda     #$01                            ; 90BD A9 01                    ..
        bne     L90C7                           ; 90BF D0 06                    ..
L90C1:  ldx     #$9C                            ; 90C1 A2 9C                    ..
        ldy     #$80                            ; 90C3 A0 80                    ..
        lda     #$02                            ; 90C5 A9 02                    ..
L90C7:  stx     r4H                             ; 90C7 86 0B                    ..
        sty     r4L                             ; 90C9 84 0A                    ..
        sta     r1H                             ; 90CB 85 05                    ..
        lda     #$28                            ; 90CD A9 28                    .(
        sta     r1L                             ; 90CF 85 04                    ..
        rts                                     ; 90D1 60                       `

; ----------------------------------------------------------------------------
L90D2:  lda     #$00                            ; 90D2 A9 00                    ..
        sta     L9674                           ; 90D4 8D 74 96                 .t.
        ldx     #$02                            ; 90D7 A2 02                    ..
        lda     r1L                             ; 90D9 A5 04                    ..
        beq     L90E3                           ; 90DB F0 06                    ..
        cmp     #$51                            ; 90DD C9 51                    .Q
        bcs     L90E3                           ; 90DF B0 02                    ..
        sec                                     ; 90E1 38                       8
        rts                                     ; 90E2 60                       `

; ----------------------------------------------------------------------------
L90E3:  clc                                     ; 90E3 18                       .
        rts                                     ; 90E4 60                       `

; ----------------------------------------------------------------------------
__OpenDisk:
        jsr     NewDisk                         ; 90E5 20 E1 C1                  ..
        txa                                     ; 90E8 8A                       .
        bne     L910F                           ; 90E9 D0 24                    .$
        jsr     GetDirHead                      ; 90EB 20 47 C2                  G.
        txa                                     ; 90EE 8A                       .
        bne     L910F                           ; 90EF D0 1E                    ..
        jsr     L91E5                           ; 90F1 20 E5 91                  ..
        jsr     ChkDkGEOS                       ; 90F4 20 DE C1                  ..
        lda     #$82                            ; 90F7 A9 82                    ..
        sta     r4H                             ; 90F9 85 0B                    ..
        lda     #$90                            ; 90FB A9 90                    ..
        sta     r4L                             ; 90FD 85 0A                    ..
        ldx     #$0C                            ; 90FF A2 0C                    ..
        jsr     GetPtrCurDkNm                   ; 9101 20 98 C2                  ..
        ldx     #$0A                            ; 9104 A2 0A                    ..
        ldy     #$0C                            ; 9106 A0 0C                    ..
        lda     #$12                            ; 9108 A9 12                    ..
        jsr     CopyFString                     ; 910A 20 68 C2                  h.
        ldx     #$00                            ; 910D A2 00                    ..
L910F:  rts                                     ; 910F 60                       `

; ----------------------------------------------------------------------------
__BlkAlloc:
        pla                                     ; 9110 68                       h
        sta     r3L                             ; 9111 85 08                    ..
        pla                                     ; 9113 68                       h
        sta     r3H                             ; 9114 85 09                    ..
        lda     r3H                             ; 9116 A5 09                    ..
        pha                                     ; 9118 48                       H
        lda     r3L                             ; 9119 A5 08                    ..
        pha                                     ; 911B 48                       H
        lda     r3L                             ; 911C A5 08                    ..
        sec                                     ; 911E 38                       8
        sbc     $C1EE                           ; 911F ED EE C1                 ...
        sta     r3L                             ; 9122 85 08                    ..
        lda     r3H                             ; 9124 A5 09                    ..
        sbc     $C1EF                           ; 9126 ED EF C1                 ...
        sta     r3H                             ; 9129 85 09                    ..
        ldy     #$27                            ; 912B A0 27                    .'
        lda     r3H                             ; 912D A5 09                    ..
        beq     L9133                           ; 912F F0 02                    ..
        ldy     #$23                            ; 9131 A0 23                    .#
L9133:  sty     r3L                             ; 9133 84 08                    ..
        ldy     #$00                            ; 9135 A0 00                    ..
        sty     r3H                             ; 9137 84 09                    ..
        lda     #$02                            ; 9139 A9 02                    ..
        bne     L913F                           ; 913B D0 02                    ..
__NxtBlkAlloc:
        lda     #$00                            ; 913D A9 00                    ..
L913F:  sta     L9678                           ; 913F 8D 78 96                 .x.
        lda     r9H                             ; 9142 A5 15                    ..
        pha                                     ; 9144 48                       H
        lda     r9L                             ; 9145 A5 14                    ..
        pha                                     ; 9147 48                       H
        lda     r3H                             ; 9148 A5 09                    ..
        pha                                     ; 914A 48                       H
        lda     r3L                             ; 914B A5 08                    ..
        pha                                     ; 914D 48                       H
        lda     #$00                            ; 914E A9 00                    ..
        sta     r3H                             ; 9150 85 09                    ..
        lda     #$FE                            ; 9152 A9 FE                    ..
        sta     r3L                             ; 9154 85 08                    ..
        ldx     #$06                            ; 9156 A2 06                    ..
        ldy     #$08                            ; 9158 A0 08                    ..
        jsr     Ddiv                            ; 915A 20 69 C1                  i.
        lda     r8L                             ; 915D A5 12                    ..
        beq     L9167                           ; 915F F0 06                    ..
        inc     r2L                             ; 9161 E6 06                    ..
        bne     L9167                           ; 9163 D0 02                    ..
        inc     r2H                             ; 9165 E6 07                    ..
L9167:  jsr     L91E5                           ; 9167 20 E5 91                  ..
        jsr     CalcBlksFree                    ; 916A 20 DB C1                  ..
        pla                                     ; 916D 68                       h
        sta     r3L                             ; 916E 85 08                    ..
        pla                                     ; 9170 68                       h
        sta     r3H                             ; 9171 85 09                    ..
        ldx     #$03                            ; 9173 A2 03                    ..
        lda     r2H                             ; 9175 A5 07                    ..
        cmp     r4H                             ; 9177 C5 0B                    ..
        bne     L917F                           ; 9179 D0 04                    ..
        lda     r2L                             ; 917B A5 06                    ..
        cmp     r4L                             ; 917D C5 0A                    ..
L917F:  beq     L9183                           ; 917F F0 02                    ..
        bcs     L91DE                           ; 9181 B0 5B                    .[
L9183:  lda     r6H                             ; 9183 A5 0F                    ..
        sta     r4H                             ; 9185 85 0B                    ..
        lda     r6L                             ; 9187 A5 0E                    ..
        sta     r4L                             ; 9189 85 0A                    ..
        lda     r2H                             ; 918B A5 07                    ..
        sta     r5H                             ; 918D 85 0D                    ..
        lda     r2L                             ; 918F A5 06                    ..
        sta     r5L                             ; 9191 85 0C                    ..
L9193:  jsr     SetNextFree                     ; 9193 20 92 C2                  ..
        txa                                     ; 9196 8A                       .
        bne     L91DE                           ; 9197 D0 45                    .E
        ldy     #$00                            ; 9199 A0 00                    ..
        lda     r3L                             ; 919B A5 08                    ..
        sta     (r4L),y                         ; 919D 91 0A                    ..
        iny                                     ; 919F C8                       .
        lda     r3H                             ; 91A0 A5 09                    ..
        sta     (r4L),y                         ; 91A2 91 0A                    ..
        clc                                     ; 91A4 18                       .
        lda     #$02                            ; 91A5 A9 02                    ..
        adc     r4L                             ; 91A7 65 0A                    e.
        sta     r4L                             ; 91A9 85 0A                    ..
        bcc     L91AF                           ; 91AB 90 02                    ..
        inc     r4H                             ; 91AD E6 0B                    ..
L91AF:  lda     L9678                           ; 91AF AD 78 96                 .x.
        beq     L91BD                           ; 91B2 F0 09                    ..
        dec     L9678                           ; 91B4 CE 78 96                 .x.
        bne     L91BD                           ; 91B7 D0 04                    ..
        lda     #$23                            ; 91B9 A9 23                    .#
        sta     r3L                             ; 91BB 85 08                    ..
L91BD:  lda     r5L                             ; 91BD A5 0C                    ..
        bne     L91C3                           ; 91BF D0 02                    ..
        dec     r5H                             ; 91C1 C6 0D                    ..
L91C3:  dec     r5L                             ; 91C3 C6 0C                    ..
        lda     r5L                             ; 91C5 A5 0C                    ..
        ora     r5H                             ; 91C7 05 0D                    ..
        bne     L9193                           ; 91C9 D0 C8                    ..
        ldy     #$00                            ; 91CB A0 00                    ..
        tya                                     ; 91CD 98                       .
        sta     (r4L),y                         ; 91CE 91 0A                    ..
        iny                                     ; 91D0 C8                       .
        lda     r8L                             ; 91D1 A5 12                    ..
        bne     L91D7                           ; 91D3 D0 02                    ..
        lda     #$FE                            ; 91D5 A9 FE                    ..
L91D7:  clc                                     ; 91D7 18                       .
        adc     #$01                            ; 91D8 69 01                    i.
        sta     (r4L),y                         ; 91DA 91 0A                    ..
        ldx     #$00                            ; 91DC A2 00                    ..
L91DE:  pla                                     ; 91DE 68                       h
        sta     r9L                             ; 91DF 85 14                    ..
        pla                                     ; 91E1 68                       h
        sta     r9H                             ; 91E2 85 15                    ..
        rts                                     ; 91E4 60                       `

; ----------------------------------------------------------------------------
L91E5:  lda     #$82                            ; 91E5 A9 82                    ..
        sta     r5H                             ; 91E7 85 0D                    ..
        lda     #$00                            ; 91E9 A9 00                    ..
        sta     r5L                             ; 91EB 85 0C                    ..
        rts                                     ; 91ED 60                       `

; ----------------------------------------------------------------------------
_Get1stDirEntry:
        jsr     L90C1                           ; 91EE 20 C1 90                  ..
        inc     r1H                             ; 91F1 E6 05                    ..
        lda     #$00                            ; 91F3 A9 00                    ..
        sta     L9679                           ; 91F5 8D 79 96                 .y.
        beq     L9236                           ; 91F8 F0 3C                    .<
_GetNxtDirEntry:
        ldx     #$00                            ; 91FA A2 00                    ..
        ldy     #$00                            ; 91FC A0 00                    ..
        clc                                     ; 91FE 18                       .
        lda     #$20                            ; 91FF A9 20                    . 
        adc     r5L                             ; 9201 65 0C                    e.
        sta     r5L                             ; 9203 85 0C                    ..
        bcc     L9209                           ; 9205 90 02                    ..
        inc     r5H                             ; 9207 E6 0D                    ..
L9209:  lda     r5H                             ; 9209 A5 0D                    ..
        cmp     #$80                            ; 920B C9 80                    ..
        bne     L9213                           ; 920D D0 04                    ..
        lda     r5L                             ; 920F A5 0C                    ..
        cmp     #$FF                            ; 9211 C9 FF                    ..
L9213:  bcc     L9243                           ; 9213 90 2E                    ..
        ldy     #$FF                            ; 9215 A0 FF                    ..
        lda     $8001                           ; 9217 AD 01 80                 ...
        sta     r1H                             ; 921A 85 05                    ..
        lda     diskBlkBuf                      ; 921C AD 00 80                 ...
        sta     r1L                             ; 921F 85 04                    ..
        bne     L9236                           ; 9221 D0 13                    ..
        lda     L9679                           ; 9223 AD 79 96                 .y.
        bne     L9243                           ; 9226 D0 1B                    ..
        lda     #$FF                            ; 9228 A9 FF                    ..
        sta     L9679                           ; 922A 8D 79 96                 .y.
        jsr     GetBorder                       ; 922D 20 36 90                  6.
        txa                                     ; 9230 8A                       .
        bne     L9243                           ; 9231 D0 10                    ..
        tya                                     ; 9233 98                       .
        bne     L9243                           ; 9234 D0 0D                    ..
L9236:  jsr     ReadBuff                        ; 9236 20 3C 90                  <.
        ldy     #$00                            ; 9239 A0 00                    ..
        lda     #$80                            ; 923B A9 80                    ..
        sta     r5H                             ; 923D 85 0D                    ..
        lda     #$02                            ; 923F A9 02                    ..
        sta     r5L                             ; 9241 85 0C                    ..
L9243:  rts                                     ; 9243 60                       `

; ----------------------------------------------------------------------------
_GetBorder:
        jsr     GetDirHead                      ; 9244 20 47 C2                  G.
        txa                                     ; 9247 8A                       .
        bne     L9264                           ; 9248 D0 1A                    ..
        jsr     L91E5                           ; 924A 20 E5 91                  ..
        jsr     ChkDkGEOS                       ; 924D 20 DE C1                  ..
        bne     L9256                           ; 9250 D0 04                    ..
        ldy     #$FF                            ; 9252 A0 FF                    ..
        bne     L9262                           ; 9254 D0 0C                    ..
L9256:  lda     $82AC                           ; 9256 AD AC 82                 ...
        sta     r1H                             ; 9259 85 05                    ..
        lda     $82AB                           ; 925B AD AB 82                 ...
        sta     r1L                             ; 925E 85 04                    ..
        ldy     #$00                            ; 9260 A0 00                    ..
L9262:  ldx     #$00                            ; 9262 A2 00                    ..
L9264:  rts                                     ; 9264 60                       `

; ----------------------------------------------------------------------------
__ChkDkGEOS:
        ldy     #$AD                            ; 9265 A0 AD                    ..
        ldx     #$00                            ; 9267 A2 00                    ..
        stx     isGEOS                          ; 9269 8E 8B 84                 ...
L926C:  lda     (r5L),y                         ; 926C B1 0C                    ..
        cmp     L9282,x                         ; 926E DD 82 92                 ...
        bne     L927E                           ; 9271 D0 0B                    ..
        iny                                     ; 9273 C8                       .
        inx                                     ; 9274 E8                       .
        cpx     #$0B                            ; 9275 E0 0B                    ..
        bne     L926C                           ; 9277 D0 F3                    ..
        lda     #$FF                            ; 9279 A9 FF                    ..
        sta     isGEOS                          ; 927B 8D 8B 84                 ...
L927E:  lda     isGEOS                          ; 927E AD 8B 84                 ...
        rts                                     ; 9281 60                       `

; ----------------------------------------------------------------------------
L9282:  .byte   "GEOS format V1.0"              ; 9282 47 45 4F 53 20 66 6F 72  GEOS for
                                                ; 928A 6D 61 74 20 56 31 2E 30  mat V1.0
        .byte   $00                             ; 9292 00                       .
; ----------------------------------------------------------------------------
__GetFreeDirBlk:
        php                                     ; 9293 08                       .
        sei                                     ; 9294 78                       x
        lda     r6L                             ; 9295 A5 0E                    ..
        pha                                     ; 9297 48                       H
        lda     r2H                             ; 9298 A5 07                    ..
        pha                                     ; 929A 48                       H
        lda     r2L                             ; 929B A5 06                    ..
        pha                                     ; 929D 48                       H
        ldx     r10L                            ; 929E A6 16                    ..
        inx                                     ; 92A0 E8                       .
        stx     r6L                             ; 92A1 86 0E                    ..
        lda     #$28                            ; 92A3 A9 28                    .(
        sta     r1L                             ; 92A5 85 04                    ..
        lda     #$03                            ; 92A7 A9 03                    ..
        sta     r1H                             ; 92A9 85 05                    ..
L92AB:  jsr     ReadBuff                        ; 92AB 20 3C 90                  <.
L92AE:  txa                                     ; 92AE 8A                       .
        bne     L92E9                           ; 92AF D0 38                    .8
        dec     r6L                             ; 92B1 C6 0E                    ..
        beq     L92CA                           ; 92B3 F0 15                    ..
L92B5:  lda     diskBlkBuf                      ; 92B5 AD 00 80                 ...
        bne     L92C0                           ; 92B8 D0 06                    ..
        jsr     AddDirBlock                     ; 92BA 20 39 90                  9.
        clv                                     ; 92BD B8                       .
        bvc     L92AE                           ; 92BE 50 EE                    P.
L92C0:  sta     r1L                             ; 92C0 85 04                    ..
        lda     $8001                           ; 92C2 AD 01 80                 ...
        sta     r1H                             ; 92C5 85 05                    ..
        clv                                     ; 92C7 B8                       .
        bvc     L92AB                           ; 92C8 50 E1                    P.
L92CA:  ldy     #$02                            ; 92CA A0 02                    ..
        ldx     #$00                            ; 92CC A2 00                    ..
L92CE:  lda     diskBlkBuf,y                    ; 92CE B9 00 80                 ...
        beq     L92E9                           ; 92D1 F0 16                    ..
        tya                                     ; 92D3 98                       .
        clc                                     ; 92D4 18                       .
        adc     #$20                            ; 92D5 69 20                    i 
        tay                                     ; 92D7 A8                       .
        bcc     L92CE                           ; 92D8 90 F4                    ..
        lda     #$01                            ; 92DA A9 01                    ..
        sta     r6L                             ; 92DC 85 0E                    ..
        ldx     #$04                            ; 92DE A2 04                    ..
        ldy     r10L                            ; 92E0 A4 16                    ..
        iny                                     ; 92E2 C8                       .
        sty     r10L                            ; 92E3 84 16                    ..
        cpy     #$12                            ; 92E5 C0 12                    ..
        bcc     L92B5                           ; 92E7 90 CC                    ..
L92E9:  pla                                     ; 92E9 68                       h
        sta     r2L                             ; 92EA 85 06                    ..
        pla                                     ; 92EC 68                       h
        sta     r2H                             ; 92ED 85 07                    ..
        pla                                     ; 92EF 68                       h
        sta     r6L                             ; 92F0 85 0E                    ..
        plp                                     ; 92F2 28                       (
        rts                                     ; 92F3 60                       `

; ----------------------------------------------------------------------------
_AddDirBlock:
        lda     r6H                             ; 92F4 A5 0F                    ..
        pha                                     ; 92F6 48                       H
        lda     r6L                             ; 92F7 A5 0E                    ..
        pha                                     ; 92F9 48                       H
        ldx     #$04                            ; 92FA A2 04                    ..
        lda     $89FA                           ; 92FC AD FA 89                 ...
        beq     L9327                           ; 92FF F0 26                    .&
        lda     r1H                             ; 9301 A5 05                    ..
        sta     r3H                             ; 9303 85 09                    ..
        lda     r1L                             ; 9305 A5 04                    ..
        sta     r3L                             ; 9307 85 08                    ..
        jsr     SetNextFree                     ; 9309 20 92 C2                  ..
        lda     r3H                             ; 930C A5 09                    ..
        sta     $8001                           ; 930E 8D 01 80                 ...
        lda     r3L                             ; 9311 A5 08                    ..
        sta     diskBlkBuf                      ; 9313 8D 00 80                 ...
        jsr     WriteBuff                       ; 9316 20 3F 90                  ?.
        txa                                     ; 9319 8A                       .
        bne     L9327                           ; 931A D0 0B                    ..
        lda     r3H                             ; 931C A5 09                    ..
        sta     r1H                             ; 931E 85 05                    ..
        lda     r3L                             ; 9320 A5 08                    ..
        sta     r1L                             ; 9322 85 04                    ..
        jsr     L932E                           ; 9324 20 2E 93                  ..
L9327:  pla                                     ; 9327 68                       h
        sta     r6L                             ; 9328 85 0E                    ..
        pla                                     ; 932A 68                       h
        sta     r6H                             ; 932B 85 0F                    ..
        rts                                     ; 932D 60                       `

; ----------------------------------------------------------------------------
L932E:  lda     #$00                            ; 932E A9 00                    ..
        tay                                     ; 9330 A8                       .
L9331:  sta     diskBlkBuf,y                    ; 9331 99 00 80                 ...
        iny                                     ; 9334 C8                       .
        bne     L9331                           ; 9335 D0 FA                    ..
        dey                                     ; 9337 88                       .
        sty     $8001                           ; 9338 8C 01 80                 ...
        jmp     WriteBuff                       ; 933B 4C 3F 90                 L?.

; ----------------------------------------------------------------------------
__SetNextFree:
        jsr     L9348                           ; 933E 20 48 93                  H.
        bne     L9344                           ; 9341 D0 01                    ..
        rts                                     ; 9343 60                       `

; ----------------------------------------------------------------------------
L9344:  lda     #$27                            ; 9344 A9 27                    .'
        sta     r3L                             ; 9346 85 08                    ..
L9348:  lda     r3H                             ; 9348 A5 09                    ..
        clc                                     ; 934A 18                       .
        adc     #$01                            ; 934B 69 01                    i.
        sta     r6H                             ; 934D 85 0F                    ..
        lda     r3L                             ; 934F A5 08                    ..
        sta     r6L                             ; 9351 85 0E                    ..
        cmp     #$28                            ; 9353 C9 28                    .(
        beq     L935D                           ; 9355 F0 06                    ..
L9357:  lda     r6L                             ; 9357 A5 0E                    ..
        cmp     #$28                            ; 9359 C9 28                    .(
        beq     L938F                           ; 935B F0 32                    .2
L935D:  cmp     #$29                            ; 935D C9 29                    .)
        bcc     L9364                           ; 935F 90 03                    ..
        sec                                     ; 9361 38                       8
        sbc     #$28                            ; 9362 E9 28                    .(
L9364:  sec                                     ; 9364 38                       8
        sbc     #$01                            ; 9365 E9 01                    ..
        asl     a                               ; 9367 0A                       .
        sta     r7L                             ; 9368 85 10                    ..
        asl     a                               ; 936A 0A                       .
        clc                                     ; 936B 18                       .
        adc     r7L                             ; 936C 65 10                    e.
        tax                                     ; 936E AA                       .
        lda     r6L                             ; 936F A5 0E                    ..
        cmp     #$29                            ; 9371 C9 29                    .)
        bcc     L937B                           ; 9373 90 06                    ..
        lda     $9C90,x                         ; 9375 BD 90 9C                 ...
        clv                                     ; 9378 B8                       .
        bvc     L937E                           ; 9379 50 03                    P.
L937B:  lda     $8910,x                         ; 937B BD 10 89                 ...
L937E:  beq     L938F                           ; 937E F0 0F                    ..
        lda     #$28                            ; 9380 A9 28                    .(
        sta     r7L                             ; 9382 85 10                    ..
        tay                                     ; 9384 A8                       .
L9385:  jsr     L93BB                           ; 9385 20 BB 93                  ..
        beq     L93AD                           ; 9388 F0 23                    .#
        inc     r6H                             ; 938A E6 0F                    ..
        dey                                     ; 938C 88                       .
        bne     L9385                           ; 938D D0 F6                    ..
L938F:  lda     r6L                             ; 938F A5 0E                    ..
        cmp     #$29                            ; 9391 C9 29                    .)
        bcs     L939F                           ; 9393 B0 0A                    ..
        dec     r6L                             ; 9395 C6 0E                    ..
        bne     L93A1                           ; 9397 D0 08                    ..
        lda     #$29                            ; 9399 A9 29                    .)
        sta     r6L                             ; 939B 85 0E                    ..
        bne     L93A1                           ; 939D D0 02                    ..
L939F:  inc     r6L                             ; 939F E6 0E                    ..
L93A1:  lda     r6L                             ; 93A1 A5 0E                    ..
        cmp     #$51                            ; 93A3 C9 51                    .Q
        bcs     L93B8                           ; 93A5 B0 11                    ..
        lda     #$00                            ; 93A7 A9 00                    ..
        sta     r6H                             ; 93A9 85 0F                    ..
        beq     L9357                           ; 93AB F0 AA                    ..
L93AD:  lda     r6L                             ; 93AD A5 0E                    ..
        sta     r3L                             ; 93AF 85 08                    ..
        lda     r6H                             ; 93B1 A5 0F                    ..
        sta     r3H                             ; 93B3 85 09                    ..
        ldx     #$00                            ; 93B5 A2 00                    ..
        rts                                     ; 93B7 60                       `

; ----------------------------------------------------------------------------
L93B8:  ldx     #$03                            ; 93B8 A2 03                    ..
        rts                                     ; 93BA 60                       `

; ----------------------------------------------------------------------------
L93BB:  lda     r6H                             ; 93BB A5 0F                    ..
L93BD:  cmp     r7L                             ; 93BD C5 10                    ..
        bcc     L93C7                           ; 93BF 90 06                    ..
        sec                                     ; 93C1 38                       8
        sbc     r7L                             ; 93C2 E5 10                    ..
        clv                                     ; 93C4 B8                       .
        bvc     L93BD                           ; 93C5 50 F6                    P.
L93C7:  sta     r6H                             ; 93C7 85 0F                    ..
_AllocateBlock:
        jsr     FindBAMBit                      ; 93C9 20 AD C2                  ..
        bne     L93D1                           ; 93CC D0 03                    ..
        ldx     #$06                            ; 93CE A2 06                    ..
        rts                                     ; 93D0 60                       `

; ----------------------------------------------------------------------------
L93D1:  php                                     ; 93D1 08                       .
        lda     r6L                             ; 93D2 A5 0E                    ..
        cmp     #$29                            ; 93D4 C9 29                    .)
        bcc     L93F1                           ; 93D6 90 19                    ..
        lda     r8H                             ; 93D8 A5 13                    ..
        eor     $9C90,x                         ; 93DA 5D 90 9C                 ]..
        sta     $9C90,x                         ; 93DD 9D 90 9C                 ...
        ldx     r7H                             ; 93E0 A6 11                    ..
        plp                                     ; 93E2 28                       (
        beq     L93EB                           ; 93E3 F0 06                    ..
        dec     $9C90,x                         ; 93E5 DE 90 9C                 ...
        clv                                     ; 93E8 B8                       .
        bvc     L9407                           ; 93E9 50 1C                    P.
L93EB:  inc     $9C90,x                         ; 93EB FE 90 9C                 ...
        clv                                     ; 93EE B8                       .
        bvc     L9407                           ; 93EF 50 16                    P.
L93F1:  lda     r8H                             ; 93F1 A5 13                    ..
        eor     $8910,x                         ; 93F3 5D 10 89                 ]..
        sta     $8910,x                         ; 93F6 9D 10 89                 ...
        ldx     r7H                             ; 93F9 A6 11                    ..
        plp                                     ; 93FB 28                       (
        beq     L9404                           ; 93FC F0 06                    ..
        dec     $8910,x                         ; 93FE DE 10 89                 ...
        clv                                     ; 9401 B8                       .
        bvc     L9407                           ; 9402 50 03                    P.
L9404:  inc     $8910,x                         ; 9404 FE 10 89                 ...
L9407:  ldx     #$00                            ; 9407 A2 00                    ..
        rts                                     ; 9409 60                       `

; ----------------------------------------------------------------------------
__FreeBlock:
        jsr     FindBAMBit                      ; 940A 20 AD C2                  ..
        beq     L93D1                           ; 940D F0 C2                    ..
        ldx     #$06                            ; 940F A2 06                    ..
        rts                                     ; 9411 60                       `

; ----------------------------------------------------------------------------
__FindBAMBit:
        lda     r6H                             ; 9412 A5 0F                    ..
        and     #$07                            ; 9414 29 07                    ).
        tax                                     ; 9416 AA                       .
        lda     FBBBitTab,x                     ; 9417 BD 4C 94                 .L.
        sta     r8H                             ; 941A 85 13                    ..
        lda     r6L                             ; 941C A5 0E                    ..
        cmp     #$29                            ; 941E C9 29                    .)
        bcc     L9425                           ; 9420 90 03                    ..
        sec                                     ; 9422 38                       8
        sbc     #$28                            ; 9423 E9 28                    .(
L9425:  sec                                     ; 9425 38                       8
        sbc     #$01                            ; 9426 E9 01                    ..
        asl     a                               ; 9428 0A                       .
        sta     r7H                             ; 9429 85 11                    ..
        asl     a                               ; 942B 0A                       .
        clc                                     ; 942C 18                       .
        adc     r7H                             ; 942D 65 11                    e.
        sta     r7H                             ; 942F 85 11                    ..
        lda     r6H                             ; 9431 A5 0F                    ..
        lsr     a                               ; 9433 4A                       J
        lsr     a                               ; 9434 4A                       J
        lsr     a                               ; 9435 4A                       J
        sec                                     ; 9436 38                       8
        adc     r7H                             ; 9437 65 11                    e.
        tax                                     ; 9439 AA                       .
        lda     r6L                             ; 943A A5 0E                    ..
        cmp     #$29                            ; 943C C9 29                    .)
        bcc     L9446                           ; 943E 90 06                    ..
        lda     $9C90,x                         ; 9440 BD 90 9C                 ...
        and     r8H                             ; 9443 25 13                    %.
        rts                                     ; 9445 60                       `

; ----------------------------------------------------------------------------
L9446:  lda     $8910,x                         ; 9446 BD 10 89                 ...
        and     r8H                             ; 9449 25 13                    %.
        rts                                     ; 944B 60                       `

; ----------------------------------------------------------------------------
FBBBitTab:
        .byte   $01,$02,$04,$08,$10,$20,$40,$80 ; 944C 01 02 04 08 10 20 40 80  ..... @.
; ----------------------------------------------------------------------------
__CalcBlksFree:
        lda     #$00                            ; 9454 A9 00                    ..
        sta     r4L                             ; 9456 85 0A                    ..
        sta     r4H                             ; 9458 85 0B                    ..
        ldy     #$10                            ; 945A A0 10                    ..
L945C:  lda     dir2Head,y                      ; 945C B9 00 89                 ...
        clc                                     ; 945F 18                       .
        adc     r4L                             ; 9460 65 0A                    e.
        sta     r4L                             ; 9462 85 0A                    ..
        bcc     L9468                           ; 9464 90 02                    ..
        inc     r4H                             ; 9466 E6 0B                    ..
L9468:  tya                                     ; 9468 98                       .
        clc                                     ; 9469 18                       .
        adc     #$06                            ; 946A 69 06                    i.
        tay                                     ; 946C A8                       .
        cpy     #$FA                            ; 946D C0 FA                    ..
        beq     L9468                           ; 946F F0 F7                    ..
        cpy     #$00                            ; 9471 C0 00                    ..
        bne     L945C                           ; 9473 D0 E7                    ..
        ldy     #$10                            ; 9475 A0 10                    ..
L9477:  lda     $9C80,y                         ; 9477 B9 80 9C                 ...
        clc                                     ; 947A 18                       .
        adc     r4L                             ; 947B 65 0A                    e.
        sta     r4L                             ; 947D 85 0A                    ..
        bcc     L9483                           ; 947F 90 02                    ..
        inc     r4H                             ; 9481 E6 0B                    ..
L9483:  tya                                     ; 9483 98                       .
        clc                                     ; 9484 18                       .
        adc     #$06                            ; 9485 69 06                    i.
        tay                                     ; 9487 A8                       .
        bne     L9477                           ; 9488 D0 ED                    ..
        lda     #$0C                            ; 948A A9 0C                    ..
        sta     r3H                             ; 948C 85 09                    ..
        lda     #$58                            ; 948E A9 58                    .X
        sta     r3L                             ; 9490 85 08                    ..
        rts                                     ; 9492 60                       `

; ----------------------------------------------------------------------------
__SetGEOSDisk:
        jsr     GetDirHead                      ; 9493 20 47 C2                  G.
        txa                                     ; 9496 8A                       .
        bne     L94DE                           ; 9497 D0 45                    .E
        jsr     L91E5                           ; 9499 20 E5 91                  ..
        jsr     CalcBlksFree                    ; 949C 20 DB C1                  ..
        ldx     #$03                            ; 949F A2 03                    ..
        lda     r4L                             ; 94A1 A5 0A                    ..
        ora     r4H                             ; 94A3 05 0B                    ..
        beq     L94DE                           ; 94A5 F0 37                    .7
        lda     #$28                            ; 94A7 A9 28                    .(
        sta     r3L                             ; 94A9 85 08                    ..
        lda     #$12                            ; 94AB A9 12                    ..
        sta     r3H                             ; 94AD 85 09                    ..
        jsr     SetNextFree                     ; 94AF 20 92 C2                  ..
        txa                                     ; 94B2 8A                       .
        bne     L94DE                           ; 94B3 D0 29                    .)
        lda     r3H                             ; 94B5 A5 09                    ..
        sta     r1H                             ; 94B7 85 05                    ..
        lda     r3L                             ; 94B9 A5 08                    ..
        sta     r1L                             ; 94BB 85 04                    ..
        jsr     L932E                           ; 94BD 20 2E 93                  ..
        txa                                     ; 94C0 8A                       .
        bne     L94DE                           ; 94C1 D0 1B                    ..
        lda     r1H                             ; 94C3 A5 05                    ..
        sta     $82AC                           ; 94C5 8D AC 82                 ...
        lda     r1L                             ; 94C8 A5 04                    ..
        sta     $82AB                           ; 94CA 8D AB 82                 ...
        ldy     #$BC                            ; 94CD A0 BC                    ..
        ldx     #$0F                            ; 94CF A2 0F                    ..
L94D1:  lda     L9282,x                         ; 94D1 BD 82 92                 ...
        sta     curDirHead,y                    ; 94D4 99 00 82                 ...
        dey                                     ; 94D7 88                       .
        dex                                     ; 94D8 CA                       .
        bpl     L94D1                           ; 94D9 10 F6                    ..
        jsr     PutDirHead                      ; 94DB 20 4A C2                  J.
L94DE:  rts                                     ; 94DE 60                       `

; ----------------------------------------------------------------------------
__InitForIO:
        php                                     ; 94DF 08                       .
        pla                                     ; 94E0 68                       h
        sta     L966A                           ; 94E1 8D 6A 96                 .j.
        sei                                     ; 94E4 78                       x
        lda     CPU_DATA                        ; 94E5 A5 01                    ..
        sta     L966C                           ; 94E7 8D 6C 96                 .l.
        lda     #$36                            ; 94EA A9 36                    .6
        sta     CPU_DATA                        ; 94EC 85 01                    ..
        lda     grirqen                         ; 94EE AD 1A D0                 ...
        sta     L966B                           ; 94F1 8D 6B 96                 .k.
        lda     clkreg                          ; 94F4 AD 30 D0                 .0.
        sta     L9669                           ; 94F7 8D 69 96                 .i.
        ldy     #$00                            ; 94FA A0 00                    ..
        sty     clkreg                          ; 94FC 8C 30 D0                 .0.
        sty     grirqen                         ; 94FF 8C 1A D0                 ...
        lda     #$7F                            ; 9502 A9 7F                    ..
        sta     grirq                           ; 9504 8D 19 D0                 ...
        sta     $DC0D                           ; 9507 8D 0D DC                 ...
        sta     $DD0D                           ; 950A 8D 0D DD                 ...
        lda     #$95                            ; 950D A9 95                    ..
        sta     $0315                           ; 950F 8D 15 03                 ...
        lda     #$4F                            ; 9512 A9 4F                    .O
        sta     irqvec                          ; 9514 8D 14 03                 ...
        lda     #$95                            ; 9517 A9 95                    ..
        sta     $0319                           ; 9519 8D 19 03                 ...
        lda     #$54                            ; 951C A9 54                    .T
        sta     nmivec                          ; 951E 8D 18 03                 ...
        lda     #$3F                            ; 9521 A9 3F                    .?
        sta     $DD02                           ; 9523 8D 02 DD                 ...
        lda     mobenble                        ; 9526 AD 15 D0                 ...
        sta     L966D                           ; 9529 8D 6D 96                 .m.
        sty     mobenble                        ; 952C 8C 15 D0                 ...
        sty     $DD05                           ; 952F 8C 05 DD                 ...
        iny                                     ; 9532 C8                       .
        sty     $DD04                           ; 9533 8C 04 DD                 ...
        lda     #$81                            ; 9536 A9 81                    ..
        sta     $DD0D                           ; 9538 8D 0D DD                 ...
        lda     #$09                            ; 953B A9 09                    ..
        sta     $DD0E                           ; 953D 8D 0E DD                 ...
        ldy     #$2C                            ; 9540 A0 2C                    .,
L9542:  lda     rasreg                          ; 9542 AD 12 D0                 ...
        cmp     TURBO_DD00_CPY                  ; 9545 C5 8F                    ..
        beq     L9542                           ; 9547 F0 F9                    ..
        sta     TURBO_DD00_CPY                  ; 9549 85 8F                    ..
        dey                                     ; 954B 88                       .
        bne     L9542                           ; 954C D0 F4                    ..
        rts                                     ; 954E 60                       `

; ----------------------------------------------------------------------------
        pla                                     ; 954F 68                       h
        tay                                     ; 9550 A8                       .
        pla                                     ; 9551 68                       h
        tax                                     ; 9552 AA                       .
        pla                                     ; 9553 68                       h
        rti                                     ; 9554 40                       @

; ----------------------------------------------------------------------------
__DoneWithIO:
        sei                                     ; 9555 78                       x
        lda     L9669                           ; 9556 AD 69 96                 .i.
        sta     clkreg                          ; 9559 8D 30 D0                 .0.
        lda     L966D                           ; 955C AD 6D 96                 .m.
        sta     mobenble                        ; 955F 8D 15 D0                 ...
        lda     #$7F                            ; 9562 A9 7F                    ..
        sta     $DD0D                           ; 9564 8D 0D DD                 ...
        lda     $DD0D                           ; 9567 AD 0D DD                 ...
        lda     L966B                           ; 956A AD 6B 96                 .k.
        sta     grirqen                         ; 956D 8D 1A D0                 ...
        lda     L966C                           ; 9570 AD 6C 96                 .l.
        sta     CPU_DATA                        ; 9573 85 01                    ..
        lda     L966A                           ; 9575 AD 6A 96                 .j.
        pha                                     ; 9578 48                       H
        plp                                     ; 9579 28                       (
        rts                                     ; 957A 60                       `

; ----------------------------------------------------------------------------
__EnterTurbo:
        lda     curDrive                        ; 957B AD 89 84                 ...
        jsr     SetDevice                       ; 957E 20 B0 C2                  ..
        ldx     #$00                            ; 9581 A2 00                    ..
        rts                                     ; 9583 60                       `

; ----------------------------------------------------------------------------
__ExitTurbo:
        lda     #$01                            ; 9584 A9 01                    ..
        sta     interleave                      ; 9586 8D 8C 84                 ...
        rts                                     ; 9589 60                       `

; ----------------------------------------------------------------------------
__ChangeDiskDevice:
        sta     curDrive                        ; 958A 8D 89 84                 ...
        sta     curDevice                       ; 958D 85 BA                    ..
        ldx     #$00                            ; 958F A2 00                    ..
        rts                                     ; 9591 60                       `

; ----------------------------------------------------------------------------
__NewDisk:
        jsr     EnterTurbo                      ; 9592 20 14 C2                  ..
        rts                                     ; 9595 60                       `

; ----------------------------------------------------------------------------
__ReadBlock:
        jsr     L90D2                           ; 9596 20 D2 90                  ..
        bcc     L959E                           ; 9599 90 03                    ..
        jsr     L95BD                           ; 959B 20 BD 95                  ..
L959E:  ldy     #$00                            ; 959E A0 00                    ..
        rts                                     ; 95A0 60                       `

; ----------------------------------------------------------------------------
_ReadLink:
        jsr     L90D2                           ; 95A1 20 D2 90                  ..
        bcc     L95AB                           ; 95A4 90 05                    ..
        ldy     #$91                            ; 95A6 A0 91                    ..
        jsr     L95C5                           ; 95A8 20 C5 95                  ..
L95AB:  rts                                     ; 95AB 60                       `

; ----------------------------------------------------------------------------
__WriteBlock:
        jsr     L90D2                           ; 95AC 20 D2 90                  ..
        bcc     L95B4                           ; 95AF 90 03                    ..
        jsr     L95C1                           ; 95B1 20 C1 95                  ..
L95B4:  rts                                     ; 95B4 60                       `

; ----------------------------------------------------------------------------
__VerWriteBlock:
        jsr     L90D2                           ; 95B5 20 D2 90                  ..
        bcc     L95BC                           ; 95B8 90 02                    ..
        ldx     #$00                            ; 95BA A2 00                    ..
L95BC:  rts                                     ; 95BC 60                       `

; ----------------------------------------------------------------------------
L95BD:  ldy     #$91                            ; 95BD A0 91                    ..
        bne     L95D5                           ; 95BF D0 14                    ..
L95C1:  ldy     #$90                            ; 95C1 A0 90                    ..
        bne     L95D5                           ; 95C3 D0 10                    ..
L95C5:  lda     r2H                             ; 95C5 A5 07                    ..
        pha                                     ; 95C7 48                       H
        lda     r2L                             ; 95C8 A5 06                    ..
        pha                                     ; 95CA 48                       H
        lda     #$00                            ; 95CB A9 00                    ..
        sta     r2H                             ; 95CD 85 07                    ..
        lda     #$02                            ; 95CF A9 02                    ..
        sta     r2L                             ; 95D1 85 06                    ..
        bne     L95E3                           ; 95D3 D0 0E                    ..
L95D5:  lda     r2H                             ; 95D5 A5 07                    ..
        pha                                     ; 95D7 48                       H
        lda     r2L                             ; 95D8 A5 06                    ..
        pha                                     ; 95DA 48                       H
        lda     #$01                            ; 95DB A9 01                    ..
        sta     r2H                             ; 95DD 85 07                    ..
        lda     #$00                            ; 95DF A9 00                    ..
        sta     r2L                             ; 95E1 85 06                    ..
L95E3:  lda     r0H                             ; 95E3 A5 03                    ..
        pha                                     ; 95E5 48                       H
        lda     r0L                             ; 95E6 A5 02                    ..
        pha                                     ; 95E8 48                       H
        lda     r1H                             ; 95E9 A5 05                    ..
        pha                                     ; 95EB 48                       H
        lda     r1L                             ; 95EC A5 04                    ..
        pha                                     ; 95EE 48                       H
        lda     r3L                             ; 95EF A5 08                    ..
        pha                                     ; 95F1 48                       H
        tya                                     ; 95F2 98                       .
        pha                                     ; 95F3 48                       H
        lda     r2H                             ; 95F4 A5 07                    ..
        pha                                     ; 95F6 48                       H
        lda     r2L                             ; 95F7 A5 06                    ..
        pha                                     ; 95F9 48                       H
        lda     r7H                             ; 95FA A5 11                    ..
        pha                                     ; 95FC 48                       H
        lda     r7L                             ; 95FD A5 10                    ..
        pha                                     ; 95FF 48                       H
        lda     r8H                             ; 9600 A5 13                    ..
        pha                                     ; 9602 48                       H
        lda     r8L                             ; 9603 A5 12                    ..
        pha                                     ; 9605 48                       H
        dec     r1L                             ; 9606 C6 04                    ..
        lda     r1H                             ; 9608 A5 05                    ..
        sta     r2H                             ; 960A 85 07                    ..
        lda     #$28                            ; 960C A9 28                    .(
        sta     r2L                             ; 960E 85 06                    ..
        ldx     #$04                            ; 9610 A2 04                    ..
        ldy     #$06                            ; 9612 A0 06                    ..
        jsr     BBMult                          ; 9614 20 60 C1                  `.
        clc                                     ; 9617 18                       .
        lda     r1L                             ; 9618 A5 04                    ..
        adc     r2H                             ; 961A 65 07                    e.
        sta     r1L                             ; 961C 85 04                    ..
        lda     r1H                             ; 961E A5 05                    ..
        ldy     curDrive                        ; 9620 AC 89 84                 ...
        adc     driveData,y                     ; 9623 79 BF 88                 y..
        sta     r3L                             ; 9626 85 08                    ..
        lda     r1L                             ; 9628 A5 04                    ..
        sta     r1H                             ; 962A 85 05                    ..
        pla                                     ; 962C 68                       h
        sta     r8L                             ; 962D 85 12                    ..
        pla                                     ; 962F 68                       h
        sta     r8H                             ; 9630 85 13                    ..
        pla                                     ; 9632 68                       h
        sta     r7L                             ; 9633 85 10                    ..
        pla                                     ; 9635 68                       h
        sta     r7H                             ; 9636 85 11                    ..
        pla                                     ; 9638 68                       h
        sta     r2L                             ; 9639 85 06                    ..
        pla                                     ; 963B 68                       h
        sta     r2H                             ; 963C 85 07                    ..
        lda     #$00                            ; 963E A9 00                    ..
        sta     r1L                             ; 9640 85 04                    ..
        lda     r4H                             ; 9642 A5 0B                    ..
        sta     r0H                             ; 9644 85 03                    ..
        lda     r4L                             ; 9646 A5 0A                    ..
        sta     r0L                             ; 9648 85 02                    ..
        pla                                     ; 964A 68                       h
        tay                                     ; 964B A8                       .
        jsr     DoRAMOp                         ; 964C 20 D4 C2                  ..
        tax                                     ; 964F AA                       .
        pla                                     ; 9650 68                       h
        sta     r3L                             ; 9651 85 08                    ..
        pla                                     ; 9653 68                       h
        sta     r1L                             ; 9654 85 04                    ..
        pla                                     ; 9656 68                       h
        sta     r1H                             ; 9657 85 05                    ..
        pla                                     ; 9659 68                       h
        sta     r0L                             ; 965A 85 02                    ..
        pla                                     ; 965C 68                       h
        sta     r0H                             ; 965D 85 03                    ..
        pla                                     ; 965F 68                       h
        sta     r2L                             ; 9660 85 06                    ..
        pla                                     ; 9662 68                       h
        sta     r2H                             ; 9663 85 07                    ..
        txa                                     ; 9665 8A                       .
        ldx     #$00                            ; 9666 A2 00                    ..
        rts                                     ; 9668 60                       `

; ----------------------------------------------------------------------------
L9669:  brk                                     ; 9669 00                       .
L966A:  brk                                     ; 966A 00                       .
L966B:  brk                                     ; 966B 00                       .
L966C:  brk                                     ; 966C 00                       .
L966D:  brk                                     ; 966D 00                       .
        brk                                     ; 966E 00                       .
        brk                                     ; 966F 00                       .
        brk                                     ; 9670 00                       .
        brk                                     ; 9671 00                       .
        brk                                     ; 9672 00                       .
        brk                                     ; 9673 00                       .
L9674:  brk                                     ; 9674 00                       .
        brk                                     ; 9675 00                       .
        brk                                     ; 9676 00                       .
        brk                                     ; 9677 00                       .
L9678:  brk                                     ; 9678 00                       .
L9679:  brk                                     ; 9679 00                       .
        brk                                     ; 967A 00                       .
        brk                                     ; 967B 00                       .
        brk                                     ; 967C 00                       .
        brk                                     ; 967D 00                       .
        brk                                     ; 967E 00                       .
        .byte   "RAM 1581 driver Copyright (C) 1"; 967F 52 41 4D 20 31 35 38 31 RAM 1581
                                                ; 9687 20 64 72 69 76 65 72 20   driver 
                                                ; 968F 43 6F 70 79 72 69 67 68  Copyrigh
                                                ; 9697 74 20 28 43 29 20 31     t (C) 1
        .byte   "990, Jim Collette & Berkeley So"; 969E 39 39 30 2C 20 4A 69 6D 990, Jim
                                                ; 96A6 20 43 6F 6C 6C 65 74 74   Collett
                                                ; 96AE 65 20 26 20 42 65 72 6B  e & Berk
                                                ; 96B6 65 6C 65 79 20 53 6F     eley So
        .byte   "ftworks.  Thanks to Matt Lovele"; 96BD 66 74 77 6F 72 6B 73 2E ftworks.
                                                ; 96C5 20 20 54 68 61 6E 6B 73    Thanks
                                                ; 96CD 20 74 6F 20 4D 61 74 74   to Matt
                                                ; 96D5 20 4C 6F 76 65 6C 65      Lovele
        .byte   "ss and Angie McKenna of BSW for"; 96DC 73 73 20 61 6E 64 20 41 ss and A
                                                ; 96E4 6E 67 69 65 20 4D 63 4B  ngie McK
                                                ; 96EC 65 6E 6E 61 20 6F 66 20  enna of 
                                                ; 96F4 42 53 57 20 66 6F 72     BSW for
        .byte   " their help and support.  (Q-Li"; 96FB 20 74 68 65 69 72 20 68  their h
                                                ; 9703 65 6C 70 20 61 6E 64 20  elp and 
                                                ; 970B 73 75 70 70 6F 72 74 2E  support.
                                                ; 9713 20 20 28 51 2D 4C 69       (Q-Li
        .byte   "nk: GEOREP JIM)"               ; 971A 6E 6B 3A 20 47 45 4F 52  nk: GEOR
                                                ; 9722 45 50 20 4A 49 4D 29     EP JIM)
        .byte   $00                             ; 9729 00                       .
; ----------------------------------------------------------------------------
        pla                                     ; 972A 68                       h
