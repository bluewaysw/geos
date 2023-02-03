;#include <stdio.h>

;#include "weeip.h"
;#include "eth.h"
;#include "arp.h"
;#include "dns.h"
;#include "dhcp.h"

;#include "memory.h"
;#include "random.h"

.include "geosmac.inc"
.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"

.include "defs.inc"


.import socket_send
.import socket_connect
.import socket_set_rx_buffer
.import socket_set_callback
.import socket_create
.import socket_release
.import socket_select

.import ip_local
.import ip_dnsserver
.import ip_mask
.import ip_gate
.import mac_local
.import task_add

.export dhcp_configured
.export dhcp_autoconfig


;// Don't request DHCP retries too quickly
;// as the network tick loop may be called
;// very fast during configuration
DHCP_RETRY_TICKS 	=	255

dhcp_configured:
	.byte	0
dhcp_acks:
	.byte	0
dhcp_xid:
	.byte	0, 0, 0, 0

.import ip_broadcast			;///< Subnetwork broadcast address
ip_dhcpserver:
	.byte	0, 0, 0, 0

;// Share data buffer with DNS client to save space
;// NOTE: dns_query must be at least 512 bytes long
.import dns_query
.import dns_buf
dhcp_socket:
	.word	0

dhcprtryName:
	.byte	"dhcprtry", NULL

;void dhcp_send_query_or_request(unsigned char requestP);



dhcp_reply_handler:

	;unsigned int type,len,offset;
	;unsigned int i;
	; offset => r2
	; type = r4L
	; len = r4H
	cmp	#WEEIP_EV_DATA
	beq	@101
	rts
@102b:
	jmp	@100
@101:
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

	MoveW	dhcp_socket, r1
	jsr	socket_select

	lda	r0L
	;// First time it will be the offer.
	;// And actually, that's all we care about receiving.
;// We MUST however, send the ACCEPT message.
;// Checbk that XID matches us
ldx	#0
@21:
	lda	dhcp_xid, x
	cmp	dns_buf+4,x
	bne	@20
	inx
	cpx	#6
	bne	@21
@20:
	cpx	#4
	bcc	@102b	; branch x < #4

	;// Check that MAC address matches us
	ldx	#0
@31:
	lda	dns_buf+$1c,x
	cmp	mac_local,x
	bne	@30
	inx
	cpx	#6
	bne	@31
@30:
	cpx	#6
	bcc	@102b

	;// Check that its a DHCP reply message
	lda	dns_buf
	cmp	#$02
	bne	@102
	lda	dns_buf+1
	cmp	#$01
	bne	@102
	lda	dns_buf+2
	cmp	#$06
	bne	@102
	lda	dns_buf+3
	cmp	#$00
	bne	@102

	;// Ok, its for us. Extract the info we need.

	;// Default mask 255.255.255.0
	LoadB	ip_mask, $FF
	LoadB	ip_mask+1, $FF
	LoadB	ip_mask+2, $FF
	LoadB	ip_mask+3, 0

	;// DNS defaults to the DHCP server, unless specified later in an option
	;// (This is required because although we ask for it in our request,
	;// Fritz Boxes at least seem to not always provide it, even when asked.)
	ldx	#0
	@40:
	lda	dns_buf+20, x
	sta	ip_dnsserver, x
	sta	ip_dhcpserver,x
	inx
	cpx	#4
	bne	@40

	;// Set our IP from BOOTP field
	ldx	#0
@41:
	lda	dns_buf+$10, x
	sta	ip_local,x
	inx
	cpx	#4
	bne	@41

.ifdef DEBUG_DHCP
	;printf("IP is %d.%d.%d.%d\n",ip_local.b[0],ip_local.b[1],ip_local.b[2],ip_local.b[3]);
.endif

	;// Only process DHCP fields if magic cookie is set
	lda	dns_buf+$ec
	cmp	#$63
	bne	@103
	lda	dns_buf+$ed
	cmp	#$82
	bne	@103
	lda	dns_buf+$ee
	cmp	#$53
	bne	@103
	lda	dns_buf+$ef
	cmp	#$63
	beq	@104
@103:
	jmp	@100
@cont2:
	jmp	@cont
@102:
	jmp	@100
@104:
.ifdef DEBUG_DHCP
	printf("Parsing DHCP fields $%002x\n",dns_buf[0xf2]);
