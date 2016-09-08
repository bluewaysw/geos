; C65 specific stuffs, already int he combined kernal image, not the loader!
; (C)2016 LGB Gábor Lénárt

.include "config.inc"

.if (c65)

.segment "c65start"
.include "c65.inc"
; Note: we can't use const.inc here, as would conflict ie with MAP constant
; with the MAP opcode defined in c65.inc ...
.import _ResetHandle
.import __c65start_LOAD__
.import __c65start_SIZE__
.export InitC65

; Relocated to $100 (well, there is place in stack ...) and executed
; there. The reason for this is commented in InitC65
.PROC	relocated_segment_nullifier
	sta	__c65start_LOAD__,x
	inx
	bne	relocated_segment_nullifier
	inc	$102		; self-mod of the first STA arg
	dey
	bne	relocated_segment_nullifier
	jmp	_ResetHandle	; call the original stuff (at $5000)
.ENDPROC


.PROC InitC65
	; We don't do MAP, LDZ #0, stack/BP setup etc here, already done in the "BASIC stub" loader, in c65/loader.s
	sei
	cld
	ldx	#$FF
	txs
	; Patch out the call for this func.
	; It needs to be able to work with the trap=1 setting, it seems.
	; The same for "relocated_segment_nullifier" stuff at the end
	lda	#$78	; sei
	sta	_ResetHandle
	lda	#$D8	; cld
	sta	_ResetHandle+1
	lda	#$A2	; ldx immed.
	sta	_ResetHandle+2
	; We need I/O
        LDA     #$35
        STA     1
        ; Various VIC register stuffs
        LDA	#$A5	; 2 values sequence for enabling "newVic" I/O mode (that is, C65 I/O, for M65, another seq is needed)
        STA	$D02F
        LDA	#$96
        STA	$D02F
        LDA	#64
        STA	$D031	; turn maybe used enhanched VIC3 capabilities OFF (other than FAST mode!)
        STZ	$D030	; turn ROM mappings / etc OFF
        STZ	$D019	; disable VIC interrupts
        STZ	$D01A
        LDA	#$15
        STA	$D018
	; give up newVic mode
	; that is for GEOS may touch new I/O regs (expecting for VIC-2 "echoes" etc) and screws up ...
	; I'm not sure if this is needed, try to remove it.
	; if someone wants to use C65 feature, than it's another question
	STA	$D02F
	; Clear our "c65start" segment with the relocated code to $100 and then jump to
	; the original stuff there.
to_geos:
	ldx	#0
@cp:
	lda	relocated_segment_nullifier,x
	sta	$100,x
	inx
	bpl	@cp	; 128 bytes should be enough for everyone.
	ldx	#0
	txa
	ldy	#.HIBYTE(__c65start_SIZE__) + 1
	EOM	; well just to be sure, a previous MAP does not cause problem with disabled interrupts ...
	jmp	$100
.ENDPROC

.endif
