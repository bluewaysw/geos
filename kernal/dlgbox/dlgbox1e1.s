; GEOS KERNAL by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Dialog box: default icon descriptors

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "config.inc"
.include "kernal.inc"
.include "c64.inc"

.import DBIcDISK
.import DBIcPicDISK
.import DBIcOPEN
.import DBIcPicOPEN
.import DBIcNO
.import DBIcPicNO
.import DBIcYES
.import DBIcPicYES
.import DBIcCANCEL
.import DBIcPicCANCEL
.import DBIcOK
.import DBIcPicOK

.global DBDefIconsTab

.ifdef wheels
.global DBDefIconsTabRoutine
.endif

.segment "dlgbox1e1"

.ifdef bsw128
MSB = DOUBLE_B
.else
MSB = 0
.endif

.ifdef mega65
ICON_UNDERLAY_FLAG =	$4000
.else
ICON_UNDERLAY_FLAG =	0
.endif

DBDefIconsTab:
	.word DBIcPicOK | ICON_UNDERLAY_FLAG
	.word 0
	.byte MSB | 6, 16
DBDefIconsTabRoutine:
	.word DBIcOK

	.word DBIcPicCANCEL | ICON_UNDERLAY_FLAG
	.word 0
	.byte MSB | 6, 16
	.word DBIcCANCEL

	.word DBIcPicYES | ICON_UNDERLAY_FLAG
	.word 0
	.byte MSB | 6, 16
	.word DBIcYES

	.word DBIcPicNO | ICON_UNDERLAY_FLAG
	.word 0
	.byte MSB | 6, 16
	.word DBIcNO

	.word DBIcPicOPEN | ICON_UNDERLAY_FLAG
	.word 0
	.byte 6, 16
	.word DBIcOPEN

	.word DBIcPicDISK | ICON_UNDERLAY_FLAG
	.word 0
	.byte 6, 16
	.word DBIcDISK

