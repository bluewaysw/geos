; da65 V2.13.2 - (C) Copyright 2000-2009,  Ullrich von Bassewitz
; Created:    2010-05-27 22:45:43
; Input file: configure.cvt.record.0
; Page:       1

.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"
.include "geosmac.inc"
.include "diskdrv.inc"

        ;.cpu 6502
        ;.to "r0.bin",plain
        ;.sl "r0.labels"
        ;.source "inc/labels.inc"
     	;.initmem $ea
     	;.zone r0
L3156           = $3156

.ifdef config128
L6216           = $62AD;
.else
L6216           = $6216;
.endif

      ;  *=$406

;.import L6216

.segment "STARTUP"

.export L043E
.export L0616
.export L0672
.export L0739
.export InitDrive
.export	L0911
.export L0E19
.export L0FA0
.export L0FB3
.export L0A66
.export L0A6A
.export Init1541
.export InitShadowed1541
.export InitRAM1541
.export Init1571
.export Init1581
.export InitShadowed1581
.export InitRAM1571
.export InitRAM1581
.export InitRAM
.export InitF011
.export InitF011_1
.export InitSD81
.export InitSD71
.export InitSD
.export InitVirtual
.export InitFloppy

;.export L043E   ;        = $043E; fix!
;.export L0616   ;        = $0616; fix!
;.export L0672   ;        = $0672; fix!
;.export L0739   ;        = $0739; fix!
;.export InitDrive   ;        = $073E; fix!
;.export L0911   ;        = $0911; fix!
;.export L0E19   ;        = $0E19; fix!
;.export L0FA0   ;        = $0FA0; fix!
;.export L0FB3   ;        = $0FB3; fix!
.export __STARTUP_RUN__

.import V20D9
.import V2102
.import V2103
.import VarImageFileName
.import VarImageFileNames
.import VarImageDriveType
.import V2104
.import V2105
.import V2106
.import V2107
.import V2108
.import V2108a
.import V2109
.import V210A
.import V2150
.import V212B
.import V212C
.import V212F
.import V2130
.import UIEntry
.import L180C
.import SetupDrive
.import V20FA
.import V20F2
.import V20EA
.import CheckDrive
.import V2551

; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
; data saved to config file on "save configuration"
; (saved) driveType 0 and 1
        .byte   $00,$00                         ; 0406 01 03                    ..
; (saved) driveType 2 and 3
L0408:  .byte   $00,$00                         ; 0408 03 00                    ..

; sysRAMFlg sub set (RAM options)
L040A:  .byte   $a0 ;$E0                        ; 040A E0                       .
; ----------------------------------------------------------------------------
__STARTUP_RUN__:
	jsr	i_FillRam
	.word	V2551-V20D9+1
	.word	V20D9
	.byte	0
.ifndef config128
        jsr     L047C                           ; 040B 20 7C 04                  |.
.endif
	lda     firstBoot                       ; 040E AD C5 88                 ...
        cmp     #$FF                            ; 0411 C9 FF                    ..
        bne     L0418                           ; 0413 D0 03                    ..
        jmp     L04EC                           ; 0415 4C EC 04                 L..
; ----------------------------------------------------------------------------
L0418:  bit     c128Flag                        ; 0418 2C 13 C0                 ,..
.ifdef config128
        bpl     L0479
.else
        bmi     L0479                           ; 041B 30 5C                    0\
.endif
        lda     curDrive                        ; 041D AD 89 84                 ...
        sta     V2104                           ; 0420 8D 04 21                 ..!
        tay                                     ; 0423 A8                       .
        lda     $8486,y                         ; 0424 B9 86 84                 ...
        sta     V2105                           ; 0427 8D 05 21                 ..!
	
	; remember mounted image file, to resort
	cmp	#DRV_SD_81
	bne	@10
	
	; fetch image name
	jsr	GetImageFile
	LoadW	r1, VarImageFileName
	ldx	#r0
	ldy	#r1
	jsr	CopyString	
@10:
	jsr     L0FB3                           ; 042A 20 B3 0F                  ..
        jsr     i_MoveData                      ; 042D 20 B7 C1                  ..
        .word   $5000
        .word   V2150 ;SaveBootCode
        .word   $0400
        ;brk                                     ; 0430 00                       .
        ;bvc     L0483                           ; 0431 50 50                    PP
        ;and     ($00,x)                     ; 0433 21 00                    !.
        ;.byte   $04                             ; 0435 04                       .
	lda     #$01                            ; 0436 A9 01                    ..
        sta     NUMDRV                          ; 0438 8D 8D 84                 ...
        jsr     L0558                           ; 043B 20 58 05                  X.
L043E:        lda     V2104                           ; 043E AD 04 21                 ..!
        jsr     InitDrive                           ; 0441 20 3E 07                  >.
        
	jsr     L1081                           ; 0444 20 81 10                  ..
        jsr     L0FA0                           ; 0447 20 A0 0F                  ..

	lda	firstBoot
	cmp	#$FF
	beq	@10
	lda	V2105
	cmp	#DRV_SD_81
	bne 	@10
	LoadW	r0, VarImageFileName
	jsr	SetImageFile
@10:

.ifndef config128
        ; for config64 if no RAM exp is available, only
        ; multiple drives are supported if they are of the same type
        ; this routine checks this and sets one drive support
        ; if needed
        lda     ramExpSize                      ; 044A AD C3 88                 ...
        bne     L0470                           ; 044D D0 21                    .!
        lda     NUMDRV                          ; 044F AD 8D 84                 ...
        cmp     #$02                            ; 0452 C9 02                    ..
        bcc     L0470                           ; 0454 90 1A                    ..
        lda     driveType                       ; 0456 AD 8E 84                 ...
        cmp     driveType+1                     ; 0459 CD 8F 84                 ...
        bne     L0462                           ; 045C D0 04                    ..

        ; we not support 2 1581 drives without REU
        cmp     #$03                            ; 045E C9 03                    ..
        bne     L0470                           ; 0460 D0 0E                    ..
L0462:
        ; 2 different drives here not supported
        ; make us a 1 drive system
        jsr     L0739                           ; 0462 20 39 07                  9.
        jsr     PurgeTurbo                      ; 0465 20 35 C2                  5.
        jsr     L0739                           ; 0468 20 39 07                  9.
        lda     #$01                            ; 046B A9 01                    ..
        sta     NUMDRV                          ; 046D 8D 8D 84                 ...
L0470:
.endif
        jsr     i_MoveData                      ; 0470 20 B7 C1                  ..
        .word   V2150 ;SaveBootCode
        .word   $5000
        .word   $0400
        ;bvc     L0496                           ; 0473 50 21                    P!
        ;brk                                     ; 0475 00                       .
        ;bvc     L0478                           ; 0476 50 00                    P.
        ;.byte   $04                             ; 0478 04                       .
L0479:	jmp     EnterDeskTop                    ; 0479 4C 2C C2                 L,.
; ----------------------------------------------------------------------------
.ifndef config128
L047C:  bit     c128Flag                        ; 047C 2C 13 C0                 ,..
        bmi     L048E                           ; 047F 30 0D                    0.
        lda     version
        cmp     #$14
        bcs     L048E                           ; 0486 B0 06                    ..
        jsr     L04CC                           ; 0488 20 CC 04                  ..
        jsr     L048F                           ; 048B 20 8F 04                  ..
L048E:  rts                                     ; 048E 60                       `
; ----------------------------------------------------------------------------
L048F:  lda     #$C3                            ; 048F A9 C3                    ..
        sta     r0H                             ; 0491 85 03                    ..
        lda     #$10                            ; 0493 A9 10                    ..
        .byte   $85                             ; 0495 85                       .
L0496:  .byte   $02                             ; 0496 02                       .
        ldy     #$00                            ; 0497 A0 00                    ..
        sty     r1L                             ; 0499 84 04                    ..
        jsr     L04A2                           ; 049B 20 A2 04                  ..
        lda     #$05                            ; 049E A9 05                    ..
        sta     r1L                             ; 04A0 85 04                    ..
L04A2:  ldx     r1L                             ; 04A2 A6 04                    ..
L04A4:  lda     (r0L),y                         ; 04A4 B1 02                    ..
        cmp     L04C2,x                         ; 04A6 DD C2 04                 ...
        beq     L04B3                           ; 04A9 F0 08                    ..
        cpx     r1L                             ; 04AB E4 04                    ..
        bne     L04A2                           ; 04AD D0 F3                    ..
        iny                                     ; 04AF C8                       .
        bne     L04A2                           ; 04B0 D0 F0                    ..
        rts                                     ; 04B2 60                       `
; ----------------------------------------------------------------------------
L04B3:  iny                                     ; 04B3 C8                       .
        bne     L04B7                           ; 04B4 D0 01                    ..
        rts                                     ; 04B6 60                       `
; ----------------------------------------------------------------------------
L04B7:  inx                                     ; 04B7 E8                       .
        lda     L04C2,x                         ; 04B8 BD C2 04                 ...
        bne     L04A4                           ; 04BB D0 E7                    ..
        lda     #$34                            ; 04BD A9 34                    .4
        sta     (r0L),y                         ; 04BF 91 02                    ..
        rts                                     ; 04C1 60                       `
; ----------------------------------------------------------------------------
L04C2:  lda     $815C                           ; 04C2 AD 5C 81                 .\.
        cmp     #$00                            ; 04C5 C9 00                    ..
        jsr     L3156                           ; 04C7 20 56 31                  V1
        .byte   $2E                             ; 04CA 2E                       .
        brk                                     ; 04CB 00                       .
L04CC:  lda     version                         ; 04CC AD 0F C0                 ...
        cmp     #$13                            ; 04CF C9 13                    ..
        bne     L04EB                           ; 04D1 D0 18                    ..
        lda     $C2B2                           ; 04D3 AD B2 C2                 ...
        sta     r0H                             ; 04D6 85 03                    ..
        lda     $C2B1                           ; 04D8 AD B1 C2                 ...
        sta     r0L                             ; 04DB 85 02                    ..
        ldy     #$00                            ; 04DD A0 00                    ..
        lda     (r0L),y                         ; 04DF B1 02                    ..
        cmp     #$EA                            ; 04E1 C9 EA                    ..
        beq     L04EB                           ; 04E3 F0 06                    ..
        ldy     #$03                            ; 04E5 A0 03                    ..
        lda     #$3D                            ; 04E7 A9 3D                    .=
        sta     (r0L),y                         ; 04E9 91 02                    ..
L04EB:  rts                                     ; 04EB 60                       `
.endif
; ----------------------------------------------------------------------------
; Code executed if loaded after first boot, regularly, loading ui part

L04EC:  jsr     OpenConfigFile                           ; 04EC 20 22 05                  ".
        txa                                     ; 04EF 8A                       .
        bne     L050E                           ; 04F0 D0 1C                    ..
        lda     #$01                            ; 04F2 A9 01                    ..
        jsr     PointRecord                     ; 04F4 20 80 C2                  ..
        LoadW   r7, ModStart
        lda     #$FF                            ; 04FF A9 FF                    ..
        sta     r2L                             ; 0501 85 06                    ..
        sta     r2H                             ; 0503 85 07                    ..
        jsr     ReadRecord                      ; 0505 20 8C C2                  ..
        txa                                     ; 0508 8A                       .
        bne     L050E                           ; 0509 D0 03                    ..
        jmp     UIEntry                           ; 050B 4C 66 14                 Lf.
; ----------------------------------------------------------------------------
L050E:  jmp     EnterDeskTop                    ; 050E 4C 2C C2                 L,.
; ----------------------------------------------------------------------------
configFileClass:
.ifdef config128
.ifdef mega65
        .byte   "65 Config   V6.0", 0
.else

        .byte   "128 Config  V2.1"              ; 0511 43 6F 6E 66 69 67 75 72  Configur
                                                ; 0519 65 20 20 20 56 32 2E 31  e   V2.1
        .byte   $00                             ; 0521 00                       .
.endif
.else
        .byte   "Configure   V2.1"              ; 0511 43 6F 6E 66 69 67 75 72  Configur
                                                ; 0519 65 20 20 20 56 32 2E 31  e   V2.1
        .byte   $00                             ; 0521 00                       .
.endif
; ----------------------------------------------------------------------------
OpenConfigFile:  ldx     #$00                            ; 0522 A2 00                    ..
        lda     L06AC                           ; 0524 AD AC 06                 ...
        bne     L0557                           ; 0527 D0 2E                    ..

        LoadW   r6, V20D9
        ;lda     #$20                            ; 0529 A9 20                    .
        ;sta     r6H                             ; 052B 85 0F                    ..
        ;lda     #$D9                            ; 052D A9 D9                    ..
        ;sta     r6L

        LoadB   r7L, $0e                        ; auto exec file type
        LoadB   r7H, 1                          ; lookup 1 file
                                               ; 052F 85 0E                    ..
        ;lda     #$0E                            ; 0531 A9 0E                    ..
        ;sta     r7L                             ; 0533 85 10                    ..
        ;lda     #$01                            ; 0535 A9 01                    ..
        ;sta     r7H                             ; 0537 85 11                    ..

        LoadW   r10, configFileClass
        ;lda     #$05                            ; 0539 A9 05                    ..
        ;sta     r10H                            ; 053B 85 17                    ..
        ;lda     #$11                            ; 053D A9 11                    ..
        ;sta     r10L                            ; 053F 85 16                    ..
        jsr     FindFTypes                      ; 0541 20 3B C2                  ;.
        txa                                     ; 0544 8A                       .
        bne     L0557                           ; 0545 D0 10                    ..

        ; found, load it
        LoadW   r0, V20D9
        jsr     OpenRecordFile                  ; 054F 20 74 C2                  t.
        lda     #$FF                            ; 0552 A9 FF                    ..
        sta     L06AC                           ; 0554 8D AC 06                 ...
L0557:  rts                                     ; 0557 60                       `
; ----------------------------------------------------------------------------
L0558:  jsr     ExitTurbo                       ; 0558 20 32 C2                  2.
        lda     ramExpSize                      ; 055B AD C3 88                 ...
	beq     L0563                           ; 055E F0 03                    ..
        lda     L040A                           ; 0560 AD 0A 04                 ...
L0563:  and     #$A0                            ; 0563 29 A0                    ).
        sta     sysRAMFlg                       ; 0565 8D C4 88                 ...
        sta     sysFlgCopy                      ; 0568 8D 12 C0                 ...
	; check boot driver to be 1541 or 1571
	lda     V2105                           ; 056B AD 05 21                 ..!
.if 0
        cmp     #$02                            ; 056E C9 02                    ..
        bcs     L057B                           ; 0570 B0 09                    ..

	; restore/detect drives?
	jsr     L0E64                           ; 0572 20 64 0E                  d.
        
	cmp     #$FF                            ; 0575 C9 FF                    ..
        bne     L057B                           ; 0577 D0 02                    ..
        lda     #$01                            ; 0579 A9 01                    ..
L057B: 
.endif
	ldx	V2104
	sta	V2106-8,x	
	;sta     V2106                           ; 057B 8D 06 21                 ..!
.if 0
        lda     curDrive                        ; 057E AD 89 84                 ...
        eor     #$01                            ; 0581 49 01                    I.
	jsr     SetDevice                       ; 0583 20 B0 C2                  ..
        jsr     L0E64                           ; 0586 20 64 0E                  d.
	cmp     #$FF                            ; 0589 C9 FF                    ..
        bne     L058F                           ; 058B D0 02                    ..
.endif
        lda     #$00                            ; 058D A9 00                    ..
L058F:  sta     V2107                           ; 058F 8D 07 21                 ..!
.if 0
        lda     ramExpSize                      ; 0592 AD C3 88                 ...
        beq     L05A3                           ; 0595 F0 0C                    ..
        
	lda     #$0A                            ; 0597 A9 0A                    ..
        jsr     SetDevice                       ; 0599 20 B0 C2                  ..
        jsr     L0E64                           ; 059C 20 64 0E                  d.
	cmp     #$FF                            ; 0589 C9 FF                    ..
        bne     L05A5                           ; 05A1 D0 02                    ..
.endif
L05A3:  lda     #$00                            ; 05A3 A9 00                    ..
L05A5:  sta     V2108                           ; 05A5 8D 08 21                 ..!

        lda     V2104                           ; 05A8 AD 04 21                 ..!
        jsr     SetDevice                       ; 05AB 20 B0 C2                  ..

	; restore saved drive
	jsr     L06B2                           ; 05AE 20 B2 06                  ..
        
	; setup default drive
	;ldx	V2104
	;lda	V2105
	;sta	V2106-8,x
	jsr	SetupDefaulDrives
	
	; load required drivers?
	jsr     L064A                           ; 05B1 20 4A 06                  J.
        txa                                     ; 05B4 8A                       .
        bne     L05F7                           ; 05B5 D0 40                    .@
        jsr     PurgeTurbo                      ; 05B7 20 35 C2                  5.
        ldy     #$03                            ; 05BA A0 03                    ..
        lda     #$00                            ; 05BC A9 00                    ..
        sta     NUMDRV                          ; 05BE 8D 8D 84                 ...
