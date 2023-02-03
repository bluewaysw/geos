.SEGMENT "OVERLAY6"
.ifdef mega65
.INCBIN	"build/mega65/drv/drv1571ram.bin"

.SEGMENT "OVERLAY7"
.INCBIN	"build/mega65/drv/drv1581ram.bin"

.else
.INCBIN	"build/mega65/drv/drv1581ram.bin"
.endif
