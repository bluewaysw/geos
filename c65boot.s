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

	.ORG	$1FFF		; C65 basic loader start stuff

	.WORD	basic
basic:
	.WORD	basic_next
	.WORD	2016
	.BYTE	$FE, $02        ; BASIC token (double byte ...) for "BANK"
	.BYTE	" 0 : "
	.BYTE	$9E, " "	; SYS token
	.BYTE	(main/1000+48)
	.BYTE	(main/100 .MOD 10+48)
	.BYTE	(main/10 .MOD 10+48)
	.BYTE	(main .MOD 10+48)
	.BYTE	" : GEOS FOR C65"
	.BYTE	0
basic_next:
	.WORD	0


relocator_run_addr = $400



relocator_load_addr:
	.ORG	relocator_run_addr
	; Copy stuff to the usual basic start location
	; Yes, cool guys use DMAgic on C65. Though I am not a cool guy. Yet :)
relocator_start:
relocator_exec:
	LDA	geos_kernal,Y
	STA	$7FF,Y
	INY
	BNE	relocator_exec
	INC	relocator_exec + 2
	INC	relocator_exec + 5
	DEX
	BPL	relocator_exec
	NOP				; aka. EOM ... (must be here!)
	JMP	2061			; the ugly hack: we simulate pucrunch's SYS 2061 here


	.ORG	relocator_load_addr + (* - relocator_run_addr)



main:
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
	; *** Copy the relocator code
	; 128 bytes should be enough for everyone!
	LDX	#0
copy_relocator:
	LDA	relocator_load_addr, X
	STA	relocator_run_addr, X
	INX
	BPL	copy_relocator
	; Preparing to call the relocator code
	LDY	#0
	LDX	#geos_kernal_pages
	; Call the relocator
	JMP	relocator_exec


geos_kernal:
	.INCBIN "compressed.prg"
geos_kernal_pages = ((* - geos_kernal) >> 8) + 1
