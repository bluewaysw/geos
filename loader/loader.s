; Kind of C65 GEOS "loader" / basic stub / decruncher.
;
; (C)2016 LGB Gábor Lénárt

;.INCLUDE "c65.inc"

.include "const.inc"
.include "geossym.inc"

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

	lda	#$10
	sta $02
	lda #$01
	sta $03
	lda #$01
	sta $04
	lda	#$00
	sta $05

	lda	#$18
	LDZ	#2
	EOM
	sta ($02), Z
	lda #$19
	INZ
	EOM
	sta ($02), Z

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
	STZ $D031
	STZ	$D019	; disable VIC interrupts
	STZ	$D01A

	lda	#$80
	sta	$d06f

	LDA   $D054
	ORA   #$40
	STA   $D054
	lda   #$40
	sta	  $d031

	 ; Set screen ram that has 100x60 cells x 2 bytes per cell = 12,000 bytes of colour
	 ; information for bitmap mode.
	 ; First byte is foreground colour (8-bit) and second byte is background colour (also 8-bit),
	 ; so each 8x8 cell can still have only 2 colours, but they can be chosen from the whole
	 ; palette.
	 LDA #<$2000
	 STA $D060
	 LDA #>$2000
	 STA $D061
	 LDA #<1
	 STA $D062
	 LDA #>1
	 STA $D063
	 ; Set bitmap data to somewhere that has 100x60 x 8 = 48,000 bytes of RAM.
	 ; (We are using 2nd bank of 64KB for this)
	 ; NOTE: This can't actually be set freely (yet), but will be on 16KB boundaries.
	 LDA #<$4000
	 STA $D068
	 LDA #>$4000
	 STA $D069
	 LDA #1
	 STA $D06A


	 ; Setup foreground/background colours
.if 1
	 LDA #<$e000
	 STA $FB
	 LDA #>$e000
	 STA $FC
	 LDA #<4
	 STA $FD
	 LDA #>4
	 STA $FE

	 LDX #100
	 LDZ #$00
	 LDA #(DKGREY << 4)+LTGREY
colloop:

	 NOP
	 STA ($FB),Z
	 INZ
	 DEX
	 BNE cc1
	 LDX #100
cc1:
	 CPZ #$00
	 bne colloop
	 inc $fc
	 ldy $fc
	 cpy #$40
	 bne colloop
.endif
	LDA	#$30	; full RAM for uncrunching
	STA	1
	.IMPORT	uncruncher
	JSR	uncruncher
	;STZ	53280
	;STZ	53281

	JMP	$5000

;	========================
.ENDPROC



.SEGMENT "GEOS"
.INCBIN "build/mega65/compressed.bin"
