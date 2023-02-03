;**
;* @file eth.c
;* @brief Ethernet management for the MEGA65 45GS100 integrated 100mbit Ethernet controller
;* @compiler CC65
;* @author Paul Gardner-Stephen (paul@m-e-g-a.org)
;* Based on code by:
;* @author Bruno Basseto (bruno@wise-ware.org)
;*/

.include "geosmac.inc"
.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"

.include "defs.inc"

;#include <stdint.h>
;#include <stdio.h>

;#include <string.h>
;#include "task.h"
;#include "weeip.h"
;#include "arp.h"
;#include "eth.h"

;#include "memory.h"
;#include "hal.h"
;#include "debug.h"
;#include "time.h"

.import arp_query
.import arp_mens
.import query_cache
.import nwk_downstream

.import	_header
.import _header_ip_protocol
.import ip_local
.import task_add

.export eth_init
.export eth_arp_send
.export eth_clear_to_send
.export eth_write
.export eth_ip_send
.export eth_packet_send
.export mac_local
.export ip_dnsserver
.export ip_mask
.export ip_gate
.export eth_task

.export dmalist_count
.export dmalist_source_mb
.export dmalist_source_bank
.export dmalist_source_addr
.export dmalist_dest_mb
.export dmalist_dest_bank
.export dmalist_dest_addr
.export do_dma



.segment "STARTUP"

_PROMISCUOUS	=	1
NOCRCCHECK	=	1

eth_log_mode:
	.byte	0

eth_size:
	.word	0		;// Packet size.

eth_tx_len:
	.word	0		;// Bytes written to TX buffer


ip_mask:			; IPV4 ///< Subnetwork address mask.
	.dword	0
ip_gate:
	.dword	0		; IPV4 ///< IP Gateway address.
ip_dnsserver:
	.dword	0		; IPV4 ///< DNS Server IP

;**
;* Ethernet frame header.
;*/
;typedef struct {
;   EUI48 destination;            ///< Packet Destination address.
;   EUI48 source;                 ///< Packet Source address.
;   uint16_t type;                ///< Packet Type or Size (big-endian)
;} ETH_HEADER;

ethtaskName:
	.byte	"ethtask", 0

;/**
; * Ethernet frame header buffer.
; */
eth_header:
eth_header_destination:
	.byte	0, 0, 0, 0, 0, 0
eth_header_source:
	.byte	0, 0, 0, 0, 0, 0
eth_header_type:
	.word	0

ETH_TX_BUFFER 	=	$FFDE800
ETH_RX_BUFFER 	= 	$FFDE800

ETH_HEADER_SIZE	= 14
ARP_HDR_SIZE	= 28
ICMP_HDR_SIZE	= 8

IP_PROTO_TCP   	= 6	;///< TCP packet.
IP_PROTO_UDP    = 17    ;///< UDP packet.
IP_PROTO_ICMP   = 1     ;///< ICMP packet.

;/**
; * Local MAC address.
; */
mac_local:
	.byte	0, 0, 0, 0, 0, 0

MTU 	=	2048

tx_frame_buf	= $5800
	;.repeat	MTU
	;	.byte 0
	;.endrep

dmalist:
	;// Enhanced DMA options
	.byte	$0b		;option_0b;
	.byte	$80		;option_80;
dmalist_source_mb:
	.byte	0		;source_mb;
	.byte	$81		;option_81;
dmalist_dest_mb:
	.byte	0		;dest_mb;
	.byte	0		;end_of_options;

	;// F018B format DMA request
	.byte	0		;command; // copy
dmalist_count:
	.word	0		;count;
dmalist_source_addr:
	.word	0		;source_addr;
dmalist_source_bank:
	.byte	0		;source_bank;
dmalist_dest_addr:
	.word	0		;dest_addr;
dmalist_dest_bank:
	.byte	0		;dest_bank;
	.byte	0		;sub_cmd;  // F018B subcmd
	.word	0		;modulo;   // unset in lcopy