L05C1:  sta     driveType,y                     ; 05C1 99 8E 84                 ...
        sta     turboFlags,y                    ; 05C4 99 92 84                 ...
        sta     driveData,y                     ; 05C7 99 BF 88                 ...
        sta     ramBase,y                       ; 05CA 99 C7 88                 ...
        dey                                     ; 05CD 88                       .
        bpl     L05C1                           ; 05CE 10 F1                    ..
        
	; install drivers in RAM (if available)
	jsr     L05F8                           ; 05D0 20 F8 05                  ..
        
	lda     V2106                           ; 05D3 AD 06 21                 ..!
        jsr     L0769                           ; 05D6 20 69 07                  i.
	lda     V2107                           ; 05D9 AD 07 21                 ..!
        beq     L05E7                           ; 05DC F0 09                    ..
        jsr     L0739                           ; 05DE 20 39 07                  9.
        lda     V2107                           ; 05E1 AD 07 21                 ..!
        jsr     L0769                           ; 05E4 20 69 07                  i.
L05E7:  lda     V2108                           ; 05E7 AD 08 21                 ..!
        beq     L05F7                           ; 05EA F0 0B                    ..
        lda     #$0A                            ; 05EC A9 0A                    ..
        jsr     InitDrive                           ; 05EE 20 3E 07                  >.
        lda     V2108                           ; 05F1 AD 08 21                 ..!
        jsr     L0769                           ; 05F4 20 69 07                  i.
L05F7:  
	lda     V2108a                           ; 05E7 AD 08 21                 ..!
        beq     L05F7b                           ; 05EA F0 0B                    ..
        lda     #$0B                            ; 05EC A9 0A                    ..
        jsr     InitDrive                           ; 05EE 20 3E 07                  >.
        lda     V2108a                           ; 05F1 AD 08 21                 ..!
        jsr     L0769                           ; 05F4 20 69 07                  i.
L05F7b:  
	rts                                     ; 05F7 60
; ----------------------------------------------------------------------------
L05F8:  lda     ramExpSize                      ; 05F8 AD C3 88                 ...
        beq     L0615                           ; 05FB F0 18                    ..
        lda     #$08                            ; 05FD A9 08                    ..
        sta     V212B                           ; 05FF 8D 2B 21                 .+!
        lda     V2106                           ; 0602 AD 06 21                 ..!
        sta     V212F                           ; 0605 8D 2F 21                 ./!
L0608:  jsr     InstallDriver                           ; 0608 20 C8 09                  ..
        inc     V212B                           ; 060B EE 2B 21                 .+!
        lda     V212B                           ; 060E AD 2B 21                 .+!
        cmp     #$0C                            ; 0611 C9 0C                    ..
        bne     L0608                           ; 0613 D0 F3                    ..
L0615:  rts                                     ; 0615 60                       `
; ----------------------------------------------------------------------------
L0616:      ldy     curDrive                        ; 0616 AC 89 84                 ...
        lda     $8486,y                         ; 0619 B9 86 84                 ...
        beq     L0649                           ; 061C F0 2B                    .+
        tay                                     ; 061E A8                       .
        jsr     L0A76                           ; 061F 20 76 0A                  v.
        lda     L06AD,y                         ; 0622 B9 AD 06                 ...
        bne     L0649                           ; 0625 D0 22                    ."
        lda     #$FF                            ; 0627 A9 FF                    ..
        sta     L06AD,y                         ; 0629 99 AD 06                 ...
        lda     L0A64,y                         ; 062C B9 64 0A                 .d.
        sta     r1L                             ; 062F 85 04                    ..
        lda     L0A69,y                         ; 0631 B9 69 0A                 .i.
        sta     r1H                             ; 0634 85 05                    ..
        lda     #$90                            ; 0636 A9 90                    ..
        sta     r0H                             ; 0638 85 03                    ..
        lda     #$00                            ; 063A A9 00                    ..
        sta     r0L                             ; 063C 85 02                    ..
        lda     #$0D                            ; 063E A9 0D                    ..
        sta     r2H                             ; 0640 85 07                    ..
        lda     #$80                            ; 0642 A9 80                    ..
        sta     r2L                             ; 0644 85 06                    ..
        jsr     MoveData                        ; 0646 20 7E C1                  ~.
L0649:  rts                                     ; 0649 60                       `
; ----------------------------------------------------------------------------
L064A:  lda     V2106                           ; 064A AD 06 21                 ..!
        jsr     L0672                           ; 064D 20 72 06                  r.
	bne     L0671                           ; 0650 D0 1F                    ..
        lda     V2107                           ; 0652 AD 07 21                 ..!
        jsr     L0672                           ; 0655 20 72 06                  r.
        bne     L0671                           ; 0658 D0 17                    ..
        lda     V2108                           ; 065A AD 08 21                 ..!
        jsr     L0672                           ; 065D 20 72 06                  r.
        bne     L0671                           ; 0660 D0 0F                    ..
	lda     V2108a                          ; 065A AD 08 21                 ..!
        jsr     L0672                           ; 065D 20 72 06                  r.
        bne     L0671                           ; 0660 D0 0F                    ..
        ldx     #$00                            ; 0662 A2 00                    ..
        lda     L06AC                           ; 0664 AD AC 06                 ...
        beq     L0671                           ; 0667 F0 08                    ..
        jsr     CloseRecordFile                 ; 0669 20 77 C2                  w.
        lda     #$00                            ; 066C A9 00                    ..
        sta     L06AC                           ; 066E 8D AC 06                 ...
L0671:  rts                                     ; 0671 60                       `
; ----------------------------------------------------------------------------
L0672:  ldx     #$00                            ; 0672 A2 00                    ..
        tay                                     ; 0674 A8                       .
        beq     L06AA                           ; 0675 F0 33                    .3
        
	; get VLIR record offset from type
	jsr     L0A76                           ; 0677 20 76 0A                  v.
        
	; already loaded?
	lda     L06AD,y                         ; 067A B9 AD 06                 ...
        bne     L06AA                           ; 067D D0 2B                    .+
        
	tya                                     ; 067F 98                       .
        pha                                     ; 0680 48                       H
        jsr     OpenConfigFile                           ; 0681 20 22 05                  ".
        pla                                     ; 0684 68                       h
        tay                                     ; 0685 A8                       .
        txa                                     ; 0686 8A                       .
        bne     L06AA                           ; 0687 D0 21                    .!
        
	lda     #$FF                            ; 0689 A9 FF                    ..
        sta     L06AD,y                         ; 068B 99 AD 06                 ...
        
	lda     L0A64,y                         ; 068E B9 64 0A                 .d.
        sta     r7L                             ; 0691 85 10                    ..
        lda     L0A69,y                         ; 0693 B9 69 0A                 .i.
        sta     r7H                             ; 0696 85 11                    ..
        
	tya                                     ; 0698 98                       .
        clc                                     ; 0699 18                       .
        adc     #$02                            ; 069A 69 02                    i.
	jsr     PointRecord                     ; 069C 20 80 C2                  ..
        lda     #$0D                            ; 069F A9 0D                    ..
        sta     r2H                             ; 06A1 85 07                    ..
        lda     #$80                            ; 06A3 A9 80                    ..
        sta     r2L                             ; 06A5 85 06                    ..
        jsr     ReadRecord                      ; 06A7 20 8C C2                  ..
L06AA:  txa                                     ; 06AA 8A                       .
        rts                                     ; 06AB 60                       `


SetupDefaulDrives:
	jsr	SetupVirtual
	jsr	SetupInternalFloppy
	jsr	SetupSDMountD81
	jsr	SetupSDMountD71
	rts

; potentially, bootet from drive 1 there might
; still be a virtual drive
SetupVirtual:
	lda	$D68A
	bit	#4
	beq 	@1	; branch if drive 0 is non-virtual
	ldx	#0
@3:
	lda	V2106, x
	cmp	#DRV_F011_V
	beq	@1
	inx
	cpx	#4
	bne	@3
	
	; no virtual drive found
	ldx	#0
@4:
	lda	V2106, x
	beq	@2
	inx	
	cpx	#4
	bne	@4
	bra	@1
			
	; setup virtual
@2:
	lda	#DRV_F011_V
	sta	V2106, x

@1:	; there is already a virtual drive
	rts
	
SetupInternalFloppy:
	ldx	#0
@3:
	lda	V2106, x
	cmp	#DRV_F011_0
	beq	@1
	inx
	cpx	#4
	bne	@3

	; no real floppy yet
	ldx	#0
@4:
	lda	V2106, x
	beq	@2
	inx	
	cpx	#4
	bne	@4
	bra	@1

	; setup floppy
@2:
	lda	#DRV_F011_0
	sta	V2106, x
@1:
	rts
	
SetupSDMountD81:
	ldx	#0
@3:
	lda	V2106, x
	cmp	#DRV_SD_81
	beq	@1
	inx
	cpx	#4
	bne	@3

; no real floppy yet
	ldx	#0
@4:
	lda	V2106, x
	beq	@2
	inx	
	cpx	#4
	bne	@4
	bra	@1

; setup floppy
@2:
	lda	#DRV_SD_81
	sta	V2106, x
@1:
	rts
	
SetupSDMountD71:
	rts

GetFreeDrive:
	ldx	#0
@2:
	lda	driveType, x
	beq	@1
	inx
	cpx	#4
	bne	@2
	sec
	rts
	
@1:	clc
	rts

; ----------------------------------------------------------------------------
L06AC:  brk                                     ; 06AC 00                       .
L06AD:  brk                                     ; 06AD 00                       .
        brk                                     ; 06AE 00                       .
        brk                                     ; 06AF 00                       .
        brk                                     ; 06B0 00                       .
        brk                                     ; 06B1 00                       .
		.byte 	0
L06B2:  lda     #$01                            ; 06B2 A9 01                    ..
        sta     r0L                             ; 06B4 85 02                    ..
        lda     V2104                           ; 06B6 AD 04 21                 ..!
        eor     #$01                            ; 06B9 49 01                    I.
        tay                                     ; 06BB A8                       .
        lda     $03FE,y                         ; 06BC B9 FE 03                 ...
        ldx     V2107                           ; 06BF AE 07 21                 ..!
        jsr     L06EB                           ; 06C2 20 EB 06                  ..
        sta     V2107                           ; 06C5 8D 07 21                 ..!
        
	ldy     V2104                           ; 06C8 AC 04 21                 ..!
        lda     $03FE,y                         ; 06CB B9 FE 03                 ...
        and     #$7F                            ; 06CE 29 7F                    ).
        ldx     V2106                           ; 06D0 AE 06 21                 ..!
        jsr     L06EB                           ; 06D3 20 EB 06                  ..
        sta     V2106                           ; 06D6 8D 06 21                 ..!

	; if ram drive, config drive c
        lda     ramExpSize                      ; 06D9 AD C3 88                 ...
        beq     L06E7                           ; 06DC F0 09                    ..
        
	lda     L0408                           ; 06DE AD 08 04                 ...
        ldx     V2108                           ; 06E1 AE 08 21                 ..!
        jsr     L06EB                           ; 06E4 20 EB 06                  ..
L06E7:  sta     V2108                           ; 06E7 8D 08 21                 ..!

	; if ram drive, config drive d
	lda     ramExpSize                      ; 06D9 AD C3 88                 ...
	beq     L06E7b                           ; 06DC F0 09                    ..

	lda     L0408+1                           ; 06DE AD 08 04                 ...
	ldx     V2108a                           ; 06E1 AE 08 21                 ..!
	jsr     L06EB                           ; 06E4 20 EB 06                  ..
L06E7b:  sta     V2108a                           ; 06E7 8D 08 21                 ..!

        rts                                     ; 06EA 60                       `
; ----------------------------------------------------------------------------
; init save drive options
; x = detected drive type
; a = saved drive type
; ret a = resulting drive type

L06EB:  stx     r2L                             ; 06EB 86 06                    ..
        sta     r2H                             ; 06ED 85 07                    ..
        jsr     L09AD                           ; 06EF 20 AD 09                  ..
        clc                                     ; 06F2 18                       .
        adc     r0L                             ; 06F3 65 02                    e.
        cmp     ramExpSize                      ; 06F5 CD C3 88                 ...
        bcc     L0704                           ; 06F8 90 0A                    ..
        beq     L0704                           ; 06FA F0 08                    ..
        
	; no ram left, return pure resulting drive type
	lda     r2H                             ; 06FC A5 07                    ..
        and     #$3F                            ; 06FE 29 3F                    )?
        sta     r2H                             ; 0700 85 07                    ..
        lda     r0L                             ; 0702 A5 02                    ..
L0704:  
	; remember next free bank
	sta     r0H                             ; 0704 85 03                    ..
        lda     r2H                             ; 0706 A5 07                    ..
        bpl     L0711                           ; 0708 10 07                    ..
        
	; init ram drive
	lda     r0H                             ; 070A A5 03                    ..
        sta     r0L                             ; 070C 85 02                    ..
        
	; return resulting drive type
	lda     r2H                             ; 070E A5 07                    ..
        rts                                     ; 0710 60                       `
; ----------------------------------------------------------------------------
; init ram backed drive
; if detected 1571 but save 1541, force to 1541
L0711:  and     #$0F                            ; 0711 29 0F                    ).
        cmp     #$01                            ; 0713 C9 01                    ..
        bne     L0721                           ; 0715 D0 0A                    ..
        lda     r2L                             ; 0717 A5 06                    ..
        cmp     #$02                            ; 0719 C9 02                    ..
        bne     L0721                           ; 071B D0 04                    ..
        lda     #$01                            ; 071D A9 01                    ..
        sta     r2L                             ; 071F 85 06                    ..
L0721:  lda     r2H                             ; 0721 A5 07                    ..
        and     #$40                            ; 0723 29 40                    )@
        beq     L0736                           ; 0725 F0 0F                    ..
        
	; ram shadow drive
	lda     r2H                             ; 0727 A5 07                    ..
        and     #$0F                            ; 0729 29 0F                    ).
        cmp     r2L                             ; 072B C5 06                    ..
        bne     L0736                           ; 072D D0 07                    ..
        lda     r0H                             ; 072F A5 03                    ..
        sta     r0L                             ; 0731 85 02                    ..
        lda     r2H                             ; 0733 A5 07                    ..
        rts                                     ; 0735 60                       `
; ----------------------------------------------------------------------------
L0736:  lda     r2L                             ; 0736 A5 06                    ..
        rts                                     ; 0738 60                       `
;rts
; ----------------------------------------------------------------------------
L0739:  lda     curDrive                        ; 0739 AD 89 84                 ...
        eor     #$01                            ; 073C 49 01                    I.
InitDrive:
	;ldy     curDrive                        ; 074D AC 89 84                 ...
        ;lda     $8486,y                         ; 0750 B9 86 84                 ...
        ;beq     L0768                           ; 0753 F0 06                    ..

	jsr     SetDevice                       ; 073E 20 B0 C2                  ..
        txa                                     ; 0741 8A                       .
        bne     L0768                           ; 0742 D0 24                    .$

	lda	firstBoot
	cmp     #$FF                    
        bne     @10	
	ldy	curDrive
	lda	VarImageDriveType-8,y
	cmp	#DRV_SD_81
	bne 	@10
	cmp	driveType-8,y
	bne	@10
	LoadW	r0, VarImageFileNames
@12:
	cpy	#8
	beq 	@11
	AddVW	64, r0
	dey
	bra	@12
@11:
	jsr	SetImageFile
@10:

.ifndef config128
        lda     ramExpSize                      ; 0744 AD C3 88                 ...
        bne     L075F                           ; 0747 D0 16                    ..
        lda     V212F                           ; 0749 AD 2F 21                 ./!
        pha                                     ; 074C 48                       H
        ldy     curDrive                        ; 074D AC 89 84                 ...
        lda     $8486,y                         ; 0750 B9 86 84                 ...
        beq     L075B                           ; 0753 F0 06                    ..
        sta     V212F                           ; 0755 8D 2F 21                 ./!
        jsr     InstallDriver                           ; 0758 20 C8 09                  ..
L075B:  pla                                     ; 075B 68                       h
        sta     V212F                           ; 075C 8D 2F 21                 ./!
.endif
L075F:  ldy     curDrive                        ; 075F AC 89 84                 ...
        lda     $8486,y                         ; 0762 B9 86 84                 ...
        sta     curType                         ; 0765 8D C6 88                 ...
