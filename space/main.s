.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"
.include "geosmac.inc"
.include "diskdrv.inc"

.include "ip/defs.inc"

.export __STARTUP_RUN__

.export fileRequestBuf

.import eth_init
.import weeip_init
.import dhcp_configured
.import dhcp_autoconfig
.import task_periodic
.import task_add
.import task_cancel
.import eth_task
.import dns_hostname_to_ip

.import socket_create
.import socket_connect
.import socket_set_rx_buffer
.import socket_set_callback
.import socket_select
.import socket_send
.import socket_data_size
.import socket_disconnect
.import socket_reset
.import socket_release

.import dns_buf
.import dns_timeout

.export oldAppMain

.segment "STARTUP"


INIT_STATE_FRESH	=	0
INIT_STATE_MOUSE	=	1
INIT_STATE_DOWNLOAD	=	2


initState:
	.byte	INIT_STATE_FRESH

guid:
	.repeat	16
		.byte	0
	.endrep
setid:
	.repeat	16
		.byte	0
	.endrep


savedFirstBlock:
	.word	0

LINE_BUF_SIZE	=	256

DL_STATE_IDLE	=	0
DL_STATE_INIT	=	1
DL_STATE_DHCP	=	2
DL_STATE_DNS	=	3
DL_STATE_HTTP	=	4

HTTP_STATE_IDLE		=	0
HTTP_STATE_REQUEST	=	1
HTTP_STATE_HEADER	=	2
HTTP_STATE_BODY		=	3
HTTP_STATE_ERROR	=	4
HTTP_STATE_REDIRECT	=	5
HTTP_STATE_COMPLETE	=	6
HTTP_STATE_CONNECT	=	7

__STARTUP_RUN__:

	LoadB	dispBufferOn, ST_WR_FORE
	LoadW	RecoverVector, MyRecover

	lda	firstBoot
	cmp	#$FF
	bne	@bootTime
	jmp	NormalStart

@bootTime:
	LoadW	r0, $5000
	LoadW	r1, 0
	LoadW	r2, $3000
	LoadB	r3L, 0
	jsr	StashRAM

.if 1

	MoveW	$8400+1, savedFirstBlock
	CmpBI	initState, INIT_STATE_FRESH
	beq	@fresh
	sei
	jsr	InstallFirstInput
	cli
	jmp	@initDownload

@fresh:
	LoadW	r0, WelcomeDialog
	jsr	DoDlgBox

	LoadW	r1, joystickFN
	CmpBI	r0L, OK
	beq	@mouse
	LoadW	r1, mouseFN
@mouse:
	jsr	MakeFirstInput

	; generate UUID
	; determin Set ID
	LoadB	initState, INIT_STATE_MOUSE
	jsr	SaveState

@initDownload:
	jsr	CountMissingFiles		; -> r0
	LoadW	r1, (bootstrapTableEnd - bootstrapTable) / 5
	MoveW	r0, total_count

	lda	r0L
	ora	r0H
	bne	@filesMissing
	jmp	@noMissingFiles
@filesMissing:
	MoveB	r0L, missing_count
	MoveB	r1L, distro_count
	LoadW	r0, CheckDialog
	jsr	DoDlgBox

	CmpBI	r0L, YES
	beq	@checkLicense
	jmp	@noDownload

@checkLicense:
	LoadW	r0, CheckLicenseDialog
	jsr	DoDlgBox

	CmpBI	r0L, YES
	beq	@runDownload
	jmp	@cancelled

@runDownload:
	LoadW	intTopVector, MyInt

	cli
	MoveW	appMain, oldAppMain
	LoadW	appMain, runDownload
	LoadW	r0, DownloadDialog
	jsr	DoDlgBox
	MoveW	oldAppMain, appMain


	jsr	cancelDownload		; call in any case, just in case

	lda	r0L
	cmp	#OK
	beq	@showSuccess
@cancelled:
	LoadW	a0, CancelledResultString
	jmp	@showResult

@showSuccess:
	LoadW	a0, SuccessResultString
@showResult:
	; count for missing files again
	jsr	CountMissingFiles		; -> r0
	LoadW	r1, (bootstrapTableEnd - bootstrapTable) / 5
	MoveW	r0, total_count

	MoveW	r0, a1
	MoveW	r1, a2

	LoadW	r0, ResultDialog
	jsr	DoDlgBox

@noDownload:
@noMissingFiles:
	LoadB	initState, INIT_STATE_DOWNLOAD
	jsr	SaveState

	sec
	LoadW	intTopVector, InterruptMain
	cli
.endif

@finishDialog:
@10:
	LoadW	r0, $5000
	LoadW	r1, 0
	LoadW	r2, $3000
	LoadB	r3L, 0
	jsr	FetchRAM

	jmp	EnterDeskTop

joystickFN:
	.byte	"JOYSTICK", NULL
mouseFN:
	.byte	"MEGA 1351", NULL

NormalStart:
	LoadW	r0, Welcome2Dialog
	jsr	DoDlgBox

	jmp	EnterDeskTop


SaveState:
	MoveW	savedFirstBlock, r1
	LoadW	r4,$8000
	jsr	GetBlock

	ldx	#0
@loop:
	lda	initState,x
	sta	$8002,x
	inx
	cpx	#16+16+1
	bne	@loop
	jsr	PutBlock	
	rts
MyInt:
	lda	requestTimeout
	ora	requestTimeout+1
	beq	@10
	DecW	requestTimeout
@10:
	lda	downloadTimeout
	ora	downloadTimeout+1
	beq	@20
	DecW	downloadTimeout
@20:
	lda	dns_timeout
	ora	dns_timeout+1
	beq	@30
	DecW	dns_timeout
@30:
	jmp	InterruptMain

MyRecover:
	jmp	Rectangle

DownloadingString:
	.byte 	BOLDON, "Downloading file ", NULL
OfString:
	.byte 	" of ", NULL
DownEndString:
	.byte 	":", PLAINTEXT, NULL
ErrorCountString:
	.byte	"Failed files: ", NULL
FileProgressString:
	.byte	"  -  ", NULL
KBytesString:
	.byte	" KByte", NULL

FirstRetryString:
	.byte	" (2nd try)", NULL
SecondRetryString:
	.byte	" (3rd try)", NULL
printProgress:
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
PushW	r10
PushW	r11
PushW	r12
PushW	r13
PushW	r14
PushW	r15

	LoadW	r11, %1011101100000000 | ((-(117)) & $FF)
	LoadB	r1H, (-40) & $FF
	LoadW	r0, DownloadingString
	jsr	PutString

	MoveB	file_count, r0L
	LoadB	r0H, 0

	CmpW	r0, total_count
	beq	@useTotal
	IncW	r0
@useTotal:
	lda	#SET_SURPRESS|SET_LEFTJUST
	jsr	PutDecimal

	LoadW	r0, OfString
	jsr	PutString

	MoveW	total_count, r0
	lda	#SET_SURPRESS|SET_LEFTJUST
	jsr	PutDecimal

	LoadW	r0, DownEndString
	jsr	PutString
	LoadW	r0, emptyString
	jsr	PutString

	LoadW	r11, %1011101100000000 | ((-(117)) & $FF)
	LoadB	r1H, (-20) & $FF
	MoveW	current_name, r0
	jsr	PutString
	
	LoadW	r0, FileProgressString
	jsr	PutString
	MoveW	kbytes, r0
	lda	#SET_SURPRESS|SET_LEFTJUST
	jsr	PutDecimal
	LoadW	r0, KBytesString
	jsr	PutString

	ldx	retry_count
	beq	@noRetry
	LoadW	r0, FirstRetryString
	cpx	#1
	beq	@showRetry
	LoadW	r0, SecondRetryString
@showRetry:
	jsr	PutString

@noRetry:
	LoadW	r0, emptyString
	jsr	PutString

	LoadW	r11, %1011101100000000 | ((-(117)) & $FF)
	LoadB	r1H, (20) & $FF
	LoadW	r0, ErrorCountString
	jsr	PutString
	LoadB	r0H, 0
	MoveB	error_count, r0L
	lda	#SET_SURPRESS|SET_LEFTJUST
	jsr	PutDecimal

	LoadW	r0, emptyString
	jsr	PutString
PopW	r15
PopW	r14
PopW	r13
PopW	r12
PopW	r11
PopW	r10
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

runDownload:
	jsr	task_periodic
	LoadB	dblClickCount, 1
@21:
	lda	dblClickCount
	bne	@21

	CmpBI	downloadState, DL_STATE_DHCP
	bne	@100b

	lda	dhcp_configured
	bne	@11
	jmp	@10
@11:
	; DHCP completed
	lda	#$FF
	LoadW	r0, hostName
	LoadW	r1, hostIP

	jsr	dns_hostname_to_ip
	LoadB	retry_count, 0
	LoadB	downloadState, DL_STATE_DNS
	jmp	@10

@100b:
	CmpBI	downloadState, DL_STATE_DNS
	bne	@100

	jsr	dns_run
	bcc	@dns_done	; still active, 
	rts