.endif
	lda	dns_buf+$f2
	cmp	#$02
	beq	@501
	jmp	@500
@501:
	LoadW	r2, $f0

@loop:
	LoadW	r3, dns_buf
	AddW	r2, r3
	ldy	#0
	lda	(r3),y
	cmp	#$FF		; end of record?
	beq	@cont2
	CmpW	r2, 512
	bcs	@do
	jmp	@cont2
@do:
	ldy	#0
	lda	(r3),y
	bne	@99
	IncW	r2
	jmp	@98
@99:
	sta	r4L

	;// Skip field type
	IncW	r2
	;// Parse and skip length marker
	LoadW	r3, dns_buf
	AddW	r2, r3
	lda	(r3), y
	sta	r4H
	IncW	r2

	;// offset now points to the data field.
	lda	r4L
	cmp	#$01
	bne	@81
	LoadW	r3, dns_buf
	AddW	r2, r3
	ldy	#0
@82:
	lda	(r3), y
	sta	ip_mask, y
	iny
	cpy	#4
	bne	@82
.ifdef DEBUG_DHCP
	;printf("Netmask is %d.%d.%d.%d\n",ip_mask.b[0],ip_mask.b[1],ip_mask.b[2],ip_mask.b[3]);
.endif
	bra	@89
@81:
	cmp	#$03
	bne	@83

	LoadW	r3, dns_buf
	AddW	r2, r3

	ldy	#0
@84:
	lda	(r3), y
	sta	ip_gate, y
	iny
	cpy	#4
	bne	@84

.ifdef DEBUG_DHCP
	;printf("Gateway is %d.%d.%d.%d\n",ip_gate.b[0],ip_gate.b[1],ip_gate.b[2],ip_gate.b[3]);
.endif
	bra	@89
@83:
	cmp	#$06
	bne	@89

	ldy	#0
	LoadW	r3, dns_buf
	AddW	r2, r3
@88:
	lda	(r3), y
	sta	ip_dnsserver, y
	iny
	cpy	#4
	bne	@88

.ifdef DEBUG_DHCP
	;printf("DNS option is %d.%d.%d.%d\n",ip_dnsserver.b[0],ip_dnsserver.b[1],ip_dnsserver.b[2],ip_dnsserver.b[3]);
.endif
@89:
	;// Skip over length and continue
	MoveB	r4H, r3L
	LoadB	r3H, 0
	AddW	r3, r2
	jmp	@loop
@98:
@cont:

	;// Compute broadcast address
	ldx	#0
@85:
	lda	#$FF
	eor	ip_mask, x
	and	#$FF
	ora	ip_local, x
	sta	ip_broadcast, x
	inx
	cpx	#4
	bne	@85

.ifdef DEBUG_DHCP
	;printf("Broadcast is %d.%d.%d.%d\n",ip_broadcast.b[0],ip_broadcast.b[1],ip_broadcast.b[2],ip_broadcast.b[3]);
.endif
	;// XXX We SHOULD send a packet to acknowledge the offer.
	;// It works for now without it, because we start responding to ARP requests which
	;// sensible DHCP servers will perform to verify occupancy of the IP.
.ifdef DEBUG_DHCP
	printf("Sending DHCP ACK\n");
.endif
	lda	#1
	jsr	dhcp_send_query_or_request
	;// Fritz box only sends DHCP ACK, not message type 5, so we just give up
	;// after a couple of goes

	inc	dhcp_acks
	lda	dhcp_acks
	cmp	#2
	beq	@86
	bcc	@86

	LoadB	dhcp_configured, 1

	lda	ip_dnsserver
	ora	ip_dnsserver+1
	ora	ip_dnsserver+2
	ora	ip_dnsserver+3

	MoveW	dhcp_socket, r1
	jsr	socket_release
@86:
	bra	@502
@500:
	cmp	#$05
	bne	@510

	;// Mark DHCP configuration complete, and free the socket
	LoadB	dhcp_configured, 1
.ifdef DEBUG_DHCP
	printf("DHCP configuration complete.\n");
.endif
	MoveW	dhcp_socket, r1
	jsr	socket_release
	bra	@502

@510:

.ifdef DEBUG_DHCP
	printf("Unknown DHCP message\n");
.endif
@502:
@100:
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

