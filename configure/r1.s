; da65 V2.13.2 - (C) Copyright 2000-2009,  Ullrich von Bassewitz
; Created:    2010-05-27 22:22:16
; Input file: configure.cvt.record.1
; Page:       1

.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"
.include "geosmac.inc"


.segment "OVERLAY1"

       ;!cpu 6502
       ;!to "r1.bin",plain
       ;!sl "r1.labels"
       ;!source "inc/labels.inc"
       ;!source "inc/r0.inc"
       ;*=$13b1
       ;!zone r1
; ----------------------------------------------------------------------------

vdcreg  = $d600
vdcdata = $d601

; fix!
;L043E           = $043E; fix!
;L0616           = $0616; fix!
;L0672           = $0672; fix!
;L0739           = $0739; fix!
;InitDrive           = $073E; fix!
;L0911           = $0911; fix!
;L0E19           = $0E19; fix!
;L0FA0           = $0FA0; fix!
;L0FB3           = $0FB3; fix!

.import L043E
.import L0616
.import L0672
.import L0739
.import InitDrive
.import	L0911
.import L0E19
.import L0FA0
.import L0FB3
.import L0A66
.import L0A6A
.import Init1541
.import InitShadowed1541
.import InitRAM1541
.import Init1571
.import Init1581
.import InitShadowed1581
.import InitRAM1571
.import InitRAM1581
.import InitF011

.export V20D9
.export V2102
.export V2103
.export V2104
.export V2105
.export V2106
.export V2107
.export V2108
.export V2109
.export V210A
.export V212B
.export V212C
.export V212D
.export V212E
.export V212F
.export V2130
.export V2150
.export UIEntry
.export L180C
.export SetupDrive
.export V20FA
.export V20F2
.export V20EA
.export CheckDrive

L6819           = $6819

.ifdef mega65
CFG_DOUBLE_W    = 0
CFG_ADD1_W      = 0
.else
CFG_DOUBLE_W    = DOUBLE_W
CFG_ADD1_W      = ADD1_W
.endif

; ----------------------------------------------------------------------------
AreaTable:
;#0
        .byte   $69, $c4
.ifdef config128
        .word   $b4 + CFG_DOUBLE_W, $136 + CFG_DOUBLE_W
.else
        .word   $b4, $136
.endif

;#1
        .byte   $85, $8f
.ifdef config128
        .word   $011e + CFG_DOUBLE_W, $0130 + CFG_DOUBLE_W
.else
        .word   $011e, $0130
.endif

;#2
        .byte   $A1, $AB
.ifdef config128
        .word   $011e + CFG_DOUBLE_W, $0130 + CFG_DOUBLE_W
.else
        .word   $011e, $0130
.endif

;#3
        .byte   $07
        .byte   $62                             ; 13C4 62                       b
.ifdef config128
        .word   $1e+CFG_DOUBLE_W, $a0+CFG_DOUBLE_W
.else
        .word   $1e, $a0
.endif

;#4
        .byte   $07                             ; 13C9 07                       .
        .byte   $62                             ; 13CA 62                       b
.ifdef config128
        .word   $b4 + CFG_DOUBLE_W, $136 + CFG_DOUBLE_W
.else
        .word   $b4, $136
.endif

;#5
        .byte   $69, $c4
.ifdef config128
        .word   $1e + CFG_DOUBLE_W, $a0 + CFG_DOUBLE_W
.else
        .word   $1e, $a0
.endif

;#6
        .byte   $17, $21                             ; 13D5 17                       .
.ifdef config128
        .word   $88 + CFG_DOUBLE_W, $9a + CFG_DOUBLE_W
.else
        .word   $88, $9a
.endif

;#7
        .byte   $23                             ; 13DB 23                       #
        .byte   $2d
.ifdef config128
        .word   $88 + CFG_DOUBLE_W, $9a + CFG_DOUBLE_W
.else
        .word   $88, $9a
.endif

;#8
        .byte   $2F                             ; 13E1 2F                       /
        .byte   $39
.ifdef config128
        .word   $88 + CFG_DOUBLE_W, $9a + CFG_DOUBLE_W
.else
        .word   $88, $9a
.endif

;#9                          .
        .byte   $3B                             ; 13E7 3B                       ;
        .byte   $45
.ifdef config128
        .word   $88 + CFG_DOUBLE_W, $9a + CFG_DOUBLE_W
.else
        .word   $88, $9a
.endif

;#10
        .byte   $47, $51
.ifdef config128
        .word   $88 + CFG_DOUBLE_W, $9a + CFG_DOUBLE_W
.else
        .word   $88, $9a
.endif

;#11
        .byte   $53, $5d                             ; 13F3 53
.ifdef config128
        .word   $88 + CFG_DOUBLE_W, $9a + CFG_DOUBLE_W
.else
        .word   $88, $9a
.endif

;#12
        .byte   $17, $21                             ; 13F9 17
.ifdef config128
        .word   $011e + CFG_DOUBLE_W, $0130 + CFG_DOUBLE_W
.else
        .word   $011e, $0130
.endif

;#13
        .byte   $23, $2d
.ifdef config128
        .word   $011e + CFG_DOUBLE_W, $0130 + CFG_DOUBLE_W
.else
        .word   $011e, $0130
.endif

;#14
        .byte   $2F, $39                             ; 1405 2F                       /
.ifdef config128
        .word   $011e + CFG_DOUBLE_W, $0130 + CFG_DOUBLE_W
.else
        .word   $011e, $0130
.endif

;#15
        .byte   $3B, $45                             ; 140B 3B                       ;
.ifdef config128
        .word   $011e + CFG_DOUBLE_W, $0130 + CFG_DOUBLE_W
.else
        .word   $011e, $0130
.endif

;#16
        .byte   $47, $51
.ifdef config128
        .word   $011e + CFG_DOUBLE_W, $0130 + CFG_DOUBLE_W
.else
        .word   $011e, $0130
.endif

;#17
        .byte   $53, $5d
.ifdef config128
        .word   $011e + CFG_DOUBLE_W, $0130 + CFG_DOUBLE_W
.else
        .word   $011e, $0130
.endif

;#18
        .byte   $79, $83                             ; 141D 79                       y
.ifdef config128
        .word   $88 + CFG_DOUBLE_W, $9a + CFG_DOUBLE_W
.else
        .word   $88, $9a
.endif

;#19
        .byte   $85, $8f
.ifdef config128
        .word   $88 + CFG_DOUBLE_W, $9a + CFG_DOUBLE_W
.else
        .word   $88, $9a
.endif

;#20
        .byte   $91, $9b
.ifdef config128
        .word   $88 + CFG_DOUBLE_W, $9a + CFG_DOUBLE_W
.else
        .word   $88, $9a
.endif

;#21
        .byte   $9d, $a7
.ifdef config128
        .word   $88 + CFG_DOUBLE_W, $9a + CFG_DOUBLE_W
.else
        .word   $88, $9a
.endif

;#22
        .byte   $a9, $b3
.ifdef config128
        .word   $88 + CFG_DOUBLE_W, $9a + CFG_DOUBLE_W
.else
        .word   $88, $9a
.endif

;#23
        .byte   $b5, $bf
.ifdef config128
        .word   $88 + CFG_DOUBLE_W, $9a + CFG_DOUBLE_W
.else
        .word   $88, $9a
.endif

;#24
        .byte   $79, $83                             ; 141D 79                       y
.ifdef config128
        .word   $011e + CFG_DOUBLE_W, $0130 + CFG_DOUBLE_W
.else
        .word   $011e, $9a
.endif

;#25
        .byte   $85, $8f
.ifdef config128
        .word   $011e + CFG_DOUBLE_W, $0130 + CFG_DOUBLE_W
.else
        .word   $011e, $9a
.endif

;#26
        .byte   $91, $9b
.ifdef config128
        .word   $011e + CFG_DOUBLE_W, $0130 + CFG_DOUBLE_W
.else
        .word   $011e, $9a
.endif

;#27
        .byte   $9d, $a7
.ifdef config128
        .word   $011e + CFG_DOUBLE_W, $0130 + CFG_DOUBLE_W
.else
        .word   $011e, $9a
.endif

;#28
        .byte   $a9, $b3
.ifdef config128
        .word   $011e + CFG_DOUBLE_W, $0130 + CFG_DOUBLE_W
.else
        .word   $011e, $9a
.endif

;#29
        .byte   $b5, $bf
.ifdef config128
        .word   $011e + CFG_DOUBLE_W, $0130 + CFG_DOUBLE_W
.else
        .word   $011e, $9a
.endif



L1441:  LoadW   r0, AreaTable
        cpy     #$00                            ; 1449 C0 00                    ..
        beq     L145B                           ; 144B F0 0E                    ..
L144D:  clc                                     ; 144D 18                       .
        lda     #$06                            ; 144E A9 06                    ..
        adc     r0L                             ; 1450 65 02                    e.
        sta     r0L                             ; 1452 85 02                    ..
        bcc     L1458                           ; 1454 90 02                    ..
        inc     r0H                             ; 1456 E6 03                    ..
L1458:  dey                                     ; 1458 88                       .
        bne     L144D                           ; 1459 D0 F2                    ..
L145B:  ldy     #$05                            ; 145B A0 05                    ..
L145D:  lda     (r0L),y                         ; 145D B1 02                    ..
        sta     r2L,y                           ; 145F 99 06 00                 ...
        dey                                     ; 1462 88                       .
        bpl     L145D                           ; 1463 10 F8                    ..
        rts                                     ; 1465 60                       `
; ----------------------------------------------------------------------------
UIEntry:
        lda     version                         ; 1466 AD 0F C0                 ...
        cmp     #$13                            ; 1469 C9 13                    ..
        bcc     L1472                           ; 146B 90 05                    ..
        bit     c128Flag                        ; 146D 2C 13 C0                 ,..
.ifdef config128
        bmi     L147F                           ; 1470 10 0D                    ..
.else
        bpl     L147F                           ; 1470 10 0D                    ..
.endif
L1472:  jsr     CloseRecordFile                 ; 1472 20 77 C2                  w.
        ldx     #>incompKernDlg                 ; 1475 A2 15                    ..
        lda     #<incompKernDlg                 ; 1477 A9 42                    .B
        jsr     L2022                           ; 1479 20 22 20                  "
L147C:  jmp     EnterDeskTop                    ; 147C 4C 2C C2                 L,.
; ----------------------------------------------------------------------------
; we are geso64/geos128 as config requires
L147F:  lda     #$80                            ; 147F A9 80                    ..
        sta     dispBufferOn                    ; 1481 85 2F                    ./
        lda     curDrive                        ; 1483 AD 89 84                 ...
        sta     V2104                           ; 1486 8D 04 21                 ..!
        tay                                     ; 1489 A8                       .
        lda     $8486,y                         ; 148A B9 86 84                 ...
        sta     V2105                           ; 148D 8D 05 21                 ..!
        jsr     L0FB3 ; check for reu                          ; 1490 20 B3 0F                  ..
        lda     #$01                            ; 1493 A9 01                    ..
        sta     NUMDRV                          ; 1495 8D 8D 84                 ...
        jsr     L14FC                           ; 1498 20 FC 14                  ..
        txa                                     ; 149B 8A                       .
        bne     L147C                           ; 149C D0 DE                    ..
        lda     sysRAMFlg                       ; 149E AD C4 88                 ...
        sta     $040A                           ; 14A1 8D 0A 04                 ...
        ldy     #$03                            ; 14A4 A0 03                    ..
L14A6:  lda     driveType,y                     ; 14A6 B9 8E 84                 ...
        sta     $0406,y                         ; 14A9 99 06 04                 ...
        dey                                     ; 14AC 88                       .
        bpl     L14A6                           ; 14AD 10 F7                    ..
        jsr     L0FA0                           ; 14AF 20 A0 0F                  ..
        jsr     i_GraphicsString                ; 14B2 20 A8 C1                  ..
        ;ora     r0L                             ; 14B5 05 02                    ..
        ;ora     (CPU_DDR,x)                     ; 14B7 01 00                    ..
        ;brk                                     ; 14B9 00                       .
        ;brk                                     ; 14BA 00                       .
        ;.byte   $03                             ; 14BB 03                       .
        ;.byte   $3F                             ; 14BC 3F                       ?
        ;ora     ($C7,x)                         ; 14BD 01 C7                    ..
        ;brk                                     ; 14BF 00                       .
        .byte   NEWPATTERN
        .byte   $02
        .byte   MOVEPENTO
        .word   0
        .byte   0
        .byte   RECTANGLETO
.ifdef config128
.ifdef mega65
        .word   SC_FROM_END+0 + (((SC_FROM_END|0) >> 8) << 12)  
.else
        .word   319 + CFG_DOUBLE_W + CFG_ADD1_W
.endif
.else
        .word   319
.endif
.ifdef mega65
        .byte   0
.else
        .byte   199
.endif
        .byte   NULL

.ifdef config128
        ; setup resolution specific coordinates
        jsr     L2340                           ; 1514 20 40 23                  @#

        LoadW   MenuRight, $15
        LoadW   SubMenuRight, $62
        bit     graphMode                       ; 152B 24 3F                    $?
        bpl     L1543                           ; 152D 10 14                    ..
        LoadW   MenuRight, $1b
        LoadW   SubMenuRight, $96
L1543:

.endif
        LoadW   r0, IconTable
        jsr     DoIcons                         ; 14C8 20 5A C1                  Z.
        LoadW   r0, MenuTable
        lda     #$00                            ; 14D3 A9 00                    ..
        jsr     DoMenu                          ; 14D5 20 51 C1                  Q.
        jsr     L1590                           ; 14D8 20 90 15                  ..
        LoadW   otherPressVec, ConfigOtherPressVec
        LoadW   RecoverVector, ConfigRecoverVector
        rts                                     ; 14EF 60                       `
; ----------------------------------------------------------------------------
; icon table
IconTable:
        ora     (r1H,x)                         ; 14F0 01 05                    ..
        brk                                     ; 14F2 00                       .
        ora     CPU_DDR                         ; 14F3 05 00                    ..
        brk                                     ; 14F5 00                       .
        .byte   $27                             ; 14F6 27                       '
        brk                                     ; 14F7 00                       .
        ora     (CPU_DATA,x)                    ; 14F8 01 01                    ..
        brk                                     ; 14FA 00                       .
        brk                                     ; 14FB 00                       .
L14FC:  jsr     L0616                           ; 14FC 20 16 06                  ..
.ifndef config128
        ; for GEOS64 skip this if there is not REU
        lda     ramExpSize                      ; 14FF AD C3 88                 ...
        beq     L1518                           ; 1502 F0 14                    ..
.endif
        lda     curDrive                        ; 1504 AD 89 84                 ...
        eor     #$01                            ; 1507 49 01                    I.
        tay                                     ; 1509 A8                       .
        lda     $8486,y                         ; 150A B9 86 84                 ...
        beq     L1518                           ; 150D F0 09                    ..
        jsr     L0739                           ; 150F 20 39 07                  9.
        jsr     L0616                           ; 1512 20 16 06                  ..
        jsr     L0739                           ; 1515 20 39 07                  9.
