;**
;* @file nwk.c
;* @brief Network and Transport layers.
;* @compiler CC65
;* @author Paul Gardner-Stephen (paul@m-e-g-a.org)
;* derived from:
;* @author Bruno Basseto (bruno@wise-ware.org)
;*

.include "geosmac.inc"
.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"

.include "defs.inc"
;#include <stdio.h>

;#include "memory.h"
;#include "debug.h"

;// On MEGA65 we have deep enough stack we don't need to schedule sending
;// ACKs, we can just send them immediately.
;// #define INSTANT_ACK
;// Report various things on serial monitor interface
;// #define DEBUG_ACK

;// Enable ICMP PING if desired.
;//#define ENABLE_ICMP


;*
;  Use a graduated timeout that starts out fast, and then slows down,
;  so that we spread our timeouts over a longer preiod of time, but
;  at the same time, we don't wait forever for initial retries on a
;  local LAN
;*/
;#define SOCKET_TIMEOUT(S) (TIMEOUT_TCP + 32*(RETRIES_TCP - S->retry))
;//#define DEBUG_TCP_RETRIES
socket_timeout:
	lda	#RETRIES_TCP
	sec
	ldy	#SOCKET_RETRY_OFFSET
	sec
	sbc	(r8), y

	asl
	asl
	asl
	asl
	asl

	clc
	adc	#TIMEOUT_TCP
	rts

;#define SOCKET_TIMEOUT(S) (TIMEOUT_TCP + 32*(RETRIES_TCP - S->retry))

;*
;* Values for protocol field.
;*
IP_PROTO_TCP    =	6      	;///< TCP packet.
IP_PROTO_UDP    =	17     	;///< UDP packet.
IP_PROTO_ICMP	=	1      	;///< ICMP packet.


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
;#include "checksum.h"
;#include "eth.h"
;#include "arp.h"

;#include "memory.h"

.import	_sockets
.import ip_checksum

.import	dmalist_source_mb
.import	dmalist_source_bank
.import	dmalist_source_addr
.import	dmalist_dest_mb
.import	dmalist_dest_bank
.import	dmalist_dest_addr
.import	dmalist_count

.import	chks
.import ip_checksum
.import checksum_init
.import add_checksum

.import eth_packet_send
.import eth_ip_send
.import eth_write
.import eth_clear_to_send

.import	do_dma
.import task_add
.import task_cancel


.export _header
.export ip_local
.export nwk_downstream
.export id
.export ip_broadcast
.export nwk_upstream
.export nwk_tick
.export upstreamName
.export nwktickName


;**
;* Message header buffer.
;*
_header:
	.repeat	40
		.byte	0
	.endrep

ip_broadcast:                  ;///< Subnetwork broadcast address
	.repeat	4
		.byte	0
	.endrep

data_size:
	.word 	0
data_ofs:
	.word	0
seq:
	.dword	0

;#define TCPH(X) _header.t.tcp.X
;#define ICMPH(X) _header.t.icmp.X
;#define UDPH(X) _header.t.udp.X
;#define IPH(X) _header.ip.X


upstreamName:
	.byte	"upstream", NULL
nwktickName:
	.byte	"nwktick", NULL


ETH_RX_BUFFER 	= 	$FFDE800

;// Smaller MTU to save memory
MTU = 1000
;extern unsigned char tx_frame_buf[MTU];
;extern unsigned short eth_tx_len;

;**
;* Packet counter.
;*/
id:
	.word	0
;**
;* Local IP address.
;*/
ip_local:
	.byte	0, 0, 0, 0
;**
;* Default header.
;*/
WINDOW_SIZE_OFFSET 	=	34
default_header:
	.byte	$45, $08, $00, $28, $00, $00, $00, $00, $40, $06
	.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte	$00, $00, $50, $00
	;// TCP Window size
	.byte	$06, $00 	;// ~1.5KB by default
	.byte	$00, $00, $00, $00


;**
;* Flags received within last packet.
;*
_flags:
	.byte	0

;**
;* TCP timing control task.
;* Called periodically at a rate defined by TICK_TCP.
;*/
nwk_tick:			; (byte_t sig)
	rts
	;static byte_t t=0;

	;*
	;* Loop all sockets.
	;*/

	ldx	#0
	LoadW	r8, _sockets
@processSocket:
	ldy	#0
	lda	(r8), y
	cmp	#SOCKET_TCP
	beq	@processTCP
	jmp	@nextSocket
			;// UDP socket or unused.
@processTCP:
	;//      if(_sckt->time == 0) continue;
			;// does not have timing requirements.

	;*
	;* Do socket timing.
	;*
	ldy	#SOCKET_TIME_OFFSET
	lda	(r8),y
	beq	@10
	dec
	sta	(r8), y

@10:
	beq	@processTimeout
	jmp	@noTimeout

@processTimeout:
	;*
	;* Timeout.
	;* Check retransmissions.
	;*/

	ldy	#SOCKET_RETRY_OFFSET
	lda	(r8), y
	bne	@doRetry
	jmp	@noRetry
@doRetry:

.ifdef DEBUG_TCP_RETRIES
	printf("tcp retry %d\n",_sckt->retry);
.endif
	ldy	#SOCKET_RETRY_OFFSET
	lda	(r8), y
	dec
	sta	(r8), y

	jsr	socket_timeout
	ldy	#SOCKET_TIME_OFFSET
	sta	(r8), y

	ldy	#SOCKET_STATE_OFFSET
	lda	(r8), y

	cmp	#_SYN_SENT
	beq	@201
	cmp	#_ACK_REC
	bne	@200
@201:
	lda	#SYN
	ldy	#SOCKET_TO_SEND_OFFSET
	sta	(r8), y
	bra	@290
@200:
	cmp	#_SYN_REC
	bne	@202
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#SYN|ACK
	sta	(r8), y
	bra	@290
@202:
	cmp	#_ACK_WAIT
	bne	@203

	ldy	#SOCKET_TO_SEND_OFFSET
	lda	# ACK | PSH
	sta	(r8), y
@203:
bra	@290
	cmp	#_FIN_SENT
	beq	@205
	cmp	#_FIN_ACK_REC
	bne	@204
@205:
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	# ACK
	sta	(r8), y
.ifdef DEBUG_ACK
	debug_msg("Asserting ACK: _FIN_ACK_REC state");
.endif
	bra	@290
@204:
	cmp	#_FIN_REC
	bne	@206
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	# FIN|ACK
	sta	(r8), y
.ifdef DEBUG_ACK
	debug_msg("Asserting ACK: _FIN_REC state");
.endif
	bra	@290
@206:
	jsr	socket_timeout
	ldy	#SOCKET_TIME_OFFSET
	sta	(r8), y
	ldy	#SOCKET_TIMEOUT_OFFSET
	lda	#0
	sta	(r8), y
@290:
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	(r8), y
	beq	@207
	;*
	;* Force nwk_upstream() to execute.
	;*
	ldy	#SOCKET_TIMEOUT_OFFSET
	lda	#$FF
	sta	(r8), y
.ifdef INSTANT_ACK
	jsr	nwk_upstream
.endif
.ifdef DEBUG_ACK
	debug_msg("scheduling nwk_upstream 0 0");
.endif
	LoadW	r0, nwk_upstream
	jsr	task_cancel
	LoadB	r1L, 0
	LoadB	r1H, 0
	LoadW	r2, upstreamName
	jsr	task_add
@207:
	bra	@noTimeout

@noRetry:
	;*
	;* Too much retransmissions.
	;* Socket down
	;*
	ldy	#SOCKET_STATE_OFFSET
	lda	#_IDLE
	sta	(r8), y

	ldy	#SOCKET_CALLBACK_OFFSET
	lda	(r8), y
	sta	r7L
	iny
	lda	(r8), y
	sta	r7H
	iny

	lda	#WEEIP_EV_DISCONNECT
	jsr	(r7)

	jsr    	remove_rx_data

@noTimeout:

@nextSocket:
	AddVW	SOCKET_SIZE, r8
	inx
	cmp	#MAX_SOCKET
	beq	@noNextSocket
	jmp	@processSocket

@noNextSocket:
	;*
	;* Reschedule task for periodic execution.
	;*
	; periodicly done by integration
	LoadW	r0, nwk_tick
	LoadB	r1L, TICK_TCP
	LoadB	r1H, 0
	LoadW	r2, nwktickName
	jsr	task_add
	rts

; in: r8 socket ptr
remove_rx_data:
	ldy	#SOCKET_RX_DATA_OFFSET
	lda	(r8),y
	iny
	ora	(r8),y

	bne	@run
	jmp	@done
@run:
	ldy	#SOCKET_RX_OO_START_OFFSET
	lda	(r8), y
	iny
	ora	(r8), y
	bne	@301
	jmp	@300
@301:
	ldy	#SOCKET_RX_OFFSET
	lda	(r8), y
	sta	r5L
	iny
	lda	(r8), y
	sta	r5H

	ldy	#SOCKET_RX_DATA_OFFSET
	lda	(r8), y
	sta	r4L
	iny
	lda	(r8), y
	sta	r4H

	; setup dmalist to receive from ETH_RX_BUFFER
	LoadB	dmalist_source_mb, 0
	LoadB	dmalist_source_bank, 0
	MoveW	r5, dmalist_source_addr
	AddW	dmalist_source_addr, r4

	LoadB  	dmalist_dest_mb, 0	; fetching into bank 0
	LoadB	dmalist_dest_bank, 0
	MoveW	r5, dmalist_dest_addr

	ldy	#SOCKET_RX_OO_END_OFFSET
	lda	(r8), y
	sta	dmalist_count
	iny
	lda	(r8), y
	sta	dmalist_count+1
	SubW	dmalist_count, r4

	jsr	do_dma

	ldy	#SOCKET_RX_OO_START_OFFSET
	sec
	lda	(r8), y
	sbc	r4L
	sta	(r8), y
	iny
	lda	(r8), y
	sbc	r4H
	sta	(r8), y

	ldy	#SOCKET_RX_OO_END_OFFSET
	sec
	lda	(r8), y
	sbc	r4L
	sta	(r8), y
	iny
	lda	(r8), y
	sbc	r4H
	sta	(r8), y
@300:
  	ldy	#SOCKET_RX_DATA_OFFSET
	lda	#0
	sta	(r8), y
	iny
	sta	(r8), y
@done:
	rts

; in: r8 socket ptr
; destroy: r6, r7
compute_window_size:

	;unsigned short available_window=0;
	LoadW	r7, 0

	;// Now patch the header to take account of how much buffer space we _actually_ have available
	ldy	#SOCKET_RX_DATA_OFFSET
	lda	(r8), y
	sta	r6L
	iny
	lda	(r8), y
	sta	r6
	CmpW	r6, r7
	bcc	@10
	MoveW	r6, r7
@10:
	ldy	#SOCKET_RX_OO_END_OFFSET
	lda	(r8), y
	sta	r6L
	iny
	lda	(r8), y
	sta	r6
	CmpW	r6, r7
	bcc	@11
	MoveW	r6, r7
@11:
	ldy	#SOCKET_RX_SIZE_OFFSET
	lda	(r8),y
	sta	r6L
	iny
	lda	(r8),y
	sta	r6H
	SubW	r6, r7

	MoveB	r6H, default_header+WINDOW_SIZE_OFFSET+0
	MoveB	r6L, default_header+WINDOW_SIZE_OFFSET+1
	rts

;**
;* Network upstream task. Send outgoing network messages.
;*/
nwk_upstream:		; (byte_t sig)

.ifdef DEBUG_ACK
	debug_msg("nwk_upstream called.");
.endif
	PushW	r0
	PushW	r1
	PushW	r2
	PushW	r3
	PushW	r4
	PushW	r5
	PushW	r6
	PushW	r7
	PushW	r8
	PushW	r9

	jsr	eth_clear_to_send
	bcs	@ready

	;*
	;* Ethernet not ready.
	;* Delay task execution.
	;*
	;//     printf("ETH TX wait\n");
.ifdef DEBUG_ACK
	debug_msg("scheduling nwk_upstream 2 0");
.endif
	LoadW	r0, nwk_upstream
	LoadB	r1L, 2
	LoadB	r1H, 0
	LoadW	r2, upstreamName
	jsr	task_add
	jmp	@done
@ready:
	;*
	;* Search for pending messages.
	;*

	LoadW	r8, _sockets
	ldx	#0

@processSocket:
	stx	r9L

	ldy	#SOCKET_TO_SEND_OFFSET
	lda	(r8), y
	bne	@10
	jmp	@nextSocket
			;// no message to send for this socket.
@10:
.ifdef DEBUG_ACK
	debug_msg("nwk_upstream sending a packet for socket");
.endif

	;*
	;* Pending message found, send it.
	;*
	;jsr	checksum_init
	LoadW	chks, 0

	jsr	compute_window_size

	;// XXX Correct buffer offset processing to handle variable
	;// header lengths
	LoadB	dmalist_source_mb, 0
	LoadB	dmalist_source_bank, 0
	LoadW	dmalist_source_addr, default_header

	LoadB  	dmalist_dest_mb, 0	; fetching into bank 0
	LoadB	dmalist_dest_bank, 0
	LoadW	dmalist_dest_addr, _header
	LoadW	dmalist_count, 40

	jsr	do_dma

	MoveB	id, _header+IP_HDR_ID+1;
	MoveB	id+1, _header+IP_HDR_ID;
	IncW	id

	ldx	#0
	ldy	#SOCKET_REMIP_OFFSET
@50:
	lda	ip_local, x
	sta	_header+IP_HDR_SOURCE_OFFSET, x
	lda	(r8), y
	sta	_header+IP_HDR_DEST_OFFSET, x
	iny
	inx
	cpx	#4
	bne	@50

	ldx	#0
	ldy	#SOCKET_PORT_OFFSET
@51:
	lda	(r8), y
	sta	_header+TCP_HDR_SOURCE_OFFSET,x
	inx
	iny
	cpx	#2
	bne	@51

	ldx	#0
	ldy	#SOCKET_REMPORT_OFFSET
@52:
	lda	(r8), y
	sta	_header+TCP_HDR_DEST_OFFSET,x
	inx
	iny
	cpx	#2
	bne	@52

	;*
	;* Check payload area in _sckt->tx.
	;*
	LoadW	data_size, 0		; data_size
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	(r8), y
	and	#PSH
	beq	@60

	ldy	#SOCKET_TX_SIZE_OFFSET
	lda	(r8), y
	sta	r1L
	sta	data_size
	iny
	lda	(r8), y
	sta	r1H
	sta	data_size+1

	ldy	#SOCKET_TX_OFFSET
	lda	(r8), y
	sta	r0L
	iny
	lda	(r8), y
	sta	r0H

	jsr	ip_checksum
@60:
	ldy	#SOCKET_TYPE_OFFSET
	lda	(r8), y
	cmp	#SOCKET_TCP
	beq	@handleTCP
	jmp	@handleUDP
@handleTCP:

	;*
	;* TCP message header.
	;*
	MoveW	data_size, r4
	AddVW	40, r4
	lda	r4L
	sta	_header+IP_HDR_LENGTH_OFFSET+1
	lda	r4H
	sta	_header+IP_HDR_LENGTH_OFFSET

	 ldy	#SOCKET_TO_SEND_OFFSET
	 lda	(r8),y
	 sta 	_header+TCP_HDR_FLAGS

	 ;*
	 ;* Check sequence numbers.
	 ;*
	 ldy	#SOCKET_SEQ_OFFSET_DW
	 lda	(r8), y
	 sta	seq
	 iny
	 lda	(r8), y
	 sta	seq+1
	 iny
	 lda	(r8), y
	 sta	seq+2
	 iny
	 lda	(r8), y
	 sta	seq+3
	 iny

	 ldy	#SOCKET_TIMEOUT_OFFSET
	 lda	(r8), y
	 beq	@noTimeout

	 brk
	 lda	#$89

	 ;*
	 ;* Retransmission.
	 ;* Use old sequence number.
	 ;*
	 lda	data_size
	 ora	data_size+1
	 beq	@61
	 SubW	seq, data_size