dhcp_autoconfig_retry:
	lda	dhcp_configured
	bne	@10
	;// This will automatically re-add us to the list
	lda	#0
	jsr	dhcp_send_query_or_request
	LoadW	r0, dhcp_autoconfig_retry
	LoadW	r1, DHCP_RETRY_TICKS
	LoadW	r2, dhcprtryName
	jsr	task_add
@10:
	rts

; out: carry set dhcp done
dhcp_autoconfig:
	lda	dhcp_configured
	bne	@10

	;// Initially we have seen zero DHCP acks
	LoadB	dhcp_acks, 0

	LoadB	r0L, SOCKET_UDP
	jsr	socket_create
	MoveW	r1, dhcp_socket

	LoadW	r0, dhcp_reply_handler
	jsr	socket_set_callback

	LoadW	r0, dns_buf
	LoadW	r1, DNS_BUF_SIZE
	jsr	socket_set_rx_buffer

	lda	#0
	jsr	dhcp_send_query_or_request

	;// Mark ourselves as not yet having configured by DHCP
	LoadB	dhcp_configured, 0

	;// Schedule ourselves to retransmit DHCP query until we are configured
	LoadW	r0, dhcp_autoconfig_retry
	LoadW	r1, DHCP_RETRY_TICKS
	LoadW	r2, dhcprtryName
	jsr	task_add
@10:
	sec
	rts

; in: requestP
dhcp_send_query_or_request:
	sta	r7L
	;uint16_t dhcp_query_len=0;
	;unsigned char i;
	;IPV4 ip_broadcast;

	MoveW	dhcp_socket, r1
	jsr	socket_select

	ldx	#0
	lda	#$FF
@440:
	sta	ip_broadcast, x
	inx
	cpx	#4
	bne	@440

	MoveW	ip_broadcast, r0
	MoveW	ip_broadcast+2, r1
	LoadW	r2, 67
	jsr	socket_connect

	;// force local port to 68
	;// (reversed byte order for network byte ordering)
	MoveW	dhcp_socket, r8
	ldy	#SOCKET_PORT_OFFSET
	lda	#0
	sta	(r8), y
	iny
	lda	#68
	sta	(r8), y

	;// Now form our DHCP discover message
	;// 16-bit random request ID:

	LoadW	r3, 0

	LoadW	r4, dns_query
	AddW	r3, r4
	ldy	#0
	lda	#$01			; // OP
	sta	(r4), y
	IncW	r3
	IncW	r4
	lda	#$01			; // HTYPE
	sta	(r4), y
	IncW	r3
	IncW	r4
	lda	#$06			; // HLEN
	sta	(r4), y
	IncW	r3
	IncW	r4
	lda	#$00			; // HOPS
	sta	(r4), y
	IncW	r3
	IncW	r4

	;// Transaction ID
	;// PGS Generate a single XID we use across multiple requests, to
	;// avoid race conditions where a reply might always come just as
	;// we have sent of a new request with a different XID.
	;// (I have seen this happen quite a number of times).
	lda	dhcp_xid
	ora	dhcp_xid+1
	ora	dhcp_xid+2
	ora	dhcp_xid+3
	bne	@655
	lda	$D012
	sta	random+1
	jsr	GetRandom

	jsr	GetRandom
	lda	random
	sta	dhcp_xid
	lda	random+1
	sta	dhcp_xid+1
	jsr	GetRandom
	lda	random
	sta	dhcp_xid+2
	lda	random+1
	sta	dhcp_xid+3
@655:
	LoadW	r4, dns_query
	AddW	r3, r4

	ldx	#0
	ldy	#0
@656:
	lda	dhcp_xid, x
	sta	(r4), y
	IncW	r4
	IncW	r3
	inx
	cpx	#4
	bne	@656

	LoadW	r4, dns_query
	AddW	r3, r4
	ldy	#0
	lda	#0			;// SECS since start of request
	sta	(r4), y
	IncW	r3
	IncW	r4
	lda	#0			;// SECS since start of request
	sta	(r4), y
	IncW	r3
	IncW	r4
	lda	#0
	sta	(r4), y
	IncW	r3
	IncW	r4
	lda	#0			;// FLAGS
	sta	(r4), y
	IncW	r3
	IncW	r4

	;// Various empty fields
	ldx	#0
	ldy	#0
	lda	#0			;// FLAGS
@432:
	sta	(r4), y
	iny
	cpy	#16
	bne	@432

	lda	r7L
	beq	@441

	LoadW	r4, dns_query
	AddW	r3, r4

	;// Client IP
	ldy	#0