; in:		a	byte to send
; destroyed:	x
eth:
	tax
	CmpWI	eth_tx_len, MTU
	beq 	@1		; branch if eth_tx_len bigger or equal MTU
	bcs	@1
	PushW	r0
	LoadW	r0, tx_frame_buf
	AddW	eth_tx_len, r0
	ldy	#0
	txa
	sta	(r0), y
	PopW	r0
@1:	IncW	eth_tx_len
	rts

;*
;* Check if the transceiver is ready to transmit a packet.
;* @return TRUE if a packet can be sent.
;*
; out:		c	set if
eth_clear_to_send:
	lda	$D6E0
	and	#$80
	bne 	@1
	clc
	rts
@1:
	sec
	rts

;**
;* Command the ethernet controller to discard the current frame in the
;* RX buffer.
;* Select next one, if existing.
;*
eth_drop:
	;// Do nothing, as we pop the ethernet buffer off when asking for a frame in
	;// eth_task().
	rts

do_dma:
	LoadB	$d702, 0
	LoadB	$d704, $00		;  // List is in $00xxxxx
	LoadB	$d701, >dmalist
	LoadB	$d705, <dmalist		; // triggers enhanced DMA
	rts

dbg_msg:
	.repeat	80
		.byte	0
	.endrep
sixteenbytes:
	.repeat	16
		.byte	0
	.endrep

;**
;* Ethernet control task.
;* Shall be called when a packet arrives.
;*
;uint8_t
eth_task:	; (uint8_t p)

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

	;*
	;* Check if there are incoming packets.
	;* If not, then check in a while.
	;*
	;unsigned short i;
	;unsigned char j=PEEK(0xD6EF);
	;struct m65_tm tm;

	;unsigned char cpu_side=j&3;
	;unsigned char eth_side=(j>>2)&3;
.if 0
	// Check the RXIRQ flag to see if we have frames waiting or not
	if(!(PEEK(0xD6E1)&0x20)) {
		task_add(eth_task, 10, 0,"ethtask");
		return 0;
		}
.else
	;// XXX Kludge until the Ethernet controller gets updated to have a working
 	;// RX ready flag.
	lda	$D6EF
	tax
	lsr
	lsr
	and	#$03
	sta	@10+1
	txa
	and	#$03

	sec
@10:
	sbc	#$00
	and	#3
	cmp	#3
	bne	@havePkt

	LoadW	r0, eth_task
	LoadB	r1L, 0
	LoadB	r1H, 0
	LoadW	r2, ethtaskName
	jsr	task_add

	jmp	@1000
@havePkt:
.endif
	;// Get next received packet
	;// Just $01 and $03 should be enough, but then packets may be received in triplicate
	;// based on testing in wirekrill. But clearing bit 1 again solves this problem.
	LoadB	$D6E1, $01
	LoadB	$D6E1, $03
	LoadB	$D6E1, $01

	;*
	;* A packet is available.
	;*

	; setup dmalist to receive from ETH_RX_BUFFER
	LoadB	dmalist_source_mb, ETH_RX_BUFFER>>20;
	LoadB	dmalist_source_bank, (ETH_RX_BUFFER>>16) & $0f;
	LoadW	dmalist_source_addr, ETH_RX_BUFFER & $ffff;

	LoadB  	dmalist_dest_mb, 0	; fetching into bank 0
	LoadB	dmalist_dest_bank, 0

	;if (eth_log_mode&ETH_LOG_RX) {
	;	getrtc(&tm);
	;	debug_msg("");
	;	snprintf(dbg_msg,80,"%02d:%02d:%02d/%d eth rx\n",tm.tm_hour,tm.tm_min,tm.tm_sec,PEEK(0xD012));
	;	debug_msg(dbg_msg);
	;	for(i=0;i<2048;i+=16) {
	;		lcopy(ETH_RX_BUFFER+i,(unsigned long)sixteenbytes,16);
	;		snprintf(dbg_msg,80,"  %04x : ",i);
	;		for(j=0;j<16;j++) snprintf(&dbg_msg[strlen(dbg_msg)],80-strlen(dbg_msg)," %02x",sixteenbytes[j]);
	;		debug_msg(dbg_msg);
	;	}
	;}

	;// +2 to skip length and flags field
	LoadW	dmalist_count, ETH_HEADER_SIZE
	LoadB	dmalist_source_addr, 2		; ETH_RX_BUFFER+2L
	LoadW	dmalist_dest_addr, eth_header
	jsr	do_dma
	;lcopy(ETH_RX_BUFFER+2L,(uint32_t)&eth_header, sizeof(eth_header));

	;*
	;* Check destination address.
	;*
	lda	#$FF
	ldx	#6
