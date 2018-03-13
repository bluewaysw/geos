; da65 V2.15
; Created:    2017-06-30 19:08:50
; Input file: configure.cvt.record.4
; Page:       1

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "kernal.inc"
.include "jumptab.inc"
.include "c64.inc"

LFF54           := $FF54
LFF6C           := $FF6C
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

L04B9           := $04B9
L032B           := $032B
L04D1           := $04D1
L04B0           := $04B0
L04E9           := $04E9
L046E           := $046E
L03AD           := $03AD
L03ED           := $03ED
L03FF           := $03FF
L03FD           := $03FD
L03FC           := $03FC
L03FB           := $03FB
L03FE           := $03FE
L0368           := $0368
L0402           := $0402
L04BE           := $04BE
L046A           := $046A
L0354           := $0354
L0362           := $0362












; ----------------------------------------------------------------------------

.segment        "drv1581_21hd": absolute

_InitForIO:
        .addr   __InitForIO                     ; 9000 EF 94                    ..
_DoneWithIO:
        .addr   __DoneWithIO                    ; 9002 92 95                    ..
_ExitTurbo:
        .addr   __ExitTurbo                     ; 9004 F3 96                    ..
_PurgeTurbo:
        .addr   __PurgeTurbo                    ; 9006 68 97                    h.
_EnterTurbo:
        .addr   __EnterTurbo                    ; 9008 E8 95                    ..
_ChangeDiskDevice:
        .addr   __ChangeDiskDevice              ; 900A 74 97                    t.
_NewDisk:
        .addr   __NewDisk                       ; 900C E5 97                    ..
_ReadBlock:
        .addr   __ReadBlock                     ; 900E D6 98                    ..
_WriteBlock:
        .addr   __WriteBlock                    ; 9010 3A 99                    :.
_VerWriteBlock:
        .addr   __VerWriteBlock                 ; 9012 69 99                    i.
_OpenDisk:
        .addr   __OpenDisk                      ; 9014 16 91                    ..
_GetBlock:
        .addr   __GetBlock                      ; 9016 8C 90                    ..
_PutBlock:
        .addr   __PutBlock                      ; 9018 C4 90                    ..
_GetDirHead:
        .addr   __GetDirHead                    ; 901A 64 90                    d.
_PutDirHead:
        .addr   __PutDirHead                    ; 901C 9C 90                    ..
_GetFreeDirBlk:
        .addr   __GetFreeDirBlk                 ; 901E BC 92                    ..
_CalcBlksFree:
        .addr   __CalcBlksFree                  ; 9020 73 94                    s.
_FreeBlock:
        .addr   __FreeBlock                     ; 9022 29 94                    ).
_SetNextFree:
        .addr   __SetNextFree                   ; 9024 64 93                    d.
_FindBAMBit:
        .addr   __FindBAMBit                    ; 9026 31 94                    1.
_NxtBlkAlloc:
        .addr   __NxtBlkAlloc                   ; 9028 6A 91                    j.
_BlkAlloc:
        .addr   __BlkAlloc                      ; 902A 3D 91                    =.
_ChkDkGEOS:
        .addr   __ChkDkGEOS                     ; 902C 8E 92                    ..
_SetGEOSDisk:
        .addr   __SetGEOSDisk                   ; 902E B1 94                    ..
; ----------------------------------------------------------------------------
Get1stDirEntry:
        jmp     _Get1stDirEntry                 ; 9030 4C 0F 92                 L..

; ----------------------------------------------------------------------------
GetNxtDirEntry:
        jmp     _GetNxtDirEntry                 ; 9033 4C 1E 92                 L..

; ----------------------------------------------------------------------------
GetBorder:
        jmp     _GetBorder                      ; 9036 4C 68 92                 Lh.

; ----------------------------------------------------------------------------
AddDirBlock:
        jmp     _AddDirBlock                    ; 9039 4C 1D 93                 L..

; ----------------------------------------------------------------------------
ReadBuff:
        jmp     _ReadBuff                       ; 903C 4C 84 90                 L..

; ----------------------------------------------------------------------------
WriteBuff:
        jmp     _WriteBuff                      ; 903F 4C BC 90                 L..

; ----------------------------------------------------------------------------
        jmp     DUNK4_2                         ; 9042 4C AB 97                 L..

; ----------------------------------------------------------------------------
        jmp     GetDOSError                     ; 9045 4C 6C 99                 Ll.

; ----------------------------------------------------------------------------
AllocateBlock:
        jmp     _AllocateBlock                  ; 9048 4C E8 93                 L..

; ----------------------------------------------------------------------------
ReadLink:
        jmp     _ReadLink                       ; 904B 4C 0E 98                 L..

; ----------------------------------------------------------------------------
        .byte   $03                             ; 904E 03                       .
        .byte   "For Noelle & Dylan"            ; 904F 46 6F 72 20 4E 6F 65 6C  For Noel
                                                ; 9057 6C 65 20 26 20 44 79 6C  le & Dyl
                                                ; 905F 61 6E                    an
        .byte   $00                             ; 9061 00                       .
; ----------------------------------------------------------------------------
        bpl     __GetDirHead                    ; 9062 10 00                    ..
__GetDirHead:	
        lda     #$FF                            ; 9064 A9 FF                    ..
        sta     L9BFA                           ; 9066 8D FA 9B                 ...
        jsr     EnterTurbo                      ; 9069 20 14 C2                  ..
        txa                                     ; 906C 8A                       .
        bne     L9083                           ; 906D D0 14                    ..
        jsr     InitForIO                       ; 906F 20 5C C2                  \.
        jsr     SetDirHead_1                    ; 9072 20 D4 90                  ..
        bne     L907F                           ; 9075 D0 08                    ..
        jsr     SetDirHead_2                    ; 9077 20 DC 90                  ..
        bne     L907F                           ; 907A D0 03                    ..
        jsr     SetDirHead_3                    ; 907C 20 E4 90                  ..
L907F:  jsr     DoneWithIO                      ; 907F 20 5F C2                  _.
        txa                                     ; 9082 8A                       .
L9083:  rts                                     ; 9083 60                       `

; ----------------------------------------------------------------------------
_ReadBuff:
        lda     #$80                            ; 9084 A9 80                    ..
        sta     r4H                             ; 9086 85 0B                    ..
        lda     #$00                            ; 9088 A9 00                    ..
        sta     r4L                             ; 908A 85 0A                    ..
__GetBlock:
        jsr     EnterTurbo                      ; 908C 20 14 C2                  ..
        bne     L909A                           ; 908F D0 09                    ..
        jsr     InitForIO                       ; 9091 20 5C C2                  \.
        jsr     ReadBlock                       ; 9094 20 1A C2                  ..
        jsr     DoneWithIO                      ; 9097 20 5F C2                  _.
L909A:  txa                                     ; 909A 8A                       .
        rts                                     ; 909B 60                       `

; ----------------------------------------------------------------------------
__PutDirHead:
        lda     #$00                            ; 909C A9 00                    ..
        sta     L9BFA                           ; 909E 8D FA 9B                 ...
        jsr     EnterTurbo                      ; 90A1 20 14 C2                  ..
        txa                                     ; 90A4 8A                       .
        bne     L90BB                           ; 90A5 D0 14                    ..
        jsr     InitForIO                       ; 90A7 20 5C C2                  \.
        jsr     SetDirHead_1                    ; 90AA 20 D4 90                  ..
        bne     L90B7                           ; 90AD D0 08                    ..
        jsr     SetDirHead_2                    ; 90AF 20 DC 90                  ..
        bne     L90B7                           ; 90B2 D0 03                    ..
        jsr     SetDirHead_3                    ; 90B4 20 E4 90                  ..
L90B7:  jsr     DoneWithIO                      ; 90B7 20 5F C2                  _.
        txa                                     ; 90BA 8A                       .
L90BB:  rts                                     ; 90BB 60                       `

; ----------------------------------------------------------------------------
_WriteBuff:
        lda     #$80                            ; 90BC A9 80                    ..
        sta     r4H                             ; 90BE 85 0B                    ..
        lda     #$00                            ; 90C0 A9 00                    ..
        sta     r4L                             ; 90C2 85 0A                    ..
__PutBlock:
        jsr     EnterTurbo                      ; 90C4 20 14 C2                  ..
        bne     L90D2                           ; 90C7 D0 09                    ..
        jsr     InitForIO                       ; 90C9 20 5C C2                  \.
        jsr     WriteBlock                      ; 90CC 20 20 C2                   .
        jsr     DoneWithIO                      ; 90CF 20 5F C2                  _.
L90D2:  txa                                     ; 90D2 8A                       .
        rts                                     ; 90D3 60                       `

; ----------------------------------------------------------------------------
SetDirHead_1:
        ldx     #$82                            ; 90D4 A2 82                    ..
        ldy     #$00                            ; 90D6 A0 00                    ..
        lda     #$00                            ; 90D8 A9 00                    ..
        beq     L90EA                           ; 90DA F0 0E                    ..
SetDirHead_2:
        ldx     #$89                            ; 90DC A2 89                    ..
        ldy     #$00                            ; 90DE A0 00                    ..
        lda     #$01                            ; 90E0 A9 01                    ..
        bne     L90EA                           ; 90E2 D0 06                    ..
SetDirHead_3:
        ldx     #$9C                            ; 90E4 A2 9C                    ..
        ldy     #$80                            ; 90E6 A0 80                    ..
        lda     #$02                            ; 90E8 A9 02                    ..
L90EA:  stx     r4H                             ; 90EA 86 0B                    ..
        sty     r4L                             ; 90EC 84 0A                    ..
        sta     r1H                             ; 90EE 85 05                    ..
        lda     #$28                            ; 90F0 A9 28                    .(
        sta     r1L                             ; 90F2 85 04                    ..
        bit     L9BFA                           ; 90F4 2C FA 9B                 ,..
        bmi     L90FE                           ; 90F7 30 05                    0.
        jsr     __WriteBlock                    ; 90F9 20 3A 99                  :.
        txa                                     ; 90FC 8A                       .
        rts                                     ; 90FD 60                       `

; ----------------------------------------------------------------------------
L90FE:  jsr     __ReadBlock                     ; 90FE 20 D6 98                  ..
        txa                                     ; 9101 8A                       .
        rts                                     ; 9102 60                       `

; ----------------------------------------------------------------------------
CheckParams_1:
        lda     #$00                            ; 9103 A9 00                    ..
        sta     L9BFC                           ; 9105 8D FC 9B                 ...
        ldx     #$02                            ; 9108 A2 02                    ..
        lda     r1L                             ; 910A A5 04                    ..
        beq     L9114                           ; 910C F0 06                    ..
        cmp     #$51                            ; 910E C9 51                    .Q
        bcs     L9114                           ; 9110 B0 02                    ..
        sec                                     ; 9112 38                       8
        rts                                     ; 9113 60                       `

; ----------------------------------------------------------------------------
L9114:  clc                                     ; 9114 18                       .
        rts                                     ; 9115 60                       `

; ----------------------------------------------------------------------------
__OpenDisk:
        jsr     NewDisk                         ; 9116 20 E1 C1                  ..
        txa                                     ; 9119 8A                       .
        bne     L913C                           ; 911A D0 20                    . 
        jsr     GetDirHead                      ; 911C 20 47 C2                  G.
        bne     L913C                           ; 911F D0 1B                    ..
        jsr     L9286                           ; 9121 20 86 92                  ..
        lda     #$82                            ; 9124 A9 82                    ..
        sta     r4H                             ; 9126 85 0B                    ..
        lda     #$90                            ; 9128 A9 90                    ..
        sta     r4L                             ; 912A 85 0A                    ..
        ldx     #$0C                            ; 912C A2 0C                    ..
        jsr     GetPtrCurDkNm                   ; 912E 20 98 C2                  ..
        ldy     #$12                            ; 9131 A0 12                    ..
L9133:  lda     (r4L),y                         ; 9133 B1 0A                    ..
        sta     (r5L),y                         ; 9135 91 0C                    ..
        dey                                     ; 9137 88                       .
        bpl     L9133                           ; 9138 10 F9                    ..
        ldx     #$00                            ; 913A A2 00                    ..
