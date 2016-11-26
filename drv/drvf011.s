
;GEOS F1011 disk driver
;reassembled by Maciej 'YTM/Elysium' Witkowiak
;31.08-3.09.2001
;ported 1581 to F011 for MEGA65 compatiblity
;05.08.2016 - 08.08.2016

		;*=DISK_BASE

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "jumptab.inc"
.include "c64.inc"


; this module is always built with the mega65 variant, so 4510 cpu supported enabled

.segment "drvf011"

DriveAddy = $0300

dir3Head	= $9c80

_InitForIO:			.word __InitForIO		;9000
_DoneWithIO:			.word __DoneWithIO		;9002
_ExitTurbo:			.word __ExitTurbo		;9004
_PurgeTurbo:			.word __PurgeTurbo		;9006
_EnterTurbo:			.word __EnterTurbo		;9008
_ChangeDiskDevice:	.word __ChangeDiskDevice	;900a
_NewDisk:			.word __NewDisk 		;900c
_ReadBlock:			.word __ReadBlock		;900e
_WriteBlock:			.word __WriteBlock		;9010
_VerWriteBlock:		.word __VerWriteBlock		;9012
_OpenDisk:			.word __OpenDisk		;9014
_GetBlock:			.word __GetBlock		;9016
_PutBlock:			.word __PutBlock		;9018
_GetDirHead:			.word __GetDirHead		;901a
_PutDirHead:			.word __PutDirHead		;901c
_GetFreeDirBlk:		.word __GetFreeDirBlk		;901e
_CalcBlksFree:	.word __CalcBlksFree		;9020
_FreeBlock:			.word __FreeBlock		;9022
_SetNextFree:		.word __SetNextFree		;9024
_FindBAMBit:			.word __FindBAMBit		;9026
_NxtBlkAlloc:		.word __NxtBlkAlloc		;9028
_BlkAlloc:			.word __BlkAlloc		;902a
_ChkDkGEOS:			.word __ChkDkGEOS		;902c
_SetGEOSDisk:		.word __SetGEOSDisk		;902e

Get1stDirEntry:		JMP _Get1stDirEntry		;9030
GetNxtDirEntry:		JMP _GetNxtDirEntry		;9033
GetBorder:			JMP _GetBorder			;9036
AddDirBlock:			JMP _AddDirBlock		;9039
ReadBuff:			JMP _ReadBuff			;903c
WriteBuff:			JMP _WriteBuff			;903f
					JMP __I9042			;9042
					JMP GetDOSError 		;9045
AllocateBlock:		JMP _AllocateBlock		;9048
ReadLink:			JMP _ReadLink			;904b

E904E:				.byte $03			;904e

; ==============================================================================

evenFlag:		.byte 0

; ==============================================================================

__GetDirHead:	
	JSR SetDirHead_1		;904f
	JSR __GetBlock
	BNE GDH_0
	JSR SetDirHead_2
	JSR __GetBlock
	BNE GDH_0
	JSR SetDirHead_3
	BNE __GetBlock
GDH_0:		
	RTS				;9064

_ReadBuff:	
	LoadW r4, diskBlkBuf		;9065

__GetBlock:
	JSR InitForIO
	JSR ReadBlock
	JSR DoneWithIO

	TXA
	RTS

__PutDirHead:					;907d
	JSR SetDirHead_1
	JSR __PutBlock
	BNE PDH_0
	JSR SetDirHead_2
	JSR __PutBlock
	BNE PDH_0
	JSR SetDirHead_3
	BNE __PutBlock
PDH_0:		
	RTS				;9092

_WriteBuff:	
	LoadW r4, diskBlkBuf		;9093
__PutBlock:
	JSR InitForIO
	JSR WriteBlock
	bnex PutBlk0
	JSR VerWriteBlock

PutBlk0:
	JSR DoneWithIO			;90ac

	TXA
	RTS

SetDirHead_1:	
	LDX #>curDirHead		;90b1
	LDY #<curDirHead
	LDA #0
	BEQ SDH_1

	SetDirHead_2:	
	LDX #>dir2Head			;90b9
	LDY #<dir2Head
	LDA #1
	BNE SDH_1
SetDirHead_3:
	LDX #>dir3Head			;90c1
	LDY #<dir3Head
	LDA #2
