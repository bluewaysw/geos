;#include <stdio.h>
;#include <string.h>

;#include "weeip.h"
;#include "eth.h"
;#include "arp.h"
;#include "dns.h"

;#include "memory.h"
;#include "random.h"

.include "geosmac.inc"
.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"

.include "defs.inc"


.import socket_release
.import task_periodic
.import socket_connect
.import ip_dnsserver
.import socket_select
.import socket_set_rx_buffer
.import socket_set_callback
.import socket_create
.import socket_send

.export dns_query
.export dns_buf
.export dns_hostname_to_ip


dns_query_returned:
	.byte	0

dns_return_ip:
	.byte	0, 0, 0, 0

dns_socket:
	.word	0

dns_query:
	.repeat DSN_QUERY_SIZE
		.byte 	0
	.endrep

dns_query_len:
	.word	0
dns_buf:
	.repeat DNS_BUF_SIZE
		.byte	0
	.endrep


; in: r0 ptr to host name to query:
dns_construct_hostname_to_ip_query:
	;unsigned char prefix_position,i;
	;unsigned char field_len;
	; prefix_position => r3L

	;// Now form our DNS query
	;// 16-bit random request ID:
	jsr	GetRandom
	lda	random
	sta	dns_query
	lda	random+1
	sta	dns_query+1
	;// Request flags: Is request, please recurse etc
	LoadB	dns_query+2, $01
	LoadB	dns_query+3, $00
	;// QDCOUNT = 1 (one question follows)
	LoadB	dns_query+4, $00
	LoadB	dns_query+5, $01
	;// ANCOUNT = 0 (no answers follow)
	LoadB	dns_query+6, $00
	LoadB	dns_query+7, $00
	;// NSCOUNT = 0 (no records follow)
	LoadB	dns_query+8, $00
	LoadB	dns_query+9, $00
	;// ARCOUNT = 0 (no additional records follow)
	LoadB	dns_query+10, $00
	LoadB	dns_query+11, $00
	LoadW	dns_query_len, 12

	;// Now convert dotted hostname to DNS field format.
	;// This involves changing each . to the length of the following field,
	;// adding a $00 to the end, and prefixing the whole thing with the
	;// length of the first part.
	;// This is most easily done by reserving the prefix byte first, and whenever
	;// we hit a . or end of string, updating the previous prefix byte.
	MoveB	dns_query_len, r3L
	inc	dns_query_len

	PushW	r0		; hostname
	LoadW	r1, dns_query
	AddW	dns_query_len, r1
	ldy	#0
	sty	r2H
@21:
	lda	(r0), y
	beq	@22
	iny
	bne	@21
@22:
	iny
	sty	r2L
	jsr	MoveData
	PopW	r0
  	LoadB	r3H, 0

	ldx	#0
	ldy	#0
@dnsLoop:
	lda	(r0), y
	;iny
	cmp	#'.'
	beq	@dnsPart
	cmp	#0
	bne	@dnsNext
@dnsPart:
	txa
	ldx	r3L
	sta	dns_query, x
	tax
	inc
	clc
	adc	r3L
	sta	r3L
     	ldx	#0		; field_len = 0
	bra	@33
@dnsNext:
	inx
@33:
	lda	(r0), y
	beq	@34
	iny
	bra	@dnsLoop
@34:
	ldy	r3L
	iny
	sty	dns_query_len
	LoadB	dns_query_len+1, 0

	;// QTYPE = 0x0001 = "A records"
	LoadW	r1, dns_query
	AddW	dns_query_len, r1
	ldy	#0
	lda	#$00
	sta	(r1), y
	iny
	lda	#$01
	sta	(r1), y
	iny
  	;// QCLASS = 0x0001 = "internet addressses
	lda	#$00
	sta	(r1), y
	iny
	lda	#$01
	sta	(r1), y
	AddVW	4, dns_query_len
	rts


dns_reply_handler:

	cmp	#WEEIP_EV_DATA
	beq	@10b
	rts
@10b:
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

	;unsigned int ofs;
	;unsigned char i,j;

	;//  printf("DNS packet seen.\n");

	MoveW	dns_socket, r0
	jsr	socket_select

;// Check that query ID matches
	lda	dns_buf
	cmp	dns_query
	bne	@10a
	lda	dns_buf+1
	cmp	dns_query+1
	bne	@10a

	;// Check that it is a reply
	lda	dns_buf+2
	cmp	#$81
	beq	@20
	cmp	#$85
	bne	@10a
@20:
	;// Check if we have at least one answer
	lda	dns_buf+6
	ora	dns_buf+7
	bne	@30

	;//      printf("DNS response contained no answers.\n");
	bra	@10a
@10a:
	jmp	@10
@30:
	;// Skip over the question text (HACK: Search for first $00 byte)
	LoadW	r1, dns_buf
	AddVW	$0c, r1
	ldy	#0
@31:
	lda	(r1), y
	beq	@40
	IncW	r1
	bra	@31
@40:
	;// Then skip that $00 byte
	IncW	r1

 	;// Skip over query type and class if correct
	lda	(r1), y
	cmp	#$00
	bne	@10a
	IncW	r1
	lda	(r1), y
	cmp	#$01
	bne	@10a
	IncW	r1

	lda	(r1), y
	cmp	#$00
	bne	@10a
	IncW	r1
	lda	(r1), y
	cmp	#$01
	beq	@10c
@10d:
	jmp	@10
@10c:
	IncW	r1

	;// Now we are at the start of the answer section
	;// Assume that answers will be pointers to the name in the query.
	;// For this we look for fixed value $c0 $0c indicating pointer to the name in the query
	lda	(r1), y
	cmp	#$c0
	bne	@10d
	IncW	r1
	lda	(r1), y
	cmp	#$0c
	bne	@10d
	IncW	r1

	;// Check if it is a CNAME, in which case we need to re-issue the request for the
	;// CNAME
	lda	(r1), y
	cmp	#$00
	beq	@11a
@11b:
	jmp	@11
@11a:
	iny
	lda	(r1), y
	cmp	#$05
	bne	@11b
	IncW	r1
	IncW	r1

	;// printf("DNS server responded with a CNAME\n");
	;// Skip TTL and size
	AddVW	8, r1

	;// We should now have len+string tuples following.
	;// So decode those into a hostname string, and resolve that instead
	;// We decode them into place in dns_buf to avoid having a separate buffer
	ldx	#0	;      i=0;