@chkBroadcast:
	dex
	beq	@processPkt
	cmp	eth_header_destination-1,x
	beq	@chkBroadcast

	; check for local mac
	ldx	#0
@checkLocalMac:
	lda	mac_local, x
	cmp	eth_header_destination,x
	bne	@drop2			; not for us
	inx
	cpx	#6
	bne	@checkLocalMac

@processPkt:
	LoadB	dmalist_source_addr, 2+14		; ETH_RX_BUFFER+2+14

	;*
	;* Address match, check protocol.
	;* Read protocol header.
	;*
	CmpWI	eth_header_type, $0608	; // big-endian for 0x0806
	bne	@checkIP

	;*
        ;* ARP packet.
        ;*
	LoadW	dmalist_count, ARP_HDR_SIZE
	LoadW	dmalist_dest_addr, _header
	jsr	do_dma
        ;lcopy(ETH_RX_BUFFER+2+14,(uint32_t)&_header, sizeof(ARP_HDR));

	jsr	arp_mens

@drop2:
        jmp	@drop

@checkIP:
	CmpWI	eth_header_type, $0008		;// big-endian for 0x0800
	bne	@other

	;*
	;* IP packet.
	;* Verify transport protocol to load header.
	;*
	LoadW	dmalist_count, IP_HDR_SIZE
	LoadW	dmalist_dest_addr, _header
	jsr	do_dma
	;lcopy(ETH_RX_BUFFER+2+14,(uint32_t)&_header, sizeof(IP_HDR));
;update_cache(&_header.ip.source, &eth_header.source);

	LoadB	dmalist_source_addr, 2+14+IP_HDR_SIZE		; ETH_RX_BUFFER+2+14

	LoadW	dmalist_dest_addr, _header+IP_HDR_SIZE

	lda	_header+IP_HDR_PROTO_OFFSET
	cmp	#IP_PROTO_UDP
	bne	@checkTCP

	LoadW	dmalist_count, UDP_HDR_SIZE
	jsr	do_dma
	;lcopy(ETH_RX_BUFFER+2+14+sizeof(IP_HDR),(uint32_t)&_header.t.udp, sizeof(UDP_HDR));

	bra	@ipEnd
@checkTCP:
	cmp	#IP_PROTO_TCP
	bne	@checkICMP

	LoadW	dmalist_count, TCP_HDR_SIZE
	jsr	do_dma
	;lcopy(ETH_RX_BUFFER+2+14+sizeof(IP_HDR),(uint32_t)&_header.t.tcp, sizeof(TCP_HDR));
	bra	@ipEnd
@checkICMP:
	cmp	#IP_PROTO_ICMP
	bne	@unknownIP
	LoadW	dmalist_count, ICMP_HDR_SIZE
	jsr	do_dma
	;lcopy(ETH_RX_BUFFER+2+14+sizeof(IP_HDR),(uint32_t)&_header.t.icmp, sizeof(ICMP_HDR));
	bra	@ipEnd
@unknownIP:
	bra	@drop
@ipEnd:

	jsr	nwk_downstream

@other:
	; printf("Unknown ether type $%04x\n",eth_header.type);

@drop:
	jsr	eth_drop
	;// We processed a packet, so schedule ourselves immediately, in case there
	;// are more packets coming.
	LoadW	r0, eth_task
	LoadB	r1L, 0
	LoadB	r1H, 0
	LoadW	r2, ethtaskName
	jsr	task_add	;// try again to check more packets.
@1000:
	ldx	#0
.if 0
	lda	$2709
	cmp	#$C0
	bne	@HOHO
	lda	r9L
	brk
	@HOHO2:
	lda	#$56
	@HOHO:
.endif
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

;#define IPH(X) _header.ip.X