L0768:  rts                                     ; 0768 60                       `
; ----------------------------------------------------------------------------
L0769:  pha                                     ; 0769 48                       H
        lda     #$00                            ; 076A A9 00                    ..
        sta     V212C                           ; 076C 8D 2C 21                 .,!
        lda     curDrive                        ; 076F AD 89 84                 ...
        sta     V212B                           ; 0772 8D 2B 21                 .+!
        pla                                     ; 0775 68                       h
        beq     L07B6                           ; 0776 F0 3E                    .>
        cmp     #$01                            ; 0778 C9 01                    ..
        bne     L077F                           ; 077A D0 03                    ..
        jmp     L07B7                           ; 077C 4C B7 07                 L..
; ----------------------------------------------------------------------------
L077F:  cmp     #$02                            ; 077F C9 02                    ..
        bne     L0786                           ; 0781 D0 03                    ..
        jmp     L07DF                           ; 0783 4C DF 07                 L..
; ----------------------------------------------------------------------------
L0786:  cmp     #$03                            ; 0786 C9 03                    ..
        bne     @1                              ; 0788 D0 03                    ..
        jmp     L07EF                           ; 078A 4C EF 07                 L..
@1:	cmp	#DRV_SD_81
	bne	@2
	jmp	InitSD81
@2:	cmp	#DRV_SD_71
	bne 	@3
	jmp	InitSD71
@3:	cmp	#DRV_F011_0
	bne	@4
	jmp	InitF011
@4:	cmp	#DRV_F011_V
	bne	L078D
	jmp	InitVirtual
; ----------------------------------------------------------------------------
L078D:  cmp     #$41                            ; 078D C9 41                    .A
        bne     L0797                           ; 078F D0 06                    ..
        jsr     L07B7                           ; 0791 20 B7 07                  ..
        jmp     L07FF                           ; 0794 4C FF 07                 L..
; ----------------------------------------------------------------------------
L0797:  cmp     #$43                            ; 0797 C9 43                    .C
        bne     L07A1                           ; 0799 D0 06                    ..
        jsr     L07EF                           ; 079B 20 EF 07                  ..
        jmp     L0820                           ; 079E 4C 20 08                 L .
; ----------------------------------------------------------------------------
L07A1:  cmp     #$81                            ; 07A1 C9 81                    ..
        bne     L07A8                           ; 07A3 D0 03                    ..
        jmp     L0841                           ; 07A5 4C 41 08                 LA.
; ----------------------------------------------------------------------------
L07A8:  cmp     #$82                            ; 07A8 C9 82                    ..
        bne     L07AF                           ; 07AA D0 03                    ..
        jmp     L0873                           ; 07AC 4C 73 08                 Ls.
; ----------------------------------------------------------------------------
L07AF:  cmp     #$83                            ; 07AF C9 83                    ..
        bne     L07B6                           ; 07B1 D0 03                    ..
        jmp     L08A5                           ; 07B3 4C A5 08                 L..
; ----------------------------------------------------------------------------
L07B6:  rts                                     ; 07B6 60                       `
; ----------------------------------------------------------------------------
Init1541:
L07B7:  lda     V212C                           ; 07B7 AD 2C 21                 .,!
        cmp     #$01                            ; 07BA C9 01                    ..
        beq     L07DE                           ; 07BC F0 20                    .
        cmp     #$41                            ; 07BE C9 41                    .A
        bne     L07D6                           ; 07C0 D0 14                    ..
        ldy     V212B                           ; 07C2 AC 2B 21                 .+!
        lda     #$01                            ; 07C5 A9 01                    ..
        sta     $8486,y                         ; 07C7 99 86 84                 ...
        sta     $03FE,y                         ; 07CA 99 FE 03                 ...
        lda     #$00                            ; 07CD A9 00                    ..
        sta     driveData,y                     ; 07CF 99 BF 88                 ...
        dec     L180C                           ; 07D2 CE 0C 18                 ...
        rts                                     ; 07D5 60                       `
; ----------------------------------------------------------------------------
L07D6:  lda     #$01                            ; 07D6 A9 01                    ..
        sta     V212F                           ; 07D8 8D 2F 21                 ./!
        jmp     InitNewDrive                           ; 07DB 4C D7 08                 L..
; ----------------------------------------------------------------------------
L07DE:  rts                                     ; 07DE 60                       `
; ----------------------------------------------------------------------------
Init1571:
L07DF:  lda     V212C                           ; 07DF AD 2C 21                 .,!
        cmp     #$02                            ; 07E2 C9 02                    ..
        beq     L07EE                           ; 07E4 F0 08                    ..
        lda     #$02                            ; 07E6 A9 02                    ..
        sta     V212F                           ; 07E8 8D 2F 21                 ./!
        jmp     InitNewDrive                           ; 07EB 4C D7 08                 L..
; ----------------------------------------------------------------------------
L07EE:  rts                                     ; 07EE 60                       `
; ----------------------------------------------------------------------------
Init1581:
L07EF:  lda     V212C                           ; 07EF AD 2C 21                 .,!
        cmp     #$03                            ; 07F2 C9 03                    ..
        beq     L07FE                           ; 07F4 F0 08                    ..
        lda     #$03                            ; 07F6 A9 03                    ..
        sta     V212F                           ; 07F8 8D 2F 21                 ./!
        jmp     InitNewDrive                           ; 07FB 4C D7 08                 L..
; ----------------------------------------------------------------------------
L07FE:  rts                                     ; 07FE 60                       `
; ----------------------------------------------------------------------------
InitF011:	
	lda     V212C                           ; 07EF AD 2C 21                 .,!
        cmp     #$04                            ; 07F2 C9 03                    ..
        beq     L07FE                           ; 07F4 F0 08                    ..

        lda     #$04                            ; 07F6 A9 03                    ..
        sta     V212F                           ; 07F8 8D 2F 21                 ./!
        jsr     InitNewDrive                           ; 07FB 4C D7 08                 L..

	rts
; ----------------------------------------------------------------------------
InitF011_1:	
	lda     V212C                           ; 07EF AD 2C 21                 .,!
        cmp     #$05                            ; 07F2 C9 03                    ..
        beq     L07FE                           ; 07F4 F0 08                    ..

        lda     #$05                            ; 07F6 A9 03                    ..
        sta     V212F                           ; 07F8 8D 2F 21                 ./!
        jsr     InitNewDrive                           ; 07FB 4C D7 08                 L..

	rts
; ----------------------------------------------------------------------------
InitSD81:
	lda     V212C                           ; 07EF AD 2C 21                 .,!
        cmp     #$06                            ; 07F2 C9 03                    ..
        beq     L07FE                           ; 07F4 F0 08                    ..
        lda     #$06                            ; 07F6 A9 03                    ..
        sta     V212F                           ; 07F8 8D 2F 21                 ./!
        jmp     InitNewDrive                           ; 07FB 4C D7 08                 L..
; ----------------------------------------------------------------------------
InitVirtual:
	lda     V212C                           ; 07EF AD 2C 21                 .,!
        cmp     #$08                            ; 07F2 C9 03                    ..
        beq     L07FE                           ; 07F4 F0 08                    ..
        lda     #$08                            ; 07F6 A9 03                    ..
        sta     V212F                           ; 07F8 8D 2F 21                 ./!
	jmp     InitNewDrive                           ; 07FB 4C D7 08                 L..
; ----------------------------------------------------------------------------
InitSD:
	lda     V212C                           ; 07EF AD 2C 21                 .,!
        cmp     #DRV_SD_81
	beq     L07FE                        
	cmp     #DRV_SD_71
	beq     L07FE                        
        
	lda     #DRV_SD_81                      ; 07F6 A9 03                    ..
        sta     V212F                           ; 07F8 8D 2F 21                 ./!
        jmp     InitNewDrive                           ; 07FB 4C D7 08                 L..
; ----------------------------------------------------------------------------
InitFloppy:
	lda     V212C                           ; 07EF AD 2C 21                 .,!
        cmp     #DRV_F011_0
	beq     L07FE                        
	cmp     #DRV_F011_1
	beq     L07FE                        
        
	lda     #DRV_F011_0                     ; 07F6 A9 03                    ..
        sta     V212F                           ; 07F8 8D 2F 21                 ./!
        jmp     InitNewDrive                           ; 07FB 4C D7 08                 L..
; ----------------------------------------------------------------------------
InitSD71:
	lda     V212C                           ; 07EF AD 2C 21                 .,!
        cmp     #$07                            ; 07F2 C9 03                    ..
        beq     L07FE                           ; 07F4 F0 08                    ..
        lda     #$07                            ; 07F6 A9 03                    ..
        sta     V212F                           ; 07F8 8D 2F 21                 ./!
        jmp     InitNewDrive                           ; 07FB 4C D7 08                 L..
; ----------------------------------------------------------------------------
AlreadyF011:  rts                                     ; 07FE 60                       `
; ----------------------------------------------------------------------------
InitShadowed1541:
L07FF:  lda     V212C                           ; 07FF AD 2C 21                 .,!
        cmp     #$41                            ; 0802 C9 41                    .A
        beq     L081F                           ; 0804 F0 19                    ..
        lda     #$41                            ; 0806 A9 41                    .A
        jsr     L0911                           ; 0808 20 11 09                  ..
        ldy     V212B                           ; 080B AC 2B 21                 .+!
        sta     driveData,y                     ; 080E 99 BF 88                 ...
        lda     #$41                            ; 0811 A9 41                    .A
        sta     $8486,y                         ; 0813 99 86 84                 ...
        sta     $03FE,y                         ; 0816 99 FE 03                 ...
        jsr     NewDisk                         ; 0819 20 E1 C1                  ..
        dec     L180C                           ; 081C CE 0C 18                 ...
L081F:  rts                                     ; 081F 60                       `
; ----------------------------------------------------------------------------
InitShadowed1581:
L0820:  lda     V212C                           ; 0820 AD 2C 21                 .,!
        cmp     #$43                            ; 0823 C9 43                    .C
        beq     L0840                           ; 0825 F0 19                    ..
        lda     #$43                            ; 0827 A9 43                    .C
        jsr     L0911                           ; 0829 20 11 09                  ..
        ldy     V212B                           ; 082C AC 2B 21                 .+!
        sta     driveData,y                     ; 082F 99 BF 88                 ...
        lda     #$43                            ; 0832 A9 43                    .C
        sta     $8486,y                         ; 0834 99 86 84                 ...
        sta     $03FE,y                         ; 0837 99 FE 03                 ...
        jsr     NewDisk                         ; 083A 20 E1 C1                  ..
        dec     L180C                           ; 083D CE 0C 18                 ...
L0840:  rts                                     ; 0840 60                       `
; ----------------------------------------------------------------------------
InitRAM1541:
L0841:  lda     V212C                           ; 0841 AD 2C 21                 .,!
        cmp     #$81                            ; 0844 C9 81                    ..
        beq     L0872                           ; 0846 F0 2A                    .*
        lda     #$81                            ; 0848 A9 81                    ..
        sta     V212F                           ; 084A 8D 2F 21                 ./!
        jsr     InstallDriver                           ; 084D 20 C8 09                  ..
        inc     NUMDRV                          ; 0850 EE 8D 84                 ...
        lda     #$81                            ; 0853 A9 81                    ..
        jsr     L0911                           ; 0855 20 11 09                  ..
        ldy     V212B                           ; 0858 AC 2B 21                 .+!
        sta     driveData,y                     ; 085B 99 BF 88                 ...
        lda     #$81                            ; 085E A9 81                    ..
        sta     $8486,y                         ; 0860 99 86 84                 ...
        sta     $03FE,y                         ; 0863 99 FE 03                 ...
        lda     V212B                           ; 0866 AD 2B 21                 .+!
        jsr     InitDrive                           ; 0869 20 3E 07                  >.
        jsr     L0A8A                           ; 086C 20 8A 0A                  ..
        dec     L180C                           ; 086F CE 0C 18                 ...
L0872:  rts                                     ; 0872 60                       `
; ----------------------------------------------------------------------------
InitRAM1571:
L0873:  lda     V212C                           ; 0873 AD 2C 21                 .,!
        cmp     #$82                            ; 0876 C9 82                    ..
        beq     L08A4                           ; 0878 F0 2A                    .*
        lda     #$82                            ; 087A A9 82                    ..
        sta     V212F                           ; 087C 8D 2F 21                 ./!
        jsr     InstallDriver                           ; 087F 20 C8 09                  ..
        inc     NUMDRV                          ; 0882 EE 8D 84                 ...
        lda     #$82                            ; 0885 A9 82                    ..
        jsr     L0911                           ; 0887 20 11 09                  ..
        ldy     V212B                           ; 088A AC 2B 21                 .+!
        sta     driveData,y                     ; 088D 99 BF 88                 ...
        lda     #$82                            ; 0890 A9 82                    ..
        sta     $8486,y                         ; 0892 99 86 84                 ...
        sta     $03FE,y                         ; 0895 99 FE 03                 ...
        lda     V212B                           ; 0898 AD 2B 21                 .+!
        jsr     InitDrive                           ; 089B 20 3E 07                  >.
        
	jsr     L0A8A                           ; 089E 20 8A 0A                  ..
        dec     L180C                           ; 08A1 CE 0C 18                 ...
L08A4:  rts                                     ; 08A4 60                       `
; ----------------------------------------------------------------------------
InitRAM:
InitRAM1581:
L08A5:  lda     V212C                           ; 08A5 AD 2C 21                 .,!
        cmp     #$83                            ; 08A8 C9 83                    ..
        beq     L08D6                           ; 08AA F0 2A                    .*
        lda     #$83                            ; 08AC A9 83                    ..
        sta     V212F                           ; 08AE 8D 2F 21                 ./!
	jsr     InstallDriver                           ; 08B1 20 C8 09                  ..
        inc     NUMDRV                          ; 08B4 EE 8D 84                 ...

        lda     #$83                            ; 08B7 A9 83                    ..
        jsr     L0911                           ; 08B9 20 11 09                  ..
        ldy     V212B                           ; 08BC AC 2B 21                 .+!
        sta     driveData,y                     ; 08BF 99 BF 88                 ...
        lda     #$83                            ; 08C2 A9 83                    ..
        sta     $8486,y                         ; 08C4 99 86 84                 ...
        sta     $03FE,y                         ; 08C7 99 FE 03                 ...
        lda     V212B                           ; 08CA AD 2B 21                 .+!
        jsr     InitDrive                           ; 08CD 20 3E 07                  >.
        jsr     L0A8A                           ; 08D0 20 8A 0A                  ..
        dec     L180C                           ; 08D3 CE 0C 18                 ...
L08D6:  rts                                     ; 08D6 60                       `
; ----------------------------------------------------------------------------
InitNewDrive:  ; init drive driver
		jsr     InstallDriver                           ; 08D7 20 C8 09                  ..
	lda     V212B                           ; 08DA AD 2B 21                 .+!
        jsr     InitDrive                           ; 08DD 20 3E 07                  >.
        lda     firstBoot                       ; 08E0 AD C5 88                 ...
        cmp     #$FF                            ; 08E3 C9 FF                    ..
        beq     L08F6                           ; 08E5 F0 0F                    ..

		ldy     V212B                           ; 08E7 AC 2B 21                 .+!
        lda     V212F                           ; 08EA AD 2F 21                 ./!
        sta     $8486,y                         ; 08ED 99 86 84                 ...
        inc     NUMDRV                          ; 08F0 EE 8D 84                 ...
.if 0
	cmp	#DRV_SD_81
	bne	@10
	;brk
	cpy	V2104
	bne	@10
	;brk
	LoadW	r0, VarImageFileName
	jsr	SetImageFile
@10:
.endif
	clv                                     ; 08F3 B8                       .
        bvc     L08FF                           ; 08F4 50 09                    P.
L08F6:
        ; handle non first boot setup, using dialogs
	jsr     SetupDrive                           ; 08F6 20 05 1E                  ..
        lda     V212B                           ; 08F9 AD 2B 21                 .+!
        jsr     InitDrive                           ; 08FC 20 3E 07                  >.
L08FF:  dec     L180C                           ; 08FF CE 0C 18                 ...
        ldy     V212B                           ; 0902 AC 2B 21                 .+!
        lda     $8486,y                         ; 0905 B9 86 84                 ...
        sta     $03FE,y                         ; 0908 99 FE 03                 ...
        lda     #$00                            ; 090B A9 00                    ..
        sta     driveData,y                     ; 090D 99 BF 88                 ...

	lda     $8486,y                         ; 0905 B9 86 84                 ...
.if 0
	cmp	#DRV_SD_81
	bne	@10
	;brk
	cpy	V2104
	bne	@10
	;brk
	LoadW	r0, VarImageFileName
	jsr	SetImageFile
@10:
.endif
        rts                                     ; 0910 60                       `
; ----------------------------------------------------------------------------
L0911:  pha                                     ; 0911 48                       H
        jsr     L0977                           ; 0912 20 77 09                  w.
        pla                                     ; 0915 68                       h
        sta     r0L                             ; 0916 85 02                    ..
        lda     V212C                           ; 0918 AD 2C 21                 .,!
        and     #$C0                            ; 091B 29 C0                    ).
        bne     L092A                           ; 091D D0 0B                    ..
        lda     r0L                             ; 091F A5 02                    ..
        jsr     L09AD                           ; 0921 20 AD 09                  ..
        cmp     #$01                            ; 0924 C9 01                    ..
        beq     L0933                           ; 0926 F0 0B                    ..
        bne     L0945                           ; 0928 D0 1B                    ..
L092A:  ldy     V212B                           ; 092A AC 2B 21                 .+!
        lda     driveData,y                     ; 092D B9 BF 88                 ...
        ldx     #$00                            ; 0930 A2 00                    ..
        rts                                     ; 0932 60                       `
