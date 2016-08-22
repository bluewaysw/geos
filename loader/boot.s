; VERY ugly C65 GEOS "loader".
;
; (C)2016 LGB (Gabor Lenart)
;
; Basically it gets the pucrunch'ed (for C64) version of the GEOS build, with its BASIC stub, etc
; And copy to the address where it would be on C64, then execute it directly, bypassing the SYS stuff.
; Also it sets up an unmapped 4510 status, without VIC3 reg $30 ROM mapping and the desired CPU port value
; for some kind of faked "C64 compatibility", though, the CPU fast mode is kept turned on for some
; GEOS performance boost :)
; Note, that I was lazy to write proper linker cfg file and use segments, so it's an ugly .ORG stuff.
; Also, a more proper solution would be use a custom un-puprunch code in the loader without the ugly
; copy hack ...


.SEGMENT "LOADADDR"
	.IMPORT __STUB_LOAD__
	.WORD __STUB_LOAD__


.SEGMENT "STUB"
.SCOPE
	.WORD	next
	.WORD	2016
	.BYTE	$FE, $02        ; BASIC token (double byte ...) for "BANK"
	.BYTE	" 0 : "
	.BYTE	$9E, " "	; SYS token
	.BYTE	<(main/10000+48)
	.BYTE	<(main/1000 .MOD 10+48)
	.BYTE	<(main/100 .MOD 10+48)
	.BYTE	<(main/10 .MOD 10+48)
	.BYTE	<(main .MOD 10+48)
	.BYTE	" : GEOS FOR C65"
	.BYTE	0
next:	.WORD	0
.ENDSCOPE



.CODE
.IMPORT uncruncher


.PROC main
	LDA	#0
	TAX
	TAY
	.BYTE	$4B	; TAZ
	.BYTE	$5C	; MAP (it also inhibits interrupts till the next NOP ... errrr ... EOM), totally unmapped status
	.BYTE	$5B	; TAB,	zero page is _zero_ page :)
	INY
	.BYTE	$2B	; TYS,	standard stack location
	.BYTE	$03	; SEE,	8 bit stack
	; Just to be sure, enable newVic mode
	LDA	#$A5
	STA	$D02F
	LDA	#$96
	STA	$D02F
	; CPU port stuff, C64-alike config
	LDA	#$FF
	STA	0
	LDA	#$37
	STA	1	; the "CPU port"
	; Various VIC register stuffs
	LDA	#64
	STA	$D031	; turn maybe used enhanched VIC3 capabilities OFF (other than FAST mode!)
	LDA	#0
	STA	$D030	; turn ROM mappings / etc OFF
	STA	$D019	; disable VIC interrupts
	STA	$D01A
	LDA	#$15
	STA	$D018
	; *** Uncrunch
	; Call with X = HI of packed data, Y = LO of packed data
	; Returns exec address in X = HI and Y = LO
	; Carry will be set for error, cleared for OK
	LDX	#.HIBYTE(geos_kernal_compressed)
	LDY	#.LOBYTE(geos_kernal_compressed)
	JSR	uncruncher
	BCS	@unpack_error
	NOP
	JMP	$5000
@unpack_error:
	INC	53281
	JMP	@unpack_error
.ENDPROC

.SEGMENT "PACKED"
geos_kernal_compressed:
	.INCBIN "compressed.bin"