@dns_done:
	jsr	dns_result

	MoveW	r0, ip_address
	MoveW	r1, ip_address + 2

	LoadB	a2L, 0

	LoadB	error_count, 0
	LoadB	success_count, 0
	LoadB	downloadState, DL_STATE_HTTP

	; get next file

	jsr	downloadGetRequest

	php
	sei
	LoadW	downloadTimeout, 50*30
	plp

	jmp	@10
@100:
	CmpBI	downloadState, DL_STATE_INIT
	bne	@101
	dec	initCounter
	beq 	@104
	rts
@104:
	; start DHCP
	;// Do DHCP auto-configuration
	LoadB	downloadState, DL_STATE_DHCP
	LoadB	dhcp_configured, 0
	;printf("Configuring network via DHCP\n");

	jsr	dhcp_autoconfig
	jmp	@10
@101:
	CmpBI	downloadState, DL_STATE_HTTP
	beq	@102b
	rts
@102b:
	lda	requestComplete
	bne 	@101b

	; check timeout
	lda	downloadTimeout
	ora	downloadTimeout+1
	bne	@101c

	jsr	requestCancel

	; retry the request
	lda	retry_count
	cmp	#3
	bne	@101d

	inc	error_count
	jmp	@101b

@101d:	
	inc	retry_count
	dec	a2L	; retry the last file

	MoveW	ip_address, r0
	MoveW	ip_address + 2, r1

	jsr	downloadGetRequest
	php
	sei
	LoadW	downloadTimeout, 50*30
	plp
	jmp	@10
@101c:
	jsr	runRequest
	jmp	@10
@101b:
	inc	file_count
	LoadB	retry_count, 0

	MoveW	ip_address, r0
	MoveW	ip_address + 2, r1

	jsr	downloadGetRequest
	php
	sei
	LoadW	downloadTimeout, 50*30
	plp
	bcc	@10		; request issued
	
	; no more files
	LoadB	sysDBData, OK
	jmp	RstrFrmDialogue

@102:
@10:
	rts
cancelDownload:

	; cancel cleanup not implemented yet
	; DL_STATE_DHCP
	; DL_STATE_DNS
	; DL_STATE_HTTP
	; DL_STATE_INIT

	rts

downloadGetRequest:
	lda	a2L
	cmp	#(bootstrapTableEnd - bootstrapTable) / 5
	bne	@ok
	jmp	@err
@ok:
	LoadW	a3, 0
	lda	a2L
	asl
	rol	a3H
	asl
	rol	a3H
	clc
	adc	a2L
	sta	a3L
	lda	a3H
	adc	#0
	sta	a3H
	clc
	lda	#<bootstrapTable
	adc	a3L
	sta	a3L
	lda	#>bootstrapTable
	adc	a3H
	sta	a3H
	ldy	#0
	lda	(a3), y
	sta	r2L
	iny
	lda	(a3), y
	sta	r2H

	iny
	lda	(a3), y
	sta	r6L
	iny
	lda	(a3), y
	sta	r6H
	iny
	lda	(a3), y
	sta	a9L
	iny
	MoveW	r6, current_name

	MoveW	r6, r7
	PushW	r1
	PushW	r6
	jsr	FindFile
	PopW	r6
	PopW	r1
	txa
	bne	@doIt	
	jmp	@findNext
@doIt:
	LoadW	kbytes, 0

	jsr	printProgress

	; send http GET request
	ldy	#0
@nextChar:
	lda	(r2),y
	beq	@get
	iny
	jmp	@nextChar
@get:
	sty	r3L
	LoadB	r3H, 0
	;PushW	r0
	;PushW	r1
	jsr	HTTP_GET
	inc	a2L
@done:
	clc
	rts
@findNext:
	inc	a2L
	lda	a2L
	cmp	#(bootstrapTableEnd - bootstrapTable) / 5
	beq	@err
	jsr	downloadGetRequest
	php
	sei
	LoadW	downloadTimeout, 50*60*3
	plp
	rts
@err:
	sec
	rts

startDownload:
	; correct text clipping, workaround for kernel bug?
	DecW	rightMargin

	LoadW	appMain, runDownload
	LoadW	intTopVector, MyInt

prepare_network:

	;// Setup WeeIP

	jsr	weeip_init
	LoadW	r0, eth_task
	jsr	task_cancel
	LoadB	r1L, 0
	LoadB	r1H, 0
	LoadW	r2H, ethName
	jsr	task_add

	;LoadB	dblClickCount, 250
@22:
	;lda	dblClickCount
	;bne	@22
	
	LoadB	downloadState, DL_STATE_INIT
	LoadB	initCounter, 250
	rts

runRequest:
	CmpBI	http_state, HTTP_STATE_CONNECT
	bne	@11
	lda	http_connected
	bne	@connected

	lda	requestTimeout
	ora	requestTimeout+1
	bne	@14

	CmpBI	requestRetry, 12	; aprox 2 min max
	bne	@13
	jmp	@connect_timeout
@14:
	jmp	@10
@13:
	inc	requestRetry

	jsr	socket_reset
	MoveW	a0, r0
	MoveW	a1, r1
	LoadW	r2, 80
	jsr	socket_connect

	php
	sei
	LoadW	requestTimeout, 50*10
	plp
	rts
@connect_timeout:
	jsr	socket_disconnect
	MoveW	http_socket, r1
	jsr	socket_release
	ldx	#10
	LoadB	http_state, HTTP_STATE_IDLE
	jmp	@10

@connected:
	LoadB	http_state, HTTP_STATE_IDLE
	lda	requestRedirect
	bne	@redir
	jmp	doSendRequest
@redir:	
	jmp 	doSendRequestRedirect
@11:	CmpBI	http_state, HTTP_STATE_REQUEST
	bne	@12
	; handle timeout here
	lda	requestTimeout
	ora	requestTimeout+1
	beq 	@16
	jmp	@10
@16:
	jsr	socket_disconnect
	MoveW	http_socket, r1
	jsr	socket_release

	LoadB	http_state, HTTP_STATE_IDLE
	ldx	#TIMEOUT_ERR
	jmp	@10


@12:	CmpBI 	http_state, HTTP_STATE_REDIRECT
	bne	@15
	;inc	$D020

	MoveW	http_socket, r1
	jsr	socket_disconnect
	;MoveW	http_socket, r1
	;jsr	socket_reset
	MoveW	http_socket, r1
	jsr	socket_release

	MoveW	ip_address, r0
	MoveW	ip_address+2, r1
	LoadW	r2, 0
	LoadW	r3, 0
	jsr	HTTP_GET
	rts
@15:
	CmpBI	http_state, HTTP_STATE_COMPLETE
	bne	@10

	MoveW	http_socket, r1
	jsr	socket_disconnect
	;MoveW	http_socket, r1
	;jsr	socket_reset
	MoveW	http_socket, r1
	jsr	socket_release

	; file downloaded successful?
	LoadW	r6, tempName2
	jsr	ConvertCVT
	cpx	#0
	beq	@done
	; cleanup remove temp file
	txa
	pha
	LoadW	r0, tempName2
	jsr	DeleteFile
	pla
	tax
@done:
	LoadB	requestComplete, $FF

@10:
	rts

requestCancel:

	MoveW	http_socket, r1
	jsr	socket_disconnect
	;MoveW	http_socket, r1
	;jsr	socket_reset
	MoveW	http_socket, r1
	jsr	socket_release
@10:
	rts

; input:
;   r0,r1 up address to connect to
;   r2 = address of file name or URL (for re-direct)
;   r3 = length of file name
;   a9L = Folder number
; output:
;   x = result code, 0 is success (and file has been created)
HTTP_GET:
	;PushW	r2
	;PushW	r3

	MoveW 	r2, requestFileName
	MoveW	r3, requestFileNameLen

	PushW	r0
	PushW	r1

	LoadB	requestComplete, 0
	LoadB	requestRedirect, 0

	LoadW	r0, tempName2
	jsr	DeleteFile
	; ignore error

	LoadB	http_state, HTTP_STATE_IDLE
	LoadB	http_line_buf_pos, 0
	LoadB	http_redirect, 0
	lda	r2L
	ora	r2H
	bne	@10
	LoadB	requestRedirect, $FF

@10:
	LoadB	http_connected, 0
	LoadW	download_count, 1
	LoadB	download_pos, 2
	LoadW	download_packets, 0
	LoadW	download_packets2, 0
	LoadW	r3, 0		; lookup next free block from beginning
	jsr	SetNextFree
	cpx	#0
	beq	@gotBlock
	jmp	@err
@gotBlock:
	IncW	download_count
	MoveW	r3, download_block
	MoveW	r3, download_first

	LoadB	r0L, SOCKET_TCP
	jsr	socket_create
	MoveW	r1, http_socket

	jsr	socket_select

	LoadW	r0, HTTP_GET_callback
	jsr	socket_set_callback

	LoadW	r0, $5500
	LoadW	r1, 2048
	jsr	socket_set_rx_buffer

	PopW	r1
	PopW	r0
	MoveW	r0, a0
	MoveW	r1, a1
	LoadW	a8, 0
@reconn:
	LoadW	r2, 80
	jsr	socket_connect

	LoadB	http_state, HTTP_STATE_CONNECT
	php
	sei
	LoadW	requestTimeout, 50*10
	LoadB	requestRetry, 0
	plp

	rts
@err:
	LoadB	requestComplete, $FF
	rts

.if 0
	; wait to be connected
	ldx	#50
	ldy	#10
@20:	dex
	bne	@20a
	ldx	#50
	dey
	bne	@20a
	jsr	socket_reset
	MoveW	a0, r0
	MoveW	a1, r1
	jmp	@reconn
@20a:
	lda	http_connected
	bne	@10
	txa
	pha
	tya
	pha
	jsr	task_periodic
	pla
	tay
	pla
	tax
	LoadB	dblClickCount, 1
@21:
	lda	dblClickCount
	bne	@21

	; timeout
	IncW	a8
	CmpWI	a8, 50*120	; 2 min
	bne 	@20

	jsr	socket_disconnect
	MoveW	http_socket, r1
	jsr	socket_release
	ldx	#TIMEOUT_ERR
	jmp	@err
@10:
.endif

doSendRequest:
	LoadB	http_state, HTTP_STATE_REQUEST

	; construct request
	LoadW	r7, 0
	
	; get get
	jsr	i_MoveData
	.word	fileRequestPrefix		; from
	.word	fileRequestBuf
	.word	fileRequestPrefixEnd - fileRequestPrefix
	LoadW	r0, fileRequestPrefixEnd - fileRequestPrefix 
	AddW	r0, r7

	LoadW	r0, fileRequestBuf
	AddW	r7, r0
	MoveW	r0, @locationTo
	; get location
	jsr	i_MoveData
	.word	fileRequestLocation
@locationTo:
	.word	0
	.word	fileRequestLocationEnd - fileRequestLocation
	LoadW	r0, fileRequestLocationEnd - fileRequestLocation 
	AddW	r0, r7

	;PopW	r3
	;PopW	r2
	MoveW	requestFileName, @nameFrom
	MoveW	requestFileNameLen, @fromNameSize
	LoadW	r0, fileRequestBuf
	AddW	r7, r0
	MoveW	r0, @nameTo
	AddW	requestFileNameLen, r7
	; add name
	jsr	i_MoveData
@nameFrom:
	.word	fileRequestSuffix
@nameTo:
	.word	0
@fromNameSize:
	.word	0

	LoadW	r0, fileRequestBuf
	AddW	r7, r0
	MoveW	r0, @suffixTo
	; get suffix
	jsr	i_MoveData
	.word	fileRequestSuffix
@suffixTo:
	.word	0
	.word	fileRequestSuffixEnd - fileRequestSuffix
	LoadW	r0, fileRequestSuffixEnd - fileRequestSuffix
	AddW	r0, r7

	; connected, send request
	LoadW	r0, fileRequestBuf
	MoveW	r7, r1		; request len
	
	LoadW	a8, 0
	jsr	socket_send


	php
	sei
	LoadW	requestTimeout, 50*60 ; wait aprox 1 mins without data
	LoadB	requestRetry, 0
	plp

	rts

.if 0
@30:
	jsr	task_periodic
	LoadB	dblClickCount, 1
@31:
	lda	dblClickCount
	bne	@31

	IncW	a8
	CmpWI	a8, 50*60	; wait aprox 1 mins without data
	bne	@_33b

	;inc	$D020

	jsr	socket_disconnect
	MoveW	http_socket, r1
	jsr	socket_release

	ldx	#TIMEOUT_ERR
	jmp	@err
@_33b:
	CmpBI	http_state, HTTP_STATE_REQUEST
	beq	@30
	CmpBI	http_state, HTTP_STATE_REDIRECT
	beq	@_33
	jmp	@33
@_33:

doSendRequestRedirect:
	lda	#$71

	LoadW	r5, http_line_buf + (httpLocationHeaderEnd-httpLocationHeader)
	LoadW	r6, httpDomain
	ldx	#r5
	ldy	#r6
	lda	#<(httpDomainEnd - httpDomain)
	jsr	CmpFString

	;MoveW	http_socket, r1
	;jsr	socket_reset

	MoveW	http_socket, r1
	jsr	socket_release

	LoadB	http_line_buf_pos, 0
	LoadB	http_connected, 0

	LoadB	http_state, HTTP_STATE_REQUEST


	LoadB	r0L, SOCKET_TCP
	jsr	socket_create
	MoveW	r1, http_socket
	jsr	socket_select
	
	LoadW	r0, HTTP_GET_callback
	jsr	socket_set_callback

	LoadW	r0, $5500
	LoadW	r1, 2048
	jsr	socket_set_rx_buffer
	LoadW	a8, 0
@_reconn:
	MoveW	a1, r1		; same IP address as the original request
	MoveW	a0, r0
	LoadW	r2, 80
	jsr	socket_connect



	; wait to be connected
	ldx	#50
	ldy	#10
@_20:	dex
	bne	@_20a
	ldx	#50
	dey
	bne	@_20a
	;inc	$D020
	jsr	socket_reset
	jmp	@_reconn
@_20a:
	lda	http_connected
	bne	@_10
	txa
	pha
	tya
	pha
	jsr	task_periodic
	pla
	tay
	pla
	tax
	LoadB	dblClickCount, 1
@_21:
	lda	dblClickCount
	bne	@_21
	IncW	a8
	CmpWI	a8, 50*120
	bne	@_20

	jsr	socket_disconnect
	MoveW	http_socket, r1
	jsr	socket_release
	ldx	#TIMEOUT_ERR
	jmp	@err
@_10:
.endif

doSendRequestRedirect:
	; redirect request
	; construct request
	LoadB	http_state, HTTP_STATE_REQUEST
	LoadW	r7, 0	
	
	; get get
	jsr	i_MoveData
	.word	fileRequestPrefix		; from
	.word	fileRequestBuf
	.word	fileRequestPrefixEnd - fileRequestPrefix
	LoadW	r0, fileRequestPrefixEnd - fileRequestPrefix 
	AddW	r0, r7

	; copy url path
	LoadW	r0, fileRequestBuf
	AddW	r7, r0
	ldy	#0
	ldx	#<((httpLocationHeaderEnd-httpLocationHeader)+(httpDomainEnd - httpDomain)-1)
@27:
	lda	http_line_buf, x
	sta	(r0), y
	beq	@28
	iny
	inx
	IncW	r7
	bra	@27
@28:
	LoadW	r0, fileRequestBuf
	AddW	r7, r0
	MoveW	r0, @suffixTo2
	; get suffix

	jsr	i_MoveData
	.word	fileRequestSuffix
@suffixTo2:
	.word	0
	.word	fileRequestSuffixEnd - fileRequestSuffix
	LoadW	r0, fileRequestSuffixEnd - fileRequestSuffix
	AddW	r0, r7

	; connected, send request
	LoadW	r0, fileRequestBuf
	MoveW	r7, r1

	jsr	socket_send

	php
	sei
	LoadW	requestTimeout, 50*60 ; wait aprox 1 mins without data
	LoadB	requestRetry, 0
	plp

	rts

.if 0


	LoadW	a7, 0

	LoadW	a8, 0
@34:
	jsr	task_periodic
	LoadB	dblClickCount, 1
@33:
	lda	dblClickCount
	bne	@33
	IncW	a8

	CmpW	download_packets, a7
	beq	@33c 
	MoveW	download_packets, a7
	LoadW	a8, 0
@33c:
	CmpWI	a8, 50*60	; wait aprox 1 mins without data
	bne	@33b

	;inc	$D020

	jsr	socket_disconnect
	MoveW	http_socket, r1
	jsr	socket_release

	ldx	#TIMEOUT_ERR
	jmp	@err
@33b:
	CmpBI	http_state, HTTP_STATE_REQUEST
	beq	@34
	CmpBI	http_state, HTTP_STATE_COMPLETE
	bne	@34

	MoveW	http_socket, r1
	jsr	socket_disconnect
	;MoveW	http_socket, r1
	;jsr	socket_reset
	MoveW	http_socket, r1
	jsr	socket_release

	; file downloaded successful?
	LoadW	r6, tempName2
	jsr	ConvertCVT
	cpx	#0
	beq	@done
	; cleanup remove temp file
	txa
	pha
	LoadW	r0, tempName2
	jsr	DeleteFile
	pla
	tax
@done:
	LoadB	requestComplete, $FF
	rts
@err:
	LoadB	requestComplete, $FF
	rts
.endif

; r6 - file name
ConvertCVT:
	jsr	FindFile
	txa
	bne	@err

	; validate file? -> assume that it is correct file for now
	MoveW	r1, r3

	; load cvt header block $8100
	LoadW	r4, fileHeader		;$8100
	MoveW	dirEntryBuf+1, r1
	MoveW	r1, r6
	jsr	GetBlock
	txa
	bne	@err

	; copy file entry
	ldx	#0
@dirEntryCopy:
	lda	fileHeader+2, x
	sta	dirEntryBuf, x
	inx
	cpx	#30
	bne	@dirEntryCopy

	; load 2nd block = geos info block $8100
	MoveW	fileHeader, r1
	jsr	GetBlock
	txa
	beq	@gotInfo
@err:
	rts
@gotInfo:
	MoveW	r1, dirEntryBuf+19
	MoveW	fileHeader, r2
	LoadB	fileHeader, $00
	LoadB	fileHeader+1, $FF
	jsr	PutBlock
	txa
	bne	@err

	MoveW	r2, r1

	lda	fileHeader+70
	cmp	#1		;VLIR
	beq	@vlir
	jmp	@doneSeq

@vlir:
	; load VLIR block
	jsr	GetBlock
	txa	
	bne	@err

	MoveW	fileHeader, r7	; next block
	LoadB	r8L, 2		; initial module
@nextStrm:
	ldx	r8L
	beq	@done
	lda	fileHeader, x
	sta	r8H		; block count
	lda	fileHeader+1, x
	sta	r9L		; stream end bytes

	lda	r8H
	bne	@recFound
	lda	r9L
	cmp	#$FF
	beq	@nextMod
	jmp	@done
@recFound:
	lda	r7L
	sta	fileHeader, x
	lda	r7H
	sta	fileHeader+1, x

	LoadW	r4, diskBlkBuf
@nextBlk:
	MoveW	r7, r1
	jsr	GetBlock
	txa
	beq	@noErr
	jmp	@err
@noErr:
	MoveW	diskBlkBuf, r7
	dec	r8H
	bne	@nextBlk

	; this is last Block
	LoadB	diskBlkBuf, 0
	MoveB	r9L, diskBlkBuf+1

	jsr	PutBlock
	txa
	beq	@nextMod
	jmp	@err
@nextMod:
	; next module
	inc	r8L
	inc	r8L

	jmp	@nextStrm
@done:
	; write VLIR block
	LoadB	fileHeader, 0
	LoadB	fileHeader+1, $FF
	MoveW	r2, r1
	LoadW	r4, fileHeader
	jsr	PutBlock
	txa
	bne	@err2
@doneSeq:
	MoveW	r2, dirEntryBuf+1

	; remember GEOS file structure type (SEQ, VLIR)
	; remember referrence to next block

	; storage disconnected block
	; remeber correct block/sector

	; load next block (VLIR block table) $8100
 
	; for each entry, uncut the block sequence

	MoveW	r3, r1
	LoadW	r4, diskBlkBuf
	jsr	GetBlock
	txa
	bne	@err2

	ldx	r5L
	ldy	#0
@copyBack:
	lda	dirEntryBuf,y
	sta	diskBlkBuf,x
	inx
	iny
	cpy	#30
	bne	@copyBack

	ldx	#32
	CmpBI	r5L, 2 
	beq	@firstFile
	ldx	r5L
	dex
@firstFile:
	lda	a9L
	sta	diskBlkBuf, x

	jsr	PutBlock
	txa
	bne	@err2

	; free original header block
	jsr	FreeBlock
	txa
	bne	@err2
	jsr	PutDirHead
	txa
	bne	@err2
	ldx	#0	; no error
	rts
@err2:
	rts
HTTP_GET_callback:
	tax
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
	txa
	cmp	#WEEIP_EV_CONNECT
	bne	@10

	LoadB	http_connected, $FF
	jmp	@11
@10:
	cmp	#WEEIP_EV_DATA
	beq	@12b
	cmp	#WEEIP_EV_DISCONNECT_WITH_DATA
	beq	@12bb
	cmp	#WEEIP_EV_CLOSE_WITH_DATA
	beq	@12bb
	jmp	@12
@12bb:
	;inc	$D020
@12b:
	LoadB	http_connected, $FF
	pha
	jsr	socket_data_size		; get data size to r0

	;IncW	download_packets
	;AddW	r0, download_packets

	LoadW	r1, 0
	LoadW	r2, $5500
	CmpWI	r0, 0
	bne	@haveData			; skip if not data available
@12c:
	pla
	jmp	@12

@haveData:
	; start new or continue line
	ldx	http_line_buf_pos
@31:
	CmpBI	http_state, HTTP_STATE_REQUEST
	beq	@processLine
	CmpBI	http_state, HTTP_STATE_HEADER
	beq	@processLine
	CmpBI	http_state, HTTP_STATE_BODY
	beq	@processBody			; mode data for the body
	jmp	@12c				; idle? drop data

@processLine:
	; process next byte

	ldy	#0
	lda	(r2), y
	bne	@20

	brk					; fail on \0 in lines
	lda	#$89
	lda	(r2), y

@20:
	cmp	#CR				; skip, we check for  \n
	beq	@30
	cmp	#LF
	bne	@32				; no line end yet

	; NULL terminate current line
	lda	#NULL
	sta	http_line_buf, x

	; process line now
	cpx	#0				; empty line?
	beq	@processBodyStart

	jsr	ProcessLine

	; next new line
	ldx	#0
	bra	@30
@32:
	cpx	#$FF
	beq	@30
	sta	http_line_buf, x
	inx
@30:
	IncW	r1
	IncW	r2
	CmpW	r1, r0
	bne	@31
	stx	http_line_buf_pos		; remeber line buf pos
@12d:
	jmp	@12c

	; fall through to body processing of last line after header passed
@processBodyStart:
	LoadB	http_state, HTTP_STATE_BODY
	IncW	r1
	IncW	r2
	CmpW	r1, r0
	beq	@12d

@processBody:
	ldx	download_pos

	; add bytes to buffer @diskBlkBuf
@bodyLoop:
	php
	sei
	LoadW	downloadTimeout, 50*30
	plp

	IncW	download_packets
	IncW	download_packets2
	CmpWI	download_packets2, 1024
	bne	@noKB
	IncW	kbytes
	LoadW	download_packets2, 0
	txa
	pha
	jsr	printProgress
	pla
	tax
@noKB:
	ldy	#0
	lda	(r2), y

	cpx	#0	; check for overflow
	bne	@storeBody

	inx
	inx
	stx	download_pos

	pha
	PushW	r1
	PushW	r2
	PushW	r0

	LoadW	r3, 0		; lookup next free block from beginning
	; allocate next block
	jsr	SetNextFree
	cpx	#0
	bne	@bodyErr
	IncW	download_count

	jsr	printProgress

	; write block
	MoveW	r3, diskBlkBuf
	MoveW	download_block, r1
	MoveW	r3, download_block
	LoadW	r4, diskBlkBuf
	jsr	PutBlock
	cpx	#0
	bne	@bodyErr

	PopW	r0
	PopW	r2
	PopW	r1
	pla
	
	; setup next
	ldx	download_pos
	;sta	diskBlkBuf, x
	;bra	@bodyNext
@storeBody:
	sta	diskBlkBuf, x
	inx
@bodyNext:
	IncW	r1		; read count
	IncW	r2		; read pos
	CmpW	r1, r0		; avail
	beq	@endLoop
	jmp	@bodyLoop
@endLoop:
	stx	download_pos

	jmp	@12c
@bodyErr:

	brk
	lda	#$92
@12:
	cmp	#WEEIP_EV_CLOSE
	beq	@14bb
	cmp	#WEEIP_EV_CLOSE_WITH_DATA
	bne	@12cc
@14bb:
	jsr	socket_disconnect
	bra	@11
@12cc:
	cmp	#WEEIP_EV_DISCONNECT
	beq	@11b
	cmp	#WEEIP_EV_DISCONNECT_WITH_DATA
	bne	@11
@11b:
	MoveW	http_socket, r1
	jsr	socket_disconnect
	;brk
	;lda	#$93
	lda	http_state
	cmp	#HTTP_STATE_BODY
	bne	@17
	jsr	CloseFile
	LoadB	http_state, HTTP_STATE_COMPLETE
@17:
	LoadB	http_connected, 0
@11:
;brk
;lda	#$97

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

ProcessLine:

	CmpBI	http_state, HTTP_STATE_REQUEST
	bne	@100

	; check for result code
	LoadW	r5, http_line_buf
	LoadW	r6, httpSuccessResult
	ldx	#r5
	ldy	#r6
	lda	#<(httpSuccessResultEnd-httpSuccessResult)
	jsr	CmpFString
	bne	@11

	; success, start reading header
	LoadB	http_state, HTTP_STATE_HEADER
	bra	@end
@11:
	LoadW	r5, http_line_buf
	LoadW	r6, httpRedirectResult
	ldx	#r5
	ldy	#r6
	lda	#<(httpRedirectResultEnd-httpRedirectResult)
	jsr	CmpFString
	bne	@10

	LoadB	http_state, HTTP_STATE_HEADER
	LoadB	http_redirect, $FF
	bra	@end

@10:	; handle wrong/unexpected result
	LoadB	http_state, HTTP_STATE_ERROR
	MoveW	http_socket, r1
	jsr	socket_disconnect
	bra	@end
@100:
	; reading header, just continue
	lda	http_redirect
	beq	@end

	LoadW	r5, http_line_buf
	LoadW	r6, httpLocationHeader
	ldx	#r5
	ldy	#r6
	lda	#<(httpLocationHeaderEnd-httpLocationHeader)
	jsr	CmpFString
	bne	@end

	;brk
	;lda	#$85

	;
	LoadB	http_state, HTTP_STATE_REDIRECT
	MoveW	http_socket, r1
	jsr	socket_disconnect