; ----------------------------------------------------------------------------
L0933:  ldy     ramExpSize                      ; 0933 AC C3 88                 ...
L0936:  dey                                     ; 0936 88                       .
        bmi     L0942                           ; 0937 30 09                    0.
        lda     V2130,y                         ; 0939 B9 30 21                 .0!
        bne     L0936                           ; 093C D0 F8                    ..
        tya                                     ; 093E 98                       .
        ldx     #$00                            ; 093F A2 00                    ..
        rts                                     ; 0941 60                       `
; ----------------------------------------------------------------------------
L0942:  ldx     #$FF                            ; 0942 A2 FF                    ..
        rts                                     ; 0944 60                       `
; ----------------------------------------------------------------------------
L0945:  sta     r0L                             ; 0945 85 02                    ..
        ldy     #$00                            ; 0947 A0 00                    ..
L0949:  lda     r0L                             ; 0949 A5 02                    ..
        sta     r0H                             ; 094B 85 03                    ..
L094D:  sty     r1L                             ; 094D 84 04                    ..
        cpy     ramExpSize                      ; 094F CC C3 88                 ...
        bcs     L0974                           ; 0952 B0 20                    .
        lda     V2130,y                         ; 0954 B9 30 21                 .0!
        iny                                     ; 0957 C8                       .
        cmp     #$00                            ; 0958 C9 00                    ..
        bne     L094D                           ; 095A D0 F1                    ..
L095C:  dec     r0H                             ; 095C C6 03                    ..
        beq     L096F                           ; 095E F0 0F                    ..
        cpy     ramExpSize                      ; 0960 CC C3 88                 ...
        bcs     L0974                           ; 0963 B0 0F                    ..
        lda     V2130,y                         ; 0965 B9 30 21                 .0!
        iny                                     ; 0968 C8                       .
        cmp     #$00                            ; 0969 C9 00                    ..
        bne     L0949                           ; 096B D0 DC                    ..
        beq     L095C                           ; 096D F0 ED                    ..
L096F:  lda     r1L                             ; 096F A5 04                    ..
        ldx     #$00                            ; 0971 A2 00                    ..
        rts                                     ; 0973 60                       `
; ----------------------------------------------------------------------------
L0974:  ldx     #$FF                            ; 0974 A2 FF                    ..
        rts                                     ; 0976 60                       `
; ----------------------------------------------------------------------------
L0977:  ldy     #$1F                            ; 0977 A0 1F                    ..
        lda     #$00                            ; 0979 A9 00                    ..
L097B:  sta     V2130,y                         ; 097B 99 30 21                 .0!
        dey                                     ; 097E 88                       .
        bpl     L097B                           ; 097F 10 FA                    ..
        lda     #$FF                            ; 0981 A9 FF                    ..
        sta     V2130                           ; 0983 8D 30 21                 .0!
        lda     #$08                            ; 0986 A9 08                    ..
        sta     r0L                             ; 0988 85 02                    ..
L098A:  ldy     r0L                             ; 098A A4 02                    ..
        lda     $8486,y                         ; 098C B9 86 84                 ...
        jsr     L09AD                           ; 098F 20 AD 09                  ..
        tax                                     ; 0992 AA                       .
        beq     L09A4                           ; 0993 F0 0F                    ..
        ldy     r0L                             ; 0995 A4 02                    ..
        lda     driveData,y                     ; 0997 B9 BF 88                 ...
        tay                                     ; 099A A8                       .
L099B:  lda     #$FF                            ; 099B A9 FF                    ..
        sta     V2130,y                         ; 099D 99 30 21                 .0!
        iny                                     ; 09A0 C8                       .
        dex                                     ; 09A1 CA                       .
        bne     L099B                           ; 09A2 D0 F7                    ..
L09A4:  inc     r0L                             ; 09A4 E6 02                    ..
        lda     r0L                             ; 09A6 A5 02                    ..
        cmp     #$0C                            ; 09A8 C9 0C                    ..
        bcc     L098A                           ; 09AA 90 DE                    ..
        rts                                     ; 09AC 60                       `
; ----------------------------------------------------------------------------
; get RAM block required for RAM backed drive type
L09AD:  sta     r0H                             ; 09AD 85 03                    ..
        and     #$C0                            ; 09AF 29 C0                    ).
        beq     L09C2                           ; 09B1 F0 0F                    ..
        lda     r0H                             ; 09B3 A5 03                    ..
        cmp     #$83                            ; 09B5 C9 83                    ..
        bne     L09BC                           ; 09B7 D0 03                    ..
        clc                                     ; 09B9 18                       .
        adc     #$01                            ; 09BA 69 01                    i.
L09BC:  and     #$0F                            ; 09BC 29 0F                    ).
        tay                                     ; 09BE A8                       .
        lda     L09C3,y                         ; 09BF B9 C3 09                 ...
L09C2:  rts                                     ; 09C2 60                       `
; ----------------------------------------------------------------------------
L09C3:  .byte   $03                             ; 09C3 03                       .
        .byte   $03                             ; 09C4 03                       .
        asl     CPU_DATA                        ; 09C5 06 01                    ..
        .byte   $0D                             ; 09C7 0D                       .
InstallDriver:  lda     ramExpSize                      ; 09C8 AD C3 88                 ...
        bne     L09F0                           ; 09CB D0 23                    .#
        lda     sysRAMFlg                       ; 09CD AD C4 88                 ...
        and     #$BF                            ; 09D0 29 BF                    ).
        sta     sysRAMFlg                       ; 09D2 8D C4 88                 ...
        sta     sysFlgCopy                      ; 09D5 8D 12 C0                 ...
        sta     L040A                           ; 09D8 8D 0A 04                 ...
        ldy     V212F                           ; 09DB AC 2F 21                 ./!
        lda     V212B                           ; 09DE AD 2B 21                 .+!
        jsr     L0A3D                           ; 09E1 20 3D 0A                  =.
        lda     #$90                            ; 09E4 A9 90                    ..
        sta     r1H                             ; 09E6 85 05                    ..
        lda     #$00                            ; 09E8 A9 00                    ..
        sta     r1L                             ; 09EA 85 04                    ..
        jsr     MoveData                        ; 09EC 20 7E C1                  ~.
        rts                                     ; 09EF 60                       `
; ----------------------------------------------------------------------------
L09F0:  lda     sysRAMFlg                       ; 09F0 AD C4 88                 ...
        ora     #$40                            ; 09F3 09 40                    .@
        sta     sysRAMFlg                       ; 09F5 8D C4 88                 ...
        sta     sysFlgCopy                      ; 09F8 8D 12 C0                 ...
        sta     L040A                           ; 09FB 8D 0A 04                 ...
	
	; stash driver a driver
        ldy     driveType                       ; 09FE AC 8E 84                 ...
        beq     L0A0B                           ; 0A01 F0 08                    ..
        lda     #$08                            ; 0A03 A9 08                    ..
        jsr     L0A3D                           ; 0A05 20 3D 0A                  =.
        jsr     StashRAM                        ; 0A08 20 C8 C2                  ..

	; stash driver b driver
L0A0B:  ldy     $848F                           ; 0A0B AC 8F 84                 ...
        beq     L0A18                           ; 0A0E F0 08                    ..
        lda     #$09                            ; 0A10 A9 09                    ..
        jsr     L0A3D

	ldy	$848F

	jsr     StashRAM

	; stash driver c driver
L0A18:  ldy     $8490                           ; 0A18 AC 90 84                 ...
        beq     L0A18_D                           ; 0A1B F0 08                    ..
        lda     #$0A                            ; 0A1D A9 0A                    ..
        jsr     L0A3D                           ; 0A1F 20 3D 0A                  =.
        jsr     StashRAM                        ; 0A22 20 C8 C2                  ..

	; stash driver d driver
L0A18_D:  
	ldy     $8491                          ; 0A18 AC 90 84                 ...
        beq     L0A25                           ; 0A1B F0 08                    ..
        lda     #$0B                            ; 0A1D A9 0A                    ..
        jsr     L0A3D                           ; 0A1F 20 3D 0A                  =.
        jsr     StashRAM                        ; 0A22 20 C8 C2                  ..

L0A25:  
	ldy     V212F                           ; 0A25 AC 2F 21                 ./!

        lda     V212B                           ; 0A28 AD 2B 21                 .+!
        jsr     L0A3D                           ; 0A2B 20 3D 0A                  =.
        jsr     StashRAM                        ; 0A2E 20 C8 C2                  ..
        lda     #$90                            ; 0A31 A9 90                    ..
        sta     r1H                             ; 0A33 85 05                    ..
        lda     #$00                            ; 0A35 A9 00                    ..
        sta     r1L                             ; 0A37 85 04                    ..
        jsr     MoveData                        ; 0A39 20 7E C1                  ~.

	ldy     V212F                           ; 0A25 AC 2F 21                 ./!
	cpy	#$82
	bne	@10
@10:
        rts                                     ; 0A3C 60                       `
; ----------------------------------------------------------------------------
L0A3D:  pha                                     ; 0A3D 48                       H
        jsr     L0A76                           ; 0A3E 20 76 0A                  v.
        lda     L0A64,y                         ; 0A41 B9 64 0A                 .d.
        sta     r0L                             ; 0A44 85 02                    ..
        lda     L0A69,y                         ; 0A46 B9 69 0A                 .i.
        sta     r0H                             ; 0A49 85 03                    ..
        pla                                     ; 0A4B 68                       h
        tay                                     ; 0A4C A8                       .
        lda     L0A66-8,y                         ; 0A4D B9 66 0A                 .f.
        sta     r1L                             ; 0A50 85 04                    ..
        lda     L0A6A-8,y                         ; 0A52 B9 6A 0A                 .j.
        sta     r1H                             ; 0A55 85 05                    ..
        lda     #$0D                            ; 0A57 A9 0D                    ..
        sta     r2H                             ; 0A59 85 07                    ..
        lda     #$80                            ; 0A5B A9 80                    ..
        sta     r2L                             ; 0A5D 85 06                    ..
        lda     #$00                            ; 0A5F A9 00                    ..
        sta     r3L                             ; 0A61 85 08                    ..
        rts                                     ; 0A63 60                       `
; ----------------------------------------------------------------------------
; 2f00 - ???
; 3c80 -
; 4a00 -
; 5780 -
; 6500 -
; 7280 -
; 8000 - NO

L0A64:  .byte   0, $80                             ; 0A64 80                       .
        brk                                     ; 0A65 00                       .
		.byte   $80                             ; 0A66 80                       .
        brk                                     ; 0A67 00                       .
        .byte   $80                             ; 0A68 80                       .

L0A69:  .byte   $65, $3C                             ; 0A69 3C                       <
	.byte	$4a                                    ; 0A6A 4A                       J
        .byte   $57, $2f, $72

L0A66:
        brk                                     ; 0A6E 00                       .
        .byte   $80                             ; 0A6F 80                       .
        brk                                     ; 0A70 00                       .
        .byte   $80                             ; 0A71 80                       .

L0A6A:
        .byte   $83                             ; 0A72 83                       .
        ;bcc     L0A13                           ; 0A73 90 9E                    ..
        .byte   $90, $9e
        .byte   $AB                             ; 0A75 AB                       .

; translate drive type to driver offset
L0A76:  tya                                     ; 0A76 98                       .
        bpl     L0A85                           ; 0A77 10 0C                    ..
        cmp     #$83                            ; 0A79 C9 83                    ..
        beq     L0A81                           ; 0A7B F0 04                    ..
.ifdef mega65
        ldy     #$04                            ; 0A7D A0 03                    ..
.else
        ldy     #$03                            ; 0A7D A0 03                    ..
.endif
        bne     L0A89                           ; 0A7F D0 08                    ..
.ifdef mega65
L0A81:  ldy     #$05                            ; 0A81 A0 04                    ..
.else
L0A81:  ldy     #$04                            ; 0A81 A0 04                    ..
.endif
        bne     L0A89                           ; 0A83 D0 04                    ..
L0A85:  and     #$0F                            ; 0A85 29 0F                    ).
        tay                                     ; 0A87 A8                       .
        dey                                     ; 0A88 88                       .
	
	; drive type 4 and above use driver index 3
	cpy	#3
	bcc	L0A89
	ldy	#3	; use M65 device driver (F011)
	
L0A89:  rts                                     ; 0A89 60                       `
; ----------------------------------------------------------------------------
L0A8A:  ldy     V212B                           ; 0A8A AC 2B 21                 .+!
        lda     $8486,y                         ; 0A8D B9 86 84                 ...
        and     #$0F                            ; 0A90 29 0F                    ).
        cmp     #$03                            ; 0A92 C9 03                    ..
        bcc     L0A99                           ; 0A94 90 03                    ..
        jmp     L0C8E                           ; 0A96 4C 8E 0C                 L..
; ----------------------------------------------------------------------------
L0A99:
  	ldy     #$00                            ; 0A99 A0 00                    ..
        tya                                     ; 0A9B 98                       .