L913C:  rts                                     ; 913C 60                       `

; ----------------------------------------------------------------------------
__BlkAlloc:
        pla                                     ; 913D 68                       h
        sta     r3L                             ; 913E 85 08                    ..
        pla                                     ; 9140 68                       h
        sta     r3H                             ; 9141 85 09                    ..
        lda     r3H                             ; 9143 A5 09                    ..
        pha                                     ; 9145 48                       H
        lda     r3L                             ; 9146 A5 08                    ..
        pha                                     ; 9148 48                       H
        lda     r3L                             ; 9149 A5 08                    ..
        sec                                     ; 914B 38                       8
        sbc     $C1EE                           ; 914C ED EE C1                 ...
        sta     r3L                             ; 914F 85 08                    ..
        lda     r3H                             ; 9151 A5 09                    ..
        sbc     $C1EF                           ; 9153 ED EF C1                 ...
        sta     r3H                             ; 9156 85 09                    ..
        ldy     #$27                            ; 9158 A0 27                    .'
        lda     r3H                             ; 915A A5 09                    ..
        beq     L9160                           ; 915C F0 02                    ..
        ldy     #$23                            ; 915E A0 23                    .#
L9160:  sty     r3L                             ; 9160 84 08                    ..
        ldy     #$00                            ; 9162 A0 00                    ..
        sty     r3H                             ; 9164 84 09                    ..
        lda     #$02                            ; 9166 A9 02                    ..
        bne     L916C                           ; 9168 D0 02                    ..
__NxtBlkAlloc:
        lda     #$00                            ; 916A A9 00                    ..
L916C:  sta     L9C01                           ; 916C 8D 01 9C                 ...
        lda     r9H                             ; 916F A5 15                    ..
        pha                                     ; 9171 48                       H
        lda     r9L                             ; 9172 A5 14                    ..
        pha                                     ; 9174 48                       H
        lda     r3H                             ; 9175 A5 09                    ..
        pha                                     ; 9177 48                       H
        lda     r3L                             ; 9178 A5 08                    ..
        pha                                     ; 917A 48                       H
        lda     #$00                            ; 917B A9 00                    ..
        sta     r3H                             ; 917D 85 09                    ..
        lda     #$FE                            ; 917F A9 FE                    ..
        sta     r3L                             ; 9181 85 08                    ..
        ldx     #$06                            ; 9183 A2 06                    ..
        ldy     #$08                            ; 9185 A0 08                    ..
        .byte   $20                             ; 9187 20                        
L9188:  adc     #$C1                            ; 9188 69 C1                    i.
        lda     r8L                             ; 918A A5 12                    ..
        beq     L9194                           ; 918C F0 06                    ..
        inc     r2L                             ; 918E E6 06                    ..
        bne     L9194                           ; 9190 D0 02                    ..
        inc     r2H                             ; 9192 E6 07                    ..
L9194:  jsr     L9286                           ; 9194 20 86 92                  ..
        pla                                     ; 9197 68                       h
        sta     r3L                             ; 9198 85 08                    ..
        pla                                     ; 919A 68                       h
        sta     r3H                             ; 919B 85 09                    ..
        ldx     #$03                            ; 919D A2 03                    ..
        lda     r2H                             ; 919F A5 07                    ..
        cmp     r4H                             ; 91A1 C5 0B                    ..
        bne     L91A9                           ; 91A3 D0 04                    ..
        lda     r2L                             ; 91A5 A5 06                    ..
        cmp     r4L                             ; 91A7 C5 0A                    ..
L91A9:  beq     L91AD                           ; 91A9 F0 02                    ..
        bcs     L9208                           ; 91AB B0 5B                    .[
L91AD:  lda     r6H                             ; 91AD A5 0F                    ..
        sta     r4H                             ; 91AF 85 0B                    ..
        lda     r6L                             ; 91B1 A5 0E                    ..
        sta     r4L                             ; 91B3 85 0A                    ..
        lda     r2H                             ; 91B5 A5 07                    ..
        sta     r5H                             ; 91B7 85 0D                    ..
        lda     r2L                             ; 91B9 A5 06                    ..
        sta     r5L                             ; 91BB 85 0C                    ..
L91BD:  jsr     SetNextFree                     ; 91BD 20 92 C2                  ..
        txa                                     ; 91C0 8A                       .
        bne     L9208                           ; 91C1 D0 45                    .E
        ldy     #$00                            ; 91C3 A0 00                    ..
        lda     r3L                             ; 91C5 A5 08                    ..
        sta     (r4L),y                         ; 91C7 91 0A                    ..
        iny                                     ; 91C9 C8                       .
        lda     r3H                             ; 91CA A5 09                    ..
        sta     (r4L),y                         ; 91CC 91 0A                    ..
        clc                                     ; 91CE 18                       .
        lda     #$02                            ; 91CF A9 02                    ..
        adc     r4L                             ; 91D1 65 0A                    e.
        sta     r4L                             ; 91D3 85 0A                    ..
        bcc     L91D9                           ; 91D5 90 02                    ..
        inc     r4H                             ; 91D7 E6 0B                    ..
L91D9:  lda     L9C01                           ; 91D9 AD 01 9C                 ...
        beq     L91E7                           ; 91DC F0 09                    ..
        dec     L9C01                           ; 91DE CE 01 9C                 ...
        bne     L91E7                           ; 91E1 D0 04                    ..
        lda     #$23                            ; 91E3 A9 23                    .#
        sta     r3L                             ; 91E5 85 08                    ..
L91E7:  lda     r5L                             ; 91E7 A5 0C                    ..
        bne     L91ED                           ; 91E9 D0 02                    ..
        dec     r5H                             ; 91EB C6 0D                    ..
L91ED:  dec     r5L                             ; 91ED C6 0C                    ..
        lda     r5L                             ; 91EF A5 0C                    ..
        ora     r5H                             ; 91F1 05 0D                    ..
        bne     L91BD                           ; 91F3 D0 C8                    ..
        ldy     #$00                            ; 91F5 A0 00                    ..
        tya                                     ; 91F7 98                       .
        sta     (r4L),y                         ; 91F8 91 0A                    ..
        iny                                     ; 91FA C8                       .
        lda     r8L                             ; 91FB A5 12                    ..
        bne     L9201                           ; 91FD D0 02                    ..
        lda     #$FE                            ; 91FF A9 FE                    ..
L9201:  clc                                     ; 9201 18                       .
        adc     #$01                            ; 9202 69 01                    i.
        sta     (r4L),y                         ; 9204 91 0A                    ..
        ldx     #$00                            ; 9206 A2 00                    ..
L9208:  pla                                     ; 9208 68                       h
        sta     r9L                             ; 9209 85 14                    ..
        pla                                     ; 920B 68                       h
        sta     r9H                             ; 920C 85 15                    ..
        rts                                     ; 920E 60                       `

; ----------------------------------------------------------------------------
_Get1stDirEntry:
        lda     #$28                            ; 920F A9 28                    .(
        sta     r1L                             ; 9211 85 04                    ..
        lda     #$03                            ; 9213 A9 03                    ..
        sta     r1H                             ; 9215 85 05                    ..
        lda     #$00                            ; 9217 A9 00                    ..
        sta     L9C02                           ; 9219 8D 02 9C                 ...
        beq     L925A                           ; 921C F0 3C                    .<
_GetNxtDirEntry:
        ldx     #$00                            ; 921E A2 00                    ..
        ldy     #$00                            ; 9220 A0 00                    ..
        clc                                     ; 9222 18                       .
        lda     #$20                            ; 9223 A9 20                    . 
        adc     r5L                             ; 9225 65 0C                    e.
        sta     r5L                             ; 9227 85 0C                    ..
        bcc     L922D                           ; 9229 90 02                    ..
        inc     r5H                             ; 922B E6 0D                    ..
L922D:  lda     r5H                             ; 922D A5 0D                    ..
        cmp     #$80                            ; 922F C9 80                    ..
        bne     L9237                           ; 9231 D0 04                    ..
        lda     r5L                             ; 9233 A5 0C                    ..
        cmp     #$FF                            ; 9235 C9 FF                    ..
L9237:  bcc     L9267                           ; 9237 90 2E                    ..
        ldy     #$FF                            ; 9239 A0 FF                    ..
        lda     $8001                           ; 923B AD 01 80                 ...
        sta     r1H                             ; 923E 85 05                    ..
        lda     diskBlkBuf                      ; 9240 AD 00 80                 ...
        sta     r1L                             ; 9243 85 04                    ..
        bne     L925A                           ; 9245 D0 13                    ..
        lda     L9C02                           ; 9247 AD 02 9C                 ...
        bne     L9267                           ; 924A D0 1B                    ..
        lda     #$FF                            ; 924C A9 FF                    ..
        sta     L9C02                           ; 924E 8D 02 9C                 ...
        jsr     GetBorder                       ; 9251 20 36 90                  6.
        txa                                     ; 9254 8A                       .
        bne     L9267                           ; 9255 D0 10                    ..
        tya                                     ; 9257 98                       .
        bne     L9267                           ; 9258 D0 0D                    ..
L925A:  jsr     ReadBuff                        ; 925A 20 3C 90                  <.
        ldy     #$00                            ; 925D A0 00                    ..
        lda     #$80                            ; 925F A9 80                    ..
        sta     r5H                             ; 9261 85 0D                    ..
        lda     #$02                            ; 9263 A9 02                    ..
        sta     r5L                             ; 9265 85 0C                    ..
L9267:  rts                                     ; 9267 60                       `

; ----------------------------------------------------------------------------
_GetBorder:
        jsr     GetDirHead                      ; 9268 20 47 C2                  G.
        txa                                     ; 926B 8A                       .
        bne     L9285                           ; 926C D0 17                    ..
        jsr     L9286                           ; 926E 20 86 92                  ..
        bne     L9277                           ; 9271 D0 04                    ..
        ldy     #$FF                            ; 9273 A0 FF                    ..
        bne     L9283                           ; 9275 D0 0C                    ..
L9277:  lda     $82AC                           ; 9277 AD AC 82                 ...
        sta     r1H                             ; 927A 85 05                    ..
        lda     $82AB                           ; 927C AD AB 82                 ...
        sta     r1L                             ; 927F 85 04                    ..
        ldy     #$00                            ; 9281 A0 00                    ..
L9283:  ldx     #$00                            ; 9283 A2 00                    ..
L9285:  rts                                     ; 9285 60                       `

; ----------------------------------------------------------------------------
L9286:  lda     #$82                            ; 9286 A9 82                    ..
        sta     r5H                             ; 9288 85 0D                    ..
        lda     #$00                            ; 928A A9 00                    ..
        sta     r5L                             ; 928C 85 0C                    ..
__ChkDkGEOS:
        ldy     #$AD                            ; 928E A0 AD                    ..
        ldx     #$00                            ; 9290 A2 00                    ..
        stx     isGEOS                          ; 9292 8E 8B 84                 ...
L9295:  lda     (r5L),y                         ; 9295 B1 0C                    ..
        cmp     GEOSDiskID,x                    ; 9297 DD AB 92                 ...
        bne     L92A7                           ; 929A D0 0B                    ..
        iny                                     ; 929C C8                       .
        inx                                     ; 929D E8                       .
        cpx     #$0B                            ; 929E E0 0B                    ..
        bne     L9295                           ; 92A0 D0 F3                    ..
        lda     #$FF                            ; 92A2 A9 FF                    ..
        sta     isGEOS                          ; 92A4 8D 8B 84                 ...
