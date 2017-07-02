; da65 V2.15
; Created:    2017-06-30 23:03:11
; Input file: configure.cvt.record.5
; Page:       1


.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "kernal.inc"
.include "jumptab.inc"
.include "c64.inc"

.segment        "drv1571ram": absolute

_InitForIO:
        .addr   __InitForIO                     ; 9000 37 95                    7.
_DoneWithIO:
        .addr   __DoneWithIO                    ; 9002 AD 95                    ..
_ExitTurbo:
        .addr   __ExitTurbo                     ; 9004 DC 95                    ..
_PurgeTurbo:
        .addr   __ExitTurbo                     ; 9006 DC 95                    ..
_EnterTurbo:
        .addr   __EnterTurbo                    ; 9008 D3 95                    ..
_ChangeDiskDevice:
        .addr   __ChangeDiskDevice              ; 900A E2 95                    ..
_NewDisk:
        .addr   __NewDisk                       ; 900C EA 95                    ..
_ReadBlock:
        .addr   __ReadBlock                     ; 900E EE 95                    ..
_WriteBlock:
        .addr   __WriteBlock                    ; 9010 04 96                    ..
_VerWriteBlock:
        .addr   __VerWriteBlock                 ; 9012 0D 96                    ..
_OpenDisk:
        .addr   __OpenDisk                      ; 9014 02 91                    ..
_GetBlock:
        .addr   __GetBlock                      ; 9016 7D 90                    }.
_PutBlock:
        .addr   __PutBlock                      ; 9018 B0 90                    ..
_GetDirHead:
        .addr   __GetDirHead                    ; 901A 4F 90                    O.
_PutDirHead:
        .addr   __PutDirHead                    ; 901C 8A 90                    ..
_GetFreeDirBlk:
        .addr   __GetFreeDirBlk                 ; 901E 90 92                    ..
_CalcBlksFree:
        .addr   __CalcBlksFree                  ; 9020 90 94                    ..
_FreeBlock:
        .addr   __FreeBlock                     ; 9022 67 94                    g.
_SetNextFree:
        .addr   __SetNextFree                   ; 9024 3D 93                    =.
_FindBAMBit:
        .addr   __FindBAMBit                    ; 9026 1C 94                    ..
_NxtBlkAlloc:
        .addr   __NxtBlkAlloc                   ; 9028 39 91                    9.
_BlkAlloc:
        .addr   __BlkAlloc                      ; 902A 32 91                    2.
_ChkDkGEOS:
        .addr   __ChkDkGEOS                     ; 902C 60 92                    `.
_SetGEOSDisk:
        .addr   __SetGEOSDisk                   ; 902E D6 94                    ..
; ----------------------------------------------------------------------------
Get1stDirEntry:
        jmp     _Get1stDirEntry                 ; 9030 4C D7 91                 L..

; ----------------------------------------------------------------------------
GetNxtDirEntry:
        jmp     _GetNxtDirEntry                 ; 9033 4C F0 91                 L..

; ----------------------------------------------------------------------------
GetBorder:
        jmp     _GetBorder                      ; 9036 4C 3A 92                 L:.

; ----------------------------------------------------------------------------
AddDirBlock:
        jmp     _AddDirBlock                    ; 9039 4C F1 92                 L..

; ----------------------------------------------------------------------------
ReadBuff:
        jmp     _ReadBuff                       ; 903C 4C 75 90                 Lu.

; ----------------------------------------------------------------------------
WriteBuff:
        jmp     _WriteBuff                      ; 903F 4C A8 90                 L..

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
        jmp     _AllocateBlock                  ; 9048 4C EF 93                 L..

; ----------------------------------------------------------------------------
ReadLink:
        jmp     _ReadLink                       ; 904B 4C F9 95                 L..

; ----------------------------------------------------------------------------
        .byte   $82                             ; 904E 82                       .
__GetDirHead:
        jsr     L90C3                           ; 904F 20 C3 90                  ..
        jsr     __GetBlock                      ; 9052 20 7D 90                  }.
        txa                                     ; 9055 8A                       .
        bne     L906F                           ; 9056 D0 17                    ..
        ldy     curDrive                        ; 9058 AC 89 84                 ...
        lda     $8203                           ; 905B AD 03 82                 ...
        sta     $88B7,y                         ; 905E 99 B7 88                 ...
        bpl     L906F                           ; 9061 10 0C                    ..
        jsr     L90D2                           ; 9063 20 D2 90                  ..
        jsr     __GetBlock                      ; 9066 20 7D 90                  }.
        lda     #$06                            ; 9069 A9 06                    ..
        sta     interleave                      ; 906B 8D 8C 84                 ...
        rts                                     ; 906E 60                       `

; ----------------------------------------------------------------------------
L906F:  lda     #$08                            ; 906F A9 08                    ..
        sta     interleave                      ; 9071 8D 8C 84                 ...
        rts                                     ; 9074 60                       `

; ----------------------------------------------------------------------------
_ReadBuff:
        lda     #$80                            ; 9075 A9 80                    ..
        sta     r4H                             ; 9077 85 0B                    ..
        lda     #$00                            ; 9079 A9 00                    ..
        sta     r4L                             ; 907B 85 0A                    ..
__GetBlock:
        jsr     EnterTurbo                      ; 907D 20 14 C2                  ..
        txa                                     ; 9080 8A                       .
        bne     L9089                           ; 9081 D0 06                    ..
        php                                     ; 9083 08                       .
        sei                                     ; 9084 78                       x
        jsr     ReadBlock                       ; 9085 20 1A C2                  ..
        plp                                     ; 9088 28                       (
L9089:  rts                                     ; 9089 60                       `

; ----------------------------------------------------------------------------
__PutDirHead:
        php                                     ; 908A 08                       .
        sei                                     ; 908B 78                       x
        jsr     L90C3                           ; 908C 20 C3 90                  ..
        jsr     WriteBlock                      ; 908F 20 20 C2                   .
        txa                                     ; 9092 8A                       .
        bne     L90A6                           ; 9093 D0 11                    ..
        ldy     curDrive                        ; 9095 AC 89 84                 ...
        lda     $8203                           ; 9098 AD 03 82                 ...
        sta     $88B7,y                         ; 909B 99 B7 88                 ...
        bpl     L90A6                           ; 909E 10 06                    ..
        jsr     L90D2                           ; 90A0 20 D2 90                  ..
        jsr     WriteBlock                      ; 90A3 20 20 C2                   .