@451:
	lda	ip_local, y
	sta	(r4), y
	iny
	cpy	#4
	bne	@451

	AddVW	8, r4

	;// Server IP
	ldy	#0
@452:
	lda	ip_dhcpserver, y
	sta	(r4), y
	iny
	cpy	#4
	bne	@452
@441:
	AddVW	16, r3

	;// our MAC address padded to 192 bytes
	LoadW	r4, dns_query
	AddW	r3, r4
	ldy	#0
@453:
	lda	mac_local, y
	beq	@454
	sta	(r4), y
	iny
	cpy	#6
	bne	@453

	lda	#0
@454:
	sta	(r4), y
	iny
	cpy	#16+192
	bne	@454

	AddVW	16+192, r3

	;// DHCP magic cookie
	LoadW	r4, dns_query
	AddW	r3, r4
	ldy	#0
	lda	#$63
	sta	(r4), y
	IncW	r3
	IncW	r4
	lda	#$82
	sta	(r4), y
	IncW	r3
	IncW	r4
	lda	#$53
	sta	(r4), y
	IncW	r3
	IncW	r4
	lda	#$63
	sta	(r4), y
	IncW	r3
	IncW	r4
	lda	#$35
	sta	(r4), y
	IncW	r3
	IncW	r4
	lda	#$01
	sta	(r4), y
	IncW	r3
	IncW	r4

	LoadW	r4, dns_query
	AddW	r3, r4
	;if (requestP)
	lda	r7L
	beq	@803
	ldy	#0
	lda	#$03
	sta	(r4), y		 ;// DHCP request (i.e., client accepting offer)
	IncW	r3
	bra	@804
@803:
	ldy	#0
	lda	#$01
	sta	(r4), y		 ;// DHCP discover
	IncW	r3
@804:
	;// Pad to word boundary
	LoadW	r4, dns_query
	AddW	r3, r4
	IncW	r3
	ldy	#0
	lda	#0
	sta	(r4), y

	lda	r7L
	bne	@618
	jmp	@607
@618:
	;// BOOTP option $32 Confirm IP address
	LoadW	r4, dns_query
	AddW	r3, r4

	ldy	#0
	lda	#$32
	sta	(r4), y
	IncW	r3
	IncW	r4

	lda	#$04
	sta	(r4), y
	IncW	r3
	IncW	r4

	ldx	#0
@801:
	lda	ip_local, x
	sta	(r4), y
	IncW	r3
	IncW	r4
	inx
	cpx	#4
	bne	@801

	;// BOOTP $36 Confirm DHCP server
	lda	#$36
	sta	(r4), y
	IncW	r3
	IncW	r4

	lda	#$04
	sta	(r4), y
	IncW	r3
	IncW	r4

	ldx	#0
@802:
	lda	ip_dhcpserver, x
	sta	(r4), y
	IncW	r3
	IncW	r4
	inx
	cpx	#4
	bne	@802
	jmp	@608
@607:
	;// Request subnetmask, router, domainname, DNS server
	LoadW	r4, dns_query
	AddW	r3, r4

	ldy	#0
	lda	#$37
	sta	(r4), y
	IncW	r3
	IncW	r4

	lda	#$05
	sta	(r4), y
	IncW	r3
	IncW	r4

	lda	#$01
	sta	(r4), y
	IncW	r3
	IncW	r4

	lda	#$03
	sta	(r4), y
	IncW	r3
	IncW	r4

	lda	#$0f
	sta	(r4), y
	IncW	r3
	IncW	r4

	lda	#$06
	sta	(r4), y
	IncW	r3
	IncW	r4

	lda	#$06
	sta	(r4), y
	IncW	r3
	IncW	r4
@608:
	;// End of request
	LoadW	r4, dns_query
	AddW	r3, r4
	ldy	#0
	lda	#$FF
	sta	(r4), y
	IncW	r3
	IncW	r4

	;// Pad out to standard length
@601:
	CmpWI	r3, 512
	;bcs	@600
	beq	@600
	LoadW	r4, dns_query
	AddW	r3, r4
	IncW	r3
	ldy	#0
	lda	#0
	sta	(r4), y
	bra	@601
@600:
	LoadW	r0, dns_query
	MoveW	r3, r1
  	jsr	socket_send
	rts