L92A7:  lda     isGEOS                          ; 92A7 AD 8B 84                 ...
        rts                                     ; 92AA 60                       `

; ----------------------------------------------------------------------------
GEOSDiskID:
        .byte   "GEOS format V1.0"              ; 92AB 47 45 4F 53 20 66 6F 72  GEOS for
                                                ; 92B3 6D 61 74 20 56 31 2E 30  mat V1.0
        .byte   $00                             ; 92BB 00                       .
; ----------------------------------------------------------------------------
__GetFreeDirBlk:
        php                                     ; 92BC 08                       .
        sei                                     ; 92BD 78                       x
        lda     r6L                             ; 92BE A5 0E                    ..
        pha                                     ; 92C0 48                       H
        lda     r2H                             ; 92C1 A5 07                    ..
        pha                                     ; 92C3 48                       H
        lda     r2L                             ; 92C4 A5 06                    ..
        pha                                     ; 92C6 48                       H
        ldx     r10L                            ; 92C7 A6 16                    ..
        inx                                     ; 92C9 E8                       .
        stx     r6L                             ; 92CA 86 0E                    ..
        lda     #$28                            ; 92CC A9 28                    .(
        sta     r1L                             ; 92CE 85 04                    ..
        lda     #$03                            ; 92D0 A9 03                    ..
        sta     r1H                             ; 92D2 85 05                    ..
L92D4:  jsr     ReadBuff                        ; 92D4 20 3C 90                  <.
L92D7:  txa                                     ; 92D7 8A                       .
        bne     L9312                           ; 92D8 D0 38                    .8
        dec     r6L                             ; 92DA C6 0E                    ..
        beq     L92F3                           ; 92DC F0 15                    ..
L92DE:  lda     diskBlkBuf                      ; 92DE AD 00 80                 ...
        bne     L92E9                           ; 92E1 D0 06                    ..
        jsr     AddDirBlock                     ; 92E3 20 39 90                  9.
        clv                                     ; 92E6 B8                       .
        bvc     L92D7                           ; 92E7 50 EE                    P.
L92E9:  sta     r1L                             ; 92E9 85 04                    ..
        lda     $8001                           ; 92EB AD 01 80                 ...
        sta     r1H                             ; 92EE 85 05                    ..
        clv                                     ; 92F0 B8                       .
        bvc     L92D4                           ; 92F1 50 E1                    P.
L92F3:  ldy     #$02                            ; 92F3 A0 02                    ..
        ldx     #$00                            ; 92F5 A2 00                    ..
L92F7:  lda     diskBlkBuf,y                    ; 92F7 B9 00 80                 ...
        beq     L9312                           ; 92FA F0 16                    ..
        tya                                     ; 92FC 98                       .
        clc                                     ; 92FD 18                       .
        adc     #$20                            ; 92FE 69 20                    i 
        tay                                     ; 9300 A8                       .
        bcc     L92F7                           ; 9301 90 F4                    ..
        lda     #$01                            ; 9303 A9 01                    ..
        sta     r6L                             ; 9305 85 0E                    ..
        ldx     #$04                            ; 9307 A2 04                    ..
        ldy     r10L                            ; 9309 A4 16                    ..
        iny                                     ; 930B C8                       .
        sty     r10L                            ; 930C 84 16                    ..
        cpy     #$12                            ; 930E C0 12                    ..
        bcc     L92DE                           ; 9310 90 CC                    ..
L9312:  pla                                     ; 9312 68                       h
        sta     r2L                             ; 9313 85 06                    ..
        pla                                     ; 9315 68                       h
        sta     r2H                             ; 9316 85 07                    ..
        pla                                     ; 9318 68                       h
        sta     r6L                             ; 9319 85 0E                    ..
        plp                                     ; 931B 28                       (
        rts                                     ; 931C 60                       `

; ----------------------------------------------------------------------------
_AddDirBlock:
        lda     r6H                             ; 931D A5 0F                    ..
        pha                                     ; 931F 48                       H
        lda     r6L                             ; 9320 A5 0E                    ..
        pha                                     ; 9322 48                       H
        ldx     #$04                            ; 9323 A2 04                    ..
        lda     $89FA                           ; 9325 AD FA 89                 ...
        beq     ClearAndWrite                   ; 9328 F0 22                    ."
        lda     r1H                             ; 932A A5 05                    ..
        sta     r3H                             ; 932C 85 09                    ..
        lda     r1L                             ; 932E A5 04                    ..
        sta     r3L                             ; 9330 85 08                    ..
        jsr     SetNextFree                     ; 9332 20 92 C2                  ..
        pla                                     ; 9335 68                       h
        sta     r6L                             ; 9336 85 0E                    ..
        pla                                     ; 9338 68                       h
        sta     r6H                             ; 9339 85 0F                    ..
        lda     r3H                             ; 933B A5 09                    ..
        sta     $8001                           ; 933D 8D 01 80                 ...
        lda     r3L                             ; 9340 A5 08                    ..
        sta     diskBlkBuf                      ; 9342 8D 00 80                 ...
        jsr     WriteBuff                       ; 9345 20 3F 90                  ?.
        txa                                     ; 9348 8A                       .
        beq     ClearAndWrite                   ; 9349 F0 01                    ..
        rts                                     ; 934B 60                       `

; ----------------------------------------------------------------------------
ClearAndWrite:
        lda     r3H                             ; 934C A5 09                    ..
        sta     r1H                             ; 934E 85 05                    ..
        lda     r3L                             ; 9350 A5 08                    ..
        sta     r1L                             ; 9352 85 04                    ..
L9354:  lda     #$00                            ; 9354 A9 00                    ..
        tay                                     ; 9356 A8                       .
L9357:  sta     diskBlkBuf,y                    ; 9357 99 00 80                 ...
        iny                                     ; 935A C8                       .
        bne     L9357                           ; 935B D0 FA                    ..
        dey                                     ; 935D 88                       .
        sty     $8001                           ; 935E 8C 01 80                 ...
        jmp     WriteBuff                       ; 9361 4C 3F 90                 L?.

; ----------------------------------------------------------------------------
__SetNextFree:
        jsr     L936E                           ; 9364 20 6E 93                  n.
        bne     L936A                           ; 9367 D0 01                    ..
        rts                                     ; 9369 60                       `

; ----------------------------------------------------------------------------
L936A:  lda     #$27                            ; 936A A9 27                    .'
        sta     r3L                             ; 936C 85 08                    ..
L936E:  ldy     r3H                             ; 936E A4 09                    ..
        iny                                     ; 9370 C8                       .
        sty     r6H                             ; 9371 84 0F                    ..
        lda     r3L                             ; 9373 A5 08                    ..
        sta     r6L                             ; 9375 85 0E                    ..
        cmp     #$28                            ; 9377 C9 28                    .(
        beq     L9381                           ; 9379 F0 06                    ..
L937B:  lda     r6L                             ; 937B A5 0E                    ..
        cmp     #$28                            ; 937D C9 28                    .(
        beq     L93B2                           ; 937F F0 31                    .1
L9381:  cmp     #$29                            ; 9381 C9 29                    .)
        bcc     L9388                           ; 9383 90 03                    ..
        sec                                     ; 9385 38                       8
        sbc     #$28                            ; 9386 E9 28                    .(
L9388:  sec                                     ; 9388 38                       8
        sbc     #$01                            ; 9389 E9 01                    ..
        asl     a                               ; 938B 0A                       .
        sta     r7L                             ; 938C 85 10                    ..
        asl     a                               ; 938E 0A                       .
        clc                                     ; 938F 18                       .
        adc     r7L                             ; 9390 65 10                    e.
        tax                                     ; 9392 AA                       .
        lda     r6L                             ; 9393 A5 0E                    ..
        cmp     #$29                            ; 9395 C9 29                    .)
        bcc     L939F                           ; 9397 90 06                    ..
        lda     $9C90,x                         ; 9399 BD 90 9C                 ...
        clv                                     ; 939C B8                       .
        bvc     L93A2                           ; 939D 50 03                    P.
L939F:  lda     $8910,x                         ; 939F BD 10 89                 ...
L93A2:  beq     L93B2                           ; 93A2 F0 0E                    ..
        ldy     #$28                            ; 93A4 A0 28                    .(
        sty     r7L                             ; 93A6 84 10                    ..
L93A8:  jsr     SNxtFreeHelp                    ; 93A8 20 DA 93                  ..
        beq     L93CC                           ; 93AB F0 1F                    ..
        inc     r6H                             ; 93AD E6 0F                    ..
        dey                                     ; 93AF 88                       .
        bne     L93A8                           ; 93B0 D0 F6                    ..
L93B2:  ldy     r6L                             ; 93B2 A4 0E                    ..
        cpy     #$29                            ; 93B4 C0 29                    .)
        bcs     L93BF                           ; 93B6 B0 07                    ..
        dey                                     ; 93B8 88                       .
        bne     L93C4                           ; 93B9 D0 09                    ..
        ldy     #$29                            ; 93BB A0 29                    .)
        bne     L93C4                           ; 93BD D0 05                    ..
L93BF:  iny                                     ; 93BF C8                       .
        cpy     #$51                            ; 93C0 C0 51                    .Q
        bcs     L93D7                           ; 93C2 B0 13                    ..
L93C4:  sty     r6L                             ; 93C4 84 0E                    ..
        ldy     #$00                            ; 93C6 A0 00                    ..
        sty     r6H                             ; 93C8 84 0F                    ..
        beq     L937B                           ; 93CA F0 AF                    ..
L93CC:  lda     r6H                             ; 93CC A5 0F                    ..
        sta     r3H                             ; 93CE 85 09                    ..
        lda     r6L                             ; 93D0 A5 0E                    ..
        sta     r3L                             ; 93D2 85 08                    ..
        ldx     #$00                            ; 93D4 A2 00                    ..
        rts                                     ; 93D6 60                       `

; ----------------------------------------------------------------------------
L93D7:  ldx     #$03                            ; 93D7 A2 03                    ..
        rts                                     ; 93D9 60                       `

; ----------------------------------------------------------------------------
SNxtFreeHelp:
        lda     r6H                             ; 93DA A5 0F                    ..
L93DC:  cmp     r7L                             ; 93DC C5 10                    ..
        bcc     L93E6                           ; 93DE 90 06                    ..
        sec                                     ; 93E0 38                       8
        sbc     r7L                             ; 93E1 E5 10                    ..
        clv                                     ; 93E3 B8                       .
        bvc     L93DC                           ; 93E4 50 F6                    P.
L93E6:  sta     r6H                             ; 93E6 85 0F                    ..
_AllocateBlock:
        jsr     FindBAMBit                      ; 93E8 20 AD C2                  ..
        bne     L93F0                           ; 93EB D0 03                    ..
        ldx     #$06                            ; 93ED A2 06                    ..
        rts                                     ; 93EF 60                       `

; ----------------------------------------------------------------------------
L93F0:  php                                     ; 93F0 08                       .
        lda     r6L                             ; 93F1 A5 0E                    ..
        cmp     #$29                            ; 93F3 C9 29                    .)
        bcc     L9410                           ; 93F5 90 19                    ..
        lda     r8H                             ; 93F7 A5 13                    ..
        eor     $9C90,x                         ; 93F9 5D 90 9C                 ]..
        sta     $9C90,x                         ; 93FC 9D 90 9C                 ...
        ldx     r7H                             ; 93FF A6 11                    ..
        plp                                     ; 9401 28                       (
        beq     L940A                           ; 9402 F0 06                    ..
        dec     $9C90,x                         ; 9404 DE 90 9C                 ...
        ldx     #$00                            ; 9407 A2 00                    ..
        rts                                     ; 9409 60                       `

; ----------------------------------------------------------------------------
L940A:  inc     $9C90,x                         ; 940A FE 90 9C                 ...
        ldx     #$00                            ; 940D A2 00                    ..
        rts                                     ; 940F 60                       `

; ----------------------------------------------------------------------------
L9410:  lda     r8H                             ; 9410 A5 13                    ..
        eor     $8910,x                         ; 9412 5D 10 89                 ]..
        sta     $8910,x                         ; 9415 9D 10 89                 ...
        ldx     r7H                             ; 9418 A6 11                    ..
        plp                                     ; 941A 28                       (
        beq     L9423                           ; 941B F0 06                    ..
        dec     $8910,x                         ; 941D DE 10 89                 ...
        ldx     #$00                            ; 9420 A2 00                    ..
        rts                                     ; 9422 60                       `

; ----------------------------------------------------------------------------
L9423:  inc     $8910,x                         ; 9423 FE 10 89                 ...
        ldx     #$00                            ; 9426 A2 00                    ..
        rts                                     ; 9428 60                       `

; ----------------------------------------------------------------------------
__FreeBlock:
        jsr     FindBAMBit                      ; 9429 20 AD C2                  ..
        beq     L93F0                           ; 942C F0 C2                    ..
        ldx     #$06                            ; 942E A2 06                    ..
        rts                                     ; 9430 60                       `

; ----------------------------------------------------------------------------
__FindBAMBit:
        lda     r6H                             ; 9431 A5 0F                    ..
        and     #$07                            ; 9433 29 07                    ).
        tax                                     ; 9435 AA                       .
        lda     FBBBitTab,x                     ; 9436 BD 6B 94                 .k.
        sta     r8H                             ; 9439 85 13                    ..
        lda     r6L                             ; 943B A5 0E                    ..
        cmp     #$29                            ; 943D C9 29                    .)
        bcc     L9444                           ; 943F 90 03                    ..
        sec                                     ; 9441 38                       8
        sbc     #$28                            ; 9442 E9 28                    .(