L90A6:  plp                                     ; 90A6 28                       (
        rts                                     ; 90A7 60                       `

; ----------------------------------------------------------------------------
_WriteBuff:
        lda     #$80                            ; 90A8 A9 80                    ..
        sta     r4H                             ; 90AA 85 0B                    ..
        lda     #$00                            ; 90AC A9 00                    ..
        sta     r4L                             ; 90AE 85 0A                    ..
__PutBlock:
        jsr     EnterTurbo                      ; 90B0 20 14 C2                  ..
        txa                                     ; 90B3 8A                       .
        bne     L90C2                           ; 90B4 D0 0C                    ..
        php                                     ; 90B6 08                       .
        sei                                     ; 90B7 78                       x
        jsr     WriteBlock                      ; 90B8 20 20 C2                   .
        txa                                     ; 90BB 8A                       .
        bne     L90C1                           ; 90BC D0 03                    ..
        jsr     VerWriteBlock                   ; 90BE 20 23 C2                  #.
L90C1:  plp                                     ; 90C1 28                       (
L90C2:  rts                                     ; 90C2 60                       `

; ----------------------------------------------------------------------------
L90C3:  lda     #$12                            ; 90C3 A9 12                    ..
        sta     r1L                             ; 90C5 85 04                    ..
        lda     #$00                            ; 90C7 A9 00                    ..
        sta     r1H                             ; 90C9 85 05                    ..
        sta     r4L                             ; 90CB 85 0A                    ..
        lda     #$82                            ; 90CD A9 82                    ..
        sta     r4H                             ; 90CF 85 0B                    ..
        rts                                     ; 90D1 60                       `

; ----------------------------------------------------------------------------
L90D2:  lda     #$35                            ; 90D2 A9 35                    .5
        sta     r1L                             ; 90D4 85 04                    ..
        lda     #$00                            ; 90D6 A9 00                    ..
        sta     r1H                             ; 90D8 85 05                    ..
        sta     r4L                             ; 90DA 85 0A                    ..
        lda     #$89                            ; 90DC A9 89                    ..
        sta     r4H                             ; 90DE 85 0B                    ..
        rts                                     ; 90E0 60                       `

; ----------------------------------------------------------------------------
L90E1:  lda     #$00                            ; 90E1 A9 00                    ..
        sta     L96FC                           ; 90E3 8D FC 96                 ...
        ldx     #$02                            ; 90E6 A2 02                    ..
        lda     r1L                             ; 90E8 A5 04                    ..
        beq     L9100                           ; 90EA F0 14                    ..
        cmp     #$24                            ; 90EC C9 24                    .$
        bcc     L90FE                           ; 90EE 90 0E                    ..
        ldy     curDrive                        ; 90F0 AC 89 84                 ...
        lda     $88B7,y                         ; 90F3 B9 B7 88                 ...
        bpl     L9100                           ; 90F6 10 08                    ..
        lda     r1L                             ; 90F8 A5 04                    ..
        cmp     #$47                            ; 90FA C9 47                    .G
        bcs     L9100                           ; 90FC B0 02                    ..
L90FE:  sec                                     ; 90FE 38                       8
        rts                                     ; 90FF 60                       `

; ----------------------------------------------------------------------------
L9100:  clc                                     ; 9100 18                       .
        rts                                     ; 9101 60                       `

; ----------------------------------------------------------------------------
__OpenDisk:
        jsr     NewDisk                         ; 9102 20 E1 C1                  ..
        txa                                     ; 9105 8A                       .
        bne     L9131                           ; 9106 D0 29                    .)
        jsr     GetDirHead                      ; 9108 20 47 C2                  G.
        txa                                     ; 910B 8A                       .
        bne     L9131                           ; 910C D0 23                    .#
        lda     #$82                            ; 910E A9 82                    ..
        sta     r5H                             ; 9110 85 0D                    ..
        lda     #$00                            ; 9112 A9 00                    ..
        sta     r5L                             ; 9114 85 0C                    ..
        jsr     ChkDkGEOS                       ; 9116 20 DE C1                  ..
        lda     #$82                            ; 9119 A9 82                    ..
        sta     r4H                             ; 911B 85 0B                    ..
        lda     #$90                            ; 911D A9 90                    ..
        sta     r4L                             ; 911F 85 0A                    ..
        ldx     #$0C                            ; 9121 A2 0C                    ..
        jsr     GetPtrCurDkNm                   ; 9123 20 98 C2                  ..
        ldx     #$0A                            ; 9126 A2 0A                    ..
        ldy     #$0C                            ; 9128 A0 0C                    ..
        lda     #$12                            ; 912A A9 12                    ..
        jsr     CopyFString                     ; 912C 20 68 C2                  h.
        ldx     #$00                            ; 912F A2 00                    ..
L9131:  rts                                     ; 9131 60                       `

; ----------------------------------------------------------------------------
__BlkAlloc:
        ldy     #$01                            ; 9132 A0 01                    ..
        sty     r3L                             ; 9134 84 08                    ..
        dey                                     ; 9136 88                       .
        sty     r3H                             ; 9137 84 09                    ..
__NxtBlkAlloc:
        lda     r9H                             ; 9139 A5 15                    ..
        pha                                     ; 913B 48                       H
        lda     r9L                             ; 913C A5 14                    ..
        pha                                     ; 913E 48                       H
        lda     r3H                             ; 913F A5 09                    ..
        pha                                     ; 9141 48                       H
        lda     r3L                             ; 9142 A5 08                    ..
        pha                                     ; 9144 48                       H
        lda     #$00                            ; 9145 A9 00                    ..
        sta     r3H                             ; 9147 85 09                    ..
        lda     #$FE                            ; 9149 A9 FE                    ..
        sta     r3L                             ; 914B 85 08                    ..
        ldx     #$06                            ; 914D A2 06                    ..
        ldy     #$08                            ; 914F A0 08                    ..
        jsr     Ddiv                            ; 9151 20 69 C1                  i.
        lda     r8L                             ; 9154 A5 12                    ..
        beq     L915E                           ; 9156 F0 06                    ..
        inc     r2L                             ; 9158 E6 06                    ..
        bne     L915E                           ; 915A D0 02                    ..
        inc     r2H                             ; 915C E6 07                    ..
L915E:  jsr     L91CE                           ; 915E 20 CE 91                  ..
        jsr     CalcBlksFree                    ; 9161 20 DB C1                  ..
        pla                                     ; 9164 68                       h
        sta     r3L                             ; 9165 85 08                    ..
        pla                                     ; 9167 68                       h
        sta     r3H                             ; 9168 85 09                    ..
        ldx     #$03                            ; 916A A2 03                    ..
        lda     r2H                             ; 916C A5 07                    ..
        cmp     r4H                             ; 916E C5 0B                    ..
        bne     L9176                           ; 9170 D0 04                    ..
        lda     r2L                             ; 9172 A5 06                    ..
        cmp     r4L                             ; 9174 C5 0A                    ..
L9176:  beq     L917A                           ; 9176 F0 02                    ..
        bcs     L91C7                           ; 9178 B0 4D                    .M
L917A:  lda     r6H                             ; 917A A5 0F                    ..
        sta     r4H                             ; 917C 85 0B                    ..
        lda     r6L                             ; 917E A5 0E                    ..
        sta     r4L                             ; 9180 85 0A                    ..
        lda     r2H                             ; 9182 A5 07                    ..
        sta     r5H                             ; 9184 85 0D                    ..
        lda     r2L                             ; 9186 A5 06                    ..
        sta     r5L                             ; 9188 85 0C                    ..
L918A:  jsr     SetNextFree                     ; 918A 20 92 C2                  ..
        txa                                     ; 918D 8A                       .
        bne     L91C7                           ; 918E D0 37                    .7
        ldy     #$00                            ; 9190 A0 00                    ..
        lda     r3L                             ; 9192 A5 08                    ..
        sta     (r4L),y                         ; 9194 91 0A                    ..
        iny                                     ; 9196 C8                       .
        lda     r3H                             ; 9197 A5 09                    ..
        sta     (r4L),y                         ; 9199 91 0A                    ..
        clc                                     ; 919B 18                       .
        lda     #$02                            ; 919C A9 02                    ..
        adc     r4L                             ; 919E 65 0A                    e.
        sta     r4L                             ; 91A0 85 0A                    ..
        bcc     L91A6                           ; 91A2 90 02                    ..
        inc     r4H                             ; 91A4 E6 0B                    ..
L91A6:  lda     r5L                             ; 91A6 A5 0C                    ..
        bne     L91AC                           ; 91A8 D0 02                    ..
        dec     r5H                             ; 91AA C6 0D                    ..
L91AC:  dec     r5L                             ; 91AC C6 0C                    ..
        lda     r5L                             ; 91AE A5 0C                    ..
        ora     r5H                             ; 91B0 05 0D                    ..
        bne     L918A                           ; 91B2 D0 D6                    ..
        ldy     #$00                            ; 91B4 A0 00                    ..
        tya                                     ; 91B6 98                       .
        sta     (r4L),y                         ; 91B7 91 0A                    ..
        iny                                     ; 91B9 C8                       .
        lda     r8L                             ; 91BA A5 12                    ..
        bne     L91C0                           ; 91BC D0 02                    ..
        lda     #$FE                            ; 91BE A9 FE                    ..
L91C0:  clc                                     ; 91C0 18                       .
        adc     #$01                            ; 91C1 69 01                    i.
        sta     (r4L),y                         ; 91C3 91 0A                    ..
        ldx     #$00                            ; 91C5 A2 00                    ..
L91C7:  pla                                     ; 91C7 68                       h
        sta     r9L                             ; 91C8 85 14                    ..
        pla                                     ; 91CA 68                       h
        sta     r9H                             ; 91CB 85 15                    ..
        rts                                     ; 91CD 60                       `

; ----------------------------------------------------------------------------
L91CE:  lda     #$82                            ; 91CE A9 82                    ..
        sta     r5H                             ; 91D0 85 0D                    ..
        lda     #$00                            ; 91D2 A9 00                    ..
        sta     r5L                             ; 91D4 85 0C                    ..
        rts                                     ; 91D6 60                       `

; ----------------------------------------------------------------------------
_Get1stDirEntry:
        lda     #$12                            ; 91D7 A9 12                    ..
        sta     r1L                             ; 91D9 85 04                    ..
        lda     #$01                            ; 91DB A9 01                    ..
        sta     r1H                             ; 91DD 85 05                    ..
        jsr     ReadBuff                        ; 91DF 20 3C 90                  <.
        lda     #$80                            ; 91E2 A9 80                    ..
        sta     r5H                             ; 91E4 85 0D                    ..
        lda     #$02                            ; 91E6 A9 02                    ..
        sta     r5L                             ; 91E8 85 0C                    ..
        lda     #$00                            ; 91EA A9 00                    ..
        sta     L96FF                           ; 91EC 8D FF 96                 ...
        rts                                     ; 91EF 60                       `

; ----------------------------------------------------------------------------
_GetNxtDirEntry:
        ldx     #$00                            ; 91F0 A2 00                    ..
        ldy     #$00                            ; 91F2 A0 00                    ..
        clc                                     ; 91F4 18                       .
        lda     #$20                            ; 91F5 A9 20                    . 
        adc     r5L                             ; 91F7 65 0C                    e.
        sta     r5L                             ; 91F9 85 0C                    ..
        bcc     L91FF                           ; 91FB 90 02                    ..
        inc     r5H                             ; 91FD E6 0D                    ..
L91FF:  lda     r5H                             ; 91FF A5 0D                    ..
        cmp     #$80                            ; 9201 C9 80                    ..
        bne     L9209                           ; 9203 D0 04                    ..
        lda     r5L                             ; 9205 A5 0C                    ..
        cmp     #$FF                            ; 9207 C9 FF                    ..
L9209:  bcc     L9239                           ; 9209 90 2E                    ..
        ldy     #$FF                            ; 920B A0 FF                    ..
        lda     $8001                           ; 920D AD 01 80                 ...
        sta     r1H                             ; 9210 85 05                    ..
        lda     diskBlkBuf                      ; 9212 AD 00 80                 ...
        sta     r1L                             ; 9215 85 04                    ..
        bne     L922C                           ; 9217 D0 13                    ..
        lda     L96FF                           ; 9219 AD FF 96                 ...
        bne     L9239                           ; 921C D0 1B                    ..
        lda     #$FF                            ; 921E A9 FF                    ..
        sta     L96FF                           ; 9220 8D FF 96                 ...
        jsr     GetBorder                       ; 9223 20 36 90                  6.
        txa                                     ; 9226 8A                       .
        bne     L9239                           ; 9227 D0 10                    ..
        tya                                     ; 9229 98                       .
        bne     L9239                           ; 922A D0 0D                    ..
L922C:  jsr     ReadBuff                        ; 922C 20 3C 90                  <.
        ldy     #$00                            ; 922F A0 00                    ..
        lda     #$80                            ; 9231 A9 80                    ..
        sta     r5H                             ; 9233 85 0D                    ..
        lda     #$02                            ; 9235 A9 02                    ..
        sta     r5L                             ; 9237 85 0C                    ..
L9239:  rts                                     ; 9239 60                       `

; ----------------------------------------------------------------------------
_GetBorder:
        jsr     GetDirHead                      ; 923A 20 47 C2                  G.
        txa                                     ; 923D 8A                       .
        bne     L925F                           ; 923E D0 1F                    ..
        lda     #$82                            ; 9240 A9 82                    ..
        sta     r5H                             ; 9242 85 0D                    ..
        lda     #$00                            ; 9244 A9 00                    ..
        sta     r5L                             ; 9246 85 0C                    ..
        jsr     ChkDkGEOS                       ; 9248 20 DE C1                  ..
        bne     L9251                           ; 924B D0 04                    ..
        ldy     #$FF                            ; 924D A0 FF                    ..
        bne     L925D                           ; 924F D0 0C                    ..
L9251:  lda     $82AC                           ; 9251 AD AC 82                 ...
        sta     r1H                             ; 9254 85 05                    ..
        lda     $82AB                           ; 9256 AD AB 82                 ...
        sta     r1L                             ; 9259 85 04                    ..
        ldy     #$00                            ; 925B A0 00                    ..
L925D:  ldx     #$00                            ; 925D A2 00                    ..
L925F:  rts                                     ; 925F 60                       `

; ----------------------------------------------------------------------------
__ChkDkGEOS:
        ldy     #$AD                            ; 9260 A0 AD                    ..
        ldx     #$00                            ; 9262 A2 00                    ..
        lda     #$00                            ; 9264 A9 00                    ..
        sta     isGEOS                          ; 9266 8D 8B 84                 ...
L9269:  lda     (r5L),y                         ; 9269 B1 0C                    ..
        cmp     L927F,x                         ; 926B DD 7F 92                 ...
        bne     L927B                           ; 926E D0 0B                    ..
        iny                                     ; 9270 C8                       .
        inx                                     ; 9271 E8                       .
        cpx     #$0B                            ; 9272 E0 0B                    ..
        bne     L9269                           ; 9274 D0 F3                    ..
        lda     #$FF                            ; 9276 A9 FF                    ..
        sta     isGEOS                          ; 9278 8D 8B 84                 ...