SDH_1:		
	STX r4H				;90c7
	STY r4L
	STA r1H
	LDA #DIR_1581_TRACK
	STA r1L
	RTS

CheckParams:
	bbrf 6, curType, CheckParams_1	;90d2
	JSR DoCacheVerify
	BEQ CheckParams_2
CheckParams_1:
 	
	LDA #0				;90dc
	STA errCount
	LDX #INV_TRACK
	LDA r1L
	BEQ CheckParams_2
	CMP #81
	BCS CheckParams_2
	SEC
	RTS
CheckParams_2: 	
	CLC				;90ed
	RTS

__OpenDisk:					;90ba
	LDY curDrive
	LDA _driveType,y
	STA tmpDriveType
	AND #%10111111
	STA _driveType,y
	JSR NewDisk
	bnex OpenDsk1
	JSR GetDirHead
	bnex OpenDsk1
	bbrf 6, tmpDriveType, OpenDsk10
	JSR SetDirHead_1
	JSR DoCacheVerify
	BNE OpenDsk0
	JSR SetDirHead_2
	JSR DoCacheVerify
	BEQ OpenDsk10
OpenDsk0:
	JSR DoClearCache		;911e
	JSR SetDirHead_1
	JSR DoCacheWrite
	JSR SetDirHead_2
	JSR DoCacheWrite
	JSR SetDirHead_3
	JSR DoCacheWrite
OpenDsk10:
	JSR SetCurDHVec			;9133

	JSR ChkDkGEOS
	LoadW r4, curDirHead+OFF_DISK_NAME
	LDX #r5
	JSR GetPtrCurDkNm
	LDX #r4
	LDY #r5
	LDA #18
	JSR CopyFString
	LDX #0
OpenDsk1:
	LDY curDrive			;910a
	LDA tmpDriveType
	STA _driveType,y
	RTS

__BlkAlloc:					;915b
	PopW r3			;!!!hint???
	PushW r3
	SubW SaveFile+1, r3
	LDY #$27
	LDA r3H
	BEQ E917E
	LDY #$23
E917E:
	STY r3L				;917e
	LDY #0
	STY r3H
	LDA #2
	BNE E918A
__NxtBlkAlloc:
	LDA #0				;9188
E918A:
	STA E9C64			;918a

	PushW r9
	PushW r3
	LoadW r3, $00fe
	LDX #r2
	LDY #r3
	JSR Ddiv
	LDA r8L
	BEQ BlkAlc0
	INC r2L
	BNE *+4
	INC r2H
BlkAlc0: 	
	JSR SetCurDHVec			;91b2
	JSR CalcBlksFree
	PopW r3
	LDX #INSUFF_SPACE
	CmpW r2, r4
	BEQ BlkAlc1
	BCS BlkAlc4
BlkAlc1: 	
	MoveW r6, r4			;91ce
	MoveW r2, r5
BlkAlc2:
 	JSR SetNextFree 		;91de
	bnex BlkAlc4
	LDY #0
	LDA r3L
	STA (r4),y
	INY
	LDA r3H
	STA (r4),y
	AddVW 2, r4
	LDA E9C64
	BEQ BlkAlc2_1
	DEC E9C64
	BNE BlkAlc2_1
	LoadB r3L, $23
BlkAlc2_1:	
	LDA r5L				;9208
	BNE *+4
	DEC r5H
	DEC r5L
	LDA r5L
	ORA r5H
	BNE BlkAlc2
	LDY #0
	TYA
	STA (r4),y
	INY
	LDA r8L
	BNE BlkAlc3
	LDA #$fe
BlkAlc3: 
	CLC				;9222
	ADC #1
	STA (r4),y
	LDX #0
BlkAlc4:
 	PopW r9			;9229
	RTS

SetCurDHVec:	
	LoadW r5, curDirHead		;9230
	RTS

_Get1stDirEntry:					;9239
	JSR SetDirHead_3
	INC r1H
	LoadB borderFlag, 0
	BEQ GNDirEntry0

_GetNxtDirEntry:				;9245
	LDX #0
	LDY #0
	AddVW $20, r5
	CmpWI r5, diskBlkBuf+$ff
	BCC GNDirEntry1
	LDY #$ff
	MoveW diskBlkBuf, r1
	BNE GNDirEntry0
	LDA borderFlag
	BNE GNDirEntry1
	LDA #$ff
	STA borderFlag
	JSR GetBorder
	bnex GNDirEntry1
	TYA
	BNE GNDirEntry1