L9444:  sec                                     ; 9444 38                       8
        sbc     #$01                            ; 9445 E9 01                    ..
        asl     a                               ; 9447 0A                       .
        sta     r7H                             ; 9448 85 11                    ..
        asl     a                               ; 944A 0A                       .
        clc                                     ; 944B 18                       .
        adc     r7H                             ; 944C 65 11                    e.
        sta     r7H                             ; 944E 85 11                    ..
        lda     r6H                             ; 9450 A5 0F                    ..
        lsr     a                               ; 9452 4A                       J
        lsr     a                               ; 9453 4A                       J
        lsr     a                               ; 9454 4A                       J
        sec                                     ; 9455 38                       8
        adc     r7H                             ; 9456 65 11                    e.
        tax                                     ; 9458 AA                       .
        lda     r6L                             ; 9459 A5 0E                    ..
        cmp     #$29                            ; 945B C9 29                    .)
        bcc     L9465                           ; 945D 90 06                    ..
        lda     $9C90,x                         ; 945F BD 90 9C                 ...
        and     r8H                             ; 9462 25 13                    %.
        rts                                     ; 9464 60                       `

; ----------------------------------------------------------------------------
L9465:  lda     $8910,x                         ; 9465 BD 10 89                 ...
        and     r8H                             ; 9468 25 13                    %.
        rts                                     ; 946A 60                       `

; ----------------------------------------------------------------------------
FBBBitTab:
        .byte   $01,$02,$04,$08,$10,$20,$40,$80 ; 946B 01 02 04 08 10 20 40 80  ..... @.
; ----------------------------------------------------------------------------
__CalcBlksFree:
        lda     #$00                            ; 9473 A9 00                    ..
        sta     r4L                             ; 9475 85 0A                    ..
        sta     r4H                             ; 9477 85 0B                    ..
        ldy     #$10                            ; 9479 A0 10                    ..
L947B:  lda     dir2Head,y                      ; 947B B9 00 89                 ...
        clc                                     ; 947E 18                       .
        adc     r4L                             ; 947F 65 0A                    e.
        sta     r4L                             ; 9481 85 0A                    ..
        bcc     L9487                           ; 9483 90 02                    ..
        inc     r4H                             ; 9485 E6 0B                    ..
L9487:  tya                                     ; 9487 98                       .
        clc                                     ; 9488 18                       .
        adc     #$06                            ; 9489 69 06                    i.
        tay                                     ; 948B A8                       .
        cpy     #$FA                            ; 948C C0 FA                    ..
        beq     L9487                           ; 948E F0 F7                    ..
        tay                                     ; 9490 A8                       .
        bne     L947B                           ; 9491 D0 E8                    ..
        ldy     #$10                            ; 9493 A0 10                    ..
L9495:  lda     $9C80,y                         ; 9495 B9 80 9C                 ...
        clc                                     ; 9498 18                       .
        adc     r4L                             ; 9499 65 0A                    e.
        sta     r4L                             ; 949B 85 0A                    ..
        bcc     L94A1                           ; 949D 90 02                    ..
        inc     r4H                             ; 949F E6 0B                    ..
L94A1:  tya                                     ; 94A1 98                       .
        clc                                     ; 94A2 18                       .
        adc     #$06                            ; 94A3 69 06                    i.
        tay                                     ; 94A5 A8                       .
        bne     L9495                           ; 94A6 D0 ED                    ..
        lda     #$0C                            ; 94A8 A9 0C                    ..
        sta     r3H                             ; 94AA 85 09                    ..
        lda     #$58                            ; 94AC A9 58                    .X
        sta     r3L                             ; 94AE 85 08                    ..
        rts                                     ; 94B0 60                       `

; ----------------------------------------------------------------------------
__SetGEOSDisk:
        jsr     GetDirHead                      ; 94B1 20 47 C2                  G.
        txa                                     ; 94B4 8A                       .
        bne     L94EE                           ; 94B5 D0 37                    .7
        lda     #$28                            ; 94B7 A9 28                    .(
        sta     r3L                             ; 94B9 85 08                    ..
        lda     #$12                            ; 94BB A9 12                    ..
        sta     r3H                             ; 94BD 85 09                    ..
        jsr     SetNextFree                     ; 94BF 20 92 C2                  ..
        txa                                     ; 94C2 8A                       .
        bne     L94EE                           ; 94C3 D0 29                    .)
        lda     r3H                             ; 94C5 A5 09                    ..
        sta     r1H                             ; 94C7 85 05                    ..
        lda     r3L                             ; 94C9 A5 08                    ..
        sta     r1L                             ; 94CB 85 04                    ..
        jsr     L9354                           ; 94CD 20 54 93                  T.
        txa                                     ; 94D0 8A                       .
        bne     L94EE                           ; 94D1 D0 1B                    ..
        lda     r1H                             ; 94D3 A5 05                    ..
        sta     $82AC                           ; 94D5 8D AC 82                 ...
        lda     r1L                             ; 94D8 A5 04                    ..
        sta     $82AB                           ; 94DA 8D AB 82                 ...
        ldy     #$BC                            ; 94DD A0 BC                    ..
        ldx     #$0F                            ; 94DF A2 0F                    ..
L94E1:  lda     GEOSDiskID,x                    ; 94E1 BD AB 92                 ...
        sta     curDirHead,y                    ; 94E4 99 00 82                 ...
        dey                                     ; 94E7 88                       .
        dex                                     ; 94E8 CA                       .
        bpl     L94E1                           ; 94E9 10 F6                    ..
        jmp     PutDirHead                      ; 94EB 4C 4A C2                 LJ.

; ----------------------------------------------------------------------------
L94EE:  rts                                     ; 94EE 60                       `

; ----------------------------------------------------------------------------
__InitForIO:
		sei
        php                                     ; 94EF 08                       .
        pla                                     ; 94F0 68                       h
        sta     L9BF0                           ; 94F1 8D F0 9B                 ...
        sei                                     ; 94F4 78                       x
        lda     CPU_DATA                        ; 94F5 A5 01                    ..
        sta     L9BF2                           ; 94F7 8D F2 9B                 ...
.if (!.defined(config128)) || .defined(mega65)
        lda     #$36                            ; 94FA A9 36                    .6
        sta     CPU_DATA                        ; 94FC 85 01                    ..
.endif
        lda     grirqen                         ; 94FE AD 1A D0                 ...
        sta     L9BF1                           ; 9501 8D F1 9B                 ...
        lda     clkreg                          ; 9504 AD 30 D0                 .0.
        sta     L9BEF                           ; 9507 8D EF 9B                 ...
        ldy     #$00                            ; 950A A0 00                    ..
        sty     clkreg                          ; 950C 8C 30 D0                 .0.
        sty     grirqen                         ; 950F 8C 1A D0                 ...
        lda     #$7F                            ; 9512 A9 7F                    ..
        sta     grirq                           ; 9514 8D 19 D0                 ...
        sta     $DC0D                           ; 9517 8D 0D DC                 ...
        sta     $DD0D                           ; 951A 8D 0D DD                 ...
.if .defined(config128) & (!.defined(mega65))
        lda     #>D_IRQHandler
        sta     $0315
        sta     $0319
        lda     #<D_IRQHandler
        sta     $0314
        sta     $0318
.else
        LoadW   $0314, D_IRQHandler
        LoadW   $0318, D_NMIHandler
.endif
        lda     #$3F                            ; 9531 A9 3F                    .?
        sta     $DD02                           ; 9533 8D 02 DD                 ...
        lda     mobenble                        ; 9536 AD 15 D0                 ...
        sta     L9BF3                           ; 9539 8D F3 9B                 ...
        sty     mobenble                        ; 953C 8C 15 D0                 ...
        sty     $DD05                           ; 953F 8C 05 DD                 ...
        iny                                     ; 9542 C8                       .
        sty     $DD04                           ; 9543 8C 04 DD                 ...
        lda     #$81                            ; 9546 A9 81                    ..
        sta     $DD0D                           ; 9548 8D 0D DD                 ...
        lda     #$09                            ; 954B A9 09                    ..
        sta     $DD0E                           ; 954D 8D 0E DD                 ...
        ldy     #$2C                            ; 9550 A0 2C                    .,
L9552:  lda     rasreg                          ; 9552 AD 12 D0                 ...
        cmp     TURBO_DD00_CPY                  ; 9555 C5 8F                    ..
        beq     L9552                           ; 9557 F0 F9                    ..
        sta     TURBO_DD00_CPY                  ; 9559 85 8F                    ..
        dey                                     ; 955B 88                       .
        bne     L9552                           ; 955C D0 F4                    ..
        lda     cia2base                        ; 955E AD 00 DD                 ...
        and     #$07                            ; 9561 29 07                    ).
        sta     TURBO_DD00                      ; 9563 85 8E                    ..
        sta     L9870                           ; 9565 8D 70 98                 .p.
        sta     L9877                           ; 9568 8D 77 98                 .w.
        ora     #$30                            ; 956B 09 30                    .0
        sta     TURBO_DD00_CPY                  ; 956D 85 8F                    ..
        sta     L985C                           ; 956F 8D 5C 98                 .\.
        lda     TURBO_DD00                      ; 9572 A5 8E                    ..
        ora     #$10                            ; 9574 09 10                    ..
        sta     L9BF9                           ; 9576 8D F9 9B                 ...
        sta     L9881                           ; 9579 8D 81 98                 ...
        ldy     #$1F                            ; 957C A0 1F                    ..
L957E:  lda     L982E,y                         ; 957E B9 2E 98                 ...
        and     #$F0                            ; 9581 29 F0                    ).
        ora     TURBO_DD00                      ; 9583 05 8E                    ..
        sta     L982E,y                         ; 9585 99 2E 98                 ...
        dey                                     ; 9588 88                       .
        bpl     L957E                           ; 9589 10 F3                    ..


        rts                                     ; 958B 60                       `

; ----------------------------------------------------------------------------
D_IRQHandler:
.if .defined(config128) & (!.defined(mega65))
        pla
        sta     $ff00
.endif
        pla                                     ; 958C 68                       h
        tay                                     ; 958D A8                       .
        pla                                     ; 958E 68                       h
        tax                                     ; 958F AA                       .
        pla                                     ; 9590 68                       h
D_NMIHandler:
        rti                                     ; 9591 40                       @

; ----------------------------------------------------------------------------
__DoneWithIO:
        sei                                     ; 9592 78                       x
        lda     L9BEF                           ; 9593 AD EF 9B                 ...
        sta     clkreg                          ; 9596 8D 30 D0                 .0.
        lda     L9BF3                           ; 9599 AD F3 9B                 ...
        sta     mobenble                        ; 959C 8D 15 D0                 ...
        lda     #$7F                            ; 959F A9 7F                    ..
        sta     $DD0D                           ; 95A1 8D 0D DD                 ...
        lda     $DD0D                           ; 95A4 AD 0D DD                 ...
        lda     L9BF1                           ; 95A7 AD F1 9B                 ...
        sta     grirqen                         ; 95AA 8D 1A D0                 ...

		lda	#$a5
		sta	$d02f
		lda #$96
		sta	$d02f
		
.if (!.defined(config128)) || .defined(mega65)
        lda     L9BF2                           ; 95AD AD F2 9B                 ...
        sta     CPU_DATA                        ; 95B0 85 01                    ..
.endif
        lda     L9BF0                           ; 95B2 AD F0 9B                 ...
        pha                                     ; 95B5 48                       H
        plp                                     ; 95B6 28                       (
        rts                                     ; 95B7 60                       `

; ----------------------------------------------------------------------------
SendDOSCmd:
        stx     $8C                             ; 95B8 86 8C                    ..
        sta     $8B                             ; 95BA 85 8B                    ..
        lda     #$00                            ; 95BC A9 00                    ..
        sta     STATUS                          ; 95BE 85 90                    ..
        lda     curDrive                        ; 95C0 AD 89 84                 ...
        jsr     LISTEN                          ; 95C3 20 B1 FF                  ..
        bit     STATUS                          ; 95C6 24 90                    $.
        bmi     L95E2                           ; 95C8 30 18                    0.
        lda     #$FF                            ; 95CA A9 FF                    ..
        jsr     SECOND                          ; 95CC 20 93 FF                  ..
        bit     STATUS                          ; 95CF 24 90                    $.
        bmi     L95E2                           ; 95D1 30 0F                    0.
        ldy     #$00                            ; 95D3 A0 00                    ..
L95D5:  lda     ($8B),y                         ; 95D5 B1 8B                    ..
        jsr     CIOUT                           ; 95D7 20 A8 FF                  ..
        iny                                     ; 95DA C8                       .
        cpy     #$05                            ; 95DB C0 05                    ..
        bcc     L95D5                           ; 95DD 90 F6                    ..
        ldx     #$00                            ; 95DF A2 00                    ..
        rts                                     ; 95E1 60                       `

; ----------------------------------------------------------------------------
L95E2:  jsr     UNLSN                           ; 95E2 20 AE FF                  ..
        ldx     #$0D                            ; 95E5 A2 0D                    ..
        rts                                     ; 95E7 60                       `

; ----------------------------------------------------------------------------
__EnterTurbo:
        lda     curDrive                        ; 95E8 AD 89 84                 ...
        jsr     SetDevice                       ; 95EB 20 B0 C2                  ..
        ldx     curDrive                        ; 95EE AE 89 84                 ...
        lda     diskOpenFlg,x                   ; 95F1 BD 8A 84                 ...
        bmi     L9604                           ; 95F4 30 0E                    0.
        jsr     SendCODE                        ; 95F6 20 69 96                  i.
        txa                                     ; 95F9 8A                       .
        bne     L963B                           ; 95FA D0 3F                    .?
        ldx     curDrive                        ; 95FC AE 89 84                 ...
        lda     #$80                            ; 95FF A9 80                    ..
        sta     diskOpenFlg,x                   ; 9601 9D 8A 84                 ...
L9604:  and     #$40                            ; 9604 29 40                    )@
        bne     L9634                           ; 9606 D0 2C                    .,
        jsr     InitForIO                       ; 9608 20 5C C2                  \.
        ldx     #>EnterCommand                            ; 960B A2 96                    ..
        lda     #<EnterCommand                            ; 960D A9 3D                    .=
        jsr     SendDOSCmd                      ; 960F 20 B8 95                  ..
        txa                                     ; 9612 8A                       .
        bne     L9638                           ; 9613 D0 23                    .#
        jsr     UNLSN                           ; 9615 20 AE FF                  ..
        sei                                     ; 9618 78                       x
        ldy     #$21                            ; 9619 A0 21                    .!
L961B:  dey                                     ; 961B 88                       .
        bne     L961B                           ; 961C D0 FD                    ..
        jsr     L9880                           ; 961E 20 80 98                  ..
L9621:  bit     cia2base                        ; 9621 2C 00 DD                 ,..
        bmi     L9621                           ; 9624 30 FB                    0.
        jsr     DoneWithIO                      ; 9626 20 5F C2                  _.
        ldx     curDrive                        ; 9629 AE 89 84                 ...
        lda     diskOpenFlg,x                   ; 962C BD 8A 84                 ...
        ora     #$40                            ; 962F 09 40                    .@
        sta     diskOpenFlg,x                   ; 9631 9D 8A 84                 ...
L9634:  ldx     #$00                            ; 9634 A2 00                    ..
        beq     L963B                           ; 9636 F0 03                    ..
L9638:  jsr     DoneWithIO                      ; 9638 20 5F C2                  _.
L963B:  txa                                     ; 963B 8A                       .
        rts                                     ; 963C 60                       `

; ----------------------------------------------------------------------------
EnterCommand:
        .byte   $4D,$2D,$45                     ; 963D 4D 2D 45                 M-E
; ----------------------------------------------------------------------------
        .word   $040F                           ; 9640 0F 04                    ..
; ----------------------------------------------------------------------------
SendExitTurbo:
        jsr     InitForIO                       ; 9642 20 5C C2                  \.
        ldx     #$04                            ; 9645 A2 04                    ..
        lda     #$B9                            ; 9647 A9 B9                    ..
        jsr     L979F                           ; 9649 20 9F 97                  ..
        ldx     #$04                            ; 964C A2 04                    ..
        lda     #$57                            ; 964E A9 57                    .W
        jsr     L979F                           ; 9650 20 9F 97                  ..
        jsr     L97D9                           ; 9653 20 D9 97                  ..
L9656:  lda     curDrive                        ; 9656 AD 89 84                 ...
        jsr     LISTEN                          ; 9659 20 B1 FF                  ..
        lda     #$EF                            ; 965C A9 EF                    ..
        jsr     SECOND                          ; 965E 20 93 FF                  ..
        jsr     UNLSN                           ; 9661 20 AE FF                  ..
        ldx     #$00                            ; 9664 A2 00                    ..
        jmp     DoneWithIO                      ; 9666 4C 5F C2                 L_.

; ----------------------------------------------------------------------------
SendCODE:
        jsr     CheckReal1581                   ; 9669 20 95 99                  ..
        txa                                     ; 966C 8A                       .
        beq     InitHDCode                      ; 966D F0 05                    ..
        bpl     L9673                           ; 966F 10 02                    ..
        bmi     Init1581Code                    ; 9671 30 1B                    0.
L9673:  rts                                     ; 9673 60                       `

; ----------------------------------------------------------------------------
InitHDCode:
        jsr     InitForIO                       ; 9674 20 5C C2                  \.
        ldx     #>HDCommand                            ; 9677 A2 96                    ..
        lda     #<HDCommand                            ; 9679 A9 89                    ..
        jsr     SendDOSCmd                      ; 967B 20 B8 95                  ..
        txa                                     ; 967E 8A                       .
        bne     L9686                           ; 967F D0 05                    ..
        jsr     UNLSN                           ; 9681 20 AE FF                  ..
        ldx     #$00                            ; 9684 A2 00                    ..
L9686:  jmp     DoneWithIO                      ; 9686 4C 5F C2                 L_.

; ----------------------------------------------------------------------------
HDCommand:
        .byte   "GEOS"                          ; 9689 47 45 4F 53              GEOS
        .byte   $00                             ; 968D 00                       .
; ----------------------------------------------------------------------------
Init1581Code:
        jsr     InitForIO                       ; 968E 20 5C C2                  \.
        LoadW   $8d, DriveCode2
        lda     #$03                            ; 9699 A9 03                    ..
        sta     L96F1+1                         ; 969B 8D F2 96                 ...
        lda     #$00                            ; 969E A9 00                    ..
        sta     L96F1                           ; 96A0 8D F1 96                 ...
        lda     #$0F                            ; 96A3 A9 0F                    ..
        sta     TURBO_DD00_CPY                  ; 96A5 85 8F                    ..
L96A7:  jsr     SendCHUNK                       ; 96A7 20 CD 96                  ..
        txa                                     ; 96AA 8A                       .
        bne     L96CA                           ; 96AB D0 1D                    ..
        clc                                     ; 96AD 18                       .
        lda     #$20                            ; 96AE A9 20                    . 
        adc     $8D                             ; 96B0 65 8D                    e.
        sta     $8D                             ; 96B2 85 8D                    ..
        bcc     L96B8                           ; 96B4 90 02                    ..
        inc     TURBO_DD00                      ; 96B6 E6 8E                    ..
L96B8:  clc                                     ; 96B8 18                       .
        lda     #$20                            ; 96B9 A9 20                    . 
        adc     L96F1                           ; 96BB 6D F1 96                 m..
        sta     L96F1                           ; 96BE 8D F1 96                 ...
        bcc     L96C6                           ; 96C1 90 03                    ..
        inc     L96F1+1                         ; 96C3 EE F2 96                 ...
L96C6:  dec     TURBO_DD00_CPY                  ; 96C6 C6 8F                    ..
        bpl     L96A7                           ; 96C8 10 DD                    ..
L96CA:  jmp     DoneWithIO                      ; 96CA 4C 5F C2                 L_.

; ----------------------------------------------------------------------------
SendCHUNK:
        ldx     #>WriteCommand                            ; 96CD A2 96                    ..
        lda     #<WriteCommand                            ; 96CF A9 EE                    ..
        jsr     SendDOSCmd                      ; 96D1 20 B8 95                  ..
        txa                                     ; 96D4 8A                       .
        bne     L96ED                           ; 96D5 D0 16                    ..
        lda     #$20                            ; 96D7 A9 20                    . 
        jsr     CIOUT                           ; 96D9 20 A8 FF                  ..
        ldy     #$00                            ; 96DC A0 00                    ..
L96DE:  lda     ($8D),y                         ; 96DE B1 8D                    ..
        jsr     CIOUT                           ; 96E0 20 A8 FF                  ..
        iny                                     ; 96E3 C8                       .
        cpy     #$20                            ; 96E4 C0 20                    . 
        bcc     L96DE                           ; 96E6 90 F6                    ..
        jsr     UNLSN                           ; 96E8 20 AE FF                  ..
        ldx     #$00                            ; 96EB A2 00                    ..
L96ED:  rts                                     ; 96ED 60                       `

; ----------------------------------------------------------------------------
WriteCommand:
        .byte   "M-W"                           ; 96EE 4D 2D 57                 M-W
; ----------------------------------------------------------------------------
L96F1:  .word   $0000                           ; 96F1 00 00                    ..
; ----------------------------------------------------------------------------
__ExitTurbo:
        txa                                     ; 96F3 8A                       .
        pha                                     ; 96F4 48                       H
        ldx     curDrive                        ; 96F5 AE 89 84                 ...
        lda     diskOpenFlg,x                   ; 96F8 BD 8A 84                 ...
        and     #$40                            ; 96FB 29 40                    )@
        beq     L975D                           ; 96FD F0 5E                    .^
        jsr     SendExitTurbo                   ; 96FF 20 42 96                  B.
        ldx     curDrive                        ; 9702 AE 89 84                 ...
        lda     diskOpenFlg,x                   ; 9705 BD 8A 84                 ...
        and     #$BF                            ; 9708 29 BF                    ).
        sta     diskOpenFlg,x                   ; 970A 9D 8A 84                 ...
        bit     sysRAMFlg                       ; 970D 2C C4 88                 ,..
        bvc     L975D                           ; 9710 50 4B                    PK
        lda     r0H                             ; 9712 A5 03                    ..
        pha                                     ; 9714 48                       H
        lda     r0L                             ; 9715 A5 02                    ..
        pha                                     ; 9717 48                       H
        lda     r1H                             ; 9718 A5 05                    ..
        pha                                     ; 971A 48                       H
        lda     r1L                             ; 971B A5 04                    ..
        pha                                     ; 971D 48                       H
        lda     r2H                             ; 971E A5 07                    ..
        pha                                     ; 9720 48                       H
        lda     r2L                             ; 9721 A5 06                    ..
        pha                                     ; 9723 48                       H
        lda     r3L                             ; 9724 A5 08                    ..
        pha                                     ; 9726 48                       H
        ldx     curDrive                        ; 9727 AE 89 84                 ...
        lda     L9758,x                         ; 972A BD 58 97                 .X.
        sta     r1L                             ; 972D 85 04                    ..
        lda     L975C,x                         ; 972F BD 5C 97                 .\.
        sta     r1H                             ; 9732 85 05                    ..
        lda     #$9C                            ; 9734 A9 9C                    ..
        sta     r0H                             ; 9736 85 03                    ..
        lda     #$80                            ; 9738 A9 80                    ..
        sta     r0L                             ; 973A 85 02                    ..
        ldy     #$00                            ; 973C A0 00                    ..
        sty     r3L                             ; 973E 84 08                    ..
        sty     r2L                             ; 9740 84 06                    ..
        iny                                     ; 9742 C8                       .
        sty     r2H                             ; 9743 84 07                    ..
        jsr     StashRAM                        ; 9745 20 C8 C2                  ..
        pla                                     ; 9748 68                       h
        sta     r3L                             ; 9749 85 08                    ..
        pla                                     ; 974B 68                       h
        sta     r2L                             ; 974C 85 06                    ..
        pla                                     ; 974E 68                       h
        sta     r2H                             ; 974F 85 07                    ..
        pla                                     ; 9751 68                       h
        sta     r1L                             ; 9752 85 04                    ..
        pla                                     ; 9754 68                       h
        sta     r1H                             ; 9755 85 05                    ..
        pla                                     ; 9757 68                       h
L9758:  sta     r0L                             ; 9758 85 02                    ..
        pla                                     ; 975A 68                       h
        .byte   $85                             ; 975B 85                       .
L975C:  .byte   $03                             ; 975C 03                       .
L975D:  pla                                     ; 975D 68                       h
        tax                                     ; 975E AA                       .
        rts                                     ; 975F 60                       `

; ----------------------------------------------------------------------------
        .byte   $80,$00,$80,$00,$8F,$9D,$AA,$B8 ; 9760 80 00 80 00 8F 9D AA B8  ........
; ----------------------------------------------------------------------------
__PurgeTurbo:
        jsr     ExitTurbo                       ; 9768 20 32 C2                  2.
        ldy     curDrive                        ; 976B AC 89 84                 ...
        lda     #$00                            ; 976E A9 00                    ..
        sta     diskOpenFlg,y                   ; 9770 99 8A 84                 ...
        rts                                     ; 9773 60                       `

; ----------------------------------------------------------------------------
__ChangeDiskDevice:
        sta     ChngDskDev_Number               ; 9774 8D 9D 97                 ...
        jsr     PurgeTurbo                      ; 9777 20 35 C2                  5.
        jsr     InitForIO                       ; 977A 20 5C C2                  \.
        ldx     #>ChngDskDev_Command                            ; 977D A2 97                    ..
        lda     #<ChngDskDev_Command                            ; 977F A9 9A                    ..
        jsr     SendDOSCmd                      ; 9781 20 B8 95                  ..
        txa                                     ; 9784 8A                       .
        bne     L9797                           ; 9785 D0 10                    ..
        ldy     ChngDskDev_Number               ; 9787 AC 9D 97                 ...
        lda     #$00                            ; 978A A9 00                    ..
        sta     diskOpenFlg,y                   ; 978C 99 8A 84                 ...
        sty     curDrive                        ; 978F 8C 89 84                 ...
        sty     curDevice                       ; 9792 84 BA                    ..
        jmp     L9656                           ; 9794 4C 56 96                 LV.

; ----------------------------------------------------------------------------
L9797:  jmp     DoneWithIO                      ; 9797 4C 5F C2                 L_.

; ----------------------------------------------------------------------------
ChngDskDev_Command:
        .byte   "U0>"                           ; 979A 55 30 3E                 U0>
; ----------------------------------------------------------------------------
ChngDskDev_Number:
        .byte   $08,$00                         ; 979D 08 00                    ..
; ----------------------------------------------------------------------------
L979F:  stx     $8C                             ; 979F 86 8C                    ..
        sta     $8B                             ; 97A1 85 8B                    ..
        ldy     #$02                            ; 97A3 A0 02                    ..
        bne     L97B7                           ; 97A5 D0 10                    ..
L97A7:  stx     $8C                             ; 97A7 86 8C                    ..
        sta     $8B                             ; 97A9 85 8B                    ..
DUNK4_2:ldy     #$04                            ; 97AB A0 04                    ..
        lda     r1H                             ; 97AD A5 05                    ..
        sta     L9BF8                           ; 97AF 8D F8 9B                 ...
        lda     r1L                             ; 97B2 A5 04                    ..
        sta     L9BF7                           ; 97B4 8D F7 9B                 ...
L97B7:  lda     $8C                             ; 97B7 A5 8C                    ..
        sta     L9BF6                           ; 97B9 8D F6 9B                 ...
        lda     $8B                             ; 97BC A5 8B                    ..
        sta     L9BF5                           ; 97BE 8D F5 9B                 ...
        lda     #>L9BF5                            ; 97C1 A9 9B                    ..
        sta     $8C                             ; 97C3 85 8C                    ..
        lda     #<L9BF5                            ; 97C5 A9 F5                    ..
        sta     $8B                             ; 97C7 85 8B                    ..
        jmp     L9886                           ; 97C9 4C 86 98                 L..

; ----------------------------------------------------------------------------
L97CC:  ldy     #$01                            ; 97CC A0 01                    ..
        jsr     L984E                           ; 97CE 20 4E 98                  N.
        pha                                     ; 97D1 48                       H
        tay                                     ; 97D2 A8                       .
        jsr     L984E                           ; 97D3 20 4E 98                  N.
        pla                                     ; 97D6 68                       h
        tay                                     ; 97D7 A8                       .
        rts                                     ; 97D8 60                       `

; ----------------------------------------------------------------------------
L97D9:  sei                                     ; 97D9 78                       x
        lda     TURBO_DD00                      ; 97DA A5 8E                    ..
        sta     cia2base                        ; 97DC 8D 00 DD                 ...
L97DF:  bit     cia2base                        ; 97DF 2C 00 DD                 ,..
        bpl     L97DF                           ; 97E2 10 FB                    ..
        rts                                     ; 97E4 60                       `

; ----------------------------------------------------------------------------
__NewDisk:
        jsr     EnterTurbo                      ; 97E5 20 14 C2                  ..
        bne     L980D                           ; 97E8 D0 23                    .#
        lda     #$00                            ; 97EA A9 00                    ..
        sta     L9BFC                           ; 97EC 8D FC 9B                 ...
        sta     r1L                             ; 97EF 85 04                    ..
        jsr     InitForIO                       ; 97F1 20 5C C2                  \.
L97F4:  ldx     #$04                            ; 97F4 A2 04                    ..
        lda     #$9B                            ; 97F6 A9 9B                    ..
        jsr     L97A7                           ; 97F8 20 A7 97                  ..
        jsr     GetDOSError                     ; 97FB 20 6C 99                  l.
        beq     L980A                           ; 97FE F0 0A                    ..
        inc     L9BFC                           ; 9800 EE FC 9B                 ...
        cpy     L9BFC                           ; 9803 CC FC 9B                 ...
        beq     L980A                           ; 9806 F0 02                    ..
        bcs     L97F4                           ; 9808 B0 EA                    ..
L980A:  jsr     DoneWithIO                      ; 980A 20 5F C2                  _.
L980D:  rts                                     ; 980D 60                       `

; ----------------------------------------------------------------------------
_ReadLink:
        jsr     CheckParams_1                   ; 980E 20 03 91                  ..
        bcc     L9822                           ; 9811 90 0F                    ..
        lda     r1L                             ; 9813 A5 04                    ..
        ora     #$80                            ; 9815 09 80                    ..
        sta     r1L                             ; 9817 85 04                    ..
        jsr     L98DB                           ; 9819 20 DB 98                  ..
        lda     r1L                             ; 981C A5 04                    ..
        and     #$7F                            ; 981E 29 7F                    ).
        sta     r1L                             ; 9820 85 04                    ..
L9822:  rts                                     ; 9822 60                       `

; ----------------------------------------------------------------------------
DOSErrTab:
        .byte   $01,$05,$02,$08,$08,$01,$05,$01 ; 9823 01 05 02 08 08 01 05 01  ........
        .byte   $05,$05,$05                     ; 982B 05 05 05                 ...
L982E:  .byte   $00,$80,$20,$A0,$40,$C0,$60,$E0 ; 982E 00 80 20 A0 40 C0 60 E0  .. .@.`.
        .byte   $10,$90,$30,$B0,$50,$D0,$70,$F0 ; 9836 10 90 30 B0 50 D0 70 F0  ..0.P.p.
L983E:  .byte   $00,$20,$00,$20,$10,$30,$10,$30 ; 983E 00 20 00 20 10 30 10 30  . . .0.0
        .byte   $00,$20,$00,$20,$10,$30,$10,$30 ; 9846 00 20 00 20 10 30 10 30  . . .0.0
; ----------------------------------------------------------------------------
L984E:  jsr     L97D9                           ; 984E 20 D9 97                  ..
L9851:  sec                                     ; 9851 38                       8
L9852:  lda     rasreg                          ; 9852 AD 12 D0                 ...
        sbc     #$32                            ; 9855 E9 32                    .2
        and     #$07                            ; 9857 29 07                    ).
        beq     L9852                           ; 9859 F0 F7                    ..
        .byte   $A9                             ; 985B A9                       .
L985C:  and     $8D,x                           ; 985C 35 8D                    5.
        brk                                     ; 985E 00                       .
        cmp     $0F29,x                         ; 985F DD 29 0F                 .).
        sta     cia2base                        ; 9862 8D 00 DD                 ...
        lda     cia2base                        ; 9865 AD 00 DD                 ...
        lsr     a                               ; 9868 4A                       J
        lsr     a                               ; 9869 4A                       J
        ora     cia2base                        ; 986A 0D 00 DD                 ...
        lsr     a                               ; 986D 4A                       J
        lsr     a                               ; 986E 4A                       J
        .byte   $49                             ; 986F 49                       I
L9870:  ora     $4D                             ; 9870 05 4D                    .M
        brk                                     ; 9872 00                       .
        cmp     $4A4A,x                         ; 9873 DD 4A 4A                 .JJ
        .byte   $49                             ; 9876 49                       I
L9877:  ora     $4D                             ; 9877 05 4D                    .M
        brk                                     ; 9879 00                       .
        cmp     L9188,x                         ; 987A DD 88 91                 ...
        .byte   $8B                             ; 987D 8B                       .
        bne     L9851                           ; 987E D0 D1                    ..
L9880:  .byte   $A2                             ; 9880 A2                       .
L9881:  .byte   $0F                             ; 9881 0F                       .
        stx     cia2base                        ; 9882 8E 00 DD                 ...
        rts                                     ; 9885 60                       `

; ----------------------------------------------------------------------------
L9886:  jsr     L97D9                           ; 9886 20 D9 97                  ..
        tya                                     ; 9889 98                       .
        pha                                     ; 988A 48                       H
        ldy     #$00                            ; 988B A0 00                    ..
        jsr     L989D                           ; 988D 20 9D 98                  ..
        pla                                     ; 9890 68                       h
        tay                                     ; 9891 A8                       .
L9892:  jsr     L97D9                           ; 9892 20 D9 97                  ..
L9895:  dey                                     ; 9895 88                       .
        lda     ($8B),y                         ; 9896 B1 8B                    ..
        ldx     TURBO_DD00                      ; 9898 A6 8E                    ..
        stx     cia2base                        ; 989A 8E 00 DD                 ...
L989D:  tax                                     ; 989D AA                       .
        and     #$0F                            ; 989E 29 0F                    ).
        sta     $8D                             ; 98A0 85 8D                    ..
        sec                                     ; 98A2 38                       8
L98A3:  lda     rasreg                          ; 98A3 AD 12 D0                 ...
        sbc     #$32                            ; 98A6 E9 32                    .2
        and     #$07                            ; 98A8 29 07                    ).
        beq     L98A3                           ; 98AA F0 F7                    ..
        txa                                     ; 98AC 8A                       .
        ldx     TURBO_DD00_CPY                  ; 98AD A6 8F                    ..
        stx     cia2base                        ; 98AF 8E 00 DD                 ...
        and     #$F0                            ; 98B2 29 F0                    ).
        ora     TURBO_DD00                      ; 98B4 05 8E                    ..
        sta     cia2base                        ; 98B6 8D 00 DD                 ...
        ror     a                               ; 98B9 6A                       j
        ror     a                               ; 98BA 6A                       j
        and     #$F0                            ; 98BB 29 F0                    ).
        ora     TURBO_DD00                      ; 98BD 05 8E                    ..
        sta     cia2base                        ; 98BF 8D 00 DD                 ...
        ldx     $8D                             ; 98C2 A6 8D                    ..
        lda     L982E,x                         ; 98C4 BD 2E 98                 ...
        sta     cia2base                        ; 98C7 8D 00 DD                 ...
        lda     L983E,x                         ; 98CA BD 3E 98                 .>.
        cpy     #$00                            ; 98CD C0 00                    ..
        sta     cia2base                        ; 98CF 8D 00 DD                 ...
        bne     L9895                           ; 98D2 D0 C1                    ..
        beq     L9880                           ; 98D4 F0 AA                    ..
__ReadBlock:
        jsr     CheckParams_1                   ; 98D6 20 03 91                  ..
        bcc     L9937                           ; 98D9 90 5C                    .\
L98DB:  ldx     #$04                            ; 98DB A2 04                    ..
        lda     #$CC                            ; 98DD A9 CC                    ..
        jsr     L97A7                           ; 98DF 20 A7 97                  ..
        ldx     #$03                            ; 98E2 A2 03                    ..
        lda     #$1F                            ; 98E4 A9 1F                    ..
        jsr     L979F                           ; 98E6 20 9F 97                  ..
        lda     r4H                             ; 98E9 A5 0B                    ..
        sta     $8C                             ; 98EB 85 8C                    ..
        lda     r4L                             ; 98ED A5 0A                    ..
        sta     $8B                             ; 98EF 85 8B                    ..
        ldy     #$00                            ; 98F1 A0 00                    ..
        lda     r1L                             ; 98F3 A5 04                    ..
        bpl     L98F9                           ; 98F5 10 02                    ..
        ldy     #$02                            ; 98F7 A0 02                    ..
L98F9:  jsr     L984E                           ; 98F9 20 4E 98                  N.
        jsr     L9973                           ; 98FC 20 73 99                  s.
        beq     L990B                           ; 98FF F0 0A                    ..
        inc     L9BFC                           ; 9901 EE FC 9B                 ...
        cpy     L9BFC                           ; 9904 CC FC 9B                 ...
        beq     L990B                           ; 9907 F0 02                    ..
        bcs     L98DB                           ; 9909 B0 D0                    ..
L990B:  lda     r1L                             ; 990B A5 04                    ..
        cmp     #$28                            ; 990D C9 28                    .(
        bne     L9936                           ; 990F D0 25                    .%
        lda     r1H                             ; 9911 A5 05                    ..
        bne     L9936                           ; 9913 D0 21                    .!
        ldy     #$04                            ; 9915 A0 04                    ..
L9917:  lda     (r4L),y                         ; 9917 B1 0A                    ..
        sta     L9BFB                           ; 9919 8D FB 9B                 ...
        tya                                     ; 991C 98                       .
        clc                                     ; 991D 18                       .
        adc     #$8C                            ; 991E 69 8C                    i.
        tay                                     ; 9920 A8                       .
        lda     (r4L),y                         ; 9921 B1 0A                    ..
        pha                                     ; 9923 48                       H
        lda     L9BFB                           ; 9924 AD FB 9B                 ...
        sta     (r4L),y                         ; 9927 91 0A                    ..
        tya                                     ; 9929 98                       .
        sec                                     ; 992A 38                       8
        sbc     #$8C                            ; 992B E9 8C                    ..
        tay                                     ; 992D A8                       .
        pla                                     ; 992E 68                       h
        sta     (r4L),y                         ; 992F 91 0A                    ..
        iny                                     ; 9931 C8                       .
        cpy     #$1D                            ; 9932 C0 1D                    ..
        bne     L9917                           ; 9934 D0 E1                    ..
L9936:  txa                                     ; 9936 8A                       .
L9937:  ldy     #$00                            ; 9937 A0 00                    ..
        rts                                     ; 9939 60                       `

; ----------------------------------------------------------------------------
__WriteBlock:
        jsr     CheckParams_1                   ; 993A 20 03 91                  ..
        bcc     L9968                           ; 993D 90 29                    .)
        jsr     L990B                           ; 993F 20 0B 99                  ..
L9942:  ldx     #$04                            ; 9942 A2 04                    ..
        lda     #$7C                            ; 9944 A9 7C                    .|
        jsr     L97A7                           ; 9946 20 A7 97                  ..
        lda     r4H                             ; 9949 A5 0B                    ..
        sta     $8C                             ; 994B 85 8C                    ..
        lda     r4L                             ; 994D A5 0A                    ..
        sta     $8B                             ; 994F 85 8B                    ..
        ldy     #$00                            ; 9951 A0 00                    ..
        jsr     L9892                           ; 9953 20 92 98                  ..
        jsr     L9973                           ; 9956 20 73 99                  s.
        beq     L9965                           ; 9959 F0 0A                    ..
        inc     L9BFC                           ; 995B EE FC 9B                 ...
        cpy     L9BFC                           ; 995E CC FC 9B                 ...
        beq     L9965                           ; 9961 F0 02                    ..
        bcs     L9942                           ; 9963 B0 DD                    ..
L9965:  jsr     L990B                           ; 9965 20 0B 99                  ..
L9968:  rts                                     ; 9968 60                       `

; ----------------------------------------------------------------------------
__VerWriteBlock:
        ldx     #$00                            ; 9969 A2 00                    ..
        rts                                     ; 996B 60                       `

; ----------------------------------------------------------------------------
GetDOSError:
        ldx     #$03                            ; 996C A2 03                    ..
        lda     #$2B                            ; 996E A9 2B                    .+
        jsr     L979F                           ; 9970 20 9F 97                  ..
L9973:  LoadW   $8b, L9BFD
        jsr     L97CC                           ; 997B 20 CC 97                  ..
        lda     L9BFD                           ; 997E AD FD 9B                 ...
        pha                                     ; 9981 48                       H
        tay                                     ; 9982 A8                       .
        lda     L9822,y                         ; 9983 B9 22 98                 .".
        tay                                     ; 9986 A8                       .
        pla                                     ; 9987 68                       h
        cmp     #$02                            ; 9988 C9 02                    ..
        bcc     L9991                           ; 998A 90 05                    ..
        clc                                     ; 998C 18                       .
        adc     #$1E                            ; 998D 69 1E                    i.
        bne     L9993                           ; 998F D0 02                    ..
L9991:  lda     #$00                            ; 9991 A9 00                    ..
L9993:  tax                                     ; 9993 AA                       .
        rts                                     ; 9994 60                       `

; ----------------------------------------------------------------------------
CheckReal1581:
        jsr     InitForIO                       ; 9995 20 5C C2                  \.
        lda     #$00                            ; 9998 A9 00                    ..
        sta     STATUS                          ; 999A 85 90                    ..
        LoadW   $8d, L9BFF
        lda     #$FE                            ; 99A4 A9 FE                    ..
        sta     L9A00+1                         ; 99A6 8D 01 9A                 ...
        lda     #$A0                            ; 99A9 A9 A0                    ..
        sta     L9A00                           ; 99AB 8D 00 9A                 ...
        jsr     ReadDeviceWord                  ; 99AE 20 CE 99                  ..
        txa                                     ; 99B1 8A                       .
        bne     L99CA                           ; 99B2 D0 16                    ..
        lda     L9BFF                           ; 99B4 AD FF 9B                 ...
        cmp     #$43                            ; 99B7 C9 43                    .C
        bne     L99C8                           ; 99B9 D0 0D                    ..
        lda     L9C00                           ; 99BB AD 00 9C                 ...
        cmp     #$4D                            ; 99BE C9 4D                    .M
        bne     L99C8                           ; 99C0 D0 06                    ..
        ldx     #$00                            ; 99C2 A2 00                    ..
        jsr     DoneWithIO                      ; 99C4 20 5F C2                  _.
        rts                                     ; 99C7 60                       `

; ----------------------------------------------------------------------------
L99C8:  ldx     #$FF                            ; 99C8 A2 FF                    ..
L99CA:  jsr     DoneWithIO                      ; 99CA 20 5F C2                  _.
        rts                                     ; 99CD 60                       `

; ----------------------------------------------------------------------------
ReadDeviceWord:
        ldx     #>MemReadCommand                            ; 99CE A2 99                    ..
        lda     #<MemReadCommand                            ; 99D0 A9 FD                    ..
        jsr     SendDOSCmd                      ; 99D2 20 B8 95                  ..
        txa                                     ; 99D5 8A                       .
        bne     L99FC                           ; 99D6 D0 24                    .$
        lda     #$02                            ; 99D8 A9 02                    ..
        jsr     CIOUT                           ; 99DA 20 A8 FF                  ..
        jsr     UNLSN                           ; 99DD 20 AE FF                  ..
        lda     curDrive                        ; 99E0 AD 89 84                 ...
        jsr     TALK                            ; 99E3 20 B4 FF                  ..
        lda     #$FF                            ; 99E6 A9 FF                    ..
        jsr     TKSA                            ; 99E8 20 96 FF                  ..
        ldy     #$00                            ; 99EB A0 00                    ..
L99ED:  jsr     ACPTR                           ; 99ED 20 A5 FF                  ..
        sta     ($8D),y                         ; 99F0 91 8D                    ..
        iny                                     ; 99F2 C8                       .
        cpy     #$02                            ; 99F3 C0 02                    ..
        bcc     L99ED                           ; 99F5 90 F6                    ..
        jsr     UNTLK                           ; 99F7 20 AB FF                  ..
        ldx     #$00                            ; 99FA A2 00                    ..
L99FC:  rts                                     ; 99FC 60                       `

; ----------------------------------------------------------------------------
MemReadCommand:
        eor     $522D                           ; 99FD 4D 2D 52                 M-R
L9A00:  .byte   $00                             ; 9A00 00                       .
        .byte   $00                             ; 9A01 00                       .

DriveCode2:
; End of "record4" segment
; ----------------------------------------------------------------------------
.code


.segment        "drv1581_21hd_drivecode": absolute

DriveCode:
        .byte   $0F,$07,$0D,$05,$0B,$03,$09,$01 ; 9A02 0F 07 0D 05 0B 03 09 01  ........
        .byte   $0E,$06,$0C,$04,$0A,$02,$08,$00 ; 9A0A 0E 06 0C 04 0A 02 08 00  ........
        .byte   $80,$20,$A0,$40,$C0,$60,$E0,$10 ; 9A12 80 20 A0 40 C0 60 E0 10  . .@.`..
        .byte   $90,$30,$B0,$50,$D0,$70,$F0     ; 9A1A 90 30 B0 50 D0 70 F0     .0.P.p.
; ----------------------------------------------------------------------------
        ldy     #$00                            ; 9A21 A0 00                    ..
        lda     $04EB                           ; 9A23 AD EB 04                 ...
        bpl     L9A2A                           ; 9A26 10 02                    ..
        ldy     #$02                            ; 9A28 A0 02                    ..
L9A2A:  jsr     L0362                           ; 9A2A 20 62 03                  b.
        lda     #$05                            ; 9A2D A9 05                    ..
        sta     a9L                             ; 9A2F 85 7E                    .~
        ldy     #$00                            ; 9A31 A0 00                    ..
        sty     a9H                             ; 9A33 84 7F                    ..
        iny                                     ; 9A35 C8                       .
        jsr     L0354                           ; 9A36 20 54 03                  T.
        jsr     L046A                           ; 9A39 20 6A 04                  j.
        cli                                     ; 9A3C 58                       X
L9A3D:  lda     $04E8                           ; 9A3D AD E8 04                 ...
        beq     L9A4D                           ; 9A40 F0 0B                    ..
        dex                                     ; 9A42 CA                       .
        bne     L9A4D                           ; 9A43 D0 08                    ..
        dec     $04E8                           ; 9A45 CE E8 04                 ...
        bne     L9A4D                           ; 9A48 D0 03                    ..
        jsr     L04BE                           ; 9A4A 20 BE 04                  ..
L9A4D:  lda     #$04                            ; 9A4D A9 04                    ..
        bit     $4001                           ; 9A4F 2C 01 40                 ,.@
        bne     L9A3D                           ; 9A52 D0 E9                    ..
        sei                                     ; 9A54 78                       x
        rts                                     ; 9A55 60                       `

; ----------------------------------------------------------------------------
        sty     $42                             ; 9A56 84 42                    .B
        ldy     #$00                            ; 9A58 A0 00                    ..
        jsr     L0402                           ; 9A5A 20 02 04                  ..
        lda     $42                             ; 9A5D A5 42                    .B
        jsr     L0368                           ; 9A5F 20 68 03                  h.
        ldy     $42                             ; 9A62 A4 42                    .B
        jsr     L0402                           ; 9A64 20 02 04                  ..
L9A67:  dey                                     ; 9A67 88                       .
        lda     (a9L),y                         ; 9A68 B1 7E                    .~
        sta     $41                             ; 9A6A 85 41                    .A
        and     #$0F                            ; 9A6C 29 0F                    ).
        tax                                     ; 9A6E AA                       .
        lda     #$04                            ; 9A6F A9 04                    ..
        sta     $4001                           ; 9A71 8D 01 40                 ..@
L9A74:  bit     $4001                           ; 9A74 2C 01 40                 ,.@
        beq     L9A74                           ; 9A77 F0 FB                    ..
        lda     $0300,x                         ; 9A79 BD 00 03                 ...
        sta     $4001                           ; 9A7C 8D 01 40                 ..@
        nop                                     ; 9A7F EA                       .
        nop                                     ; 9A80 EA                       .
        ldx     $41                             ; 9A81 A6 41                    .A
        rol     a                               ; 9A83 2A                       *
        and     #$0F                            ; 9A84 29 0F                    ).
        sta     $4001                           ; 9A86 8D 01 40                 ..@
        txa                                     ; 9A89 8A                       .
        lsr     a                               ; 9A8A 4A                       J
        lsr     a                               ; 9A8B 4A                       J
        lsr     a                               ; 9A8C 4A                       J
        lsr     a                               ; 9A8D 4A                       J
        tax                                     ; 9A8E AA                       .
        lda     $0300,x                         ; 9A8F BD 00 03                 ...
        sta     $4001                           ; 9A92 8D 01 40                 ..@
        nop                                     ; 9A95 EA                       .
        nop                                     ; 9A96 EA                       .
        nop                                     ; 9A97 EA                       .
        nop                                     ; 9A98 EA                       .
        rol     a                               ; 9A99 2A                       *
        and     #$0F                            ; 9A9A 29 0F                    ).
        cpy     #$00                            ; 9A9C C0 00                    ..
        sta     $4001                           ; 9A9E 8D 01 40                 ..@
        bne     L9A67                           ; 9AA1 D0 C4                    ..
        jsr     L03FE                           ; 9AA3 20 FE 03                  ..
        beq     L9AEF                           ; 9AA6 F0 47                    .G
        nop                                     ; 9AA8 EA                       .
        nop                                     ; 9AA9 EA                       .
        nop                                     ; 9AAA EA                       .
        nop                                     ; 9AAB EA                       .
        nop                                     ; 9AAC EA                       .
        nop                                     ; 9AAD EA                       .
        nop                                     ; 9AAE EA                       .
        jsr     L0402                           ; 9AAF 20 02 04                  ..
        jsr     L03FB                           ; 9AB2 20 FB 03                  ..
        lda     #$00                            ; 9AB5 A9 00                    ..
        sta     $41                             ; 9AB7 85 41                    .A
L9AB9:  eor     $41                             ; 9AB9 45 41                    EA
        sta     $41                             ; 9ABB 85 41                    .A
        jsr     L03FC                           ; 9ABD 20 FC 03                  ..
        lda     #$04                            ; 9AC0 A9 04                    ..
L9AC2:  bit     $4001                           ; 9AC2 2C 01 40                 ,.@
        beq     L9AC2                           ; 9AC5 F0 FB                    ..
        jsr     L03FD                           ; 9AC7 20 FD 03                  ..
        lda     $4001                           ; 9ACA AD 01 40                 ..@
        jsr     L03FC                           ; 9ACD 20 FC 03                  ..
        asl     a                               ; 9AD0 0A                       .
        ora     $4001                           ; 9AD1 0D 01 40                 ..@
        php                                     ; 9AD4 08                       .
        plp                                     ; 9AD5 28                       (
        nop                                     ; 9AD6 EA                       .
        nop                                     ; 9AD7 EA                       .
        and     #$0F                            ; 9AD8 29 0F                    ).
        tax                                     ; 9ADA AA                       .
        lda     $4001                           ; 9ADB AD 01 40                 ..@
        jsr     L03FF                           ; 9ADE 20 FF 03                  ..
        asl     a                               ; 9AE1 0A                       .
        ora     $4001                           ; 9AE2 0D 01 40                 ..@
        and     #$0F                            ; 9AE5 29 0F                    ).
        ora     $030F,x                         ; 9AE7 1D 0F 03                 ...
        dey                                     ; 9AEA 88                       .
        sta     (a9L),y                         ; 9AEB 91 7E                    .~
        bne     L9AB9                           ; 9AED D0 CA                    ..
L9AEF:  ldx     #$02                            ; 9AEF A2 02                    ..
        stx     $4001                           ; 9AF1 8E 01 40                 ..@
        php                                     ; 9AF4 08                       .
        plp                                     ; 9AF5 28                       (
        php                                     ; 9AF6 08                       .
        plp                                     ; 9AF7 28                       (
        php                                     ; 9AF8 08                       .
        plp                                     ; 9AF9 28                       (
        php                                     ; 9AFA 08                       .
        plp                                     ; 9AFB 28                       (
        nop                                     ; 9AFC EA                       .
        nop                                     ; 9AFD EA                       .
        nop                                     ; 9AFE EA                       .
        nop                                     ; 9AFF EA                       .
        nop                                     ; 9B00 EA                       .
        nop                                     ; 9B01 EA                       .
        nop                                     ; 9B02 EA                       .
        rts                                     ; 9B03 60                       `

; ----------------------------------------------------------------------------
L9B04:  lda     #$04                            ; 9B04 A9 04                    ..
        bit     $4001                           ; 9B06 2C 01 40                 ,.@
        bne     L9B04                           ; 9B09 D0 F9                    ..
        lda     #$00                            ; 9B0B A9 00                    ..
        sta     $4001                           ; 9B0D 8D 01 40                 ..@
        rts                                     ; 9B10 60                       `

; ----------------------------------------------------------------------------
        sei                                     ; 9B11 78                       x
        lda     $41                             ; 9B12 A5 41                    .A
        pha                                     ; 9B14 48                       H
        lda     $42                             ; 9B15 A5 42                    .B
        pha                                     ; 9B17 48                       H
        lda     a9H                             ; 9B18 A5 7F                    ..
        pha                                     ; 9B1A 48                       H
        lda     a9L                             ; 9B1B A5 7E                    .~
        pha                                     ; 9B1D 48                       H
        ldx     #$02                            ; 9B1E A2 02                    ..
        ldy     #$00                            ; 9B20 A0 00                    ..
L9B22:  dey                                     ; 9B22 88                       .
        bne     L9B22                           ; 9B23 D0 FD                    ..
        dex                                     ; 9B25 CA                       .
        bne     L9B22                           ; 9B26 D0 FA                    ..
        jsr     L03ED                           ; 9B28 20 ED 03                  ..
        lda     #$04                            ; 9B2B A9 04                    ..
L9B2D:  bit     $4001                           ; 9B2D 2C 01 40                 ,.@
        beq     L9B2D                           ; 9B30 F0 FB                    ..
        lda     #$04                            ; 9B32 A9 04                    ..
        sta     a9H                             ; 9B34 85 7F                    ..
        lda     #$E9                            ; 9B36 A9 E9                    ..
        sta     a9L                             ; 9B38 85 7E                    .~
        ldy     #$01                            ; 9B3A A0 01                    ..
        jsr     L03AD                           ; 9B3C 20 AD 03                  ..
        sta     $42                             ; 9B3F 85 42                    .B
        tay                                     ; 9B41 A8                       .
        jsr     L03AD                           ; 9B42 20 AD 03                  ..
        jsr     L046E                           ; 9B45 20 6E 04                  n.
        lda     #$06                            ; 9B48 A9 06                    ..
        sta     a9H                             ; 9B4A 85 7F                    ..
        lda     #$00                            ; 9B4C A9 00                    ..
        sta     a9L                             ; 9B4E 85 7E                    .~
        lda     #$04                            ; 9B50 A9 04                    ..
        pha                                     ; 9B52 48                       H
        lda     #$2F                            ; 9B53 A9 2F                    ./
        pha                                     ; 9B55 48                       H
        jmp     (L04E9)                         ; 9B56 6C E9 04                 l..

; ----------------------------------------------------------------------------
        jsr     L0402                           ; 9B59 20 02 04                  ..
        pla                                     ; 9B5C 68                       h
        pla                                     ; 9B5D 68                       h
        pla                                     ; 9B5E 68                       h
        sta     a9L                             ; 9B5F 85 7E                    .~
        pla                                     ; 9B61 68                       h
        sta     a9H                             ; 9B62 85 7F                    ..
        pla                                     ; 9B64 68                       h
        sta     $42                             ; 9B65 85 42                    .B
        pla                                     ; 9B67 68                       h
        sta     $41                             ; 9B68 85 41                    .A
        cli                                     ; 9B6A 58                       X
        rts                                     ; 9B6B 60                       `

; ----------------------------------------------------------------------------
        lda     #$BF                            ; 9B6C A9 BF                    ..
        bne     L9B77                           ; 9B6E D0 07                    ..
        lda     #$40                            ; 9B70 A9 40                    .@
        ora     $4000                           ; 9B72 0D 00 40                 ..@
        bne     L9B7A                           ; 9B75 D0 03                    ..
L9B77:  and     $4000                           ; 9B77 2D 00 40                 -.@
L9B7A:  sta     $4000                           ; 9B7A 8D 00 40                 ..@
        rts                                     ; 9B7D 60                       `

; ----------------------------------------------------------------------------
        jsr     L04B0                           ; 9B7E 20 B0 04                  ..
        ldy     #$00                            ; 9B81 A0 00                    ..
        jsr     L03AD                           ; 9B83 20 AD 03                  ..
        lda     #$B6                            ; 9B86 A9 B6                    ..
        jsr     L04D1                           ; 9B88 20 D1 04                  ..
        lda     r1H                             ; 9B8B A5 05                    ..
        sta     $01FA                           ; 9B8D 8D FA 01                 ...
        bne     L9B9A                           ; 9B90 D0 08                    ..
        lda     #$90                            ; 9B92 A9 90                    ..
        sta     $04E8                           ; 9B94 8D E8 04                 ...
        jsr     L04D1                           ; 9B97 20 D1 04                  ..
L9B9A:  jmp     L032B                           ; 9B9A 4C 2B 03                 L+.

; ----------------------------------------------------------------------------
        jsr     L04B9                           ; 9B9D 20 B9 04                  ..
        lda     #$92                            ; 9BA0 A9 92                    ..
        jsr     L04D1                           ; 9BA2 20 D1 04                  ..
        lda     r1H                             ; 9BA5 A5 05                    ..
        cmp     #$02                            ; 9BA7 C9 02                    ..
        bcc     L9BAE                           ; 9BA9 90 03                    ..
        nop                                     ; 9BAB EA                       .
        nop                                     ; 9BAC EA                       .
        rts                                     ; 9BAD 60                       `

; ----------------------------------------------------------------------------
L9BAE:  lda     #$B0                            ; 9BAE A9 B0                    ..
        bne     L9BD3                           ; 9BB0 D0 21                    .!
        lda     $04EB                           ; 9BB2 AD EB 04                 ...
        and     #$7F                            ; 9BB5 29 7F                    ).
        cmp     r7H                             ; 9BB7 C5 11                    ..
        beq     L9BE8                           ; 9BB9 F0 2D                    .-
        lda     $04E8                           ; 9BBB AD E8 04                 ...
        beq     L9BE8                           ; 9BBE F0 28                    .(
        ldx     #$03                            ; 9BC0 A2 03                    ..
        jsr     LFF6C                           ; 9BC2 20 6C FF                  l.
        lda     #$00                            ; 9BC5 A9 00                    ..
        sta     $04E8                           ; 9BC7 8D E8 04                 ...
        lda     #$86                            ; 9BCA A9 86                    ..
        bne     L9BD3                           ; 9BCC D0 05                    ..
        jsr     L04B0                           ; 9BCE 20 B0 04                  ..
        lda     #$80                            ; 9BD1 A9 80                    ..
L9BD3:  sta     r1H                             ; 9BD3 85 05                    ..
        lda     $04EB                           ; 9BD5 AD EB 04                 ...
        and     #$7F                            ; 9BD8 29 7F                    ).
        sta     r7H                             ; 9BDA 85 11                    ..
        lda     $04EC                           ; 9BDC AD EC 04                 ...
        sta     r8L                             ; 9BDF 85 12                    ..
        ldx     #$03                            ; 9BE1 A2 03                    ..
        lda     r0L,x                           ; 9BE3 B5 02                    ..
        jsr     LFF54                           ; 9BE5 20 54 FF                  T.
L9BE8:  rts                                     ; 9BE8 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; 9BE9 00                       .
        brk                                     ; 9BEA 00                       .
        brk                                     ; 9BEB 00                       .
        brk                                     ; 9BEC 00                       .
        brk                                     ; 9BED 00                       .
        brk                                     ; 9BEE 00                       .

; End of "drv1581_drvcode" segment
; ----------------------------------------------------------------------------
.code

.segment        "drv1581_21hd_b": absolute

L9BEF:  brk                                     ; 9BEF 00                       .
L9BF0:  brk                                     ; 9BF0 00                       .
L9BF1:  brk                                     ; 9BF1 00                       .
L9BF2:  brk                                     ; 9BF2 00                       .
L9BF3:  brk                                     ; 9BF3 00                       .
        brk                                     ; 9BF4 00                       .
L9BF5:  brk                                     ; 9BF5 00                       .
L9BF6:  brk                                     ; 9BF6 00                       .
L9BF7:  brk                                     ; 9BF7 00                       .
L9BF8:  brk                                     ; 9BF8 00                       .
L9BF9:  brk                                     ; 9BF9 00                       .
L9BFA:  brk                                     ; 9BFA 00                       .
L9BFB:  brk                                     ; 9BFB 00                       .
L9BFC:  brk                                     ; 9BFC 00                       .
L9BFD:  brk                                     ; 9BFD 00                       .
        brk                                     ; 9BFE 00                       .
L9BFF:  brk                                     ; 9BFF 00                       .
L9C00:  brk                                     ; 9C00 00                       .
L9C01:  brk                                     ; 9C01 00                       .
L9C02:  brk                                     ; 9C02 00                       .
        brk                                     ; 9C03 00                       .
        brk                                     ; 9C04 00                       .
        brk                                     ; 9C05 00                       .
        brk                                     ; 9C06 00                       .
        brk                                     ; 9C07 00                       .
;        .byte   $C2                             ; 9C08 C2                       .
