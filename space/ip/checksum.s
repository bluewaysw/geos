;**
;* @file checksum.c
;* @brief Helper functions for calculating IP checksums.
;* @compiler CPIK 0.7.3 / MCC18 3.36
;* @author Bruno Basseto (bruno@wise-ware.org)
;*/

;********************************************************************************
;********************************************************************************
;* The MIT License (MIT)
;*
;* Copyright (c) 1995-2013 Bruno Basseto (bruno@wise-ware.org).
;*
;* Permission is hereby granted, free of charge, to any person obtaining a copy
;* of this software and associated documentation files (the "Software"), to deal
;* in the Software without restriction, including without limitation the rights
;* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;* copies of the Software, and to permit persons to whom the Software is
;* furnished to do so, subject to the following conditions:
;*
;* The above copyright notice and this permission notice shall be included in
;* all copies or substantial portions of the Software.
;*
;* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;* THE SOFTWARE.
;********************************************************************************
;********************************************************************************/

;#include "task.h"
;#include "checksum.h"

.include "geosmac.inc"
.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"


.export chks
.export ip_checksum
.export add_checksum

;**
;* Last checksum computation result.
;*/
;chks_t chks;
chks:
	.word	0

_a:	.byte	0
_b:	.byte	0
_c:	.byte	0
_b16:	.word	0


;**
;* Sums a 16-bit word to the current checksum value.
;* Optimized for 8-bit word processors.
;* The result is found in chks.
;* @param v Value to sum.
;*/
; in: r0 - word
add_checksum:
	;*
	;* First byte (MSB).
	;*
	MoveB	chks, _a

	MoveB	_a, _b16
	LoadB	_b16+1, 0
	LoadB	r1H, 0
	MoveB	r0H, r1L
	AddW	r1, _b16
	MoveB	_b16, _b
	MoveB	_b16+1, _c

	MoveB	_b, chks

	;*
	;* Second byte (LSB).
	;*/
	MoveB	chks+1, _a
	MoveB	_a, _b16
	LoadB	_b16+1, 0
	LoadB	r1H, 0
	MoveB	r0L, r1L
	AddW	r1, _b16
	MoveB	_c, r1L
	AddW	r1, _b16
	MoveB	_b16, _b
	MoveB	_b16+1, _c

	MoveB	_b, chks+1

	;*
	;* Test for carry.
	;*
	lda	_c
	beq	@10

	inc	chks
	bne	@10
	inc	chks+1
@10:
	rts

;**
;* Calculate checksum for a memory area (must be word-aligned).
;* Pad a zero byte, if the size is odd.
;* Optimized for 8-bit word processors.
;* The result is found in chks.
;* @param p Pointer to a memory buffer.
;* @param t Data size in bytes.
;*/
; in: r0 - buffer address, r1 - buffer size
ip_checksum:
	LoadB	_c, 0

@loop:
	CmpWI	r1, 0
	bne	@11
	jmp	@10
@11:
	;*
	;* First byte (do not care if LSB or not).
	;*/
	MoveB	chks, _a

	LoadB	_b16+1, 0
	MoveB	_a, _b16

	LoadB	r2H, 0
	MoveB	_c, r2L
	AddW	r2, _b16
	ldy	#0
	lda	(r0), y
	sta	r2L
	IncW	r0
	AddW	r2, _b16
	MoveB	_b16, _b
	MoveB	_b16+1, _c

	MoveB	_b, chks
	DecW	r1

	CmpWI	r1, 0
	bne	@20
	;*
	;* Pad a zero. Just test the carry.
	;*/

	CmpBI	_c, 0
	beq	@30
	inc	chks+1
	lda	chks+1
	cmp	#0
	bne	@30

	inc	chks
@30:
	bra	@done
@20:
	;*
	;* Second byte (do not care if MSB or not).
	;*/
	MoveB	chks+1, _a

	MoveB	_a, _b16
	LoadB	_b16+1, 0

	MoveB	_c, r2L
	LoadB	r2H, 0
	AddW	r2, _b16

	ldy	#0
	lda	(r0), y
	sta	r2L
	IncW	r0
	AddW	r2, _b16
	MoveB	_b16, _b
	MoveB	_b16+1, _c
	MoveB	_b, chks+1

	DecW	r1
	jmp	@loop
@10:
	;*
	;* Test the carry.
	;*/
	CmpBI	_c, 0
	beq	@done
	inc	chks
	CmpBI	chks, 0
	bne	@done
	inc	chks+1
@done:
	rts