GNDirEntry0:
	JSR ReadBuff			;9281
	LDY #0
	LoadW r5, diskBlkBuf+FRST_FILE_ENTRY
GNDirEntry1:
	RTS				;928e

_GetBorder:					;928f
	JSR GetDirHead
	bnex GetBord2
	JSR SetCurDHVec
	JSR ChkDkGEOS
	BNE GetBord0
	LDY #$ff
	BNE GetBord1
GetBord0:	
	MoveW curDirHead+OFF_OP_TR_SC, r1	;92a1
	LDY #0
GetBord1:	
	LDX #0				;92ad
GetBord2:	
	RTS				;92af

__ChkDkGEOS:					;92b0
	LDY #OFF_GS_ID
	LDX #0
	STX isGEOS
ChkDkG0:
 	LDA (r5),y			;92b7
	CMP GEOSDiskID,x
	BNE ChkDkG1
	INY
	INX
	CPX #11
	BNE ChkDkG0
	LoadB isGEOS, $ff
ChkDkG1:
 	LDA isGEOS			;92c9
	RTS

GEOSDiskID:
	.byte "GEOS format V1.0",NULL	;92cd

__GetFreeDirBlk: 				;92de
	PHP
	SEI
	PushB r6L
	PushW r2
	LDX r10L
	INX
	STX r6L
	LoadB r1L, DIR_1581_TRACK
	LoadB r1H, 3
GFDirBlk0:
	JSR ReadBuff			;92f6
GFDirBlk1:
	bnex GFDirBlk5 		;92f9
	DEC r6L
	BEQ GFDirBlk3
GFDirBlk11:
	LDA diskBlkBuf			;9300
	BNE GFDirBlk2
	JSR AddDirBlock
	bra GFDirBlk1
GFDirBlk2:
	STA r1L 			;930b
	MoveB diskBlkBuf+1, r1H
	bra GFDirBlk0
GFDirBlk3:
	LDY #FRST_FILE_ENTRY		;9315
	LDX #0
GFDirBlk4:
	LDA diskBlkBuf,y		;9319
	BEQ GFDirBlk5
	TYA
	addv $20
	TAY
	BCC GFDirBlk4
	LoadB r6L, 1
	LDX #FULL_DIRECTORY
	LDY r10L
	INY
	STY r10L
	CPY #$12
	BCC GFDirBlk11
GFDirBlk5:
	PopW r2			;9334
	PopB r6L
	PLP
	RTS

_AddDirBlock:					;933f
	PushW r6
	LDX #4
	LDA dir2Head+$fa
	BEQ ADirBlk0
	MoveW r1, r3
	JSR SetNextFree
	MoveW r3, diskBlkBuf
	JSR WriteBuff
	bnex ADirBlk0
	MoveW r3, r1
	JSR ClearAndWrite
ADirBlk0:
	PopW r6			;9372
	RTS

ClearAndWrite:
	LDA #0				;9379
	TAY
CAndWr0:
 	STA diskBlkBuf,y		;937c
	INY
	BNE CAndWr0
	DEY
	STY diskBlkBuf+1
	JMP WriteBuff

__SetNextFree:					;9389
	JSR SNF_1
	BNE SNF_0
	RTS
SNF_0:
	LoadB r3L, $27			;938f
SNF_1:
	LDA r3H				;9393
	addv 1
	STA r6H
	MoveB r3L, r6L
	CMP #DIR_1581_TRACK
	BEQ SNF_3
SNF_2:
	LDA r6L				;93a2
	CMP #DIR_1581_TRACK
	BEQ SNF_8
SNF_3:
	CMP #DIR_1581_TRACK+1		;93a8
	BCC SNF_4
	subv DIR_1581_TRACK
SNF_4:
	subv $01			;93af
	ASL
	STA r7L
	ASL
	CLC
	ADC r7L
	TAX
	CmpBI r6L, DIR_1581_TRACK+1
	BCC SNF_5
	LDA dir3Head+$10,x
	bra SNF_6
SNF_5:
	LDA dir2Head+$10,x		;93c6
SNF_6:
	BEQ SNF_8			;93c9
	LoadB r7L, DIR_1581_TRACK
	TAY
SNF_7:
	JSR SNxtFreeHelp		;93d0
	BEQ SNF_11
	INC r6H
	DEY
	BNE SNF_7
SNF_8:
	CmpBI r6L, DIR_1581_TRACK+1			;93da
	BCS SNF_9
	DEC r6L
	BNE SNF_10
	LoadB r6L, DIR_1581_TRACK+1
	BNE SNF_10
SNF_9:
	INC r6L				;93ea
SNF_10:
	CmpBI r6L, $51			;93ec
	BCS SNF_12
	LoadB r6H, 0
	BEQ SNF_2
SNF_11:
	MoveW r6, r3			;93f8
	LDX #0
	RTS
SNF_12:
	LDX #INSUFF_SPACE		;9403
	RTS

SNxtFreeHelp:	
	LDA r6H 			;9406
SNFHlp_1:	
	CMP r7L 			;9408
	BCC SNFHlp_2
	sub r7L
	bra SNFHlp_1
SNFHlp_2:
	STA r6H 			;9412

_AllocateBlock:
	JSR FindBAMBit			;9414
	BNE AllBlk_0
	LDX #BAD_BAM
	RTS
AllBlk_0:
	PHP				;941c
	CmpBI r6L, DIR_1581_TRACK+1
	BCC AllBlk_2
	LDA r8H
	EOR dir3Head+$10,x
	STA dir3Head+$10,x
	LDX r7H
	PLP
	BEQ AllBlk_1
	DEC dir3Head+$10,x
	bra AllBlk_4
AllBlk_1:
	INC dir3Head+$10,x		;9436
	bra AllBlk_4
AllBlk_2:
	LDA r8H				;943c
	EOR dir2Head+$10,x
	STA dir2Head+$10,x
	LDX r7H
	PLP
	BEQ AllBlk_3
	DEC dir2Head+$10,x
	bra AllBlk_4
AllBlk_3:
	INC dir2Head+$10,x		;944f
AllBlk_4:
	LDX #0				;9452
	RTS

__FreeBlock:
	JSR FindBAMBit			;9455
	BEQ AllBlk_0
	LDX #BAD_BAM
	RTS

__FindBAMBit:
					;945d
	LDA r6H
	AND #%00000111
	TAX
	LDA FBBBitTab,x
	STA r8H
	CmpBI r6L, DIR_1581_TRACK+1
	BCC FBB_1
	subv DIR_1581_TRACK
FBB_1:
	subv $1
	ASL
	STA r7H
	ASL
	add r7H
	STA r7H
	LDA r6H
	LSR
	LSR
	LSR
	SEC
	ADC r7H
	TAX
	CmpBI r6L, DIR_1581_TRACK+1
	BCC FBB_2
	LDA dir3Head+$10,x
	AND r8H
	RTS
FBB_2:
	LDA dir2Head+$10,x
	AND r8H
	RTS
		
FBBBitTab:
	.byte $01, $02, $04, $08	;9497
	.byte $10, $20, $40, $80

__CalcBlksFree:					;949f
	LoadW r4, 0
	LDY #$10
CBlksFre0:
	LDA dir2Head,y			;94a7
	add r4L
	STA r4L
	BCC *+4
	INC r4H
CBlksFre1:
	TYA				;94b3
	addv 6
	TAY
	CPY #$FA
	BEQ CBlksFre1
	CPY #$00
	BNE CBlksFre0
	LDY #$10
CBlksFre2:
	LDA dir3Head,y			;94c2
	add r4L
	STA r4L
	BCC *+4
	INC r4H
CBlksFre3:
	TYA				;94ce
	addv 6
	TAY
	BNE CBlksFre2
	LoadW r3, $0c58
	RTS

__InitForIO:					;95c6
	PHP
	PLA
	STA tmpPS
	SEI
	LDA CPU_DATA
	STA tmpCPU_DATA
	LoadB CPU_DATA, KRNL_IO_IN
	LDA grirqen
	STA tmpgrirqen
	LDA clkreg
	STA tmpclkreg
	LDY #0
	STY clkreg
	STY grirqen
	LDA #%01111111
	STA grirq
	STA cia1base+13
	STA cia2base+13
	LDA #%00111111
	STA cia2base+2
	LDA mobenble
	STA tmpmobenble
	STY mobenble
	STY cia2base+5
	INY
	STY cia2base+4
	
	; The implementation assumes, that the environment is properly initialized
	; already, especially VICIII or VICIV enabled, running CPU at 3.5Mhz or
	; 48Mhz in case of MEGA65
	;LDA #$A5      ; C65: VIC-III enable sequence
	;STA $D02F
	;LDA #$96
	;STA $D02F     ; C65: VIC-III enabled
	;lda	#$40
	;TSB $D031     ; set bit 6 in $D031 to put CPU at 3.5MHz
	;;lda	#$21
	;;TSB $D030     ; bank in $C000 interface ROM and remove CIAs from IO map
	
	RTS

