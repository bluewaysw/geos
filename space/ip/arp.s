;**
;* @file arp.c
;* @brief Address Resolution Protocol implementation.
;* @compiler CPIK 0.7.3 / MCC18 3.36
;* @author Bruno Basseto (bruno@wise-ware.org)
;*/

.include "geosmac.inc"
.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"

;#include <stdio.h>

;#include "task.h"
;#include "weeip.h"
;#include "eth.h"

;#include "memory.h"
;#include "random.h"

.import eth_arp_send
.import ip_local
.import mac_local
.import _header
.import task_add

.export arp_query
.export query_cache
.export arp_init
.export arp_mens


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

;#include <string.h>
;#include "weeip.h"
;#include "eth.h"

;*
;* Opcodes.
;*/
ARP_REQUEST	=	$0100         	;// big-endian for 0x0001
ARP_REPLY 	=	$0200         	;// big-endian for 0x0002

;**
;* A known IP-MAC addresses pair.
;*/
;typedef struct {
;   IPV4 ip;                                  ///< IP address.
;   EUI48 mac;                                ///< Associated MAC address.
;   uint16_t time;                            ///< Time to expire.
;} ARP_CACHE_ENTRY;

ARP_CACHE_ENTRY_SIZE		=	12
ARP_CACHE_ENTRY_TIME_OFFSET	=	10

ARP_HDR_HARDWARE_OFFSET		=	0
ARP_HDR_PROTOCOL_OFFSET		=	2
ARP_HDR_HW_SIZE_OFFSET		=	4
ARP_HDR_PR_SIZE_OFFSET		=	5
ARP_HDR_OPCODE_OFFSET		=	6
ARP_HDR_ORIG_HW_OFFSET		=	8
ARP_HDR_ORIG_IP4_OFFSET		=	14
ARP_HDR_DEST_HW_OFFSET		=	18
ARP_HDR_DEST_IP4_OFFSET		=	24

MAX_CACHE    	=   	8              	;///< ARP Cache table size.

ARP_TICK_TIME	=	147            	;// about 10 seconds
MAX_TIMEOUT_ARP =	120            	;// about 20 minutes
MIN_TIMEOUT_ARP =	2              	;// about 20 seconds

arptickName:
	.byte	"arptick", 0


;**
;* List of known MAC addresses.
;*
arp_cache:
	.repeat	MAX_CACHE*ARP_CACHE_ENTRY_SIZE
		.byte	0
	.endrep

;#define ARP(X) _header.arp.X

;**
;* Search for an IP among the known ones.
;* Starts a new table entry if not found.
;* @param ip Address to look for.
;* @param mac Corresponding MAC address, if found.
;* @return TRUE if found.
;*
;---------------------------------------------------------------
; query_cache
; in:  r0/r1  IP address BY VALUE (r0L = first octet)
; out: carry set   = resolved, MAC in r3,r4,r5
;      carry clear = not resolved yet. A pending entry (MAC = $FF..)
;                    now exists for this IP; caller should arp_query.
; destroys: a, x, y, r2, r6, r7
;---------------------------------------------------------------
query_cache:
	;* Broadcast IP -> broadcast MAC
	ldx	#0
	lda	#$FF
@10:	cmp	r0, x
	bne	@noBroadcast
	inx
	cpx	#4
	bne	@10
	ldx	#5
@11:	sta	r3, x
	dex
	bpl	@11
	sec
	rts

@noBroadcast:
	jsr	find_entry		; r2 -> entry, carry set if found
	bcc	@notFound

	ldy	#4			; first MAC byte
	lda	(r2), y
	cmp	#$FF
	beq	@pending		; reserved, reply not in yet
	ldx	#0
@20:	lda	(r2), y
	sta	r3, x
	iny
	inx
	cpx	#6
	bne	@20
	sec
	rts
@pending:
	clc
	rts

@notFound:
	;* Reserve an entry holding the IP we are going to ask for,
	;* so the ARP reply can be matched to it.
	jsr	find_lru_slot		; r2 -> slot to reuse
	ldy	#0
@30:	lda	r0, y			; IP by value
	sta	(r2), y
	iny
	cpy	#4
	bne	@30
	lda	#$FF			; MAC unknown -> pending marker
@31:	sta	(r2), y
	iny
	cpy	#ARP_CACHE_ENTRY_TIME_OFFSET
	bne	@31
	lda	#<MIN_TIMEOUT_ARP
	sta	(r2), y
	iny
	lda	#>MIN_TIMEOUT_ARP
	sta	(r2), y
	clc
	rts

;---------------------------------------------------------------
; find_entry
; in:  r0/r1  IP by value
; out: carry set + r2 -> entry if found, carry clear otherwise
; destroys: a, x, y, r2
;---------------------------------------------------------------
find_entry:
	LoadW	r2, arp_cache
	ldx	#0
@loop:	ldy	#0
@cmp:	lda	(r2), y
	cmp	r0, y
	bne	@next
	iny
	cpy	#4
	bne	@cmp
	sec
	rts
@next:	AddVW	ARP_CACHE_ENTRY_SIZE, r2
	inx
	cpx	#MAX_CACHE
	bne	@loop
	clc
	rts

;---------------------------------------------------------------
; find_lru_slot - entry with the smallest time value
; (free slots have 0, pending MIN_TIMEOUT_ARP, resolved MAX_TIMEOUT_ARP)
; out: r2 -> slot
; destroys: a, x, y, r6, r7
;---------------------------------------------------------------
find_lru_slot:
	LoadW	r2, arp_cache
	MoveW	r2, r6			; best slot so far
	LoadW	r7, $FFFF		; best time so far
	ldx	#0
@loop:	ldy	#ARP_CACHE_ENTRY_TIME_OFFSET+1
	lda	(r2), y
	cmp	r7H
	bne	@cmpDone
	dey
	lda	(r2), y
	cmp	r7L
@cmpDone:
	bcs	@next			; time >= best, keep best
	MoveW	r2, r6
	ldy	#ARP_CACHE_ENTRY_TIME_OFFSET
	lda	(r2), y
	sta	r7L
	iny
	lda	(r2), y
	sta	r7H
@next:	AddVW	ARP_CACHE_ENTRY_SIZE, r2
	inx
	cpx	#MAX_CACHE
	bne	@loop
	MoveW	r6, r2
	rts

;---------------------------------------------------------------
; learn_sender - store sender IP/MAC of the ARP packet in _header
; in:  carry set   = insert if not cached (request addressed to us)
;      carry clear = only update an existing entry (reply), so
;                    unrelated ARP traffic can't evict our entries
; destroys: a, x, y, r0, r1, r2, r6, r7
;---------------------------------------------------------------
learn_sender:
	php
	MoveW	_header+ARP_HDR_ORIG_IP4_OFFSET, r0
	MoveW	_header+ARP_HDR_ORIG_IP4_OFFSET+2, r1
	lda	r0L			; ignore 0.0.0.0 (ARP probes)
	ora	r0H
	ora	r1L
	ora	r1H
	bne	@valid
	plp
	rts
@valid:
	jsr	find_entry
	bcs	@found
	plp
	bcs	@insert
	rts				; reply for an IP we never asked for
@insert:
	jsr	find_lru_slot
	ldy	#0
@ip:	lda	r0, y
	sta	(r2), y
	iny
	cpy	#4
	bne	@ip
	bra	@setMac
@found:
	plp
@setMac:
	ldy	#4
	ldx	#0
@mac:	lda	_header+ARP_HDR_ORIG_HW_OFFSET, x
	sta	(r2), y
	iny
	inx
	cpx	#6
	bne	@mac
	lda	#<MAX_TIMEOUT_ARP
	sta	(r2), y
	iny
	lda	#>MAX_TIMEOUT_ARP
	sta	(r2), y
	rts

arp_query:
	;*
	;* ARP REQUEST message.
	;*
	LoadW	_header+ARP_HDR_HARDWARE_OFFSET, $0100
					; // ethernet (big-endian for 0x0001)
	LoadW	_header+ARP_HDR_PROTOCOL_OFFSET, $0008
					; // internet protocol (big-endian for 0x0800)
	LoadB	_header+ARP_HDR_HW_SIZE_OFFSET, 6
					; // 6 bytes for ethernet MAC
	LoadB	_header+ARP_HDR_PR_SIZE_OFFSET, 4
					; // 4 bytes for IPv4
	LoadW	_header+ARP_HDR_OPCODE_OFFSET, ARP_REQUEST

	;*
	;* Local addresses for the Sender.
	;*
	ldx	#0
@10:
	lda	mac_local, x
	sta	_header+ARP_HDR_ORIG_HW_OFFSET,x
	inx
	cpx	#6
	bne	@10

	ldx	#0
@11:
	lda	ip_local, x
	sta	_header+ARP_HDR_ORIG_IP4_OFFSET,x
	inx
	cpx	#4
	bne	@11

	;*
	;* Destination addresses.
	;*
	ldx	#0
	ldy	#0
@20:
	lda	r0, y
	sta	_header+ARP_HDR_DEST_IP4_OFFSET,x
	inx
	iny
	cpy	#4
	bne	@20

	jsr	i_FillRam
	.word	6		; sizeof(EUI48)
	.word	_header+ARP_HDR_DEST_HW_OFFSET
	.byte	$FF
				;// what we want to know

	;*
	;* Send message.
	;*
	LoadW	r1, _header+ARP_HDR_DEST_HW_OFFSET
   	jsr	eth_arp_send

	rts


;**
;* Process an incoming ARP message.
;*
arp_mens:
	;* Check opcode.
	;*
	;*/
	MoveW	_header+ARP_HDR_OPCODE_OFFSET, r0
	CmpWI	r0, ARP_REQUEST
	beq	@19
	jmp	@10
@19:
	;*
	;* Address request.
	;* Check local address.
	;*
	LoadW	r0, ip_local
	LoadW	r1, _header+ARP_HDR_DEST_IP4_OFFSET
	ldy	#0
@11:
	lda	(r0),y
	cmp	(r1),y
	beq	@18
	jmp	@done
@18:
	iny
	cpy	#4
	bne	@11

	;*
	;* Looking for us.
	;* Insert sender address into cache.
	;*
	sec			; insert if not yet cached
	jsr	learn_sender

	;*
	;* Assemble a response message.
	;*
	LoadW	_header+ARP_HDR_HARDWARE_OFFSET, $0100
					;// ethernet (big-endian for 0x0001)
	LoadW	_header+ARP_HDR_PROTOCOL_OFFSET, $0008
					;// internet protocol (big-endian for 0x0800)
	LoadB	_header+ARP_HDR_HW_SIZE_OFFSET, 6
					;// 6 bytes for ethernet MAC
	LoadB	_header+ARP_HDR_PR_SIZE_OFFSET, 4
					;// 4 bytes for IPv4
	LoadW	_header+ARP_HDR_OPCODE_OFFSET, ARP_REPLY

	;*
	;* Swap addresses.
	;*
	ldx	#0
@30:
	lda	_header+ARP_HDR_DEST_HW_OFFSET, x
	tay
	lda	_header+ARP_HDR_ORIG_HW_OFFSET,x
	sta	_header+ARP_HDR_DEST_HW_OFFSET, x
	tya
	sta	_header+ARP_HDR_ORIG_HW_OFFSET, x
	inx
	cpx	#6
	bne	@30

	ldx	#0
@31:
	lda	_header+ARP_HDR_DEST_IP4_OFFSET, x
	tay
	lda	_header+ARP_HDR_ORIG_IP4_OFFSET,x
	sta	_header+ARP_HDR_DEST_IP4_OFFSET, x
	tya
	sta	_header+ARP_HDR_ORIG_IP4_OFFSET, x
	inx
	cpx	#4
	bne	@31

	;*
	;* Local addresses as Sender.
	;*
	ldx	#0
@32:
	lda	mac_local, x
	sta	_header+ARP_HDR_ORIG_HW_OFFSET,x
	inx
	cpx	#6
	bne	@32

	ldx	#0
@33:
	lda	ip_local, x
	sta	_header+ARP_HDR_ORIG_IP4_OFFSET,x
	inx
	cpx	#4
	bne	@33

	;*
	;* Send answer.
	;*
	LoadW	r1, _header+ARP_HDR_DEST_HW_OFFSET
	jsr	eth_arp_send
@done:
	rts

@10:
	CmpWI	r0, ARP_REPLY
	bne	@done

	;*
	;* ARP response.
	;*
	clc			; only update entries we asked for
	jsr	learn_sender
	rts

;**
;* ARP timing control task.
;* Called each 10 seconds.
;*
; destoryed: r0
arp_tick:
rts
	LoadW	r0, arp_cache
	ldx	#0
@10:
	ldy	#ARP_CACHE_ENTRY_TIME_OFFSET
	lda	(r0), y
	bne	@11
	iny
	lda	(r0), y
	bne	@11

	; handle outdated entry here, time is already 0
	ldy	#0
	lda	#$FF
@12:
	sta	(r0), y
	iny
	cpy	#10
	bne	@12
@11:
	AddVW	ARP_CACHE_ENTRY_SIZE, r0
	inx
	cpx	#MAX_CACHE
	bne	@10

	;*
	;* Reschedule for periodic execution.
	;*
	LoadW	r0, arp_tick
	LoadB	r1L, ARP_TICK_TIME
	LoadB	r1H, 0
	LoadW	r2, arptickName
	jsr	task_add
	rts

;**
;* ARP setup and startup.
;*/
; destroy: a, x, y, r0, r1, r2
arp_init:
	jsr	i_FillRam
	.word	MAX_CACHE*ARP_CACHE_ENTRY_SIZE
	.word	arp_cache
	.byte	$FF

	LoadW	r0, arp_cache
	ldx	#0
@10:
	ldy	#ARP_CACHE_ENTRY_TIME_OFFSET
	lda	#0
	sta	(r0), y
	iny
	sta	(r0), y

	AddVW	ARP_CACHE_ENTRY_SIZE, r0
	inx
	cpx	#MAX_CACHE
	bne	@10

	; tick is applied from the outside
	LoadW	r0, arp_tick
	LoadB	r1L, ARP_TICK_TIME
	LoadB	r1H, 0
	LoadW	r2, arptickName
	jsr	task_add
	rts