L1518:  lda     #$01                            ; 1518 A9 01                    ..
        jsr     L0672                           ; 151A 20 72 06                  r.
        bne     L1541                           ; 151D D0 22                    ."
        lda     #$02                            ; 151F A9 02                    ..
        jsr     L0672                           ; 1521 20 72 06                  r.
        bne     L1541                           ; 1524 D0 1B                    ..
        lda     #$03                            ; 1526 A9 03                    ..
        jsr     L0672                           ; 1528 20 72 06                  r.
        bne     L1541     						; 152B D0 14                    ..
.ifdef mega65
        lda     #$04                            ; 1526 A9 03                    ..
        jsr     L0672                           ; 1528 20 72 06                  r.
        bne     L1541     						; 152B D0 14                    ..
.endif
        lda     ramExpSize                      ; 152D AD C3 88                 ...
        beq     L153E                           ; 1530 F0 0C                    ..
        lda     #$81                            ; 1532 A9 81                    ..
        jsr     L0672                           ; 1534 20 72 06                  r.
        lda     #$83                            ; 1537 A9 83                    ..
        jsr     L0672                           ; 1539 20 72 06                  r.
        bne     L1541                           ; 153C D0 03                    ..
L153E:  jsr     CloseRecordFile                 ; 153E 20 77 C2                  w.
L1541:  rts                                     ; 1541 60                       `
; ----------------------------------------------------------------------------
incompKernDlg:
        .byte   $81
        .byte   DBTXTSTR
        .byte   $0c
        .byte   $20
        .word   L1551
        .byte   DBTXTSTR
        .byte   $0c
        .byte   $30
        .word   L1570
        .byte   OK
        .byte   1
        .byte   $48
        .byte   NULL
L1551:  clc                                     ; 1551 18                       .
        .byte   $22                             ; 1552 22                       "
        .byte   "CONFIGURE"                     ; 1553 43 4F 4E 46 49 47 55 52  CONFIGUR
                                                ; 155B 45                       E
        .byte   $22                             ; 155C 22                       "
        .byte   " is not applicable"            ; 155D 20 69 73 20 6E 6F 74 20   is not
                                                ; 1565 61 70 70 6C 69 63 61 62  applicab
                                                ; 156D 6C 65                    le
        .byte   $00
L1570:
        .byte   $18                             ; 156F 00 18                    ..
        .byte   "to this version of GEOS KERNAL"; 1571 74 6F 20 74 68 69 73 20  to this
                                                ; 1579 76 65 72 73 69 6F 6E 20  version
                                                ; 1581 6F 66 20 47 45 4F 53 20  of GEOS
                                                ; 1589 4B 45 52 4E 41 4C        KERNAL
        .byte   $00                             ; 158F 00                       .
; ----------------------------------------------------------------------------
L1590:  jsr     L16A2                           ; 1590 20 A2 16                  ..
        jsr     L16CC                           ; 1593 20 CC 16                  ..
        lda     ramExpSize                      ; 1596 AD C3 88                 ...
        beq     L159E                           ; 1599 F0 03                    ..
        jsr     L16F6                           ; 159B 20 F6 16     
	jsr	RenderDriveD             
L159E:  ;ldy     #$00                            ; 159E A0 00                    ..
        ;jsr     L15AA                           ; 15A0 20 AA 15                  ..
        ;jsr     L1752                           ; 15A3 20 52 17                  R.
        jsr     ExitTurbo                       ; 15A6 20 32 C2                  2.
        rts                                     ; 15A9 60                       `
; ----------------------------------------------------------------------------
L15AA:  jsr     L1441                           ; 15AA 20 41 14                  A.
        lda     #$00                            ; 15AD A9 00                    ..
        jsr     SetPattern                      ; 15AF 20 39 C1                  9.
        jsr     Rectangle                       ; 15B2 20 24 C1                  $.
        lda     #$FF                            ; 15B5 A9 FF                    ..
        jsr     FrameRectangle                  ; 15B7 20 27 C1                  '.
        inc     r2H                             ; 15BA E6 07                    ..
L15BC:  inc     r4L                             ; 15BC E6 0A                    ..
        bne     L15C2                           ; 15BE D0 02                    ..
        inc     r4H                             ; 15C0 E6 0B                    ..
L15C2:  lda     #$FF                            ; 15C2 A9 FF                    ..
        jsr     FrameRectangle                  ; 15C4 20 27 C1                  '.
        dec     r2H                             ; 15C7 C6 07                    ..
        ldx     #$0A                            ; 15C9 A2 0A                    ..
        jsr     Ddec                            ; 15CB 20 75 C1                  u.
        rts                                     ; 15CE 60                       `
; ----------------------------------------------------------------------------
L15CF:  pha                                     ; 15CF 48                       H
        jsr     L1441                           ; 15D0 20 41 14                  A.
        pla                                     ; 15D3 68                       h
        jsr     SetPattern                      ; 15D4 20 39 C1                  9.
        jsr     Rectangle                       ; 15D7 20 24 C1                  $.
        lda     #$FF                            ; 15DA A9 FF                    ..
        jmp     FrameRectangle                  ; 15DC 4C 27 C1                 L'.
; ----------------------------------------------------------------------------
L15DF:  lda     V212E                           ; 15DF AD 2E 21                 ..!
        sta     r15H                            ; 15E2 85 21                    .!
        lda     V212D                           ; 15E4 AD 2D 21                 .-!
        sta     r15L                            ; 15E7 85 20                    .
        ldy     #$00                            ; 15E9 A0 00                    ..
        lda     (r15L),y                        ; 15EB B1 20                    .
        sta     V212B                           ; 15ED 8D 2B 21                 .+!
        jsr     InitDrive                           ; 15F0 20 3E 07                  >.
        ldy     V212B                           ; 15F3 AC 2B 21                 .+!
        lda     $8486,y                         ; 15F6 B9 86 84                 ...
        sta     V212C                           ; 15F9 8D 2C 21                 .,!
        jmp     L161C                           ; 15FC 4C 1C 16                 L..
; ----------------------------------------------------------------------------
L15FF:  lda     V212E                           ; 15FF AD 2E 21                 ..!
        sta     r15H                            ; 1602 85 21                    .!
        lda     V212D                           ; 1604 AD 2D 21                 .-!
        sta     r15L                            ; 1607 85 20                    .
        ldy     #$00                            ; 1609 A0 00                    ..
        lda     (r15L),y                        ; 160B B1 20                    .
        sta     V212B                           ; 160D 8D 2B 21                 .+!
        jsr     InitDrive                           ; 1610 20 3E 07                  >.
        inc $d020
        ldy     V212B                           ; 1613 AC 2B 21                 .+!
        lda     $8486,y                         ; 1616 B9 86 84                 ...
        sta     V212C                           ; 1619 8D 2C 21                 .,!
L161C:  ldy     #$01                            ; 161C A0 01                    ..
        lda     (r15L),y                        ; 161E B1 20                    .
        sta     V212A                           ; 1620 8D 2A 21                 .*!
L1623:  clc                                     ; 1623 18                       .
        lda     #$02                            ; 1624 A9 02                    ..
        adc     r15L                            ; 1626 65 20                    e
        sta     r15L                            ; 1628 85 20                    .
        bcc     L162E                           ; 162A 90 02                    ..
        inc     r15H                            ; 162C E6 21                    .!
L162E:  ldy     #$00                            ; 162E A0 00                    ..
        lda     (r15L),y                        ; 1630 B1 20                    .
        sta     r13L                            ; 1632 85 1C                    ..
        iny                                     ; 1634 C8                       .
        lda     (r15L),y                        ; 1635 B1 20                    .
        sta     r13H                            ; 1637 85 1D                    ..
        beq     L165D                           ; 1639 F0 22                    ."
        ldy     V212A                           ; 163B AC 2A 21                 .*!
        jsr     L1441                           ; 163E 20 41 14                  A.
        jsr     IsMseInRegion                   ; 1641 20 B3 C2                  ..
        beq     L1657                           ; 1644 F0 11                    ..
        ldy     #$03                            ; 1646 A0 03                    ..
        lda     (r13L),y                        ; 1648 B1 1C                    ..
        sta     r0L                             ; 164A 85 02                    ..
        iny                                     ; 164C C8                       .
        lda     (r13L),y                        ; 164D B1 1C                    ..
        sta     r0H                             ; 164F 85 03                    ..
        jsr     L165E                           ; 1651 20 5E 16                  ^.
        clv                                     ; 1654 B8                       .
        bvc     L165D                           ; 1655 50 06                    P.
L1657:  inc     V212A                           ; 1657 EE 2A 21                 .*!
        clv                                     ; 165A B8                       .
        bvc     L1623                           ; 165B 50 C6                    P.
L165D:  rts                                     ; 165D 60                       `
; ----------------------------------------------------------------------------
L165E:  jmp     (r0L)                           ; 165E 6C 02 00                 l..
; ----------------------------------------------------------------------------
DriveAStr:
        .byte   $18                                     ; 1661 18                       .
        .byte   "Drive A"                       ; 1662 44 72 69 76 65 20 41     Drive A
        .byte   $00
DriveBStr:
        .byte   $18                         ; 1669 00 18                    ..
        .byte   "Drive B"                       ; 166B 44 72 69 76 65 20 42     Drive B
        .byte   $00
DriveCStr:
        .byte   $18                         ; 1672 00 18                    ..
        .byte   "Drive C"                       ; 1674 44 72 69 76 65 20 43     Drive C
        .byte   $00                             ; 167B 00                       .
DriveDStr:
        .byte   $18
        .byte   "Drive D"
        .byte   $00
; ----------------------------------------------------------------------------
L167C:  ldy     #$03                            ; 167C A0 03                    ..
        jsr     L1720                           ; 167E 20 20 17                   .
        ldy     #$04                            ; 1681 A0 04                    ..
        jsr     L1720                           ; 1683 20 20 17                   .
        lda     ramExpSize                      ; 1686 AD C3 88                 ...
        beq     L1690                           ; 1689 F0 05                    ..
        ldy     #$05                            ; 168B A0 05                    ..
        jsr     L1720                           ; 168D 20 20 17                   .
	ldy     #$00                            ; 168B A0 05                    ..
        jsr     L1720                           ; 168D 20 20 17                   .
L1690:  jsr     L16BE                           ; 1690 20 BE 16                  ..
        jsr     L16E8                           ; 1693 20 E8 16                  ..
        lda     ramExpSize                      ; 1696 AD C3 88                 ...
        beq     L169E                           ; 1699 F0 03                    ..
        jsr     L1712                           ; 169B 20 12 17                  ..
	jsr     L1712b
L169E:  jsr     ExitTurbo                       ; 169E 20 32 C2                  2.
        rts                                     ; 16A1 60                       `
; ----------------------------------------------------------------------------
L16A2:  ldy     #$03                            ; 16A2 A0 03                    ..
        jsr     L15AA                           ; 16A4 20 AA 15                  ..
        LoadW   r0, DriveAStr
        lda     #$13                            ; 16AF A9 13                    ..
        sta     r1H                             ; 16B1 85 05                    ..
.ifdef config128
        LoadW   r11, $4F + CFG_DOUBLE_W
.else
        LoadW   r11, $4F
.endif
        jsr     PutString                       ; 16BB 20 48 C1                  H.
L16BE:  LoadW   V212D, L1B79
        jsr     L1A74                           ; 16C8 20 74 1A                  t.
        rts                                     ; 16CB 60                       `
; ----------------------------------------------------------------------------
L16CC:  ldy     #$04                            ; 16CC A0 04                    ..
        jsr     L15AA                           ; 16CE 20 AA 15                  ..
        LoadW   r0, DriveBStr
        lda     #$13                            ; 16D9 A9 13                    ..
        sta     r1H                             ; 16DB 85 05                    ..
.ifdef config128
        LoadW   r11, $E5 + CFG_DOUBLE_W
.else
        LoadW   r11, $E5
.endif
        jsr     PutString                       ; 16E5 20 48 C1                  H.
L16E8:  LoadW   V212D, L1B89
        jsr     L1A74                           ; 16F2 20 74 1A                  t.
        rts                                     ; 16F5 60                       `
; ----------------------------------------------------------------------------
L16F6:  ldy     #$05                            ; 16F6 A0 05                    ..
        jsr     L15AA                           ; 16F8 20 AA 15                  ..
        LoadW   r0, DriveCStr
        lda     #$75                            ; 1703 A9 75                    .u
        sta     r1H                             ; 1705 85 05                    ..
.ifdef config128
        LoadW   r11, $4F + CFG_DOUBLE_W
.else
        LoadW   r11, $4F
.endif
        jsr     PutString                       ; 170F 20 48 C1                  H.
L1712:  LoadW   V212D, L1B99
        jsr     L1A74                           ; 171C 20 74 1A                  t.
        rts                                     ; 171F 60                       `
; ----------------------------------------------------------------------------
RenderDriveD:  ldy     #$00                            ; 16F6 A0 05                    ..
        jsr     L15AA                           ; 16F8 20 AA 15                  ..
        LoadW   r0, DriveDStr
        lda     #$75                            ; 1703 A9 75                    .u
        sta     r1H                             ; 1705 85 05                    ..
.ifdef config128
        LoadW   r11, $E5 + CFG_DOUBLE_W
.else
        LoadW   r11, $E5
.endif
        jsr     PutString                       ; 170F 20 48 C1                  H.
L1712b: LoadW   V212D, L1B99_D
        jsr     L1A74                           ; 171C 20 74 1A                  t.
        rts                                     ; 171F 60                       `
; ----------------------------------------------------------------------------
L1720:  jsr     L1441                           ; 1720 20 41 14                  A.
        clc                                     ; 1723 18                       .
        lda     #$02                            ; 1724 A9 02                    ..
        adc     r3L                             ; 1726 65 08                    e.
        sta     r3L                             ; 1728 85 08                    ..
        bcc     L172E                           ; 172A 90 02                    ..
        inc     r3H                             ; 172C E6 09                    ..
L172E:  sec                                     ; 172E 38                       8
        lda     r4L                             ; 172F A5 0A                    ..
        sbc     #$02                            ; 1731 E9 02                    ..
        sta     r4L                             ; 1733 85 0A                    ..
        lda     r4H                             ; 1735 A5 0B                    ..
        sbc     #$00                            ; 1737 E9 00                    ..
        sta     r4H                             ; 1739 85 0B                    ..
        lda     r2L                             ; 173B A5 06                    ..
        clc                                     ; 173D 18                       .
        adc     #$0F                            ; 173E 69 0F                    i.
        sta     r2L                             ; 1740 85 06                    ..
        lda     r2H                             ; 1742 A5 07                    ..
        sec                                     ; 1744 38                       8
        sbc     #$02                            ; 1745 E9 02                    ..
        sta     r2H                             ; 1747 85 07                    ..
        lda     #$00                            ; 1749 A9 00                    ..
        jsr     SetPattern                      ; 174B 20 39 C1                  9.
        jsr     Rectangle                       ; 174E 20 24 C1                  $.
        rts                                     ; 1751 60                       `
; ----------------------------------------------------------------------------
L1752:  jsr     L1873                           ; 1752 20 73 18                  s.
        lda     ramExpSize                      ; 1755 AD C3 88                 ...
        beq     L1760                           ; 1758 F0 06                    ..
        jsr     L1761                           ; 175A 20 61 17                  a.
        jsr     L17B2                           ; 175D 20 B2 17                  ..
L1760:  rts                                     ; 1760 60                       `
; ----------------------------------------------------------------------------
L1761:
        LoadW  r0, DMAMoveDataStr
        lda     #$A4                            ; 1769 A9 A4                    ..
        sta     r1H                             ; 176B 85 05                    ..
.ifdef config128
        LoadW   r11, $BE + CFG_DOUBLE_W
.else
        LoadW   r11, $BE
.endif
        jsr     PutString                       ; 1775 20 48 C1                  H.
        LoadW   r0, DMAMoveDataStr2
        lda     #$B2                            ; 1780 A9 B2                    ..
        sta     r1H                             ; 1782 85 05                    ..
.ifdef config128
        LoadW   r11, $BE + CFG_DOUBLE_W
.else
        LoadW   r11, $BE
.endif
        jsr     PutString                       ; 178C 20 48 C1                  H.
L178F:  lda     sysRAMFlg                       ; 178F AD C4 88                 ...
        and     #$80                            ; 1792 29 80                    ).
        beq     L1798                           ; 1794 F0 02                    ..
        lda     #$02                            ; 1796 A9 02                    ..
L1798:  ldy     #$01                            ; 1798 A0 01                    ..
        jsr     L15CF                           ; 179A 20 CF 15                  ..
        rts                                     ; 179D 60                       `
; ----------------------------------------------------------------------------
DMAMoveDataStr:
        .byte   $18                                     ; 179E 18                       .
        .byte   "DMA for"                       ; 179F 44 4D 41 20 66 6F 72     DMA for
        .byte   $00
DMAMoveDataStr2:
        .byte   $22                         ; 17A6 00 22                    ."
        .byte   "MoveData"                      ; 17A8 4D 6F 76 65 44 61 74 61  MoveData
        .byte   $22,$00                         ; 17B0 22 00                    ".
; ----------------------------------------------------------------------------
L17B2:
        LoadW   r0, RAMRebootStr
        lda     #$8D                            ; 17BA A9 8D                    ..
        sta     r1H                             ; 17BC 85 05                    ..
.ifdef config128
        LoadW   r11, $BE + CFG_DOUBLE_W
.else
        LoadW   r11, $BE
.endif
        jsr     PutString                       ; 17C6 20 48 C1                  H.
L17C9:  lda     sysRAMFlg                       ; 17C9 AD C4 88                 ...
        and     #$20                            ; 17CC 29 20                    )
        beq     L17D2                           ; 17CE F0 02                    ..
        lda     #$02                            ; 17D0 A9 02                    ..
L17D2:  ldy     #$02                            ; 17D2 A0 02                    ..
        jsr     L15CF                           ; 17D4 20 CF 15                  ..
        rts                                     ; 17D7 60                       `
; ----------------------------------------------------------------------------
RAMRebootStr:
        .byte   $18                             ; 17D8 18                       .
        .byte   "RAM Reboot"                    ; 17D9 52 41 4D 20 52 65 62 6F  RAM Rebo
                                                ; 17E1 6F 74                    ot
        .byte   $00                             ; 17E3 00                       .
; ----------------------------------------------------------------------------
ConfigOtherPressVec:
        lda     mouseData                       ; 17E4 AD 05 85                 ...
        bpl     L17EA                           ; 17E7 10 01                    ..
        rts                                     ; 17E9 60                       `
; ----------------------------------------------------------------------------
L17EA:
	lda     #$00                            ; 17EA A9 00                    ..
        sta     L180C                           ; 17EC 8D 0C 18                 ...
        ;jsr     L1837                           ; 17EF 20 37 18                  7.
        jsr     L180D                           ; 17F2 20 0D 18                  ..
        inc $d020
        jsr     L181B                           ; 17F5 20 1B 18                  ..
        lda     ramExpSize                      ; 17F8 AD C3 88                 ...
        beq     L1800                           ; 17FB F0 03                    ..
        jsr     L1829                           ; 17FD 20 29 18                  ).
	jsr     L1829_D
L1800:  lda     L180C                           ; 1800 AD 0C 18                 ...
        beq     L180B                           ; 1803 F0 06                    ..
        jsr     L0FA0                           ; 1805 20 A0 0F                  ..
        jsr     L167C                           ; 1808 20 7C 16                  |.
L180B:  rts                                     ; 180B 60                       `
; ----------------------------------------------------------------------------
L180C:  brk                                     ; 180C 00                       .
L180D:
        LoadW   V212D, L1B79
        jsr     L15FF                           ; 1817 20 FF 15                  ..
        rts                                     ; 181A 60                       `
; ----------------------------------------------------------------------------
L181B:
        LoadW   V212D, L1B89
        jsr     L15FF                           ; 1825 20 FF 15                  ..
        rts                                     ; 1828 60                       `
; ----------------------------------------------------------------------------
L1829:
        LoadW   V212D, L1B99
        jsr     L15DF                           ; 1833 20 DF 15                  ..
        rts                                     ; 1836 60                       `
; ----------------------------------------------------------------------------
L1829_D:
        LoadW   V212D, L1B99_D
        jsr     L15DF                           ; 1833 20 DF 15                  ..
        rts                                     ; 1836 60                       `
; ----------------------------------------------------------------------------
L1837:  lda     ramExpSize                      ; 1837 AD C3 88                 ...
        beq     L1872                           ; 183A F0 36                    .6
        ldy     #$01                            ; 183C A0 01                    ..
        jsr     L1441                           ; 183E 20 41 14                  A.
        jsr     IsMseInRegion                   ; 1841 20 B3 C2                  ..
        beq     L1857                           ; 1844 F0 11                    ..
        lda     sysRAMFlg                       ; 1846 AD C4 88                 ...
        eor     #$80                            ; 1849 49 80                    I.
        sta     sysRAMFlg                       ; 184B 8D C4 88                 ...
        sta     sysFlgCopy                      ; 184E 8D 12 C0                 ...
        sta     $040A                           ; 1851 8D 0A 04                 ...
        jmp     L178F                           ; 1854 4C 8F 17                 L..
; ----------------------------------------------------------------------------
L1857:  ldy     #$02                            ; 1857 A0 02                    ..
        jsr     L1441                           ; 1859 20 41 14                  A.
        jsr     IsMseInRegion                   ; 185C 20 B3 C2                  ..
        beq     L1872                           ; 185F F0 11                    ..
        lda     sysRAMFlg                       ; 1861 AD C4 88                 ...
        eor     #$20                            ; 1864 49 20                    I
        sta     sysRAMFlg                       ; 1866 8D C4 88                 ...
        sta     sysFlgCopy                      ; 1869 8D 12 C0                 ...
        sta     $040A                           ; 186C 8D 0A 04                 ...
        jmp     L17C9                           ; 186F 4C C9 17                 L..
; ----------------------------------------------------------------------------
L1872:  rts                                     ; 1872 60                       `
; ----------------------------------------------------------------------------
L1873:  LoadW   r0, RAMExpStr
        lda     #$75                            ; 187B A9 75                    .u
        sta     r1H                             ; 187D 85 05                    ..
.ifdef config128
        LoadW   r11, $BE + CFG_DOUBLE_W
.else
        LoadW   r11, $BE
.endif
        jsr     PutString                       ; 1887 20 48 C1                  H.
        lda     ramExpSize                      ; 188A AD C3 88                 ...
        sta     r0L                             ; 188D 85 02                    ..
        lda     #$40                            ; 188F A9 40                    .@
        sta     r2L                             ; 1891 85 06                    ..
        ldx     #$02                            ; 1893 A2 02                    ..
        ldy     #$06                            ; 1895 A0 06                    ..
        jsr     BBMult                          ; 1897 20 60 C1                  `.
        lda     #$C0                            ; 189A A9 C0                    ..
        jsr     PutDecimal                      ; 189C 20 84 C1                  ..
        lda     #$4B                            ; 189F A9 4B                    .K
        jsr     PutChar                         ; 18A1 20 45 C1                  E.
        rts                                     ; 18A4 60                       `
; ----------------------------------------------------------------------------
RAMExpStr:
        .byte   $18                             ; 18A5 18                       .
        .byte   "RAM expansion: "               ; 18A6 52 41 4D 20 65 78 70 61  RAM expa
                                                ; 18AE 6E 73 69 6F 6E 3A 20     nsion:
        .byte   $00                             ; 18B5 00                       .
; ----------------------------------------------------------------------------
MenuQuit:
        jsr     DoPreviousMenu                  ; 18B6 20 90 C1                  ..
        lda     driveType                       ; 18B9 AD 8E 84                 ...
        beq     L18C0                           ; 18BC F0 02                    ..
        bpl     L18C8                           ; 18BE 10 08                    ..
L18C0:  lda     $848F                           ; 18C0 AD 8F 84                 ...
        beq     L18C7                           ; 18C3 F0 02                    ..
        bpl     L18C8                           ; 18C5 10 01                    ..
L18C7:  rts                                     ; 18C7 60                       `
; ----------------------------------------------------------------------------
L18C8:  ldy     V2104                           ; 18C8 AC 04 21                 ..!
        lda     $8486,y                         ; 18CB B9 86 84                 ...
        bne     L18D6                           ; 18CE D0 06                    ..
        tya                                     ; 18D0 98                       .
        eor     #$01                            ; 18D1 49 01                    I.
        sta     V2104                           ; 18D3 8D 04 21                 ..!
L18D6:  jmp     L043E                           ; 18D6 4C 3E 04                 L>.
; ----------------------------------------------------------------------------
        ldx     #>SomeTextDlg                            ; 18D9 A2 18                    ..
        lda     #<SomeTextDlg                            ; 18DB A9 E0                    ..
        jmp     L2022                           ; 18DD 4C 22 20                 L"
; ----------------------------------------------------------------------------
SomeTextDlg:
        .byte   $81
        .byte   DBVARSTR
        .byte   $10, $20
        .byte   r5
        .byte   OK
        .byte   1
        .byte   $48
        .byte   0
MenuShowInfo:
        jsr     DoPreviousMenu                  ; 18E9 20 90 C1                  ..
        ldx     #>InfoDlg                       ; 18EC A2 18                    ..
        lda     #<InfoDlg                           ; 18EE A9 F4                    ..
        jsr     L2022                           ; 18F0 20 22 20                  "
        rts                                     ; 18F3 60                       `
; ----------------------------------------------------------------------------
InfoDlg:
        .byte   $81
        .byte   DBTXTSTR
        .byte   8
        .byte   $10
        .word   L1910
        .byte   DBTXTSTR
        .byte   8
        .byte   $20
        .word   L1921
        .byte   DBTXTSTR
        .byte   8
        .byte   $2c
        .word   L193B
        .byte   DBTXTSTR
        .byte   8
        .byte   $3E
        .word   L194F
        .byte   DBTXTSTR
        .byte   8
        .byte   $4A
        .word   L196C
        .byte   DBSYSOPV
        .byte   0
L1910:
        .byte   $18,$1A                     ; 190F 00 18 1A                 ...
.ifdef config128
        .byte   "128 CONFIGURE 2.1"                 ; 1912 43 4F 4E 46 49 47 55 52  CONFIGUR
                                                ; 191A 45 20 32 2E 31           E 2.1
.else
        .byte   "CONFIGURE 2.1"                 ; 1912 43 4F 4E 46 49 47 55 52  CONFIGUR
                                                ; 191A 45 20 32 2E 31           E 2.1
.endif
        .byte   $1B,$00                         ; 191F 1B 00                    ..
L1921:  .byte   $18                             ; 1921 18                       .
        .byte   "Copyright (C) 1986-1990,"      ; 1922 43 6F 70 79 72 69 67 68  Copyrigh
                                                ; 192A 74 20 28 43 29 20 31 39  t (C) 19
                                                ; 1932 38 36 2D 31 39 39 30 2C  86-1990,
        .byte   $00                             ; 193A 00                       .
L193B:  .byte   "Berkeley Softworks."           ; 193B 42 65 72 6B 65 6C 65 79  Berkeley
                                                ; 1943 20 53 6F 66 74 77 6F 72   Softwor
                                                ; 194B 6B 73 2E                 ks.
        .byte   $00                             ; 194E 00                       .
L194F:  .byte   "Portions Copyright (C) 1990,"  ; 194F 50 6F 72 74 69 6F 6E 73  Portions
                                                ; 1957 20 43 6F 70 79 72 69 67   Copyrig
                                                ; 195F 68 74 20 28 43 29 20 31  ht (C) 1
                                                ; 1967 39 39 30 2C              990,
        .byte   $00                             ; 196B 00                       .
L196C:
        .byte   "Jim Collette. (Q-Link: GEOREP J"; 196C 4A 69 6D 20 43 6F 6C 6C Jim Coll
                                                ; 1974 65 74 74 65 2E 20 28 51  ette. (Q
                                                ; 197C 2D 4C 69 6E 6B 3A 20 47  -Link: G
                                                ; 1984 45 4F 52 45 50 20 4A     EOREP J
        .byte   "IM)"                           ; 198B 49 4D 29                 IM)
        .byte   $1B,$00                         ; 198E 1B 00                    ..
; ----------------------------------------------------------------------------
MenuSaveConfig:
        jsr     DoPreviousMenu                  ; 1990 20 90 C1                  ..
        lda     V2104                           ; 1993 AD 04 21                 ..!
        jsr     InitDrive                           ; 1996 20 3E 07                  >.
        LoadW   r0, V20D9
        jsr     OpenRecordFile                  ; 19A1 20 74 C2                  t.
        txa                                     ; 19A4 8A                       .
        bne     L19CE                           ; 19A5 D0 27                    .'
        lda     #$00                            ; 19A7 A9 00                    ..
        jsr     PointRecord                     ; 19A9 20 80 C2                  ..
        lda     #$80                            ; 19AC A9 80                    ..
        sta     r4H                             ; 19AE 85 0B                    ..
        lda     #$00                            ; 19B0 A9 00                    ..
        sta     r4L                             ; 19B2 85 0A                    ..
        jsr     GetBlock                        ; 19B4 20 E4 C1                  ..
        txa                                     ; 19B7 8A                       .
        bne     L19CE                           ; 19B8 D0 14                    ..
        ldy     #$04                            ; 19BA A0 04                    ..
L19BC:  lda     $0406,y                         ; 19BC B9 06 04                 ...
        sta     $8002,y                         ; 19BF 99 02 80                 ...
        dey                                     ; 19C2 88                       .
        bpl     L19BC                           ; 19C3 10 F7                    ..
        jsr     PutBlock                        ; 19C5 20 E7 C1                  ..
        txa                                     ; 19C8 8A                       .
        bne     L19CE                           ; 19C9 D0 03                    ..
        jmp     CloseRecordFile                 ; 19CB 4C 77 C2                 Lw.
; ----------------------------------------------------------------------------
L19CE:  ldx     #>CantSaveDlg                            ; 19CE A2 19                    ..
        lda     #<CantSaveDlg                            ; 19D0 A9 D5                    ..
        jmp     L2022                           ; 19D2 4C 22 20                 L"
; ----------------------------------------------------------------------------
CantSaveDlg:
        .byte   $81
        .byte   DBTXTSTR
        .byte   $0C
        .byte   $20
        .word   L19E4
        .byte   DBTXTSTR
        .byte   $0C
        .byte   $30
        .word   L1A03
        .byte   OK
        .byte   1
        .byte   $48
        .byte   0

