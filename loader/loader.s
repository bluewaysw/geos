; Kind of C65 GEOS "loader" / basic stub / decruncher.
;
; (C)2016 LGB Gábor Lénárt

;.INCLUDE "c65.inc"

.SETCPU "4510"

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
	.BYTE	" : GEOS LOADER AND KERNAL FOR C65 MODE ONLY"
	.BYTE	0
next:	.WORD	0
.ENDSCOPE



.CODE
.PROC main
	SEI
	CLD
	LDA	#0
	TAX
	TAY
	TAZ	; we use Z register as zero, so STZ is about the same as on 65C02
	MAP	; no CPU mapping
	TAB	; just to be sure: ZP at $0000
	INY
	TYS	; just to be sure: stack at $100
	SEE	; just to be sure: 8 bit stack
	EOM
	; Just to be sure, enable newVic mode, to access eg VIC-3 register $30
	; We don't need Mega65 fast mode here at any price, let's do that
	; later maybe, in c65/start.s
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
	STZ	$D030	; turn ROM mappings / etc OFF
	STZ	$D019	; disable VIC interrupts
	STZ	$D01A
	LDA	#$30	; full RAM for uncrunching
	STA	1
	.IMPORT	uncruncher
	JSR	uncruncher
	;STZ	53280
	;STZ	53281
	JMP	$5000
.ENDPROC



.SEGMENT "GEOS"
.INCBIN "build/mega65/compressed.bin"
