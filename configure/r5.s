.SEGMENT "OVERLAY5"
.ifdef mega65
.INCBIN	"build/mega65/drv/drvf011.bin"
.else
.INCBIN	"build/mega65/drv/drv1571ram.bin"
.endif