@61:
	;// XXX Why on earth do we subtract one here?
	;// This messes up connections sometimes, because
	;// we SYN, get SYN+ACK, and have sent a 2nd SYN
	;// again before we read the SYN+ACK. But in the process
	;// we have of course decremented the sequence number
	;// by one, so the other side gets VERY confused, and says
	;// RST!
	;//            if(_sckt->toSend & (SYN | FIN)) seq.d--;
@noTimeout:
	MoveB	seq+3, _header+TCP_HDR_N_SEQ_OFFSET
	MoveB	seq+2, _header+TCP_HDR_N_SEQ_OFFSET+1
	MoveB	seq+1, _header+TCP_HDR_N_SEQ_OFFSET+2
	MoveB	seq+0, _header+TCP_HDR_N_SEQ_OFFSET+3

	ldy	#SOCKET_REMSEQ_OFFSET_DW
	lda	(r8), y
	sta	_header+TCP_HDR_N_ACK_OFFSET+3
	iny
	lda	(r8), y
	sta	_header+TCP_HDR_N_ACK_OFFSET+2
	iny
	lda	(r8), y
	sta	_header+TCP_HDR_N_ACK_OFFSET+1
	iny
	lda	(r8), y
	sta	_header+TCP_HDR_N_ACK_OFFSET

	 ;if (_sckt->remSeq.d-_sckt->remSeqStart.d)
	 ;  //	   printf("ACKing %ld\n",_sckt->remSeq.d-_sckt->remSeqStart.d+data_size);

	 ldy	#SOCKET_TIMEOUT_OFFSET
	 lda	(r8), y
	 bne	@noTimeout2
	 ;*
	 ;* Update sequence number data.
	 ;*
	 lda	data_size
	 ora	data_size+1
	 beq	@70

	 clc
	 lda	data_size
	 adc	seq
	 sta	seq
	 lda	data_size+1
	 adc	seq+1
	 sta	seq+1
	 lda	#0
	 adc	seq+2
	 sta	seq+2
	 lda	#0
	 adc	seq+3
	 sta	seq+3
@70:
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	(r8), y
	and	#SYN|FIN
	beq	@71

	inc	seq
	bne	@71
	inc	seq+1
	bne	@71
	inc	seq+2
	bne	@71
	inc	seq+3
@71:

	ldy	#SOCKET_SEQ_OFFSET_DW
	lda	seq
	sta	(r8), y
	iny
	lda	seq+1
	sta	(r8), y
	iny
	lda	seq+2
	sta	(r8), y
	iny
	lda	seq+3
	sta	(r8), y
	iny
@noTimeout2:
	;*
	;* Update TCP checksum information.
	;*
	LoadW	_header+TCP_HDR_CHECKSUM_OFFSET, 0

	LoadW	r0, _header+12
	LoadW	r1, 8+TCP_HDR_SIZE
	jsr	ip_checksum
	LoadW	r0, IP_PROTO_TCP
	jsr	add_checksum
	MoveW	data_size, r0
	AddVW	TCP_HDR_SIZE, r0
	jsr	add_checksum
	lda	chks
	eor	#$FF
	sta	_header+TCP_HDR_CHECKSUM_OFFSET
	lda	chks+1
	eor	#$FF
	sta	_header+TCP_HDR_CHECKSUM_OFFSET+1
	jmp	@cont

@handleUDP:

	;*
	;* UDP message header.
	;*
	LoadB	_header+IP_HDR_PROTO_OFFSET, IP_PROTO_UDP

	MoveW	data_size, r0
	AddVW	28, r0
	MoveB	r0H, _header+IP_HDR_LENGTH_OFFSET
	MoveB	r0L, _header+IP_HDR_LENGTH_OFFSET+1

	MoveW	data_size, r0
	AddVW	8, r0
	MoveB	r0H, _header+UDP_HDR_LENGTH_OFFSET
	MoveB	r0L, _header+UDP_HDR_LENGTH_OFFSET+1

	;*
	;* Update UDP checksum information.
	;*
	LoadW	_header+UDP_HDR_CHECKSUM_OFFSET, 0

	LoadW	r0, _header+12
	LoadW	r1, 8 + UDP_HDR_SIZE
	jsr	ip_checksum

	LoadW	r0, IP_PROTO_UDP
	jsr	add_checksum
	MoveW	data_size, r0
	AddVW	UDP_HDR_SIZE, r0
	jsr	add_checksum
	lda	chks
	eor	#$FF
	sta	_header+UDP_HDR_CHECKSUM_OFFSET
	lda	chks+1
	eor	#$FF
	sta	_header+UDP_HDR_CHECKSUM_OFFSET+1

	;*
	;* Tell UDP that data was sent (no acknowledge).
	;*
	ldy	#SOCKET_CALLBACK_OFFSET
	lda	(r8), y
	sta	r4L
	iny
	lda	(r8), y
	sta	r4H
	lda	#WEEIP_EV_DATA_SENT
	jsr	(r4)
	jsr	remove_rx_data

@cont:
	;*
	;* Update IP checksum information.
	;*
	;jsr	checksum_init
	LoadW	chks, 0
	LoadW	r0, _header
	LoadW	r1, 20
	jsr	ip_checksum
	lda	chks
	eor	#$FF
	sta	_header+IP_HDR_CHECKSUM_OFFSET
	lda	chks+1
	eor	#$FF
	sta	_header+IP_HDR_CHECKSUM_OFFSET+1

	;*
	;* Send IP packet.
	;*
	jsr	eth_ip_send
	bcc	@failed

	lda	data_size
	ora	data_size+1
	beq	@62
	MoveW	data_size, r0
	ldy	#SOCKET_TX_OFFSET
	lda	(r8),y
	sta	r1L
	iny
	lda	(r8), y
	sta	r1H
	jsr	eth_write
@62:
.ifdef DEBUG_ACK
	debug_msg("eth_packet_send() called");
.endif
	jsr	eth_packet_send
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#0
	sta	(r8), y
	ldy	#SOCKET_TIMEOUT_OFFSET
	lda	#0
	sta	(r8), y
	jsr	socket_timeout
	ldy	#SOCKET_TIME_OFFSET
	sta	(r8), y

@failed:
	;// Sending the IP packet failed, possibly because there was no ARP
	;// entry for the requested IP, if it is on the local network.

	;// So we don't clear the status that we need to send

	;*
	;* Reschedule 50ms later for eventual further processing.
	;*
.ifdef DEBUG_ACK
	debug_msg("scheduling nwk_upstream 5 0");
.endif
	LoadW	r0, nwk_upstream
	LoadB	r1L, 5
	LoadB	r1H, 0
	LoadW	r2, upstreamName
	jsr	task_add
@nextSocket:
	AddVW	SOCKET_SIZE, r8
   	ldx	r9L
	inx
	cpx	#MAX_SOCKET
	beq	@noNextSocket
	jmp	@processSocket
@noNextSocket:
	;*
	;* Job done, finish.
	;*
@done:
	PopW	r9
	PopW	r8
	PopW	r7
	PopW	r6
	PopW	r5
	PopW	r4
	PopW	r3
	PopW	r2
	PopW	r1
	PopW	r0
	rts

.if 0
unsigned long byte_order_swap_d(unsigned long in)
{
	unsigned long out;
	((unsigned char *)&out)[0]=((unsigned char *)&in)[3];
	((unsigned char *)&out)[1]=((unsigned char *)&in)[2];
	((unsigned char *)&out)[2]=((unsigned char *)&in)[1];
	((unsigned char *)&out)[3]=((unsigned char *)&in)[0];
	return out;
}
.endif