L0A9C:  sta     curDirHead,y                    ; 0A9C 99 00 82                 ...
        iny                                     ; 0A9F C8                       .
        bne     L0A9C                           ; 0AA0 D0 FA                    ..
        lda     #$34                            ; 0AA2 A9 34                    .4
        sta     L0BBB                           ; 0AA4 8D BB 0B                 ...
        lda     #$00                            ; 0AA7 A9 00                    ..
        sta     L0B28                           ; 0AA9 8D 28 0B                 .(.
        ldy     curDrive                        ; 0AAC AC 89 84                 ...
        lda     $8486,y                         ; 0AAF B9 86 84                 ...
        and     #$0F                            ; 0AB2 29 0F                    ).
        ldy     #$BD                            ; 0AB4 A0 BD                    ..
        cmp     #$01                            ; 0AB6 C9 01                    ..
        beq     L0AC6                           ; 0AB8 F0 0C                    ..
        ldy     #$00                            ; 0ABA A0 00                    ..
        lda     #$37                            ; 0ABC A9 37                    .7
        sta     L0BBB                           ; 0ABE 8D BB 0B                 ...
        lda     #$80                            ; 0AC1 A9 80                    ..
        sta     L0B28                           ; 0AC3 8D 28 0B                 .(.
L0AC6:  dey                                     ; 0AC6 88                       .
        lda     L0B25,y                         ; 0AC7 B9 25 0B                 .%.
        sta     curDirHead,y                    ; 0ACA 99 00 82                 ...
        tya                                     ; 0ACD 98                       .
        bne     L0AC6                           ; 0ACE D0 F6                    ..
        ldy     curDrive                        ; 0AD0 AC 89 84                 ...
        lda     $8486,y                         ; 0AD3 B9 86 84                 ...
        and     #$0F                            ; 0AD6 29 0F                    ).
        cmp     #$01                            ; 0AD8 C9 01                    ..
        beq     L0AF1                           ; 0ADA F0 15                    ..
        ldy     #$00                            ; 0ADC A0 00                    ..
        tya                                     ; 0ADE 98                       .
L0ADF:  sta     dir2Head,y                      ; 0ADF 99 00 89                 ...
        iny                                     ; 0AE2 C8                       .
        bne     L0ADF                           ; 0AE3 D0 FA                    ..
        ldy     #$69                            ; 0AE5 A0 69                    .i
L0AE7:  dey                                     ; 0AE7 88                       .
        lda     L0C25,y                         ; 0AE8 B9 25 0C                 .%.
        sta     dir2Head,y                      ; 0AEB 99 00 89                 ...
        tya                                     ; 0AEE 98                       .
        bne     L0AE7                           ; 0AEF D0 F6                    ..
L0AF1:
        jsr     PutDirHead                      ; 0AF1 20 4A C2                  J.

        jsr     L0B1B                           ; 0AF4 20 1B 0B                  ..
        lda     #$FF                            ; 0AF7 A9 FF                    ..
        sta     $8001                           ; 0AF9 8D 01 80                 ...
        lda     #$80                            ; 0AFC A9 80                    ..
        sta     r4H                             ; 0AFE 85 0B                    ..
        lda     #$00                            ; 0B00 A9 00                    ..
        sta     r4L                             ; 0B02 85 0A                    ..
        lda     #$12                            ; 0B04 A9 12                    ..
        sta     r1L                             ; 0B06 85 04                    ..
        lda     #$01                            ; 0B08 A9 01                    ..
        sta     r1H                             ; 0B0A 85 05                    ..
        jsr     PutBlock                        ; 0B0C 20 E7 C1                  ..
        inc     r1L                             ; 0B0F E6 04                    ..
        lda     #$08                            ; 0B11 A9 08                    ..
        sta     r1H                             ; 0B13 85 05                    ..
        jsr     PutBlock                        ; 0B15 20 E7 C1                  ..
        lda     #$00                            ; 0B18 A9 00                    ..
        rts                                     ; 0B1A 60                       `
; ----------------------------------------------------------------------------
L0B1B:  ldy     #$00                            ; 0B1B A0 00                    ..
        tya                                     ; 0B1D 98                       .
L0B1E:  sta     diskBlkBuf,y                    ; 0B1E 99 00 80                 ...
        dey                                     ; 0B21 88                       .
        bne     L0B1E                           ; 0B22 D0 FA                    ..
        rts                                     ; 0B24 60                       `
; ----------------------------------------------------------------------------
L0B25:  .byte   $12,$01,$41                     ; 0B25 12 01 41                 ..A
L0B28:  .byte   $00,$15,$FF,$FF,$1F,$15,$FF,$FF ; 0B28 00 15 FF FF 1F 15 FF FF  ........
        .byte   $1F,$15,$FF,$FF,$1F,$15,$FF,$FF ; 0B30 1F 15 FF FF 1F 15 FF FF  ........
        .byte   $1F,$15,$FF,$FF,$1F,$15,$FF,$FF ; 0B38 1F 15 FF FF 1F 15 FF FF  ........
        .byte   $1F,$15,$FF,$FF,$1F,$15,$FF,$FF ; 0B40 1F 15 FF FF 1F 15 FF FF  ........
        .byte   $1F,$15,$FF,$FF,$1F,$15,$FF,$FF ; 0B48 1F 15 FF FF 1F 15 FF FF  ........
        .byte   $1F,$15,$FF,$FF,$1F,$15,$FF,$FF ; 0B50 1F 15 FF FF 1F 15 FF FF  ........
        .byte   $1F,$15,$FF,$FF,$1F,$15,$FF,$FF ; 0B58 1F 15 FF FF 1F 15 FF FF  ........
        .byte   $1F,$15,$FF,$FF,$1F,$15,$FF,$FF ; 0B60 1F 15 FF FF 1F 15 FF FF  ........
        .byte   $1F,$15,$FF,$FF,$1F,$11,$FC,$FF ; 0B68 1F 15 FF FF 1F 11 FC FF  ........
        .byte   $07,$12,$FF,$FE,$07,$13,$FF,$FF ; 0B70 07 12 FF FE 07 13 FF FF  ........
        .byte   $07,$13,$FF,$FF,$07,$13,$FF,$FF ; 0B78 07 13 FF FF 07 13 FF FF  ........
        .byte   $07,$13,$FF,$FF,$07,$13,$FF,$FF ; 0B80 07 13 FF FF 07 13 FF FF  ........
        .byte   $07,$12,$FF,$FF,$03,$12,$FF,$FF ; 0B88 07 12 FF FF 03 12 FF FF  ........
        .byte   $03,$12,$FF,$FF,$03,$12,$FF,$FF ; 0B90 03 12 FF FF 03 12 FF FF  ........
        .byte   $03,$12,$FF,$FF,$03,$12,$FF,$FF ; 0B98 03 12 FF FF 03 12 FF FF  ........
        .byte   $03,$11,$FF,$FF,$01,$11,$FF,$FF ; 0BA0 03 11 FF FF 01 11 FF FF  ........
        .byte   $01,$11,$FF,$FF,$01,$11,$FF,$FF ; 0BA8 01 11 FF FF 01 11 FF FF  ........
        .byte   $01,$11,$FF,$FF                 ; 0BB0 01 11 FF FF              ....
; ----------------------------------------------------------------------------
        .byte   $01                             ; 0BB4 01                       .
        .byte   "RAM 15"                        ; 0BB5 52 41 4D 20 31 35        RAM 15
L0BBB:  .byte   "71"                            ; 0BBB 37 31                    71
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0 ; 0BBD A0 A0 A0 A0 A0 A0 A0 A0  ........
        .byte   $A0,$A0                         ; 0BC5 A0 A0                    ..
        .byte   "RD"                            ; 0BC7 52 44                    RD
        .byte   $A0                             ; 0BC9 A0                       .
        .byte   "2A"                            ; 0BCA 32 41                    2A
        .byte   $A0,$A0,$A0,$A0,$13,$08         ; 0BCC A0 A0 A0 A0 13 08        ......
        .byte   "GEOS format V1.0"              ; 0BD2 47 45 4F 53 20 66 6F 72  GEOS for
                                                ; 0BDA 6D 61 74 20 56 31 2E 30  mat V1.0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 0BE2 00 00 00 00 00 00 00 00  ........
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 0BEA 00 00 00 00 00 00 00 00  ........
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 0BF2 00 00 00 00 00 00 00 00  ........
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 0BFA 00 00 00 00 00 00 00 00  ........
        .byte   $15,$15,$15,$15,$15,$15,$15,$15 ; 0C02 15 15 15 15 15 15 15 15  ........
        .byte   $15,$15,$15,$15,$15,$15,$15,$15 ; 0C0A 15 15 15 15 15 15 15 15  ........
        .byte   $15,$00,$13,$13,$13,$13,$13,$13 ; 0C12 15 00 13 13 13 13 13 13  ........
        .byte   $12,$12,$12,$12,$12,$12,$11,$11 ; 0C1A 12 12 12 12 12 12 11 11  ........
        .byte   $11,$11,$11                     ; 0C22 11 11 11                 ...
L0C25:  .byte   $FF,$FF,$1F,$FF,$FF,$1F,$FF,$FF ; 0C25 FF FF 1F FF FF 1F FF FF  ........
        .byte   $1F,$FF,$FF,$1F,$FF,$FF,$1F,$FF ; 0C2D 1F FF FF 1F FF FF 1F FF  ........
        .byte   $FF,$1F,$FF,$FF,$1F,$FF,$FF,$1F ; 0C35 FF 1F FF FF 1F FF FF 1F  ........
        .byte   $FF,$FF,$1F,$FF,$FF,$1F,$FF,$FF ; 0C3D FF FF 1F FF FF 1F FF FF  ........
        .byte   $1F,$FF,$FF,$1F,$FF,$FF,$1F,$FF ; 0C45 1F FF FF 1F FF FF 1F FF  ........
        .byte   $FF,$1F,$FF,$FF,$1F,$FF,$FF,$1F ; 0C4D FF 1F FF FF 1F FF FF 1F  ........
        .byte   $FF,$FF,$1F,$00,$00,$00,$FF,$FF ; 0C55 FF FF 1F 00 00 00 FF FF  ........
        .byte   $07,$FF,$FF,$07,$FF,$FF,$07,$FF ; 0C5D 07 FF FF 07 FF FF 07 FF  ........
        .byte   $FF,$07,$FF,$FF,$07,$FF,$FF,$07 ; 0C65 FF 07 FF FF 07 FF FF 07  ........
        .byte   $FF,$FF,$03,$FF,$FF,$03,$FF,$FF ; 0C6D FF FF 03 FF FF 03 FF FF  ........
        .byte   $03,$FF,$FF,$03,$FF,$FF,$03,$FF ; 0C75 03 FF FF 03 FF FF 03 FF  ........
        .byte   $FF,$03,$FF,$FF,$01,$FF,$FF,$01 ; 0C7D FF 03 FF FF 01 FF FF 01  ........
        .byte   $FF,$FF,$01,$FF,$FF,$01,$FF,$FF ; 0C85 FF FF 01 FF FF 01 FF FF  ........
        .byte   $01                             ; 0C8D 01                       .
; ----------------------------------------------------------------------------
L0C8E:  ldy     #$00                            ; 0C8E A0 00                    ..
        tya                                     ; 0C90 98                       .
L0C91:  sta     curDirHead,y                    ; 0C91 99 00 82                 ...
        iny                                     ; 0C94 C8                       .
        bne     L0C91                           ; 0C95 D0 FA                    ..
        lda     #$28                            ; 0C97 A9 28                    .(
        sta     curDirHead                      ; 0C99 8D 00 82                 ...
        lda     #$03                            ; 0C9C A9 03                    ..
        sta     $8201                           ; 0C9E 8D 01 82                 ...
        lda     #$44                            ; 0CA1 A9 44                    .D
        sta     $8202                           ; 0CA3 8D 02 82                 ...
        ldy     #$2D                            ; 0CA6 A0 2D                    .-
L0CA8:  lda     L0D36,y                         ; 0CA8 B9 36 0D                 .6.
        sta     $8290,y                         ; 0CAB 99 90 82                 ...
        dey                                     ; 0CAE 88                       .
        bpl     L0CA8                           ; 0CAF 10 F7                    ..
        lda     #$28                            ; 0CB1 A9 28                    .(
        sta     r1L                             ; 0CB3 85 04                    ..
        lda     #$00                            ; 0CB5 A9 00                    ..
        sta     r1H                             ; 0CB7 85 05                    ..
        lda     #$82                            ; 0CB9 A9 82                    ..
        sta     r4H                             ; 0CBB 85 0B                    ..
        lda     #$00                            ; 0CBD A9 00                    ..
        sta     r4L                             ; 0CBF 85 0A                    ..
        jsr     PutBlock                        ; 0CC1 20 E7 C1                  ..
        ldy     #$00                            ; 0CC4 A0 00                    ..
L0CC6:  lda     L0D64,y                         ; 0CC6 B9 64 0D                 .d.
        sta     dir2Head,y                      ; 0CC9 99 00 89                 ...
        iny                                     ; 0CCC C8                       .
        bne     L0CC6                           ; 0CCD D0 F7                    ..
        lda     #$28                            ; 0CCF A9 28                    .(
        sta     r1L                             ; 0CD1 85 04                    ..
        lda     #$01                            ; 0CD3 A9 01                    ..
        sta     r1H                             ; 0CD5 85 05                    ..
        lda     #$89                            ; 0CD7 A9 89                    ..
        sta     r4H                             ; 0CD9 85 0B                    ..
        lda     #$00                            ; 0CDB A9 00                    ..
        sta     r4L                             ; 0CDD 85 0A                    ..
        jsr     PutBlock                        ; 0CDF 20 E7 C1                  ..
        lda     #$FF                            ; 0CE2 A9 FF                    ..
        sta     $8901                           ; 0CE4 8D 01 89                 ...
        lda     #$00                            ; 0CE7 A9 00                    ..
        sta     dir2Head                        ; 0CE9 8D 00 89                 ...
        lda     #$28                            ; 0CEC A9 28                    .(
        sta     $89FA                           ; 0CEE 8D FA 89                 ...
        lda     #$FF                            ; 0CF1 A9 FF                    ..
        sta     $89FB                           ; 0CF3 8D FB 89                 ...
        lda     #$FF                            ; 0CF6 A9 FF                    ..
        sta     $89FD                           ; 0CF8 8D FD 89                 ...
        lda     #$28                            ; 0CFB A9 28                    .(
        sta     r1L                             ; 0CFD 85 04                    ..
        lda     #$02                            ; 0CFF A9 02                    ..
        sta     r1H                             ; 0D01 85 05                    ..
        lda     #$89                            ; 0D03 A9 89                    ..
        sta     r4H                             ; 0D05 85 0B                    ..
        lda     #$00                            ; 0D07 A9 00                    ..
        sta     r4L                             ; 0D09 85 0A                    ..
        jsr     PutBlock                        ; 0D0B 20 E7 C1                  ..
        jsr     GetDirHead                      ; 0D0E 20 47 C2                  G.
        jsr     L0B1B                           ; 0D11 20 1B 0B                  ..
        lda     #$FF                            ; 0D14 A9 FF                    ..
        sta     $8001                           ; 0D16 8D 01 80                 ...
        lda     #$80                            ; 0D19 A9 80                    ..
        sta     r4H                             ; 0D1B 85 0B                    ..
        lda     #$00                            ; 0D1D A9 00                    ..
        sta     r4L                             ; 0D1F 85 0A                    ..
        lda     #$28                            ; 0D21 A9 28                    .(
        sta     r1L                             ; 0D23 85 04                    ..
        lda     #$03                            ; 0D25 A9 03                    ..
        sta     r1H                             ; 0D27 85 05                    ..
        jsr     PutBlock                        ; 0D29 20 E7 C1                  ..
        lda     #$13                            ; 0D2C A9 13                    ..
        sta     r1H                             ; 0D2E 85 05                    ..
        jsr     PutBlock                        ; 0D30 20 E7 C1                  ..
        lda     #$00                            ; 0D33 A9 00                    ..
        rts                                     ; 0D35 60                       `
; ----------------------------------------------------------------------------
L0D36:  .byte   "RAM 1581"                      ; 0D36 52 41 4D 20 31 35 38 31  RAM 1581
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0 ; 0D3E A0 A0 A0 A0 A0 A0 A0 A0  ........
        .byte   $A0,$A0                         ; 0D46 A0 A0                    ..
        .byte   "RD"                            ; 0D48 52 44                    RD
        .byte   $A0                             ; 0D4A A0                       .
        .byte   "3D"                            ; 0D4B 33 44                    3D
        .byte   $A0,$A0,$00,$00                 ; 0D4D A0 A0 00 00              ....
        .byte   "("                             ; 0D51 28                       (
        .byte   $13                             ; 0D52 13                       .
        .byte   "GEOS format V1.0"              ; 0D53 47 45 4F 53 20 66 6F 72  GEOS for
                                                ; 0D5B 6D 61 74 20 56 31 2E 30  mat V1.0
        .byte   $00                             ; 0D63 00                       .
L0D64:  .byte   "("                             ; 0D64 28                       (
        .byte   $02                             ; 0D65 02                       .
        .byte   "D"                             ; 0D66 44                       D
        .byte   $BB                             ; 0D67 BB                       .
        .byte   "EA"                            ; 0D68 45 41                    EA
        .byte   $C0,$00,$00,$00,$00,$00,$00,$00 ; 0D6A C0 00 00 00 00 00 00 00  ........
        .byte   $00,$00                         ; 0D72 00 00                    ..
        .byte   "("                             ; 0D74 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0D75 FF FF FF FF FF           .....
        .byte   "("                             ; 0D7A 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0D7B FF FF FF FF FF           .....
        .byte   "("                             ; 0D80 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0D81 FF FF FF FF FF           .....
        .byte   "("                             ; 0D86 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0D87 FF FF FF FF FF           .....
        .byte   "("                             ; 0D8C 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0D8D FF FF FF FF FF           .....
        .byte   "("                             ; 0D92 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0D93 FF FF FF FF FF           .....
        .byte   "("                             ; 0D98 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0D99 FF FF FF FF FF           .....
        .byte   "("                             ; 0D9E 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0D9F FF FF FF FF FF           .....
        .byte   "("                             ; 0DA4 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DA5 FF FF FF FF FF           .....
        .byte   "("                             ; 0DAA 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DAB FF FF FF FF FF           .....
        .byte   "("                             ; 0DB0 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DB1 FF FF FF FF FF           .....
        .byte   "("                             ; 0DB6 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DB7 FF FF FF FF FF           .....
        .byte   "("                             ; 0DBC 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DBD FF FF FF FF FF           .....
        .byte   "("                             ; 0DC2 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DC3 FF FF FF FF FF           .....
        .byte   "("                             ; 0DC8 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DC9 FF FF FF FF FF           .....
        .byte   "("                             ; 0DCE 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DCF FF FF FF FF FF           .....
        .byte   "("                             ; 0DD4 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DD5 FF FF FF FF FF           .....
        .byte   "("                             ; 0DDA 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DDB FF FF FF FF FF           .....
        .byte   "("                             ; 0DE0 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DE1 FF FF FF FF FF           .....
        .byte   "("                             ; 0DE6 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DE7 FF FF FF FF FF           .....
        .byte   "("                             ; 0DEC 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DED FF FF FF FF FF           .....
        .byte   "("                             ; 0DF2 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DF3 FF FF FF FF FF           .....
        .byte   "("                             ; 0DF8 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DF9 FF FF FF FF FF           .....
        .byte   "("                             ; 0DFE 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0DFF FF FF FF FF FF           .....
        .byte   "("                             ; 0E04 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0E05 FF FF FF FF FF           .....
        .byte   "("                             ; 0E0A 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0E0B FF FF FF FF FF           .....
        .byte   "("                             ; 0E10 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0E11 FF FF FF FF FF           .....
        .byte   "("                             ; 0E16 28                       (
        .byte   $FF,$FF             ; 0E17 FF FF FF FF FF           .....
L0E19:   .byte     $FF,$FF,$FF
        .byte   "("                             ; 0E1C 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0E1D FF FF FF FF FF           .....
        .byte   "("                             ; 0E22 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0E23 FF FF FF FF FF           .....
        .byte   "("                             ; 0E28 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0E29 FF FF FF FF FF           .....
        .byte   "("                             ; 0E2E 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0E2F FF FF FF FF FF           .....
        .byte   "("                             ; 0E34 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0E35 FF FF FF FF FF           .....
        .byte   "("                             ; 0E3A 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0E3B FF FF FF FF FF           .....
        .byte   "("                             ; 0E40 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0E41 FF FF FF FF FF           .....
        .byte   "("                             ; 0E46 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0E47 FF FF FF FF FF           .....
        .byte   "("                             ; 0E4C 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0E4D FF FF FF FF FF           .....
        .byte   "("                             ; 0E52 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0E53 FF FF FF FF FF           .....
        .byte   "("                             ; 0E58 28                       (
        .byte   $FF,$FF,$FF,$FF,$FF             ; 0E59 FF FF FF FF FF           .....
        .byte   "#"                             ; 0E5E 23                       #
        .byte   $F0,$FF,$F7,$FF,$FF             ; 0E5F F0 FF F7 FF FF           .....
; ----------------------------------------------------------------------------
L0E64:  lda     #$E5                            ; 0E64 A9 E5                    ..
        sta     r0H                             ; 0E66 85 03                    ..
        lda     #$80                            ; 0E68 A9 80                    ..
        sta     r0L                             ; 0E6A 85 02                    ..
        jsr     L0EA0                           ; 0E6C 20 A0 0E                  ..
        cpx     #$00                            ; 0E6F E0 00                    ..
        bne     L0E82                           ; 0E71 D0 0F                    ..
        cmp     #$00                            ; 0E73 C9 00                    ..
        bne     L0E82                           ; 0E75 D0 0B                    ..
        lda     #$A6                            ; 0E77 A9 A6                    ..
        sta     r0H                             ; 0E79 85 03                    ..
        lda     #$C0                            ; 0E7B A9 C0                    ..
        sta     r0L                             ; 0E7D 85 02                    ..
        jsr     L0EA0                           ; 0E7F 20 A0 0E                  ..
L0E82:  cpx     #$00                            ; 0E82 E0 00                    ..
        bne     L0E9D                           ; 0E84 D0 17                    ..
        tax                                     ; 0E86 AA                       .
        lda     #$01                            ; 0E87 A9 01                    ..
        cpx     #$41                            ; 0E89 E0 41                    .A
        beq     L0E9F                           ; 0E8B F0 12                    ..
        lda     #$02                            ; 0E8D A9 02                    ..
        cpx     #$71                            ; 0E8F E0 71                    .q
        beq     L0E9F                           ; 0E91 F0 0C                    ..
        lda     #$03                            ; 0E93 A9 03                    ..
        ldx     #$81                            ; 0E95 A2 81                    ..
        bne     L0E9F                           ; 0E97 D0 06                    ..
        lda     #$FF                            ; 0E99 A9 FF                    ..
        bne     L0E9F                           ; 0E9B D0 02                    ..
L0E9D:  lda     #$00                            ; 0E9D A9 00                    ..
L0E9F:  rts                                     ; 0E9F 60                       `
; ----------------------------------------------------------------------------
L0EA0:  
	jsr     L0EF5                           ; 0EA0 20 F5 0E                  ..
        lda     #$01                            ; 0EA3 A9 01                    ..
        sta     r2H                             ; 0EA5 85 07                    ..
        lda     #$00                            ; 0EA7 A9 00                    ..
        sta     r2L                             ; 0EA9 85 06                    ..
L0EAB:  jsr     L0F05                           ; 0EAB 20 05 0F                  ..
        cpx     #$00                            ; 0EAE E0 00                    ..
        bne     L0EF4                           ; 0EB0 D0 42                    .B
        cmp     #$31                            ; 0EB2 C9 31                    .1
        bne     L0EE4                           ; 0EB4 D0 2E                    ..
        jsr     L0F05                           ; 0EB6 20 05 0F                  ..
        cmp     #$35                            ; 0EB9 C9 35                    .5
        bne     L0EE4                           ; 0EBB D0 27                    .'
        jsr     L0F05                           ; 0EBD 20 05 0F                  ..
        sta     r1L                             ; 0EC0 85 04                    ..
        and     #$70                            ; 0EC2 29 70                    )p
        cmp     #$30                            ; 0EC4 C9 30                    .0
        bne     L0EE4                           ; 0EC6 D0 1C                    ..
        lda     r1L                             ; 0EC8 A5 04                    ..
        asl                                    ; 0ECA 0A                       .
        asl                                    ; 0ECB 0A                       .
        asl                                    ; 0ECC 0A                       .
        asl                                    ; 0ECD 0A                       .
        sta     r1L                             ; 0ECE 85 04                    ..
        jsr     L0F05                           ; 0ED0 20 05 0F                  ..
        sta     r1H                             ; 0ED3 85 05                    ..
        and     #$70                            ; 0ED5 29 70                    )p
        cmp     #$30                            ; 0ED7 C9 30                    .0
        bne     L0EE4                           ; 0ED9 D0 09                    ..
        lda     r1H                             ; 0EDB A5 05                    ..
        and     #$0F                            ; 0EDD 29 0F                    ).
        ora     r1L                             ; 0EDF 05 04                    ..
        ldx     #$00                            ; 0EE1 A2 00                    ..
        rts                                     ; 0EE3 60                       `
; ----------------------------------------------------------------------------
L0EE4:  lda     r2L                             ; 0EE4 A5 06                    ..
        bne     L0EEA                           ; 0EE6 D0 02                    ..
        dec     r2H                             ; 0EE8 C6 07                    ..
L0EEA:  dec     r2L                             ; 0EEA C6 06                    ..
        lda     r2L                             ; 0EEC A5 06                    ..
        ora     r2H                             ; 0EEE 05 07                    ..
        bne     L0EAB                           ; 0EF0 D0 B9                    ..
        ldx     #$00                            ; 0EF2 A2 00                    ..
L0EF4:  rts                                     ; 0EF4 60                       `
; ----------------------------------------------------------------------------
L0EF5:  lda     r0H                             ; 0EF5 A5 03                    ..
        sta     L0F72                           ; 0EF7 8D 72 0F                 .r.
        lda     r0L                             ; 0EFA A5 02                    ..
        sta     L0F71                           ; 0EFC 8D 71 0F                 .q.
        lda     #$20                            ; 0EFF A9 20                    .
        sta     V2109                           ; 0F01 8D 09 21                 ..!
        rts                                     ; 0F04 60                       `
; ----------------------------------------------------------------------------
L0F05:  
	ldy     V2109                           ; 0F05 AC 09 21                 ..!
        cpy     #$20                            ; 0F08 C0 20                    .
        bcs     L0F15                           ; 0F0A B0 09                    ..
        lda     V210A,y                         ; 0F0C B9 0A 21                 ..!
        inc     V2109                           ; 0F0F EE 09 21                 ..!
        ldx     #$00                            ; 0F12 A2 00                    ..
        rts                                     ; 0F14 60                       `
; ----------------------------------------------------------------------------
L0F15:  jsr     InitForIO                       ; 0F15 20 5C C2                  \.
        LoadW   r0, L0F6E
        jsr     L0F74                           ; 0F20 20 74 0F                  t.
	beq     L0F29                           ; 0F23 F0 04                    ..
        jsr     DoneWithIO                      ; 0F25 20 5F C2                  _.
        rts                                     ; 0F28 60                       `
; ----------------------------------------------------------------------------
L0F29:  jsr     UNLSN                           ; 0F29 20 AE FF                  ..
        lda     curDrive                        ; 0F2C AD 89 84                 ...
        jsr     TALK                            ; 0F2F 20 B4 FF                  ..
        lda     #$FF                            ; 0F32 A9 FF                    ..
        jsr     TKSA                            ; 0F34 20 96 FF                  ..
        ldy     #$00                            ; 0F37 A0 00                    ..
L0F39:  jsr     ACPTR                           ; 0F39 20 A5 FF                  ..
        sta     V210A,y                         ; 0F3C 99 0A 21                 ..!
        iny                                     ; 0F3F C8                       .
        cpy     #$20                            ; 0F40 C0 20                    .
        bcc     L0F39                           ; 0F42 90 F5                    ..
        jsr     UNTLK                           ; 0F44 20 AB FF                  ..
        lda     curDrive                        ; 0F47 AD 89 84                 ...
        jsr     LISTEN                          ; 0F4A 20 B1 FF                  ..
        lda     #$EF                            ; 0F4D A9 EF                    ..
        jsr     SECOND                          ; 0F4F 20 93 FF                  ..
        jsr     UNLSN                           ; 0F52 20 AE FF                  ..
        jsr     DoneWithIO                      ; 0F55 20 5F C2                  _.
        lda     #$00                            ; 0F58 A9 00                    ..
        sta     V2109                           ; 0F5A 8D 09 21                 ..!
        clc                                     ; 0F5D 18                       .
        lda     #$20                            ; 0F5E A9 20                    .
        adc     L0F71                           ; 0F60 6D 71 0F                 mq.
        sta     L0F71                           ; 0F63 8D 71 0F                 .q.
        bcc     L0F6B                           ; 0F66 90 03                    ..
        inc     L0F72                           ; 0F68 EE 72 0F                 .r.
L0F6B:  clv                                     ; 0F6B B8                       .
        bvc     L0F05                           ; 0F6C 50 97                    P.
L0F6E:
        eor     $522D                           ; 0F6E 4D 2D 52                 M-R
L0F71:  brk                                     ; 0F71 00                       .
L0F72:  brk                                     ; 0F72 00                       .
        .byte   $20                             ; 0F73 20
L0F74:  lda     #$00                            ; 0F74 A9 00                    ..
        sta     STATUS                          ; 0F76 85 90                    ..
        lda     curDrive                        ; 0F78 AD 89 84                 ...
        jsr     LISTEN                          ; 0F7B 20 B1 FF                  ..
        bit     STATUS                          ; 0F7E 24 90                    $.
        bmi     L0F9A                           ; 0F80 30 18                    0.
        lda     #$FF                            ; 0F82 A9 FF                    ..
        jsr     SECOND                          ; 0F84 20 93 FF                  ..
        bit     STATUS                          ; 0F87 24 90                    $.
        bmi     L0F9A                           ; 0F89 30 0F                    0.
        ldy     #$00                            ; 0F8B A0 00                    ..
L0F8D:  lda     (r0L),y                         ; 0F8D B1 02                    ..
        jsr     CIOUT                           ; 0F8F 20 A8 FF                  ..
        iny                                     ; 0F92 C8                       .
        cpy     #$06                            ; 0F93 C0 06                    ..
        bcc     L0F8D                           ; 0F95 90 F6                    ..
        ldx     #$00                            ; 0F97 A2 00                    ..
        rts                                     ; 0F99 60                       `
; ----------------------------------------------------------------------------
L0F9A:  jsr     UNLSN                           ; 0F9A 20 AE FF                  ..
        ldx     #$0D                            ; 0F9D A2 0D                    ..
        rts                                     ; 0F9F 60                       `
; ----------------------------------------------------------------------------
L0FA0:  lda     #$00                            ; 0FA0 A9 00                    ..
        sta     NUMDRV                          ; 0FA2 8D 8D 84                 ...
        ldy     #$01                            ; 0FA5 A0 01                    ..
L0FA7:  lda     driveType,y                     ; 0FA7 B9 8E 84                 ...
        beq     L0FAF                           ; 0FAA F0 03                    ..
        inc     NUMDRV                          ; 0FAC EE 8D 84                 ...
L0FAF:  dey                                     ; 0FAF 88                       .
        bpl     L0FA7                           ; 0FB0 10 F5                    ..
        rts                                     ; 0FB2 60                       `
; ----------------------------------------------------------------------------
.ifdef mega65

FAST_FLAGS	=	$60	;$70
CACHE_BIT	=	$80

HRBustCache:
	PushW	r0
	PushW	r1
	
.if 0
	LoadW	r0, $FFF2
	LoadW	r1, $0BFF

	lda	#(FAST_FLAGS & ($ff - CACHE_BIT))
	ldz	#0
	eom
	sta 	(r0), z

	lda	#(FAST_FLAGS | CACHE_BIT)
	ldz	#0
	eom
	sta 	(r0), z
.endif	
	PopW	r1
	PopW	r0
	
	rts
L0FB3:
	; if we are a real mega65 we are able to use some of the ROM
	; mapped banks for GEOS REU
	;
	; but starting mega65r2 PCB actual expansion RAM (HyperRAM)
	; may be available at $800000, lets check
	; if it is there and how much, supporting up to 16MB for now
	LoadW	r0, $0000
	LoadW	r1, $0800
	LoadW	r2, $0000
	LoadW	r3, $0810

	ldx	#0
@2:
	lda	#$BD
	ldz	#0
	eom
	sta 	(r0), z
	eom
	lda	(r0), z
	cmp	#$BD
	beq	@1
	inx
	bne	@2	
	bra	@noREU
	
@1:
	jsr	HRBustCache
	
	ldz	#0
	eom
	lda 	(r0), z
	cmp	#$BD
	bne	@3

	jsr	HRBustCache
	
	lda	#$55
	ldz	#0
	eom
	sta 	(r2), z
	eom
	lda 	(r2), z
	cmp	#$55
	bne	@3
	
	jsr	HRBustCache
	
	lda	#$AA
	ldz	#0
	eom
	sta 	(r2), z
	eom
	lda 	(r2), z
	cmp	#$AA
	bne	@3
	
	jsr	HRBustCache

	ldz	#0
	eom
	lda 	(r0), z
	cmp	#$BD
	bne	@3

	; next bank
	lda	r3L
	clc
	adc	#$10
	beq	@4		; last bank, can't count for it
	sta	r3L
	bra	@1	
@4:
@3:
	ldx	r3L
	stx	ramExpSize
	rts
@noREU:
	LoadB	ramExpSize, 1
	rts

.else
L0FB3:  jsr     InitForIO                       ; 0FB3 20 5C C2                  \.
        lda     #$00                            ; 0FB6 A9 00                    ..
        sta     ramExpSize                      ; 0FB8 8D C3 88                 ...
        lda     #$02                            ; 0FBB A9 02                    ..
        sta     V2102                           ; 0FBD 8D 02 21                 ..!
        ;rts
        lda     EXP_BASE                        ; 0FC0 AD 00 DF                 ...
        and     #$10                            ; 0FC3 29 10                    ).
        beq     L0FCC                           ; 0FC5 F0 05                    ..
        lda     #$20                            ; 0FC7 A9 20                    .
        sta     V2102                           ; 0FC9 8D 02 21                 ..!
L0FCC:  lda     EXP_BASE                        ; 0FCC AD 00 DF                 ...
        and     #$E0                            ; 0FCF 29 E0                    ).
        bne     L100D                           ; 0FD1 D0 3A                    .:
        lda     #$55                            ; 0FD3 A9 55                    .U
        sta     $DF02                           ; 0FD5 8D 02 DF                 ...
        cmp     $DF02                           ; 0FD8 CD 02 DF                 ...
        bne     L100D                           ; 0FDB D0 30                    .0
        lda     #$AA                            ; 0FDD A9 AA                    ..
        sta     $DF02                           ; 0FDF 8D 02 DF                 ...
        ldy     #$00                            ; 0FE2 A0 00                    ..
L0FE4:  dey                                     ; 0FE4 88                       .
        bne     L0FE4                           ; 0FE5 D0 FD                    ..
        cmp     $DF02                           ; 0FE7 CD 02 DF                 ...
        bne     L100D                           ; 0FEA D0 21                    .!
        lda     #$01                            ; 0FEC A9 01                    ..
        sta     ramExpSize                      ; 0FEE 8D C3 88                 ...
        lda     #$00                            ; 0FF1 A9 00                    ..
        sta     r3L                             ; 0FF3 85 08                    ..
L0FF5:  jsr     L1010                           ; 0FF5 20 10 10                  ..
        bcc     L100A                           ; 0FF8 90 10                    ..
        lda     ramExpSize                      ; 0FFA AD C3 88                 ...
        cmp     V2102                           ; 0FFD CD 02 21                 ..!
        beq     L100D                           ; 1000 F0 0B                    ..
        inc     ramExpSize                      ; 1002 EE C3 88                 ...
        inc     r3L                             ; 1005 E6 08                    ..
        clv                                     ; 1007 B8                       .
        bvc     L0FF5                           ; 1008 50 EB                    P.
L100A:  dec     ramExpSize                      ; 100A CE C3 88                 ...
L100D:  jmp     DoneWithIO                      ; 100D 4C 5F C2                 L_.
.endif
; ----------------------------------------------------------------------------
	;*=$1010
L1010:
        LoadW   r0, V20FA
        lda     #$00                            ; 1018 A9 00                    ..
        sta     r1L                             ; 101A 85 04                    ..
        sta     r1H                             ; 101C 85 05                    ..
        lda     #$00                            ; 101E A9 00                    ..
        sta     r2H                             ; 1020 85 07                    ..
        lda     #$08                            ; 1022 A9 08                    ..
        sta     r2L                             ; 1024 85 06                    ..
        jsr     FetchRAM                        ; 1026 20 CB C2                  ..
        LoadW   r0, L1079
        jsr     StashRAM                        ; 1031 20 C8 C2                  ..
        LoadW   r0, V20EA
        jsr     FetchRAM                        ; 103C 20 CB C2                  ..
        lda     r3L                             ; 103F A5 08                    ..
        pha                                     ; 1041 48                       H
        lda     #$00                            ; 1042 A9 00                    ..
        sta     r3L                             ; 1044 85 08                    ..
        LoadW   r0, V20F2
        jsr     FetchRAM                        ; 104E 20 CB C2                  ..
        pla                                     ; 1051 68                       h
        sta     r3L                             ; 1052 85 08                    ..
        LoadW   r0, V20FA
        jsr     StashRAM                        ; 105C 20 C8 C2                  ..
        ldy     #$07                            ; 105F A0 07                    ..
L1061:  lda     L1079,y                         ; 1061 B9 79 10                 .y.
        cmp     V20EA,y                         ; 1064 D9 EA 20                 ..
        bne     L1077                           ; 1067 D0 0E                    ..
        ldx     r3L                             ; 1069 A6 08                    ..
        beq     L1072                           ; 106B F0 05                    ..
        cmp     V20F2,y                         ; 106D D9 F2 20                 ..
        beq     L1077                           ; 1070 F0 05                    ..
L1072:  dey                                     ; 1072 88                       .
        bpl     L1061                           ; 1073 10 EC                    ..
        sec                                     ; 1075 38                       8
        rts                                     ; 1076 60                       `
; ----------------------------------------------------------------------------
L1077:  clc                                     ; 1077 18                       .
        rts                                     ; 1078 60                       `
; ----------------------------------------------------------------------------
L1079:  .byte   "RAMCheck"                      ; 1079 52 41 4D 43 68 65 63 6B  RAMCheck
; ----------------------------------------------------------------------------
L1081:  lda     sysRAMFlg                       ; 1081 AD C4 88                 ...
        and     #$20                            ; 1084 29 20                    )
        beq     L1094                           ; 1086 F0 0C                    ..
        lda     V2104                           ; 1088 AD 04 21                 ..!
        jsr     InitDrive                           ; 108B 20 3E 07                  >.
        jsr     L1095                           ; 108E 20 95 10                  ..
        jsr     L1145                           ; 1091 20 45 11                  E.
L1094:  rts                                     ; 1094 60                       `
; ----------------------------------------------------------------------------
L1095:  jsr     L113A                           ; 1095 20 3A 11                  :.
        lda     #$84                            ; 1098 A9 84                    ..
        sta     r0H                             ; 109A 85 03                    ..
        lda     #$79                            ; 109C A9 79                    .y
        sta     r1H                             ; 109E 85 05                    ..
        lda     #$05                            ; 10A0 A9 05                    ..
        sta     r2H                             ; 10A2 85 07                    ..
        jsr     StashRAM                        ; 10A4 20 C8 C2                  ..
        bit     sysRAMFlg                       ; 10A7 2C C4 88                 ,..
        bvs     L10C2                           ; 10AA 70 16                    p.
        jsr     L113A                           ; 10AC 20 3A 11                  :.
        lda     #$90                            ; 10AF A9 90                    ..
        sta     r0H                             ; 10B1 85 03                    ..
        lda     #$83                            ; 10B3 A9 83                    ..
        sta     r1H                             ; 10B5 85 05                    ..
        lda     #$0D                            ; 10B7 A9 0D                    ..
        sta     r2H                             ; 10B9 85 07                    ..
        lda     #$80                            ; 10BB A9 80                    ..
        sta     r2L                             ; 10BD 85 06                    ..
        jsr     StashRAM                        ; 10BF 20 C8 C2                  ..
L10C2:  jsr     L113A                           ; 10C2 20 3A 11                  :.
        lda     #$80                            ; 10C5 A9 80                    ..
        sta     r0L                             ; 10C7 85 02                    ..
        sta     r2L                             ; 10C9 85 06                    ..
        lda     #$9D                            ; 10CB A9 9D                    ..
        sta     r0H                             ; 10CD 85 03                    ..
        lda     #$B9                            ; 10CF A9 B9                    ..
        sta     r1H                             ; 10D1 85 05                    ..
        lda     #$00                            ; 10D3 A9 00                    ..
        sta     r3L                             ; 10D5 85 08                    ..
        lda     #$02                            ; 10D7 A9 02                    ..
        sta     r2H                             ; 10D9 85 07                    ..
        jsr     StashRAM                        ; 10DB 20 C8 C2                  ..
        jsr     L113A                           ; 10DE 20 3A 11                  :.
        lda     #$BF                            ; 10E1 A9 BF                    ..
        sta     r0H                             ; 10E3 85 03                    ..
        lda     #$40                            ; 10E5 A9 40                    .@
        sta     r0L                             ; 10E7 85 02                    ..
        lda     #$BB                            ; 10E9 A9 BB                    ..
        sta     r1H                             ; 10EB 85 05                    ..
        lda     #$80                            ; 10ED A9 80                    ..
        sta     r1L                             ; 10EF 85 04                    ..
        lda     #$10                            ; 10F1 A9 10                    ..
        sta     r2H                             ; 10F3 85 07                    ..
        lda     #$C0                            ; 10F5 A9 C0                    ..
        sta     r2L                             ; 10F7 85 06                    ..
        jsr     StashRAM                        ; 10F9 20 C8 C2                  ..
        lda     #$30                            ; 10FC A9 30                    .0
        sta     r4L                             ; 10FE 85 0A                    ..
        lda     #$D0                            ; 1100 A9 D0                    ..
        sta     r5H                             ; 1102 85 0D                    ..
        lda     #$00                            ; 1104 A9 00                    ..
        sta     r5L                             ; 1106 85 0C                    ..
        lda     #$80                            ; 1108 A9 80                    ..
        sta     r0H                             ; 110A 85 03                    ..
        lda     #$00                            ; 110C A9 00                    ..
        sta     r0L                             ; 110E 85 02                    ..
        lda     #$CC                            ; 1110 A9 CC                    ..
        sta     r1H                             ; 1112 85 05                    ..
        lda     #$40                            ; 1114 A9 40                    .@
        sta     r1L                             ; 1116 85 04                    ..
        lda     #$01                            ; 1118 A9 01                    ..
        sta     r2H                             ; 111A 85 07                    ..
        lda     #$00                            ; 111C A9 00                    ..
        sta     r2L                             ; 111E 85 06                    ..
        lda     #$00                            ; 1120 A9 00                    ..
        sta     r3L                             ; 1122 85 08                    ..

L1124:  ldy     #$00                            ; 1124 A0 00                    ..
.ifdef config128
        php                                     ; 1072 08                       .
        sei                                     ; 1073 78                       x
        lda     #$7F                            ; 1074 A9 7F                    ..
        sta     config                          ; 1076 8D 00 FF                 ...
.endif
L1126:  lda     (r5L),y                         ; 1126 B1 0C                    ..
        sta     diskBlkBuf,y                    ; 1128 99 00 80                 ...
        iny                                     ; 112B C8                       .
        bne     L1126                           ; 112C D0 F8                    ..
.ifdef config128

        lda     #$7E                            ; 1081 A9 7E                    .~
        sta     config                          ; 1083 8D 00 FF                 ...
        plp                                     ; 1086 28                       (
.endif
        jsr     StashRAM                        ; 112E 20 C8 C2                  ..
        inc     r5H                             ; 1131 E6 0D                    ..
        inc     r1H                             ; 1133 E6 05                    ..
        dec     r4L                             ; 1135 C6 0A                    ..
        bne     L1124                           ; 1137 D0 EB                    ..

.ifdef config128
        php                                     ; 1092 08                       .
        sei                                     ; 1093 78                       x
        lda     $D506                           ; 1094 AD 06 D5                 ...
        pha                                     ; 1097 48                       H
        lda     #$40                            ; 1098 A9 40                    .@
        sta     r4L                             ; 109A 85 0A                    ..
        lda     #$C0                            ; 109C A9 C0                    ..
        sta     r5H                             ; 109E 85 0D                    ..
        lda     #$00                            ; 10A0 A9 00                    ..
        sta     r5L                             ; 10A2 85 0C                    ..
        lda     #$80                            ; 10A4 A9 80                    ..
        sta     r0H                             ; 10A6 85 03                    ..
        lda     #$00                            ; 10A8 A9 00                    ..
        sta     r0L                             ; 10AA 85 02                    ..
        lda     #$39                            ; 10AC A9 39                    .9
        sta     r1H                             ; 10AE 85 05                    ..
        lda     #$00                            ; 10B0 A9 00                    ..
        sta     r1L                             ; 10B2 85 04                    ..
        lda     #$01                            ; 10B4 A9 01                    ..
        sta     r2H                             ; 10B6 85 07                    ..
        lda     #$00                            ; 10B8 A9 00                    ..
        sta     r2L                             ; 10BA 85 06                    ..
        lda     #$00                            ; 10BC A9 00                    ..
        sta     r3L                             ; 10BE 85 08                    ..
L10C0:  lda     $D506                           ; 10C0 AD 06 D5                 ...
        and     #$F0                            ; 10C3 29 F0                    ).
        ora     #$0B                            ; 10C5 09 0B                    ..
        sta     $D506                           ; 10C7 8D 06 D5                 ...
        lda     #$7F                            ; 10CA A9 7F                    ..
        sta     config                          ; 10CC 8D 00 FF                 ...
        ldy     #$00                            ; 10CF A0 00                    ..
L10D1:  lda     (r5L),y                         ; 10D1 B1 0C                    ..
        sta     diskBlkBuf,y                    ; 10D3 99 00 80                 ...
        iny                                     ; 10D6 C8                       .
        bne     L10D1                           ; 10D7 D0 F8                    ..
        lda     #$7E                            ; 10D9 A9 7E                    .~
        sta     config                          ; 10DB 8D 00 FF                 ...
        lda     $D506                           ; 10DE AD 06 D5                 ...
        and     #$F0                            ; 10E1 29 F0                    ).
        sta     $D506                           ; 10E3 8D 06 D5                 ...
        jsr     StashRAM                        ; 10E6 20 C8 C2                  ..
        inc     r5H                             ; 10E9 E6 0D                    ..
        inc     r1H                             ; 10EB E6 05                    ..
        dec     r4L                             ; 10ED C6 0A                    ..
        bne     L10C0                           ; 10EF D0 CF                    ..
        pla                                     ; 10F1 68                       h
        sta     $D506                           ; 10F2 8D 06 D5                 ...
        plp                                     ; 10F5 28                       (
.endif
        rts                                     ; 1139 60                       `
; ----------------------------------------------------------------------------
L113A:  lda     #$00                            ; 113A A9 00                    ..
        sta     r0L                             ; 113C 85 02                    ..
        sta     r1L                             ; 113E 85 04                    ..
        sta     r2L                             ; 1140 85 06                    ..
        sta     r3L                             ; 1142 85 08                    ..
        rts                                     ; 1144 60                       `
; ----------------------------------------------------------------------------
L1145:  jsr     L113A                           ; 1145 20 3A 11                  :.
        lda     #$7E                            ; 1148 A9 7E                    .~
        sta     r1H                             ; 114A 85 05                    ..
        lda     #$05                            ; 114C A9 05                    ..
        sta     r2H                             ; 114E 85 07                    ..
        LoadW   r0, RebootCode
        jmp     StashRAM                        ; 1158 4C C8 C2                 L..

.segment "REBOOT"

; ----------------------------------------------------------------------------
; RAM reboot code?
RebootCode:
        sei                                     ; 115B 78                       x
        cld                                     ; 115C D8                       .
        ldx     #$FF                            ; 115D A2 FF                    ..
        txs                                     ; 115F 9A                       .
        lda     #$30                            ; 1160 A9 30                    .0
        sta     CPU_DATA                        ; 1162 85 01                    ..
.ifdef config128
        lda     #$7E                            ; 1121 A9 7E                    .~
        sta     config                          ; 1123 8D 00 FF                 ...
        lda     #$40                            ; 1126 A9 40                    .@
        sta     $D506                           ; 1128 8D 06 D5                 ...
.endif
        lda     #$90                            ; 1164 A9 90                    ..
        sta     r0H                             ; 1166 85 03                    ..
        lda     #$00                            ; 1168 A9 00                    ..
        sta     r0L                             ; 116A 85 02                    ..
        lda     #$83                            ; 116C A9 83                    ..
        sta     r1H                             ; 116E 85 05                    ..
        lda     #$00                            ; 1170 A9 00                    ..
        sta     r1L                             ; 1172 85 04                    ..
        lda     #$0D                            ; 1174 A9 0D                    ..
        sta     r2H                             ; 1176 85 07                    ..
        lda     #$80                            ; 1178 A9 80                    ..
        sta     r2L                             ; 117A 85 06                    ..
        jsr     L6216                           ; 117C 20 16 62                  .b
        lda     #$9D                            ; 117F A9 9D                    ..
        sta     r0H                             ; 1181 85 03                    ..
        lda     #$80                            ; 1183 A9 80                    ..
        sta     r0L                             ; 1185 85 02                    ..
        lda     #$B9                            ; 1187 A9 B9                    ..
        sta     r1H                             ; 1189 85 05                    ..
        lda     #$00                            ; 118B A9 00                    ..
        sta     r1L                             ; 118D 85 04                    ..
        lda     #$02                            ; 118F A9 02                    ..
        sta     r2H                             ; 1191 85 07                    ..
        lda     #$80                            ; 1193 A9 80                    ..
        sta     r2L                             ; 1195 85 06                    ..
        jsr     L6216                           ; 1197 20 16 62                  .b
        lda     #$BF                            ; 119A A9 BF                    ..
        sta     r0H                             ; 119C 85 03                    ..
        lda     #$40                            ; 119E A9 40                    .@
        sta     r0L                             ; 11A0 85 02                    ..
        lda     #$BB                            ; 11A2 A9 BB                    ..
        sta     r1H                             ; 11A4 85 05                    ..
        lda     #$80                            ; 11A6 A9 80                    ..
        sta     r1L                             ; 11A8 85 04                    ..
        lda     #$00                            ; 11AA A9 00                    ..
        sta     r2H                             ; 11AC 85 07                    ..
        lda     #$C0                            ; 11AE A9 C0                    ..
        sta     r2L                             ; 11B0 85 06                    ..
        jsr     L6216                           ; 11B2 20 16 62                  .b
        lda     #$C0                            ; 11B5 A9 C0                    ..
        sta     r0H                             ; 11B7 85 03                    ..
        lda     #$80                            ; 11B9 A9 80                    ..
        sta     r0L                             ; 11BB 85 02                    ..
        lda     #$BC                            ; 11BD A9 BC                    ..
        sta     r1H                             ; 11BF 85 05                    ..
        lda     #$C0                            ; 11C1 A9 C0                    ..
        sta     r1L                             ; 11C3 85 04                    ..
        lda     #$0F                            ; 11C5 A9 0F                    ..
        sta     r2H                             ; 11C7 85 07                    ..
        lda     #$80                            ; 11C9 A9 80                    ..
        sta     r2L                             ; 11CB 85 06                    ..
        jsr     L6216                           ; 11CD 20 16 62                  .b
        lda     #$30                            ; 11D0 A9 30                    .0
        sta     r4L                             ; 11D2 85 0A                    ..
        lda     #$D0                            ; 11D4 A9 D0                    ..
        sta     r5H                             ; 11D6 85 0D                    ..
        lda     #$00                            ; 11D8 A9 00                    ..
        sta     r5L                             ; 11DA 85 0C                    ..
        lda     #$80                            ; 11DC A9 80                    ..
        sta     r0H                             ; 11DE 85 03                    ..
        lda     #$00                            ; 11E0 A9 00                    ..
        sta     r0L                             ; 11E2 85 02                    ..
        lda     #$CC                            ; 11E4 A9 CC                    ..
        sta     r1H                             ; 11E6 85 05                    ..
        lda     #$40                            ; 11E8 A9 40                    .@
        sta     r1L                             ; 11EA 85 04                    ..
        lda     #$01                            ; 11EC A9 01                    ..
        sta     r2H                             ; 11EE 85 07                    ..
        lda     #$00                            ; 11F0 A9 00                    ..
        sta     r2L                             ; 11F2 85 06                    ..
L11F4:  jsr     L6216                           ; 11F4 20 16 62                  .b
        ldy     #$00                            ; 11F7 A0 00                    ..
.ifdef config128
        lda     #$7F                            ; 11C0 A9 7F                    ..
        sta     config                          ; 11C2 8D 00 FF                 ...
        lda     r5H                             ; 11C5 A5 0D                    ..
        cmp     #$FF                            ; 11C7 C9 FF                    ..
        bne     L11CD                           ; 11C9 D0 02                    ..
        ldy     #$05                            ; 11CB A0 05                    ..
L11CD:  lda     diskBlkBuf,y                    ; 11CD B9 00 80                 ...
        sta     (r5L),y                         ; 11D0 91 0C                    ..
        iny                                     ; 11D2 C8                       .
        bne     L11CD                           ; 11D3 D0 F8                    ..
        lda     #$7E                            ; 11D5 A9 7E                    .~
        sta     config                          ; 11D7 8D 00 FF                 ...
        inc     r5H                             ; 11DA E6 0D                    ..
        inc     r1H                             ; 11DC E6 05                    ..
        dec     r4L                             ; 11DE C6 0A                    ..
        bne     L11F4 ;L11BB                           ; 11E0 D0 D9                    ..
        lda     #$40                            ; 11E2 A9 40                    .@
        sta     r4L                             ; 11E4 85 0A                    ..
        lda     #$C0                            ; 11E6 A9 C0                    ..
        sta     r5H                             ; 11E8 85 0D                    ..
        lda     #$00                            ; 11EA A9 00                    ..
        sta     r5L                             ; 11EC 85 0C                    ..
        lda     #$80                            ; 11EE A9 80                    ..
        sta     r0H                             ; 11F0 85 03                    ..
        lda     #$00                            ; 11F2 A9 00                    ..
        sta     r0L                             ; 11F4 85 02                    ..
        lda     #$39                            ; 11F6 A9 39                    .9
        sta     r1H                             ; 11F8 85 05                    ..
        lda     #$00                            ; 11FA A9 00                    ..
        sta     r1L                             ; 11FC 85 04                    ..
        lda     #$01                            ; 11FE A9 01                    ..
        sta     r2H                             ; 1200 85 07                    ..
        lda     #$00                            ; 1202 A9 00                    ..
        sta     r2L                             ; 1204 85 06                    ..
L1206:  jsr     $62AD                           ; 1206 20 AD 62                  .b
        lda     #$4B                            ; 1209 A9 4B                    .K
        sta     $D506                           ; 120B 8D 06 D5                 ...
        lda     #$7F                            ; 120E A9 7F                    ..
        sta     config                          ; 1210 8D 00 FF                 ...
        ldy     #$00                            ; 1213 A0 00                    ..
        lda     r5H                             ; 1215 A5 0D                    ..
        cmp     #$FF                            ; 1217 C9 FF                    ..
        bne     L11F9                           ; 1219 D0 02                    ..
        ldy     #$05                            ; 121B A0 05                    ..
.endif
L11F9:  lda     diskBlkBuf,y                    ; 11F9 B9 00 80                 ...
        sta     (r5L),y                         ; 11FC 91 0C                    ..
        iny                                     ; 11FE C8                       .
        bne     L11F9                           ; 11FF D0 F8                    ..
.ifdef config128
        lda     #$7E                            ; 1225 A9 7E                    .~
        sta     config                          ; 1227 8D 00 FF                 ...
        lda     #$40                            ; 122A A9 40                    .@
        sta     $D506                           ; 122C 8D 06 D5                 ...
.endif
        inc     r5H                             ; 1201 E6 0D                    ..
        inc     r1H                             ; 1203 E6 05                    ..
        dec     r4L                             ; 1205 C6 0A                    ..
.ifdef config128
        bne     L1206                           ; 1207 D0 EB                    ..
.else
        bne     L11F4                           ; 1207 D0 EB                    ..
.endif
        jsr     i_FillRam                       ; 1209 20 B4 C1                  ..
        brk                                     ; 120C 00                       .
        ora     CPU_DDR                         ; 120D 05 00                    ..
        sty     CPU_DDR                         ; 120F 84 00                    ..
.ifdef config128
        lda     $D505                           ; 123F AD 05 D5                 ...
        and     #$80                            ; 1242 29 80                    ).
        eor     #$80                            ; 1244 49 80                    I.
        sta     graphMode                       ; 1246 85 3F                    .?
        lda     #$80                            ; 1248 A9 80                    ..
        sta     dispBufferOn                    ; 124A 85 2F                    ./
        bit     graphMode                       ; 124C 24 3F                    $?
        bmi     L1278                           ; 124E 30 28                    0(
.endif
        lda     #$00                            ; 1211 A9 00                    ..
        sta     r0L                             ; 1213 85 02                    ..
        lda     #$A0                            ; 1215 A9 A0                    ..
        sta     r0H                             ; 1217 85 03                    ..
        ldx     #$7D                            ; 1219 A2 7D                    .}
L121B:  ldy     #$3F                            ; 121B A0 3F                    .?
L121D:  lda     #$55                            ; 121D A9 55                    .U
        sta     (r0L),y                         ; 121F 91 02                    ..
        dey                                     ; 1221 88                       .
        lda     #$AA                            ; 1222 A9 AA                    ..
        sta     (r0L),y                         ; 1224 91 02                    ..
        dey                                     ; 1226 88                       .
        bpl     L121D                           ; 1227 10 F4                    ..
        lda     r0L                             ; 1229 A5 02                    ..
        clc                                     ; 122B 18                       .
        adc     #$40                            ; 122C 69 40                    i@
        sta     r0L                             ; 122E 85 02                    ..
        bcc     L1234                           ; 1230 90 02                    ..
        inc     r0H                             ; 1232 E6 03                    ..
L1234:  dex                                     ; 1234 CA                       .
        bne     L121B                           ; 1235 D0 E4                    ..
.ifdef config128
        beq     L1286                           ; 1276 F0 0E                    ..
L1278:  lda     #$02                            ; 1278 A9 02                    ..
        jsr     SetPattern                      ; 127A 20 39 C1                  9.
        jsr     i_Rectangle                     ; 127D 20 9F C1                  ..
        brk                                     ; 1280 00                       .
        .byte   $C7                             ; 1281 C7                       .
        brk                                     ; 1282 00                       .
        brk                                     ; 1283 00                       .
        .byte   $7F                             ; 1284 7F                       .
        .byte   $02                             ; 1285 02                       .
L1286:
.endif

        jsr     FirstInit                       ; 1237 20 71 C2                  q.
        lda     #$FF                            ; 123A A9 FF                    ..
        sta     firstBoot                       ; 123C 8D C5 88                 ...
        jsr     MOUSE_BASE                      ; 123F 20 80 FE                  ..
.ifdef config128
        lda     graphMode                       ; 1291 A5 3F                    .?
        jsr     SetNewMode                      ; 1293 20 DD C2                  ..
.endif
        lda     #$88                            ; 1242 A9 88                    ..
        sta     r0H                             ; 1244 85 03                    ..
        lda     #$C3                            ; 1246 A9 C3                    ..
        sta     r0L                             ; 1248 85 02                    ..
        lda     #$7D                            ; 124A A9 7D                    .}
        sta     r1H                             ; 124C 85 05                    ..
        lda     #$C3                            ; 124E A9 C3                    ..
        sta     r1L                             ; 1250 85 04                    ..
        lda     #$00                            ; 1252 A9 00                    ..
        sta     r2H                             ; 1254 85 07                    ..
        lda     #$02                            ; 1256 A9 02                    ..
        sta     r2L                             ; 1258 85 06                    ..
        jsr     L6216                           ; 125A 20 16 62                  .b
        lda     sysFlgCopy                      ; 125D AD 12 C0                 ...
        sta     sysRAMFlg                       ; 1260 8D C4 88                 ...
        lda     #$85                            ; 1263 A9 85                    ..
        sta     r0H                             ; 1265 85 03                    ..
        lda     #$16                            ; 1267 A9 16                    ..
        sta     r0L                             ; 1269 85 02                    ..
        lda     #$7A                            ; 126B A9 7A                    .z
        sta     r1H                             ; 126D 85 05                    ..
        lda     #$16                            ; 126F A9 16                    ..
        sta     r1L                             ; 1271 85 04                    ..
        lda     #$00                            ; 1273 A9 00                    ..
        sta     r2H                             ; 1275 85 07                    ..
        lda     #$03                            ; 1277 A9 03                    ..
        sta     r2L                             ; 1279 85 06                    ..
        lda     #$00                            ; 127B A9 00                    ..
        sta     r3L                             ; 127D 85 08                    ..
        jsr     FetchRAM                        ; 127F 20 CB C2                  ..
        lda     $DC08                           ; 1282 AD 08 DC                 ...
        sta     $DC08                           ; 1285 8D 08 DC                 ...
        lda     #$84                            ; 1288 A9 84                    ..
        sta     r0H                             ; 128A 85 03                    ..
        lda     #$8E                            ; 128C A9 8E                    ..
        sta     r0L                             ; 128E 85 02                    ..
        lda     #$79                            ; 1290 A9 79                    .y
        sta     r1H                             ; 1292 85 05                    ..
        lda     #$8E                            ; 1294 A9 8E                    ..
        sta     r1L                             ; 1296 85 04                    ..
        lda     #$00                            ; 1298 A9 00                    ..
        sta     r2H                             ; 129A 85 07                    ..
        lda     #$04                            ; 129C A9 04                    ..
        sta     r2L                             ; 129E 85 06                    ..
        jsr     FetchRAM                        ; 12A0 20 CB C2                  ..
        lda     #$88                            ; 12A3 A9 88                    ..
        sta     r0H                             ; 12A5 85 03                    ..
        lda     #$C7                            ; 12A7 A9 C7                    ..
        sta     r0L                             ; 12A9 85 02                    ..
        lda     #$7D                            ; 12AB A9 7D                    .}
        sta     r1H                             ; 12AD 85 05                    ..
        lda     #$C7                            ; 12AF A9 C7                    ..
        sta     r1L                             ; 12B1 85 04                    ..
        lda     #$00                            ; 12B3 A9 00                    ..
        sta     r2H                             ; 12B5 85 07                    ..
        lda     #$04                            ; 12B7 A9 04                    ..
        sta     r2L                             ; 12B9 85 06                    ..
        jsr     FetchRAM                        ; 12BB 20 CB C2                  ..
        lda     #$84                            ; 12BE A9 84                    ..
        sta     r0H                             ; 12C0 85 03                    ..
        lda     #$65                            ; 12C2 A9 65                    .e
        sta     r0L                             ; 12C4 85 02                    ..
        lda     #$79                            ; 12C6 A9 79                    .y
        sta     r1H                             ; 12C8 85 05                    ..
        lda     #$65                            ; 12CA A9 65                    .e
        sta     r1L                             ; 12CC 85 04                    ..
        lda     #$00                            ; 12CE A9 00                    ..
        sta     r2H                             ; 12D0 85 07                    ..
        lda     #$11                            ; 12D2 A9 11                    ..
        sta     r2L                             ; 12D4 85 06                    ..
        jsr     FetchRAM                        ; 12D6 20 CB C2                  ..
        lda     #$88                            ; 12D9 A9 88                    ..
        sta     r0H                             ; 12DB 85 03                    ..
        lda     #$CB                            ; 12DD A9 CB                    ..
        sta     r0L                             ; 12DF 85 02                    ..
        lda     #$7D                            ; 12E1 A9 7D                    .}
        sta     r1H                             ; 12E3 85 05                    ..
        lda     #$CB                            ; 12E5 A9 CB                    ..
        sta     r1L                             ; 12E7 85 04                    ..
        lda     #$00                            ; 12E9 A9 00                    ..
        sta     r2H                             ; 12EB 85 07                    ..
        lda     #$11                            ; 12ED A9 11                    ..
        sta     r2L                             ; 12EF 85 06                    ..
        jsr     FetchRAM                        ; 12F1 20 CB C2                  ..
        lda     #$84                            ; 12F4 A9 84                    ..
        sta     r0H                             ; 12F6 85 03                    ..
        lda     #$89                            ; 12F8 A9 89                    ..
        sta     r0L                             ; 12FA 85 02                    ..
        lda     #$79                            ; 12FC A9 79                    .y
        sta     r1H                             ; 12FE 85 05                    ..
        lda     #$89                            ; 1300 A9 89                    ..
        sta     r1L                             ; 1302 85 04                    ..
        lda     #$00                            ; 1304 A9 00                    ..
        sta     r2H                             ; 1306 85 07                    ..
        lda     #$01                            ; 1308 A9 01                    ..
        sta     r2L                             ; 130A 85 06                    ..
        jsr     FetchRAM                        ; 130C 20 CB C2                  ..
        jsr     InitForIO                       ; 130F 20 5C C2                  \.
        lda     #$04                            ; 1312 A9 04                    ..
        sta     r0L                             ; 1314 85 02                    ..
L1316:  ldy     #$00                            ; 1316 A0 00                    ..
        ldx     #$00                            ; 1318 A2 00                    ..
L131A:  dey                                     ; 131A 88                       .
        bne     L131A                           ; 131B D0 FD                    ..
        dex                                     ; 131D CA                       .
        bne     L131A                           ; 131E D0 FA                    ..
        dec     r0L                             ; 1320 C6 02                    ..
        bne     L1316                           ; 1322 D0 F2                    ..
        jsr     DoneWithIO                      ; 1324 20 5F C2                  _.
        lda     curDrive                        ; 1327 AD 89 84                 ...
        pha                                     ; 132A 48                       H
        lda     #$0B                            ; 132B A9 0B                    ..
        sta     curDrive                        ; 132D 8D 89 84                 ...
        sta     curDevice                       ; 1330 85 BA                    ..
        lda     #$00                            ; 1332 A9 00                    ..
        sta     NUMDRV                          ; 1334 8D 8D 84                 ...
        sta     curDevice                       ; 1337 85 BA                    ..
        lda     #$08                            ; 1339 A9 08                    ..
        sta     interleave                      ; 133B 8D 8C 84                 ...
        jsr     SetDevice                       ; 133E 20 B0 C2                  ..
        lda     #$08                            ; 1341 A9 08                    ..
        sta     V2103                           ; 1343 8D 03 21                 ..!
L1346:  ldy     V2103                           ; 1346 AC 03 21                 ..!
        lda     $8486,y                         ; 1349 B9 86 84                 ...
        beq     L135E                           ; 134C F0 10                    ..
        cpy     #$0A                            ; 134E C0 0A                    ..
        bcs     L1355                           ; 1350 B0 03                    ..
        inc     NUMDRV                          ; 1352 EE 8D 84                 ...
L1355:  lda     V2103                           ; 1355 AD 03 21                 ..!
        jsr     SetDevice                       ; 1358 20 B0 C2                  ..
        jsr     NewDisk                         ; 135B 20 E1 C1                  ..
L135E:  inc     V2103                           ; 135E EE 03 21                 ..!
        lda     V2103                           ; 1361 AD 03 21                 ..!
        cmp     #$0C                            ; 1364 C9 0C                    ..
        bcc     L1346                           ; 1366 90 DE                    ..
        beq     L1346                           ; 1368 F0 DC                    ..
        pla                                     ; 136A 68                       h
        jsr     SetDevice                       ; 136B 20 B0 C2                  ..
        jmp     EnterDeskTop                    ; 136E 4C 2C C2                 L,.
; ----------------------------------------------------------------------------
	;*=$1371
	;jmp FetchRAM
;L6216:
        ldy     #$91                            ; 1371 A0 91                    ..
.ifdef config128
.ifdef mega65
        ldx     CPU_DATA                        ; 1373 A6 01                    ..
        lda     #$35                            ; 1375 A9 35                    .5
        sta     CPU_DATA                        ; 1377 85 01                    ..
.else
        lda     #$00                            ; 13C7 A9 00                    ..
        sta     $D030   ;clkreg                          ; 13C9 8D 30 D0                 .0.
        nop                                     ; 13CC EA                       .
.endif
.else
        ldx     CPU_DATA                        ; 1373 A6 01                    ..
        lda     #$35                            ; 1375 A9 35                    .5
        sta     CPU_DATA                        ; 1377 85 01                    ..
.endif
        lda     r0H                             ; 1379 A5 03                    ..
        sta     $DF03                           ; 137B 8D 03 DF                 ...
        lda     r0L                             ; 137E A5 02                    ..
        sta     $DF02                           ; 1380 8D 02 DF                 ...
        lda     r1H                             ; 1383 A5 05                    ..
        sta     $DF05                           ; 1385 8D 05 DF                 ...
        lda     r1L                             ; 1388 A5 04                    ..
        sta     $DF04                           ; 138A 8D 04 DF                 ...
        lda     #$00                            ; 138D A9 00                    ..
        sta     $DF06                           ; 138F 8D 06 DF                 ...
        lda     r2H                             ; 1392 A5 07                    ..
        sta     $DF08                           ; 1394 8D 08 DF                 ...
        lda     r2L                             ; 1397 A5 06                    ..
        sta     $DF07                           ; 1399 8D 07 DF                 ...
        lda     #$00                            ; 139C A9 00                    ..
        sta     $DF09                           ; 139E 8D 09 DF                 ...
        sta     $DF0A                           ; 13A1 8D 0A DF                 ...
        sty     $DF01                           ; 13A4 8C 01 DF                 ...
L13A7:  lda     EXP_BASE                        ; 13A7 AD 00 DF                 ...
        and     #$60                            ; 13AA 29 60                    )`
        beq     L13A7                           ; 13AC F0 F9                    ..
.ifdef config128
.ifdef mega65
        stx     CPU_DATA                        ; 13AE 86 01                    ..
.else
        nop
        nop
.endif
.else
        stx     CPU_DATA                        ; 13AE 86 01                    ..
.endif
        rts                                     ; 13B0 60                       `
; ----------------------------------------------------------------------------
.segment "STARTUP2"

	;*=$13b1
;        .byte   $A2                             ; 13B1 A2                       .

ModStart:

.export __MODSTART__ := ModStart