__DoneWithIO:
	SEI
	LDA tmpclkreg
	STA clkreg
	LDA tmpmobenble
	STA mobenble
	LoadB cia2base+13, %01111111
	LDA cia2base+13
	LDA tmpgrirqen
	STA grirqen
	LDA tmpCPU_DATA
	STA CPU_DATA
	LDA tmpPS
	PHA
	PLP
	RTS

_ReadLink:					;98cf
__ReadBlock:					;98e4
	JSR CheckParams_1
	BCC _ReadBlockEnd

	bbrf 6, curType, _ReadBlockCont1
	JSR DoCacheRead
	BNE _ReadBlockEnd

_ReadBlockCont1:
; Read sector from disk
	JSR _SetOperation	; set 
	BCS @1
	LDA #$01
	STA $D081
	LDA #$40
	STA $D081
@3:
	LDA $D082
	AND #$10
	BNE @2
	LDA $D083
	BPL @3
@2:
@1:
	LDY #$00		;; read over 256 bytes if needed
	LDA evenFlag
	BEQ @4
@5:
	JSR _ReadByte		
	INY
	BNE @5
@4:
@6:
	JSR _ReadByte		; read our 256 byte sector in the buffer?
	STA (r4L),Y
	INY
	BNE @6
	
	LDX #0			; no error
	
ReadBlockDirBlock:
	CmpBI r1L, DIR_1581_TRACK                      ;9924
	BNE _ReadBlockWriteCache
	LDA r1H
	BNE _ReadBlockWriteCache

	LDY #4
_ReadBlockMoveLoop:
	LDA (r4),y                      ;9930
	STA E9C63
	TYA
	addv $8c
	TAY
	LDA (r4),y
	PHA
	LDA E9C63
	STA (r4),y
	TYA
	subv $8c
	TAY
	PLA
	STA (r4),y
	INY
	CPY #$1d
	BNE _ReadBlockMoveLoop

_ReadBlockWriteCache:
	bnex _ReadBlockEnd                  ;9924
	bbrf 6, curType, _ReadBlockEnd
	JSR DoCacheWrite
	bra _ReadBlockEnd

_ReadBlockEnd:
	LDY #0

	RTS

_ReadByte:
@1:
	LDA $D082
	AND #$20
	BNE @1
	LDA $D087
	RTS
	
_WriteByte:
	STA $D087
	RTS
	
_SetOperation:

	JSR _WaitReady
	
	LDA r1L		; track 1-80
	DEC
	STA $D084		; track
	
	LDA r1H		; 
	CMP #$14		; c set if >= 20
	LDA #$00
	ROL
	EOR #1
	STA $D086		; side
	EOR #1
	BEQ @1
	LDA #$14
@1:
	NEG
	CLC
	ADC r1H
	LSR
	INC
	STA $D085		; sector
	
	LDA #$00
	ROR
	STA evenFlag
	
	CLC
	RTS

_ExecCommand:
	STA $D081
_WaitReady:
@1:
	BIT $D082
	BMI @1
	RTS

_CheckResult:
	JSR _WaitReady
	LDA $D082
	AND #$18
	BEQ @1
	
	SEC
	RTS
@1:
	CLC
	RTS

_DriveReady:
	JSR _WaitReady
	LDA $D082
	AND #$02
	BNE @1
	CLC
	RTS
@1:
	SEC
	RTS
	
__WriteBlock:					;9960
	JSR CheckParams
	BCC _WriteBlockEnd

	JSR ReadBlockDirBlock

	; f011 block write here
	JSR _SetOperation		; set track, side, sector
	BCS _WriteBlockEnd
	
	JSR _DriveReady		; drive ready, not wrote protect
	BCS _WriteBlockEnd
	
	LDA #$40
	JSR _ExecCommand		; execute read	
	JSR _CheckResult		; test if read succeeded
	BCS _WriteBlockEnd
	
	LDY #$00		; skip first 256 bytes if needed
	LDA evenFlag
	BEQ @1