@end:
	rts

CloseFile:
	lda	#$FF

	LoadB	diskBlkBuf, $00
	MoveB	download_pos, diskBlkBuf+1

	; write block
	MoveW	download_block, r1
	LoadW	r4, diskBlkBuf
	jsr	PutBlock

	; allocate dir entry
	LoadB	r10L, 0
	jsr	GetFreeDirBlk

	; fill in dir entry
	lda	#$82
	sta	diskBlkBuf, y

	lda	download_first
	sta	diskBlkBuf+1,y
	lda	download_first+1
	sta	diskBlkBuf+2,y

	; copy name
	tya
	pha
	ldx	#0
@10:
	lda	tempName, x
	sta	diskBlkBuf+3,y
	inx
	iny
	cpx	#16
	bne	@10
	pla
	tay
	lda	#0
	sta	diskBlkBuf+19,y
	sta	diskBlkBuf+20,y
	sta	diskBlkBuf+21,y
	sta	diskBlkBuf+22,y
	sta	diskBlkBuf+23,y
	sta	diskBlkBuf+24,y
	sta	diskBlkBuf+25,y
	sta	diskBlkBuf+26,y
	sta	diskBlkBuf+27,y

	lda	download_count
	sta	diskBlkBuf+28,y
	lda	download_count+1
	sta	diskBlkBuf+29,y


	; r1 point to track and sector
	LoadW	r4, diskBlkBuf
	jsr	PutBlock

	jsr	PutDirHead			; destroys r1

	rts

CountMissingFiles:
	LoadW	r0, 0
	LoadW	r8, bootstrapTable
@10:
	ldy	#2
	lda	(r8), y
	sta	r6L
	iny
	lda	(r8), y
	sta	r6H
	jsr	FindFile
	cpx	#0
	beq	@20
	IncW	r0
@20:
	AddVW	5, r8
	CmpWI	r8, bootstrapTableEnd
	bne	@10
	rts

WelcomeInit:
	LoadW	keyVector, WelcomeKeyHandler
	rts

WelcomeKeyHandler:
	lda	keyData
	cmp	#'1'
	beq	@10
	cmp	#'2'
	beq	@20
	rts
@10:
	LoadB	sysDBData, OK
	jmp	RstrFrmDialogue	
@20:
	LoadB	sysDBData, CANCEL
	jmp	RstrFrmDialogue

InstallFirstInput:
	; find the first input driver on diskBlkBuf
	LoadB	r7L, INPUT_DEVICE
	LoadB	r7H, 1
	LoadW	r10, NULL	; no class to compare
	LoadW	r6, FrontBuffer
	jsr	FindFTypes
	cpx	#0
	bne	@done	; on error do nothing

	CmpBI	r7H, 0
	bne	@done

	; found something, load it
	LoadW	r6, FrontBuffer
	lda	#$00
	sta	r0L
	sta	r10L
	jsr	GetFile
@done:
	rts

;	r1	File name of input driver to move to front
;
MakeFirstInput:
	; find the first input driver on diskBlkBuf
	MoveW	r1, a2
	LoadB	r7L, INPUT_DEVICE
	LoadB	r7H, 1
	LoadW	r10, NULL	; no class to compare
	LoadW	r6, FrontBuffer
	jsr	FindFTypes

	cpx	#0
	beq	@ok
@done2:
	jmp	@done
@ok:
	CmpBI	r7H, 0
	bne	@done2
	LoadW	r0, FrontBuffer
	ldx	#a2
	ldy	#r0
	jsr	CmpString
	beq	@done2

	; find dir entry of this
	LoadW	r6, FrontBuffer
	jsr	FindFile
	cpx	#0
	bne	@done

	MoveW	r1, a0
	MoveW	r5, a1

	jsr	@swap

	; find entry to be MoveData
	MoveW	a2, r6
	jsr	FindFile
	cpx	#0
	bne	@done

	jsr	@swap
	LoadW	r4, diskBlkBuf
	jsr	PutBlock
	cpx	#0
	bne	@done
	LoadW	r4, diskBlkBuf
	MoveW	a0, r1
	jsr	GetBlock
	cpx	#0
	bne	@done
	MoveW	a1, r5
	jsr	@swap
	LoadW	r4, diskBlkBuf
	jsr	PutBlock

	MoveW	a2,r6
	lda	#$00
	sta	r0L
	sta	r10L
	jmp	GetFile	
@done:
	rts
@swap:
	; copy dir entry to buffer
	ldy	#0
@loop1:
	lda	(r5), y
	tax
	lda	FrontBuffer, y
	sta	(r5), y
	txa
	sta	FrontBuffer, y
	iny	
	cpy	#30
	bne	@loop1

	rts

tempName2:
	.byte	"Temp Download", NULL

tempName:
	.byte	"Temp Download", $a0, $a0, $a0

FrontBuffer:
http_line_buf:
	.repeat	LINE_BUF_SIZE
		.byte	0
	.endrep
http_line_buf_pos:
	.byte	0

kbytes:
	.word	0

file_count:
	.byte	0
total_count:
	.word	0

current_name:
	.word	NULL

error_count:
	.byte	0
missing_count:
	.byte	0
distro_count:
	.byte	0

retry_count:
	.byte	0

success_count:
	.byte 	0

oldAppMain:
	.word	0

http_connected:
	.byte	0
http_redirect:
	.byte 	0
http_socket:
	.word	0
http_state:
	.byte	HTTP_STATE_IDLE

download_pos:
	.byte	2
download_block:
	.word	0
download_first:
	.word	0
download_count:
	.word	0
download_packets:
	.word 	0
download_packets2:
	.word 	0
downloadState:
	.byte	DL_STATE_IDLE
initCounter:
	.byte	0
requestComplete:
	.byte 	0
ip_address:
	.byte 	0, 0, 0, 0 

requestTimeout:
	.word	0
requestRetry:
	.byte 	0
requestFileName:
	.word 	0
requestFileNameLen:
	.word 	0
requestRedirect:
	.byte 	0

downloadTimeout:
	.word	0

fileRequestBuf		= $5000
;	.repeat		1024
;		.byte	0
;	.endrep

fileRequestPrefix:
	.byte	"GET "
fileRequestPrefixEnd:
	.byte	NULL

fileRequestLocation:
	.byte	"/web/20111025045336if_/http://cbmfiles.com:80/geos/geosfiles/"
fileRequestLocationEnd:
	.byte	NULL

fileRequestSuffix:
	.byte	" HTTP/1.0", CR, LF
	.byte	"Host: web.archive.org", CR, LF
	.byte	"Connection: Close", CR, LF
	.byte	CR, LF
fileRequestSuffixEnd:
	.byte 	NULL

ethName:
	.byte	"eth", NULL

httpSuccessResult:
	.byte	"HTTP/1.1 200 "
httpSuccessResultEnd:

httpRedirectResult:
	.byte	"HTTP/1.1 302 "
httpRedirectResultEnd:

httpLocationHeader:
	.byte	"location: "
httpLocationHeaderEnd:

httpDomain:
	.byte	"http://web.archive.org/"
httpDomainEnd:
	.byte	NULL

hostName:
	;.byte	"www.bluewaysw.de", NULL
	;.byte	"192.168.17.116", NULL
	.byte	"web.archive.org", NULL
	;.byte	"breadbox.com", NULL
hostIP:
	.byte	0, 0, 0, 0

missingTextOf:
	.byte	" of ", NULL
missingText:
	.byte 	" default distro files are missing.", NULL
missingText2:
	.byte 	" files are still missing!", PLAINTEXT, NULL
missingText3:
	.byte	"To retry the download later, manually", NULL
missingText4:
	.byte	"run GEOSPACE from TopDesk.", NULL
downloadText:
	.byte	BOLDON, "Are you connected to the internet and", NULL
downloadText2:
	.byte	"want to try downloading the files now?", NULL

DrawMissing:

	LoadW	r11, %1011101100000000 | ((-(117)) & $FF)
	LoadB	r1H, (-36) & $FF

	lda	#BOLDON
	jsr	PutChar

	LoadB	r0H, 0
	MoveB	missing_count, r0L
	lda	#SET_SURPRESS|SET_LEFTJUST
	jsr	PutDecimal

	LoadW	r0, missingTextOf
	jsr	PutString

	LoadB	r0H, 0
	MoveB	distro_count, r0L
	lda	#SET_SURPRESS|SET_LEFTJUST
	jsr	PutDecimal

	LoadW	r0, missingText
	jsr	PutString

	rts

DrawMissing2:

	lda	a1L
	ora	a1H
	beq	@done

	LoadW	r11, %1011101100000000 | ((-(86)) & $FF)
	LoadB	r1H, (-16) & $FF

	lda	#BOLDON
	jsr	PutChar

	MoveW	a1, r0
	lda	#SET_SURPRESS|SET_LEFTJUST
	jsr	PutDecimal

	LoadW	r0, missingTextOf
	jsr	PutString

	MoveW	a2, r0
	lda	#SET_SURPRESS|SET_LEFTJUST
	jsr	PutDecimal

	LoadW	r0, missingText2
	jsr	PutString

	LoadW	r11, %1011101100000000 | ((-(86)) & $FF)
	LoadB	r1H, (0) & $FF

	LoadW	r0, missingText3
	jsr	PutString

	LoadW	r11, %1011101100000000 | ((-(86)) & $FF)
	LoadB	r1H, (16) & $FF

	LoadW	r0, missingText4
	jsr	PutString