L927B:  lda     isGEOS                          ; 927B AD 8B 84                 ...
        rts                                     ; 927E 60                       `

; ----------------------------------------------------------------------------
L927F:  .byte   "GEOS format V1.0"              ; 927F 47 45 4F 53 20 66 6F 72  GEOS for
                                                ; 9287 6D 61 74 20 56 31 2E 30  mat V1.0
        .byte   $00                             ; 928F 00                       .
; ----------------------------------------------------------------------------
__GetFreeDirBlk:
        php                                     ; 9290 08                       .
        sei                                     ; 9291 78                       x
        lda     r6L                             ; 9292 A5 0E                    ..
        pha                                     ; 9294 48                       H
        lda     r2H                             ; 9295 A5 07                    ..
        pha                                     ; 9297 48                       H
        lda     r2L                             ; 9298 A5 06                    ..
        pha                                     ; 929A 48                       H
        ldx     r10L                            ; 929B A6 16                    ..
        inx                                     ; 929D E8                       .
        stx     r6L                             ; 929E 86 0E                    ..
        lda     #$12                            ; 92A0 A9 12                    ..
        sta     r1L                             ; 92A2 85 04                    ..
        lda     #$01                            ; 92A4 A9 01                    ..
        sta     r1H                             ; 92A6 85 05                    ..
L92A8:  jsr     ReadBuff                        ; 92A8 20 3C 90                  <.
L92AB:  txa                                     ; 92AB 8A                       .
        bne     L92E6                           ; 92AC D0 38                    .8
        dec     r6L                             ; 92AE C6 0E                    ..
        beq     L92C7                           ; 92B0 F0 15                    ..
L92B2:  lda     diskBlkBuf                      ; 92B2 AD 00 80                 ...
        bne     L92BD                           ; 92B5 D0 06                    ..
        jsr     AddDirBlock                     ; 92B7 20 39 90                  9.
        clv                                     ; 92BA B8                       .
        bvc     L92AB                           ; 92BB 50 EE                    P.
L92BD:  sta     r1L                             ; 92BD 85 04                    ..
        lda     $8001                           ; 92BF AD 01 80                 ...
        sta     r1H                             ; 92C2 85 05                    ..
        clv                                     ; 92C4 B8                       .
        bvc     L92A8                           ; 92C5 50 E1                    P.
L92C7:  ldy     #$02                            ; 92C7 A0 02                    ..
        ldx     #$00                            ; 92C9 A2 00                    ..
L92CB:  lda     diskBlkBuf,y                    ; 92CB B9 00 80                 ...
        beq     L92E6                           ; 92CE F0 16                    ..
        tya                                     ; 92D0 98                       .
        clc                                     ; 92D1 18                       .
        adc     #$20                            ; 92D2 69 20                    i 
        tay                                     ; 92D4 A8                       .
        bcc     L92CB                           ; 92D5 90 F4                    ..
        lda     #$01                            ; 92D7 A9 01                    ..
        sta     r6L                             ; 92D9 85 0E                    ..
        ldx     #$04                            ; 92DB A2 04                    ..
        ldy     r10L                            ; 92DD A4 16                    ..
        iny                                     ; 92DF C8                       .
        sty     r10L                            ; 92E0 84 16                    ..
        cpy     #$12                            ; 92E2 C0 12                    ..
        bcc     L92B2                           ; 92E4 90 CC                    ..
L92E6:  pla                                     ; 92E6 68                       h
        sta     r2L                             ; 92E7 85 06                    ..
        pla                                     ; 92E9 68                       h
        sta     r2H                             ; 92EA 85 07                    ..
        pla                                     ; 92EC 68                       h
        sta     r6L                             ; 92ED 85 0E                    ..
        plp                                     ; 92EF 28                       (
        rts                                     ; 92F0 60                       `

; ----------------------------------------------------------------------------
_AddDirBlock:
        lda     r6H                             ; 92F1 A5 0F                    ..
        pha                                     ; 92F3 48                       H
        lda     r6L                             ; 92F4 A5 0E                    ..
        pha                                     ; 92F6 48                       H
        ldy     #$48                            ; 92F7 A0 48                    .H
        ldx     #$04                            ; 92F9 A2 04                    ..
        lda     curDirHead,y                    ; 92FB B9 00 82                 ...
        beq     L9326                           ; 92FE F0 26                    .&
        lda     r1H                             ; 9300 A5 05                    ..
        sta     r3H                             ; 9302 85 09                    ..
        lda     r1L                             ; 9304 A5 04                    ..
        sta     r3L                             ; 9306 85 08                    ..
        jsr     SetNextFree                     ; 9308 20 92 C2                  ..
        lda     r3H                             ; 930B A5 09                    ..
        sta     $8001                           ; 930D 8D 01 80                 ...
        lda     r3L                             ; 9310 A5 08                    ..
        sta     diskBlkBuf                      ; 9312 8D 00 80                 ...
        jsr     WriteBuff                       ; 9315 20 3F 90                  ?.
        txa                                     ; 9318 8A                       .
        bne     L9326                           ; 9319 D0 0B                    ..
        lda     r3H                             ; 931B A5 09                    ..
        sta     r1H                             ; 931D 85 05                    ..
        lda     r3L                             ; 931F A5 08                    ..
        sta     r1L                             ; 9321 85 04                    ..
        jsr     L932D                           ; 9323 20 2D 93                  -.
L9326:  pla                                     ; 9326 68                       h
        sta     r6L                             ; 9327 85 0E                    ..
        pla                                     ; 9329 68                       h
        sta     r6H                             ; 932A 85 0F                    ..
        rts                                     ; 932C 60                       `

; ----------------------------------------------------------------------------
L932D:  lda     #$00                            ; 932D A9 00                    ..
        tay                                     ; 932F A8                       .
L9330:  sta     diskBlkBuf,y                    ; 9330 99 00 80                 ...
        iny                                     ; 9333 C8                       .
        bne     L9330                           ; 9334 D0 FA                    ..
        dey                                     ; 9336 88                       .
        sty     $8001                           ; 9337 8C 01 80                 ...
        jmp     WriteBuff                       ; 933A 4C 3F 90                 L?.

; ----------------------------------------------------------------------------
__SetNextFree:
        lda     r3H                             ; 933D A5 09                    ..
        clc                                     ; 933F 18                       .
        adc     interleave                      ; 9340 6D 8C 84                 m..
        sta     r6H                             ; 9343 85 0F                    ..
        lda     r3L                             ; 9345 A5 08                    ..
        sta     r6L                             ; 9347 85 0E                    ..
        cmp     #$12                            ; 9349 C9 12                    ..
        beq     L935B                           ; 934B F0 0E                    ..
        cmp     #$35                            ; 934D C9 35                    .5
        beq     L935B                           ; 934F F0 0A                    ..
L9351:  lda     r6L                             ; 9351 A5 0E                    ..
        cmp     #$12                            ; 9353 C9 12                    ..
        beq     L9387                           ; 9355 F0 30                    .0
        cmp     #$35                            ; 9357 C9 35                    .5
        beq     L9387                           ; 9359 F0 2C                    .,
L935B:  cmp     #$24                            ; 935B C9 24                    .$
        bcc     L936A                           ; 935D 90 0B                    ..
        clc                                     ; 935F 18                       .
        adc     #$B9                            ; 9360 69 B9                    i.
        tax                                     ; 9362 AA                       .
        lda     curDirHead,x                    ; 9363 BD 00 82                 ...
        bne     L9372                           ; 9366 D0 0A                    ..
        beq     L9387                           ; 9368 F0 1D                    ..
L936A:  asl     a                               ; 936A 0A                       .
        asl     a                               ; 936B 0A                       .
        tax                                     ; 936C AA                       .
        lda     curDirHead,x                    ; 936D BD 00 82                 ...
        beq     L9387                           ; 9370 F0 15                    ..
L9372:  lda     r6L                             ; 9372 A5 0E                    ..
        jsr     L93C5                           ; 9374 20 C5 93                  ..
        lda     L93DD,x                         ; 9377 BD DD 93                 ...
        sta     r7L                             ; 937A 85 10                    ..
        tay                                     ; 937C A8                       .
L937D:  jsr     L93E1                           ; 937D 20 E1 93                  ..
        beq     L93B7                           ; 9380 F0 35                    .5
        inc     r6H                             ; 9382 E6 0F                    ..
        dey                                     ; 9384 88                       .
        bne     L937D                           ; 9385 D0 F6                    ..
L9387:  bit     $8203                           ; 9387 2C 03 82                 ,..
        bpl     L93A0                           ; 938A 10 14                    ..
        lda     r6L                             ; 938C A5 0E                    ..
        cmp     #$24                            ; 938E C9 24                    .$
        bcs     L9399                           ; 9390 B0 07                    ..
        clc                                     ; 9392 18                       .
        adc     #$23                            ; 9393 69 23                    i#
        sta     r6L                             ; 9395 85 0E                    ..
        bne     L93A8                           ; 9397 D0 0F                    ..
L9399:  sec                                     ; 9399 38                       8
        sbc     #$22                            ; 939A E9 22                    ."
        sta     r6L                             ; 939C 85 0E                    ..
        bne     L93A4                           ; 939E D0 04                    ..
L93A0:  inc     r6L                             ; 93A0 E6 0E                    ..
        lda     r6L                             ; 93A2 A5 0E                    ..
L93A4:  cmp     #$24                            ; 93A4 C9 24                    .$
        bcs     L93C2                           ; 93A6 B0 1A                    ..
L93A8:  sec                                     ; 93A8 38                       8
        sbc     r3L                             ; 93A9 E5 08                    ..
        sta     r6H                             ; 93AB 85 0F                    ..
        asl     a                               ; 93AD 0A                       .
        adc     #$04                            ; 93AE 69 04                    i.
        adc     interleave                      ; 93B0 6D 8C 84                 m..
        sta     r6H                             ; 93B3 85 0F                    ..
        bne     L9351                           ; 93B5 D0 9A                    ..
L93B7:  lda     r6L                             ; 93B7 A5 0E                    ..
        sta     r3L                             ; 93B9 85 08                    ..
        lda     r6H                             ; 93BB A5 0F                    ..
        sta     r3H                             ; 93BD 85 09                    ..
        ldx     #$00                            ; 93BF A2 00                    ..
        rts                                     ; 93C1 60                       `