; in: r8 socket ptr
nwk_schedule_oo_ack:
	;*
	;* Out of order, send our number.
	;*
.if 0
	;printf("request OOO ack: %ld != %ld\n",
	;	byte_order_swap_d(TCPH(n_seq.d))-_sckt->remSeqStart.d,_sckt->remSeq.d-_sckt->remSeqStart.d);
.endif
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#ACK
	sta	(r8),y
.ifdef INSTANT_ACK
	lda	#0
	jsr	nwk_upstream
.endif
.ifdef DEBUG_ACK
	debug_msg("asserting ack: Out-of-order rx");
	debug_msg("scheduling nwk_upstream 0 0");
.endif
	LoadW	r0, nwk_upstream
	jsr	task_cancel
	LoadB	r1L, 0
	LoadB	r1H, 0
	LoadW	r2, upstreamName
	jsr	task_add
	rts

;**
;* Network downstream processing.
;* Parse incoming network messages.
;*/
nwk_downstream:

	PushW	r0
	PushW	r1
	PushW	r2
	PushW	r3
	PushW	r4
	PushW	r5
	PushW	r6
	PushW	r7
	PushW	r8
	PushW	r9

	;WEEIP_EVENT ev;	=> r7L
	;_uint32_t rel_sequence; => r2/r3
	;static unsigned char i;

	LoadB	r7L, WEEIP_EV_NONE

	;*
	;* Packet size.
	;*
	CmpBI	_header+IP_HDR_VER_LENGTH_OFFSET, $45
	beq	@10
	jmp	@drop
@10:
	MoveB	_header+IP_HDR_LENGTH_OFFSET, data_size+1
	MoveB	_header+IP_HDR_LENGTH_OFFSET+1, data_size

	;*
	;* Checksum.
	;*/
	;jsr	checksum_init
	LoadW	chks, 0
	LoadW	r0, _header
	LoadW	r1, 20
	jsr	ip_checksum
	CmpWI	chks, $FFFF
	beq	@9

	brk
	lda	#$56

	jmp	@drop
@9:
.if 0
	;printf("\nI am %d.%d.%d.%d\n",ip_local.b[0],ip_local.b[1],ip_local.b[2],ip_local.b[3]);
	;printf("P=%02x: %d.%d.%d.%d:%d -> %d.%d.%d.%d:%d\n",
	;	IPH(protocol),
	;	IPH(source).b[0],IPH(source).b[1],IPH(source).b[2],IPH(source).b[3],
	;	NTOHS(TCPH(source)),
	;	IPH(destination).b[0],IPH(destination).b[1],IPH(destination).b[2],IPH(destination).b[3],
	;	NTOHS(TCPH(destination)));
.endif

	;*
	;* Destination address.
	;*
	lda	#$FF
	cmp	_header+IP_HDR_DEST_OFFSET		;// broadcast.
	bne	@80
	cmp	_header+IP_HDR_DEST_OFFSET+1
	bne	@80
	cmp	_header+IP_HDR_DEST_OFFSET+2
	bne	@80
	cmp	_header+IP_HDR_DEST_OFFSET+3
	beq	@89

@80:
	lda	ip_local
	cmp	_header+IP_HDR_DEST_OFFSET		;// unicast.
	bne	@81
	lda	ip_local+1
	cmp	_header+IP_HDR_DEST_OFFSET+1
	bne	@81
	lda	ip_local+2
	cmp	_header+IP_HDR_DEST_OFFSET+2
	bne	@81
	lda	ip_local+3
	cmp	_header+IP_HDR_DEST_OFFSET+3
	beq	@89

@81:
	lda	ip_broadcast
	cmp	_header+IP_HDR_DEST_OFFSET		;// unicast.
	bne	@82
	lda	ip_broadcast+1
	cmp	_header+IP_HDR_DEST_OFFSET+1
	bne	@82
	lda	ip_broadcast+2
	cmp	_header+IP_HDR_DEST_OFFSET+2
	bne	@82
	lda	ip_broadcast+3
	cmp	_header+IP_HDR_DEST_OFFSET+3
	beq	@89

@82:
	lda	#0
	cmp	ip_local			;// Waiting for DHCP configuration
	bne	@83
	cmp	ip_local+1
	bne	@83
	cmp	ip_local+2
	bne	@83
	cmp	ip_local+3
	beq	@89
@83:
	jmp	@drop				; // not for us.
@89:
	CmpBI	_header+IP_HDR_PROTO_OFFSET, IP_PROTO_ICMP
	bne	@noICMP
	jmp	@parse_icmp
@noICMP:
	lda	_header+TCP_HDR_DEST_OFFSET+1

	;*
	;* Search for a waiting socket.
	;*
	LoadW	r8, _sockets
	ldx	#0
@socketLoop:
	ldy	#SOCKET_TYPE_OFFSET
	lda	(r8), y
	cmp	#SOCKET_FREE
	beq	@next
	ldy	#SOCKET_PORT_OFFSET
	lda	(r8), y
	cmp	_header+TCP_HDR_DEST_OFFSET
	bne	@next
	iny
	lda	(r8), y
	cmp	_header+TCP_HDR_DEST_OFFSET+1
	bne	@next		;// another port.
	ldy	#SOCKET_TYPE_OFFSET
	lda	(r8), y
	cmp	#SOCKET_UDP
	bne	@noUDP	;// another protocol.
	CmpBI	_header+IP_HDR_PROTO_OFFSET, IP_PROTO_UDP
	bne	@next
	bra 	@use
@noUDP:
	CmpBI	_header+IP_HDR_PROTO_OFFSET, IP_PROTO_TCP
	bne	@next
@use:
	ldy	#SOCKET_LISTEN_OFFSET
	lda	(r8), y
	bne	@found		;// waiting for a connection

	;// Don't check source if we are bound to broadcast
	ldy	#SOCKET_REMIP_OFFSET
	lda	#$FF
@broadcastCheck:
	cmp	(r8), y
	bne	@checkSource
	iny
	cpy	#SOCKET_REMIP_OFFSET+4
	bne	@broadcastCheck
	bra	@remIPChecked
@checkSource:
	ldy	#SOCKET_REMIP_OFFSET
@remIPCheck:
	lda	_header+IP_HDR_SOURCE_OFFSET-SOCKET_REMIP_OFFSET, y
	cmp	(r8), y
	bne	@next
	iny
	cpy	#SOCKET_REMIP_OFFSET+4
	bne	@remIPCheck     ;// another source.
@remIPChecked:
	ldy	#SOCKET_REMPORT_OFFSET
	lda	(r8), y
	cmp	_header+TCP_HDR_SOURCE_OFFSET
	bne	@next
	iny
	lda	(r8), y
	cmp	_header+TCP_HDR_SOURCE_OFFSET+1
	bne	@next		;// another port.
	bra	@found		;// found!
@next:
	AddW	r8, SOCKET_SIZE
	inx
	cpx	#MAX_SOCKET
	bne	@socketLoop

   	jmp	@drop                   ;// no socket for the message.

@found:
	;*
	;* Update socket data.
	;*
	;//   printf("found socket: source.d=$%08lx\n",IPH(source).d);
	ldy	#SOCKET_REMIP_OFFSET
@15:
	lda	_header+IP_HDR_SOURCE_OFFSET-SOCKET_REMIP_OFFSET, y
	sta	(r8), y
	iny
	cpy	#SOCKET_REMIP_OFFSET+4
	bne	@15

	ldy	#SOCKET_REMPORT_OFFSET
	lda	_header+TCP_HDR_SOURCE_OFFSET
	sta	(r8), y
	iny
	ldy	_header+TCP_HDR_SOURCE_OFFSET+1
	sta	(r8), y

	lda	#0 ; FALSE
	ldy	#SOCKET_LISTEN_OFFSET
	sta	(r8), y

	CmpBI	_header+IP_HDR_PROTO_OFFSET, IP_PROTO_TCP
	bne	@noTCP

	jmp	@parse_tcp