@done:
	rts

CheckDialog:
	.byte	$1	; standard dialog, light bachground

	ByteCY	%101100000000 | ((-127) & $FF), %101100000000 | ((-50) & $FF)
	ByteCY	%101100000000 | ((118) & $FF), %101100000000 | ((50) & $FF)
	WordCX	%101100000000 | ((-(127)) & $FF), %101100000000 | ((-50) & $FF)
	WordCX	%101100000000 | ((118) & $FF), %101100000000 | ((50) & $FF)

	;.byte	DBTXTSTR, 10,16
	;.word	missingText
	.byte	DB_USR_ROUT
	.word	DrawMissing

	.byte	DBTXTSTR, 10,32+8
	.word	downloadText

	.byte	DBTXTSTR, 10,48+8
	.word	downloadText2

	.byte	YES
	.byte	1, 74
	.byte	NO
	.byte	24, 74

	.byte	NULL

downloadingInto:
	.byte	BOLDON, "Downloading GEOS files from", NULL
downloadingInto2:
	.byte	"cbmfiles.com/geos (via archive.org):", NULL
rulesText1:
	.byte	ITALICON, "Please respect the downloading rules!", PLAINTEXT, NULL
rulesText2:
	.byte	"Even though GEOS 64 and GEOS 128 are being", NULL
rulesText3:
	.byte	"provided for free downloading, it is still commercial", NULL
rulesText4:
	.byte	"software. Therefore all existing copyrights apply.", NULL

rulesText5:
	.byte	"As a user, you are perfectly welcome to download", NULL
rulesText6:
	.byte	"GEOS and use it as much as you'd like. The only", NULL
rulesText7:
	.byte	"restrictions are you must not sell it or redistribute", NULL
rulesText8:
	.byte	"it in any form or fashion.", NULL

rulesText9:
	.byte	BOLDON, "Do you agree not to redistribute or sell", NULL
rulesText10:
	.byte	"GEOS?", NULL

CheckLicenseDialog:
	.byte	$1	; standard dialog, light bachground

	ByteCY	%101100000000 | ((-127) & $FF), %101100000000 | ((-94) & $FF)
	ByteCY	%101100000000 | ((118) & $FF), %101100000000 | ((90) & $FF)
	WordCX	%101100000000 | ((-(127)) & $FF), %101100000000 | ((-94) & $FF)
	WordCX	%101100000000 | ((118) & $FF), %101100000000 | ((90) & $FF)

	.byte	DBTXTSTR, 10,16
	.word	downloadingInto
	.byte	DBTXTSTR, 10,26
	.word	downloadingInto2

	.byte	DBTXTSTR, 10,42
	.word	rulesText1

	.byte	DBTXTSTR, 10,42+16
	.word	rulesText2
	.byte	DBTXTSTR, 10,42+26
	.word	rulesText3
	.byte	DBTXTSTR, 10,42+36
	.word	rulesText4

	.byte	DBTXTSTR, 10,42+46+6
	.word	rulesText5
	.byte	DBTXTSTR, 10,42+56+6
	.word	rulesText6
	.byte	DBTXTSTR, 10,42+66+6
	.word	rulesText7
	.byte	DBTXTSTR, 10,42+76+6
	.word	rulesText8

	.byte	DBTXTSTR, 10,42+86+6+6
	.word	rulesText9
	.byte	DBTXTSTR, 10,42+96+6+6
	.word	rulesText10

	.byte	YES
	.byte	1, 166
	.byte	CANCEL
	.byte	24, 166

	.byte	NULL

connectingText:
	.byte	BOLDON, "Connecting...", NULL

DownloadDialog:
	.byte	$1	; standard dialog, light bachground

	ByteCY	%101100000000 | ((-127) & $FF), %101100000000 | ((-60) & $FF)
	ByteCY	%101100000000 | ((118) & $FF), %101100000000 | ((60) & $FF)
	WordCX	%101100000000 | ((-(127)) & $FF), %101100000000 | ((-60) & $FF)
	WordCX	%101100000000 | ((118) & $FF), %101100000000 | ((60) & $FF)

	.byte	DBTXTSTR, 10,20
	.word	connectingText

	.byte	CANCEL
	.byte	24, 100

	.byte	DB_USR_ROUT
	.word	startDownload

	.byte	NULL

WelcomeDialog:
	.byte	$81	; standard dialog, light bachground

	;.byte	OK
	;.byte	17, 74

	.byte	DBTXTSTR, 10,12
	.word	welcomeText

	.byte	DBTXTSTR, 10,23
	.word	geosVersionText

	.byte	DBTXTSTR, 10,33
	.word	versionDetails

	.byte	DBTXTSTR, 10,43
	.word	warranties2

	.byte	DBTXTSTR, 10,59
	.word	selectInputInstruc

	.byte	DBTXTSTR, 10,73
	.word	joystickInput

	.byte	DBTXTSTR, 10,84
	.word	mouseInput

	;.byte	DBTXTSTR, 10,89
	;.word	bluewayswInfo

	.byte	DB_USR_ROUT
	.word	WelcomeInit

	.byte	NULL

systemUpToDate:
	.byte	BOLDON, "System disk is up to date!", NULL

Welcome2Dialog:
	.byte	$81	; standard dialog, light bachground

	.byte	OK
	.byte	17, 74

	.byte	DBTXTSTR, 10,12
	.word	welcome2Text

	.byte	DBTXTSTR, 10,23
	.word	geosVersionText

	.byte	DBTXTSTR, 10,33
	.word	versionDetails

	.byte	DBTXTSTR, 10,43
	.word	warranties2

	.byte	DBTXTSTR, 10,62
	.word	systemUpToDate

	.byte	NULL


welcomeText:
	.byte	BOLDON, OUTLINEON, "Welcome!", PLAINTEXT, NULL
welcome2Text:
	.byte	BOLDON, OUTLINEON, "Hello Again!", PLAINTEXT, NULL
geosVersionText:
	.byte	BOLDON, "GEOS 6.0",PLAINTEXT," (r4+ BETA) for the ", BOLDON,"MEGA65", PLAINTEXT, NULL
versionDetails:
	.byte	"https://github.com/bluewaysw/geos.git", NULL
warranties2:
	.byte	BOLDON, "Use with care, no warranties!", PLAINTEXT, NULL
;geoSpaceInfo:
;	.byte	"establishing GeoSpace:", NULL
;bluewayswInfo:
;	.byte	BOLDON, "www.bluewaysw.de", NULL
selectInputInstruc:
	.byte	PLAINTEXT, "Press <> key to set your input driver:", NULL
joystickInput:
	.byte	BOLDON, "  <1>  JOYSTICK", NULL
mouseInput:
	.byte	BOLDON, "  <2>  MEGA 1351", PLAINTEXT, " (Mouse)", NULL
ResultDialog:
	.byte	$81	; standard dialog, light bachground

	.byte	OK
	.byte	17, 74

	.byte	DBVARSTR, 10,16
	.byte	a0

	.byte	DB_USR_ROUT
	.word	DrawMissing2

	.byte	NULL

SuccessResultString:
	.byte	BOLDON, "Download completed.", NULL
CancelledResultString:
	.byte	BOLDON, "Download cancelled.", NULL

emptyString: 
	.byte	"                                            ", NULL

FOLDER_PRINTER_DRIVER	= 10
FOLDER_APPLICATION 	= 3
FOLDER_FONTS		= 6
FOLDER_DEST_ACC		= 5
FOLDER_OTHER_DATA	= 9
FOLDER_UTILITIES	= 7

gw128cvt:
	.byte	"GW128.CVT", NULL
gw128name:
	.byte	"GEOWRITE 128", NULL

gp128cvt:
	.byte	"GPT128.CVT", NULL
gp128name:
	.byte	"GEOPAINT", NULL

photo_mgrcvt:
	.byte	"PHMGR128.CVT", NULL
photo_mgrname:
	.byte	"photo manager", NULL

text_mgrcvt:
	.byte	"TXMGR128.CVT", NULL
text_mgrname:
	.byte	"text manager", NULL

alarm128cvt:
	.byte	"ALARM128.CVT", NULL
alarm128name:
	.byte	"alarm clock", NULL

calc128cvt:
	.byte	"CALC128.CVT", NULL
calc128name:
	.byte	"calculator", NULL

notepadcvt:
	.byte	"NOTE128.CVT", NULL
notepadname:
	.byte	"note pad", NULL

spell128cvt:
	.byte	"SPELL128.CVT", NULL
spell128name:
	.byte	"GEOSPELL 128", NULL

spelldatacvt:
	.byte	"DICT.CVT", NULL
spelldataname:
	.byte	"GeoDictionary", NULL

merge128cvt:
	.byte	"GM128.CVT", NULL
merge128name:
	.byte	"GEOMERGE", NULL

.if 0
californiacvt:
	.byte	"CALIF.CVT", NULL
