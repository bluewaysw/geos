.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"
.include "geosmac.inc"
.include "diskdrv.inc"

.include "ip/defs.inc"

.export __STARTUP_RUN__

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

.segment "STARTUP"

LINE_BUF_SIZE	=	256

HTTP_STATE_IDLE		=	0
HTTP_STATE_REQUEST	=	1
HTTP_STATE_HEADER	=	2
HTTP_STATE_BODY		=	3
HTTP_STATE_ERROR	=	4
HTTP_STATE_REDIRECT	=	5

__STARTUP_RUN__:
.if 0
	;jsr	CountMissingFiles		; -> r0

	;brk
	;lda	#$43

	LoadW	r0, CheckDialog
	jsr	DoDlgBox

	lda	r0L
	cmp	#OK
	bne	@10

	;jsr	eth_init

	jsr	prepare_network
.endif
	LoadW	r0, WelcomeDialog
	jsr	DoDlgBox
@10:
	jmp	EnterDeskTop

prepare_network:
	cli

	;// Setup WeeIP

	jsr	weeip_init
	LoadW	r0, eth_task
	jsr	task_cancel
	LoadB	r1L, 0
	LoadB	r1H, 0
	LoadW	r2H, ethName
	jsr	task_add

	LoadB	dblClickCount, 250
@22:
	lda	dblClickCount
	bne	@22

	;// Do DHCP auto-configuration
	LoadB	dhcp_configured, 0
	;printf("Configuring network via DHCP\n");
	jsr	dhcp_autoconfig

@20:
	lda	dhcp_configured
	bne	@10
	jsr	task_periodic
	LoadB	dblClickCount, 1
@21:
	lda	dblClickCount
	bne	@21
	bra	@20
@10:
	brk
	lda	#$FF
	LoadW	r0, hostName
	LoadW	r1, hostIP
	jsr	dns_hostname_to_ip

	LoadB	$D020, 0
	; send http GET request
	LoadW	r2, gp128cvt
	LoadW	r3, 10
	jsr	HTTP_GET
	;  printf("My IP is %d.%d.%d.%d\n",
	;	 ip_local.b[0],ip_local.b[1],ip_local.b[2],ip_local.b[3]);
	rts

; r0,r1 up address to connect to
; r2 = address of file name or URL (for re-direct)
; r3 = length of file name
HTTP_GET:
	PushW	r2
	PushW	r3
	PushW	r0
	PushW	r1

	LoadB	http_state, HTTP_STATE_IDLE
	LoadB	http_line_buf_pos, 0
	LoadB	http_redirect, 0
	LoadB	http_connected, 0
	LoadW	download_count, 1
	LoadB	download_pos, 2
	LoadW	download_packets, 0
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

	LoadW	r0, $5000
	LoadW	r1, 2048
	jsr	socket_set_rx_buffer

	PopW	r1
	PopW	r0
	MoveW	r0, a0
	MoveW	r1, a1
	LoadW	r2, 80
	jsr	socket_connect

	; wait to be connected
@20:
	lda	http_connected
	bne	@10
	jsr	task_periodic
	LoadB	dblClickCount, 1
@21:
	;lda	dblClickCount
	;bne	@21
	bra	@20
@10:
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

	PopW	r3
	PopW	r2
	MoveW	r2, @nameFrom
	MoveW	r3, @fromNameSize
	LoadW	r0, fileRequestBuf
	AddW	r7, r0
	MoveW	r0, @nameTo
	AddW	r3, r7
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
	jsr	socket_send

@30:
	jsr	task_periodic
	LoadB	dblClickCount, 1
@31:
	lda	dblClickCount
	bne	@31

	lda	http_connected
	bne	@30

	CmpBI	http_state, HTTP_STATE_REDIRECT
	beq	@_33
	jmp	@33
@_33:
	brk
	lda	#$71

	LoadW	r5, http_line_buf + (httpLocationHeaderEnd-httpLocationHeader)
	LoadW	r6, httpDomain
	ldx	#r5
	ldy	#r6
	lda	#<(httpDomainEnd - httpDomain)
	jsr	CmpFString


	LoadB	http_line_buf_pos, 0
	LoadB	http_connected, 0

	LoadB	http_state, HTTP_STATE_REQUEST

	MoveW	http_socket, r1
	jsr	socket_reset
	jsr	socket_release

	LoadB	r0L, SOCKET_TCP
	jsr	socket_create
	MoveW	r1, http_socket
	
	MoveW	a1, r1
	MoveW	a0, r0
	jsr	socket_select
	LoadW	r2, 80
	jsr	socket_connect

	; wait until connected
@_20:
	lda	http_connected
	bne	@_10
	jsr	task_periodic
	LoadB	dblClickCount, 1