; ----------------------------------------------------------------------------
L93C2:  ldx     #$03                            ; 93C2 A2 03                    ..
        rts                                     ; 93C4 60                       `

; ----------------------------------------------------------------------------
L93C5:  pha                                     ; 93C5 48                       H
        cmp     #$24                            ; 93C6 C9 24                    .$
        bcc     L93CD                           ; 93C8 90 03                    ..
        sec                                     ; 93CA 38                       8
        sbc     #$23                            ; 93CB E9 23                    .#
L93CD:  ldx     #$00                            ; 93CD A2 00                    ..
L93CF:  cmp     L93D9,x                         ; 93CF DD D9 93                 ...
        bcc     L93D7                           ; 93D2 90 03                    ..
        inx                                     ; 93D4 E8                       .
        bne     L93CF                           ; 93D5 D0 F8                    ..
L93D7:  pla                                     ; 93D7 68                       h
        rts                                     ; 93D8 60                       `

; ----------------------------------------------------------------------------
L93D9:  .byte   $12                             ; 93D9 12                       .
        ora     $241F,y                         ; 93DA 19 1F 24                 ..$
L93DD:  ora     r8H,x                           ; 93DD 15 13                    ..
        .byte   $12                             ; 93DF 12                       .
        .byte   $11                             ; 93E0 11                       .
L93E1:  lda     r6H                             ; 93E1 A5 0F                    ..
L93E3:  cmp     r7L                             ; 93E3 C5 10                    ..
        bcc     L93ED                           ; 93E5 90 06                    ..
        sec                                     ; 93E7 38                       8
        sbc     r7L                             ; 93E8 E5 10                    ..
        clv                                     ; 93EA B8                       .
        bvc     L93E3                           ; 93EB 50 F6                    P.
L93ED:  sta     r6H                             ; 93ED 85 0F                    ..
_AllocateBlock:
        jsr     FindBAMBit                      ; 93EF 20 AD C2                  ..
        beq     L9419                           ; 93F2 F0 25                    .%
        lda     r6L                             ; 93F4 A5 0E                    ..
        cmp     #$24                            ; 93F6 C9 24                    .$
        bcc     L9407                           ; 93F8 90 0D                    ..
        lda     r8H                             ; 93FA A5 13                    ..
        eor     #$FF                            ; 93FC 49 FF                    I.
        and     dir2Head,x                      ; 93FE 3D 00 89                 =..
        sta     dir2Head,x                      ; 9401 9D 00 89                 ...
        clv                                     ; 9404 B8                       .
        bvc     L9411                           ; 9405 50 0A                    P.
L9407:  lda     r8H                             ; 9407 A5 13                    ..
        eor     #$FF                            ; 9409 49 FF                    I.
        and     curDirHead,x                    ; 940B 3D 00 82                 =..
        sta     curDirHead,x                    ; 940E 9D 00 82                 ...
L9411:  ldx     r7H                             ; 9411 A6 11                    ..
        dec     curDirHead,x                    ; 9413 DE 00 82                 ...
        ldx     #$00                            ; 9416 A2 00                    ..
        rts                                     ; 9418 60                       `

; ----------------------------------------------------------------------------
L9419:  ldx     #$06                            ; 9419 A2 06                    ..
        rts                                     ; 941B 60                       `

; ----------------------------------------------------------------------------
__FindBAMBit:
        lda     r6H                             ; 941C A5 0F                    ..
        and     #$07                            ; 941E 29 07                    ).
        tax                                     ; 9420 AA                       .
        lda     L945F,x                         ; 9421 BD 5F 94                 ._.
        sta     r8H                             ; 9424 85 13                    ..
        lda     r6L                             ; 9426 A5 0E                    ..
        cmp     #$24                            ; 9428 C9 24                    .$
        bcc     L944C                           ; 942A 90 20                    . 
        sec                                     ; 942C 38                       8
        sbc     #$24                            ; 942D E9 24                    .$
        sta     r7H                             ; 942F 85 11                    ..
        lda     r6H                             ; 9431 A5 0F                    ..
        lsr     a                               ; 9433 4A                       J
        lsr     a                               ; 9434 4A                       J
        lsr     a                               ; 9435 4A                       J
        clc                                     ; 9436 18                       .
        adc     r7H                             ; 9437 65 11                    e.
        asl     r7H                             ; 9439 06 11                    ..
        clc                                     ; 943B 18                       .
        adc     r7H                             ; 943C 65 11                    e.
        tax                                     ; 943E AA                       .
        lda     r6L                             ; 943F A5 0E                    ..
        clc                                     ; 9441 18                       .
        adc     #$B9                            ; 9442 69 B9                    i.
        sta     r7H                             ; 9444 85 11                    ..
        lda     dir2Head,x                      ; 9446 BD 00 89                 ...
        and     r8H                             ; 9449 25 13                    %.
        rts                                     ; 944B 60                       `

; ----------------------------------------------------------------------------
L944C:  asl     a                               ; 944C 0A                       .
        asl     a                               ; 944D 0A                       .
        sta     r7H                             ; 944E 85 11                    ..
        lda     r6H                             ; 9450 A5 0F                    ..
        lsr     a                               ; 9452 4A                       J
        lsr     a                               ; 9453 4A                       J
        lsr     a                               ; 9454 4A                       J
        sec                                     ; 9455 38                       8
        adc     r7H                             ; 9456 65 11                    e.
        tax                                     ; 9458 AA                       .
        lda     curDirHead,x                    ; 9459 BD 00 82                 ...
        and     r8H                             ; 945C 25 13                    %.
        rts                                     ; 945E 60                       `

