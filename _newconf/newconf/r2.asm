; da65 V2.15
; Created:    2017-07-30 15:27:26
; Input file: configure128.cvt.record.2
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
L033A           := $033A
L0340           := $0340
L037B           := $037B
L0389           := $0389
L03BE           := $03BE
L03CB           := $03CB
APP_RAM         := $0400
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
L3156           := $3156
L40A0           := $40A0
L4328           := $4328
BACK_SCR_BASE   := $6000
L6040           := $6040
L6216           := $6216
L656C           := $656C
L6F43           := $6F43
L6F53           := $6F53
L6F66           := $6F66
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
L9DD8           := $9DD8
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
LF24B           := $F24B
LF3B1           := $F3B1
LF4CA           := $F4CA
LF510           := $F510
LF5E9           := $F5E9
LF78F           := $F78F
LF97E           := $F97E
LF98F           := $F98F
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
        .addr   L9479                           ; 9000 79 94                    y.
_DoneWithIO:
        .addr   L9504                           ; 9002 04 95                    ..
_ExitTurbo:
        .addr   L9749                           ; 9004 49 97                    I.
_PurgeTurbo:
        .addr   L9769                           ; 9006 69 97                    i.
_EnterTurbo:
        .addr   L9663                           ; 9008 63 96                    c.
_ChangeDiskDevice:
        .addr   L97A7                           ; 900A A7 97                    ..
_NewDisk:
        .addr   L9778                           ; 900C 78 97                    x.
_ReadBlock:
        .addr   L97D5                           ; 900E D5 97                    ..
_WriteBlock:
        .addr   L981E                           ; 9010 1E 98                    ..
_VerWriteBlock:
        .addr   L9847                           ; 9012 47 98                    G.
_OpenDisk:
        .addr   L90BA                           ; 9014 BA 90                    ..
_GetBlock:
        .addr   L905B                           ; 9016 5B 90                    [.
_PutBlock:
        .addr   L9078                           ; 9018 78 90                    x.
_GetDirHead:
        .addr   L904E                           ; 901A 4E 90                    N.
_PutDirHead:
        .addr   L906B                           ; 901C 6B 90                    k.
_GetFreeDirBlk:
        .addr   L926F                           ; 901E 6F 92                    o.
_CalcBlksFree:
        .addr   L93F5                           ; 9020 F5 93                    ..
_FreeBlock:
        .addr   L93DD                           ; 9022 DD 93                    ..
_SetNextFree:
        .addr   L931C                           ; 9024 1C 93                    ..
_FindBAMBit:
        .addr   L93B6                           ; 9026 B6 93                    ..
_NxtBlkAlloc:
        .addr   L911C                           ; 9028 1C 91                    ..
_BlkAlloc:
        .addr   L9115                           ; 902A 15 91                    ..
_ChkDkGEOS:
        .addr   L923F                           ; 902C 3F 92                    ?.
_SetGEOSDisk:
        .addr   L941E                           ; 902E 1E 94                    ..
; ----------------------------------------------------------------------------
Get1stDirEntry:
        jmp     L91B6                           ; 9030 4C B6 91                 L..

; ----------------------------------------------------------------------------
GetNxtDirEntry:
        jmp     L91CF                           ; 9033 4C CF 91                 L..

; ----------------------------------------------------------------------------
GetBorder:
        jmp     L9219                           ; 9036 4C 19 92                 L..

; ----------------------------------------------------------------------------
AddDirBlock:
        jmp     L92D0                           ; 9039 4C D0 92                 L..

; ----------------------------------------------------------------------------
ReadBuff:
        jmp     L9053                           ; 903C 4C 53 90                 LS.

; ----------------------------------------------------------------------------
WriteBuff:
        jmp     L9070                           ; 903F 4C 70 90                 Lp.

; ----------------------------------------------------------------------------
        jmp     L9629                           ; 9042 4C 29 96                 L).

; ----------------------------------------------------------------------------
        jmp     L9889                           ; 9045 4C 89 98                 L..

; ----------------------------------------------------------------------------
AllocateBlock:
        jmp     L939C                           ; 9048 4C 9C 93                 L..

; ----------------------------------------------------------------------------
ReadLink:
        jmp     L97D5                           ; 904B 4C D5 97                 L..

; ----------------------------------------------------------------------------
L904E:  .byte   $20                             ; 904E 20                        
__GetDirHead:
        stx     $D090                           ; 904F 8E 90 D0                 ...
        php                                     ; 9052 08                       .
L9053:  lda     #$80                            ; 9053 A9 80                    ..
        sta     r4H                             ; 9055 85 0B                    ..
        lda     #$00                            ; 9057 A9 00                    ..
        sta     r4L                             ; 9059 85 0A                    ..
L905B:  jsr     EnterTurbo                      ; 905B 20 14 C2                  ..
        txa                                     ; 905E 8A                       .
        bne     L906A                           ; 905F D0 09                    ..
        jsr     InitForIO                       ; 9061 20 5C C2                  \.
        .byte   $20                             ; 9064 20                        
        .byte   $1A                             ; 9065 1A                       .
_ReadBuff:
        .byte   $C2                             ; 9066 C2                       .
        jsr     DoneWithIO                      ; 9067 20 5F C2                  _.
L906A:  rts                                     ; 906A 60                       `

; ----------------------------------------------------------------------------
L906B:  jsr     L908E                           ; 906B 20 8E 90                  ..
__GetBlock:
        bne     L9078                           ; 906E D0 08                    ..
L9070:  lda     #$80                            ; 9070 A9 80                    ..
        sta     r4H                             ; 9072 85 0B                    ..
        lda     #$00                            ; 9074 A9 00                    ..
        sta     r4L                             ; 9076 85 0A                    ..
L9078:  jsr     EnterTurbo                      ; 9078 20 14 C2                  ..
__PutDirHead:
        txa                                     ; 907B 8A                       .
        bne     L908D                           ; 907C D0 0F                    ..
        jsr     InitForIO                       ; 907E 20 5C C2                  \.
        jsr     WriteBlock                      ; 9081 20 20 C2                   .
        txa                                     ; 9084 8A                       .
        bne     L908A                           ; 9085 D0 03                    ..
        jsr     VerWriteBlock                   ; 9087 20 23 C2                  #.
L908A:  jsr     DoneWithIO                      ; 908A 20 5F C2                  _.
L908D:  rts                                     ; 908D 60                       `

; ----------------------------------------------------------------------------
L908E:  lda     #$12                            ; 908E A9 12                    ..
        sta     r1L                             ; 9090 85 04                    ..
        lda     #$00                            ; 9092 A9 00                    ..
        sta     r1H                             ; 9094 85 05                    ..
_WriteBuff:
        sta     r4L                             ; 9096 85 0A                    ..
        lda     #$82                            ; 9098 A9 82                    ..
        sta     r4H                             ; 909A 85 0B                    ..
        rts                                     ; 909C 60                       `

; ----------------------------------------------------------------------------
L909D:  .byte   $2C                             ; 909D 2C                       ,
__PutBlock:
        dec     $88                             ; 909E C6 88                    ..
        bvc     L90A7                           ; 90A0 50 05                    P.
        jsr     L9C6A                           ; 90A2 20 6A 9C                  j.
        beq     L90B8                           ; 90A5 F0 11                    ..
L90A7:  lda     #$00                            ; 90A7 A9 00                    ..
        sta     L9D37                           ; 90A9 8D 37 9D                 .7.
        ldx     #$02                            ; 90AC A2 02                    ..
        lda     r1L                             ; 90AE A5 04                    ..
        beq     L90B8                           ; 90B0 F0 06                    ..
        cmp     #$24                            ; 90B2 C9 24                    .$
        bcs     L90B8                           ; 90B4 B0 02                    ..
        sec                                     ; 90B6 38                       8
        rts                                     ; 90B7 60                       `

; ----------------------------------------------------------------------------
L90B8:  clc                                     ; 90B8 18                       .
        rts                                     ; 90B9 60                       `

; ----------------------------------------------------------------------------
L90BA:  ldy     curDrive                        ; 90BA AC 89 84                 ...
        lda     $8486,y                         ; 90BD B9 86 84                 ...
        sta     L9114                           ; 90C0 8D 14 91                 ...
        and     #$BF                            ; 90C3 29 BF                    ).
        sta     $8486,y                         ; 90C5 99 86 84                 ...
        jsr     NewDisk                         ; 90C8 20 E1 C1                  ..
        txa                                     ; 90CB 8A                       .
        bne     L910A                           ; 90CC D0 3C                    .<
        jsr     GetDirHead                      ; 90CE 20 47 C2                  G.
        txa                                     ; 90D1 8A                       .
        bne     L910A                           ; 90D2 D0 36                    .6
        bit     L9114                           ; 90D4 2C 14 91                 ,..
        bvc     L90E7                           ; 90D7 50 0E                    P.
        jsr     L9C6A                           ; 90D9 20 6A 9C                  j.
        beq     L90E7                           ; 90DC F0 09                    ..
        jsr     L9C18                           ; 90DE 20 18 9C                  ..
        jsr     L908E                           ; 90E1 20 8E 90                  ..
        .byte   $20                             ; 90E4 20                        
__OpenDisk:
        sty     $9C                             ; 90E5 84 9C                    ..
L90E7:  lda     #$82                            ; 90E7 A9 82                    ..
        sta     r5H                             ; 90E9 85 0D                    ..
        lda     #$00                            ; 90EB A9 00                    ..
        sta     r5L                             ; 90ED 85 0C                    ..
        jsr     ChkDkGEOS                       ; 90EF 20 DE C1                  ..
        lda     #$82                            ; 90F2 A9 82                    ..
        sta     r4H                             ; 90F4 85 0B                    ..
        lda     #$90                            ; 90F6 A9 90                    ..
        sta     r4L                             ; 90F8 85 0A                    ..
        ldx     #$0C                            ; 90FA A2 0C                    ..
        jsr     GetPtrCurDkNm                   ; 90FC 20 98 C2                  ..
        ldx     #$0A                            ; 90FF A2 0A                    ..
        ldy     #$0C                            ; 9101 A0 0C                    ..
        lda     #$12                            ; 9103 A9 12                    ..
        jsr     CopyFString                     ; 9105 20 68 C2                  h.
        ldx     #$00                            ; 9108 A2 00                    ..
L910A:  lda     L9114                           ; 910A AD 14 91                 ...
        ldy     curDrive                        ; 910D AC 89 84                 ...
__BlkAlloc:
        sta     $8486,y                         ; 9110 99 86 84                 ...
        rts                                     ; 9113 60                       `

; ----------------------------------------------------------------------------
L9114:  brk                                     ; 9114 00                       .
L9115:  ldy     #$01                            ; 9115 A0 01                    ..
        sty     r3L                             ; 9117 84 08                    ..
        dey                                     ; 9119 88                       .
        sty     r3H                             ; 911A 84 09                    ..
L911C:  lda     r9H                             ; 911C A5 15                    ..
        pha                                     ; 911E 48                       H
        lda     r9L                             ; 911F A5 14                    ..
        pha                                     ; 9121 48                       H
        lda     r3H                             ; 9122 A5 09                    ..
        pha                                     ; 9124 48                       H
        lda     r3L                             ; 9125 A5 08                    ..
        pha                                     ; 9127 48                       H
        lda     #$00                            ; 9128 A9 00                    ..
        sta     r3H                             ; 912A 85 09                    ..
        lda     #$FE                            ; 912C A9 FE                    ..
        sta     r3L                             ; 912E 85 08                    ..
        ldx     #$06                            ; 9130 A2 06                    ..
        ldy     #$08                            ; 9132 A0 08                    ..
        jsr     Ddiv                            ; 9134 20 69 C1                  i.
        lda     r8L                             ; 9137 A5 12                    ..
        beq     L9141                           ; 9139 F0 06                    ..
        inc     r2L                             ; 913B E6 06                    ..
__NxtBlkAlloc:
        bne     L9141                           ; 913D D0 02                    ..
        inc     r2H                             ; 913F E6 07                    ..
L9141:  lda     #$82                            ; 9141 A9 82                    ..
        sta     r5H                             ; 9143 85 0D                    ..
        lda     #$00                            ; 9145 A9 00                    ..
        sta     r5L                             ; 9147 85 0C                    ..
        jsr     CalcBlksFree                    ; 9149 20 DB C1                  ..
        pla                                     ; 914C 68                       h
        sta     r3L                             ; 914D 85 08                    ..
        pla                                     ; 914F 68                       h
        sta     r3H                             ; 9150 85 09                    ..
        ldx     #$03                            ; 9152 A2 03                    ..
        lda     r2H                             ; 9154 A5 07                    ..
        cmp     r4H                             ; 9156 C5 0B                    ..
        bne     L915E                           ; 9158 D0 04                    ..
        lda     r2L                             ; 915A A5 06                    ..
        cmp     r4L                             ; 915C C5 0A                    ..
L915E:  beq     L9162                           ; 915E F0 02                    ..
        bcs     L91AF                           ; 9160 B0 4D                    .M
L9162:  lda     r6H                             ; 9162 A5 0F                    ..
        sta     r4H                             ; 9164 85 0B                    ..
        lda     r6L                             ; 9166 A5 0E                    ..
        sta     r4L                             ; 9168 85 0A                    ..
        lda     r2H                             ; 916A A5 07                    ..
        sta     r5H                             ; 916C 85 0D                    ..
        lda     r2L                             ; 916E A5 06                    ..
        sta     r5L                             ; 9170 85 0C                    ..
L9172:  jsr     SetNextFree                     ; 9172 20 92 C2                  ..
        txa                                     ; 9175 8A                       .
        bne     L91AF                           ; 9176 D0 37                    .7
        ldy     #$00                            ; 9178 A0 00                    ..
        lda     r3L                             ; 917A A5 08                    ..
        sta     (r4L),y                         ; 917C 91 0A                    ..
        iny                                     ; 917E C8                       .
        lda     r3H                             ; 917F A5 09                    ..
        sta     (r4L),y                         ; 9181 91 0A                    ..
        clc                                     ; 9183 18                       .
        lda     #$02                            ; 9184 A9 02                    ..
        adc     r4L                             ; 9186 65 0A                    e.
        sta     r4L                             ; 9188 85 0A                    ..
        bcc     L918E                           ; 918A 90 02                    ..
        inc     r4H                             ; 918C E6 0B                    ..