L19E4:  .byte   $18                             ; 19E4 18                       .
        .byte   "Unable to save configuration:" ; 19E5 55 6E 61 62 6C 65 20 74  Unable t
                                                ; 19ED 6F 20 73 61 76 65 20 63  o save c
                                                ; 19F5 6F 6E 66 69 67 75 72 61  onfigura
                                                ; 19FD 74 69 6F 6E 3A           tion:
        .byte   $00                             ; 1A02 00
L1A03:
        .byte   $18
        .byte   "Can't find "                   ; 1A04 43 61 6E 27 74 20 66 69  Can't fi
                                                ; 1A0C 6E 64 20                 nd
        .byte   $22                             ; 1A0F 22                       "
        .byte   "CONFIGURE"                     ; 1A10 43 4F 4E 46 49 47 55 52  CONFIGUR
                                                ; 1A18 45                       E
        .byte   $22                             ; 1A19 22                       "
        .byte   " file."                        ; 1A1A 20 66 69 6C 65 2E         file.
        .byte   $00
MenuTable:
        .byte   $00,$0E
        .word   $00
MenuRight:
        .word   $15
        .byte   $01                             ; 1A20 00 00 0E 00 00 15 00 01  ........
        .word   L1A2D
        .byte   "@"                       ; 1A2A 40
        .word   L203D
L1A2D:
        .byte   "file", 0

        .byte   "disk"                          ; 1A32 64 69 73 6B              disk
        .byte   $00                             ; 1A36 00                       .
; ----------------------------------------------------------------------------
        ;asl     $0038                           ; 1A37 0E 38 00                 .8.
L1A37:
SubMenu:
        .byte   $0e
        .byte   $38
        .word 0
SubMenuRight:
        .word  $62

        .byte   3 | VERTICAL                             ; 1A3D 83                       .

        .word   L1A4D
        .byte   $00
        .word   MenuSaveConfig

        .word   L1A60
        .byte   0
        .word   MenuShowInfo

        .word   L1A6F
        .byte   0
        .word   MenuQuit

L1A4D:
        .byte   "save configurat"               ; 1A4D 73 61 76 65 20 63 6F 6E  save con
                                                ; 1A55 66 69 67 75 72 61 74     figurat
L1A5C:  .byte   "ion"                           ; 1A5C 69 6F 6E                 ion
        .byte   $00                             ; 1A5F 00                       .
L1A60:
        .byte   "CONFIGURE info"                ; 1A60 43 4F 4E 46 49 47 55 52  CONFIGUR
                                                ; 1A68 45 20 69 6E 66 6F        E info
        .byte   $00                             ; 1A6E 00                       .
L1A6F:
        .byte   "quit"                          ; 1A6F 71 75 69 74              quit
        .byte   $00                             ; 1A73 00                       .
; ----------------------------------------------------------------------------
L1A74:  lda     V212E                           ; 1A74 AD 2E 21                 ..!
        sta     r15H                            ; 1A77 85 21                    .!
        lda     V212D                           ; 1A79 AD 2D 21                 .-!
        sta     r15L                            ; 1A7C 85 20                    .
        ldy     #$00                            ; 1A7E A0 00                    ..
        lda     (r15L),y                        ; 1A80 B1 20                    .
        sta     V212B                           ; 1A82 8D 2B 21                 .+!
        tay                                     ; 1A85 A8                       .
        lda     $8486,y                         ; 1A86 B9 86 84                 ...
        sta     V212C                           ; 1A89 8D 2C 21                 .,!
        ldy     #$01                            ; 1A8C A0 01                    ..
        lda     (r15L),y                        ; 1A8E B1 20                    .
        sta     V212A                           ; 1A90 8D 2A 21                 .*!
        clc                                     ; 1A93 18                       .
        lda     #$02                            ; 1A94 A9 02                    ..
        adc     r15L                            ; 1A96 65 20                    e
        sta     r15L                            ; 1A98 85 20                    .
        bcc     L1A9E                           ; 1A9A 90 02                    ..
        inc     r15H                            ; 1A9C E6 21                    .!