@101:
	;while(dns_buf[ofs]) {
	ldy	#0
	lda	(r1), y
	bne	@100

	cmp	#$C0
	bcc	@102

	;// Expand compressed name pointers
	IncW	r1
	lda	(r1), y
	sta	r1L
	LoadB	r1H, 0
	AddW	dns_buf, r1
@102:
	LoadB	r2L,0		; j in the original
	cpx	#0
	beq	@103
	lda	#'.'
	sta	dns_buf, x
	inx
@103:
	ldy	#0
	lda	(r1), y
	beq	@104
	dec
	sta	(r1), y

	iny
	tya
	clc
	adc	r2L
	tay
	lda	(r1), y
	sta	dns_buf, x
	inx
	inc	r2L
	bne 	@103
@104:
	IncW	r1
	LoadB	r2H, 0
	AddW	r2, r1
	lda	#0
	sta	dns_buf, x
	bra	@101
@100:

	;printf("Resolving CNAME '%s' ...\n",dns_buf);
	LoadW	r0, dns_buf
	jsr	dns_construct_hostname_to_ip_query
	LoadW	r0, dns_query
	MoveW	dns_query_len, r1
	jsr	socket_send
@11:
	;// Then we check that answer type is $00 $01 = "type a"
	ldy	#0
	lda	(r1), y
	cmp	#$00
	bne	@10
	iny
	lda	(r1), y
	cmp	#$01
	bne	@10
	IncW	r1
	IncW	r1
	dey
	;// Then we check that answer class is $00 $01 = "IPv4 address"
	lda	(r1), y
	cmp	#$00
	bne	@10
	iny
	lda	(r1), y
	cmp	#$01
	bne	@10
	IncW	r1
	IncW	r1
	dey
	;// Now we can just skip over the TTL and size, by assuming its a 4 byte
	AddVW	6, r1

	;// IP address
	ldy	#0
	lda	(r1), y
	sta	dns_return_ip, y
	iny
	lda	(r1), y
	sta	dns_return_ip, y
	iny
	lda	(r1), y
	sta	dns_return_ip, y
	iny
	lda	(r1), y
	sta	dns_return_ip, y
	iny
	LoadB	dns_query_returned, 1
@10:
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

;unsigned char offset=0;
;unsigned char bytes=0;
;unsigned char value=0;

;in: r0 - hostname, r1 - ip address ptr
;out: carry - set if
dns_hostname_to_ip:
	;EUI48 mac;
	;unsigned char next_retry,retries;

	;// Check if IP address, and if so, parse directly.
	;offset=0; bytes=0; value=0;

	LoadB	r2L, 0	; value
	ldx	#0	; bytes
	ldy	#0	; offset
@30:
	lda	(r0), y
	beq	@10
	cmp	#'.'
	bne	@11
	lda	r2L
	sta	dns_return_ip,x
	inx
	LoadB	r2L, 0		; restart value with 0
	cpx	#3
	beq	@12
	bcs	@100		; branch if x > 3 and '.' found
@12:
	iny
	bra	@30
 @11:
	cmp	#'0'
	bcc	@10	;// Not a digit or a period, so its not an IP address
	cmp	#'9'
	beq	@13
	bcs	@10
@13:
	lda	r2L
	asl		; by 2
	asl		; by 4
	asl		; by 8
	clc
	adc	r2L
	clc
	adc	r2L
	sta	r2L
	lda	(r0), y
	sec
	sbc	#'0'
	clc
	adc	r2L
	sta	r2L

    	iny
	bra	@30
@10:
	cpx	#3
	bne	@100
	lda	(r0), y
	bne	@100

	lda	r2L
	sta	dns_return_ip, x
	jmp	@done

 @100:
 	PushW	r1
 	PushW	r0
 	LoadB	r0L, SOCKET_UDP
	jsr	socket_create
	MoveW	r1, dns_socket
	LoadW	r0, dns_reply_handler
	jsr	socket_set_callback
	LoadW	r0, dns_buf
	LoadW	r1, DNS_BUF_SIZE
	jsr	socket_set_rx_buffer

	;// Before we get any further, send an ARP query for the DNS server
	;// (or if it isn't on the same network segment, for our gateway.)
	;// to prime things.
	;// XXX Should not be necessary, as it will happen automatically?
	;//  arp_query(&ip_dnsserver);
	;//  arp_query(&ip_gate);
	;// Then wait until we get a reply.
	;//  while((!query_cache(&ip_dnsserver,&mac)) &&(!query_cache(&ip_gate,&mac)) ) {
	;//    task_periodic();
	;//  }
	;//  printf("ARPed");

	MoveW	dns_socket, r1
	jsr	socket_select

	MoveW	ip_dnsserver, r0
	MoveW	ip_dnsserver+2, r1
	LoadW	r2, 53

	lda	r0L
	ora	r0H
	ora	r1L
	ora	r1H
	bne	@999
@999:
	jsr	socket_connect

	PopW	r0
  	jsr	dns_construct_hostname_to_ip_query

	LoadW	r0, dns_query
	MoveW	dns_query_len, r1
  	jsr	socket_send

	PopW	r1

	;// Run normal network state machine
	;// XXX Call-back handlers for other network tasks can still occur
 	LoadB	dns_query_returned, 0

	;// Retry for approx 30 seconds (will be slightly longer on NTSC, as we
	;// time retries based on elapsed video frames).
	LoadB	r2L, 30
	LoadB	dblClickCount, 50
@203:
	lda	dns_query_returned
	bne	@200

	jsr	task_periodic

	;// Detect timeout, and retry for ~30 seconds
	lda	dblClickCount
	bne	@202

	lda	r2L
	bne	@204
	clc
	rts
@204:
	MoveW	dns_socket, r1
	jsr	socket_select

	LoadW	r0, dns_query
	MoveW	dns_query_len, r1
	jsr	socket_send

	dec	r2L
	LoadB	dblClickCount, 50
@202:
	bra	@203
@200:
	MoveW	dns_socket, r1
	jsr	socket_release

@done:
	;// Copy resolved IP address
	ldx	#0
@201:
	lda	dns_return_ip, x
	sta	r0, x
	inx
	cpx	#4
	bne	@201

	sec
	rts