; in:	r0 - buffer length
;	r1 - buffer address
; destroyed: a, x, y
eth_write:
	ldx	r0L
	ldy	r0H

	AddW	eth_tx_len, r0
	CmpWI	r0, MTU
	beq 	@done		; branch if eth_tx_len bigger or equal MTU
	bcs	@done

  	;lcopy((uint32_t)buf,(unsigned long)&tx_frame_buf[eth_tx_len],len);

	PushW	r2
	stx	r2L		; amount
	sty	r2H
	MoveW	r1, r0 		; src
	LoadW	r1, tx_frame_buf
	AddW	eth_tx_len, r1	; dest
	AddW	r2, eth_tx_len
	jsr	MoveData
	ldy	r2H
	MoveW	r0, r1
	PopW	r2
@done:
	stx	r0L
	sty	r0H
	rts

;**
;* Finish transfering an IP packet to the ethernet controller and start transmission.
;*
eth_packet_send:

	;unsigned short i;
	;unsigned char j;
	;struct m65_tm tm;

	;// Set packet length
	;mega65_io_enable();
	MoveB	eth_tx_len, $D6E2
	LoadB	dblClickCount, 1
@wait2:
	lda	dblClickCount
	bne	@wait2
	MoveB	eth_tx_len+1, $D6E3

	; setup dmalist to send to ETH_TX_BUFFER
	LoadB	dmalist_dest_mb, ETH_TX_BUFFER>>20;
	LoadB	dmalist_dest_bank, (ETH_TX_BUFFER>>16) & $0f;
	LoadW	dmalist_dest_addr, ETH_TX_BUFFER & $ffff;

	LoadB  	dmalist_source_mb, 0	; fetching into bank 0
	LoadB	dmalist_source_bank, 0

	MoveW	eth_tx_len, dmalist_count

	LoadW	dmalist_source_addr, tx_frame_buf
	jsr	do_dma

	;// Copy our working frame buffer to
	;lcopy((unsigned long)tx_frame_buf,ETH_TX_BUFFER,eth_tx_len);

.if 0
	;if (eth_log_mode&ETH_LOG_TX) {
	;	getrtc(&tm);
	;	debug_msg("");
	;	snprintf(dbg_msg,80,"%02d:%02d:%02d/%d eth tx\n",tm.tm_hour,tm.tm_min,tm.tm_sec,PEEK(0xD012));
	;	debug_msg(dbg_msg);
	;	for(i=0;i<eth_tx_len;i+=16) {
	;		snprintf(dbg_msg,80,"  %04x : ",i);
	;		for(j=0;j<16;j++) snprintf(&dbg_msg[strlen(dbg_msg)],80-strlen(dbg_msg)," %02x",tx_frame_buf[i+j]);
	;		debug_msg(dbg_msg);
	;	}
	;}
.endif

.if 0
	;printf("ETH TX: %x:%x:%x:%x:%x:%x\n",
	;	tx_frame_buf[0],tx_frame_buf[1],tx_frame_buf[2],tx_frame_buf[3],tx_frame_buf[4],tx_frame_buf[5]
	;);
.endif

	;// Make sure ethernet is not under reset
	LoadB	$D6E0, $03

	LoadB	dblClickCount, 1
@wait1:
	lda	dblClickCount
	bne	@wait1

	;// Send packet
  	LoadB	$D6E4, $01	; // TX now

	rts


;**
;* Start transfering an IP packet.
;* Find MAC address and send headers to the ethernet controller.
;* @return TRUE if succeeded.
;*
; out: c set if
eth_ip_send:

	;static IPV4 ip;
	;static EUI48 mac;

	jsr	eth_clear_to_send
	bcc	@err2		; // another transmission in progress, fail.

	;*
	;* Check destination IP.
	;*
	MoveW	_header+IP_HDR_DEST_OFFSET, r0
	MoveW	_header+IP_HDR_DEST_OFFSET+2,r1

	CmpWI	r0, $FFFF
	bne	@noBroadcast
	CmpWI	r1, $FFFF
	beq	@mapAddress
@noBroadcast:

	ldx	#0
@10:
	lda	r0, x
	eor	ip_local, x
	and	ip_mask,x
	bne	@useGateway
	inx
	cpx	#4
	bne	@10
	bra	@mapAddress