L1A9E:  ldy     #$0B                            ; 1A9E A0 0B                    ..
L1AA0:  lda     #$00                            ; 1AA0 A9 00                    ..
        sta     (r15L),y                        ; 1AA2 91 20                    .
        dey                                     ; 1AA4 88                       .
        bpl     L1AA0                           ; 1AA5 10 F9                    ..
        jsr     L1C39                           ; 1AA7 20 39 1C                  9.
        jsr     L1B5B                           ; 1AAA 20 5B 1B                  [.
        jsr     L1C41                           ; 1AAD 20 41 1C                  A.
        jsr     L1B5B                           ; 1AB0 20 5B 1B                  [.
        jsr     L1C56                           ; 1AB3 20 56 1C                  V.
        jsr     L1B5B                           ; 1AB6 20 5B 1B                  [.
        jsr     L1C88                           ; 1AB9 20 88 1C                  ..
        jsr     L1B5B                           ; 1ABC 20 5B 1B                  [.
        jsr     L1C99                           ; 1ABF 20 99 1C                  ..
        jsr     L1B5B                           ; 1AC2 20 5B 1B                  [.
.ifndef config128
        jsr     L1CAA                           ; 1AC5 20 AA 1C                  ..
        jsr     L1B5B                           ; 1AC8 20 5B 1B                  [.
.endif
        jsr     L1C6F                           ; 1ACB 20 6F 1C                  o.
        jsr     L1B5B                           ; 1ACE 20 5B 1B                  [.
        jsr     L1CC3                           ; 1AD1 20 C3 1C                  ..
        jsr     L1B5B                           ; 1AD4 20 5B 1B                  [.
        jsr     L1CDC                           ; 1AD7 20 DC 1C                  ..
        jsr     L1B5B                           ; 1ADA 20 5B 1B                  [.
        jsr     CheckF011                       ; 1AA7 20 39 1C                  9.
        jsr     L1B5B                           ; 1AAA 20 5B 1B                  [.
        lda     V212E                           ; 1ADD AD 2E 21                 ..!
        sta     r15H                            ; 1AE0 85 21                    .!
        lda     V212D                           ; 1AE2 AD 2D 21                 .-!
        sta     r15L                            ; 1AE5 85 20                    .
        clc                                     ; 1AE7 18                       .
        lda     #$02                            ; 1AE8 A9 02                    ..
        adc     r15L                            ; 1AEA 65 20                    e
        sta     r15L                            ; 1AEC 85 20                    .
        bcc     L1AF2                           ; 1AEE 90 02                    ..
        inc     r15H                            ; 1AF0 E6 21                    .!
L1AF2:  ldy     #$00                            ; 1AF2 A0 00                    ..
        lda     (r15L),y                        ; 1AF4 B1 20                    .
        sta     r13L                            ; 1AF6 85 1C                    ..
        iny                                     ; 1AF8 C8                       .
        lda     (r15L),y                        ; 1AF9 B1 20                    .
        sta     r13H                            ; 1AFB 85 1D                    ..
        beq     L1B5A                           ; 1AFD F0 5B                    .[
        ldy     V212A                           ; 1AFF AC 2A 21                 .*!
        jsr     L1441                           ; 1B02 20 41 14                  A.
        lda     r2L                             ; 1B05 A5 06                    ..
        clc                                     ; 1B07 18                       .
        adc     #$08                            ; 1B08 69 08                    i.
        sta     r1H                             ; 1B0A 85 05                    ..
        sec                                     ; 1B0C 38                       8
        lda     r3L                             ; 1B0D A5 08                    ..
        sbc     #$5A                            ; 1B0F E9 5A                    .Z
        sta     r11L                            ; 1B11 85 18                    ..
        lda     r3H                             ; 1B13 A5 09                    ..
        sbc     #$00                            ; 1B15 E9 00                    ..
        sta     r11H                            ; 1B17 85 19                    ..
        ldy     #$00                            ; 1B19 A0 00                    ..
        lda     (r13L),y                        ; 1B1B B1 1C                    ..
        pha                                     ; 1B1D 48                       H
        iny                                     ; 1B1E C8                       .
        lda     (r13L),y                        ; 1B1F B1 1C                    ..
        sta     r0L                             ; 1B21 85 02                    ..
        iny                                     ; 1B23 C8                       .
        lda     (r13L),y                        ; 1B24 B1 1C                    ..
        sta     r0H                             ; 1B26 85 03                    ..
        lda     r15H                            ; 1B28 A5 21                    .!
        pha                                     ; 1B2A 48                       H
        lda     r15L                            ; 1B2B A5 20                    .
        pha                                     ; 1B2D 48                       H
        jsr     PutString                       ; 1B2E 20 48 C1                  H.
        pla                                     ; 1B31 68                       h
        sta     r15L                            ; 1B32 85 20                    .
        pla                                     ; 1B34 68                       h
        sta     r15H                            ; 1B35 85 21                    .!
        ldy     V212A                           ; 1B37 AC 2A 21                 .*!
        pla                                     ; 1B3A 68                       h
        cmp     V212C                           ; 1B3B CD 2C 21                 .,!
        bne     L1B44                           ; 1B3E D0 04                    ..
        lda     #$02                            ; 1B40 A9 02                    ..
        bne     L1B46                           ; 1B42 D0 02                    ..
L1B44:  lda     #$00                            ; 1B44 A9 00                    ..
L1B46:  jsr     L15CF                           ; 1B46 20 CF 15                  ..
        clc                                     ; 1B49 18                       .
        lda     #$02                            ; 1B4A A9 02                    ..
        adc     r15L                            ; 1B4C 65 20                    e
        sta     r15L                            ; 1B4E 85 20                    .
        bcc     L1B54                           ; 1B50 90 02                    ..
        inc     r15H                            ; 1B52 E6 21                    .!
L1B54:  inc     V212A                           ; 1B54 EE 2A 21                 .*!
        clv                                     ; 1B57 B8                       .
        bvc     L1AF2                           ; 1B58 50 98                    P.
L1B5A:  rts                                     ; 1B5A 60                       `
; ----------------------------------------------------------------------------
L1B5B:  dey                                     ; 1B5B 88                       .
        bmi     L1B78                           ; 1B5C 30 1A                    0.
        lda     L1BB2,y                         ; 1B5E B9 B2 1B                 ...
        tax                                     ; 1B61 AA                       .
        lda     L1BA9,y                         ; 1B62 B9 A9 1B                 ...
        ldy     #$00                            ; 1B65 A0 00                    ..
        sta     (r15L),y                        ; 1B67 91 20                    .
        iny                                     ; 1B69 C8                       .
        txa                                     ; 1B6A 8A                       .
        sta     (r15L),y                        ; 1B6B 91 20                    .
        clc                                     ; 1B6D 18                       .
        lda     #$02                            ; 1B6E A9 02                    ..
        adc     r15L                            ; 1B70 65 20                    e
        sta     r15L                            ; 1B72 85 20                    .
        bcc     L1B78                           ; 1B74 90 02                    ..
        inc     r15H                            ; 1B76 E6 21                    .!
L1B78:  rts                                     ; 1B78 60                       `
; ----------------------------------------------------------------------------
L1B79:
        php                                     ; 1B79 08                       .
        asl     CPU_DDR                         ; 1B7A 06 00                    ..
        brk                                     ; 1B7C 00                       .
        brk                                     ; 1B7D 00                       .
        brk                                     ; 1B7E 00                       .
        brk                                     ; 1B7F 00                       .
        brk                                     ; 1B80 00                       .
        brk                                     ; 1B81 00                       .
        brk                                     ; 1B82 00                       .
        brk                                     ; 1B83 00                       .
        brk                                     ; 1B84 00                       .
        brk                                     ; 1B85 00                       .
        brk                                     ; 1B86 00                       .
        brk                                     ; 1B87 00                       .
        brk                                     ; 1B88 00                       .
L1B89:
        ora     #$0C                            ; 1B89 09 0C                    ..
        brk                                     ; 1B8B 00                       .
        brk                                     ; 1B8C 00                       .
        brk                                     ; 1B8D 00                       .
        brk                                     ; 1B8E 00                       .
        brk                                     ; 1B8F 00                       .
        brk                                     ; 1B90 00                       .
        brk                                     ; 1B91 00                       .
        brk                                     ; 1B92 00                       .
        brk                                     ; 1B93 00                       .
        brk                                     ; 1B94 00                       .
        brk                                     ; 1B95 00                       .
        brk                                     ; 1B96 00                       .
        brk                                     ; 1B97 00                       .
        brk                                     ; 1B98 00                       .
L1B99:
        asl                                    ; 1B99 0A                       .
        .byte   $12                             ; 1B9A 12                       .
        brk                                     ; 1B9B 00                       .
        brk                                     ; 1B9C 00                       .
        brk                                     ; 1B9D 00                       .
        brk                                     ; 1B9E 00                       .
        brk                                     ; 1B9F 00                       .
        brk                                     ; 1BA0 00                       .
        brk                                     ; 1BA1 00                       .
        brk                                     ; 1BA2 00                       .
        brk                                     ; 1BA3 00                       .
        brk                                     ; 1BA4 00                       .
        brk                                     ; 1BA5 00                       .
        brk                                     ; 1BA6 00                       .
        brk                                     ; 1BA7 00                       .
        brk                                     ; 1BA8 00                       .

L1B99_D:
        .byte	11                               
        .byte   $18                             ; 1B9A 18                       .
        brk                                     ; 1B9B 00                       .
        brk                                     ; 1B9C 00                       .
        brk                                     ; 1B9D 00                       .
        brk                                     ; 1B9E 00                       .
        brk                                     ; 1B9F 00                       .
        brk                                     ; 1BA0 00                       .
        brk                                     ; 1BA1 00                       .
        brk                                     ; 1BA2 00                       .
        brk                                     ; 1BA3 00                       .
        brk                                     ; 1BA4 00                       .
        brk                                     ; 1BA5 00                       .
        brk                                     ; 1BA6 00                       .
        brk                                     ; 1BA7 00                       .
        brk                                     ; 1BA8 00                       .

L1BA9:
        .byte   <OptNoDrive
        .byte   <Opt1541
        .byte   <OptShadowed1541
        .byte   <OptRAM1541
        .byte   <Opt1571
        .byte   <Opt1581
        .byte   <OptShadowed1581
        .byte   <OptRAM1571
        .byte   <OptRAM1581
	.byte   <OptF011

L1BB2:
        .byte   >OptNoDrive
        .byte   >Opt1541
        .byte   >OptShadowed1541
        .byte   >OptRAM1541
        .byte   >Opt1571
        .byte   >Opt1581
        .byte   >OptShadowed1581
        .byte   >OptRAM1571
        .byte   >OptRAM1581
	.byte   >OptF011

; no drive
OptNoDrive:
        .byte   0
        .word   L1BC0
        .word   InitNoDrive
L1BC0:
        .byte   "No Drive"                      ; 1BC0 4E 6F 20 44 72 69 76 65  No Drive
        .byte   $00

; 1541
Opt1541:
        .byte   $01
        .word   L1BCE
        .word   Init1541
L1BCE:
        .byte   "1541"                          ; 1BCE 31 35 34 31              1541
        .byte   $00                             ; 1BD2 00                       .

; Shadowed 1541
OptShadowed1541:
        .byte   $41                             ; 1BD3 41                       A
        .word   L1BD8
        .word   InitShadowed1541
L1BD8:
        .byte   "Shadowed 1541"                 ; 1BD8 53 68 61 64 6F 77 65 64  Shadowed
                                                ; 1BE0 20 31 35 34 31            1541
        .byte   $00

; RAM 1541
OptRAM1541:
        .byte   $81
        .word   L1BEB
        .word   InitRAM1541

L1BEB:
        .byte   "RAM 1541"                      ; 1BEB 52 41 4D 20 31 35 34 31  RAM 1541
        .byte   $00

; 1571
Opt1571:
        .byte   $02
        .word   L1BF9
        .word   Init1571

L1BF9:
        .byte   "1571"                          ; 1BF9 31 35 37 31              1571
        .byte   $00

;1581
Opt1581:
        .byte   $03
        .word   L1C03
        .word   Init1581

L1C03:
        .byte   "1581"                          ; 1C03 31 35 38 31              1581
        .byte   $00                             ; 1C07 00                       .

; Shadowed 1581
OptShadowed1581:
        .byte   "C"                             ; 1C08 43                       C
        .word   L1C0D
        .word   InitShadowed1581
L1C0D:
        .byte   "Dir Shadow 1581"               ; 1C0D 44 69 72 20 53 68 61 64  Dir Shad
                                                ; 1C15 6F 77 20 31 35 38 31     ow 1581
        .byte   $00

; RAM 1571
OptRAM1571:
        .byte   $82
        .word   L1C22                           ; 1C1C 00 82 22 1C              ..".
        .word   InitRAM1571
L1C22:
        .byte   "RAM 1571"                      ; 1C22 52 41 4D 20 31 35 37 31  RAM 1571
        .byte   $00

; RAM 1581
OptRAM1581:
        .byte   $83                             ; 1C2A 00 83                    ..
        .word   L1C30
        .word   InitRAM1581
L1C30:
        .byte   "RAM 1581"                      ; 1C30 52 41 4D 20 31 35 38 31  RAM 1581
        .byte   0                                     ; 1C38 00                       .

; F011
OptF011:
        .byte   $04
        .word   F011Label
        .word   InitF011
F011Label:
        .byte   "F011"                          ; 1BCE 31 35 34 31              1541
        .byte   $00                             ; 1BD2 00                       .


L1C39:  ldy     V212C                           ; 1C39 AC 2C 21                 .,!
        beq     L1C40                           ; 1C3C F0 02                    ..
        ldy     #$01                            ; 1C3E A0 01                    ..
L1C40:  rts                                     ; 1C40 60                       `
; ----------------------------------------------------------------------------
L1C41:  lda     V212C                           ; 1C41 AD 2C 21                 .,!
        cmp     #$01                            ; 1C44 C9 01                    ..
        beq     L1C50                           ; 1C46 F0 08                    ..
        cmp     #$41                            ; 1C48 C9 41                    .A
        beq     L1C50                           ; 1C4A F0 04                    ..
        cmp     #$00                            ; 1C4C C9 00                    ..
        bne     L1C53                           ; 1C4E D0 03                    ..
L1C50:  ldy     #$02                            ; 1C50 A0 02                    ..
        rts                                     ; 1C52 60                       `
; ----------------------------------------------------------------------------
L1C53:  ldy     #$00                            ; 1C53 A0 00                    ..
        rts                                     ; 1C55 60                       `
; ----------------------------------------------------------------------------
L1C56:  lda     V212C                           ; 1C56 AD 2C 21                 .,!
        cmp     #$41                            ; 1C59 C9 41                    .A
        beq     L1C69                           ; 1C5B F0 0C                    ..
        cmp     #$01                            ; 1C5D C9 01                    ..
        bne     L1C6C                           ; 1C5F D0 0B                    ..
        lda     #$41                            ; 1C61 A9 41                    .A
        jsr     L0911                           ; 1C63 20 11 09                  ..
        txa                                     ; 1C66 8A                       .
        bne     L1C6C                           ; 1C67 D0 03                    ..
L1C69:  ldy     #$03                            ; 1C69 A0 03                    ..
        rts                                     ; 1C6B 60                       `
; ----------------------------------------------------------------------------
L1C6C:  ldy     #$00                            ; 1C6C A0 00                    ..
        rts                                     ; 1C6E 60                       `
; ----------------------------------------------------------------------------
L1C6F:  lda     V212C                           ; 1C6F AD 2C 21                 .,!
        cmp     #$81                            ; 1C72 C9 81                    ..
        beq     L1C82                           ; 1C74 F0 0C                    ..
        cmp     #$00                            ; 1C76 C9 00                    ..
        bne     L1C85                           ; 1C78 D0 0B                    ..
        lda     #$81                            ; 1C7A A9 81                    ..
        jsr     L0911                           ; 1C7C 20 11 09                  ..
        txa                                     ; 1C7F 8A                       .
        bne     L1C85                           ; 1C80 D0 03                    ..
L1C82:  ldy     #$04                            ; 1C82 A0 04                    ..
        rts                                     ; 1C84 60                       `
; ----------------------------------------------------------------------------
L1C85:  ldy     #$00                            ; 1C85 A0 00                    ..
        rts                                     ; 1C87 60                       `
; ----------------------------------------------------------------------------
L1C88:  lda     V212C                           ; 1C88 AD 2C 21                 .,!
        cmp     #$02                            ; 1C8B C9 02                    ..
        beq     L1C93                           ; 1C8D F0 04                    ..
        cmp     #$00                            ; 1C8F C9 00                    ..
        bne     L1C96                           ; 1C91 D0 03                    ..
L1C93:  ldy     #$05                            ; 1C93 A0 05                    ..
        rts                                     ; 1C95 60                       `
; ----------------------------------------------------------------------------
L1C96:  ldy     #$00                            ; 1C96 A0 00                    ..
        rts                                     ; 1C98 60                       `

; ----------------------------------------------------------------------------
CheckF011:  lda     V212C                           ; 1C88 AD 2C 21                 .,!
        cmp     #$04                            ; 1C8B C9 02                    ..
        beq     ShowF011                           ; 1C8D F0 04                    ..
        cmp     #$00                            ; 1C8F C9 00                    ..
        bne     NoF011                           ; 1C91 D0 03                    ..
ShowF011:  ldy     #10                            ; 1C93 A0 05                    ..
        rts                                     ; 1C95 60                       `
; ----------------------------------------------------------------------------
NoF011:  ldy     #$00                            ; 1C96 A0 00                    ..
        rts                                     ; 1C98 60                       `

; ----------------------------------------------------------------------------
L1C99:  lda     V212C                           ; 1C99 AD 2C 21                 .,!
        cmp     #$03                            ; 1C9C C9 03                    ..
        beq     L1CA4                           ; 1C9E F0 04                    ..
        cmp     #$00                            ; 1CA0 C9 00                    ..
        bne     L1CA7                           ; 1CA2 D0 03                    ..
L1CA4:  ldy     #$06                            ; 1CA4 A0 06                    ..
        rts                                     ; 1CA6 60                       `
; ----------------------------------------------------------------------------
L1CA7:  ldy     #$00                            ; 1CA7 A0 00                    ..
        rts                                     ; 1CA9 60                       `
; ----------------------------------------------------------------------------
.ifndef config128
L1CAA:  lda     V212C                           ; 1CAA AD 2C 21                 .,!
        cmp     #$43                            ; 1CAD C9 43                    .C
        beq     L1CBD                           ; 1CAF F0 0C                    ..
        cmp     #$03                            ; 1CB1 C9 03                    ..
        bne     L1CC0                           ; 1CB3 D0 0B                    ..
        lda     #$43                            ; 1CB5 A9 43                    .C
        jsr     L0911                           ; 1CB7 20 11 09                  ..
        txa                                     ; 1CBA 8A                       .
        bne     L1CC0                           ; 1CBB D0 03                    ..
L1CBD:  ldy     #$07                            ; 1CBD A0 07                    ..
        rts                                     ; 1CBF 60                       `
; ----------------------------------------------------------------------------
L1CC0:  ldy     #$00                            ; 1CC0 A0 00                    ..
        rts                                     ; 1CC2 60                       `
.endif

.ifdef mega65
L1CAA:  lda     V212C                           ; 1CAA AD 2C 21                 .,!
        cmp     #$43                            ; 1CAD C9 43                    .C
        beq     L1CBD                           ; 1CAF F0 0C                    ..
        cmp     #$03                            ; 1CB1 C9 03                    ..
        bne     L1CC0                           ; 1CB3 D0 0B                    ..
        lda     #$43                            ; 1CB5 A9 43                    .C
        jsr     L0911                           ; 1CB7 20 11 09                  ..
        txa                                     ; 1CBA 8A                       .
        bne     L1CC0                           ; 1CBB D0 03                    ..
L1CBD:  ldy     #$07                            ; 1CBD A0 07                    ..
        rts                                     ; 1CBF 60                       `
; ----------------------------------------------------------------------------
L1CC0:  ldy     #$00                            ; 1CC0 A0 00                    ..
        rts                                     ; 1CC2 60                       `
.endif

; ----------------------------------------------------------------------------
L1CC3:  lda     V212C                           ; 1CC3 AD 2C 21                 .,!
        cmp     #$82                            ; 1CC6 C9 82                    ..
        beq     L1CD6                           ; 1CC8 F0 0C                    ..
        cmp     #$00                            ; 1CCA C9 00                    ..
        bne     L1CD9                           ; 1CCC D0 0B                    ..
        lda     #$82                            ; 1CCE A9 82                    ..
        jsr     L0911                           ; 1CD0 20 11 09                  ..
        txa                                     ; 1CD3 8A                       .
        bne     L1CD9                           ; 1CD4 D0 03                    ..
L1CD6:  ldy     #$08                            ; 1CD6 A0 08                    ..
        rts                                     ; 1CD8 60                       `
; ----------------------------------------------------------------------------
L1CD9:  ldy     #$00                            ; 1CD9 A0 00                    ..
        rts                                     ; 1CDB 60                       `
; ----------------------------------------------------------------------------
L1CDC:  lda     V212C                           ; 1CDC AD 2C 21                 .,!
        cmp     #$83                            ; 1CDF C9 83                    ..
        beq     L1CEF                           ; 1CE1 F0 0C                    ..
        cmp     #$00                            ; 1CE3 C9 00                    ..
        bne     L1CF2                           ; 1CE5 D0 0B                    ..
        lda     #$83                            ; 1CE7 A9 83                    ..
        jsr     L0911                           ; 1CE9 20 11 09                  ..
        txa                                     ; 1CEC 8A                       .
        bne     L1CF2                           ; 1CED D0 03                    ..
L1CEF:  ldy     #$09                            ; 1CEF A0 09                    ..
        rts                                     ; 1CF1 60                       `
; ----------------------------------------------------------------------------
L1CF2:  ldy     #$00                            ; 1CF2 A0 00                    ..
        rts                                     ; 1CF4 60                       `
; ----------------------------------------------------------------------------
InitNoDrive:
        lda     V212C                           ; 1CF5 AD 2C 21                 .,!
        beq     L1D27                           ; 1CF8 F0 2D                    .-
        jsr     PurgeTurbo                      ; 1CFA 20 35 C2                  5.
        lda     V212C                           ; 1CFD AD 2C 21                 .,!
        bmi     L1D1B                           ; 1D00 30 19                    0.
        lda     V212B                           ; 1D02 AD 2B 21                 .+!
        clc                                     ; 1D05 18                       .
        adc     #$39                            ; 1D06 69 39                    i9
L1D08:  sta     L1D9A                           ; 1D08 8D 9A 1D                 ...
        ldx     #>UnplugDlg                            ; 1D0B A2 1D                    ..
        lda     #<UnplugDlg                            ; 1D0D A9 9D                    ..
        jsr     L2022                           ; 1D0F 20 22 20                  "
        lda     r0L                             ; 1D12 A5 02                    ..
        cmp     #$02                            ; 1D14 C9 02                    ..
        beq     L1D27                           ; 1D16 F0 0F                    ..
        jsr     L1D28                           ; 1D18 20 28 1D                  (.
L1D1B:  lda     V212B                           ; 1D1B AD 2B 21                 .+!
        jsr     L1DF2                           ; 1D1E 20 F2 1D                  ..
inc $d020
        jsr     CheckAllDrives                           ; 1D21 20 B0 1D                  ..
inc $d020
        dec     L180C                           ; 1D24 CE 0C 18                 ...
L1D27:  rts                                     ; 1D27 60                       `
; ----------------------------------------------------------------------------
L1D28:  php                                     ; 1D28 08                       .
        sei                                     ; 1D29 78                       x
        LoadW   intBotVector, L1D53

        lda     #$00                            ; 1D34 A9 00                    ..
        sta     L1D60                           ; 1D36 8D 60 1D                 .`.
        lda     #$78                            ; 1D39 A9 78                    .x
        sta     L1D5F                           ; 1D3B 8D 5F 1D                 ._.
        plp                                     ; 1D3E 28                       (
L1D3F:  lda     L1D5F                           ; 1D3F AD 5F 1D                 ._.
        ora     L1D60                           ; 1D42 0D 60 1D                 .`.
        bne     L1D3F                           ; 1D45 D0 F8                    ..
        php                                     ; 1D47 08                       .
        sei                                     ; 1D48 78                       x
        lda     #$00                            ; 1D49 A9 00                    ..
        sta     intBotVector                    ; 1D4B 8D 9F 84                 ...
        sta     $84A0                           ; 1D4E 8D A0 84                 ...
        plp                                     ; 1D51 28                       (
        rts                                     ; 1D52 60                       `
; ----------------------------------------------------------------------------
L1D53:
        lda     L1D5F                           ; 1D53 AD 5F 1D                 ._.
        bne     L1D5B                           ; 1D56 D0 03                    ..
        dec     L1D60                           ; 1D58 CE 60 1D                 .`.
L1D5B:  dec     L1D5F                           ; 1D5B CE 5F 1D                 ._.
        rts                                     ; 1D5E 60                       `

L1D5F:  brk                                     ; 1D5F 00                       .
L1D60:  brk                                     ; 1D60 00                       .
; ----------------------------------------------------------------------------

L1D61:  .byte   $18                             ; 1D61 18                       .
        .byte   "If you are able to, please"    ; 1D62 49 66 20 79 6F 75 20 61  If you a
                                                ; 1D6A 72 65 20 61 62 6C 65 20  re able
                                                ; 1D72 74 6F 2C 20 70 6C 65 61  to, plea
                                                ; 1D7A 73 65                    se
        .byte   $00                             ; 1D7C 00                       .
L1D7D:
        .byte   "turn OFF and/or unplug drive " ; 1D7D 74 75 72 6E 20 4F 46 46  turn OFF
                                                ; 1D85 20 61 6E 64 2F 6F 72 20   and/or
                                                ; 1D8D 75 6E 70 6C 75 67 20 64  unplug d
                                                ; 1D95 72 69 76 65 20           rive
L1D9A:  .byte   "x."                            ; 1D9A 78 2E                    x.
        .byte   0                                    ; 1D9C 00                       .
; ----------------------------------------------------------------------------
UnplugDlg:
        .byte   $81
        .byte   DBTXTSTR
        .byte   12, 32
        .word   L1D61
        .byte   DBTXTSTR
        .byte   12, 48
        .word   L1D7D
        .byte   OK
        .byte   1, $48
        .byte   CANCEL
        .byte   $11, $48
        .byte   0

L1DAF:  brk                                     ; 1DAF 00                       .

CheckAllDrives:  lda     #$00                            ; 1DB0 A9 00                    ..
        sta     L1DAF                           ; 1DB2 8D AF 1D                 ...
        lda     #$08                            ; 1DB5 A9 08                    ..
        jsr     CheckDrive                           ; 1DB7 20 CB 1D                  ..
        lda     #$09                            ; 1DBA A9 09                    ..
        jsr     CheckDrive                           ; 1DBC 20 CB 1D                  ..
        lda     #$0A                            ; 1DBF A9 0A                    ..
        jsr     CheckDrive                           ; 1DC1 20 CB 1D                  ..
        lda     L1DAF                           ; 1DC4 AD AF 1D                 ...
        sta     NUMDRV                          ; 1DC7 8D 8D 84                 ...
        rts                                     ; 1DCA 60                       `
; ----------------------------------------------------------------------------
CheckDrive:  tay                                     ; 1DCB A8                       .
        lda     $8486,y                         ; 1DCC B9 86 84                 ...
        beq     L1DE0                           ; 1DCF F0 0F                    ..
        bmi     L1DDD                           ; 1DD1 30 0A                    0.
        tya                                     ; 1DD3 98                       .
        jsr     InitAndCheckDrive                           ; 1DD4 20 E1 1D                  ..
        bne     L1DDD                           ; 1DD7 D0 04                    ..
        jsr     L1DF2                           ; 1DD9 20 F2 1D                  ..
        rts                                     ; 1DDC 60                       `
; ----------------------------------------------------------------------------
L1DDD:  inc     L1DAF                           ; 1DDD EE AF 1D                 ...
L1DE0:  rts                                     ; 1DE0 60                       `
; ----------------------------------------------------------------------------
InitAndCheckDrive:  jsr     InitDrive                           ; 1DE1 20 3E 07                  >.
        lda     NUMDRV                          ; 1DE4 AD 8D 84                 ...
        bne     L1DEC                           ; 1DE7 D0 03                    ..
        inc     NUMDRV                          ; 1DE9 EE 8D 84                 ...
L1DEC:  jsr     NewDisk                         ; 1DEC 20 E1 C1                  ..
        cpx     #$0D                            ; 1DEF E0 0D                    ..
        rts                                     ; 1DF1 60                       `
; ----------------------------------------------------------------------------
L1DF2:  ldy     curDrive                        ; 1DF2 AC 89 84                 ...
        lda     #$00                            ; 1DF5 A9 00                    ..
        sta     $8486,y                         ; 1DF7 99 86 84                 ...
        sta     driveData,y                     ; 1DFA 99 BF 88                 ...
        sta     $03FE,y                         ; 1DFD 99 FE 03                 ...
        sta     diskOpenFlg,y                   ; 1E00 99 8A 84                 ...
        rts                                     ; 1E03 60                       `
; ----------------------------------------------------------------------------
L1E04:  brk                                     ; 1E04 00                       .
SetupDrive:
        lda     #$00                            ; 1E05 A9 00                    ..
        sta     L1E04                           ; 1E07 8D 04 1E                 ...
        lda     V212B                           ; 1E0A AD 2B 21                 .+!
        cmp     #$0A                            ; 1E0D C9 0A                    ..
        bcc     SetupDriveAB                           ; 1E0F 90 03                    ..
        jmp     SetupDriveC                           ; 1E11 4C B4 1E                 L..
; ----------------------------------------------------------------------------
SetupDriveAB:  lda     #$00                            ; 1E14 A9 00                    ..
        sta     L1E04                           ; 1E16 8D 04 1E                 ...

		; set new drive type
		ldy     V212B                           ; 1E19 AC 2B 21                 .+!
        lda     V212F                           ; 1E1C AD 2F 21                 ./!
        sta     $8486,y                         ; 1E1F 99 86 84                 ...
        inc     $848D

		lda     V212B
        jsr     InitAndCheckDrive
		bne     L1E48                           ; 1E2B D0 1B                    ..

		; the other drive empty?
		lda     V212B                           ; 1E2D AD 2B 21                 .+!
        eor     #$01                            ; 1E30 49 01                    I.
        tay                                     ; 1E32 A8                       .
        lda     $8486,y                         ; 1E33 B9 86 84                 ...
        beq     L1E59                           ; 1E36 F0 21                    .!

		tya                                     ; 1E38 98                       .
        ldy     #$0B                            ; 1E39 A0 0B                    ..
        bit     sysRAMFlg                       ; 1E3B 2C C4 88                 ,..
        bvs     L1E43                           ; 1E3E 70 03                    p.
        eor     #$02                            ; 1E40 49 02                    I.
        tay                                     ; 1E42 A8                       .
L1E43:  lda     $8486,y                         ; 1E43 B9 86 84                 ...
        beq     L1E4A                           ; 1E46 F0 02                    ..
L1E48:  bne     L1EB0                           ; 1E48 D0 66                    .f
L1E4A:  sty     L1E04                           ; 1E4A 8C 04 1E                 ...
        jsr     L0739                           ; 1E4D 20 39 07                  9.
        lda     L1E04                           ; 1E50 AD 04 1E                 ...
        jsr     L1FC5                           ; 1E53 20 C5 1F                  ..
        jsr     PurgeTurbo                      ; 1E56 20 35 C2                  5.
L1E59:  ldx     #>PluginDlg                            ; 1E59 A2 1F                    ..
        lda     #<PluginDlg                            ; 1E5B A9 A1                    ..
        jsr     L2022                           ; 1E5D 20 22 20                  "
        lda     r0L                             ; 1E60 A5 02                    ..
        cmp     #$02                            ; 1E62 C9 02                    ..
        beq     L1E98                           ; 1E64 F0 32                    .2

		; not canceled
		lda     V212B                           ; 1E66 AD 2B 21                 .+!
        jsr     InitAndCheckDrive                           ; 1E69 20 E1 1D                  ..
        bne     L1E98                           ; 1E6C D0 2A                    .*

		lda     V212B                           ; 1E6E AD 2B 21                 .+!
        eor     #$01                            ; 1E71 49 01                    I.
        sta     curDevice                       ; 1E73 85 BA                    ..
        sta     curDrive                        ; 1E75 8D 89 84                 ...
        tay                                     ; 1E78 A8                       .
        lda     V212F                           ; 1E79 AD 2F 21                 ./!
        sta     $8486,y                         ; 1E7C 99 86 84                 ...
        lda     V212B                           ; 1E7F AD 2B 21                 .+!
        jsr     L1FC5                           ; 1E82 20 C5 1F                  ..
        lda     V212B                           ; 1E85 AD 2B 21                 .+!
        sta     curDevice                       ; 1E88 85 BA                    ..
        sta     curDrive                        ; 1E8A 8D 89 84                 ...
        eor     #$01                            ; 1E8D 49 01                    I.
        tay                                     ; 1E8F A8                       .
        lda     #$00                            ; 1E90 A9 00                    ..
        sta     $8486,y                         ; 1E92 99 86 84                 ...
        txa                                     ; 1E95 8A                       .
        bne     L1E59                           ; 1E96 D0 C1                    ..
L1E98:  lda     L1E04                           ; 1E98 AD 04 1E                 ...
        beq     L1EB0                           ; 1E9B F0 13                    ..
        jsr     InitAndCheckDrive                           ; 1E9D 20 E1 1D                  ..
        bne     L1EA8                           ; 1EA0 D0 06                    ..
        jsr     L1DF2                           ; 1EA2 20 F2 1D                  ..
        clv                                     ; 1EA5 B8                       .
        bvc     L1EB0                           ; 1EA6 50 08                    P.
L1EA8:  lda     V212B                           ; 1EA8 AD 2B 21                 .+!
        eor     #$01                            ; 1EAB 49 01                    I.
        jsr     L1FC5                           ; 1EAD 20 C5 1F                  ..
L1EB0:  jsr     CheckAllDrives                           ; 1EB0 20 B0 1D                  ..
        rts                                     ; 1EB3 60                       `
; ----------------------------------------------------------------------------
SetupDriveC:  lda     #$00                            ; 1EB4 A9 00                    ..
        sta     L1E04                           ; 1EB6 8D 04 1E                 ...
        ldy     V212B                           ; 1EB9 AC 2B 21                 .+!
        lda     V212F                           ; 1EBC AD 2F 21                 ./!
        sta     $8486,y                         ; 1EBF 99 86 84                 ...
        inc     NUMDRV                          ; 1EC2 EE 8D 84                 ...
        lda     V212B                           ; 1EC5 AD 2B 21                 .+!
        jsr     InitAndCheckDrive                           ; 1EC8 20 E1 1D                  ..
        bne     L1EDB                           ; 1ECB D0 0E                    ..
        ldy     #$08                            ; 1ECD A0 08                    ..
        lda     $8486,y                         ; 1ECF B9 86 84                 ...
        beq     L1EEE                           ; 1ED2 F0 1A                    ..
        ldy     #$0B                            ; 1ED4 A0 0B                    ..
        lda     $8486,y                         ; 1ED6 B9 86 84                 ...
        beq     L1EDD                           ; 1ED9 F0 02                    ..
L1EDB:  bne     L1F3E                           ; 1EDB D0 61                    .a
L1EDD:  sty     L1E04                           ; 1EDD 8C 04 1E                 ...
        lda     #$08                            ; 1EE0 A9 08                    ..
        jsr     InitDrive                           ; 1EE2 20 3E 07                  >.
        lda     L1E04                           ; 1EE5 AD 04 1E                 ...
        jsr     L1FC5                           ; 1EE8 20 C5 1F                  ..
        jsr     PurgeTurbo                      ; 1EEB 20 35 C2                  5.
L1EEE:  ldx     #>PluginDlg2                            ; 1EEE A2 1F                    ..
        lda     #<PluginDlg2                            ; 1EF0 A9 B3                    ..
        jsr     L2022                           ; 1EF2 20 22 20                  "
        lda     r0L                             ; 1EF5 A5 02                    ..
        cmp     #$02                            ; 1EF7 C9 02                    ..
        beq     L1F29                           ; 1EF9 F0 2E                    ..
        lda     V212B                           ; 1EFB AD 2B 21                 .+!
        jsr     InitAndCheckDrive                           ; 1EFE 20 E1 1D                  ..
        bne     L1F29                           ; 1F01 D0 26                    .&
        lda     #$08                            ; 1F03 A9 08                    ..
        sta     curDevice                       ; 1F05 85 BA                    ..
        sta     curDrive                        ; 1F07 8D 89 84                 ...
        tay                                     ; 1F0A A8                       .
        lda     V212F                           ; 1F0B AD 2F 21                 ./!
        sta     $8486,y                         ; 1F0E 99 86 84                 ...
        lda     V212B                           ; 1F11 AD 2B 21                 .+!
        jsr     L1FC5                           ; 1F14 20 C5 1F                  ..
        lda     V212B                           ; 1F17 AD 2B 21                 .+!
        sta     curDevice                       ; 1F1A 85 BA                    ..
        sta     curDrive                        ; 1F1C 8D 89 84                 ...
        ldy     #$08                            ; 1F1F A0 08                    ..
        lda     #$00                            ; 1F21 A9 00                    ..
        sta     $8486,y                         ; 1F23 99 86 84                 ...
        txa                                     ; 1F26 8A                       .
        bne     L1EEE                           ; 1F27 D0 C5                    ..
L1F29:  lda     L1E04                           ; 1F29 AD 04 1E                 ...
        beq     L1F3E                           ; 1F2C F0 10                    ..
        jsr     InitAndCheckDrive                           ; 1F2E 20 E1 1D                  ..
        bne     L1F39                           ; 1F31 D0 06                    ..
        jsr     L1DF2                           ; 1F33 20 F2 1D                  ..
        clv                                     ; 1F36 B8                       .
        bvc     L1F3E                           ; 1F37 50 05                    P.
L1F39:  lda     #$08                            ; 1F39 A9 08                    ..
        jsr     L1FC5                           ; 1F3B 20 C5 1F                  ..
L1F3E:  jsr     CheckAllDrives                           ; 1F3E 20 B0 1D                  ..
        rts                                     ; 1F41 60                       `
; ----------------------------------------------------------------------------
L1F42:
        .byte   $18                             ; 1F42 18                       .
        .byte   "Plug in & turn ON new drive."  ; 1F43 50 6C 75 67 20 69 6E 20  Plug in
                                                ; 1F4B 26 20 74 75 72 6E 20 4F  & turn O
                                                ; 1F53 4E 20 6E 65 77 20 64 72  N new dr
                                                ; 1F5B 69 76 65 2E              ive.
        .byte   $00                             ; 1F5F 00                       .
L1F60:  .byte   $18                             ; 1F60 18                       .
        .byte   "(Must be set to device 8 or 9)"; 1F61 28 4D 75 73 74 20 62 65  (Must be
                                                ; 1F69 20 73 65 74 20 74 6F 20   set to
                                                ; 1F71 64 65 76 69 63 65 20 38  device 8
                                                ; 1F79 20 6F 72 20 39 29         or 9)
        .byte   $00                             ; 1F7F 00                       .
L1F80:  .byte   $18                             ; 1F80 18                       .
        .byte   "(Must be set to device 8 or 10)"; 1F81 28 4D 75 73 74 20 62 65 (Must be
                                                ; 1F89 20 73 65 74 20 74 6F 20   set to
                                                ; 1F91 64 65 76 69 63 65 20 38  device 8
                                                ; 1F99 20 6F 72 20 31 30 29      or 10)
        .byte   $00
; ----------------------------------------------------------------------------
PluginDlg:
        .byte   $81
        .byte   DBTXTSTR                             ; 1FA2 0B                       .
        .byte   $0C                             ; 1FA3 0C                       .
        .byte   $10
        .word   L1F42                           ; 1FA4 10 42                    .B
        .byte   DBTXTSTR                             ; 1FA7 0B                       .
        .byte   $0C                             ; 1FA8 0C
        .byte   $20
        .word   L1F60
        .byte   OK
        .byte   1
        .byte   $48
        .byte   CANCEL
        .byte   $11
        .byte   $48
        .byte   0                                     ; 1FB2 00                       .


PluginDlg2:
        .byte   $81
        .byte   DBTXTSTR                             ; 1FA2 0B                       .
        .byte   $0C                             ; 1FA3 0C                       .
        .byte   $10
        .word   L1F42                           ; 1FA4 10 42                    .B
        .byte   DBTXTSTR                             ; 1FA7 0B                       .
        .byte   $0C                             ; 1FA8 0C
        .byte   $20
        .word   L1F80
        .byte   OK
        .byte   1
        .byte   $48
        .byte   CANCEL
        .byte   $11
        .byte   $48
        .byte   0                                     ; 1FB2 00                       .

L1FC5:  bit     sysRAMFlg                       ; 1FC5 2C C4 88                 ,..
        bvc     L1FEE                           ; 1FC8 50 24                    P$
        pha                                     ; 1FCA 48                       H
        tay                                     ; 1FCB A8                       .
        lda     L0A66,y                         ; 1FCC B9 66 0A                 .f.
        sta     r1L                             ; 1FCF 85 04                    ..
        lda     L0A6A,y                         ; 1FD1 B9 6A 0A                 .j.
        sta     r1H                             ; 1FD4 85 05                    ..
        lda     #$90                            ; 1FD6 A9 90                    ..
        sta     r0H                             ; 1FD8 85 03                    ..
        lda     #$00                            ; 1FDA A9 00                    ..
        sta     r0L                             ; 1FDC 85 02                    ..
        lda     #$0D                            ; 1FDE A9 0D                    ..
        sta     r2H                             ; 1FE0 85 07                    ..
        lda     #$80                            ; 1FE2 A9 80                    ..
        sta     r2L                             ; 1FE4 85 06                    ..
        lda     #$00                            ; 1FE6 A9 00                    ..
L1FE8:  sta     r3L                             ; 1FE8 85 08                    ..
        jsr     StashRAM                        ; 1FEA 20 C8 C2                  ..
        pla                                     ; 1FED 68                       h
L1FEE:  sta     r0L                             ; 1FEE 85 02                    ..
        lda     curDrive                        ; 1FF0 AD 89 84                 ...
        pha                                     ; 1FF3 48                       H
        tay                                     ; 1FF4 A8                       .
        lda     driveData,y                     ; 1FF5 B9 BF 88                 ...
        pha                                     ; 1FF8 48                       H
        lda     $8486, y
        pha                                     ; 1FFC 48                       H
        bpl     L2007                           ; 1FFD 10 08                    ..
        lda     r0L                             ; 1FFF A5 02                    ..
        jsr     InitDrive                           ; 2001 20 3E 07                  >.
        clv                                     ; 2004 B8                       .
        bvc     L200C                           ; 2005 50 05                    P.
L2007:  lda     r0L                             ; 2007 A5 02                    ..
        jsr     ChangeDiskDevice                ; 2009 20 BC C2                  ..
L200C:  ldy     curDrive                        ; 200C AC 89 84                 ...
        pla                                     ; 200F 68                       h
        sta     $8486,y                         ; 2010 99 86 84                 ...
        pla                                     ; 2013 68                       h
        sta     driveData,y                     ; 2014 99 BF 88                 ...
        pla                                     ; 2017 68                       h
        tay                                     ; 2018 A8                       .
        lda     #$00                            ; 2019 A9 00                    ..
        sta     driveData,y                     ; 201B 99 BF 88                 ...
        sta     $8486,y                         ; 201E 99 86 84                 ...
        rts                                     ; 2021 60                       `
; ----------------------------------------------------------------------------
L2022:  stx     r0H                             ; 2022 86 03                    ..
        sta     r0L                             ; 2024 85 02                    ..
        ldx     #$00                            ; 2026 A2 00                    ..
        stx     V2550                           ; 2028 8E 50 25                 .P%
        lda     r5H                             ; 202B A5 0D                    ..
        pha                                     ; 202D 48                       H
        lda     r5L                             ; 202E A5 0C                    ..
        pha                                     ; 2030 48                       H
        jsr     L205B                           ; 2031 20 5B 20                  [
        pla                                     ; 2034 68                       h
        sta     r5L                             ; 2035 85 0C                    ..
        pla                                     ; 2037 68                       h
        sta     r5H                             ; 2038 85 0D                    ..
        jmp     DoDlgBox                        ; 203A 4C 56 C2                 LV.
; ----------------------------------------------------------------------------
L203D:
        ldx     #$04                            ; 203D A2 04                    ..
        jsr     L204B                           ; 203F 20 4B 20                  K
        LoadW   r0, L1A37
        rts                                     ; 204A 60                       `
; ----------------------------------------------------------------------------
L204B:  stx     V2550                           ; 204B 8E 50 25                 .P%
        ldx     V2550                           ; 204E AE 50 25                 .P%
        jmp     L205B                           ; 2051 4C 5B 20                 L[
; ----------------------------------------------------------------------------
ConfigRecoverVector:
        ldx     V2550                           ; 2054 AE 50 25                 .P%
.ifdef config128
        cpx     #$FF                            ; 20BA E0 FF                    ..
        beq     L20C6                           ; 20BC F0 08                    ..
        jsr     L20D4                           ; 20BE 20 D4 20                  .
L20C1:  lda     #$FF                            ; 20C1 A9 FF                    ..
        sta     V2550                           ; 20C3 8D EB 27                 ..'
L20C6:
.else
        jsr     L2060                           ; 2057 20 60 20                  `
.endif
        rts                                     ; 205A 60                       `
; ----------------------------------------------------------------------------
.ifdef config128
L205B:
L20C7:  jsr     L2241                           ; 20C7 20 41 22                  A"
        jsr     L2189                           ; 20CA 20 89 21                  .!
        ldy     #$00                            ; 20CD A0 00                    ..
        tya                                     ; 20CF 98                       .
        sta     (r7L),y                         ; 20D0 91 10                    ..
        beq     L20DC                           ; 20D2 F0 08                    ..

; recover
L20D4:  jsr     L2241                           ; 20D4 20 41 22                  A"
        jsr     L2189                           ; 20D7 20 89 21                  .!
        lda     #$FF                            ; 20DA A9 FF                    ..
L20DC:
.ifndef mega65
		bit     graphMode                       ; 20DC 24 3F                    $?
        bmi     L2115                           ; 20DE 30 35                    05
.endif
        sta     r4H                             ; 20E0 85 0B                    ..
.else

L205B:  lda     #$00                            ; 205B A9 00                    ..
        clv                                     ; 205D B8                       .
        bvc     L2062                           ; 205E 50 02                    P.
L2060:  lda     #$FF                            ; 2060 A9 FF                    ..
L2062:  sta     r4H                             ; 2062 85 0B                    ..
        jsr     L20BA                           ; 2064 20 BA 20                  .
.endif
L2067:  ldx     r2H                             ; 2067 A6 07                    ..
        jsr     GetScanLine                     ; 2069 20 3C C1                  <.
        lda     r2L                             ; 206C A5 06                    ..
        asl                                    ; 206E 0A                       .
        asl                                    ; 206F 0A                       .
        asl                                    ; 2070 0A                       .
        bcc     L2075                           ; 2071 90 02                    ..
        inc     r5H                             ; 2073 E6 0D                    ..
L2075:  tay                                     ; 2075 A8                       .
        lda     r3L                             ; 2076 A5 08                    ..
        sta     r4L                             ; 2078 85 0A                    ..
L207A:  bit     r4H                             ; 207A 24 0B                    $.
        bpl     L2084                           ; 207C 10 06                    ..
        jsr     L20AC                           ; 207E 20 AC 20                  .
        clv                                     ; 2081 B8                       .
        bvc     L2087                           ; 2082 50 03                    P.
L2084:  jsr     L20A0                           ; 2084 20 A0 20                  .
L2087:
.ifndef config128
        inc     r1L                             ; 2087 E6 04                    ..
        bne     L208D                           ; 2089 D0 02                    ..
        inc     r1H                             ; 208B E6 05                    ..
.endif
L208D:  clc                                     ; 208D 18                       .
        adc     #$08                            ; 208E 69 08                    i.
        bcc     L2094                           ; 2090 90 02                    ..
        inc     r5H                             ; 2092 E6 0D                    ..
L2094:  tay                                     ; 2094 A8                       .
        dec     r4L                             ; 2095 C6 0A                    ..
        bne     L207A                           ; 2097 D0 E1                    ..
        inc     r2H                             ; 2099 E6 07                    ..
        dec     r3H                             ; 209B C6 09                    ..
        bne     L2067                           ; 209D D0 C8                    ..
        rts                                     ; 209F 60                       `

.ifdef config128

; ----------------------------------------------------------------------------
.ifndef mega65
L2115:  pha                                     ; 2115 48                       H
        txa                                     ; 2116 8A                       .
        pha                                     ; 2117 48                       H
        jsr     TempHideMouse                   ; 2118 20 D7 C2                  ..
        pla                                     ; 211B 68                       h
        tax                                     ; 211C AA                       .
        pla                                     ; 211D 68                       h
        sta     r4H                             ; 211E 85 0B                    ..
        jsr     L2241                           ; 2120 20 41 22                  A"
L2123:  ldx     r2H                             ; 2123 A6 07                    ..
        jsr     GetScanLine                     ; 2125 20 3C C1                  <.
        lda     r4H                             ; 2128 A5 0B                    ..
        ora     #$40                            ; 212A 09 40                    .@
        sta     r4H                             ; 212C 85 0B                    ..
        lda     r2L                             ; 212E A5 06                    ..
        clc                                     ; 2130 18                       .
        adc     r5L                             ; 2131 65 0C                    e.
        sta     r5L                             ; 2133 85 0C                    ..
        bcc     L2139                           ; 2135 90 02                    ..
        inc     r5H                             ; 2137 E6 0D                    ..
L2139:  ldy     #$00                            ; 2139 A0 00                    ..
        lda     r3L                             ; 213B A5 08                    ..
        sta     r4L                             ; 213D 85 0A                    ..
L213F:  bit     r4H                             ; 213F 24 0B                    $.
        bpl     L2149                           ; 2141 10 06                    ..
        jsr     L217B                           ; 2143 20 7B 21                  {!
        clv                                     ; 2146 B8                       .
        bvc     L214C                           ; 2147 50 03                    P.
L2149:  jsr     L2169                           ; 2149 20 69 21                  i!
L214C:  inc     r1L                             ; 214C E6 04                    ..
        bne     L2152                           ; 214E D0 02                    ..
        inc     r1H                             ; 2150 E6 05                    ..
L2152:  inc     r5L                             ; 2152 E6 0C                    ..
        bne     L2158                           ; 2154 D0 02                    ..
        inc     r5H                             ; 2156 E6 0D                    ..
L2158:  lda     r4H                             ; 2158 A5 0B                    ..
        and     #$BF                            ; 215A 29 BF                    ).
        sta     r4H                             ; 215C 85 0B                    ..
        dec     r4L                             ; 215E C6 0A                    ..
        bne     L213F                           ; 2160 D0 DD                    ..
        inc     r2H                             ; 2162 E6 07                    ..
        dec     r3H                             ; 2164 C6 09                    ..
        bne     L2123                           ; 2166 D0 BB                    ..
        rts                                     ; 2168 60                       `
; ----------------------------------------------------------------------------
L2169:  bit     r4H                             ; 2169 24 0B                    $.
        bvc     L2173                           ; 216B 50 06                    P.
        jsr     L22E1                           ; 216D 20 E1 22                  ."
        clv                                     ; 2170 B8                       .
        bvc     L2176                           ; 2171 50 03                    P.
L2173:  jsr     L22CF                           ; 2173 20 CF 22                  ."
L2176:  ldy     #$00                            ; 2176 A0 00                    ..
        sta     (r1L),y                         ; 2178 91 04                    ..
        rts                                     ; 217A 60                       `
.endif

;L22CF:
;L22E1:
;L217B:
;L2189:
;L2241:
;L205B:

.else


; ----------------------------------------------------------------------------
L20A0:  lda     (r5L),y                         ; 20A0 B1 0C                    ..
        tax                                     ; 20A2 AA                       .
        tya                                     ; 20A3 98                       .
        pha                                     ; 20A4 48                       H
        ldy     #$00                            ; 20A5 A0 00                    ..
        txa                                     ; 20A7 8A                       .
        sta     (r1L),y                         ; 20A8 91 04                    ..
        pla                                     ; 20AA 68                       h
        rts                                     ; 20AB 60                       `
; ----------------------------------------------------------------------------
L20AC:  tya                                     ; 20AC 98                       .
        pha                                     ; 20AD 48                       H
        ldy     #$00                            ; 20AE A0 00                    ..
        lda     (r1L),y                         ; 20B0 B1 04                    ..
        tax                                     ; 20B2 AA                       .
        pla                                     ; 20B3 68                       h
        tay                                     ; 20B4 A8                       .
        txa                                     ; 20B5 8A                       .
        sta     (r5L),y                         ; 20B6 91 0C                    ..
        tya                                     ; 20B8 98                       .
        rts                                     ; 20B9 60                       `
; ----------------------------------------------------------------------------
L20BA:  LoadW	r1, V2551

        ldy     #$00                            ; 20C2 A0 00                    ..
L20C4:  lda     L20D1,x                         ; 20C4 BD D1 20                 ..
        sta     r2L,y                           ; 20C7 99 06 00                 ...
        inx                                     ; 20CA E8                       .
        iny                                     ; 20CB C8                       .
        cpy     #$04                            ; 20CC C0 04                    ..
        bne     L20C4                           ; 20CE D0 F4                    ..
        rts                                     ; 20D0 60                       `
; ----------------------------------------------------------------------------
L20D1:  php                                     ; 20D1 08                       .
        jsr     L6819                           ; 20D2 20 19 68                  .h
        brk                                     ; 20D5 00                       .
        asl     $2C0E                           ; 20D6 0E 0E 2C                 ..,
;        .byte   $C2                             ; 20D9 C2                       .
.endif

.ifdef config128
; ----------------------------------------------------------------------------
L217B:  ldy     #$00                            ; 217B A0 00                    ..
        lda     (r1L),y                         ; 217D B1 04                    ..
        bit     r4H                             ; 217F 24 0B                    $.
        bvc     L2186                           ; 2181 50 03                    P.
        jmp     L226B                           ; 2183 4C 6B 22                 Lk"

; ----------------------------------------------------------------------------
L2186:  jmp     L22BD                           ; 2186 4C BD 22                 L."

; ----------------------------------------------------------------------------
L2189:  lda     r1H                             ; 2189 A5 05                    ..
        sta     r7H                             ; 218B 85 11                    ..
        lda     r1L                             ; 218D A5 04                    ..
        sta     r7L                             ; 218F 85 10                    ..
        inc     r1L                             ; 2191 E6 04                    ..
        bne     L2197                           ; 2193 D0 02                    ..
        inc     r1H                             ; 2195 E6 05                    ..
L2197:  rts                                     ; 2197 60                       `

; ----------------------------------------------------------------------------
; uncompress for recovery

L20A0:
L2198:  tya                                     ; 2198 98                       .
        pha                                     ; 2199 48                       H
        lda     r1H                             ; 219A A5 05                    ..
        cmp     #$3C                            ; 219C C9 3C                    .<
        bcs     L21FB                           ; 219E B0 5B                    .[
        lda     (r5L),y                         ; 21A0 B1 0C                    ..
        tax                                     ; 21A2 AA                       .
        ldy     #$00                            ; 21A3 A0 00                    ..
        cpx     #$00                            ; 21A5 E0 00                    ..
        bne     L21C5                           ; 21A7 D0 1C                    ..
        lda     (r7L),y                         ; 21A9 B1 10                    ..
        bmi     L21B1                           ; 21AB 30 04                    0.
        cmp     #$7F                            ; 21AD C9 7F                    ..
        bne     L21F4                           ; 21AF D0 43                    .C
L21B1:  lda     r1H                             ; 21B1 A5 05                    ..
        sta     r7H                             ; 21B3 85 11                    ..
        lda     r1L                             ; 21B5 A5 04                    ..
        sta     r7L                             ; 21B7 85 10                    ..
        inc     r1L                             ; 21B9 E6 04                    ..
        bne     L21BF                           ; 21BB D0 02                    ..
        inc     r1H                             ; 21BD E6 05                    ..
L21BF:  lda     #$00                            ; 21BF A9 00                    ..
        sta     (r7L),y                         ; 21C1 91 10                    ..
        beq     L21F4                           ; 21C3 F0 2F                    ./
L21C5:  lda     (r7L),y                         ; 21C5 B1 10                    ..
        bpl     L21D9                           ; 21C7 10 10                    ..
        cmp     #$FF                            ; 21C9 C9 FF                    ..
        beq     L21D9                           ; 21CB F0 0C                    ..
L21CD:  txa                                     ; 21CD 8A                       .
        sta     (r1L),y                         ; 21CE 91 04                    ..
        inc     r1L                             ; 21D0 E6 04                    ..
        bne     L21D6                           ; 21D2 D0 02                    ..
        inc     r1H                             ; 21D4 E6 05                    ..
L21D6:  clv                                     ; 21D6 B8                       .
        bvc     L21F4                           ; 21D7 50 1B                    P.
L21D9:  lda     r1H                             ; 21D9 A5 05                    ..
        sta     r7H                             ; 21DB 85 11                    ..
        lda     r1L                             ; 21DD A5 04                    ..
        sta     r7L                             ; 21DF 85 10                    ..
        inc     r1L                             ; 21E1 E6 04                    ..
        bne     L21E7                           ; 21E3 D0 02                    ..
        inc     r1H                             ; 21E5 E6 05                    ..
L21E7:  lda     #$80                            ; 21E7 A9 80                    ..
        sta     (r7L),y                         ; 21E9 91 10                    ..
        lda     r1H                             ; 21EB A5 05                    ..
        cmp     #$3C                            ; 21ED C9 3C                    .<
        bcs     L21FB                           ; 21EF B0 0A                    ..
        clv                                     ; 21F1 B8                       .
        bvc     L21CD                           ; 21F2 50 D9                    P.
L21F4:  lda     (r7L),y                         ; 21F4 B1 10                    ..
        clc                                     ; 21F6 18                       .
        adc     #$01                            ; 21F7 69 01                    i.
        sta     (r7L),y                         ; 21F9 91 10                    ..
L21FB:  pla                                     ; 21FB 68                       h
        rts                                     ; 21FC 60                       `

; ----------------------------------------------------------------------------
; save foreground area with compress

L20AC:
L21FD:  tya                                     ; 21FD 98                       .
        pha                                     ; 21FE 48                       H
L21FF:  ldy     #$00                            ; 21FF A0 00                    ..
        lda     (r7L),y                         ; 2201 B1 10                    ..
        and     #$7F                            ; 2203 29 7F                    ).
        bne     L2218                           ; 2205 D0 11                    ..
        lda     r1H                             ; 2207 A5 05                    ..
        sta     r7H                             ; 2209 85 11                    ..
        lda     r1L                             ; 220B A5 04                    ..
        sta     r7L                             ; 220D 85 10                    ..
        inc     r1L                             ; 220F E6 04                    ..
        bne     L2215                           ; 2211 D0 02                    ..
        inc     r1H                             ; 2213 E6 05                    ..
L2215:  clv                                     ; 2215 B8                       .
        bvc     L21FF                           ; 2216 50 E7                    P.
L2218:  ldx     #$00                            ; 2218 A2 00                    ..
        lda     r1H                             ; 221A A5 05                    ..
        cmp     #$3C                            ; 221C C9 3C                    .<
        beq     L223A                           ; 221E F0 1A                    ..
        lda     (r7L),y                         ; 2220 B1 10                    ..
        bmi     L2228                           ; 2222 30 04                    0.
        lda     #$00                            ; 2224 A9 00                    ..
        beq     L2232                           ; 2226 F0 0A                    ..
L2228:  lda     (r1L),y                         ; 2228 B1 04                    ..
        pha                                     ; 222A 48                       H
        inc     r1L                             ; 222B E6 04                    ..
        bne     L2231                           ; 222D D0 02                    ..
        inc     r1H                             ; 222F E6 05                    ..
L2231:  pla                                     ; 2231 68                       h
L2232:  tax                                     ; 2232 AA                       .
        lda     (r7L),y                         ; 2233 B1 10                    ..
        sec                                     ; 2235 38                       8
        sbc     #$01                            ; 2236 E9 01                    ..
        sta     (r7L),y                         ; 2238 91 10                    ..
L223A:  pla                                     ; 223A 68                       h
        tay                                     ; 223B A8                       .
        txa                                     ; 223C 8A                       .
        sta     (r5L),y                         ; 223D 91 0C                    ..
        tya                                     ; 223F 98                       .
        rts                                     ; 2240 60                       `

; ----------------------------------------------------------------------------
L2241:  txa                                     ; 2241 8A                       .
        pha                                     ; 2242 48                       H
.ifndef mega65
        bit     graphMode                       ; 2243 24 3F                    $?
        bpl     L2252                           ; 2245 10 0B                    ..
        lda     #$A0                            ; 2247 A9 A0                    ..
        sta     r1H                             ; 2249 85 05                    ..
        lda     #$00                            ; 224B A9 00                    ..
        sta     r1L                             ; 224D 85 04                    ..
        clv                                     ; 224F B8                       .
        bvc     L225A                           ; 2250 50 08                    P.
L2252:
.endif
		LoadW	r1, V2551
L225A:  ldy     #$00                            ; 225A A0 00                    ..
L225C:  lda     L236C,x                         ; 225C BD 6C 23                 .l#
        sta     r2L,y                           ; 225F 99 06 00                 ...
        inx                                     ; 2262 E8                       .
        iny                                     ; 2263 C8                       .
        cpy     #$04                            ; 2264 C0 04                    ..
        bne     L225C                           ; 2266 D0 F4                    ..
        pla                                     ; 2268 68                       h
        tax                                     ; 2269 AA                       .
        rts                                     ; 226A 60                       `

; ----------------------------------------------------------------------------
L226B:  bit     graphMode                       ; 226B 24 3F                    $?
        bmi     L2274                           ; 226D 30 05                    0.
        ldy     #$00                            ; 226F A0 00                    ..
        sta     (r5L),y                         ; 2271 91 0C                    ..
        rts                                     ; 2273 60                       `

; ----------------------------------------------------------------------------
L2274:  stx     L22A3                           ; 2274 8E A3 22                 .."
        ldx     #$12                            ; 2277 A2 12                    ..
        stx     vdcreg                          ; 2279 8E 00 D6                 ...
L227C:  bit     vdcreg                          ; 227C 2C 00 D6                 ,..
        bpl     L227C                           ; 227F 10 FB                    ..
        ldx     r5H                             ; 2281 A6 0D                    ..
        stx     vdcdata                         ; 2283 8E 01 D6                 ...
        ldx     #$13                            ; 2286 A2 13                    ..
        stx     vdcreg                          ; 2288 8E 00 D6                 ...
L228B:  bit     vdcreg                          ; 228B 2C 00 D6                 ,..
        bpl     L228B                           ; 228E 10 FB                    ..
        ldx     r5L                             ; 2290 A6 0C                    ..
        stx     vdcdata                         ; 2292 8E 01 D6                 ...
        ldx     #$1F                            ; 2295 A2 1F                    ..
        stx     vdcreg                          ; 2297 8E 00 D6                 ...
L229A:  bit     vdcreg                          ; 229A 2C 00 D6                 ,..
        bpl     L229A                           ; 229D 10 FB                    ..
        sta     vdcdata                         ; 229F 8D 01 D6                 ...
        .byte   $A2                             ; 22A2 A2                       .
L22A3:  brk                                     ; 22A3 00                       .
        rts                                     ; 22A4 60                       `

; ----------------------------------------------------------------------------
        stx     vdcreg                          ; 22A5 8E 00 D6                 ...
L22A8:  bit     vdcreg                          ; 22A8 2C 00 D6                 ,..
        bpl     L22A8                           ; 22AB 10 FB                    ..
        sta     vdcdata                         ; 22AD 8D 01 D6                 ...
        rts                                     ; 22B0 60                       `

; ----------------------------------------------------------------------------
        stx     vdcreg                          ; 22B1 8E 00 D6                 ...
L22B4:  bit     vdcreg                          ; 22B4 2C 00 D6                 ,..
        bpl     L22B4                           ; 22B7 10 FB                    ..
        lda     vdcdata                         ; 22B9 AD 01 D6                 ...
        rts                                     ; 22BC 60                       `

; ----------------------------------------------------------------------------
L22BD:  bit     graphMode                       ; 22BD 24 3F                    $?
        bmi     L22C6                           ; 22BF 30 05                    0.
        ldy     #$00                            ; 22C1 A0 00                    ..
        sta     (r5L),y                         ; 22C3 91 0C                    ..
        rts                                     ; 22C5 60                       `

; ----------------------------------------------------------------------------
L22C6:  bit     vdcreg                          ; 22C6 2C 00 D6                 ,..
        bpl     L22C6                           ; 22C9 10 FB                    ..
        sta     vdcdata                         ; 22CB 8D 01 D6                 ...
        rts                                     ; 22CE 60                       `

; ----------------------------------------------------------------------------
L22CF:  bit     graphMode                       ; 22CF 24 3F                    $?
        bmi     L22D8                           ; 22D1 30 05                    0.
        ldy     #$00                            ; 22D3 A0 00                    ..
        lda     (r5L),y                         ; 22D5 B1 0C                    ..
        rts                                     ; 22D7 60                       `

; ----------------------------------------------------------------------------
L22D8:  bit     vdcreg                          ; 22D8 2C 00 D6                 ,..
        bpl     L22D8                           ; 22DB 10 FB                    ..
        lda     vdcdata                         ; 22DD AD 01 D6                 ...
        rts                                     ; 22E0 60                       `

; ----------------------------------------------------------------------------
L22E1:  bit     graphMode                       ; 22E1 24 3F                    $?
        bmi     L22EA                           ; 22E3 30 05                    0.
        ldy     #$00                            ; 22E5 A0 00                    ..
        lda     (r5L),y                         ; 22E7 B1 0C                    ..
        rts                                     ; 22E9 60                       `

; ----------------------------------------------------------------------------
L22EA:  stx     L233B                           ; 22EA 8E 3B 23                 .;#
        ldx     #$AD                            ; 22ED A2 AD                    ..
        bne     L230F                           ; 22EF D0 1E                    ..
        bit     graphMode                       ; 22F1 24 3F                    $?
        bmi     L22FA                           ; 22F3 30 05                    0.
        ldy     #$00                            ; 22F5 A0 00                    ..
        ora     (r5L),y                         ; 22F7 11 0C                    ..
        rts                                     ; 22F9 60                       `

; ----------------------------------------------------------------------------
L22FA:  stx     L233B                           ; 22FA 8E 3B 23                 .;#
        ldx     #$0D                            ; 22FD A2 0D                    ..
        bne     L230F                           ; 22FF D0 0E                    ..
        bit     graphMode                       ; 2301 24 3F                    $?
        bmi     L230A                           ; 2303 30 05                    0.
        ldy     #$00                            ; 2305 A0 00                    ..
        and     (r5L),y                         ; 2307 31 0C                    1.
        rts                                     ; 2309 60                       `

; ----------------------------------------------------------------------------
L230A:  stx     L233B                           ; 230A 8E 3B 23                 .;#
        ldx     #$2D                            ; 230D A2 2D                    .-
L230F:  stx     L233C                           ; 230F 8E 3C 23                 .<#
        ldx     #$12                            ; 2312 A2 12                    ..
        stx     vdcreg                          ; 2314 8E 00 D6                 ...
L2317:  bit     vdcreg                          ; 2317 2C 00 D6                 ,..
        bpl     L2317                           ; 231A 10 FB                    ..
        ldx     r5H                             ; 231C A6 0D                    ..
        stx     vdcdata                         ; 231E 8E 01 D6                 ...
        ldx     #$13                            ; 2321 A2 13                    ..
        stx     vdcreg                          ; 2323 8E 00 D6                 ...
L2326:  bit     vdcreg                          ; 2326 2C 00 D6                 ,..
        bpl     L2326                           ; 2329 10 FB                    ..
        ldx     r5L                             ; 232B A6 0C                    ..
        stx     vdcdata                         ; 232D 8E 01 D6                 ...
        ldx     #$1F                            ; 2330 A2 1F                    ..
        stx     vdcreg                          ; 2332 8E 00 D6                 ...
L2335:  bit     vdcreg                          ; 2335 2C 00 D6                 ,..
        bpl     L2335                           ; 2338 10 FB                    ..
        .byte   $A2                             ; 233A A2                       .
L233B:  brk                                     ; 233B 00                       .
L233C:  lda     vdcdata                         ; 233C AD 01 D6                 ...
        rts                                     ; 233F 60                       `

; ----------------------------------------------------------------------------
L2340:  bit     graphMode                       ; 2340 24 3F                    $?
        bmi     L2350                           ; 2342 30 0C                    0.
        ldy     #$07                            ; 2344 A0 07                    ..
L2346:  lda     L235C,y                         ; 2346 B9 5C 23                 .\#
        sta     L236C,y                         ; 2349 99 6C 23                 .l#
        dey                                     ; 234C 88                       .
        bpl     L2346                           ; 234D 10 F7                    ..
        rts                                     ; 234F 60                       `

; ----------------------------------------------------------------------------
L2350:  ldy     #$07                            ; 2350 A0 07                    ..
L2352:  lda     L2364,y                         ; 2352 B9 64 23                 .d#
        sta     L236C,y                         ; 2355 99 6C 23                 .l#
        dey                                     ; 2358 88                       .
        bpl     L2352                           ; 2359 10 F7                    ..
        rts                                     ; 235B 60                       `

; ----------------------------------------------------------------------------
L235C:  php                                     ; 235C 08                       .
        jsr     L6819                           ; 235D 20 19 68                  .h
        brk                                     ; 2360 00                       .
        asl     $2C0E                           ; 2361 0E 0E 2C                 ..,
L2364:  ;bpl     L2386                           ; 2364 10 20                    .
        .byte   $10, $20, $32                             ; 2366 32                       2
        pla                                     ; 2367 68                       h
        brk                                     ; 2368 00                       .
        asl     $2C1C                           ; 2369 0E 1C 2C                 ..,
L236C:  php                                     ; 236C 08                       .
        jsr     L6819                           ; 236D 20 19 68                  .h
        brk                                     ; 2370 00                       .
        asl     $2C0E                           ; 2371 0E 0E 2C                 ..,
.endif


;L2340:

VarStart:
V20D9   = VarStart
V20F2   = V20D9 + 25
V20FA   = V20D9 + 33
V20EA   = V20D9 + 17
V2102   = V20D9 + 17 + 24
V2103   = V2102 + 1
V2104   = V2103 + 1
V2105   = V2104 + 1 ;+ 35 + 1
V2106   = V2105 + 1
V2107   = V2106 + 1
V2108   = V2107 + 1
V2109   = V2108 + 1
V210A   = V2109 + 1
V212A   = V210A + 1 + 30 + 1
V212B   = V212A + 1
V212C   = V212B + 1
V212D   = V212C + 1
V212E   = V212D + 1
V212F   = V212E + 1
V2130   = V212F + 1
V2150   = V2130 + 1  + 31
V2550   = V2150 + $400
V2551	= V2550 + 1
