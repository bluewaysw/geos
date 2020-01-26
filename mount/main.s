.include "const.inc"
.include "geossym.inc"
.include "geossym2.inc"
.include "geosmac.inc"


.export __STARTUP_RUN__

.segment "STARTUP"

__STARTUP_RUN__:
	jmp EnterDeskTop