@noTCP:


	;*
	;* UDP message.
	;* Copy data into user socket buffer.
	;* Add task for processing.
	;*
	SubVW	28, data_size

	ldy	#SOCKET_RX_OFFSET
	lda	(r8), y
	iny
	ora	(r8), y
	beq	@16

	ldy	#SOCKET_RX_SIZE_OFFSET
	lda	(r8), y
	sta	r4L
	iny
	lda	(r8), y
	sta	r4H
	CmpW	r4, data_size
	bcs	@64		; if r4 bigger than data_size
	beq	@64
	MoveW	r4, data_size
@64:
	; setup dmalist to receive from ETH_RX_BUFFER
	LoadB	dmalist_source_mb, ETH_RX_BUFFER>>20;
	LoadB	dmalist_source_bank, (ETH_RX_BUFFER>>16) & $0f;
	LoadW	dmalist_source_addr, (ETH_RX_BUFFER+2+14+8+20) & $ffff;

	LoadB  	dmalist_dest_mb, 0	; fetching into bank 0
	LoadB	dmalist_dest_bank, 0

	ldy	#SOCKET_RX_OFFSET
	lda	(r8), y
	sta	dmalist_dest_addr
	iny
	lda	(r8), y
	sta	dmalist_dest_addr+1

	MoveW	data_size, dmalist_count
	jsr	do_dma

	ldy	#SOCKET_RX_DATA_OFFSET
	lda	data_size
	sta	(r8), y
	iny
	lda	data_size+1
	sta	(r8), y
@16:

	LoadB	r7L, WEEIP_EV_DATA
	jmp 	@done
	
@parse_tcp:
	;//   printf(":");

	;*
	;* TCP message.
	;* Check flags.
	;*
   	LoadB	_flags, 0
	SubVW	40, data_size

	lda	_header+TCP_HDR_FLAGS
	and	#ACK
	beq	@noAck

	;*
	;* Test acked sequence number.
	;*
	ldy	#SOCKET_SEQ_OFFSET_DW
	lda	(r8), y
	cmp	_header+TCP_HDR_ACK_OFFSET_DW+3
	bne	@wrongAck
	iny
	lda	(r8), y
	cmp	_header+TCP_HDR_ACK_OFFSET_DW+2
	bne	@wrongAck
	iny
	lda	(r8), y
	cmp	_header+TCP_HDR_ACK_OFFSET_DW+1
	bne	@wrongAck
	iny
	lda	(r8), y
	cmp	_header+TCP_HDR_ACK_OFFSET_DW
	beq	@ack

@wrongAck:
	brk
	lda	#$33
	;*
	;* Out of order, drop it.
	;* XXX This is when the other side has ACKed a different part
	;* of our stream.
	;* PGS: I think we lock-step and have only one unacknowledged packet
	;* at a time, so can effectively ignore it (but should probably be
	;* clever and re-send?)
	;*
	ldy	#SOCKET_STATE_OFFSET
	lda	(r8), y
	cmp	#_CONNECT
	bne	@67
	;printf("Drop\n");
	jmp	@drop
@67:
@ack:
	LoadB	_flags, ACK
@noAck:

	lda	_header+TCP_HDR_FLAGS
	and	#SYN
	beq	@synNotSet

	;*
	;* Restart of remote sequence number (connection?).
	;*
	ldy	#SOCKET_REMSEQ_OFFSET_DW
	lda	_header+TCP_HDR_N_SEQ_OFFSET+3
	sta	(r8), y
	iny
	lda	_header+TCP_HDR_N_SEQ_OFFSET+2
	sta	(r8), y
	iny
	lda	_header+TCP_HDR_N_SEQ_OFFSET+1
	sta	(r8), y
	iny
	lda	_header+TCP_HDR_N_SEQ_OFFSET+0
	sta	(r8), y

	;// Remember initial remote sequence # for convenient debugging
	ldy	#SOCKET_REMSEQ_OFFSET_DW
	lda	(r8),y
	ldy	#SOCKET_REMSEQSTART_OFFSET_DW
	sta	(r8), y

	ldy	#SOCKET_REMSEQ_OFFSET_DW
	lda	(r8), y
	inc
	sta	(r8), y
	lda	_flags
	ora	#SYN|ACK
	sta	_flags

	;//      printf("SYN%d",_sckt->state);
	jmp	@synDone

@synNotSet:
	;// XXX Correct buffer offset processing to handle variable
	;// header lengths
	lda	_header+IP_HDR_VER_LENGTH_OFFSET
	and	#$0F
	asl
	asl
	sta	r4L
	lda	_header+TCP_HDR_HLEN
	lsr
	lsr
	lsr
	lsr
	asl
	asl
	clc
	adc	r4L
	sta	data_ofs

	SubW	data_ofs, data_size
	AddVW	40, data_size

	;*
	;* Test remote sequence number.
	;*
	ldy	#SOCKET_RX_SIZE_OFFSET
	lda	(r8), y
	sta	r4L
	iny
	lda	(r8), y
	sta	r4H

	CmpW	r4, data_size
	bcs	@180		; if r4 bigger than data_size
	beq	@180

	brk
	lda	#$01
	MoveW	r4, data_size
@180:
	MoveB	_header+TCP_HDR_N_SEQ_OFFSET+3, r2L	;rel_sequence
	MoveB	_header+TCP_HDR_N_SEQ_OFFSET+2, r2H	;rel_sequence+1
	MoveB	_header+TCP_HDR_N_SEQ_OFFSET+1, r3L	;rel_sequence+2
	MoveB	_header+TCP_HDR_N_SEQ_OFFSET, r3H	;rel_sequence+3

	ldy	#SOCKET_REMSEQ_OFFSET_DW
	sec
	lda	r2L	;rel_sequence
	sbc	(r8), y
	sta	r2L	;rel_sequence
	iny
	lda	r2H	;rel_sequence+1
	sbc	(r8), y
	sta	r2H	;rel_sequence+1
	iny
	lda	r3L	;rel_sequence+2
	sbc	(r8), y
	sta	r3L	;rel_sequence+2
	iny
	lda	r3H	;rel_sequence+3
	sbc	(r8), y
	sta	r3H	;rel_sequence+3

.if 0
	;printf("\n%5ld: rel_seq=%ld, rx:%d,%d to %d\n",
	;	_sckt->remSeq.d-_sckt->remSeqStart.d,
	;	rel_sequence.d,
	;	_sckt->rx_data,
	;	_sckt->rx_oo_start,_sckt->rx_oo_end);
.endif
.if 0
	ldy	#SOCKET_RX_SIZE_OFFSET+1
	lda	(r8), y
	cmp	r2H		;rel_sequence
	beq	@101b
	bcc	@100		; branch if buffer size < sequence update
@101b:
	dey
	lda	(r8), y
	cmp	r2L		;rel_sequence+1
	beq	@100
	bcs	@101
@100:
	MoveW	r2, r5		; from rel_sequence
	AddW	data_size, r5
	ldy	#SOCKET_RX_SIZE_OFFSET+1
	lda	(r8), y
	cmp	r5H
	beq	@100b
	bcc	@102
@100b:
	dey
	lda	(r8), y
	cmp	r5L
	beq	@102
	bcc	@102
@101:

brk
lda	#$59
	;// Ignore segments that we can't possibly handle
	;//       printf("drop(a)");
	CmpWI	data_size, 0
	bne	@299
@298:
	jmp	@200
@299:
	jsr	nwk_schedule_oo_ack
	jmp	@drop
.endif
	;} else if (rel_sequence.w[0]==_sckt->rx_data) {
@102:

	ldy	#SOCKET_RX_DATA_OFFSET+1
	lda	(r8), y
	cmp	r2H		;rel_sequence+1
	beq	@_103
@__103:
	jmp	@103
@_103:
	dey
	lda	(r8), y
	cmp	r2L		;rel_sequence
	bne	@__103

	;// Copy to end of data in RX buffer
	;//       printf("rx append %d@%d",data_size,_sckt->rx_data);
	clc
	ldy	#SOCKET_RX_DATA_OFFSET
	lda	(r8), y
	adc	data_size
	sta	r6L
	iny
	lda	(r8), y
	adc	data_size+1
	sta	r6H

	ldy	#SOCKET_RX_SIZE_OFFSET
	lda	(r8), y
	sta	r5L
	iny
	lda	(r8), y
	sta	r5H

	;if (data_size+_sckt->rx_data>_sckt->rx_size)
	CmpW	r5, r6
	beq	@104		; branch r5 == r6
	bcs	@104		; branch r5 > r6

	brk
	lda	#$1

	MoveW	r5, data_size
	SubW	r6, data_size
@104:
	lda	data_size
	ora	data_size+1
	beq	@105

	; setup dmalist to receive from ETH_RX_BUFFER
	LoadB	dmalist_source_mb, ETH_RX_BUFFER>>20;
	LoadB	dmalist_source_bank, (ETH_RX_BUFFER>>16) & $0f;
	LoadW	dmalist_source_addr, (ETH_RX_BUFFER+16) & $ffff;
	AddW	data_ofs, dmalist_source_addr

	LoadB  	dmalist_dest_mb, 0	; fetching into bank 0
	LoadB	dmalist_dest_bank, 0
	ldy	#SOCKET_RX_DATA_OFFSET
	lda	(r8), y
	sta	dmalist_dest_addr
	iny
	lda	(r8), y
	sta	dmalist_dest_addr+1

	ldy	#SOCKET_RX_OFFSET
	clc
	lda	(r8), y
	adc	dmalist_dest_addr
	sta	dmalist_dest_addr
	iny
	lda	(r8), y
	adc	dmalist_dest_addr+1
	sta	dmalist_dest_addr+1

	MoveW	data_size, dmalist_count
	jsr	do_dma
@105:
	ldy	#SOCKET_RX_DATA_OFFSET
	clc
	lda	(r8), y
	adc	data_size
	sta	(r8), y
	iny
	lda	(r8), y
	adc	data_size+1
	sta	(r8), y
	
	cmp	#$08
	bne	@999
	
	brk
	lda	#$1
@999:
	jmp	@200

	;} else if (rel_sequence.w[0]==_sckt->rx_oo_end) {
@103:
.if 0
	;// Copy to end of OO data in RX buffer
	;// printf("oo append");
	ldy	#SOCKET_RX_OO_END_OFFSET
	lda	(r8), y
	sta	r6L
	iny
	lda	(r8), y
	sta	r6H
	ldy	#SOCKET_RX_SIZE_OFFSET
	lda	(r8), y
	sta	r5L
	iny
	lda	(r8), y
	sta	r5H

	CmpW	r5, r6
	beq	@106b
	jmp	@106
@106b:
	brk
	lda	#$03
	MoveW	r6, r4
	AddW	r6, data_size

	CmpW	r5, r6
	bcc	@_120
	jmp	@120
@_120:
brk
lda	#$04

	MoveW	r5, data_size
	SubW	data_size, r4

	lda	data_size
	ora	data_size+1
	beq	@120

	; setup dmalist to receive from ETH_RX_BUFFER
	LoadB	dmalist_source_mb, ETH_RX_BUFFER>>20;
	LoadB	dmalist_source_bank, (ETH_RX_BUFFER>>16) & $0f;
	LoadW	dmalist_source_addr, (ETH_RX_BUFFER+16) & $ffff;
	AddW	dmalist_source_addr, data_ofs

	LoadB  	dmalist_dest_mb, 0	; fetching into bank 0
	LoadB	dmalist_dest_bank, 0
	ldy	#SOCKET_RX_OO_END_OFFSET
	lda	(r8),y
	sta	dmalist_dest_addr
	iny
	lda	(r8),y
	sta	dmalist_dest_addr+1
	ldy	#SOCKET_RX_OFFSET
	clc
	lda	dmalist_dest_addr
	adc	(r8), y
	sta 	dmalist_dest_addr
	iny
	lda	dmalist_dest_addr+1
	adc	(r8), y
	sta 	dmalist_dest_addr+1

	MoveW	data_size, dmalist_count
	jsr	do_dma

@120:	jmp	@200

	;} else if ((rel_sequence.w[0]+data_size)==_sckt->rx_oo_start) {
@106:
	MoveW	data_size, r6
	AddW	r2, r6 		;rel_sequence
	ldy	#SOCKET_RX_OO_START_OFFSET
	lda	(r8),y
	cmp	r6L
	bne	@107
	iny
	ldy	#SOCKET_RX_OO_START_OFFSET
	lda	(r8),y
	cmp	r6H
	bne	@107

	;// Copy to start of OO data in RX buffer
	;//       printf("oo prepend");
	lda	data_size
	ora	data_size
	beq 	@122

	; setup dmalist to receive from ETH_RX_BUFFER
	LoadB	dmalist_source_mb, ETH_RX_BUFFER>>20;
	LoadB	dmalist_source_bank, (ETH_RX_BUFFER>>16) & $0f;
	LoadW	dmalist_source_addr, (ETH_RX_BUFFER+16) & $ffff;
	AddW	dmalist_source_addr, data_ofs

	LoadB  	dmalist_dest_mb, 0	; fetching into bank 0
	LoadB	dmalist_dest_bank, 0
	ldy	#SOCKET_RX_OFFSET
	lda	(r8), y
	sta	dmalist_dest_addr
	iny
	lda	(r8), y
	sta	dmalist_dest_addr+1
	AddW	dmalist_dest_addr, r2		;rel_sequence

	MoveW	data_size, dmalist_count

	jsr	do_dma
@122:
	ldy	#SOCKET_RX_OO_END_OFFSET
	clc
	lda	(r8), y
	adc	r2L		;rel_sequence
	sta	(r8), y
	lda	(r8), y
	adc	r2H		;rel_sequence+1
	sta	(r8), y

	jmp	@200
 	;} else if ((rel_sequence.w[0]+data_size)<_sckt->rx_size&&!_sckt->rx_oo_start) {
@107:
	ldy	#SOCKET_RX_SIZE_OFFSET
	lda	(r8) ,y
	sta	r5L
	iny
	ldy	#SOCKET_RX_SIZE_OFFSET
	lda	(r8) ,y
	sta	r5H

	MoveW	r2, r6			; from rel_sequence
	AddW	r6, r5

	CmpW	r6, r5
	bcs	@_108		; branch if r6 >= r5
@__108:
	jmp	@108
@_108:
	ldy	#SOCKET_RX_OO_START_OFFSET
	lda	(r8), y
	sta	r4L
	iny
	lda	(r8), y
	sta	r4H

	lda	r4L
	lda	r4H
	beq	@__108

	;// It belongs in the window, but not at the start, so put in RX OO buffer
	;//       printf("oo stash");
	lda	data_size
	ora	data_size+1
	beq	@123

	; setup dmalist to receive from ETH_RX_BUFFER
	LoadB	dmalist_source_mb, ETH_RX_BUFFER>>20;
	LoadB	dmalist_source_bank, (ETH_RX_BUFFER>>16) & $0f;
	LoadW	dmalist_source_addr, (ETH_RX_BUFFER+16) & $ffff;
	AddW	dmalist_source_addr, data_ofs

	LoadB  	dmalist_dest_mb, 0	; fetching into bank 0
	LoadB	dmalist_dest_bank, 0
	ldy	#SOCKET_RX_OFFSET
	lda	(r8), y
	sta	dmalist_dest_addr
	iny
	lda	(r8), y
	sta	dmalist_dest_addr+1
	AddW	dmalist_dest_addr, r2		;rel_sequence

	MoveW	data_size, dmalist_count

	jsr	do_dma
@123:
	ldy	#SOCKET_RX_OO_START_OFFSET
	lda	r2L				;rel_sequence
	sta	(r8), y
	iny
	lda	r2H				;rel_sequence
	sta	(r8), y
	MoveW	data_size, r4
	AddW	r4, r2				;rel_sequence
	ldy	#SOCKET_RX_OO_END_OFFSET
	lda	r4L
	sta	(r8), y
	iny
	lda	r4H
	sta	(r8), y
	jmp	@200
.endif
	;} else if (rel_sequence.d) {
@108:
	lda	r2L				;rel_sequence
	ora	r2H
	beq	@200

	;//       printf("drop(b)");
	lda	data_size
	ora	data_size + 1
	beq	@200
	jsr	nwk_schedule_oo_ack
	jmp	@drop
@200:
.if 0
	;//     while(!PEEK(0xD610)) continue; POKE(0xD610,0);

	;// Merge received data and RX OO area, if possible
	ldy	#SOCKET_RX_DATA_OFFSET
	lda	(r8), y
	sta	r6L
	iny
	lda	(r8), y
	sta	r6H

	lda	r6L
	ora	r6H
	bne	@124

	ldy	#SOCKET_RX_OO_START_OFFSET
	lda	(r8), y
	sta	r5L
	iny
	lda	(r8), y
	sta	r5H

	CmpW	r6, 56
	bne	@124

	ldy	#SOCKET_RX_OO_END_OFFSET
	lda	(r8), y
	sta	r4L
	iny
	lda	(r8), y
	sta	r4H
	ldy	#SOCKET_RX_DATA_OFFSET
	lda	r4L
	sta	(r8), y
	iny
	lda	r4H
	sta	(r8), y

	lda	#0
	ldy	#SOCKET_RX_OO_END_OFFSET
	sta	(r8), y
	iny
	sta	(r8), y
	ldy	#SOCKET_RX_OO_START_OFFSET
	sta	(r8), y
	iny
	sta	(r8), y
@124:
.endif
	;*
	;* Update stream sequence number.
	;*
	ldy	#SOCKET_RX_DATA_OFFSET
	lda	(r8), y
	sta	r4L
	iny
	lda	(r8), y
	sta	r4H

	ldy	#SOCKET_REMSEQ_OFFSET_DW
	clc
	lda	(r8), y
	adc	r4L
	sta	(r8), y
	iny
	lda	(r8), y
	adc	r4H
	sta	(r8), y
	iny
	lda	(r8), y
	adc	#0
	sta	(r8), y
	iny
	lda	(r8), y
	adc	#0
	sta	(r8), y
	iny

	;// Deliver data to programme
	ldy	#SOCKET_RX_DATA_OFFSET
	lda	(r8), y
	iny
	ora	(r8), y
	beq	@125

	ldy	#SOCKET_CALLBACK_OFFSET
	lda	(r8), y
	sta	r4L
	iny
	lda	(r8), y
	sta	r4H

	lda	#WEEIP_EV_DATA
	jsr	(r4)
	jsr	remove_rx_data

@125:
	;// And ACK every packet, because we don't have buffer space for multiple ones,
	;// and its thus very easy for the sender to not know where we are upto, and for
	;// everything to generally get very confused if we have encountered any out-of-order
	;// packets.
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#ACK
	sta	(r8), y
@126:
@synDone:

	;// XXX PGS moved this lower down, so that we can check any included data has the correct sequence
	;// number, so that we can pass the data up, if required, so that data included in the RST
	;// packet doesn't get lost (Boar's Head BBS does this, for example)
	lda	_header+TCP_HDR_FLAGS
	and	#RST
	beq	@300

	;*
	;* RST flag received. Force disconnection.
	;*
	ldy	#SOCKET_STATE_OFFSET
	lda	#_IDLE
	sta	(r8), y
	lda	data_size
	ora	data_size
	bne 	@301
	;// No data, so just disconnect
	LoadB	r7L, WEEIP_EV_DISCONNECT
	bra	@302
@301:
	;// Disconnect AND valid data
	LoadB	r7L, WEEIP_EV_DISCONNECT_WITH_DATA
	jmp 	@done
@302:

@300:
	;// If FIN flag is set, then we also acknowledge all data so far,
	;// plus the FIN flag.
	lda	_header+TCP_HDR_FLAGS
	and	#FIN
	bne	@310
	ldy	#SOCKET_STATE_OFFSET
	lda	(r8), y
	cmp	#_FIN_REC
	bne	@309

@310:
	ldy	#SOCKET_REMSEQ_OFFSET_DW
	lda	_header+TCP_HDR_N_SEQ_OFFSET+3
	sta	(r8), y
	iny
	lda	_header+TCP_HDR_N_SEQ_OFFSET+2
	sta	(r8), y
	iny
	lda	_header+TCP_HDR_N_SEQ_OFFSET+1
	sta	(r8), y
	iny
	lda	_header+TCP_HDR_N_SEQ_OFFSET
	sta	(r8), y

	ldy	#SOCKET_REMSEQ_OFFSET_DW
	clc
	lda	(r8),y
	adc	data_size
	sta	(r8), y
	iny
	lda	(r8),y
	adc	data_size+1
	sta	(r8), y
	iny
	lda	(r8),y
	adc	#0
	sta	(r8), y
	iny
	lda	(r8),y
	adc	#0
	sta	(r8), y

	ldy	#SOCKET_REMSEQ_OFFSET_DW
	lda	(r8), y
	inc
	sta	(r8), y
	bne	@311
	iny
	lda	(r8), y
	inc
	sta	(r8), y
	bne	@311
	iny
	lda	(r8), y
	inc
	sta	(r8), y
	bne	@311
	iny
	lda	(r8), y
	inc
	sta	(r8), y
	bne	@311
	iny
@311:
	lda	_flags
	ora	#FIN
	sta	_flags
	;//      printf("FIN ACK = %ld\n",_sckt->remSeq.d-_sckt->remSeqStart.d);
@309:

	;*
	;* TCP state machine implementation.
	;*/
	ldy	#SOCKET_STATE_OFFSET
	lda	(r8), y
	cmp	#_LISTEN
	bne	@401

	lda	_flags
	and	#SYN
	beq	@402
	;*
	;* Start incoming connection procedure.
	;*
.ifdef DEBUG_ACK
	debug_msg("asserting ack: _listen state");
.endif
	ldy	#SOCKET_STATE_OFFSET
	lda	#_SYN_REC
	sta	(r8), y
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#SYN | ACK
	sta	(r8), y
@402:
	 jmp	@500
@401:
	cmp	#_SYN_SENT
	bne	@403

	lda	_flags
	and	#ACK|SYN
	beq	@408
	;*
	;* Connection established.
	;*
.ifdef DEBUG_ACK
	debug_msg("asserting ack: _syn_sent state with syn or ack");
.endif
	ldy	#SOCKET_STATE_OFFSET
	lda	#_CONNECT
	sta	(r8), y
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#ACK
	sta	(r8), y

	;// Advance sequence # by one to ack the ack
	;ldy	#SOCKET_SEQ_OFFSET_DW
	;lda	(r8), y
	;inc
	;sta	(r8), y

	LoadB	r7L, WEEIP_EV_CONNECT
	;//printf("Saw SYN\n");
	jmp	@500
@408:
	lda	_flags
	and	#SYN
	beq	@409
.ifdef DEBUG_ACK
	;debug_msg("asserting ack: _syn_sent state with syn");
.endif
	ldy	#SOCKET_STATE_OFFSET
	lda	#_SYN_REC
	sta	(r8), y
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#SYN|ACK
	sta	(r8), y
@409:
	jmp	@500

@403:
	cmp	#_SYN_REC
	bne	@410
	lda	_flags
	and	#ACK
	beq	@411
	;*
	;* Connection established.
	;*
	ldy	#SOCKET_STATE_OFFSET
	lda	#_CONNECT
	sta	(r8), y
	LoadB	r7L, WEEIP_EV_CONNECT
@411:
	jmp	@500
@410:
	cmp	#_CONNECT
	beq	@421
	cmp	#_ACK_WAIT
	bne	@420
@421:
	lda	_flags
	and	#FIN
	beq	@419

	;*
	;* Start remote disconnection procedure.
	;*
.ifdef DEBUG_ACK
	debug_msg("asserting ack: _ack_wait state");
.endif
	ldy	#SOCKET_STATE_OFFSET
	lda	#_FIN_REC
	sta	(r8), y

	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#ACK|FIN
	sta	(r8), y

	;LoadB	r7L, WEEIP_EV_DISCONNECT		; // TESTE

	jmp 	@500
@419:
	lda	_flags
	and	#ACK
	beq	@418
	ldy	#SOCKET_STATE_OFFSET
	lda	(r8), y
	cmp	#_ACK_WAIT
	bne	@418

	;*
	;* The peer acknowledged the previously sent data.
	;*
	lda	#_CONNECT
	sta	(r8), y
@418:
	lda	data_size
	ora	data_size+1
	beq	@417

	;*
	;* Data received.
	;*
.ifdef DEBUG_ACK
	debug_msg("asserting ack: data received");
.endif
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#ACK
	sta	(r8), y
	;LoadB	r7L, WEEIP_EV_DATA
	;inc	$d020

@417:
	jmp	@500
@420:
	cmp	#_FIN_SENT
	bne	@430

	lda	_flags
	and	#FIN|ACK
	beq	@429

	;*
	;* Disconnection done.
	;*
.ifdef DEBUG_ACK
	debug_msg("asserting ack: _fin_sent state with fin or ack");
.endif
	ldy	#SOCKET_STATE_OFFSET
	lda	#_IDLE
	sta	(r8), y
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#ACK
	sta	(r8), y


	LoadB	r7L, WEEIP_EV_DISCONNECT
	;// Allow the final state to be selected based on ACK and FIN flag state.
	;//            break;
@429:
	lda	_flags
	and	#ACK
	beq	@428
	LoadB	r7L, WEEIP_EV_NONE

	ldy	#SOCKET_STATE_OFFSET
	lda	#_FIN_ACK_REC
	sta	(r8), y
@428:
	lda	_flags
	and	#FIN
	beq	@427
.ifdef DEBUG_ACK
	debug_msg("asserting ack: _fin_ack_rec state with fin");
.endif
	ldy	#SOCKET_STATE_OFFSET
	lda	#_FIN_REC
	sta	(r8),y
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#ACK
	sta	(r8),y
@427:
	jmp	@500
@430:
	cmp	#_FIN_REC
	bne	@440
	lda	_flags
	and	#ACK
	beq	@431

	;*
	;* Disconnection done.
	;*
	ldy	#SOCKET_STATE_OFFSET
	lda	#_IDLE
	sta	(r8), y
	LoadB	r7L, WEEIP_EV_DISCONNECT
@431:
	jmp	@500
@440:
	cmp	#_FIN_ACK_REC
	bne	@500
	lda	_flags
	and	#FIN
	beq	@441
	;*
	;* Disconnection done.
	;*
.ifdef DEBUG_ACK
	debug_msg("asserting ack: _fin_ack_rec state with fin");
.endif
	ldy	#SOCKET_STATE_OFFSET
	lda	#_FIN_REC
	sta	(r8), y
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#ACK
	sta	(r8), y
	LoadB	r7L, WEEIP_EV_DISCONNECT
@441:
@500:
 	jmp 	@done

@parse_icmp:
	;*
	;Parse ICMP messages.
	;Only care about ECHO REQUEST for now
	;*/
.ifdef ENABLE_ICMP
	CmpB	_header+ICMP_HDR_TYPE_OFFSET, 0x08
	bne	@45
	CmpB	_header+ICMP_HDR_FCODE_OFFSET, 0x00
	bne	@45
	;// ICMP Echo request:

	; setup dmalist to receive from ETH_RX_BUFFER
	LoadB	dmalist_source_mb, ETH_RX_BUFFER>>20;
	LoadB	dmalist_source_bank, (ETH_RX_BUFFER>>16) & $0f;
	LoadW	dmalist_source_addr, (ETH_RX_BUFFER+2L) & $ffff;

	LoadB  	dmalist_dest_mb, 0	; fetching into bank 0
	LoadB	dmalist_dest_bank, 0
	LoadW	dmalist_dest_addr, tx_frame_buf

	;// 0. Copy received packet to tx buffer
	MoveW	data_size, dmalist_count
	AddVW	14, dmalist_count
	jsr	do_dma

	// 1. Copy Eth src to DST
	LoadB	dmalist_source_mb, 0
	LoadB	dmalist_source_bank, 0
	LoadW	dmalist_source_addr, tx_frame_buf+6
	LoadW	dmalist_dest_addr, tx_frame_buf

	LoadW	dmalist_count, 6
	jsr	do_dma

	// 2. Put our ETH as src
	LoadW	dmalist_source_addr, $D6E9
	LoadW	dmalist_dest_addr, tx_frame_buf+6
	jsr	do_dma

	// 3. IP SRC becomes DST
	LoadW	dmalist_source_addr, tx_frame_buf+26
	LoadW	dmalist_dest_addr, tx_frame_buf+30

	LoadW	dmalist_count, 4
	jsr	do_dma

	// 4. Put our IP as SRC
	LoadW	dmalist_source_addr, ip_local
	LoadW	dmalist_dest_addr, tx_frame_buf+26
	jsr	do_dma

	// 5. Change type from 0x08 (ECHO REQUEST) to 0x00 (ECHO REPLY)
	LoadB	tx_frame_buf+14+20, $00

	// 6. Update ICMP checksum
	LoadB	tx_frame_buf+14+20+2, 0
	LoadB	tx_frame_buf+14+20+2+1, 0
	LoadW	chks, 0
	LoadW	r0, tx_frame_buf+14+20
	MoveW	r1, data_size
	jsr	ip_checksum
	// XXX For some reason if we do the following assignment as single
	// operation, it crashes the programme. But doing it this way,
	// seems to be fine. Go figure :/
	lda	chks
	eor	#$FF
	sta	tx_frame_buf+14+20+2
	lda	chks+1
	eor	#$FF
	sta	tx_frame_buf+14+20+2+1

	// 7. Update IP checksum
	tx_frame_buf[14+10]=0; tx_frame_buf[14+11]=0;
	LoadW	chks, 0
	LoadW	r0, tx_frame_buf+14
	LoadW	r1, 20
	jsr	ip_checksum
	*(unsigned short *)&tx_frame_buf[14+10] = checksum_result();

	// Send immediately
	eth_tx_len=14+data_size;
	eth_packet_send();
@45:
.endif
	jmp	@drop

@done:
.ifdef INSTANT_ACK
	lda	#0
	jsr	nwk_upstream
.endif
.ifdef DEBUG_ACK
	debug_msg("scheduling nwk_upstream 0 0");
.endif
	LoadW	r0, nwk_upstream
	jsr	task_cancel
	LoadB	r1L, 0
	LoadB	r1H, 0
	LoadW	r2, upstreamName
	jsr	task_add
@99:

	;*
	;* Verify event processing.
	;* Add socket management task.
	;*
	CmpBI	r7L, WEEIP_EV_NONE
	beq	@177
	ldy	#SOCKET_CALLBACK_OFFSET
	lda	(r8), y
	sta	r4L
	iny
	lda	(r8), y
	sta	r4H
	lda	r7L
	jsr	(r4)
	jsr	remove_rx_data
@177:

@drop:
	PopW	r9
	PopW	r8
	PopW	r7
	PopW	r6
	PopW	r5
	PopW	r4
	PopW	r3
	PopW	r2
	PopW	r1
	PopW	r0
	rts