@useGateway:
	MoveW	ip_gate, r0
	MoveW	ip_gate+2, r1

@mapAddress:
	jsr	query_cache		;// find MAC, r3,r4,r5
	bcs	@20
	jsr	arp_query		;// yet unknown IP, query MAC and fail.
@err2:
	bra 	@err
@20:
	;*
	;* Send ethernet header.
	;*
	LoadW	eth_tx_len, 0

	LoadW	r0, 6
	LoadW	r1, r3
	jsr	eth_write

	LoadW	r0, 6
	LoadW	r1, mac_local
	jsr	eth_write

	lda	#$08			;// type = IP (0x0800)
	jsr	eth
	lda	#$00
	jsr	eth

	;*
	;* Send protocol header.
	;*
	LoadW	r0, 40		;// header size
	lda	_header+IP_HDR_PROTO_OFFSET
	cmp	#IP_PROTO_UDP
	bne	@30
	LoadW 	r0, 28		;// header size udp
@30:
	LoadW	r1, _header
	jsr	eth_write

	;//   printf("eth_ip_send success.\n");
	;return TRUE;
	sec
	rts
@err:
	clc
	rts

;**
;* Send an ARP packet.
;* @param mac Destination MAC address.
;*/
; in: r1 addr of mac buffer (EUI48 *mac)
eth_arp_send:

	lda	$D6E0
	and	#$80
	beq	@done		;// another transmission in progress.

	LoadW	eth_tx_len, 0

	LoadW	r0, 6
	jsr	eth_write
	LoadW	r1, mac_local
	jsr	eth_write

	lda	#$08
	jsr	eth			;// type = ARP (0x0806)
	lda	#$06
	jsr	eth

	;*
	;* Send protocol header.
	;*
	LoadW	r0, ARP_HDR_SIZE
	LoadW	r1, _header
	jsr	eth_write


	;*
	;* Start transmission.
	;*
	jsr	eth_packet_send
@done:
	rts

;**
;* Ethernet controller initialization and configuration.
;*
eth_init:
	jsr	eth_drop

	;*
	;* Setup frame reception filter.
	;*
.if .defined(_PROMISCUOUS)
	lda	$D6E5
	and	#$FE
	sta	$D6E5
.else
	lda	$D6E5
	ora	#$01
	sta	$D6E5
.endif
.ifdef NOCRCCHECK
	lda	$D6E5
	ora	#$02
	sta	$D6E5
.endif

	;// Set ETH TX Phase to 1
	lda	$D6E5
	and	#$F3
	ora	#4
	sta	$D6E5

	;*
	;* Read MAC address from ETH controller
	;*
	; setup dmalist to read from $FFD36E9
	LoadB	dmalist_source_mb, $FFD36E9 >> 20
	LoadB	dmalist_source_bank, ($FFD36E9>>16) & $0f
	LoadW	dmalist_source_addr, $FFD36E9 & $ffff

	LoadB  	dmalist_dest_mb, 0	; fetching into bank 0
	LoadB	dmalist_dest_bank, 0

	LoadW	dmalist_count, 6
	LoadW	dmalist_dest_addr, mac_local
	jsr	do_dma
	;lcopy(0xFFD36E9,(unsigned long)&mac_local.b[0],6);

	;// Reset, then release from reset and reset TX FSM
	LoadB	$D6E0,0
	LoadB	dblClickCount, 1
@wait1:
	lda	dblClickCount
	bne	@wait1
	LoadB	$D6E0,3
	LoadB	dblClickCount, 1
@wait2:
	lda	dblClickCount
	bne	@wait2
	LoadB	$D6E1,3
	LoadB	dblClickCount, 1
@wait3:
	lda	dblClickCount
	bne	@wait3
	LoadB	$D6E1,0
	LoadB	dblClickCount, 1
@wait4:
	lda	dblClickCount
	bne	@wait4

	;// XXX Enable ethernet IRQs?
	rts

;**
;* Disable ethernet controller.
;*/
eth_disable:
	;*
 	;* Wait for any pending activity.
 	;*/
	;; XXX Disable ethernet IRQs?
	rts