@2:
	JSR _ReadByte	; read byte without checking if available
	INY	
	BNE @2	
@1:
	LDA (r4),Y		; write our 256 byte buffer
	JSR _WriteByte
	INY
	BNE @1
@4:
	LDA $D082		; read up rest of the buffer
	AND #$20
	BNE @3
	JSR _ReadByte 	; read byte without checking if available
	BRA @4
@3:
	LDA #$80
	JSR _ExecCommand 		; write sector

	; read back written sector
	; here we use this not for checking but to ensure the 
	; the next read will be alined, strange
	; TODO: double check why this fails on mega65 if reading
	; the next blick straigt after write command
	LDA #$40	; read command
	JSR _ExecCommand	; execute FDC command
	JSR _CheckResult  	; Test wether read or write succeed?
	
	LDX	#0
	
_WriteBlockEnd:
	JSR ReadBlockDirBlock			;998b

	RTS				;998e

__VerWriteBlock: 				;998f
	LDX #0
	bbrf 6, curType, VWrBlock3
	JMP DoCacheWrite
VWrBlock3:
	RTS				;9886

__ChangeDiskDevice:
	STA curDrive
	STA curDevice

__EnterTurbo:
__NewDisk:
__PurgeTurbo:
__ExitTurbo:	
GetDOSError:
__I9042:
__SetGEOSDisk:
GetDError:
	LDA #0
	TAX
	RTS


ClrCacheDat:
	.word 0				;9bb2

ClearCache:	
	bbsf 6, curType, DoClearCache	;9bb4
	RTS

DoClearCache:
	JSR E9C4A			;9bba
	LoadW r0, ClrCacheDat		;9c0f
	LDA #0
	STA r1L
	STA r1H
	STA r2H
	LDA #2
	STA r2L
	LDY curDrive
	LDA driveData,y
	STA r3L
DoClrCache1:
	JSR StashRAM			;9bd9
	INC r1H
	BNE DoClrCache1
DoClrCache2:
	LDX #8				;9be0
DoClrCache3:
	LDA E9C63-1,x			;9be2
	STA r0L-1,x
	DEX
	BNE DoClrCache3
	RTS

DoCacheVerify:
	LDA r1L				;9beb
	CMP #DIR_1581_TRACK
	BNE E9BF9
	LDY #$93			;9bf1
	JSR DoCacheDisk
	AND #$20
	RTS
E9BF9:
	LDX #0				;9bf9
	LDA #$ff
	RTS

DoCacheRead:
	LDA r1L				;9bfe
	CMP #DIR_1581_TRACK
	BNE GiveNoError
	LDY #%10010001			;9bfe
	JSR DoCacheDisk
	LDY #0
	LDA (r4),y
	INY
	ORA (r4),y
	RTS
GiveNoError:
	LDX #0				;9c11
	RTS

DoCacheWrite:
	LDA r1L				;9c14
	CMP #DIR_1581_TRACK
	BNE E9C1E
	LDY #%10010000
	BNE DoCacheDisk
E9C1E:
	LDX #0				;9c1e
	RTS
DoCacheDisk:
	JSR E9C4A			;9c21
	TYA
	PHA
	LDY curDrive
	LDA driveData,y
	STA r3L
	LDY #0
	STY r1L
	STY r2L
	INY
	STY r2H
	MoveW r4, r0
	PLA
	TAY
	JSR DoRAMOp
	TAY
	JSR DoClrCache2
	TYA
	RTS

E9C4A:
	LDX #8				;9c4a
E9C4C:
	LDA r0L-1,x			;9c4c
	STA E9C63-1,x
	DEX
	BNE E9C4C
	RTS

tmpclkreg:
	.byte 0				;9c55
tmpPS:			
	.byte 0				;9c56
tmpgrirqen:		
	.byte 0				;9c57
tmpCPU_DATA:		
	.byte 0				;9c58
tmpmobenble:		
	.byte 0				;9c59
	.byte 0				;9c5a
errCount:		
	.byte 0				;9c60
tmpDriveType:	
	.byte 0				;9c62
E9C63:			
	.byte 0				;9c63
E9C64:			
	.byte 0				;9c64
borderFlag:		
	.byte 0				;9c65

cname:  
	.byte "#"
cname_end:

