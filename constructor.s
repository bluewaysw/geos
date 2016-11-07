; ----------------------------------------------------------------------------
; WARNING! This is not a "real" assembly source too much, just a tricky use of
; an assembler to glue binaries together :)
; No native code, etc is allowed, of course!
; ----------------------------------------------------------------------------
; Constructs the GEOS kernal from BIN files using CA65
; I like this idea better than the 'dd' stuff in the old Makefile
; ----------------------------------------------------------------------------
; Also, in this way, some kind of config file can be used to change the build,
; ie, what disk driver is included into the final build, etc!
; ----------------------------------------------------------------------------
; (C)2016 LGB Gábor Lénárt


.INCLUDE "config.inc"

.ORG	$5000
.INCBIN	BUILDER_BIN_START_NAME
.RES	$9000 - *, 0
.INCBIN	BUILDER_BIN_DSKDRV_NAME
.RES	$9D80 - *, 0
.INCBIN	BUILDER_BIN_LOKERNAL_NAME
.RES	$BF40 - *, 0
.INCBIN	BUILDER_BIN_KERNAL_NAME
.RES	$FE80 - *, 0
.INCBIN	BUILDER_BIN_INPDRV_NAME