californianame:
	.byte	"California", NULL

corycvt:
	.byte	"CORY.CVT", NULL
coryname:
	.byte	"Cory", NULL

dwinellecvt:
	.byte	"DWIN.CVT", NULL
dwinellename:
	.byte	"Dwinelle", NULL

romacvt:
	.byte	"ROMA.CVT", NULL
romaname:
	.byte	"Roma", NULL

universitycvt:
	.byte	"UNIV.CVT", NULL
universityname:
	.byte	"University", NULL

commfontcvt:
	.byte	"COMMFONT.CVT", NULL
commfontname:
	.byte	"Commodore", NULL

lwromacvt:
	.byte	"LWROMA.CVT", NULL
lwromaname:
	.byte	"LW_Roma", NULL

lwcalcvt:
	.byte	"LWCAL.CVT", NULL
lwcalname:
	.byte	"LW_Cal", NULL

lwgreekcvt:
	.byte	"LWGREEK.CVT", NULL
lwgreekname:
	.byte	"LW_Greek", NULL

lwbarrowscvt:
	.byte	"LWBARR.CVT", NULL
lwbarrowsname:
	.byte	"LW_Barrows", NULL
.endif
paint_driverscvt:
	.byte	"PNTDRVRS.CVT", NULL
paint_driversname:
	.byte	"PAINT DRIVERS", NULL

geolasercvt:
	.byte	"GEOLASER.CVT", NULL
geolasername:
	.byte	"GEOLASER", NULL

text_grabbercvt:
	.byte	"TG128.CVT", NULL
text_grabbername:
	.byte	"TEXT GRABBER 128", NULL

tgfs4128cvt:
	.byte	"TGFS4128.CVT", NULL
tgfs4128name:
	.byte	"FleetSystem 4", NULL

tgpc2128cvt:
	.byte	"TGPC2128.CVT", NULL
tgpc2128name:
	.byte	"PaperClip II", NULL

tgww128cvt:
	.byte	"TGWW128.CVT", NULL
tgww128name:
	.byte	"WordWriter 128", NULL

tgg1128cvt:
	.byte	"TGG1128.CVT", NULL
tgg1128name:
	.byte	"C128 Generic I", NULL

tgg2128cvt:
	.byte	"TGG2128.CVT", NULL
tgg2128name:
	.byte	"C128 Generic II", NULL
.if 0
COMMCOMPcvt:
	.byte	"COMMCOMP.CVT", NULL
COMMCOMPname:
	.byte	"Comm. Compat.", NULL

p1526cvt:
	.byte	"1526.CVT", NULL
p1526name:
	.byte	"1526", NULL

ASCcvt:
	.byte	"ASC.CVT", NULL
ASCname:
	.byte	"ASCII Only", NULL

BCM120cvt:
	.byte	"BCM120.CVT", NULL
BCM120name:
	.byte	"BlueChip M120", NULL

CI8510cvt:
	.byte	"CI8510.CVT", NULL
CI8510name:
	.byte	"C.Itoh 8510", NULL

CI8510Acvt:
	.byte	"CI8510A.CVT", NULL
CI8510Aname:
	.byte	"C.Itoh 8510A", NULL

CI8510DScvt:
	.byte	"CI8510DS.CVT", NULL
CI8510DSname:
	.byte	"C.Itoh 8510 D.S.", NULL

CI8510QScvt:
	.byte	"CI8510QS.CVT", NULL
CI8510QSname:
	.byte	"C.Itoh 8510 Q.S.", NULL

CIREDcvt:
	.byte	"CIRED.CVT", NULL
CIREDname:
	.byte	"C.Itoh RED.", NULL

EPFX80cvt:
	.byte	"EPFX80.CVT", NULL
EPFX80name:
	.byte	"Epson FX-80", NULL

EPFX80DScvt:
	.byte	"EPFX80DS.CVT", NULL
EPFX80DSname:
	.byte	"Epson FX-80 DS", NULL

EPFX80QScvt:
	.byte	"EPFX80QS.CVT", NULL
EPFX80QSname:
	.byte	"Epson FX-80 QS", NULL

EPJX80cvt:
	.byte	"EPJX80.CVT", NULL
EPJX80name:
	.byte	"Epson JX-80", NULL

EPLQ1500cvt:
	.byte	"EPLQ1500.CVT", NULL
EPLQ1500name:
	.byte	"Epson LQ-1500", NULL

EPLX80cvt:
	.byte	"EPLX80.CVT", NULL
EPLX80name:
	.byte	"Epson LX-80", NULL

EPMX80cvt:
	.byte	"EPMX80.CVT", NULL
EPMX80name:
	.byte	"Epson MX-80", NULL

EPREDcvt:
	.byte	"EPRED.CVT", NULL
EPREDname:
	.byte	"Epson RED.", NULL

GEM10Xcvt:
	.byte	"GEM10X.CVT", NULL
GEM10Xname:
	.byte	"Gemini 10x", NULL

GEMDScvt:
	.byte	"GEMDS.CVT", NULL
GEMDSname:
	.byte	"Gemini DS", NULL

GEMQScvt:
	.byte	"GEMQS.CVT", NULL
GEMQSname:
	.byte	"Gemini QS", NULL

IBM51Pcvt:
	.byte	"IBM51P.CVT", NULL
IBM51Pname:
	.byte	"IBM 5152+", NULL

IBM51PDScvt:
	.byte	"IBM51PDS.CVT", NULL
IBM51PDSname:
	.byte	"IBM 5152+ DS", NULL

IBM51PQScvt:
	.byte	"IBM51PQS.CVT", NULL
IBM51PQSname:
	.byte	"IBM 5152+ QS", NULL

IMWcvt:
	.byte	"IMW.CVT", NULL
IMWname:
	.byte	"ImageWriter", NULL

IMWDScvt:
	.byte	"IMWDS.CVT", NULL
IMWDSname:
	.byte	"ImageWriterDS", NULL

IMWQScvt:
	.byte	"IMWQS.CVT", NULL
IMWQSname:
	.byte	"ImageWriterQS", NULL

IMW2cvt:
	.byte	"IMW2.CVT", NULL
IMW2name:
	.byte	"ImageWriter II", NULL

IMW2DScvt:
	.byte	"IMW2DS.CVT", NULL
IMW2DSname:
	.byte	"ImWrtr II DS", NULL

IMW2QScvt:
	.byte	"IMW2QS.CVT", NULL
IMW2QSname:
	.byte	"ImWrtr II QS", NULL

LJPARcvt:
	.byte	"LJPAR.CVT", NULL
LJPARname:
	.byte	"LaserJet PAR.", NULL

LJSERcvt:
	.byte	"LJSER.CVT", NULL
LJSERname:
	.byte	"LaserJet SER.", NULL

LW21cvt:
	.byte	"LW21.CVT", NULL
LW21name:
	.byte	"LaserWriter 2.1", NULL

MPS801cvt:
	.byte	"MPS801.CVT", NULL
MPS801name:
	.byte	"MPS-801", NULL

MPS803cvt:
	.byte	"MPS803.CVT", NULL
MPS803name:
	.byte	"MPS-803", NULL

MPS1000cvt:
	.byte	"MPS1000.CVT", NULL
MPS1000name:
	.byte	"MPS-1000", NULL

MPS1200cvt:
	.byte	"MPS1200.CVT", NULL
MPS1200name:
	.byte	"MPS 1200", NULL

MPS1200DScvt:
	.byte	"MP1200DS.CVT", NULL
MPS1200DSname:
	.byte	"MPS-1200 DS", NULL

MPS1200QScvt:
	.byte	"MP1200QS.CVT", NULL
MPS1200QSname:
	.byte	"MPS 1200 QS", NULL

OK120cvt:
	.byte	"OK120.CVT", NULL
OK120name:
	.byte	"Oki 120", NULL

OK120NLQcvt:
	.byte	"OK120NLQ.CVT", NULL
OK120NLQname:
	.byte	"Oki 120 NLQ", NULL

OKML92cvt:
	.byte	"OKML92.CVT", NULL
OKML92name:
	.byte	"Oki ML-92/93", NULL

OK10cvt:
	.byte	"OK10.CVT", NULL
OK10name:
	.byte	"Okimate 10", NULL

OK20cvt:
	.byte	"OK20.CVT", NULL
OK20name:
	.byte	"Okimate 20", NULL

OLPR2300cvt:
	.byte	"OLPR2300.CVT", NULL
OLPR2300name:
	.byte	"Olivetti PR2300", NULL

RITECPcvt:
	.byte	"RITECP.CVT", NULL
RITECPname:
	.byte	"Riteman C+", NULL

SCRIBEcvt:
	.byte	"SCRIBE.CVT", NULL
SCRIBEname:
	.byte	"Scribe", NULL

SNB15cvt:
	.byte	"SNB15.CVT", NULL
SNB15name:
	.byte	"Star NB-15", NULL

SNL10COMcvt:
	.byte	"SNL10COM.CVT", NULL
SNL10COMname:
	.byte	"Star NL-10(com)", NULL

SNX10cvt:
	.byte	"SNX10.CVT", NULL
SNX10name:
	.byte	"Star NX-10", NULL

