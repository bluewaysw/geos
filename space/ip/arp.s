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
; in:	r0/r1 ip address
; out: c set if resolved, c if new entry has been reserved
;	r3,r4,r5 mac
query_cache:
	;ARP_CACHE_ENTRY *i, *s;
	;byte_t old;

	;*
	;* Checks if broadcast address.
	;*
	ldx	#0
@10:
	lda	r0, x
	cmp	#$ff
	bne	@noBroadcast
	inx
	cpx	#4
	bne	@10

	ldx	#0
@20:
	sta	r3,x
	inx
	cpx	#6
	bne	@20
	sec
	rts

@noBroadcast:
	;*
	;* Loops into arp_cache.
	;*/
	ldx	#0
	LoadW	r3, arp_cache
@30:
	ldy	#0
@32:
	lda	(r3), y
	cmp	r0, y
	bne	@31
	iny
	cpy	#4
	bne	@32

	; found ip address in cache
	lda	(r3), y
	cmp	#$FF
	bne	@33
	clc
	rts
@33:
	ldy	#0
	AddVW	4, r3
	MoveW	r3, r2
@34:
	lda	(r2), y
	sta	r3, y
	iny
	cpy	#6
	bne	@34
.if 0
	 printf("IP %d.%d.%d.%d is in ARP cache\n",
		ip->b[0],ip->b[1],ip->b[2],ip->b[3]);
.endif
	sec			; found successfully
	rts

@31:
	AddVW	ARP_CACHE_ENTRY_SIZE, r3

	inx
	cpx	#MAX_CACHE
	bne	@30
.if 0
	printf("IP %d.%d.%d.%d not in ARP cache\n",
				ip->b[0],ip->b[1],ip->b[2],ip->b[3]);
.endif

	;*
	;* Unknown IP.
	;* Look for an empty entry.
	;*/
	LoadW	r5, $FF
	ldx	#0
	LoadW	r3, arp_cache
	MoveW	r3, r6
@40:
	ldy	#ARP_CACHE_ENTRY_TIME_OFFSET
	lda	(r3),y
	sta	r4L
	iny
	lda	(r3),y
	sta	r4H

	CmpW	r4, r5
	bcs	@41

	;brk
	;lda	#$39

	MoveW	r3, r6		; remember this cache entry
	MoveW	r4, r5		; remember this time out
@41:
	CmpWI	r5, 0
	beq	@found
		;*
	 	;* Done: found an empty entry.
	 	;*/

	AddVW	ARP_CACHE_ENTRY_SIZE, r3
	inx
	cpx	#MAX_CACHE
	bne	@40
   	; use the oldest one

@found:
	; r6 points to cache entry to be filled

	;*
	;* Init the entry with the desired IP.
	;*
	ldy	#0
@51:
	lda	(r0),y
	sta	(r6),y
	iny
	cpy	#4
	bne	@51
	AddVW	4, r6

	ldy	#0
@52:
	lda	(r1),y
	sta	(r6),y
	iny
	cpy	#6
	bne	@52
	AddVW	6, r6

	ldy	#0
	lda	#<MIN_TIMEOUT_ARP
	sta	(r6), y
	iny
	lda	#>MIN_TIMEOUT_ARP
	sta	(r6), y

	clc
	rts

;**
;* Update IP information into the ARP cache.
;* @param ip IP Address, must already be into the cache.
;* @param mac MAC address to update.
;*/
; in:	r0 ptr to IPV4
;       r1 ptr to MAC
; destroy: r2, r3, r6, r7, r8
update_cache:
.if 0
	printf("ARP: IP %d.%d.%d.%d is at %x:%x:%x:%x:%x:%x\n",
		ip->b[0],ip->b[1],ip->b[2],ip->b[3],
		mac->b[0],mac->b[1],mac->b[2],mac->b[3],mac->b[4],mac->b[5]
		);
.endif

	LoadW	r2, arp_cache
	ldx	#0
@10:
	; compare ip
	ldy	#0
@12:
	lda	(r0), y
	cmp	(r2), y
	bne	@11
	iny
	cpy	#4
	bne	@12

	; entry found
	jmp	@set
@11:
	AddVW	ARP_CACHE_ENTRY_SIZE, r2
	inx
	cpx	#MAX_CACHE
	bne	@10

	;// Not an existing entry in the cache to be updated, so replace a random entry?
	jsr	GetRandom

	PushW	r3
	PushW	r6
	PushW	r7
	PushW	r8

	MoveW	random, r6
	LoadW	r7, MAX_CACHE
	ldx	#r6
	ldy	#r7
	jsr	Ddiv

	; r8 rest
	MoveW	r8, r2
	ldx	#r2
	LoadW	r3, ARP_CACHE_ENTRY_SIZE
	ldy	#r3
	jsr 	DMult

	LoadW	r6, arp_cache
	AddW	r6, r2
	PopW	r8
	PopW	r7
	PopW	r6
	PopW	r3
@setAll:

	; set ip
	ldy	#0
@21:
	lda	(r0), y
	sta	(r2), y
	iny
	cpy	#4
	bne	@21

@set:
	; set mac
	AddVW	4, r2
	ldy	#0
@20:
	lda	(r1), y
	sta	(r2), y
	iny
	cpy	#6
	bne	@20

	; set timeout
	lda	#<MAX_TIMEOUT_ARP
	sta	(r2),y
	lda	#>MAX_TIMEOUT_ARP
	iny
	sta	(r2),y

	rts

;**
;* Send a ARP QUERY message to find about an IP address.
;* @param IP address to find.
;*/
; in: r1 ptr to ip
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
	LoadW	r0, _header+ARP_HDR_ORIG_IP4_OFFSET
	LoadW	r1, 0	; don't exepect to receive result

	jsr	query_cache	; ensure entry exists, create in free
				; slot if possible

	LoadW	r1, _header+ARP_HDR_ORIG_HW_OFFSET
	jsr	update_cache

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
	LoadW	r0, _header+ARP_HDR_ORIG_IP4_OFFSET
	LoadW	r1, _header+ARP_HDR_ORIG_HW_OFFSET
	jsr	update_cache
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