L918E:  lda     r5L                             ; 918E A5 0C                    ..
        bne     L9194                           ; 9190 D0 02                    ..
        dec     r5H                             ; 9192 C6 0D                    ..
L9194:  dec     r5L                             ; 9194 C6 0C                    ..
        lda     r5L                             ; 9196 A5 0C                    ..
        ora     r5H                             ; 9198 05 0D                    ..
        bne     L9172                           ; 919A D0 D6                    ..
        ldy     #$00                            ; 919C A0 00                    ..
        tya                                     ; 919E 98                       .
        sta     (r4L),y                         ; 919F 91 0A                    ..
        iny                                     ; 91A1 C8                       .
        lda     r8L                             ; 91A2 A5 12                    ..
        bne     L91A8                           ; 91A4 D0 02                    ..
        lda     #$FE                            ; 91A6 A9 FE                    ..
L91A8:  clc                                     ; 91A8 18                       .
        adc     #$01                            ; 91A9 69 01                    i.
        sta     (r4L),y                         ; 91AB 91 0A                    ..
        ldx     #$00                            ; 91AD A2 00                    ..
L91AF:  pla                                     ; 91AF 68                       h
        sta     r9L                             ; 91B0 85 14                    ..
        pla                                     ; 91B2 68                       h
        sta     r9H                             ; 91B3 85 15                    ..
        rts                                     ; 91B5 60                       `

; ----------------------------------------------------------------------------
L91B6:  lda     #$12                            ; 91B6 A9 12                    ..
        sta     r1L                             ; 91B8 85 04                    ..
        lda     #$01                            ; 91BA A9 01                    ..
        sta     r1H                             ; 91BC 85 05                    ..
        jsr     ReadBuff                        ; 91BE 20 3C 90                  <.
        lda     #$80                            ; 91C1 A9 80                    ..
        sta     r5H                             ; 91C3 85 0D                    ..
        lda     #$02                            ; 91C5 A9 02                    ..
        sta     r5L                             ; 91C7 85 0C                    ..
        lda     #$00                            ; 91C9 A9 00                    ..
        sta     L9D3A                           ; 91CB 8D 3A 9D                 .:.
        rts                                     ; 91CE 60                       `

; ----------------------------------------------------------------------------
L91CF:  ldx     #$00                            ; 91CF A2 00                    ..
        ldy     #$00                            ; 91D1 A0 00                    ..
        clc                                     ; 91D3 18                       .
        lda     #$20                            ; 91D4 A9 20                    . 
        adc     r5L                             ; 91D6 65 0C                    e.
        sta     r5L                             ; 91D8 85 0C                    ..
        bcc     L91DE                           ; 91DA 90 02                    ..
        inc     r5H                             ; 91DC E6 0D                    ..
L91DE:  lda     r5H                             ; 91DE A5 0D                    ..
        cmp     #$80                            ; 91E0 C9 80                    ..
        bne     L91E8                           ; 91E2 D0 04                    ..
        lda     r5L                             ; 91E4 A5 0C                    ..
        cmp     #$FF                            ; 91E6 C9 FF                    ..
L91E8:  bcc     L9218                           ; 91E8 90 2E                    ..
        ldy     #$FF                            ; 91EA A0 FF                    ..
        .byte   $AD                             ; 91EC AD                       .
        .byte   $01                             ; 91ED 01                       .
_Get1stDirEntry:
        .byte   $80                             ; 91EE 80                       .
        sta     r1H                             ; 91EF 85 05                    ..
        lda     diskBlkBuf                      ; 91F1 AD 00 80                 ...
        sta     r1L                             ; 91F4 85 04                    ..
        bne     L920B                           ; 91F6 D0 13                    ..
        .byte   $AD                             ; 91F8 AD                       .
        .byte   $3A                             ; 91F9 3A                       :
_GetNxtDirEntry:
        sta     $1BD0,x                         ; 91FA 9D D0 1B                 ...
        lda     #$FF                            ; 91FD A9 FF                    ..
        sta     L9D3A                           ; 91FF 8D 3A 9D                 .:.
        jsr     GetBorder                       ; 9202 20 36 90                  6.
        txa                                     ; 9205 8A                       .
        bne     L9218                           ; 9206 D0 10                    ..
        tya                                     ; 9208 98                       .
        bne     L9218                           ; 9209 D0 0D                    ..
L920B:  jsr     ReadBuff                        ; 920B 20 3C 90                  <.
        ldy     #$00                            ; 920E A0 00                    ..
        lda     #$80                            ; 9210 A9 80                    ..
        sta     r5H                             ; 9212 85 0D                    ..
        lda     #$02                            ; 9214 A9 02                    ..
        sta     r5L                             ; 9216 85 0C                    ..
L9218:  rts                                     ; 9218 60                       `

; ----------------------------------------------------------------------------
L9219:  jsr     GetDirHead                      ; 9219 20 47 C2                  G.
        txa                                     ; 921C 8A                       .
        bne     L923E                           ; 921D D0 1F                    ..
        lda     #$82                            ; 921F A9 82                    ..
        sta     r5H                             ; 9221 85 0D                    ..
        lda     #$00                            ; 9223 A9 00                    ..
        sta     r5L                             ; 9225 85 0C                    ..
        jsr     ChkDkGEOS                       ; 9227 20 DE C1                  ..
        bne     L9230                           ; 922A D0 04                    ..
        ldy     #$FF                            ; 922C A0 FF                    ..
        bne     L923C                           ; 922E D0 0C                    ..
L9230:  lda     $82AC                           ; 9230 AD AC 82                 ...
        sta     r1H                             ; 9233 85 05                    ..
        lda     $82AB                           ; 9235 AD AB 82                 ...
        sta     r1L                             ; 9238 85 04                    ..
        ldy     #$00                            ; 923A A0 00                    ..
L923C:  ldx     #$00                            ; 923C A2 00                    ..
L923E:  rts                                     ; 923E 60                       `

; ----------------------------------------------------------------------------
L923F:  ldy     #$AD                            ; 923F A0 AD                    ..
        ldx     #$00                            ; 9241 A2 00                    ..
        .byte   $A9                             ; 9243 A9                       .
_GetBorder:
        brk                                     ; 9244 00                       .
        sta     isGEOS                          ; 9245 8D 8B 84                 ...
L9248:  lda     (r5L),y                         ; 9248 B1 0C                    ..
        cmp     L925E,x                         ; 924A DD 5E 92                 .^.
        bne     L925A                           ; 924D D0 0B                    ..
        iny                                     ; 924F C8                       .
        inx                                     ; 9250 E8                       .
        cpx     #$0B                            ; 9251 E0 0B                    ..
        bne     L9248                           ; 9253 D0 F3                    ..
        lda     #$FF                            ; 9255 A9 FF                    ..
        sta     isGEOS                          ; 9257 8D 8B 84                 ...
L925A:  lda     isGEOS                          ; 925A AD 8B 84                 ...
        rts                                     ; 925D 60                       `

; ----------------------------------------------------------------------------
L925E:  .byte   $47                             ; 925E 47                       G
        eor     $4F                             ; 925F 45 4F                    EO
        .byte   $53                             ; 9261 53                       S
        jsr     L6F66                           ; 9262 20 66 6F                  fo
__ChkDkGEOS:
        .byte   $72                             ; 9265 72                       r
        adc     $7461                           ; 9266 6D 61 74                 mat
        jsr     L3156                           ; 9269 20 56 31                  V1
        rol     a:mouseOn                       ; 926C 2E 30 00                 .0.
L926F:  php                                     ; 926F 08                       .
        sei                                     ; 9270 78                       x
        lda     r6L                             ; 9271 A5 0E                    ..
        pha                                     ; 9273 48                       H
        lda     r2H                             ; 9274 A5 07                    ..
        pha                                     ; 9276 48                       H
        lda     r2L                             ; 9277 A5 06                    ..
        pha                                     ; 9279 48                       H
        ldx     r10L                            ; 927A A6 16                    ..
        inx                                     ; 927C E8                       .
        stx     r6L                             ; 927D 86 0E                    ..
        lda     #$12                            ; 927F A9 12                    ..
        sta     r1L                             ; 9281 85 04                    ..
        .byte   $A9,$01,$85,$05                 ; 9283 A9 01 85 05              ....
L9287:  .byte   " <"                            ; 9287 20 3C                     <
        .byte   $90                             ; 9289 90                       .
L928A:  .byte   $8A,$D0                         ; 928A 8A D0                    ..
        .byte   "8"                             ; 928C 38                       8
        .byte   $C6,$0E,$F0,$15                 ; 928D C6 0E F0 15              ....
L9291:  .byte   $AD,$00                         ; 9291 AD 00                    ..
; ----------------------------------------------------------------------------
__GetFreeDirBlk:
        .byte   $80                             ; 9293 80                       .
        bne     L929C                           ; 9294 D0 06                    ..
        jsr     AddDirBlock                     ; 9296 20 39 90                  9.
        clv                                     ; 9299 B8                       .
        bvc     L928A                           ; 929A 50 EE                    P.
L929C:  sta     r1L                             ; 929C 85 04                    ..
        lda     $8001                           ; 929E AD 01 80                 ...
        sta     r1H                             ; 92A1 85 05                    ..
        clv                                     ; 92A3 B8                       .
        bvc     L9287                           ; 92A4 50 E1                    P.
        ldy     #$02                            ; 92A6 A0 02                    ..
        ldx     #$00                            ; 92A8 A2 00                    ..
L92AA:  lda     diskBlkBuf,y                    ; 92AA B9 00 80                 ...
        beq     L92C5                           ; 92AD F0 16                    ..
        tya                                     ; 92AF 98                       .
        clc                                     ; 92B0 18                       .
        adc     #$20                            ; 92B1 69 20                    i 
        tay                                     ; 92B3 A8                       .
        bcc     L92AA                           ; 92B4 90 F4                    ..
        lda     #$01                            ; 92B6 A9 01                    ..
        sta     r6L                             ; 92B8 85 0E                    ..
        ldx     #$04                            ; 92BA A2 04                    ..
        ldy     r10L                            ; 92BC A4 16                    ..
        iny                                     ; 92BE C8                       .
        sty     r10L                            ; 92BF 84 16                    ..
        cpy     #$12                            ; 92C1 C0 12                    ..
        bcc     L9291                           ; 92C3 90 CC                    ..
L92C5:  pla                                     ; 92C5 68                       h
        sta     r2L                             ; 92C6 85 06                    ..
        pla                                     ; 92C8 68                       h
        sta     r2H                             ; 92C9 85 07                    ..
        pla                                     ; 92CB 68                       h
        sta     r6L                             ; 92CC 85 0E                    ..
        plp                                     ; 92CE 28                       (
        rts                                     ; 92CF 60                       `

; ----------------------------------------------------------------------------
L92D0:  lda     r6H                             ; 92D0 A5 0F                    ..
        pha                                     ; 92D2 48                       H
        lda     r6L                             ; 92D3 A5 0E                    ..
        pha                                     ; 92D5 48                       H
        ldy     #$48                            ; 92D6 A0 48                    .H
        ldx     #$04                            ; 92D8 A2 04                    ..
        lda     curDirHead,y                    ; 92DA B9 00 82                 ...
        beq     L9305                           ; 92DD F0 26                    .&
        lda     r1H                             ; 92DF A5 05                    ..
        sta     r3H                             ; 92E1 85 09                    ..
        lda     r1L                             ; 92E3 A5 04                    ..
        sta     r3L                             ; 92E5 85 08                    ..
        jsr     SetNextFree                     ; 92E7 20 92 C2                  ..
        lda     r3H                             ; 92EA A5 09                    ..
        sta     $8001                           ; 92EC 8D 01 80                 ...
        lda     r3L                             ; 92EF A5 08                    ..
        sta     diskBlkBuf                      ; 92F1 8D 00 80                 ...
_AddDirBlock:
        jsr     WriteBuff                       ; 92F4 20 3F 90                  ?.
        txa                                     ; 92F7 8A                       .
        bne     L9305                           ; 92F8 D0 0B                    ..
        lda     r3H                             ; 92FA A5 09                    ..
        sta     r1H                             ; 92FC 85 05                    ..
        lda     r3L                             ; 92FE A5 08                    ..
        sta     r1L                             ; 9300 85 04                    ..
        jsr     L930C                           ; 9302 20 0C 93                  ..
L9305:  pla                                     ; 9305 68                       h
        sta     r6L                             ; 9306 85 0E                    ..
        pla                                     ; 9308 68                       h
        sta     r6H                             ; 9309 85 0F                    ..
        rts                                     ; 930B 60                       `

; ----------------------------------------------------------------------------
L930C:  lda     #$00                            ; 930C A9 00                    ..
        tay                                     ; 930E A8                       .
L930F:  sta     diskBlkBuf,y                    ; 930F 99 00 80                 ...
        iny                                     ; 9312 C8                       .
        bne     L930F                           ; 9313 D0 FA                    ..
        dey                                     ; 9315 88                       .
        sty     $8001                           ; 9316 8C 01 80                 ...
        jmp     WriteBuff                       ; 9319 4C 3F 90                 L?.

; ----------------------------------------------------------------------------
L931C:  lda     r3H                             ; 931C A5 09                    ..
        clc                                     ; 931E 18                       .
        adc     interleave                      ; 931F 6D 8C 84                 m..
        sta     r6H                             ; 9322 85 0F                    ..
        lda     r3L                             ; 9324 A5 08                    ..
        sta     r6L                             ; 9326 85 0E                    ..
        cmp     #$19                            ; 9328 C9 19                    ..
        bcc     L932E                           ; 932A 90 02                    ..
        dec     r6H                             ; 932C C6 0F                    ..
L932E:  cmp     #$12                            ; 932E C9 12                    ..
        beq     L9338                           ; 9330 F0 06                    ..
L9332:  lda     r6L                             ; 9332 A5 0E                    ..
        cmp     #$12                            ; 9334 C9 12                    ..
        beq     L9355                           ; 9336 F0 1D                    ..
L9338:  asl     a                               ; 9338 0A                       .
        asl     a                               ; 9339 0A                       .
        tax                                     ; 933A AA                       .
        lda     curDirHead,x                    ; 933B BD 00 82                 ...
__SetNextFree:
        beq     L9355                           ; 933E F0 15                    ..
        lda     r6L                             ; 9340 A5 0E                    ..
        jsr     L937B                           ; 9342 20 7B 93                  {.
        lda     L938A,x                         ; 9345 BD 8A 93                 ...
        sta     r7L                             ; 9348 85 10                    ..
        tay                                     ; 934A A8                       .
L934B:  jsr     L938E                           ; 934B 20 8E 93                  ..
        beq     L936D                           ; 934E F0 1D                    ..
        inc     r6H                             ; 9350 E6 0F                    ..
        dey                                     ; 9352 88                       .
        bne     L934B                           ; 9353 D0 F6                    ..
L9355:  inc     r6L                             ; 9355 E6 0E                    ..
        lda     r6L                             ; 9357 A5 0E                    ..
        cmp     #$24                            ; 9359 C9 24                    .$
        bcs     L9378                           ; 935B B0 1B                    ..
        sec                                     ; 935D 38                       8
        sbc     r3L                             ; 935E E5 08                    ..
        sta     r6H                             ; 9360 85 0F                    ..
        asl     a                               ; 9362 0A                       .
        adc     #$04                            ; 9363 69 04                    i.
        adc     interleave                      ; 9365 6D 8C 84                 m..
        sta     r6H                             ; 9368 85 0F                    ..
        clv                                     ; 936A B8                       .
        bvc     L9332                           ; 936B 50 C5                    P.
L936D:  lda     r6L                             ; 936D A5 0E                    ..
        sta     r3L                             ; 936F 85 08                    ..
        lda     r6H                             ; 9371 A5 0F                    ..
        sta     r3H                             ; 9373 85 09                    ..
        ldx     #$00                            ; 9375 A2 00                    ..
        rts                                     ; 9377 60                       `

; ----------------------------------------------------------------------------
L9378:  ldx     #$03                            ; 9378 A2 03                    ..
        rts                                     ; 937A 60                       `

; ----------------------------------------------------------------------------
L937B:  ldx     #$00                            ; 937B A2 00                    ..
L937D:  cmp     L9386,x                         ; 937D DD 86 93                 ...
        bcc     L9385                           ; 9380 90 03                    ..
        inx                                     ; 9382 E8                       .
        bne     L937D                           ; 9383 D0 F8                    ..
L9385:  rts                                     ; 9385 60                       `

; ----------------------------------------------------------------------------
L9386:  .byte   $12                             ; 9386 12                       .
        ora     $241F,y                         ; 9387 19 1F 24                 ..$
L938A:  ora     r8H,x                           ; 938A 15 13                    ..
        .byte   $12                             ; 938C 12                       .
        .byte   $11                             ; 938D 11                       .
L938E:  lda     r6H                             ; 938E A5 0F                    ..
L9390:  cmp     r7L                             ; 9390 C5 10                    ..
        bcc     L939A                           ; 9392 90 06                    ..
        sec                                     ; 9394 38                       8
        sbc     r7L                             ; 9395 E5 10                    ..
        clv                                     ; 9397 B8                       .
        bvc     L9390                           ; 9398 50 F6                    P.
L939A:  sta     r6H                             ; 939A 85 0F                    ..
L939C:  jsr     FindBAMBit                      ; 939C 20 AD C2                  ..
        beq     L93B3                           ; 939F F0 12                    ..
        lda     r8H                             ; 93A1 A5 13                    ..
        eor     #$FF                            ; 93A3 49 FF                    I.
        and     curDirHead,x                    ; 93A5 3D 00 82                 =..
        sta     curDirHead,x                    ; 93A8 9D 00 82                 ...
        ldx     r7H                             ; 93AB A6 11                    ..
        dec     curDirHead,x                    ; 93AD DE 00 82                 ...
        ldx     #$00                            ; 93B0 A2 00                    ..
        rts                                     ; 93B2 60                       `

; ----------------------------------------------------------------------------
L93B3:  ldx     #$06                            ; 93B3 A2 06                    ..
        rts                                     ; 93B5 60                       `

; ----------------------------------------------------------------------------
L93B6:  lda     r6L                             ; 93B6 A5 0E                    ..
        asl     a                               ; 93B8 0A                       .
        asl     a                               ; 93B9 0A                       .
        sta     r7H                             ; 93BA 85 11                    ..
        lda     r6H                             ; 93BC A5 0F                    ..
        and     #$07                            ; 93BE 29 07                    ).
        tax                                     ; 93C0 AA                       .
        lda     L93D5,x                         ; 93C1 BD D5 93                 ...
        sta     r8H                             ; 93C4 85 13                    ..
        lda     r6H                             ; 93C6 A5 0F                    ..
        lsr     a                               ; 93C8 4A                       J
_AllocateBlock:
        lsr     a                               ; 93C9 4A                       J
        lsr     a                               ; 93CA 4A                       J
        sec                                     ; 93CB 38                       8
        adc     r7H                             ; 93CC 65 11                    e.
        tax                                     ; 93CE AA                       .
        lda     curDirHead,x                    ; 93CF BD 00 82                 ...
        and     r8H                             ; 93D2 25 13                    %.
        rts                                     ; 93D4 60                       `

; ----------------------------------------------------------------------------
L93D5:  ora     (r0L,x)                         ; 93D5 01 02                    ..
        .byte   $04                             ; 93D7 04                       .
        php                                     ; 93D8 08                       .
        bpl     L93FB                           ; 93D9 10 20                    . 
        rti                                     ; 93DB 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; 93DC 80                       .
L93DD:  jsr     FindBAMBit                      ; 93DD 20 AD C2                  ..
        bne     L93F2                           ; 93E0 D0 10                    ..
        lda     r8H                             ; 93E2 A5 13                    ..
L93E4:  eor     curDirHead,x                    ; 93E4 5D 00 82                 ]..
        sta     curDirHead,x                    ; 93E7 9D 00 82                 ...
        ldx     r7H                             ; 93EA A6 11                    ..
        inc     curDirHead,x                    ; 93EC FE 00 82                 ...
        ldx     #$00                            ; 93EF A2 00                    ..
        rts                                     ; 93F1 60                       `

; ----------------------------------------------------------------------------
L93F2:  ldx     #$06                            ; 93F2 A2 06                    ..
        rts                                     ; 93F4 60                       `

; ----------------------------------------------------------------------------
L93F5:  lda     #$00                            ; 93F5 A9 00                    ..
        sta     r4L                             ; 93F7 85 0A                    ..
        sta     r4H                             ; 93F9 85 0B                    ..
L93FB:  ldy     #$04                            ; 93FB A0 04                    ..
        lda     (r5L),y                         ; 93FD B1 0C                    ..
        clc                                     ; 93FF 18                       .
        adc     r4L                             ; 9400 65 0A                    e.
        sta     r4L                             ; 9402 85 0A                    ..
        bcc     L9408                           ; 9404 90 02                    ..
        inc     r4H                             ; 9406 E6 0B                    ..
L9408:  tya                                     ; 9408 98                       .
        clc                                     ; 9409 18                       .
__FreeBlock:
        adc     #$04                            ; 940A 69 04                    i.
        tay                                     ; 940C A8                       .
        cpy     #$48                            ; 940D C0 48                    .H
        beq     L9408                           ; 940F F0 F7                    ..
        .byte   $C0                             ; 9411 C0                       .
__FindBAMBit:
        bcc     L93E4                           ; 9412 90 D0                    ..
        inx                                     ; 9414 E8                       .
        lda     #$02                            ; 9415 A9 02                    ..
        sta     r3H                             ; 9417 85 09                    ..
        lda     #$98                            ; 9419 A9 98                    ..
        sta     r3L                             ; 941B 85 08                    ..
        rts                                     ; 941D 60                       `

; ----------------------------------------------------------------------------
L941E:  jsr     GetDirHead                      ; 941E 20 47 C2                  G.
        txa                                     ; 9421 8A                       .
        bne     L9478                           ; 9422 D0 54                    .T
        lda     #$82                            ; 9424 A9 82                    ..
        sta     r5H                             ; 9426 85 0D                    ..
        lda     #$00                            ; 9428 A9 00                    ..
        sta     r5L                             ; 942A 85 0C                    ..
        jsr     CalcBlksFree                    ; 942C 20 DB C1                  ..
        ldx     #$03                            ; 942F A2 03                    ..
        lda     r4L                             ; 9431 A5 0A                    ..
        ora     r4H                             ; 9433 05 0B                    ..
        beq     L9478                           ; 9435 F0 41                    .A
        lda     #$13                            ; 9437 A9 13                    ..
        sta     r3L                             ; 9439 85 08                    ..
        lda     #$00                            ; 943B A9 00                    ..
        sta     r3H                             ; 943D 85 09                    ..
        jsr     SetNextFree                     ; 943F 20 92 C2                  ..
        txa                                     ; 9442 8A                       .
        beq     L944F                           ; 9443 F0 0A                    ..
        lda     #$01                            ; 9445 A9 01                    ..
        sta     r3L                             ; 9447 85 08                    ..
        jsr     SetNextFree                     ; 9449 20 92 C2                  ..
FBBBitTab:
        .byte   $8A,$D0,$29                     ; 944C 8A D0 29                 ..)
L944F:  .byte   $A5,$09,$85,$05,$A5             ; 944F A5 09 85 05 A5           .....
; ----------------------------------------------------------------------------
__CalcBlksFree:
        php                                     ; 9454 08                       .
        sta     r1L                             ; 9455 85 04                    ..
        jsr     L930C                           ; 9457 20 0C 93                  ..
        txa                                     ; 945A 8A                       .
        bne     L9478                           ; 945B D0 1B                    ..
        lda     r1H                             ; 945D A5 05                    ..
        sta     $82AC                           ; 945F 8D AC 82                 ...
        lda     r1L                             ; 9462 A5 04                    ..
        .byte   $8D                             ; 9464 8D                       .
L9465:  .byte   $AB                             ; 9465 AB                       .
        .byte   $82                             ; 9466 82                       .
        ldy     #$BC                            ; 9467 A0 BC                    ..
        ldx     #$0F                            ; 9469 A2 0F                    ..
L946B:  lda     L925E,x                         ; 946B BD 5E 92                 .^.
        sta     curDirHead,y                    ; 946E 99 00 82                 ...
        dey                                     ; 9471 88                       .
        dex                                     ; 9472 CA                       .
        bpl     L946B                           ; 9473 10 F6                    ..
        jsr     PutDirHead                      ; 9475 20 4A C2                  J.
L9478:  rts                                     ; 9478 60                       `

; ----------------------------------------------------------------------------
L9479:  php                                     ; 9479 08                       .
        pla                                     ; 947A 68                       h
        sta     L9D2C                           ; 947B 8D 2C 9D                 .,.
        sei                                     ; 947E 78                       x
        lda     CPU_DATA                        ; 947F A5 01                    ..
        sta     L9D2E                           ; 9481 8D 2E 9D                 ...
        lda     grirqen                         ; 9484 AD 1A D0                 ...
        sta     L9D2D                           ; 9487 8D 2D 9D                 .-.
        lda     clkreg                          ; 948A AD 30 D0                 .0.
        sta     L9D2B                           ; 948D 8D 2B 9D                 .+.
        ldy     #$00                            ; 9490 A0 00                    ..
        .byte   $8C                             ; 9492 8C                       .
__SetGEOSDisk:
        bmi     L9465                           ; 9493 30 D0                    0.
        sty     grirqen                         ; 9495 8C 1A D0                 ...
        lda     #$7F                            ; 9498 A9 7F                    ..
        sta     grirq                           ; 949A 8D 19 D0                 ...
        sta     $DC0D                           ; 949D 8D 0D DC                 ...
        sta     $DD0D                           ; 94A0 8D 0D DD                 ...
        lda     #$94                            ; 94A3 A9 94                    ..
        sta     $0315                           ; 94A5 8D 15 03                 ...
        lda     #$FA                            ; 94A8 A9 FA                    ..
        sta     irqvec                          ; 94AA 8D 14 03                 ...
        lda     #$94                            ; 94AD A9 94                    ..
        sta     $0319                           ; 94AF 8D 19 03                 ...
        lda     #$FA                            ; 94B2 A9 FA                    ..
        sta     nmivec                          ; 94B4 8D 18 03                 ...
        lda     #$3F                            ; 94B7 A9 3F                    .?
        sta     $DD02                           ; 94B9 8D 02 DD                 ...
        lda     mobenble                        ; 94BC AD 15 D0                 ...
        sta     L9D2F                           ; 94BF 8D 2F 9D                 ./.
        sty     mobenble                        ; 94C2 8C 15 D0                 ...
        sty     $DD05                           ; 94C5 8C 05 DD                 ...
        iny                                     ; 94C8 C8                       .
        sty     $DD04                           ; 94C9 8C 04 DD                 ...
        lda     #$81                            ; 94CC A9 81                    ..
        sta     $DD0D                           ; 94CE 8D 0D DD                 ...
        lda     #$09                            ; 94D1 A9 09                    ..
        sta     $DD0E                           ; 94D3 8D 0E DD                 ...
        ldy     #$2C                            ; 94D6 A0 2C                    .,
L94D8:  lda     rasreg                          ; 94D8 AD 12 D0                 ...
        cmp     TURBO_DD00_CPY                  ; 94DB C5 8F                    ..
        beq     L94D8                           ; 94DD F0 F9                    ..
__InitForIO:
        sta     TURBO_DD00_CPY                  ; 94DF 85 8F                    ..
        dey                                     ; 94E1 88                       .
        bne     L94D8                           ; 94E2 D0 F4                    ..
        lda     cia2base                        ; 94E4 AD 00 DD                 ...
        and     #$07                            ; 94E7 29 07                    ).
        sta     TURBO_DD00                      ; 94E9 85 8E                    ..
        sta     L9D35                           ; 94EB 8D 35 9D                 .5.
        ora     #$30                            ; 94EE 09 30                    .0
        sta     TURBO_DD00_CPY                  ; 94F0 85 8F                    ..
        lda     TURBO_DD00                      ; 94F2 A5 8E                    ..
        ora     #$10                            ; 94F4 09 10                    ..
        sta     L9D36                           ; 94F6 8D 36 9D                 .6.
        rts                                     ; 94F9 60                       `

; ----------------------------------------------------------------------------
        pla                                     ; 94FA 68                       h
        sta     config                          ; 94FB 8D 00 FF                 ...
        pla                                     ; 94FE 68                       h
        tay                                     ; 94FF A8                       .
        pla                                     ; 9500 68                       h
        tax                                     ; 9501 AA                       .
        pla                                     ; 9502 68                       h
        rti                                     ; 9503 40                       @

; ----------------------------------------------------------------------------
L9504:  sei                                     ; 9504 78                       x
        lda     L9D2B                           ; 9505 AD 2B 9D                 .+.
        sta     clkreg                          ; 9508 8D 30 D0                 .0.
        lda     L9D2F                           ; 950B AD 2F 9D                 ./.
        sta     mobenble                        ; 950E 8D 15 D0                 ...
        lda     #$7F                            ; 9511 A9 7F                    ..
        sta     $DD0D                           ; 9513 8D 0D DD                 ...
        lda     $DD0D                           ; 9516 AD 0D DD                 ...
        lda     L9D2D                           ; 9519 AD 2D 9D                 .-.
        sta     grirqen                         ; 951C 8D 1A D0                 ...
        lda     L9D2C                           ; 951F AD 2C 9D                 .,.
        pha                                     ; 9522 48                       H
        plp                                     ; 9523 28                       (
        rts                                     ; 9524 60                       `

; ----------------------------------------------------------------------------
        .byte   $0F                             ; 9525 0F                       .
        .byte   $07                             ; 9526 07                       .
        ora     $0B05                           ; 9527 0D 05 0B                 ...
        .byte   $03                             ; 952A 03                       .
        ora     #$01                            ; 952B 09 01                    ..
        asl     $0C06                           ; 952D 0E 06 0C                 ...
        .byte   $04                             ; 9530 04                       .
        asl     a                               ; 9531 0A                       .
        .byte   $02                             ; 9532 02                       .
        php                                     ; 9533 08                       .
L9534:  brk                                     ; 9534 00                       .
        .byte   $80                             ; 9535 80                       .
        jsr     L40A0                           ; 9536 20 A0 40                  .@
        cpy     #$60                            ; 9539 C0 60                    .`
        cpx     #$10                            ; 953B E0 10                    ..
        bcc     L956F                           ; 953D 90 30                    .0
        bcs     L9591                           ; 953F B0 50                    .P
        bne     L95B3                           ; 9541 D0 70                    .p
        .byte   $F0                             ; 9543 F0                       .
L9544:  jsr     L9657                           ; 9544 20 57 96                  W.
        pha                                     ; 9547 48                       H
        pla                                     ; 9548 68                       h
        pha                                     ; 9549 48                       H
        pla                                     ; 954A 68                       h
        sty     $8D                             ; 954B 84 8D                    ..
L954D:  sec                                     ; 954D 38                       8
L954E:  lda     rasreg                          ; 954E AD 12 D0                 ...
        sbc     #$31                            ; 9551 E9 31                    .1
        bcc     L9559                           ; 9553 90 04                    ..
__DoneWithIO:
        and     #$06                            ; 9555 29 06                    ).
        beq     L954E                           ; 9557 F0 F5                    ..
L9559:  lda     TURBO_DD00_CPY                  ; 9559 A5 8F                    ..
        sta     cia2base                        ; 955B 8D 00 DD                 ...
        lda     $8B                             ; 955E A5 8B                    ..
        lda     TURBO_DD00                      ; 9560 A5 8E                    ..
        sta     cia2base                        ; 9562 8D 00 DD                 ...
L9565:  dec     $8D                             ; 9565 C6 8D                    ..
        nop                                     ; 9567 EA                       .
        nop                                     ; 9568 EA                       .
        nop                                     ; 9569 EA                       .
        lda     cia2base                        ; 956A AD 00 DD                 ...
        lsr     a                               ; 956D 4A                       J
        lsr     a                               ; 956E 4A                       J
L956F:  nop                                     ; 956F EA                       .
        ora     cia2base                        ; 9570 0D 00 DD                 ...
        lsr     a                               ; 9573 4A                       J
        lsr     a                               ; 9574 4A                       J
        lsr     a                               ; 9575 4A                       J
        lsr     a                               ; 9576 4A                       J
        ldy     cia2base                        ; 9577 AC 00 DD                 ...
        tax                                     ; 957A AA                       .
__EnterTurbo:
        tya                                     ; 957B 98                       .
        lsr     a                               ; 957C 4A                       J
        lsr     a                               ; 957D 4A                       J
        ora     cia2base                        ; 957E 0D 00 DD                 ...
        and     #$F0                            ; 9581 29 F0                    ).
        .byte   $1D                             ; 9583 1D                       .
__ExitTurbo:
        and     $95                             ; 9584 25 95                    %.
        ldy     $8D                             ; 9586 A4 8D                    ..
        sta     ($8B),y                         ; 9588 91 8B                    ..
__ChangeDiskDevice:
        bne     L954D                           ; 958A D0 C1                    ..
L958C:  ldx     L9D36                           ; 958C AE 36 9D                 .6.
        .byte   $8E                             ; 958F 8E                       .
        brk                                     ; 9590 00                       .
L9591:  .byte   $DD                             ; 9591 DD                       .
__NewDisk:
        rts                                     ; 9592 60                       `

; ----------------------------------------------------------------------------
L9593:  jsr     L9657                           ; 9593 20 57 96                  W.
__ReadBlock:
        tya                                     ; 9596 98                       .
        pha                                     ; 9597 48                       H
        ldy     #$00                            ; 9598 A0 00                    ..
        jsr     L95AA                           ; 959A 20 AA 95                  ..
        pla                                     ; 959D 68                       h
        tay                                     ; 959E A8                       .
        .byte   $20                             ; 959F 20                        
        .byte   $57                             ; 95A0 57                       W
_ReadLink:
        .byte   $96                             ; 95A1 96                       .
L95A2:  dey                                     ; 95A2 88                       .
        lda     ($8B),y                         ; 95A3 B1 8B                    ..
        ldx     TURBO_DD00                      ; 95A5 A6 8E                    ..
        stx     cia2base                        ; 95A7 8E 00 DD                 ...
L95AA:  tax                                     ; 95AA AA                       .
        .byte   $29                             ; 95AB 29                       )
__WriteBlock:
        .byte   $0F                             ; 95AC 0F                       .
        sta     $8D                             ; 95AD 85 8D                    ..
        sec                                     ; 95AF 38                       8
L95B0:  lda     rasreg                          ; 95B0 AD 12 D0                 ...
L95B3:  sbc     #$31                            ; 95B3 E9 31                    .1
__VerWriteBlock:
        bcc     L95BB                           ; 95B5 90 04                    ..
        and     #$06                            ; 95B7 29 06                    ).
        beq     L95B0                           ; 95B9 F0 F5                    ..
L95BB:  txa                                     ; 95BB 8A                       .
        ldx     TURBO_DD00_CPY                  ; 95BC A6 8F                    ..
        stx     cia2base                        ; 95BE 8E 00 DD                 ...
        and     #$F0                            ; 95C1 29 F0                    ).
        ora     TURBO_DD00                      ; 95C3 05 8E                    ..
        sta     cia2base                        ; 95C5 8D 00 DD                 ...
        ror     a                               ; 95C8 6A                       j
        ror     a                               ; 95C9 6A                       j
        and     #$F0                            ; 95CA 29 F0                    ).
        ora     L9D35                           ; 95CC 0D 35 9D                 .5.
        sta     cia2base                        ; 95CF 8D 00 DD                 ...
        ldx     $8D                             ; 95D2 A6 8D                    ..
        lda     L9534,x                         ; 95D4 BD 34 95                 .4.
        ora     TURBO_DD00                      ; 95D7 05 8E                    ..
        sta     cia2base                        ; 95D9 8D 00 DD                 ...
        ror     a                               ; 95DC 6A                       j
        ror     a                               ; 95DD 6A                       j
        and     #$F0                            ; 95DE 29 F0                    ).
        ora     TURBO_DD00                      ; 95E0 05 8E                    ..
        cpy     #$00                            ; 95E2 C0 00                    ..
        sta     cia2base                        ; 95E4 8D 00 DD                 ...
        bne     L95A2                           ; 95E7 D0 B9                    ..
        nop                                     ; 95E9 EA                       .
        nop                                     ; 95EA EA                       .
        beq     L958C                           ; 95EB F0 9F                    ..
        stx     $8C                             ; 95ED 86 8C                    ..
        sta     $8B                             ; 95EF 85 8B                    ..
        lda     #$00                            ; 95F1 A9 00                    ..
        sta     STATUS                          ; 95F3 85 90                    ..
        lda     curDrive                        ; 95F5 AD 89 84                 ...
        jsr     LISTEN                          ; 95F8 20 B1 FF                  ..
        bit     STATUS                          ; 95FB 24 90                    $.
        bmi     L9617                           ; 95FD 30 18                    0.
        lda     #$FF                            ; 95FF A9 FF                    ..
        jsr     SECOND                          ; 9601 20 93 FF                  ..
        bit     STATUS                          ; 9604 24 90                    $.
        bmi     L9617                           ; 9606 30 0F                    0.
        ldy     #$00                            ; 9608 A0 00                    ..
L960A:  lda     ($8B),y                         ; 960A B1 8B                    ..
        jsr     CIOUT                           ; 960C 20 A8 FF                  ..
        iny                                     ; 960F C8                       .
        cpy     #$05                            ; 9610 C0 05                    ..
        bcc     L960A                           ; 9612 90 F6                    ..
        ldx     #$00                            ; 9614 A2 00                    ..
        rts                                     ; 9616 60                       `

; ----------------------------------------------------------------------------
L9617:  jsr     UNLSN                           ; 9617 20 AE FF                  ..
        ldx     #$0D                            ; 961A A2 0D                    ..
        rts                                     ; 961C 60                       `

; ----------------------------------------------------------------------------
L961D:  stx     $8C                             ; 961D 86 8C                    ..
        sta     $8B                             ; 961F 85 8B                    ..
        ldy     #$02                            ; 9621 A0 02                    ..
        bne     L9635                           ; 9623 D0 10                    ..
L9625:  stx     $8C                             ; 9625 86 8C                    ..
        sta     $8B                             ; 9627 85 8B                    ..
L9629:  ldy     #$04                            ; 9629 A0 04                    ..
        lda     r1H                             ; 962B A5 05                    ..
        sta     L9D34                           ; 962D 8D 34 9D                 .4.
        lda     r1L                             ; 9630 A5 04                    ..
        sta     L9D33                           ; 9632 8D 33 9D                 .3.
L9635:  lda     $8C                             ; 9635 A5 8C                    ..
        sta     L9D32                           ; 9637 8D 32 9D                 .2.
        lda     $8B                             ; 963A A5 8B                    ..
        sta     L9D31                           ; 963C 8D 31 9D                 .1.
        lda     #$9D                            ; 963F A9 9D                    ..
        sta     $8C                             ; 9641 85 8C                    ..
        lda     #$31                            ; 9643 A9 31                    .1
        sta     $8B                             ; 9645 85 8B                    ..
        jmp     L9593                           ; 9647 4C 93 95                 L..

; ----------------------------------------------------------------------------
L964A:  ldy     #$01                            ; 964A A0 01                    ..
        jsr     L9544                           ; 964C 20 44 95                  D.
        pha                                     ; 964F 48                       H
        tay                                     ; 9650 A8                       .
        jsr     L9544                           ; 9651 20 44 95                  D.
        pla                                     ; 9654 68                       h
        tay                                     ; 9655 A8                       .
        rts                                     ; 9656 60                       `

; ----------------------------------------------------------------------------
L9657:  sei                                     ; 9657 78                       x
        lda     TURBO_DD00                      ; 9658 A5 8E                    ..
        sta     cia2base                        ; 965A 8D 00 DD                 ...
L965D:  bit     cia2base                        ; 965D 2C 00 DD                 ,..
        bpl     L965D                           ; 9660 10 FB                    ..
        rts                                     ; 9662 60                       `

; ----------------------------------------------------------------------------
L9663:  lda     curDrive                        ; 9663 AD 89 84                 ...
        jsr     SetDevice                       ; 9666 20 B0 C2                  ..
        ldx     curDrive                        ; 9669 AE 89 84                 ...
        lda     diskOpenFlg,x                   ; 966C BD 8A 84                 ...
        bmi     L967F                           ; 966F 30 0E                    0.
        jsr     L96DD                           ; 9671 20 DD 96                  ..
        txa                                     ; 9674 8A                       .
        bne     L96B9                           ; 9675 D0 42                    .B
        ldx     curDrive                        ; 9677 AE 89 84                 ...
        lda     #$80                            ; 967A A9 80                    ..
        sta     diskOpenFlg,x                   ; 967C 9D 8A 84                 ...
L967F:  .byte   ")@"                            ; 967F 29 40                    )@
        .byte   $D0                             ; 9681 D0                       .
        .byte   "/ "                            ; 9682 2F 20                    / 
        .byte   $13,$9C                         ; 9684 13 9C                    ..
        .byte   " \"                            ; 9686 20 5C                     \
        .byte   $C2,$A2,$96,$A9,$BA             ; 9688 C2 A2 96 A9 BA           .....
        .byte   " "                             ; 968D 20                        
        .byte   $ED,$95,$8A,$D0                 ; 968E ED 95 8A D0              ....
        .byte   "# "                            ; 9692 23 20                    # 
        .byte   $AE,$FF                         ; 9694 AE FF                    ..
        .byte   "x"                             ; 9696 78                       x
        .byte   $A0                             ; 9697 A0                       .
        .byte   "!"                             ; 9698 21                       !
        .byte   $88,$D0,$FD                     ; 9699 88 D0 FD                 ...
        .byte   " "                             ; 969C 20                        
        .byte   $8C,$95                         ; 969D 8C 95                    ..
        .byte   ","                             ; 969F 2C                       ,
        .byte   $00,$DD                         ; 96A0 00 DD                    ..
        .byte   "0"                             ; 96A2 30                       0
        .byte   $FB                             ; 96A3 FB                       .
        .byte   " _"                            ; 96A4 20 5F                     _
        .byte   $C2,$AE,$89,$84,$BD,$8A,$84,$09 ; 96A6 C2 AE 89 84 BD 8A 84 09  ........
        .byte   "@"                             ; 96AE 40                       @
        .byte   $9D,$8A,$84,$A2,$00,$F0,$03     ; 96AF 9D 8A 84 A2 00 F0 03     .......
        .byte   " _"                            ; 96B6 20 5F                     _
        .byte   $C2                             ; 96B8 C2                       .
L96B9:  .byte   "`M-E"                          ; 96B9 60 4D 2D 45              `M-E
        .byte   $E2,$03                         ; 96BD E2 03                    ..
L96BF:  .byte   " \"                            ; 96BF 20 5C                     \
        .byte   $C2,$A2,$04,$A9                 ; 96C1 C2 A2 04 A9              ....
        .byte   "  "                            ; 96C5 20 20                      
        .byte   $1D,$96                         ; 96C7 1D 96                    ..
        .byte   " W"                            ; 96C9 20 57                     W
        .byte   $96,$AD,$89,$84                 ; 96CB 96 AD 89 84              ....
        .byte   " "                             ; 96CF 20                        
        .byte   $B1,$FF,$A9,$EF                 ; 96D0 B1 FF A9 EF              ....
        .byte   " "                             ; 96D4 20                        
        .byte   $93,$FF                         ; 96D5 93 FF                    ..
        .byte   " "                             ; 96D7 20                        
        .byte   $AE,$FF                         ; 96D8 AE FF                    ..
        .byte   "L_"                            ; 96DA 4C 5F                    L_
        .byte   $C2                             ; 96DC C2                       .
L96DD:  .byte   " \"                            ; 96DD 20 5C                     \
        .byte   $C2,$A9,$98,$85,$8E,$A9,$BD,$85 ; 96DF C2 A9 98 85 8E A9 BD 85  ........
        .byte   $8D,$A9,$03,$8D                 ; 96E7 8D A9 03 8D              ....
        .byte   "H"                             ; 96EB 48                       H
        .byte   $97,$A9,$00,$8D                 ; 96EC 97 A9 00 8D              ....
        .byte   "G"                             ; 96F0 47                       G
        .byte   $97,$A9,$1A,$85,$8F             ; 96F1 97 A9 1A 85 8F           .....
        .byte   " "                             ; 96F6 20                        
        .byte   $1C,$97,$8A,$D0,$1D,$18,$A9     ; 96F7 1C 97 8A D0 1D 18 A9     .......
        .byte   " e"                            ; 96FE 20 65                     e
        .byte   $8D,$85,$8D,$90,$02,$E6,$8E,$18 ; 9700 8D 85 8D 90 02 E6 8E 18  ........
        .byte   $A9                             ; 9708 A9                       .
        .byte   " mG"                           ; 9709 20 6D 47                  mG
        .byte   $97,$8D                         ; 970C 97 8D                    ..
        .byte   "G"                             ; 970E 47                       G
        .byte   $97,$90,$03,$EE                 ; 970F 97 90 03 EE              ....
        .byte   "H"                             ; 9713 48                       H
        .byte   $97,$C6,$8F,$10,$DD             ; 9714 97 C6 8F 10 DD           .....
        .byte   "L_"                            ; 9719 4C 5F                    L_
        .byte   $C2,$A5,$8F,$0D,$8D,$84,$F0,$1E ; 971B C2 A5 8F 0D 8D 84 F0 1E  ........
        .byte   $A2,$97,$A9                     ; 9723 A2 97 A9                 ...
        .byte   "D "                            ; 9726 44 20                    D 
        .byte   $ED,$95                         ; 9728 ED 95                    ..
; ----------------------------------------------------------------------------
        txa                                     ; 972A 8A                       .
        bne     L9743                           ; 972B D0 16                    ..
        lda     #$20                            ; 972D A9 20                    . 
        jsr     CIOUT                           ; 972F 20 A8 FF                  ..
        ldy     #$00                            ; 9732 A0 00                    ..
L9734:  lda     ($8D),y                         ; 9734 B1 8D                    ..
        jsr     CIOUT                           ; 9736 20 A8 FF                  ..
        iny                                     ; 9739 C8                       .
        cpy     #$20                            ; 973A C0 20                    . 
        bcc     L9734                           ; 973C 90 F6                    ..
        jsr     UNLSN                           ; 973E 20 AE FF                  ..
        ldx     #$00                            ; 9741 A2 00                    ..
L9743:  rts                                     ; 9743 60                       `

; ----------------------------------------------------------------------------
        eor     $572D                           ; 9744 4D 2D 57                 M-W
        brk                                     ; 9747 00                       .
        brk                                     ; 9748 00                       .
L9749:  txa                                     ; 9749 8A                       .
        pha                                     ; 974A 48                       H
        jsr     L9C13                           ; 974B 20 13 9C                  ..
        ldx     curDrive                        ; 974E AE 89 84                 ...
        lda     diskOpenFlg,x                   ; 9751 BD 8A 84                 ...
        and     #$40                            ; 9754 29 40                    )@
        beq     L9766                           ; 9756 F0 0E                    ..
        jsr     L96BF                           ; 9758 20 BF 96                  ..
        ldx     curDrive                        ; 975B AE 89 84                 ...
        lda     diskOpenFlg,x                   ; 975E BD 8A 84                 ...
        and     #$BF                            ; 9761 29 BF                    ).
        sta     diskOpenFlg,x                   ; 9763 9D 8A 84                 ...
L9766:  pla                                     ; 9766 68                       h
        tax                                     ; 9767 AA                       .
        rts                                     ; 9768 60                       `

; ----------------------------------------------------------------------------
L9769:  jsr     L9C0B                           ; 9769 20 0B 9C                  ..
        jsr     ExitTurbo                       ; 976C 20 32 C2                  2.
L976F:  ldy     curDrive                        ; 976F AC 89 84                 ...
        lda     #$00                            ; 9772 A9 00                    ..
        sta     diskOpenFlg,y                   ; 9774 99 8A 84                 ...
        rts                                     ; 9777 60                       `

; ----------------------------------------------------------------------------
L9778:  jsr     EnterTurbo                      ; 9778 20 14 C2                  ..
        txa                                     ; 977B 8A                       .
        bne     L97A6                           ; 977C D0 28                    .(
        jsr     L9C0B                           ; 977E 20 0B 9C                  ..
        jsr     InitForIO                       ; 9781 20 5C C2                  \.
        lda     #$00                            ; 9784 A9 00                    ..
        sta     L9D37                           ; 9786 8D 37 9D                 .7.
L9789:  lda     #$04                            ; 9789 A9 04                    ..
        sta     $8C                             ; 978B 85 8C                    ..
        lda     #$DC                            ; 978D A9 DC                    ..
        sta     $8B                             ; 978F 85 8B                    ..
        jsr     L9629                           ; 9791 20 29 96                  ).
        jsr     L9889                           ; 9794 20 89 98                  ..
        beq     L97A3                           ; 9797 F0 0A                    ..
        inc     L9D37                           ; 9799 EE 37 9D                 .7.
        cpy     L9D37                           ; 979C CC 37 9D                 .7.
        beq     L97A3                           ; 979F F0 02                    ..
        bcs     L9789                           ; 97A1 B0 E6                    ..
L97A3:  jsr     DoneWithIO                      ; 97A3 20 5F C2                  _.
L97A6:  rts                                     ; 97A6 60                       `

; ----------------------------------------------------------------------------
L97A7:  pha                                     ; 97A7 48                       H
        jsr     EnterTurbo                      ; 97A8 20 14 C2                  ..
        txa                                     ; 97AB 8A                       .
        bne     L97D3                           ; 97AC D0 25                    .%
        pla                                     ; 97AE 68                       h
        pha                                     ; 97AF 48                       H
        ora     #$20                            ; 97B0 09 20                    . 
        sta     r1L                             ; 97B2 85 04                    ..
        jsr     InitForIO                       ; 97B4 20 5C C2                  \.
        ldx     #$04                            ; 97B7 A2 04                    ..
        lda     #$39                            ; 97B9 A9 39                    .9
        jsr     L9625                           ; 97BB 20 25 96                  %.
        jsr     DoneWithIO                      ; 97BE 20 5F C2                  _.
        jsr     L976F                           ; 97C1 20 6F 97                  o.
        pla                                     ; 97C4 68                       h
        tax                                     ; 97C5 AA                       .
        lda     #$C0                            ; 97C6 A9 C0                    ..
        sta     diskOpenFlg,x                   ; 97C8 9D 8A 84                 ...
        stx     curDrive                        ; 97CB 8E 89 84                 ...
        stx     curDevice                       ; 97CE 86 BA                    ..
        ldx     #$00                            ; 97D0 A2 00                    ..
        rts                                     ; 97D2 60                       `

; ----------------------------------------------------------------------------
L97D3:  pla                                     ; 97D3 68                       h
        rts                                     ; 97D4 60                       `

; ----------------------------------------------------------------------------
L97D5:  jsr     L90A7                           ; 97D5 20 A7 90                  ..
        bcc     L981B                           ; 97D8 90 41                    .A
        jsr     L9C45                           ; 97DA 20 45 9C                  E.
        bne     L981B                           ; 97DD D0 3C                    .<
L97DF:  ldx     #$05                            ; 97DF A2 05                    ..
        lda     #$8E                            ; 97E1 A9 8E                    ..
        jsr     L9625                           ; 97E3 20 25 96                  %.
        ldx     #$03                            ; 97E6 A2 03                    ..
        lda     #$20                            ; 97E8 A9 20                    . 
        jsr     L961D                           ; 97EA 20 1D 96                  ..
        lda     r4H                             ; 97ED A5 0B                    ..
        sta     $8C                             ; 97EF 85 8C                    ..
        lda     r4L                             ; 97F1 A5 0A                    ..
        sta     $8B                             ; 97F3 85 8B                    ..
        ldy     #$00                            ; 97F5 A0 00                    ..
        jsr     L9544                           ; 97F7 20 44 95                  D.
        jsr     L9890                           ; 97FA 20 90 98                  ..
        txa                                     ; 97FD 8A                       .
        beq     L980A                           ; 97FE F0 0A                    ..
        inc     L9D37                           ; 9800 EE 37 9D                 .7.
        cpy     L9D37                           ; 9803 CC 37 9D                 .7.
        beq     L980A                           ; 9806 F0 02                    ..
        bcs     L97DF                           ; 9808 B0 D5                    ..
L980A:  txa                                     ; 980A 8A                       .
        bne     L981B                           ; 980B D0 0E                    ..
        bit     curType                         ; 980D 2C C6 88                 ,..
        bvc     L9818                           ; 9810 50 06                    P.
        jsr     L9C84                           ; 9812 20 84 9C                  ..
        clv                                     ; 9815 B8                       .
        bvc     L981B                           ; 9816 50 03                    P.
L9818:  jsr     L9C72                           ; 9818 20 72 9C                  r.
L981B:  ldy     #$00                            ; 981B A0 00                    ..
        rts                                     ; 981D 60                       `

; ----------------------------------------------------------------------------
L981E:  jsr     L909D                           ; 981E 20 9D 90                  ..
        bcc     L9846                           ; 9821 90 23                    .#
L9823:  ldx     #$05                            ; 9823 A2 05                    ..
        lda     #$7C                            ; 9825 A9 7C                    .|
        jsr     L9625                           ; 9827 20 25 96                  %.
        lda     r4H                             ; 982A A5 0B                    ..
        sta     $8C                             ; 982C 85 8C                    ..
        lda     r4L                             ; 982E A5 0A                    ..
        sta     $8B                             ; 9830 85 8B                    ..
        ldy     #$00                            ; 9832 A0 00                    ..
        jsr     L9593                           ; 9834 20 93 95                  ..
        jsr     L9889                           ; 9837 20 89 98                  ..
        beq     L9846                           ; 983A F0 0A                    ..
        inc     L9D37                           ; 983C EE 37 9D                 .7.
        cpy     L9D37                           ; 983F CC 37 9D                 .7.
        beq     L9846                           ; 9842 F0 02                    ..
        bcs     L9823                           ; 9844 B0 DD                    ..
L9846:  rts                                     ; 9846 60                       `

; ----------------------------------------------------------------------------
L9847:  jsr     L909D                           ; 9847 20 9D 90                  ..
        bcc     L9888                           ; 984A 90 3C                    .<
L984C:  lda     #$03                            ; 984C A9 03                    ..
        sta     L9D39                           ; 984E 8D 39 9D                 .9.
L9851:  ldx     #$05                            ; 9851 A2 05                    ..
        lda     #$8E                            ; 9853 A9 8E                    ..
        jsr     L9625                           ; 9855 20 25 96                  %.
        jsr     L9889                           ; 9858 20 89 98                  ..
        txa                                     ; 985B 8A                       .
        beq     L987A                           ; 985C F0 1C                    ..
        dec     L9D39                           ; 985E CE 39 9D                 .9.
        bne     L9851                           ; 9861 D0 EE                    ..
        ldx     #$25                            ; 9863 A2 25                    .%
        inc     L9D37                           ; 9865 EE 37 9D                 .7.
        lda     L9D37                           ; 9868 AD 37 9D                 .7.
        cmp     #$05                            ; 986B C9 05                    ..
        beq     L987A                           ; 986D F0 0B                    ..
        pha                                     ; 986F 48                       H
        jsr     WriteBlock                      ; 9870 20 20 C2                   .
        pla                                     ; 9873 68                       h
        sta     L9D37                           ; 9874 8D 37 9D                 .7.
        txa                                     ; 9877 8A                       .
        beq     L984C                           ; 9878 F0 D2                    ..
L987A:  txa                                     ; 987A 8A                       .
        bne     L9888                           ; 987B D0 0B                    ..
        .byte   $2C                             ; 987D 2C                       ,
L987E:  dec     $88                             ; 987E C6 88                    ..
        bvc     L9885                           ; 9880 50 03                    P.
        jmp     L9C84                           ; 9882 4C 84 9C                 L..

; ----------------------------------------------------------------------------
L9885:  jmp     L9C72                           ; 9885 4C 72 9C                 Lr.

; ----------------------------------------------------------------------------
L9888:  rts                                     ; 9888 60                       `

; ----------------------------------------------------------------------------
L9889:  ldx     #$03                            ; 9889 A2 03                    ..
        lda     #$25                            ; 988B A9 25                    .%
        jsr     L961D                           ; 988D 20 1D 96                  ..
L9890:  lda     #$9D                            ; 9890 A9 9D                    ..
        sta     $8C                             ; 9892 85 8C                    ..
        lda     #$38                            ; 9894 A9 38                    .8
        sta     $8B                             ; 9896 85 8B                    ..
        jsr     L964A                           ; 9898 20 4A 96                  J.
        lda     L9D38                           ; 989B AD 38 9D                 .8.
        pha                                     ; 989E 48                       H
        tay                                     ; 989F A8                       .
        lda     L98B1,y                         ; 98A0 B9 B1 98                 ...
        tay                                     ; 98A3 A8                       .
        pla                                     ; 98A4 68                       h
        cmp     #$01                            ; 98A5 C9 01                    ..
        beq     L98AE                           ; 98A7 F0 05                    ..
        clc                                     ; 98A9 18                       .
        adc     #$1E                            ; 98AA 69 1E                    i.
        bne     L98B0                           ; 98AC D0 02                    ..
L98AE:  lda     #$00                            ; 98AE A9 00                    ..
L98B0:  tax                                     ; 98B0 AA                       .
L98B1:  rts                                     ; 98B1 60                       `

; ----------------------------------------------------------------------------
        ora     (r1H,x)                         ; 98B2 01 05                    ..
        .byte   $02                             ; 98B4 02                       .
        php                                     ; 98B5 08                       .
        php                                     ; 98B6 08                       .
        ora     (r1H,x)                         ; 98B7 01 05                    ..
        ora     (r1H,x)                         ; 98B9 01 05                    ..
        ora     r1H                             ; 98BB 05 05                    ..
        .byte   $0F                             ; 98BD 0F                       .
        .byte   $07                             ; 98BE 07                       .
        ora     $0B05                           ; 98BF 0D 05 0B                 ...
        .byte   $03                             ; 98C2 03                       .
        ora     #$01                            ; 98C3 09 01                    ..
        asl     $0C06                           ; 98C5 0E 06 0C                 ...
        .byte   $04                             ; 98C8 04                       .
        asl     a                               ; 98C9 0A                       .
        .byte   $02                             ; 98CA 02                       .
        php                                     ; 98CB 08                       .
        brk                                     ; 98CC 00                       .
        brk                                     ; 98CD 00                       .
        .byte   $80                             ; 98CE 80                       .
        jsr     L40A0                           ; 98CF 20 A0 40                  .@
        cpy     #$60                            ; 98D2 C0 60                    .`
        cpx     #$10                            ; 98D4 E0 10                    ..
        bcc     L9908                           ; 98D6 90 30                    .0
        bcs     L992A                           ; 98D8 B0 50                    .P
        bne     L994C                           ; 98DA D0 70                    .p
        beq     L987E                           ; 98DC F0 A0                    ..
        brk                                     ; 98DE 00                       .
        jsr     L033A                           ; 98DF 20 3A 03                  :.
        ldy     #$00                            ; 98E2 A0 00                    ..
        sty     a3H                             ; 98E4 84 73                    .s
        sty     a4L                             ; 98E6 84 74                    .t
        iny                                     ; 98E8 C8                       .
        sty     a2H                             ; 98E9 84 71                    .q
        ldy     #$00                            ; 98EB A0 00                    ..
        jsr     L03CB                           ; 98ED 20 CB 03                  ..
        lda     a2H                             ; 98F0 A5 71                    .q
        jsr     L0340                           ; 98F2 20 40 03                  @.
        ldy     a2H                             ; 98F5 A4 71                    .q
        jsr     L03CB                           ; 98F7 20 CB 03                  ..
L98FA:  dey                                     ; 98FA 88                       .
        lda     (a3H),y                         ; 98FB B1 73                    .s
        tax                                     ; 98FD AA                       .
        lsr     a                               ; 98FE 4A                       J
        lsr     a                               ; 98FF 4A                       J
        lsr     a                               ; 9900 4A                       J
        lsr     a                               ; 9901 4A                       J
        sta     a2L                             ; 9902 85 70                    .p
        txa                                     ; 9904 8A                       .
        and     #$0F                            ; 9905 29 0F                    ).
        tax                                     ; 9907 AA                       .
L9908:  lda     #$04                            ; 9908 A9 04                    ..
        sta     $1800                           ; 990A 8D 00 18                 ...
L990D:  bit     $1800                           ; 990D 2C 00 18                 ,..
        beq     L990D                           ; 9910 F0 FB                    ..
        bit     $1800                           ; 9912 2C 00 18                 ,..
        bne     L9917                           ; 9915 D0 00                    ..
L9917:  bne     L9919                           ; 9917 D0 00                    ..
L9919:  stx     $1800                           ; 9919 8E 00 18                 ...
        txa                                     ; 991C 8A                       .
        rol     a                               ; 991D 2A                       *
        and     #$0F                            ; 991E 29 0F                    ).
        sta     $1800                           ; 9920 8D 00 18                 ...
        ldx     a2L                             ; 9923 A6 70                    .p
        lda     $0300,x                         ; 9925 BD 00 03                 ...
        .byte   $8D                             ; 9928 8D                       .
        brk                                     ; 9929 00                       .
L992A:  clc                                     ; 992A 18                       .
        nop                                     ; 992B EA                       .
        rol     a                               ; 992C 2A                       *
        and     #$0F                            ; 992D 29 0F                    ).
        cpy     #$00                            ; 992F C0 00                    ..
        sta     $1800                           ; 9931 8D 00 18                 ...
        bne     L98FA                           ; 9934 D0 C4                    ..
        beq     L997B                           ; 9936 F0 43                    .C
        ldy     #$01                            ; 9938 A0 01                    ..
        jsr     L0389                           ; 993A 20 89 03                  ..
        sta     a2H                             ; 993D 85 71                    .q
        tay                                     ; 993F A8                       .
        jsr     L0389                           ; 9940 20 89 03                  ..
        ldy     a2H                             ; 9943 A4 71                    .q
        rts                                     ; 9945 60                       `

; ----------------------------------------------------------------------------
        jsr     L03CB                           ; 9946 20 CB 03                  ..
L9949:  pha                                     ; 9949 48                       H
        pla                                     ; 994A 68                       h
        .byte   $A9                             ; 994B A9                       .
L994C:  .byte   $04                             ; 994C 04                       .
L994D:  bit     $1800                           ; 994D 2C 00 18                 ,..
        beq     L994D                           ; 9950 F0 FB                    ..
        nop                                     ; 9952 EA                       .
        nop                                     ; 9953 EA                       .
        nop                                     ; 9954 EA                       .
        lda     $1800                           ; 9955 AD 00 18                 ...
        asl     a                               ; 9958 0A                       .
        nop                                     ; 9959 EA                       .
        nop                                     ; 995A EA                       .
        nop                                     ; 995B EA                       .
        nop                                     ; 995C EA                       .
        ora     $1800                           ; 995D 0D 00 18                 ...
        and     #$0F                            ; 9960 29 0F                    ).
        tax                                     ; 9962 AA                       .
        nop                                     ; 9963 EA                       .
        nop                                     ; 9964 EA                       .
        nop                                     ; 9965 EA                       .
        lda     $1800                           ; 9966 AD 00 18                 ...
        asl     a                               ; 9969 0A                       .
        pha                                     ; 996A 48                       H
        lda     a2L                             ; 996B A5 70                    .p
        pla                                     ; 996D 68                       h
        ora     $1800                           ; 996E 0D 00 18                 ...
        and     #$0F                            ; 9971 29 0F                    ).
        ora     $0310,x                         ; 9973 1D 10 03                 ...
        dey                                     ; 9976 88                       .
        sta     (a3H),y                         ; 9977 91 73                    .s
        bne     L9949                           ; 9979 D0 CE                    ..
L997B:  ldx     #$02                            ; 997B A2 02                    ..
        stx     $1800                           ; 997D 8E 00 18                 ...
        rts                                     ; 9980 60                       `

; ----------------------------------------------------------------------------
L9981:  dec     $48                             ; 9981 C6 48                    .H
        bne     L9988                           ; 9983 D0 03                    ..
        jsr     L0534                           ; 9985 20 34 05                  4.
L9988:  lda     #$C0                            ; 9988 A9 C0                    ..
        sta     $1805                           ; 998A 8D 05 18                 ...
L998D:  bit     $1805                           ; 998D 2C 05 18                 ,..
        bpl     L9981                           ; 9990 10 EF                    ..
        lda     #$04                            ; 9992 A9 04                    ..
        bit     $1800                           ; 9994 2C 00 18                 ,..
        bne     L998D                           ; 9997 D0 F4                    ..
        lda     #$00                            ; 9999 A9 00                    ..
        sta     $1800                           ; 999B 8D 00 18                 ...
        rts                                     ; 999E 60                       `

; ----------------------------------------------------------------------------
        php                                     ; 999F 08                       .
        sei                                     ; 99A0 78                       x
        lda     $49                             ; 99A1 A5 49                    .I
        pha                                     ; 99A3 48                       H
        lda     $180F                           ; 99A4 AD 0F 18                 ...
        and     #$DF                            ; 99A7 29 DF                    ).
        sta     $180F                           ; 99A9 8D 0F 18                 ...
        ldy     #$00                            ; 99AC A0 00                    ..
L99AE:  dey                                     ; 99AE 88                       .
        bne     L99AE                           ; 99AF D0 FD                    ..
        jsr     L03BE                           ; 99B1 20 BE 03                  ..
        lda     #$04                            ; 99B4 A9 04                    ..
L99B6:  bit     $1800                           ; 99B6 2C 00 18                 ,..
        beq     L99B6                           ; 99B9 F0 FB                    ..
        jsr     L0529                           ; 99BB 20 29 05                  ).
        lda     #$06                            ; 99BE A9 06                    ..
        sta     a4L                             ; 99C0 85 74                    .t
        lda     #$4A                            ; 99C2 A9 4A                    .J
        sta     a3H                             ; 99C4 85 73                    .s
        jsr     L037B                           ; 99C6 20 7B 03                  {.
        jsr     L052D                           ; 99C9 20 2D 05                  -.
        lda     #$07                            ; 99CC A9 07                    ..
        sta     a4L                             ; 99CE 85 74                    .t
        lda     #$00                            ; 99D0 A9 00                    ..
        sta     a3H                             ; 99D2 85 73                    .s
        lda     #$03                            ; 99D4 A9 03                    ..
        pha                                     ; 99D6 48                       H
        lda     #$FD                            ; 99D7 A9 FD                    ..
        pha                                     ; 99D9 48                       H
        jmp     (L064A)                         ; 99DA 6C 4A 06                 lJ.

; ----------------------------------------------------------------------------
        jsr     L03CB                           ; 99DD 20 CB 03                  ..
        lda     #$00                            ; 99E0 A9 00                    ..
        sta     windowTop                       ; 99E2 85 33                    .3
        sta     $1800                           ; 99E4 8D 00 18                 ...
        jsr     LF98F                           ; 99E7 20 8F F9                  ..
        lda     #$EC                            ; 99EA A9 EC                    ..
        sta     $1C0C                           ; 99EC 8D 0C 1C                 ...
        pla                                     ; 99EF 68                       h
        pla                                     ; 99F0 68                       h
        pla                                     ; 99F1 68                       h
        sta     $49                             ; 99F2 85 49                    .I
        plp                                     ; 99F4 28                       (
        rts                                     ; 99F5 60                       `

; ----------------------------------------------------------------------------
        lda     $064C                           ; 99F6 AD 4C 06                 .L.
        sta     a5H                             ; 99F9 85 77                    .w
        eor     #$60                            ; 99FB 49 60                    I`
        sta     a6L                             ; 99FD 85 78                    .x
        rts                                     ; 99FF 60                       `

; ----------------------------------------------------------------------------
        jsr     L0632                           ; 9A00 20 32 06                  2.
        lda     curPattern                      ; 9A03 A5 22                    ."
        beq     L9A0C                           ; 9A05 F0 05                    ..
        ldx     CPU_DDR                         ; 9A07 A6 00                    ..
        dex                                     ; 9A09 CA                       .
        beq     L9A2C                           ; 9A0A F0 20                    . 
L9A0C:  lda     r8L                             ; 9A0C A5 12                    ..
        pha                                     ; 9A0E 48                       H
        lda     r8H                             ; 9A0F A5 13                    ..
        pha                                     ; 9A11 48                       H
        jsr     L04DF                           ; 9A12 20 DF 04                  ..
        pla                                     ; 9A15 68                       h
        sta     r8H                             ; 9A16 85 13                    ..
        tax                                     ; 9A18 AA                       .
        pla                                     ; 9A19 68                       h
        sta     r8L                             ; 9A1A 85 12                    ..
        ldy     CPU_DDR                         ; 9A1C A4 00                    ..
        cpy     #$01                            ; 9A1E C0 01                    ..
        bne     L9A4B                           ; 9A20 D0 29                    .)
        cpx     r10H                            ; 9A22 E4 17                    ..
        bne     L9A4C                           ; 9A24 D0 26                    .&
        cmp     r10L                            ; 9A26 C5 16                    ..
        bne     L9A4C                           ; 9A28 D0 22                    ."
        lda     #$00                            ; 9A2A A9 00                    ..
L9A2C:  pha                                     ; 9A2C 48                       H
        lda     curPattern                      ; 9A2D A5 22                    ."
        ldx     #$FF                            ; 9A2F A2 FF                    ..
        sec                                     ; 9A31 38                       8
        sbc     $064C                           ; 9A32 ED 4C 06                 .L.
        beq     L9A4A                           ; 9A35 F0 13                    ..
        bcs     L9A3F                           ; 9A37 B0 06                    ..
        eor     #$FF                            ; 9A39 49 FF                    I.
        adc     #$01                            ; 9A3B 69 01                    i.
        ldx     #$01                            ; 9A3D A2 01                    ..
L9A3F:  jsr     L0494                           ; 9A3F 20 94 04                  ..
        lda     $064C                           ; 9A42 AD 4C 06                 .L.
        sta     curPattern                      ; 9A45 85 22                    ."
        jsr     L0518                           ; 9A47 20 18 05                  ..
L9A4A:  pla                                     ; 9A4A 68                       h
L9A4B:  rts                                     ; 9A4B 60                       `

; ----------------------------------------------------------------------------
L9A4C:  lda     #$0B                            ; 9A4C A9 0B                    ..
        sta     CPU_DDR                         ; 9A4E 85 00                    ..
        rts                                     ; 9A50 60                       `

; ----------------------------------------------------------------------------
        stx     $4A                             ; 9A51 86 4A                    .J
        asl     a                               ; 9A53 0A                       .
        tay                                     ; 9A54 A8                       .
        lda     $1C00                           ; 9A55 AD 00 1C                 ...
        and     #$FE                            ; 9A58 29 FE                    ).
        sta     a2L                             ; 9A5A 85 70                    .p
        lda     #$1E                            ; 9A5C A9 1E                    ..
        sta     a2H                             ; 9A5E 85 71                    .q
L9A60:  lda     a2L                             ; 9A60 A5 70                    .p
        clc                                     ; 9A62 18                       .
        adc     $4A                             ; 9A63 65 4A                    eJ
        eor     a2L                             ; 9A65 45 70                    Ep
        and     #$03                            ; 9A67 29 03                    ).
        eor     a2L                             ; 9A69 45 70                    Ep
        sta     a2L                             ; 9A6B 85 70                    .p
        sta     $1C00                           ; 9A6D 8D 00 1C                 ...
        lda     a2H                             ; 9A70 A5 71                    .q
        jsr     L04D3                           ; 9A72 20 D3 04                  ..
        lda     a2H                             ; 9A75 A5 71                    .q
        cpy     #$05                            ; 9A77 C0 05                    ..
        bcc     L9A83                           ; 9A79 90 08                    ..
        cmp     #$11                            ; 9A7B C9 11                    ..
        bcc     L9A89                           ; 9A7D 90 0A                    ..
        sbc     #$02                            ; 9A7F E9 02                    ..
        bne     L9A89                           ; 9A81 D0 06                    ..
L9A83:  cmp     #$1C                            ; 9A83 C9 1C                    ..
        bcs     L9A89                           ; 9A85 B0 02                    ..
        adc     #$04                            ; 9A87 69 04                    i.
L9A89:  sta     a2H                             ; 9A89 85 71                    .q
        dey                                     ; 9A8B 88                       .
        bne     L9A60                           ; 9A8C D0 D2                    ..
        lda     #$4B                            ; 9A8E A9 4B                    .K
        sta     $1805                           ; 9A90 8D 05 18                 ...
L9A93:  lda     $1805                           ; 9A93 AD 05 18                 ...
        bne     L9A93                           ; 9A96 D0 FB                    ..
        rts                                     ; 9A98 60                       `

; ----------------------------------------------------------------------------
        jsr     L0632                           ; 9A99 20 32 06                  2.
        ldx     CPU_DDR                         ; 9A9C A6 00                    ..
        dex                                     ; 9A9E CA                       .
        beq     L9AB3                           ; 9A9F F0 12                    ..
        ldx     #$FF                            ; 9AA1 A2 FF                    ..
        lda     #$01                            ; 9AA3 A9 01                    ..
        jsr     L0494                           ; 9AA5 20 94 04                  ..
        ldx     #$01                            ; 9AA8 A2 01                    ..
        txa                                     ; 9AAA 8A                       .
        jsr     L0494                           ; 9AAB 20 94 04                  ..
        lda     #$FF                            ; 9AAE A9 FF                    ..
        jsr     L04D3                           ; 9AB0 20 D3 04                  ..
L9AB3:  lda     #$04                            ; 9AB3 A9 04                    ..
        sta     a2L                             ; 9AB5 85 70                    .p
L9AB7:  jsr     L0599                           ; 9AB7 20 99 05                  ..
        ldx     r11L                            ; 9ABA A6 18                    ..
        stx     curPattern                      ; 9ABC 86 22                    ."
        ldy     CPU_DDR                         ; 9ABE A4 00                    ..
        dey                                     ; 9AC0 88                       .
        beq     L9AD4                           ; 9AC1 F0 11                    ..
        dec     a2L                             ; 9AC3 C6 70                    .p
        bmi     L9ACF                           ; 9AC5 30 08                    0.
        ldx     a2L                             ; 9AC7 A6 70                    .p
        jsr     L051D                           ; 9AC9 20 1D 05                  ..
        sec                                     ; 9ACC 38                       8
        bcs     L9AB7                           ; 9ACD B0 E8                    ..
L9ACF:  lda     #$00                            ; 9ACF A9 00                    ..
        sta     curPattern                      ; 9AD1 85 22                    ."
        rts                                     ; 9AD3 60                       `

; ----------------------------------------------------------------------------
L9AD4:  txa                                     ; 9AD4 8A                       .
        jsr     LF24B                           ; 9AD5 20 4B F2                  K.
        sta     $43                             ; 9AD8 85 43                    .C
        lda     $1C00                           ; 9ADA AD 00 1C                 ...
        and     #$9F                            ; 9ADD 29 9F                    ).
        ora     $0544,x                         ; 9ADF 1D 44 05                 .D.
L9AE2:  sta     $1C00                           ; 9AE2 8D 00 1C                 ...
        rts                                     ; 9AE5 60                       `

; ----------------------------------------------------------------------------
        lda     #$F7                            ; 9AE6 A9 F7                    ..
        bne     L9AFB                           ; 9AE8 D0 11                    ..
        lda     #$08                            ; 9AEA A9 08                    ..
        ora     $1C00                           ; 9AEC 0D 00 1C                 ...
        bne     L9AE2                           ; 9AEF D0 F1                    ..
        lda     #$00                            ; 9AF1 A9 00                    ..
        sta     r15L                            ; 9AF3 85 20                    . 
        lda     #$FF                            ; 9AF5 A9 FF                    ..
        sta     $3E                             ; 9AF7 85 3E                    .>
        lda     #$FB                            ; 9AF9 A9 FB                    ..
L9AFB:  and     $1C00                           ; 9AFB 2D 00 1C                 -..
        jmp     L0525                           ; 9AFE 4C 25 05                 L%.

; ----------------------------------------------------------------------------
        brk                                     ; 9B01 00                       .
        jsr     L6040                           ; 9B02 20 40 60                  @`
        tax                                     ; 9B05 AA                       .
        bit     r15L                            ; 9B06 24 20                    $ 
        bpl     L9B13                           ; 9B08 10 09                    ..
        jsr     L063B                           ; 9B0A 20 3B 06                  ;.
        lda     #$20                            ; 9B0D A9 20                    . 
        sta     r15L                            ; 9B0F 85 20                    . 
        ldx     #$00                            ; 9B11 A2 00                    ..
L9B13:  cpx     curPattern                      ; 9B13 E4 22                    ."
        beq     L9B38                           ; 9B15 F0 21                    .!
        jsr     L04F6                           ; 9B17 20 F6 04                  ..
        cmp     #$01                            ; 9B1A C9 01                    ..
        bne     L9B38                           ; 9B1C D0 1A                    ..
        ldy     r11H                            ; 9B1E A4 19                    ..
        iny                                     ; 9B20 C8                       .
        cpy     $43                             ; 9B21 C4 43                    .C
        bcc     L9B27                           ; 9B23 90 02                    ..
        ldy     #$00                            ; 9B25 A0 00                    ..
L9B27:  sty     r11H                            ; 9B27 84 19                    ..
        lda     #$00                            ; 9B29 A9 00                    ..
        sta     $45                             ; 9B2B 85 45                    .E
        lda     #$00                            ; 9B2D A9 00                    ..
        sta     windowTop                       ; 9B2F 85 33                    .3
        lda     #$18                            ; 9B31 A9 18                    ..
        sta     $32                             ; 9B33 85 32                    .2
        jsr     L05A5                           ; 9B35 20 A5 05                  ..
L9B38:  rts                                     ; 9B38 60                       `

; ----------------------------------------------------------------------------
        jsr     L0443                           ; 9B39 20 43 04                  C.
        ldx     CPU_DDR                         ; 9B3C A6 00                    ..
        dex                                     ; 9B3E CA                       .
        bne     L9B44                           ; 9B3F D0 03                    ..
        jsr     L0548                           ; 9B41 20 48 05                  H.
L9B44:  jsr     L037B                           ; 9B44 20 7B 03                  {.
        lda     #$10                            ; 9B47 A9 10                    ..
        bne     L9B50                           ; 9B49 D0 05                    ..
        jsr     L0443                           ; 9B4B 20 43 04                  C.
        lda     #$00                            ; 9B4E A9 00                    ..
L9B50:  ldx     CPU_DDR                         ; 9B50 A6 00                    ..
        dex                                     ; 9B52 CA                       .
        beq     L9B58                           ; 9B53 F0 03                    ..
        rts                                     ; 9B55 60                       `

; ----------------------------------------------------------------------------
        lda     #$30                            ; 9B56 A9 30                    .0
L9B58:  sta     $45                             ; 9B58 85 45                    .E
        lda     #$06                            ; 9B5A A9 06                    ..
        sta     windowTop                       ; 9B5C 85 33                    .3
        lda     #$4C                            ; 9B5E A9 4C                    .L
        sta     $32                             ; 9B60 85 32                    .2
        lda     #$07                            ; 9B62 A9 07                    ..
        sta     msePicPtr                       ; 9B64 85 31                    .1
        tsx                                     ; 9B66 BA                       .
        stx     $49                             ; 9B67 86 49                    .I
        ldx     #$01                            ; 9B69 A2 01                    ..
        stx     CPU_DDR                         ; 9B6B 86 00                    ..
        dex                                     ; 9B6D CA                       .
        stx     graphMode                       ; 9B6E 86 3F                    .?
        lda     #$EE                            ; 9B70 A9 EE                    ..
        sta     $1C0C                           ; 9B72 8D 0C 1C                 ...
        lda     $45                             ; 9B75 A5 45                    .E
        cmp     #$10                            ; 9B77 C9 10                    ..
        beq     L9B85                           ; 9B79 F0 0A                    ..
        cmp     #$30                            ; 9B7B C9 30                    .0
        beq     L9B82                           ; 9B7D F0 03                    ..
        jmp     LF4CA                           ; 9B7F 4C CA F4                 L..

; ----------------------------------------------------------------------------
L9B82:  jmp     LF3B1                           ; 9B82 4C B1 F3                 L..

; ----------------------------------------------------------------------------
L9B85:  jsr     LF5E9                           ; 9B85 20 E9 F5                  ..
        sta     mouseXPos                       ; 9B88 85 3A                    .:
        lda     $1C00                           ; 9B8A AD 00 1C                 ...
        and     #$10                            ; 9B8D 29 10                    ).
        bne     L9B95                           ; 9B8F D0 04                    ..
        lda     #$08                            ; 9B91 A9 08                    ..
        bne     L9BEC                           ; 9B93 D0 57                    .W
L9B95:  jsr     LF78F                           ; 9B95 20 8F F7                  ..
        jsr     LF510                           ; 9B98 20 10 F5                  ..
        ldx     #$09                            ; 9B9B A2 09                    ..
L9B9D:  bvc     L9B9D                           ; 9B9D 50 FE                    P.
        clv                                     ; 9B9F B8                       .
        dex                                     ; 9BA0 CA                       .
        bne     L9B9D                           ; 9BA1 D0 FA                    ..
        lda     #$FF                            ; 9BA3 A9 FF                    ..
        sta     $1C03                           ; 9BA5 8D 03 1C                 ...
        lda     $1C0C                           ; 9BA8 AD 0C 1C                 ...
        and     #$1F                            ; 9BAB 29 1F                    ).
        ora     #$C0                            ; 9BAD 09 C0                    ..
        sta     $1C0C                           ; 9BAF 8D 0C 1C                 ...
        lda     #$FF                            ; 9BB2 A9 FF                    ..
        ldx     #$05                            ; 9BB4 A2 05                    ..
        sta     $1C01                           ; 9BB6 8D 01 1C                 ...
        clv                                     ; 9BB9 B8                       .
L9BBA:  bvc     L9BBA                           ; 9BBA 50 FE                    P.
        clv                                     ; 9BBC B8                       .
        dex                                     ; 9BBD CA                       .
        bne     L9BBA                           ; 9BBE D0 FA                    ..
        ldy     #$BB                            ; 9BC0 A0 BB                    ..
L9BC2:  lda     $0100,y                         ; 9BC2 B9 00 01                 ...
L9BC5:  bvc     L9BC5                           ; 9BC5 50 FE                    P.
        clv                                     ; 9BC7 B8                       .
        sta     $1C01                           ; 9BC8 8D 01 1C                 ...
        iny                                     ; 9BCB C8                       .
        bne     L9BC2                           ; 9BCC D0 F4                    ..
L9BCE:  lda     (mouseOn),y                     ; 9BCE B1 30                    .0
L9BD0:  bvc     L9BD0                           ; 9BD0 50 FE                    P.
        clv                                     ; 9BD2 B8                       .
        sta     $1C01                           ; 9BD3 8D 01 1C                 ...
        iny                                     ; 9BD6 C8                       .
        bne     L9BCE                           ; 9BD7 D0 F5                    ..
L9BD9:  bvc     L9BD9                           ; 9BD9 50 FE                    P.
        lda     $1C0C                           ; 9BDB AD 0C 1C                 ...
        ora     #$E0                            ; 9BDE 09 E0                    ..
        sta     $1C0C                           ; 9BE0 8D 0C 1C                 ...
        lda     #$00                            ; 9BE3 A9 00                    ..
        sta     $1C03                           ; 9BE5 8D 03 1C                 ...
        sta     $50                             ; 9BE8 85 50                    .P
        lda     #$01                            ; 9BEA A9 01                    ..
L9BEC:  sta     CPU_DDR                         ; 9BEC 85 00                    ..
        rts                                     ; 9BEE 60                       `

; ----------------------------------------------------------------------------
        lda     r15L                            ; 9BEF A5 20                    . 
        and     #$20                            ; 9BF1 29 20                    ) 
        bne     L9C02                           ; 9BF3 D0 0D                    ..
        jsr     LF97E                           ; 9BF5 20 7E F9                  ~.
        ldy     #$80                            ; 9BF8 A0 80                    ..
L9BFA:  dex                                     ; 9BFA CA                       .
        bne     L9BFA                           ; 9BFB D0 FD                    ..
        dey                                     ; 9BFD 88                       .
        bne     L9BFA                           ; 9BFE D0 FA                    ..
        sty     $3E                             ; 9C00 84 3E                    .>
L9C02:  lda     #$FF                            ; 9C02 A9 FF                    ..
        sta     $48                             ; 9C04 85 48                    .H
        rts                                     ; 9C06 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; 9C07 00                       .
        brk                                     ; 9C08 00                       .
        brk                                     ; 9C09 00                       .
        brk                                     ; 9C0A 00                       .
L9C0B:  bit     curType                         ; 9C0B 2C C6 88                 ,..
        bvc     L9C13                           ; 9C0E 50 03                    P.
        jsr     L9C18                           ; 9C10 20 18 9C                  ..
L9C13:  ldy     #$FF                            ; 9C13 A0 FF                    ..
        jmp     AccessCache                     ; 9C15 4C EF C2                 L..

; ----------------------------------------------------------------------------
L9C18:  lda     #$9C                            ; 9C18 A9 9C                    ..
        sta     r0H                             ; 9C1A 85 03                    ..
        lda     #$09                            ; 9C1C A9 09                    ..
        sta     r0L                             ; 9C1E 85 02                    ..
        ldy     #$00                            ; 9C20 A0 00                    ..
        sty     r1L                             ; 9C22 84 04                    ..
        sty     r1H                             ; 9C24 84 05                    ..
        sty     r2H                             ; 9C26 84 07                    ..
        iny                                     ; 9C28 C8                       .
        iny                                     ; 9C29 C8                       .
        sty     r2L                             ; 9C2A 84 06                    ..
        iny                                     ; 9C2C C8                       .
        sty     r3H                             ; 9C2D 84 09                    ..
        ldy     curDrive                        ; 9C2F AC 89 84                 ...
        lda     driveData,y                     ; 9C32 B9 BF 88                 ...
        sta     r3L                             ; 9C35 85 08                    ..
L9C37:  jsr     StashRAM                        ; 9C37 20 C8 C2                  ..
        inc     r1H                             ; 9C3A E6 05                    ..
        bne     L9C37                           ; 9C3C D0 F9                    ..
        inc     r3L                             ; 9C3E E6 08                    ..
        dec     r3H                             ; 9C40 C6 09                    ..
        bne     L9C37                           ; 9C42 D0 F3                    ..
        rts                                     ; 9C44 60                       `

; ----------------------------------------------------------------------------
L9C45:  ldy     #$91                            ; 9C45 A0 91                    ..
        bit     curType                         ; 9C47 2C C6 88                 ,..
        bvc     L9C52                           ; 9C4A 50 06                    P.
        jsr     L9C86                           ; 9C4C 20 86 9C                  ..
        clv                                     ; 9C4F B8                       .
        bvc     L9C5F                           ; 9C50 50 0D                    P.
L9C52:  lda     r1L                             ; 9C52 A5 04                    ..
        cmp     #$12                            ; 9C54 C9 12                    ..
        bne     L9C67                           ; 9C56 D0 0F                    ..
        lda     r1H                             ; 9C58 A5 05                    ..
        beq     L9C67                           ; 9C5A F0 0B                    ..
        jsr     AccessCache                     ; 9C5C 20 EF C2                  ..
L9C5F:  ldy     #$00                            ; 9C5F A0 00                    ..
        lda     (r4L),y                         ; 9C61 B1 0A                    ..
        iny                                     ; 9C63 C8                       .
        ora     (r4L),y                         ; 9C64 11 0A                    ..
        rts                                     ; 9C66 60                       `

; ----------------------------------------------------------------------------
L9C67:  ldx     #$00                            ; 9C67 A2 00                    ..
        rts                                     ; 9C69 60                       `

; ----------------------------------------------------------------------------
L9C6A:  ldy     #$93                            ; 9C6A A0 93                    ..
        jsr     L9C86                           ; 9C6C 20 86 9C                  ..
        and     #$20                            ; 9C6F 29 20                    ) 
        rts                                     ; 9C71 60                       `

; ----------------------------------------------------------------------------
L9C72:  lda     r1L                             ; 9C72 A5 04                    ..
        cmp     #$12                            ; 9C74 C9 12                    ..
        bne     L9C81                           ; 9C76 D0 09                    ..
        lda     r1H                             ; 9C78 A5 05                    ..
        beq     L9C81                           ; 9C7A F0 05                    ..
        ldy     #$90                            ; 9C7C A0 90                    ..
        jmp     AccessCache                     ; 9C7E 4C EF C2                 L..

; ----------------------------------------------------------------------------
L9C81:  ldx     #$00                            ; 9C81 A2 00                    ..
        rts                                     ; 9C83 60                       `

; ----------------------------------------------------------------------------
L9C84:  ldy     #$90                            ; 9C84 A0 90                    ..
L9C86:  lda     r0H                             ; 9C86 A5 03                    ..
        pha                                     ; 9C88 48                       H
        lda     r0L                             ; 9C89 A5 02                    ..
        pha                                     ; 9C8B 48                       H
        lda     r1H                             ; 9C8C A5 05                    ..
        pha                                     ; 9C8E 48                       H
        lda     r1L                             ; 9C8F A5 04                    ..
        pha                                     ; 9C91 48                       H
        lda     r2H                             ; 9C92 A5 07                    ..
        pha                                     ; 9C94 48                       H
        lda     r2L                             ; 9C95 A5 06                    ..
        pha                                     ; 9C97 48                       H
        lda     r3L                             ; 9C98 A5 08                    ..
        pha                                     ; 9C9A 48                       H
        tya                                     ; 9C9B 98                       .
        pha                                     ; 9C9C 48                       H
        ldy     r1L                             ; 9C9D A4 04                    ..
        dey                                     ; 9C9F 88                       .
        lda     L9CE3,y                         ; 9CA0 B9 E3 9C                 ...
        clc                                     ; 9CA3 18                       .
        adc     r1H                             ; 9CA4 65 05                    e.
        sta     r1H                             ; 9CA6 85 05                    ..
        lda     L9D07,y                         ; 9CA8 B9 07 9D                 ...
        ldy     curDrive                        ; 9CAB AC 89 84                 ...
        adc     driveData,y                     ; 9CAE 79 BF 88                 y..
        sta     r3L                             ; 9CB1 85 08                    ..
        ldy     #$00                            ; 9CB3 A0 00                    ..
        sty     r1L                             ; 9CB5 84 04                    ..
        sty     r2L                             ; 9CB7 84 06                    ..
        iny                                     ; 9CB9 C8                       .
        sty     r2H                             ; 9CBA 84 07                    ..
        lda     r4H                             ; 9CBC A5 0B                    ..
        sta     r0H                             ; 9CBE 85 03                    ..
        lda     r4L                             ; 9CC0 A5 0A                    ..
        sta     r0L                             ; 9CC2 85 02                    ..
        pla                                     ; 9CC4 68                       h
        tay                                     ; 9CC5 A8                       .
        jsr     DoRAMOp                         ; 9CC6 20 D4 C2                  ..
        tax                                     ; 9CC9 AA                       .
        pla                                     ; 9CCA 68                       h
        sta     r3L                             ; 9CCB 85 08                    ..
        pla                                     ; 9CCD 68                       h
        sta     r2L                             ; 9CCE 85 06                    ..
        pla                                     ; 9CD0 68                       h
        sta     r2H                             ; 9CD1 85 07                    ..
        pla                                     ; 9CD3 68                       h
        sta     r1L                             ; 9CD4 85 04                    ..
        pla                                     ; 9CD6 68                       h
        sta     r1H                             ; 9CD7 85 05                    ..
        pla                                     ; 9CD9 68                       h
        sta     r0L                             ; 9CDA 85 02                    ..
        pla                                     ; 9CDC 68                       h
        sta     r0H                             ; 9CDD 85 03                    ..
        txa                                     ; 9CDF 8A                       .
        ldx     #$00                            ; 9CE0 A2 00                    ..
        rts                                     ; 9CE2 60                       `

; ----------------------------------------------------------------------------
L9CE3:  brk                                     ; 9CE3 00                       .
        ora     curIndexTable,x                 ; 9CE4 15 2A                    .*
        .byte   $3F                             ; 9CE6 3F                       ?
        .byte   $54                             ; 9CE7 54                       T
        adc     #$7E                            ; 9CE8 69 7E                    i~
        .byte   $93                             ; 9CEA 93                       .
        tay                                     ; 9CEB A8                       .
        lda     $E7D2,x                         ; 9CEC BD D2 E7                 ...
        .byte   $FC                             ; 9CEF FC                       .
        ora     (baselineOffset),y              ; 9CF0 11 26                    .&
        .byte   $3B                             ; 9CF2 3B                       ;
        bvc     L9D5A                           ; 9CF3 50 65                    Pe
        sei                                     ; 9CF5 78                       x
        .byte   $8B                             ; 9CF6 8B                       .
        .byte   $9E                             ; 9CF7 9E                       .
        lda     ($C4),y                         ; 9CF8 B1 C4                    ..
        .byte   $D7                             ; 9CFA D7                       .
        nop                                     ; 9CFB EA                       .
        .byte   $FC                             ; 9CFC FC                       .
        asl     $3220                           ; 9CFD 0E 20 32                 . 2
        .byte   $44                             ; 9D00 44                       D
        lsr     $67,x                           ; 9D01 56 67                    Vg
        sei                                     ; 9D03 78                       x
        .byte   $89                             ; 9D04 89                       .
        txs                                     ; 9D05 9A                       .
        .byte   $AB                             ; 9D06 AB                       .
L9D07:  brk                                     ; 9D07 00                       .
        brk                                     ; 9D08 00                       .
        brk                                     ; 9D09 00                       .
        brk                                     ; 9D0A 00                       .
        brk                                     ; 9D0B 00                       .
        brk                                     ; 9D0C 00                       .
        brk                                     ; 9D0D 00                       .
        brk                                     ; 9D0E 00                       .
        brk                                     ; 9D0F 00                       .
        brk                                     ; 9D10 00                       .
        brk                                     ; 9D11 00                       .
        brk                                     ; 9D12 00                       .
        brk                                     ; 9D13 00                       .
        ora     (CPU_DATA,x)                    ; 9D14 01 01                    ..
        ora     (CPU_DATA,x)                    ; 9D16 01 01                    ..
        ora     (CPU_DATA,x)                    ; 9D18 01 01                    ..
        ora     (CPU_DATA,x)                    ; 9D1A 01 01                    ..
        ora     (CPU_DATA,x)                    ; 9D1C 01 01                    ..
        ora     (CPU_DATA,x)                    ; 9D1E 01 01                    ..
        ora     (r0L,x)                         ; 9D20 01 02                    ..
        .byte   $02                             ; 9D22 02                       .
        .byte   $02                             ; 9D23 02                       .
        .byte   $02                             ; 9D24 02                       .
        .byte   $02                             ; 9D25 02                       .
        .byte   $02                             ; 9D26 02                       .
        .byte   $02                             ; 9D27 02                       .
        .byte   $02                             ; 9D28 02                       .
        .byte   $02                             ; 9D29 02                       .
        .byte   $02                             ; 9D2A 02                       .
L9D2B:  brk                                     ; 9D2B 00                       .
L9D2C:  brk                                     ; 9D2C 00                       .
L9D2D:  brk                                     ; 9D2D 00                       .
L9D2E:  brk                                     ; 9D2E 00                       .
L9D2F:  brk                                     ; 9D2F 00                       .
        brk                                     ; 9D30 00                       .
L9D31:  brk                                     ; 9D31 00                       .
L9D32:  brk                                     ; 9D32 00                       .
L9D33:  brk                                     ; 9D33 00                       .
L9D34:  brk                                     ; 9D34 00                       .
L9D35:  brk                                     ; 9D35 00                       .
L9D36:  brk                                     ; 9D36 00                       .
L9D37:  brk                                     ; 9D37 00                       .
L9D38:  brk                                     ; 9D38 00                       .
L9D39:  brk                                     ; 9D39 00                       .
L9D3A:  brk                                     ; 9D3A 00                       .
        bmi     L9D69                           ; 9D3B 30 2C                    0,
        brk                                     ; 9D3D 00                       .
        .byte   $42                             ; 9D3E 42                       B
        adc     a3L                             ; 9D3F 65 72                    er
        .byte   $6B                             ; 9D41 6B                       k
        adc     $6C                             ; 9D42 65 6C                    el
        adc     a6H                             ; 9D44 65 79                    ey
        jsr     L6F53                           ; 9D46 20 53 6F                  So
        ror     a4L                             ; 9D49 66 74                    ft
        .byte   $77                             ; 9D4B 77                       w
        .byte   $6F                             ; 9D4C 6F                       o
        .byte   $72                             ; 9D4D 72                       r
        .byte   $6B                             ; 9D4E 6B                       k
        .byte   $73                             ; 9D4F 73                       s
        rol     $5000                           ; 9D50 2E 00 50                 ..P
        .byte   $6F                             ; 9D53 6F                       o
        .byte   $72                             ; 9D54 72                       r
        .byte   $74                             ; 9D55 74                       t
        adc     #$6F                            ; 9D56 69 6F                    io
        .byte   $6E                             ; 9D58 6E                       n
        .byte   $73                             ; 9D59 73                       s
L9D5A:  jsr     L6F43                           ; 9D5A 20 43 6F                  Co
        bvs     L9DD8                           ; 9D5D 70 79                    py
        .byte   $72                             ; 9D5F 72                       r
        adc     #$67                            ; 9D60 69 67                    ig
        pla                                     ; 9D62 68                       h
        .byte   $74                             ; 9D63 74                       t
        jsr     L4328                           ; 9D64 20 28 43                  (C
        and     #$20                            ; 9D67 29 20                    ) 
L9D69:  and     (pressFlag),y                   ; 9D69 31 39                    19
        and     $2C30,y                         ; 9D6B 39 30 2C                 90,
        brk                                     ; 9D6E 00                       .
        lsr     a                               ; 9D6F 4A                       J
        adc     #$6D                            ; 9D70 69 6D                    im
        jsr     L6F43                           ; 9D72 20 43 6F                  Co
        jmp     (L656C)                         ; 9D75 6C 6C 65                 lle

; ----------------------------------------------------------------------------
        .byte   $74                             ; 9D78 74                       t
        .byte   $74                             ; 9D79 74                       t
        tax                                     ; 9D7A AA                       .
        tax                                     ; 9D7B AA                       .
        tax                                     ; 9D7C AA                       .