SNX10DScvt:
	.byte	"SNX10DS.CVT", NULL
SNX10DSname:
	.byte	"Star NX-10 DS", NULL

SNX10QScvt:
	.byte	"SNX10QS.CVT", NULL
SNX10QSname:
	.byte	"Star NX-10 QS", NULL

SNX10Ccvt:
	.byte	"SNX10C.CVT", NULL
SNX10Cname:
	.byte	"Star NX-10C", NULL

NX1000Rcvt:
	.byte	"NX1000R.CVT", NULL
NX1000Rname:
	.byte	"NX-1000 Rainbow", NULL

SSG10cvt:
	.byte	"SSG10.CVT", NULL
SSG10name:
	.byte	"Star SG-10/15", NULL

TOSHP321cvt:
	.byte	"TOSHP321.CVT", NULL
TOSHP321name:
	.byte	"Toshiba P321", NULL
.endif




bootstrapTable:
	.word	gw128cvt
	.word	gw128name
	.byte	FOLDER_APPLICATION

	.word	gp128cvt
	.word	gp128name
	.byte	FOLDER_APPLICATION

	.word	photo_mgrcvt
	.word	photo_mgrname
	.byte	FOLDER_DEST_ACC

	.word	text_mgrcvt
	.word	text_mgrname
	.byte	FOLDER_DEST_ACC

	.word	alarm128cvt
	.word	alarm128name
	.byte	FOLDER_DEST_ACC

	.word	calc128cvt
	.word	calc128name
	.byte	FOLDER_DEST_ACC

	.word	notepadcvt
	.word	notepadname
	.byte	FOLDER_DEST_ACC

	.word	spell128cvt
	.word	spell128name
	.byte	FOLDER_APPLICATION

	.word	spelldatacvt
	.word	spelldataname
	.byte	FOLDER_OTHER_DATA

	.word	merge128cvt
	.word	merge128name
	.byte	FOLDER_APPLICATION
.if 0
	.word	californiacvt
	.word	californianame
	.byte	FOLDER_FONTS

	.word	corycvt
	.word	coryname
	.byte	FOLDER_FONTS

	.word	dwinellecvt
	.word	dwinellename
	.byte	FOLDER_FONTS

	.word	romacvt
	.word	romaname
	.byte	FOLDER_FONTS

	.word	universitycvt
	.word	universityname
	.byte	FOLDER_FONTS

	.word	commfontcvt
	.word	commfontname
	.byte	FOLDER_FONTS

	.word	lwromacvt
	.word	lwromaname
	.byte	FOLDER_FONTS

	.word	lwcalcvt
	.word	lwcalname
	.byte	FOLDER_FONTS

	.word	lwgreekcvt
	.word	lwgreekname
	.byte	FOLDER_FONTS

	.word	lwbarrowscvt
	.word	lwbarrowsname
	.byte	FOLDER_FONTS
.endif
	.word	paint_driverscvt
	.word	paint_driversname
	.byte	FOLDER_UTILITIES

	.word	geolasercvt
	.word	geolasername
	.byte	FOLDER_UTILITIES

	.word	text_grabbercvt
	.word	text_grabbername
	.byte	FOLDER_UTILITIES

	.word	tgfs4128cvt
	.word	tgfs4128name
	.byte	FOLDER_OTHER_DATA

	.word	tgpc2128cvt
	.word	tgpc2128name
	.byte	FOLDER_OTHER_DATA

	.word	tgww128cvt
	.word	tgww128name
	.byte	FOLDER_OTHER_DATA

	.word	tgg1128cvt
	.word	tgg1128name
	.byte	FOLDER_OTHER_DATA

	.word	tgg2128cvt
	.word	tgg2128name
	.byte	FOLDER_OTHER_DATA
.if 0
	.word	COMMCOMPcvt
	.word	COMMCOMPname
	.byte	FOLDER_PRINTER_DRIVER

	.word	p1526cvt
	.word	p1526name
	.byte	FOLDER_PRINTER_DRIVER

	.word	ASCcvt
	.word	ASCname
	.byte	FOLDER_PRINTER_DRIVER

	.word	BCM120cvt
	.word	BCM120name
	.byte	FOLDER_PRINTER_DRIVER

	.word	CI8510cvt
	.word	CI8510name
	.byte	FOLDER_PRINTER_DRIVER

	.word	CI8510Acvt
	.word	CI8510Aname
	.byte	FOLDER_PRINTER_DRIVER
	
	.word	CI8510DScvt
	.word	CI8510DSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	CI8510QScvt
	.word	CI8510QSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	CIREDcvt
	.word	CIREDname
	.byte	FOLDER_PRINTER_DRIVER

	.word	EPFX80cvt
	.word	EPFX80name
	.byte	FOLDER_PRINTER_DRIVER

	.word	EPFX80DScvt
	.word	EPFX80DSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	EPFX80QScvt
	.word	EPFX80QSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	EPJX80cvt
	.word	EPJX80name
	.byte	FOLDER_PRINTER_DRIVER

	.word	EPLQ1500cvt
	.word	EPLQ1500name
	.byte	FOLDER_PRINTER_DRIVER

	.word	EPLX80cvt
	.word	EPLX80name
	.byte	FOLDER_PRINTER_DRIVER

	.word	EPMX80cvt
	.word	EPMX80name
	.byte	FOLDER_PRINTER_DRIVER

	.word	EPREDcvt
	.word	EPREDname
	.byte	FOLDER_PRINTER_DRIVER

	.word	GEM10Xcvt
	.word	GEM10Xname
	.byte	FOLDER_PRINTER_DRIVER

	.word	GEMDScvt
	.word	GEMDSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	GEMQScvt
	.word	GEMQSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	IBM51Pcvt
	.word	IBM51Pname
	.byte	FOLDER_PRINTER_DRIVER

	.word	IBM51PDScvt
	.word	IBM51PDSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	IBM51PQScvt
	.word	IBM51PQSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	IMWcvt
	.word	IMWname
	.byte	FOLDER_PRINTER_DRIVER

	.word	IMWDScvt
	.word	IMWDSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	IMWQScvt
	.word	IMWQSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	IMW2cvt
	.word	IMW2name
	.byte	FOLDER_PRINTER_DRIVER

	.word	IMW2DScvt
	.word	IMW2DSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	IMW2QScvt
	.word	IMW2QSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	LJPARcvt
	.word	LJPARname
	.byte	FOLDER_PRINTER_DRIVER

	.word	LJSERcvt
	.word	LJSERname
	.byte	FOLDER_PRINTER_DRIVER

	.word	LW21cvt
	.word	LW21name
	.byte	FOLDER_PRINTER_DRIVER

	.word	MPS801cvt
	.word	MPS801name
	.byte	FOLDER_PRINTER_DRIVER

	.word	MPS803cvt
	.word	MPS803name
	.byte	FOLDER_PRINTER_DRIVER

	.word	MPS1000cvt
	.word	MPS1000name
	.byte	FOLDER_PRINTER_DRIVER

	.word	MPS1200cvt
	.word	MPS1200name
	.byte	FOLDER_PRINTER_DRIVER

	.word	MPS1200DScvt
	.word	MPS1200DSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	MPS1200QScvt
	.word	MPS1200QSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	OK120cvt
	.word	OK120name
	.byte	FOLDER_PRINTER_DRIVER

	.word	OK120NLQcvt
	.word	OK120NLQname
	.byte	FOLDER_PRINTER_DRIVER

	.word	OKML92cvt
	.word	OKML92name
	.byte	FOLDER_PRINTER_DRIVER

	.word	OK10cvt
	.word	OK10name
	.byte	FOLDER_PRINTER_DRIVER

	.word	OK20cvt
	.word	OK20name
	.byte	FOLDER_PRINTER_DRIVER

	.word	OLPR2300cvt
	.word	OLPR2300name
	.byte	FOLDER_PRINTER_DRIVER

	.word	RITECPcvt
	.word	RITECPname
	.byte	FOLDER_PRINTER_DRIVER

	.word	SCRIBEcvt
	.word	SCRIBEname
	.byte	FOLDER_PRINTER_DRIVER

	.word	SNB15cvt
	.word	SNB15name
	.byte	FOLDER_PRINTER_DRIVER

	.word	SNL10COMcvt
	.word	SNL10COMname
	.byte	FOLDER_PRINTER_DRIVER

	.word	SNX10cvt
	.word	SNX10name
	.byte	FOLDER_PRINTER_DRIVER

	.word	SNX10DScvt
	.word	SNX10DSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	SNX10QScvt
	.word	SNX10QSname
	.byte	FOLDER_PRINTER_DRIVER

	.word	SNX10Ccvt
	.word	SNX10Cname
	.byte	FOLDER_PRINTER_DRIVER

	.word	NX1000Rcvt
	.word	NX1000Rname
	.byte	FOLDER_PRINTER_DRIVER

	.word	SSG10cvt
	.word	SSG10name
	.byte	FOLDER_PRINTER_DRIVER

	.word	TOSHP321cvt
	.word	TOSHP321name
	.byte	FOLDER_PRINTER_DRIVER
.endif

bootstrapTableEnd:
