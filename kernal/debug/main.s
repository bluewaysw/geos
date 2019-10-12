; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Misc 6502 helpers

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"

.global DebugMain

.import _DoKeyboardScan
.import _GetNextChar

; syscalls

.segment "debug"

.import _DebugStart

STACK_OFFSET = 4


consoleCols:  
  .byte 80
consoleLines: 
  .byte 25
posX:
  .byte 0
posY:
  .byte 0
cursorBlinks:
  .byte 0
cursorCount:
  .byte 0
promptBuf:
	.repeat	100
    .byte 0
  .endrep
promptLen:
  .byte 0
promptLenOld:
  .byte 0
stackPointer:
  .byte 0
initialized:
  .byte 0


saveIRQ_VECTOR:
  .word 0
saveD011:
  .byte 0
saveD018:
  .byte 0
saveDD00:
  .byte 0
saveD016:
  .byte 0
saveD031:
  .byte 0
saveD020:
  .byte 0
saveD021:
  .byte 0
saveD015:
  .byte 0
saveR0:
  .word 0
saveD060:
	.byte 0
saveD061:
	.byte 0
saveD062:
	.byte 0
saveD063:
	.byte 0
saveD068:
	.byte 0
saveD069:
	.byte 0
saveD06A:
	.byte 0
saveD058:
	.byte 0
saveD05E:
	.byte 0

u_cl:
  .word 0

breakList:
  .word 0, 0, _DebugStart, 0, 0, 0, 0, 0, 0, 0
breakOpList:
  .byte 0, 0, $ea, 0, 0, 0, 0, 0, 0, 0

consoleBufAddr:
  .word consoleBuf
consoleBuf:
	.repeat	80*25
		.byte 0
	.endrep
DebugMain:

	; on any entry?
	tsx
	stx	stackPointer
	
	MoveW	IRQ_VECTOR, saveIRQ_VECTOR
	LoadW	IRQ_VECTOR, IRQHandler
	

  ; correct PC after BRK
  ldy stackPointer
  sec
  lda $106+STACK_OFFSET,y
  sbc #2
  sta $106+STACK_OFFSET,y
  sta u_cl
  lda $107+STACK_OFFSET,y
  sbc #0
  sta $107+STACK_OFFSET,y
  sta u_cl+1

  PushB CPU_DATA
  LoadB CPU_DATA, IO_IN

  PushW r0
  MoveW r0, saveR0
  PushW r1
  PushW r2
  PushW r3

  jsr ResetSingleStep
  jsr UpdatePCBreakpoint

  lda initialized
  bne @2
  LoadB initialized, $FF
  jsr ClearConsole

  LoadW r0, welcome
  jsr PutString
@2:
  ;jsr PrintRegs


  ldy stackPointer
  lda $107+STACK_OFFSET, y
  sta r0H
  lda $106+STACK_OFFSET, y
  sta r0L
  jsr DebugOpcode_Print
  cli

@HOHO:
  jsr Prompt

  ; handle the entry
  jsr ProcessPrompt

  bcc @HOHO

  ; GO situation

  ; restore breakpoint at current PC
  jsr RestorePCBreakpoint

  jsr ExitConsole

  PopW r3
  PopW r2
  PopW r1
  PopW r0

  PopB CPU_DATA

  MoveW saveIRQ_VECTOR, IRQ_VECTOR

  rts

welcome:  .byte "SuperDebugger V6.0",13,"(C) 2019 blueway.Softworks", 13, 13, 0

ClearConsole:
  ldx #0
  stx posX  ; output position top left
  stx posY
  MoveW consoleBufAddr, r0 
@2:
  lda #' '
  ldy #0
@1:
  sta (r0), y
  iny
  cpy consoleCols
  bcc @1
  lda r0L
  clc
  adc consoleCols
  sta r0L
  lda r0H
  adc #0
  sta r0H
  inx
  cpx consoleLines
  bcc @2
  rts

PutChar:
  pha
  jsr HandleScroll
  pla
  tax
  tya
  pha

  cpx #29
  bne @10

  lda posX
  bne @11
  lda posY
  beq @10
  dec posY
  lda consoleCols
  sta posX
@11:
  dec posX

@10:

  MoveW consoleBufAddr, r1
  ldy posY
  beq @1
@2:
  lda r1L
  clc
  adc consoleCols
  sta r1L
  lda r1H
  adc #0
  sta r1H
  dey
  bne @2
@1:
  txa
  bne @7

  ldy posX 
  lda (r1), y
  eor #%10000000
  sta (r1), y
  bra @4
@7:
  cmp #29
  bne @9

  ldy posX
  lda #' '
  sta (r1), y
  iny
  lda (r1), y
  and #%01111111
  sta (r1), y
  bra @4

@9:
  cmp #13
  beq @3
  cmp #96
  bcc @6
  sec
  sbc #96
@6:
  ldy posX 
  sta (r1), y
  inc posX
  iny
  cpy consoleCols
  bcc @4
  inc posY
  lda #0
  sta posX
@4:
  pla
  tay
  rts
@3:
  ldy posX 
  lda (r1), y
  and #%01111111
  sta (r1), y

  inc posY
  lda #0
  sta posX
  bra @4

PutString:
  ldy #0
@1:
  lda (r0), y
  beq @2
  jsr PutChar
  iny
  bne @1
@2:
  rts

HandleScroll:

  lda posY
  sec
  sbc consoleLines
  bcc @1

  ; we need to scroll up
  tax
  inx
  pha
  MoveW consoleBufAddr, r2
  MoveW consoleBufAddr, r3
@2:
  lda r3L
  clc
  adc consoleCols
  sta r3L
  lda r3H
  adc #0
  sta r3H
  dec posY
  dex
  bne @2
  pla   ; lines to scroll up
  tax
  inx
  tya
  pha
@3:
  ldy #0
@4:
  lda (r3), y
  sta (r2), y
  iny
  cpy consoleCols
  bne @4

  lda r2L
  clc
  adc consoleCols
  sta r2L
  lda r2H
  adc #0
  sta r2H

  lda r3L
  clc
  adc consoleCols
  sta r3L
  lda r3H
  adc #0
  sta r3H

  inx
  cpx consoleLines
  bne @3

  ; empty line with spaces, do 1 line here
  ldy #0
@5:
  lda #' '
  sta (r2), y
  iny
  cpy consoleCols
  bne @5

  pla
  tay

@1:
  rts

Prompt:
  lda #'>'
  jsr PutChar
  jsr EnterConsole

	
  MoveB promptLen, promptLenOld
  LoadB promptLen, 0

  LoadB cursorCount, 10
  lda #0
  jsr PutChar
@1:
  lda cursorCount
  bne @3
  lda #0
  jsr PutChar
  LoadB cursorCount, 10
@3:
  jsr GetKeyPress
  cmp #0
  beq @1
  cmp #13
  beq @2
  cmp #29
  beq @5
  cmp #','
  beq @6
@8:
  ldy promptLen
  cpy #100
  bcs @4
  sta promptBuf, y
  inc promptLen 
  jsr PutChar
@4:
  bra @1
@2:
  jsr PutChar
  rts
@5:
  ldy promptLen
  beq @1
  dec promptLen
  jsr PutChar
  bra @1
@6:
  ldy promptLen
  bne @8
  ldy #0
@7:
  lda promptBuf, y
  jsr PutChar
  iny
  cpy promptLenOld
  bne @7
  MoveB promptLenOld, promptLen
  bra @1

GetKeyPress:
  
  ; wait to receive next key press from buffer
  jsr _GetNextChar

  rts

IRQHandler:
	cld
	pha
	txa
	pha
	tya
	pha

	PushB CPU_DATA
	LoadB CPU_DATA, IO_IN
	ldx #0
@2:	
	lda r0,x
	pha
	inx
	cpx #32
	bne @2


 	jsr _DoKeyboardScan

	lda #1
	sta $D019
	
	lda cursorCount
	beq @7
	ldx #0
	dec cursorCount
@7:
	ldx #31
@6:	
	pla
	sta r0,x
	dex
	bpl @6

	PopB	CPU_DATA
	pla
	tay
	pla
	tax
	pla

	rti

CursorOn:
  LoadB cursorBlinks, $FF
  lda #0
  jsr PutChar
  rts

CursorOff:
  LoadB cursorBlinks, $00
  lda #0
  jsr PutChar
  rts

UpdateCursor:
  lda cursorBlinks
  beq @1
  dec cursorCount
  bne @1

  lda #0
  jsr PutChar


@1:
  rts

ProcessTrace:

  LoadW r0, trace
  jsr PutString

  jsr ResetSingleStep

  ; calc next break address
  ; move PC to r1
  ldy stackPointer
  lda $107+STACK_OFFSET, y
  sta r0H
  lda $106+STACK_OFFSET, y
  sta r0L

  ldy #0
  ;lda (r0), y     ; get opcode at PC
	jsr	GetByte

	; special opcode handling for single step
	cmp	#$4C	; JMP
	bne	@1

	ldy	#1
	lda	(r0), y     ; get jmp address low
	tax
	iny
	lda	(r0), y     ; get jmp address high
	sta	r0H
	stx	r0L

	bra	@2

@1:
	jsr	DebugOpcode_GetLen

	clc
	adc	r0L
	sta	r0L
	lda	r0H
	adc	#0
	sta	r0H
@2:
	MoveW 	r0, r1


	jsr	SetupSingleStep

	sec	
	rts


; pass: r1 address to break next
SetupSingleStep:

  ldy #0
  lda (r1),y
  tax
  ldy #18
  lda r1L
  sta breakList,y
  lda r1H
  sta breakList+1,y
  tya
  lsr
  tay
  txa
  sta breakOpList, y
  ldy #0
  tya
  sta (r1), y
  rts

ResetSingleStep:
  ldy #18
  lda breakList,y
  ora breakList+1,y
  beq @1
  
  lda breakList,y
  sta r1L
  lda breakList+1,y
  sta r1H

  tya
  lsr
  tay
  lda breakOpList, y
  ldy #0
  sta (r1), y

  tya
  ldy #18
  sta breakList,y
  sta breakList+1,y

@1:
  rts


ProcessPrompt:

  ldy promptLen
  lda #0
  sta promptBuf, y
  cpy #1
  bcc @1

  lda promptBuf
  cmp #'r'
  beq @2
  cmp #'R'
  beq @2
  cmp #'b'
  beq @3
  cmp #'B'
  beq @3

  cmp #'s'
  beq @4

  cmp #'g'
  beq @5

  cmp #'d'
  bne @6d
  jmp @6
@6d:
  cmp #'D'
  bne @8
	jmp	ProcessDump
@8:
  cmp #'t'
  bne @7
  jmp ProcessTrace
@7:
	cmp	#'m'
	bne	@1
	jmp	ProcessMap

@2:
  jmp PrintRegs
@1:
  LoadW r0, syntaxError
  jsr PutString
  clc
  rts
@3:
  jmp PrintBreakpoints
@4:
  LoadW r0, promptBuf
  LoadW r1, stackCommand
  jsr StrBeginsWith
	beq	@4b

  LoadW r0, promptBuf
  LoadW r1, setbCommand
  jsr StrBeginsWith
  bne @1

  clc
  tya
  adc r0L
  sta r0L
  lda r0H
  adc #0
  sta r0H

  jsr EvalAddrExpr
  bcs @1

  jsr SetBreakpoint

  clc
  rts
@5:
  sec
  rts
@4b:
	LoadW	r0, currentStack
	jsr	PutString

	ldx	#0
	ldy	stackPointer
	tya
	clc
	adc	#6+STACK_OFFSET
	tay
@4c:
	jsr	DumpStackFromOffset
	iny
	inx
	cpx	#20
	bne	@4c

	clc
	rts
@6:
  ldy promptLen
  cpy #1
  beq @6c
  LoadW r0, promptBuf
  clc
  lda #1
  adc r0L
  sta r0L
  lda r0H
  adc #0
  sta r0H

  jsr EvalAddrExpr
  bcs @6c
  MoveW r1, u_cl

@6c:
  MoveW u_cl, r0 

  ldx #0
@6b:
  txa
  pha
  jsr DebugOpcode_Print
  pla
  tax
  inx
  cpx #20
  bne @6b

  MoveW r0, u_cl

  clc
  rts

DumpStackFromOffset:
	txa
	pha
	tya
	pha
	LoadB	r0H, $01
	sty	r0L
	lda	#'$'
	jsr	PutChar
	lda	r0H
	jsr	PrintByteHex
	lda	r0L
	jsr	PrintByteHex
	lda	#' '
	jsr	PutChar
	lda	#' '
	jsr	PutChar

	lda	#'$'
	jsr	PutChar
	ldy	#0
	lda	(r0), y
	jsr	PrintByteHex

	lda	#' '
	jsr	PutChar

	lda	#'$'
	jsr	PutChar
	ldy	#1
	lda	(r0), y
	jsr	PrintByteHex
	ldy	#0
	lda	(r0), y
	jsr	PrintByteHex


	lda	#13
	jsr	PutChar
	pla
	tay
	pla
	tax
	rts

ProcessDump:
	ldy promptLen
	cpy #1
	beq @6c
	LoadW r0, promptBuf
	clc
	lda #1
	adc r0L
	sta r0L
	lda r0H
	adc #0
	sta r0H

	jsr EvalAddrExpr
	bcs @6c
	MoveW r1, u_cl
@6c:
	MoveW u_cl, r0 

	lda	#'$'
	jsr	PutChar
	lda	r0H
	jsr	PrintByteHex
	lda	r0L
	jsr	PrintByteHex
	lda	#' '
	jsr	PutChar

	ldx #0
@6b:
	txa
	pha
	tay
	;lda	(r0), y
	jsr	GetByte
	jsr	PrintByteHex
	lda	#' '
	jsr	PutChar
	pla
	tax
	inx
	cpx	#20
	bne	@6b

	lda	#13
	jsr	PutChar

	MoveW r0, u_cl

	clc
	rts

PrintRegs:
  LoadW r0, regsHeader
  jsr PutString

  ldy stackPointer
  lda #'$'
  jsr PutChar
  lda $104+STACK_OFFSET, y
  jsr PrintByteHex
  lda #' '
  jsr PutChar

  lda #'$'
  jsr PutChar
  lda $103+STACK_OFFSET, y
  jsr PrintByteHex
  lda #' '
  jsr PutChar

  lda #'$'
  jsr PutChar
  lda $102+STACK_OFFSET, y
  jsr PrintByteHex
  lda #' '
  jsr PutChar

  lda #'$'
  jsr PutChar
  lda $101+STACK_OFFSET, y
  jsr PrintByteHex
  lda #' '
  jsr PutChar

  lda #'$'
  jsr PutChar
  lda $107+STACK_OFFSET, y
  jsr PrintByteHex
  lda $106+STACK_OFFSET, y
  jsr PrintByteHex
  lda #' '
  jsr PutChar

  lda #'$'
  jsr PutChar
  lda stackPointer
  jsr PrintByteHex
  lda #' '
  jsr PutChar

  lda $105+STACK_OFFSET, y
  jsr PrintByteBin
  lda #' '
  jsr PutChar

  lda $01
  jsr PrintByteBin
  lda #' '
  jsr PutChar

  lda #13
  jsr PutChar

  clc
  rts

PrintByteHex:
  pha
  lsr
  lsr
  lsr
  lsr
  jsr @3
  pla
  and #$0F

@3:
  cmp #10
  bcc @1
  clc
  adc #($41-10)
  bra @2
@1:
  clc
  adc #$30
@2:
  jsr PutChar
  rts

PrintByteBin:

  ldy #0
@1:
  asl
  pha
  lda #'0'
  bcc @2
  lda #'1'
@2:
  jsr PutChar
  pla
  iny
  cpy #8
  bne @1

  rts

PrintBreakpoints:

  ldy #0
@2:
  lda breakList, y
  ora breakList+1,y
  beq @1

  lda breakList+1, y
  jsr PrintByteHex
  lda breakList, y
  jsr PrintByteHex

  lda #13
  jsr PutChar

@1:
  iny
  iny
  cpy #16
  bne @2

  clc
  rts

regsHeader:
  .byte "Acc X   Y   Z   PC    SP  NV-BDIZC MemMap", 13, 0

EnterConsole:
  ; clear color all on any entry for now
.if 1
	 LDA #<$f800
	 STA r0L
	 LDA #>$f800
	 STA r0H
	 LDA #<1
	 STA r1L
	 LDA #>1
	 STA r1H

	 LDX #8
	 LDZ #$00
	 LDA #1
colloop:

	 NOP
	 STA (r0),Z
	 INZ
	 Bne colloop
   inc r0H
   dex
   bne colloop
	 ;inc r1L
	 ;ldy r1L
	 ;cpy #$40
	 ;bne colloop
.endif

  CmpWI consoleBufAddr, $0800
  bne @do
  rts
@do:
	MoveB	$D063, saveD063
	MoveB	$D060, saveD060
	MoveB	$D061, saveD061
	MoveB	$D062, saveD062

	LDA	#<$0800
	STA	$D060
	LDA	#>$0800
	STA	$D061
	LDA	#<0
	STA	$D062
	LDA	#>0
	STA	$D063

	MoveB	$D068, saveD068
	MoveB	$D069, saveD069
	MoveB	$D06A, saveD06A

	LDA	#<$0800
	STA	$D068
	LDA	#>$0800
	STA	$D069
	LDA	#0
	STA	$D06A
		
	MoveB	$D058, saveD058
	MoveB	$D05E, saveD05E

	LDA   #80
	STA   $D058
	STA   $D05E
	
	; video ram @ 0800, chargen @1800
	MoveB $d018, saveD018
	lda #$26
	sta $d018

	;; Set DDR on CIA2 for IEC bus, VIC-II banking
	MoveB $DD00, saveDD00
	lda $DD00
	and #%11111100
	ora #%00000011 ; bank in $0000-$4000
	sta $DD00

	;; Set up default IO values (Compute's Mapping the 64 p215)
	MoveB $d011, saveD011
	lda #$1b    		; Enable text mode
	sta $d011
	MoveB $d016, saveD016
	lda #$c8		; 40 column etc
	sta $d016

	MoveB $d031, saveD031
	lda #%11000000
	sta $d031

	;; Compute's Mapping the 64, p156
	;; We use a different colour scheme of white text on all blue

	MoveB $d020, saveD020
	MoveB $d021, saveD021
	lda #$06
	sta $D020
	sta $D021

	;; Turn off sprites
	;; (observed hanging around after running programs and resetting)
	MoveB $d015, saveD015
	lda #$00
	sta $D015

	lda	$D05D
	and	#%01111111
	sta	$D05D

  jsr SwapConsoleBuf
  LoadW consoleBufAddr, $0800

  rts

ExitConsole:

  CmpWI consoleBufAddr, $0800
  beq @do
  rts
@do:

  MoveB saveD011, $d011
  MoveB saveD018, $d018
  MoveB saveDD00, $dd00
  MoveB saveD016, $d016
  MoveB saveD031, $d031
  MoveB saveD020, $d020
  MoveB saveD021, $d021
  MoveB saveD015, $d015

  MoveB	saveD060, $D060 
  MoveB	saveD061, $D061 
  MoveB	saveD062, $D062 
  MoveB	saveD063, $D063 
  MoveB	saveD068, $D068 
  MoveB	saveD069, $D069 
  MoveB	saveD06A, $D06A 
  MoveB	saveD058, $D058 
  MoveB	saveD05E, $D05E 

  jsr SwapConsoleBuf
  LoadW consoleBufAddr, consoleBuf
  rts

SwapConsoleBuf:
  LoadW r2, consoleBuf 
  LoadW r3, $0800 
  ldx #0
@2:
  ldy #0
@1:
  lda (r3), y
  taz
  lda (r2), y
  sta (r3), y
  tza
  sta (r2), y
  iny
  cpy consoleCols
  bcc @1
  lda r2L
  clc
  adc consoleCols
  sta r2L
  lda r2H
  adc #0
  sta r2H
  lda r3L
  clc
  adc consoleCols
  sta r3L
  lda r3H
  adc #0
  sta r3H
  inx
  cpx consoleLines
  bcc @2
  rts

StrBeginsWith:
  ldy #0
@2:
  lda (r1),y
  beq @1
  cmp (r0),y
  bne @1
  iny
  bne @2
@1:
  rts

EvalAddrExpr:
  ldy #0
@2:
  lda (r0),y
  beq @1
  cmp #' '
  bne @3
  iny
  bra @2
@3:
  cmp #'$'
  bne @1

  iny
  jsr EvalHexWord
  bcs @1
  lda (r0), y
  bne @1
  clc
  rts

@1:
  sec
  rts

EvalHexWord:
  LoadW r1, 0
@2:
  lda (r0), y
  beq @5
  cmp #$30
  beq @7
  bcc @1
@7:
  cmp #$3a
  bcs @3
  sec
  sbc #$30
@4:
  and #%00001111
  tax
  asl r1L
  rol r1H
  asl r1L
  rol r1H
  asl r1L
  rol r1H
  asl r1L
  rol r1H
  txa
  ora r1L
  sta r1L
  iny
  bra @2
@3:
  cmp #'A'
  bcc @1
  cmp #'G'
  bcs @1
  sec
  sbc #'A'-10
  bra @4
@5:
  clc
  rts
@1:
  sec
  rts

SetBreakpoint:
  ldy #0
  lda (r1),y
  tax
@2:
  lda breakList,y
  ora breakList+1,y
  beq @1
  iny
  iny
  cpy #16
  bne @2
  clc
  rts
@1:
  lda r1L
  sta breakList,y
  lda r1H
  sta breakList+1,y
  tya
  lsr
  tay
  txa
  sta breakOpList, y
  ldy #0
  tya
  sta (r1), y
  clc
  rts

RestorePCBreakpoint:

  ldy stackPointer
  lda $106+STACK_OFFSET,y
  sta r1L
  lda $107+STACK_OFFSET,y
  sta r1H

  ldy #0
@2:
  lda breakList,y
  cmp r1L
  bne @3
  lda breakList+1,y
  cmp r1H
  bne @3

  ; hit
  tya
  lsr
  tay
  lda breakOpList, y
  ldy #0
  sta (r1), y
  
  rts

@3:
  iny
  iny
  cpy #16
  bne @2
  rts

UpdatePCBreakpoint:

  ldx #0
@2:
  lda breakList,x
  ora breakList+1,x
  beq @1

  lda breakList,x
  sta r1L
  lda breakList+1,x
  sta r1H

  ldy #0
  tya
  sta (r1), y
  
@1:
  inx
  inx
  cpx #16
  bne @2
  rts

trace:
  .byte "Trace!", 13, 0

syntaxError:
  .byte "Syntax Error!", 13, 0
currentStack:
	.byte	"Current Stack:", 13, "addr   byte word  return address", 13, 0
lowMapLabel:
	.byte	"Low map:  ", 0
highMapLabel:
	.byte	"High map: ", 0
setbCommand:
  .byte "setb", 0
stackCommand:
  .byte "stack", 0
  .byte "sup!"
foundAndSet:
  .byte "found and set", 13, 0

INDX  = 1
ZP    = 2
IMM   = 3
ZPX   = 4
ZPY   = 5
IDSP  = 6
IND   = 7
ABSX  = 8
ABSY  = 9
WREL  = 10
INDZ  = 11
INDY  = 12
ABS   = 13
BREL  = 14
WINDX = 15

OpcodeLength:
  .byte 1
  .byte 2   ;INDX  = 1
  .byte 2   ;ZP    = 2
  .byte 2   ;IMM   = 3
  .byte 2   ;ZPX   = 4
  .byte 2   ;ZPY   = 5
  .byte 2   ;IDSP  = 6
  .byte 3   ;IND   = 7
  .byte 3   ;ABSX  = 8
  .byte 3   ;ABSY  = 9
  .byte 3   ;WREL  = 10
  .byte 2   ;INDZ  = 11
  .byte 2   ;INDY  = 12
  .byte 3   ;ABS   = 13
  .byte 2   ;BREL  = 14 
  .byte 3   ;WINDX = 15 

; in:  A = opcode
; out: A = len
DebugOpcode_GetLen:

  ldy #0
  sty r1H

  asl
  rol r1H
  asl
  rol r1H
  sta r1L

  clc
  lda #<Opcodes
  adc r1L
  sta r1L
  lda #>Opcodes
  adc r1H
  sta r1H
  
  ldx #1

  ldy #3
  lda (r1), y
  
  tax
  lda OpcodeLength,x

  rts

; in: r0 - address of opcode
; out: r0 - point to next opcode
DebugOpcode_Print:
  lda #'$'
  jsr PutChar
  lda r0H
  jsr PrintByteHex
  lda r0L
  jsr PrintByteHex
  lda #' '
  jsr PutChar

  LoadB r2H,0

  ldy #0
  ;lda (r0), Y
  jsr GetByte
  iny
  pha


  asl
  rol r2H
  asl
  rol r2H
  sta r2L

  clc
  lda #<Opcodes
  adc r2L
  sta r2L
  lda #>Opcodes
  adc r2H
  sta r2H

  ldy #0
  lda (r2), y
  jsr PutChar

  ldy #1
  lda (r2), y
  jsr PutChar

  ldy #2
  lda (r2), y
  jsr PutChar

  lda #' '
  jsr PutChar


  ldy #3
  lda (r2), Y
  cmp #0
  bne @1

  jmp @done
@1:
  cmp #ABS
  bne @2

  lda #'$'
  jsr PutChar

  ldy #2
  ;lda (r0), Y
  jsr GetByte
  jsr PrintByteHex

  ldy #1
  ;lda (r0), Y
  jsr GetByte
  jsr PrintByteHex

  jmp @done
@2:
  cmp #IMM
  bne @3

  lda #'#'
  jsr PutChar
  lda #'$'
  jsr PutChar
  ldy #1
  ;lda (r0), Y
  jsr GetByte
  jsr PrintByteHex
  jmp @done
@3:
  cmp #ZP
  bne @4

  lda #'$'
  jsr PutChar

  ldy #1
  ;lda (r0), Y
  jsr GetByte
  jsr PrintByteHex

  jmp @done

@4:
  cmp #ZPX
  bne @5

  lda #'$'
  jsr PutChar

  ldy #1
  ;lda (r0), Y
  jsr GetByte
  jsr PrintByteHex
  lda #','
  jsr PutChar
  lda #'X'
  jsr PutChar

  jmp @done

@5:
  cmp #ZPY
  bne @6

  lda #'$'
  jsr PutChar

  ldy #1
  ;lda (r0), Y
  jsr GetByte
  jsr PrintByteHex
  lda #','
  jsr PutChar
  lda #'Y'
  jsr PutChar

  jmp @done
@6:
  cmp #ABSY
  bne @7

  lda #'$'
  jsr PutChar

  ldy #2
  ;lda (r0), Y
  jsr GetByte
  jsr PrintByteHex

  ldy #1
  ;lda (r0), Y
  jsr GetByte
  jsr PrintByteHex
  lda #','
  jsr PutChar
  lda #'Y'
  jsr PutChar

  jmp @done

@7:
  cmp #ABSX
  bne @8

  lda #'$'
  jsr PutChar

  ldy #2
  ;lda (r0), Y
  jsr GetByte
  jsr PrintByteHex

  ldy #1
  ;lda (r0), Y
  jsr GetByte
  jsr PrintByteHex
  lda #','
  jsr PutChar
  lda #'X'
  jsr PutChar

  bra @done
@8:
  cmp #BREL
  bne @9
  lda #'$'
  jsr PutChar

	PushW	r0


	ldy #1
        ;lda (r0), Y
        jsr GetByte
	pha
	
	clc
	adc	r0L
	sta	r0L
	lda	r0H
	adc	#0
	sta	r0H

	lda	r0L
	clc
	adc	#2
	sta	r0L
	lda	r0H
	adc	#0
	sta	r0H

	pla
	bpl	@8a
	dec	r0H
@8a:
	lda	r0H
	jsr	PrintByteHex
	lda	r0L
	jsr	PrintByteHex

	PopW	r0

	bra @done

@9:
	ldy	#'Y'
	cmp	#INDY
	beq	@9a
	ldy	#'X'
	cmp	#INDX
	beq	@9a
	ldy	#'Z'
	cmp	#INDZ
	bne	@10
@9a:
	tya
	pha
	lda	#'('
	jsr	PutChar
	lda	#'$'
	jsr	PutChar

	ldy 	#1
	;lda 	(r0), Y
	jsr 	GetByte
	jsr	PrintByteHex
	lda	#')'
	jsr	PutChar
	lda	#','
	jsr	PutChar
	pla
	jsr	PutChar
	bra 	@done
@10:
@done:
  lda #13
  jsr PutChar

  pla
  jsr DebugOpcode_GetLen

  clc
  adc r0L
  sta r0L
  lda r0H
  adc #0
  sta r0H
  rts

GetByte:
  PushW r0
  clc 
  tya
  adc r0L
  sta r0L
  lda r0H
  adc #0
  sta r0H

  CmpWI r0, r0
  bne @a1
  lda saveR0
  bra @3
@a1:
  CmpWI r0, r0+1
  bne @a2
  lda saveR0+1
  bra @3
@a2:

	CmpWI	r0, $800
	bcc	@a3	
	CmpWI	r0, $800+80*25
	beq	@a3
	bcs	@a3

	SubVW	$800, r0
	lda	#<consoleBuf
	clc
	adc	r0L
	sta	r0L
	lda	#>consoleBuf
	adc	r0H
	sta	r0H
	ldy	#0
	lda	(r0), y
	bra	@3
@a3:
  ; check mapped area $6000-$7FFF


  ldy #0
@2:
  lda breakList, y
  ora breakList+1,y
  beq @1

  lda breakList+1, y
  cmp r0H
  bne @1
  lda breakList, y
  cmp r0L
  bne @1

  tya
  lsr
  tay
  lda breakOpList, Y
  bra @3

@1:
  iny
  iny
  cpy #16
  bne @2

  ldy #0
  lda (r0), Y
@3:
  tay
  PopW r0
  tya
  rts 

Opcodes:
  .byte "BRK", 0
  .byte "ORA", INDX
  .byte "CLE", 0
  .byte "SEE", 0
  .byte "TSB", ZP
  .byte "ORA", ZP
  .byte "ASL", ZP
  .byte "RMB", ZP ; RMB0
  .byte "PHP", 0
  .byte "ORA", IMM
  .byte "ASL", 0
  .byte "TSY", 0
  .byte "TSB", ABS
  .byte "ORA", ABS 
  .byte "ASL", ABS
  .byte "BBR", ZP ; BBR0

  .byte "BPL", BREL
  .byte "ORA", INDY
  .byte "ORA", INDZ
  .byte "BPL", WREL
  .byte "TRB", ZPX
  .byte "ORA", ZPX
  .byte "ASL", ZPX
  .byte "RMB", ZP   ; RMB1
  .byte "CLC", 0
  .byte "ORA", ABSY
  .byte "INC", 0
  .byte "INZ", 0
  .byte "TRB", ABS
  .byte "ORA", ABSX
  .byte "ASL", ABSX
  .byte "BBR", ZP  ; BBR1

  .byte "JSR", ABS 
  .byte "AND", INDX
  .byte "JSR", IND
  .byte "JSR", WINDX
  .byte "BIT", ZP
  .byte "AND", ZP
  .byte "ROL", ZP
  .byte "RMB", ZP ; RMB2
  .byte "PLP", 0 
  .byte "AND", IMM 
  .byte "ROL", 0 
  .byte "TYS", 0
  .byte "BIT", ABS
  .byte "AND", ABS 
  .byte "ROL", ABS 
  .byte "BBR", ZP   ; BBR2

  .byte "BMI", BREL
  .byte "AND", INDY
  .byte "AND", INDZ
  .byte "BMI", WREL
  .byte "BIT", ZPX
  .byte "AND", ZPX
  .byte "ROL", ZPX
  .byte "RMB", ZP ; RMB3
  .byte "SEC", 0
  .byte "AND", ABSY
  .byte "DEC", 0
  .byte "DEZ", 0
  .byte "BIT", ABSX
  .byte "AND", ABSX
  .byte "ROL", ABSX
  .byte "BBR", ZP  ; BBR3

  .byte "RTI", 0 
  .byte "EOR", INDX
  .byte "NEG", 0
  .byte "ASR", 0
  .byte "ASR", ZP
  .byte "EOR", ZP
  .byte "LSR", ZP
  .byte "RMB", ZP ; RMB4
  .byte "PHA", 0
  .byte "EOR", IMM
  .byte "LSR", 0
  .byte "TAZ", 0
  .byte "JMP", ABS
  .byte "EOR", ABS
  .byte "LSR", ABS
  .byte "BBR", ZP   ; BBR4

  .byte "BVC", BREL
  .byte "EOR", INDY
  .byte "EOR", INDZ
  .byte "BVC", WREL
  .byte "ASR", ZPX
  .byte "EOR", ZPX
  .byte "LSR", ZPX
  .byte "RMB", ZP ; RMB5
  .byte "CLI", 0
  .byte "EOR", ABSY
  .byte "PHY", 0
  .byte "TAB", 0
  .byte "MAP", 0
  .byte "EOR", ABSX
  .byte "LSR", ABSX
  .byte "BBR", ZP   ; BBR5

  .byte "RTS", 0 
  .byte "ADC", INDX
  .byte "RTN", 0
  .byte "BSR", WREL
  .byte "STZ", ZP
  .byte "ADC", ZP
  .byte "ROR", ZP
  .byte "RMB", ZP   ; RMB6
  .byte "PLA", 0
  .byte "ADC", IMM
  .byte "ROR", 0
  .byte "TZA", 0
  .byte "JMP", IND
  .byte "ADC", ABS
  .byte "ROR", ABS
  .byte "BBR", ZP     ;BBR6

  .byte "BVS", BREL
  .byte "ADC", INDY
  .byte "ADC", INDZ
  .byte "BVS", WREL
  .byte "STZ", ZPX
  .byte "ADC", ZPX
  .byte "ROR", ZPX
  .byte "RMB", ZP   ; RMB7
  .byte "SEI", 0
  .byte "ADC", ABSY
  .byte "PLY", ABSY 
  .byte "TBA", ABSY
  .byte "JMP", WINDX
  .byte "ADC", ABSX
  .byte "ROR", ABSX
  .byte "BBR", ZP ; BBR7

  .byte "BRU", BREL 
  .byte "STA", INDX 
  .byte "STA", IDSP
  .byte "BRU", WREL
  .byte "STY", ZP
  .byte "STA", ZP
  .byte "STX", ZP
  .byte "SMB", ZP            ;SMB0
  .byte "DEY", 0
  .byte "BIT", IMM
  .byte "TXA", 0
  .byte "STY", ABSX
  .byte "STY", ABS
  .byte "STA", ABS
  .byte "STX", ABS
  .byte "BBS", ZP                ;BBS0

  .byte "BCC", BREL 
  .byte "STA", INDY
  .byte "STA", INDZ
  .byte "BCC", WREL
  .byte "STY", ZPX
  .byte "STA", ZPX
  .byte "STX", ZPY
  .byte "SMB", ZP                    ;SMB1
  .byte "TYA", 0
  .byte "STA", ABSY
  .byte "TXS", 0
  .byte "STX", ABSY
  .byte "STZ", ABS
  .byte "STA", ABSX
  .byte "STZ", ABSX
  .byte "BBS", ZP                       ;BBS1

  .byte "LDY", IMM 
  .byte "LDA", INDX
  .byte "LDX", IMM
  .byte "LDZ", IMM
  .byte "LDY", ZP
  .byte "LDA", ZP
  .byte "LDX", ZP
  .byte "SMB", ZP       ; SMB2
  .byte "TAY", 0
  .byte "LDA", IMM
  .byte "TAX", 0
  .byte "LDZ", ABS
  .byte "LDY", ABS
  .byte "LDA", ABS
  .byte "LDX", ABS
  .byte "BBS", ZP     ; BBS2

  .byte "BCS", BREL
  .byte "LDA", INDY
  .byte "LDA", INDZ
  .byte "BCS", WREL
  .byte "LDY", ZPX
  .byte "LDA", ZPX
  .byte "LDX", ZPY
  .byte "SMB", ZP     ; SMB3
  .byte "CLV", 0
  .byte "LDA", ABSY
  .byte "TSX", 0
  .byte "LDZ", ABSX
  .byte "LDY", ABSX
  .byte "LDA", ABSX
  .byte "LDX", ABSY
  .byte "BBS", ZP   ; BBS3

  .byte "CPY", IMM 
  .byte "CMP", INDX
  .byte "CPZ", IMM
  .byte "DEW", ZP
  .byte "CPY", ZP
  .byte "CMP", ZP
  .byte "DEC", ZP
  .byte "SMB", ZP      ; SMB4
  .byte "INY", 0 
  .byte "CMP", IMM
  .byte "DEX", 0
  .byte "ASW", ABS
  .byte "CPY", ABS
  .byte "CMP", ABS
  .byte "DEC", ABS
  .byte "BBS", ZP     ; BBS4

  .byte "BNE", BREL 
  .byte "CMP", INDY
  .byte "CMP", INDZ
  .byte "BNE", WREL
  .byte "CPZ", ZP
  .byte "CMP", ZPX
  .byte "DEC", ZPX
  .byte "SMB", ZP     ; SMB5
  .byte "CLD", 0
  .byte "CMP", ABSY
  .byte "PHX", 0
  .byte "PHZ", 0
  .byte "CPZ", ABS
  .byte "CMP", ABSX
  .byte "DEC", ABSX
  .byte "BBS", ZP    ;BBS5

  .byte "CPX", IMM
  .byte "SBC", INDX
  .byte "LDA", IDSP
  .byte "INW", ZP
  .byte "CPX", ZP
  .byte "SBC", ZP
  .byte "INC", ZP
  .byte "SMB", ZP    ; SMB6
  .byte "INX", 0
  .byte "SBC", IMM
  .byte "EOM", 0     ; NOP
  .byte "ROW", ABS
  .byte "CPX", ABS
  .byte "SBC", ABS
  .byte "INC", ABS
  .byte "BBS", ZP     ; BBS6

  .byte "BEQ", BREL 
  .byte "SBC", INDY
  .byte "SBC", INDZ
  .byte "BEQ", WREL
  .byte "PHD", IMM
  .byte "SBC", ZPX
  .byte "INC", ZPX
  .byte "SMB", ZP          ; SMB7
  .byte "SED", 0 
  .byte "SBC", ABSY
  .byte "PLX", 0
  .byte "PLZ", 0
  .byte "PHD", ABS
  .byte "SBC", ABSX
  .byte "INC", ABSX
  .byte "BBS", ZP         ; BBS7

ProcessMap:
	LoadW	r0, lowMapLabel
	jsr	PutString

	ldy	stackPointer
	lda	$101+STACK_OFFSET-2, y
	sta	r0H


	ldy	stackPointer
	lda	$102+STACK_OFFSET-2, y
	sta	r0L

	lda	#$60
	jsr	@1

	LoadW	r0, highMapLabel
	jsr	PutString

	MoveB	highMapBnk, r0H
	MoveB	highMap, r0L
	lda	#$A0

@1:
	pha
	lda	r0H
	jsr	PrintByteHex

	lda	#' '
	jsr	PutChar

	lda	r0L
	jsr	PrintByteHex

	lda	#' '
	jsr	PutChar

	asl	r0L
	rol	r0H

	pla
	clc
	adc	r0L
	sta	r0L
	lda	r0H
	adc	#0
	sta	r0H

	lda	#'$'
	jsr	PutChar
	lda	r0H
	jsr	PrintByteHex
	lda	r0L
	jsr	PrintByteHex
	lda	#0
	jsr	PrintByteHex

	lda	#13
	jsr	PutChar

	clc
	rts
