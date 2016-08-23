; A 65CE02/4502 capable version of CA65 would be great

; Set 65C02, it's quite "similar" to 65C02, not including though
; the (ZP),Z addressing mode instead of (ZP), missing Z register
; and some new opcodes. Here, we only define some simple macros
; to be used by my source, that's all.
.SETCPU "65C02"
.MACRO TAZ
	.BYTE	$4B
.ENDMAC
.MACRO MAP
	.BYTE	$5C
.ENDMAC
.MACRO TAB
	.BYTE	$5B
.ENDMAC
.MACRO TYS
	.BYTE	$2B
.ENDMAC
.MACRO SEE
	.BYTE	$03
.ENDMAC
.MACRO EOM
	NOP
.ENDMAC