@_21:
	;lda	dblClickCount
	;bne	@21
	bra	@_20
@_10:
	; redirect request
	; construct request
	LoadW	r7, 0
	
	brk
	lda	#$F7
	
	; get get
	jsr	i_MoveData
	.word	fileRequestPrefix		; from
	.word	fileRequestBuf
	.word	fileRequestPrefixEnd - fileRequestPrefix
	LoadW	r0, fileRequestPrefixEnd - fileRequestPrefix 
	AddW	r0, r7

	; copy url path
	AddW	r7, r0
	LoadW	r0, fileRequestBuf
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

@34:
	jsr	task_periodic
	LoadB	dblClickCount, 1
@33:
	lda	dblClickCount
	bne	@33

	lda	http_connected
	bne	@34
	rts
@err:
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
	beq	@12b
	jmp	@12
@12b:
	pha
	jsr	socket_data_size		; get data size to r0

	;IncW	download_packets
	;AddW	r0, download_packets

	LoadW	r1, 0
	LoadW	r2, $5000
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
	IncW	download_packets
	txa
	pha
	jsr	WriteBlockCount
	pla
	tax
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

	jsr	WriteBlockCount

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
	cmp	#WEEIP_EV_DISCONNECT
	beq	@11b
	cmp	#WEEIP_EV_DISCONNECT_WITH_DATA
	bne	@11
@11b:
	brk
	lda	#$93
	lda	http_state
	cmp	#HTTP_STATE_BODY
	bne	@17
	jsr	CloseFile

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

	brk
	lda	#$85

	;
	LoadB	http_state, HTTP_STATE_REDIRECT
	jsr	socket_disconnect

@end:
	rts

CloseFile:
	brk
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

WriteBlockCount:
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
jsr	UseSystemFont
MoveW	download_count, r0
LoadW	r11, 10
LoadB	r1H, 10
lda	#SET_SURPRESS|SET_LEFTJUST
jsr	PutDecimal

MoveW	download_packets, r0
LoadW	r11, 10
LoadB	r1H, 26
lda	#SET_SURPRESS|SET_LEFTJUST
jsr	PutDecimal

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


tempName:
	.byte	"Temp Download", $a0, $a0, $a0
http_line_buf:
	.repeat	LINE_BUF_SIZE
		.byte	0
	.endrep
http_line_buf_pos:
	.byte	0

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

fileRequestBuf:
	.repeat		1024
		.byte	0
	.endrep

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

CheckDialog:
	.byte	$81	; standard dialog, light bachground

	.byte	OK
	.byte	1, 74

	.byte	CANCEL
	.byte	17, 74

	.byte	NULL


WelcomeDialog:
	.byte	$81	; standard dialog, light bachground

	.byte	OK
	.byte	17, 74

	.byte	DBTXTSTR, 10,11
	.word	welcomeText

	.byte	DBTXTSTR, 10,21
	.word	geosVersionText

	.byte	DBTXTSTR, 10,33
	.word	versionDetails

	.byte	DBTXTSTR, 10,43
	.word	coreInfo

	.byte	DBTXTSTR, 10,55
	.word	warranties

	.byte	DBTXTSTR, 10,65
	.word	warranties2

	.byte	DBTXTSTR, 10,80
	.word	geoSpaceInfo

	.byte	DBTXTSTR, 10,89
	.word	bluewayswInfo

	.byte	NULL



welcomeText:
	.byte	BOLDON, OUTLINEON, "Welcome!", PLAINTEXT, NULL
geosVersionText:
	.byte	BOLDON, "GEOS V6.0 for the MEGA65", PLAINTEXT, NULL
versionDetails:
	.byte	"(11/21/21, BETA)", NULL
coreInfo:
	.byte	"M65 Core: master@009727e, build 4", NULL
warranties:
	.byte	"M65 Core: V920254", NULL
warranties2:
	.byte	BOLDON, "Use with care, no warranties!", PLAINTEXT, NULL
geoSpaceInfo:
	.byte	"establishing GeoSpace:", NULL
bluewayswInfo:
	.byte	BOLDON, "www.bluewaysw.de", NULL


FOLDER_PRINTER_DRIVER	= 10
FOLDER_APPLICATION 	= 3
FOLDER_FONTS		= 6
FOLDER_DEST_ACC		= 0
FOLDER_OTHER_DATA	= 5
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
	.byte	"MPS2000.CVT", NULL
MPS1200name:
	.byte	"MPS 1200", NULL

MPS1200DScvt:
	.byte	"MPS2000DS.CVT", NULL
MPS1200DSname:
	.byte	"MPS-1200 DS", NULL

MPS1200QScvt:
	.byte	"MPS2000QS.CVT", NULL
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
bootstrapTableEnd:
