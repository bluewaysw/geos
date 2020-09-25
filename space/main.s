.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"
.include "geosmac.inc"
.include "diskdrv.inc"


.export __STARTUP_RUN__

.segment "STARTUP"

__STARTUP_RUN__:
	LoadW	r0, WelcomeDialog
	jsr	DoDlgBox

	jmp	EnterDeskTop

	
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
	.byte	"(09/21/20, alpha preview)", NULL
coreInfo:
	.byte	"MEGA65 dev core: @192/56 3990bec", NULL
warranties:
	.byte	"Work in progress...", NULL
warranties2:
	.byte	BOLDON, "Use with care, no warranties!", PLAINTEXT, NULL
geoSpaceInfo:
	.byte	"establishing GeoSpace:", NULL
bluewayswInfo:
	.byte	BOLDON, "www.bluewaysw.de", NULL
	

