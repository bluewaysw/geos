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


.INCLUDE "c65.inc"


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



.PROC main
	LDA	#0
	TAX
	TAY
	TAZ
	MAP
	TAB
	INY
	TYS
	SEE
	SEI
	EOM
	; Just to be sure, enable newVic mode
	LDA	#$A5
	STA	$D02F
	LDA	#$96
	STA	$D02F
	; CPU port stuff
	LDA	#$2F
	STA	0
	LDA	#$37
	STA	1
	; Various VIC register stuffs
	LDA	#64
	STA	$D031	; turn maybe used enhanched VIC3 capabilities OFF (other than FAST mode!)
	STZ	$D030	; turn ROM mappings / etc OFF
	STZ	$D019	; disable VIC interrupts
	STZ	$D01A
	LDA	#$15
	STA	$D018
	; *** Uncrunch
	; Call with X = HI of packed data, Y = LO of packed data
	; Returns exec address in X = HI and Y = LO
	; Carry will be set for error, cleared for OK
	.IMPORT __GEOS_LOAD__
	LDX	#.HIBYTE(__GEOS_LOAD__)
	LDY	#.LOBYTE(__GEOS_LOAD__)
	LDA	#$30
	STA	1
	.IMPORT	uncruncher
	JSR	uncruncher
	LDA	#$37
	STA	1
	BCS	@unpack_error
	JMP	$5000
@unpack_error:
	INA
	STA	53281
	JMP	@unpack_error
.ENDPROC


.SEGMENT "GEOS"
.INCBIN "compressed.bin"