; ----------------------------------------------------------------------------
L945F:  ora     (r0L,x)                         ; 945F 01 02                    ..
        .byte   $04                             ; 9461 04                       .
        php                                     ; 9462 08                       .
        bpl     L9485                           ; 9463 10 20                    . 
        rti                                     ; 9465 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; 9466 80                       .
__FreeBlock:
        jsr     FindBAMBit                      ; 9467 20 AD C2                  ..
        bne     L948D                           ; 946A D0 21                    .!
        lda     r6L                             ; 946C A5 0E                    ..
        cmp     #$24                            ; 946E C9 24                    .$
        bcc     L947D                           ; 9470 90 0B                    ..
        lda     r8H                             ; 9472 A5 13                    ..
        eor     dir2Head,x                      ; 9474 5D 00 89                 ]..
        sta     dir2Head,x                      ; 9477 9D 00 89                 ...
        clv                                     ; 947A B8                       .
        bvc     L9485                           ; 947B 50 08                    P.
L947D:  lda     r8H                             ; 947D A5 13                    ..
        eor     curDirHead,x                    ; 947F 5D 00 82                 ]..
        sta     curDirHead,x                    ; 9482 9D 00 82                 ...
L9485:  ldx     r7H                             ; 9485 A6 11                    ..
        inc     curDirHead,x                    ; 9487 FE 00 82                 ...
        ldx     #$00                            ; 948A A2 00                    ..
        rts                                     ; 948C 60                       `

; ----------------------------------------------------------------------------
L948D:  ldx     #$06                            ; 948D A2 06                    ..
        rts                                     ; 948F 60                       `

; ----------------------------------------------------------------------------
__CalcBlksFree:
        lda     #$00                            ; 9490 A9 00                    ..
        sta     r4L                             ; 9492 85 0A                    ..
        sta     r4H                             ; 9494 85 0B                    ..
        ldy     #$04                            ; 9496 A0 04                    ..
L9498:  lda     (r5L),y                         ; 9498 B1 0C                    ..
        clc                                     ; 949A 18                       .
        adc     r4L                             ; 949B 65 0A                    e.
        sta     r4L                             ; 949D 85 0A                    ..
        bcc     L94A3                           ; 949F 90 02                    ..
        inc     r4H                             ; 94A1 E6 0B                    ..
L94A3:  tya                                     ; 94A3 98                       .
        clc                                     ; 94A4 18                       .
        adc     #$04                            ; 94A5 69 04                    i.
        tay                                     ; 94A7 A8                       .
        cpy     #$48                            ; 94A8 C0 48                    .H
        beq     L94A3                           ; 94AA F0 F7                    ..
        cpy     #$90                            ; 94AC C0 90                    ..
        bne     L9498                           ; 94AE D0 E8                    ..
        lda     #$02                            ; 94B0 A9 02                    ..
        sta     r3H                             ; 94B2 85 09                    ..
        lda     #$98                            ; 94B4 A9 98                    ..
        sta     r3L                             ; 94B6 85 08                    ..
        bit     $8203                           ; 94B8 2C 03 82                 ,..
        bpl     L94D5                           ; 94BB 10 18                    ..
        ldy     #$DD                            ; 94BD A0 DD                    ..
L94BF:  lda     (r5L),y                         ; 94BF B1 0C                    ..
        clc                                     ; 94C1 18                       .
        adc     r4L                             ; 94C2 65 0A                    e.
        sta     r4L                             ; 94C4 85 0A                    ..
        bcc     L94CA                           ; 94C6 90 02                    ..
        inc     r4H                             ; 94C8 E6 0B                    ..
L94CA:  iny                                     ; 94CA C8                       .
        bne     L94BF                           ; 94CB D0 F2                    ..
        lda     #$05                            ; 94CD A9 05                    ..
        sta     r3H                             ; 94CF 85 09                    ..
        lda     #$30                            ; 94D1 A9 30                    .0
        sta     r3L                             ; 94D3 85 08                    ..
L94D5:  rts                                     ; 94D5 60                       `

; ----------------------------------------------------------------------------
__SetGEOSDisk:
        jsr     GetDirHead                      ; 94D6 20 47 C2                  G.
        txa                                     ; 94D9 8A                       .
        bne     L9536                           ; 94DA D0 5A                    .Z
        lda     #$82                            ; 94DC A9 82                    ..
        sta     r5H                             ; 94DE 85 0D                    ..
        lda     #$00                            ; 94E0 A9 00                    ..
        sta     r5L                             ; 94E2 85 0C                    ..
        jsr     CalcBlksFree                    ; 94E4 20 DB C1                  ..
        ldx     #$03                            ; 94E7 A2 03                    ..
        lda     r4L                             ; 94E9 A5 0A                    ..
        ora     r4H                             ; 94EB 05 0B                    ..
        beq     L9536                           ; 94ED F0 47                    .G
        lda     #$00                            ; 94EF A9 00                    ..
        sta     r0L                             ; 94F1 85 02                    ..
        lda     #$13                            ; 94F3 A9 13                    ..
        sta     r3L                             ; 94F5 85 08                    ..
L94F7:  lda     #$00                            ; 94F7 A9 00                    ..
        sta     r3H                             ; 94F9 85 09                    ..
        jsr     SetNextFree                     ; 94FB 20 92 C2                  ..
        txa                                     ; 94FE 8A                       .
        beq     L950D                           ; 94FF F0 0C                    ..
        lda     r0L                             ; 9501 A5 02                    ..
        bne     L9536                           ; 9503 D0 31                    .1
        lda     #$01                            ; 9505 A9 01                    ..
        sta     r3L                             ; 9507 85 08                    ..
        sta     r0L                             ; 9509 85 02                    ..
        bne     L94F7                           ; 950B D0 EA                    ..
L950D:  lda     r3H                             ; 950D A5 09                    ..
        sta     r1H                             ; 950F 85 05                    ..
        lda     r3L                             ; 9511 A5 08                    ..
        sta     r1L                             ; 9513 85 04                    ..
        jsr     L932D                           ; 9515 20 2D 93                  -.
        txa                                     ; 9518 8A                       .
        bne     L9536                           ; 9519 D0 1B                    ..
        lda     r1H                             ; 951B A5 05                    ..
        sta     $82AC                           ; 951D 8D AC 82                 ...
        lda     r1L                             ; 9520 A5 04                    ..
        sta     $82AB                           ; 9522 8D AB 82                 ...
        ldy     #$BC                            ; 9525 A0 BC                    ..
        ldx     #$0F                            ; 9527 A2 0F                    ..
L9529:  lda     L927F,x                         ; 9529 BD 7F 92                 ...
        sta     curDirHead,y                    ; 952C 99 00 82                 ...
        dey                                     ; 952F 88                       .
        dex                                     ; 9530 CA                       .
        bpl     L9529                           ; 9531 10 F6                    ..
        jsr     PutDirHead                      ; 9533 20 4A C2                  J.
L9536:  rts                                     ; 9536 60                       `

; ----------------------------------------------------------------------------
__InitForIO:
        php                                     ; 9537 08                       .
        pla                                     ; 9538 68                       h
        sta     L96F1                           ; 9539 8D F1 96                 ...
        sei                                     ; 953C 78                       x
        lda     CPU_DATA                        ; 953D A5 01                    ..
        sta     L96F3                           ; 953F 8D F3 96                 ...
        lda     #$36                            ; 9542 A9 36                    .6
        sta     CPU_DATA                        ; 9544 85 01                    ..
        lda     grirqen                         ; 9546 AD 1A D0                 ...
        sta     L96F2                           ; 9549 8D F2 96                 ...
        lda     clkreg                          ; 954C AD 30 D0                 .0.
        sta     L96F0                           ; 954F 8D F0 96                 ...
        ldy     #$00                            ; 9552 A0 00                    ..
        sty     clkreg                          ; 9554 8C 30 D0                 .0.
        sty     grirqen                         ; 9557 8C 1A D0                 ...
        lda     #$7F                            ; 955A A9 7F                    ..
        sta     grirq                           ; 955C 8D 19 D0                 ...
        sta     $DC0D                           ; 955F 8D 0D DC                 ...
        sta     $DD0D                           ; 9562 8D 0D DD                 ...
        lda     #$95                            ; 9565 A9 95                    ..
        sta     $0315                           ; 9567 8D 15 03                 ...
        lda     #$A7                            ; 956A A9 A7                    ..
        sta     irqvec                          ; 956C 8D 14 03                 ...
        lda     #$95                            ; 956F A9 95                    ..
        sta     $0319                           ; 9571 8D 19 03                 ...
        lda     #$AC                            ; 9574 A9 AC                    ..
        sta     nmivec                          ; 9576 8D 18 03                 ...
        lda     #$3F                            ; 9579 A9 3F                    .?
        sta     $DD02                           ; 957B 8D 02 DD                 ...
        lda     mobenble                        ; 957E AD 15 D0                 ...
        sta     L96F4                           ; 9581 8D F4 96                 ...
        sty     mobenble                        ; 9584 8C 15 D0                 ...
        sty     $DD05                           ; 9587 8C 05 DD                 ...
        iny                                     ; 958A C8                       .
        sty     $DD04                           ; 958B 8C 04 DD                 ...
        lda     #$81                            ; 958E A9 81                    ..
        sta     $DD0D                           ; 9590 8D 0D DD                 ...
        lda     #$09                            ; 9593 A9 09                    ..
        sta     $DD0E                           ; 9595 8D 0E DD                 ...
        ldy     #$2C                            ; 9598 A0 2C                    .,
L959A:  lda     rasreg                          ; 959A AD 12 D0                 ...
        cmp     TURBO_DD00_CPY                  ; 959D C5 8F                    ..
        beq     L959A                           ; 959F F0 F9                    ..
        sta     TURBO_DD00_CPY                  ; 95A1 85 8F                    ..
        dey                                     ; 95A3 88                       .
        bne     L959A                           ; 95A4 D0 F4                    ..
        rts                                     ; 95A6 60                       `

; ----------------------------------------------------------------------------
        pla                                     ; 95A7 68                       h
        tay                                     ; 95A8 A8                       .
        pla                                     ; 95A9 68                       h
        tax                                     ; 95AA AA                       .
        pla                                     ; 95AB 68                       h
        rti                                     ; 95AC 40                       @

; ----------------------------------------------------------------------------
__DoneWithIO:
        sei                                     ; 95AD 78                       x
        lda     L96F0                           ; 95AE AD F0 96                 ...
        sta     clkreg                          ; 95B1 8D 30 D0                 .0.
        lda     L96F4                           ; 95B4 AD F4 96                 ...
        sta     mobenble                        ; 95B7 8D 15 D0                 ...
        lda     #$7F                            ; 95BA A9 7F                    ..
        sta     $DD0D                           ; 95BC 8D 0D DD                 ...
        lda     $DD0D                           ; 95BF AD 0D DD                 ...
        lda     L96F2                           ; 95C2 AD F2 96                 ...
        sta     grirqen                         ; 95C5 8D 1A D0                 ...
        lda     L96F3                           ; 95C8 AD F3 96                 ...
        sta     CPU_DATA                        ; 95CB 85 01                    ..
        lda     L96F1                           ; 95CD AD F1 96                 ...
        pha                                     ; 95D0 48                       H
        plp                                     ; 95D1 28                       (
        rts                                     ; 95D2 60                       `

; ----------------------------------------------------------------------------
__EnterTurbo:
        lda     curDrive                        ; 95D3 AD 89 84                 ...
        jsr     SetDevice                       ; 95D6 20 B0 C2                  ..
        ldx     #$00                            ; 95D9 A2 00                    ..
        rts                                     ; 95DB 60                       `

; ----------------------------------------------------------------------------
__ExitTurbo:
        lda     #$08                            ; 95DC A9 08                    ..
        sta     interleave                      ; 95DE 8D 8C 84                 ...
        rts                                     ; 95E1 60                       `

; ----------------------------------------------------------------------------
__ChangeDiskDevice:
        sta     curDrive                        ; 95E2 8D 89 84                 ...
        sta     curDevice                       ; 95E5 85 BA                    ..
        ldx     #$00                            ; 95E7 A2 00                    ..
        rts                                     ; 95E9 60                       `

; ----------------------------------------------------------------------------
__NewDisk:
        jsr     EnterTurbo                      ; 95EA 20 14 C2                  ..
        rts                                     ; 95ED 60                       `

; ----------------------------------------------------------------------------
__ReadBlock:
        jsr     L90E1                           ; 95EE 20 E1 90                  ..
        bcc     L95F6                           ; 95F1 90 03                    ..
        jsr     L9615                           ; 95F3 20 15 96                  ..
L95F6:  ldy     #$00                            ; 95F6 A0 00                    ..
        rts                                     ; 95F8 60                       `

; ----------------------------------------------------------------------------
_ReadLink:
        jsr     L90E1                           ; 95F9 20 E1 90                  ..
        bcc     L9603                           ; 95FC 90 05                    ..
        ldy     #$91                            ; 95FE A0 91                    ..
        jsr     L961D                           ; 9600 20 1D 96                  ..
L9603:  rts                                     ; 9603 60                       `

; ----------------------------------------------------------------------------
__WriteBlock:
        jsr     L90E1                           ; 9604 20 E1 90                  ..
        bcc     L960C                           ; 9607 90 03                    ..
        jsr     L9619                           ; 9609 20 19 96                  ..
L960C:  rts                                     ; 960C 60                       `

; ----------------------------------------------------------------------------
__VerWriteBlock:
        jsr     L90E1                           ; 960D 20 E1 90                  ..
        bcc     L9614                           ; 9610 90 02                    ..
        ldx     #$00                            ; 9612 A2 00                    ..
L9614:  rts                                     ; 9614 60                       `

; ----------------------------------------------------------------------------
L9615:  ldy     #$91                            ; 9615 A0 91                    ..
        bne     L962D                           ; 9617 D0 14                    ..
L9619:  ldy     #$90                            ; 9619 A0 90                    ..
        bne     L962D                           ; 961B D0 10                    ..
L961D:  lda     r2H                             ; 961D A5 07                    ..
        pha                                     ; 961F 48                       H
        lda     r2L                             ; 9620 A5 06                    ..
        pha                                     ; 9622 48                       H
        lda     #$00                            ; 9623 A9 00                    ..
        sta     r2H                             ; 9625 85 07                    ..
        lda     #$02                            ; 9627 A9 02                    ..
        sta     r2L                             ; 9629 85 06                    ..
        bne     L963B                           ; 962B D0 0E                    ..
L962D:  lda     r2H                             ; 962D A5 07                    ..
        pha                                     ; 962F 48                       H
        lda     r2L                             ; 9630 A5 06                    ..
        pha                                     ; 9632 48                       H
        lda     #$01                            ; 9633 A9 01                    ..
        sta     r2H                             ; 9635 85 07                    ..
        lda     #$00                            ; 9637 A9 00                    ..
        sta     r2L                             ; 9639 85 06                    ..
L963B:  lda     r0H                             ; 963B A5 03                    ..
        pha                                     ; 963D 48                       H
        lda     r0L                             ; 963E A5 02                    ..
        pha                                     ; 9640 48                       H
        lda     r1H                             ; 9641 A5 05                    ..
        pha                                     ; 9643 48                       H
        lda     r1L                             ; 9644 A5 04                    ..
        pha                                     ; 9646 48                       H
        lda     r3L                             ; 9647 A5 08                    ..
        pha                                     ; 9649 48                       H
        tya                                     ; 964A 98                       .
        pha                                     ; 964B 48                       H
        lda     r1L                             ; 964C A5 04                    ..
        cmp     #$24                            ; 964E C9 24                    .$
        bcc     L9655                           ; 9650 90 03                    ..
        sec                                     ; 9652 38                       8
        sbc     #$23                            ; 9653 E9 23                    .#
L9655:  tay                                     ; 9655 A8                       .
        dey                                     ; 9656 88                       .
        lda     L96A8,y                         ; 9657 B9 A8 96                 ...
        clc                                     ; 965A 18                       .
        adc     r1H                             ; 965B 65 05                    e.
        sta     r1H                             ; 965D 85 05                    ..
        lda     L96CC,y                         ; 965F B9 CC 96                 ...
        ldy     curDrive                        ; 9662 AC 89 84                 ...
        adc     driveData,y                     ; 9665 79 BF 88                 y..
        sta     r3L                             ; 9668 85 08                    ..
        lda     r1L                             ; 966A A5 04                    ..
        cmp     #$24                            ; 966C C9 24                    .$
        bcc     L967D                           ; 966E 90 0D                    ..
        lda     r1H                             ; 9670 A5 05                    ..
        clc                                     ; 9672 18                       .
        adc     #$BC                            ; 9673 69 BC                    i.
        sta     r1H                             ; 9675 85 05                    ..
        lda     r3L                             ; 9677 A5 08                    ..
        adc     #$02                            ; 9679 69 02                    i.
        sta     r3L                             ; 967B 85 08                    ..
L967D:  lda     #$00                            ; 967D A9 00                    ..
        sta     r1L                             ; 967F 85 04                    ..
        lda     r4H                             ; 9681 A5 0B                    ..
        sta     r0H                             ; 9683 85 03                    ..
        lda     r4L                             ; 9685 A5 0A                    ..
        sta     r0L                             ; 9687 85 02                    ..
        pla                                     ; 9689 68                       h
        tay                                     ; 968A A8                       .
        jsr     DoRAMOp                         ; 968B 20 D4 C2                  ..
        tax                                     ; 968E AA                       .
        pla                                     ; 968F 68                       h
        sta     r3L                             ; 9690 85 08                    ..
        pla                                     ; 9692 68                       h
        sta     r1L                             ; 9693 85 04                    ..
        pla                                     ; 9695 68                       h
        sta     r1H                             ; 9696 85 05                    ..
        pla                                     ; 9698 68                       h
        sta     r0L                             ; 9699 85 02                    ..
        pla                                     ; 969B 68                       h
        sta     r0H                             ; 969C 85 03                    ..
        pla                                     ; 969E 68                       h
        sta     r2L                             ; 969F 85 06                    ..
        pla                                     ; 96A1 68                       h
        sta     r2H                             ; 96A2 85 07                    ..
        txa                                     ; 96A4 8A                       .
        ldx     #$00                            ; 96A5 A2 00                    ..
        rts                                     ; 96A7 60                       `

; ----------------------------------------------------------------------------
L96A8:  brk                                     ; 96A8 00                       .
        ora     curIndexTable,x                 ; 96A9 15 2A                    .*
        .byte   $3F                             ; 96AB 3F                       ?
        .byte   $54                             ; 96AC 54                       T
        adc     #$7E                            ; 96AD 69 7E                    i~
        .byte   $93                             ; 96AF 93                       .
        tay                                     ; 96B0 A8                       .
        lda     $E7D2,x                         ; 96B1 BD D2 E7                 ...
        .byte   $FC                             ; 96B4 FC                       .
        ora     (baselineOffset),y              ; 96B5 11 26                    .&
        .byte   $3B                             ; 96B7 3B                       ;
        ;bvc     L971F                           ; 96B8 50 65                    Pe
        .byte   $50
        .byte   $65
        sei                                     ; 96BA 78                       x
        .byte   $8B                             ; 96BB 8B                       .
        .byte   $9E                             ; 96BC 9E                       .
        lda     ($C4),y                         ; 96BD B1 C4                    ..
        .byte   $D7                             ; 96BF D7                       .
        nop                                     ; 96C0 EA                       .
        .byte   $FC                             ; 96C1 FC                       .
        asl     $3220                           ; 96C2 0E 20 32                 . 2
        .byte   $44                             ; 96C5 44                       D
        lsr     $67,x                           ; 96C6 56 67                    Vg
        sei                                     ; 96C8 78                       x
        .byte   $89                             ; 96C9 89                       .
        txs                                     ; 96CA 9A                       .
        .byte   $AB                             ; 96CB AB                       .
L96CC:  brk                                     ; 96CC 00                       .
        brk                                     ; 96CD 00                       .
        brk                                     ; 96CE 00                       .
        brk                                     ; 96CF 00                       .
        brk                                     ; 96D0 00                       .
        brk                                     ; 96D1 00                       .
        brk                                     ; 96D2 00                       .
        brk                                     ; 96D3 00                       .
        brk                                     ; 96D4 00                       .
        brk                                     ; 96D5 00                       .
        brk                                     ; 96D6 00                       .
        brk                                     ; 96D7 00                       .
        brk                                     ; 96D8 00                       .
        ora     (CPU_DATA,x)                    ; 96D9 01 01                    ..
        ora     (CPU_DATA,x)                    ; 96DB 01 01                    ..
        ora     (CPU_DATA,x)                    ; 96DD 01 01                    ..
        ora     (CPU_DATA,x)                    ; 96DF 01 01                    ..
        ora     (CPU_DATA,x)                    ; 96E1 01 01                    ..
        ora     (CPU_DATA,x)                    ; 96E3 01 01                    ..
        ora     (r0L,x)                         ; 96E5 01 02                    ..
        .byte   $02                             ; 96E7 02                       .
        .byte   $02                             ; 96E8 02                       .
        .byte   $02                             ; 96E9 02                       .
        .byte   $02                             ; 96EA 02                       .
        .byte   $02                             ; 96EB 02                       .
        .byte   $02                             ; 96EC 02                       .
        .byte   $02                             ; 96ED 02                       .
        .byte   $02                             ; 96EE 02                       .
        .byte   $02                             ; 96EF 02                       .
L96F0:  brk                                     ; 96F0 00                       .
L96F1:  brk                                     ; 96F1 00                       .
L96F2:  brk                                     ; 96F2 00                       .
L96F3:  brk                                     ; 96F3 00                       .
L96F4:  brk                                     ; 96F4 00                       .
        brk                                     ; 96F5 00                       .
        brk                                     ; 96F6 00                       .
        brk                                     ; 96F7 00                       .
        brk                                     ; 96F8 00                       .
        brk                                     ; 96F9 00                       .
        brk                                     ; 96FA 00                       .
        brk                                     ; 96FB 00                       .
L96FC:  brk                                     ; 96FC 00                       .
        brk                                     ; 96FD 00                       .
        brk                                     ; 96FE 00                       .
L96FF:  brk                                     ; 96FF 00                       .
;        .byte   $F2                             ; 9700 F2                       .
