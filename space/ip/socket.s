;**
;* @file socket.c
;* @brief Socket API implementation.
;* @compiler CC65
;* @author Paul Gardner-Stephen (paul@m-e-g-a.org)
;* derived from:
;* @author Bruno Basseto (bruno@wise-ware.org)
;*

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
;#include <stdio.h>
;#include <stdint.h>
;#include <string.h>
;#include "weeip.h"
;#include "arp.h"
;#include "eth.h"

;#include "random.h"

.include "geosmac.inc"
.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"


.include "defs.inc"

.import id
.import arp_init
.import eth_init
.import nwk_tick
.import nwk_upstream
.import task_add
.import task_cancel

.export _sockets

.export socket_send
.export socket_connect
.export socket_set_rx_buffer
.export socket_set_callback
.export socket_create
.export socket_release
.export socket_select
.export socket_data_size
.export socket_disconnect
.export socket_reset
.export socket_release

.export weeip_init

.import upstreamName
.import nwktickName

;**
;* Socket list.
;*/
_sockets:
	.repeat MAX_SOCKET*SOCKET_SIZE
	.byte	0
	.endrep
;**
;* Socket currently in use.
;*/
_sckt:
	.word	0

;*
;* Local port definitions.
;*
PORT_MIN	=	1024
PORT_MAX	=	4096


port_used:                              ;///< Next port to use.
	.word	0

;**
;* Create and initialize a socket.
;* @param protocol Transport Protocol (SOCKET_TCP or SOCKET_UDP).
;* @return Socket identifier, or NULL if there are no more available sockets.
;*/
; in: r0L, protocol
; out: r1, ptr to created socket or NULL if failed to create one
socket_create:
	;*
	;* Find an unused socket.
	;*/
	LoadW	r1, _sockets
	ldx	#0
@nextSocket:
	ldy	#SOCKET_TYPE_OFFSET
	lda	(r1), y
	cmp	#SOCKET_FREE
	bne	@notFree

	PushB	r0L
	PushW	r1
	LoadW	r0, SOCKET_SIZE
	jsr	ClearRam
	PopW	r1
	PopB	r0L

	;*
	;* Initialize socket structure.
	;*/
	ldy	#SOCKET_TYPE_OFFSET
	lda	r0L
	sta	(r1), y

	ldy	#SOCKET_SEQ_OFFSET_DW
	jsr	GetRandom
	lda	random
	sta	(r1), y
	iny
	lda	random+1
	sta	(r1), y
	iny
	jsr	GetRandom
	lda	random
	sta	(r1), y
	iny
	lda	random+1
	sta	(r1), y
	bra	@done
@notFree:
	AddVW	SOCKET_SIZE, r1
	inx
	cpx	#MAX_SOCKET
	bne	@nextSocket

	LoadW	r1, NULL
@done:
	rts

;**
;* Finish using a socket.
;* @param s Socket identifier.
;*/
; in: r1 socket ptr
; destroy: r0-r2L
socket_release:
	CmpW	r1, NULL
	beq	@done

	LoadW	r0, SOCKET_SIZE
	jsr	ClearRam

@done:
	rts

;**
;* Select a socket for the next operations.
;* @param s Socket identifier.
;*/
; in: r1 socket ptr
socket_select:
	MoveW	r1, _sckt
	rts

;**
;* Setup a reception buffer for the selected socket.
;* @param b Reception buffer to use.
;* @param size Buffer size in bytes.
;*/
; in:  r0 - ptr to buffer, r1 - size of buffer
socket_set_rx_buffer:
	CmpW	_sckt, NULL
	beq	@done
	MoveW	_sckt, r8
	ldy	#SOCKET_RX_OFFSET
	lda	r0L
	sta	(r8), y
	iny
	lda	r0H
	sta	(r8), y
	ldy	#SOCKET_RX_SIZE_OFFSET
	lda	r1L
	sta	(r8), y
	iny
	lda	r1H
	sta	(r8), y
	ldy	#SOCKET_RX_DATA_OFFSET
	lda	#0
	sta	(r8), y
	iny
	sta	(r8), y
	ldy	#SOCKET_RX_OO_START_OFFSET
	sta	(r8), y
	iny
	sta	(r8), y
	ldy	#SOCKET_RX_OO_END_OFFSET
	sta	(r8), y
	iny
	sta	(r8), y
@done:
	rts

;**
;* Setup a callback task for the selected socket.
;* @param c Task for socket management.
;*/
; in: r0 - callback ptr
socket_set_callback:
	CmpW	_sckt, NULL
	beq	@done
	MoveW	_sckt, r8
	ldy	#SOCKET_CALLBACK_OFFSET
	lda	r0L
	sta	(r8), y
	iny
	lda	r0H
	sta	(r8), y
@done:
	rts

;**
;* Put the socket to listen at the specified port.
;* @param p Listening port.
;* @return TRUE if succeed.
;*/
; in: r0 - port to listen on
; out: carry set on success, socket is (or was already) active
socket_listen:
	CmpW	_sckt, NULL
	beq	@err
	MoveW	_sckt, r8

	ldy	#SOCKET_TYPE_OFFSET
	lda	(r8), y
	cmp	#SOCKET_TCP
	bne	@udp

	ldy	#SOCKET_STATE_OFFSET
	lda	(r8), y
	cmp	#_IDLE
	bne	@done
	lda	#_LISTEN
	sta	(r8), y
	bra	@setup
@udp:
	ldy	#SOCKET_STATE_OFFSET
	lda	#_CONNECT
	sta	(r8), y
@setup:
	ldy	#SOCKET_PORT_OFFSET
	lda	r0H
	sta	(r8), y
	iny
	lda	r0L
	sta	(r8), y
	ldy	#SOCKET_LISTEN_OFFSET
	lda	#$FF
	sta	(r8), y
@done:
	sec
	rts
@err:
	clc
	rts

;**
;* Ask for a connection to a remote socket.
;* @param a Destination host IP address.
;* @param p Destination port.
;* @return TRUE if succeeded.
;*
; in: r0,r1 - IPV4, r2 - port
; out: carry set on success
socket_connect:
	;*
	;* Check socket availability.
	;*
	CmpW	_sckt, NULL
	bne	@1
	jmp	@err
@1:
	MoveW	_sckt, r8

	ldy	#SOCKET_TYPE_OFFSET
	lda	(r8), y
	cmp	#SOCKET_TCP
	bne	@10
	ldy	#SOCKET_STATE_OFFSET
	lda	(r8), y
	cmp	#_IDLE
	beq	@10
	jmp	@err

@10:
	;*
	;* Select a local port number.
	;*
	ldy	#SOCKET_PORT_OFFSET
	lda	port_used+1
	sta	(r8), y
	iny
	lda	port_used
	sta	(r8), y

	CmpW	port_used, PORT_MAX
	bne	@20
	LoadW	port_used, PORT_MIN
	bra	@30
@20:
	IncW	port_used
@30:
	ldy	#SOCKET_REMIP_OFFSET
	ldx	#0
@31:
	lda	r0, x
	sta	(r8), y
	iny
	inx
	cpx	#4
	bne	@31

	ldy	#SOCKET_REMPORT_OFFSET
	lda	r2H
	sta	(r8), y
	iny
	lda	r2L
	sta	(r8), y

	ldy	#SOCKET_TYPE_OFFSET
	lda	(r8) ,y
	cmp	#SOCKET_UDP
	bne	@40

	;*
	;* UDP socket.
	;* No connection procedure needed.
	;*/
	ldy	#SOCKET_STATE_OFFSET
	lda	#_CONNECT
	sta	(r8), y
	bra	@done
@40:
	;*
	;* TCP socket.
	;* Force sending SYN message.
	;*/
	ldy	#SOCKET_STATE_OFFSET
	lda	#_SYN_SENT
	sta	(r8), y
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#SYN
	sta	(r8), y
	ldy	#SOCKET_RETRY_OFFSET
	lda	#RETRIES_TCP
	sta	(r8), y

	LoadW	r0, nwk_upstream
	jsr	task_cancel
	LoadB	r1L, 0
	LoadB	r1H, 0
	LoadW	r2, upstreamName
	jsr	task_add
@done:
	sec
	rts
@err:
	clc
	rts

;**
;* Ask for data transmission to the peer.
;* @param data Buffer for the data message.
;* @param size Buffer size in bytes.
;* @return TRUE if succeeded.
;*/
; in: r0 - ptr to data buffer, r1 - size of data buffer
; out: carry, set if success
socket_send:
	CmpW	_sckt, NULL
	beq	@err

	ldy	#SOCKET_STATE_OFFSET
	MoveW	_sckt, r8
	lda	(r8), y
	cmp	#_CONNECT
	bne	@err

	;// Check if we still have un-acknowledged data, and
	;// if so, return failure
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	(r8), y
	and	#PSH
	bne	@err

	ldy	#SOCKET_TYPE_OFFSET
	lda	(r8), y
	cmp	#SOCKET_TCP
	bne	@10

	ldy	#SOCKET_STATE_OFFSET
	lda	#_ACK_WAIT
	sta	(r8), y
@10:
	ldy	#SOCKET_TX_OFFSET
	lda	r0L
	sta	(r8), y
	iny
	lda	r0H
	sta	(r8), y
	ldy	#SOCKET_TX_SIZE_OFFSET
	lda	r1L
	sta	(r8), y
	iny
	lda	r1H
	sta	(r8), y
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#ACK|PSH
	sta	(r8), y
	ldy	#SOCKET_RETRY_OFFSET
	lda	#RETRIES_TCP
	sta	(r8), y
	LoadW	r0, nwk_upstream
	jsr	task_cancel
	LoadB	r1L, 0
	LoadB	r1H, 0
	LoadW	r2, upstreamName
	jsr	task_add
	sec
	rts
@err:
	clc
	rts

;**
;* Returns the amount of data available for reading in bytes.
;*/
; out: r0 - data size
socket_data_size:

	CmpW	_sckt, NULL
	beq	@err
	MoveW	_sckt, r8
	ldy	#SOCKET_RX_DATA_OFFSET
	lda	(r8), y
	sta	r0L
	iny
	lda	(r8), y
	sta	r0H

	sec
	rts
@err:
	clc
	rts

;**
;* Ask for socket disconnection.
;* @return TRUE if succeeded.
;*/
; out: carry set if succeeded
socket_disconnect:
	CmpW	_sckt, NULL
	beq	@err
	MoveW	_sckt, r8

	ldy	#SOCKET_TYPE_OFFSET
	lda	(r8), y
	cmp	#SOCKET_UDP
	bne	@10
	;*
	;* UDP socket.
	;* No disconnection procedure.
	;*
	ldy	#SOCKET_STATE_OFFSET
	lda	#_IDLE
	sta	(r8), y
	bra	@done
@10:
	;*
	;* TCP socket.
	;* Start sending FIN message.
	;*/
	;printf("TCP close\n");

	ldy	#SOCKET_STATE_OFFSET
	lda	(r8), y
	cmp	#_CONNECT
	;bne	@err

	ldy	#SOCKET_STATE_OFFSET
	lda	#_FIN_SENT
	sta	(r8), y
	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#FIN | ACK
	sta	(r8), y
	ldy	#SOCKET_RETRY_OFFSET
	lda	#RETRIES_TCP
	sta	(r8), y

	LoadW	r0, nwk_upstream
	jsr	task_cancel
	LoadB	r1L, 0
	LoadB	r1H, 0
	LoadW	r2, upstreamName
	jsr	task_add
@done:	sec
	rts

@err:	clc
	rts

;**
;* Reset a socket, possibly sending a RST message.
;*/
socket_reset:
	CmpW	_sckt, NULL
	beq	@done
	MoveW	_sckt, r8
	ldy	#SOCKET_TYPE_OFFSET
	lda	(r8), y
	cmp	#SOCKET_TCP
	bne	@done
	ldy	#SOCKET_STATE_OFFSET
	lda	(r8), y
	cmp	#_IDLE
	beq	@10

	ldy	#SOCKET_TO_SEND_OFFSET
	lda	#RST
	sta	(r8), y
	LoadW	r0, nwk_upstream
	jsr	task_cancel
	LoadB	r1L, 0
	LoadB	r1H, 0
	LoadW	r2, upstreamName
	jsr	task_add
@10:
	ldy	#SOCKET_STATE_OFFSET
	lda	#_IDLE
	sta	(r8),y
@done:	rts

;**
;* Network system initialization.
;*/
weeip_init:
	LoadW	r0, SOCKET_SIZE*MAX_SOCKET
	LoadW	r1, _sockets
	jsr	ClearRam
	LoadW	_sckt, _sockets

	lda	$D012
	sta	random+1

	jsr	GetRandom
	MoveW	random, r0
	LoadW	r1, PORT_MAX - PORT_MIN + 1
	ldx	#r0
	ldy	#r1
	jsr	Ddiv

	MoveW	r8, r0
	AddVW	PORT_MIN, r0
	MoveW	r0, port_used

	jsr	GetRandom
	jsr	GetRandom
	jsr	GetRandom
	jsr	GetRandom
	MoveW	random, id

	LoadW	r0, nwk_tick
	LoadB	r1L, TICK_TCP
	LoadB	r1H, 0
	LoadW	r2, nwktickName
	jsr	task_add
	jsr	eth_init
	jsr	arp_init
	rts
