AS		= ca65
LD		= ld65
CL		= cl65
C1541		= c1541
EXOMIZER	= exomizer
PUCRUNCH	= pucrunch
D64_TEMPLATE	= GEOS64.D64
D64_RESULT	= geos.d64
D81_TEMPLATE	= GEOS64.D81
D81_RESULT	= geos.d81
ASFLAGS		= -I inc -I .

KERNAL_SOURCES= \
	kernal/bitmask.s \
	kernal/bswfont.s \
	kernal/conio.s \
	kernal/dlgbox.s \
	kernal/filesys.s \
	kernal/fonts.s \
	kernal/graph.s \
	kernal/header.s \
	kernal/hw.s \
	kernal/icon.s \
	kernal/init.s \
	kernal/irq.s \
	kernal/jumptable.s \
	kernal/keyboard.s \
	kernal/load.s \
	kernal/mainloop.s \
	kernal/math.s \
	kernal/memory.s \
	kernal/menu.s \
	kernal/misc.s \
	kernal/mouse.s \
	kernal/panic.s \
	kernal/patterns.s \
	kernal/process.s \
	kernal/reu.s \
	kernal/serial.s \
	kernal/sprites.s \
	kernal/start.s \
	kernal/time.s \
	kernal/tobasic.s \
	kernal/vars.s \
	c65/start.s

DEPS= \
	Makefile \
	config.inc \
	inc/c64.inc \
	inc/const.inc \
	inc/diskdrv.inc \
	inc/geosmac.inc \
	inc/geossym.inc \
	inc/inputdrv.inc \
	inc/jumptab.inc \
	inc/kernal.inc \
	inc/printdrv.inc

KERNAL_OBJECTS=$(KERNAL_SOURCES:.s=.o)

ALL_BINS= \
	kernal.bin \
	lokernal.bin \
	start.bin \
	drv1541.bin \
	drv1571.bin \
	drv1581.bin \
	drvf011.bin \
	amigamse.bin \
	joydrv.bin \
	lightpen.bin \
	mse1531.bin \
	koalapad.bin \
	pcanalog.bin

all: $(D64_RESULT) $(D81_RESULT)

clean:
	rm -f $(KERNAL_OBJECTS) drv/*.o input/*.o $(ALL_BINS) combined.bin combined.prg compressed.prg $(D64_RESULT) $(D81_RESULT) compressed_c65.prg compressed.bin c65/*.o kernal.map constructor.o

$(D64_RESULT): compressed.prg
	if [ -s $(D64_TEMPLATE) ]; then \
		cp $(D64_TEMPLATE) $(D64_RESULT); \
		echo 'delete geos geoboot configure "geos kernal"' | $(C1541) $(D64_RESULT) >/dev/null; \
		echo write compressed.prg geos | $(C1541) $(D64_RESULT) >/dev/null; \
		echo \*\*\* Created $(D64_RESULT) based on $(D64_TEMPLATE).; \
	else \
		rm -f $(D64_RESULT); \
		echo format geos,00 d64 $(D64_RESULT) | $(C1541) >/dev/null; \
		echo write compressed.prg geos | $(C1541) $(D64_RESULT) >/dev/null; \
		if [ -e desktop.cvt ]; then echo geoswrite desktop.cvt | $(C1541) $(D64_RESULT); fi >/dev/null; \
		echo \*\*\* Created fresh $(D64_RESULT).; \
	fi;

$(D81_RESULT): compressed.prg compressed_c65.prg
	if [ -s $(D81_TEMPLATE) ]; then \
		cp $(D81_TEMPLATE) $(D81_RESULT); \
		echo 'delete geos geoboot configure "geos kernal"' | $(C1541) $(D81_RESULT) >/dev/null; \
		echo write compressed.prg geos | $(C1541) $(D81_RESULT) >/dev/null; \
		echo write compressed_c65.prg geos65 | $(C1541) $(D81_RESULT) >/dev/null; \
		echo \*\*\* Created $(D81_RESULT) based on $(D81_TEMPLATE).; \
	else \
		rm -f $(D81_RESULT); \
		echo format geos,00 d81 $(D81_RESULT) | $(C1541) >/dev/null; \
		echo write compressed.prg geos | $(C1541) $(D81_RESULT) >/dev/null; \
		echo write compressed_c65.prg geos65 | $(C1541) $(D81_RESULT) >/dev/null; \
		if [ -e desktop.cvt ]; then echo geoswrite desktop.cvt | $(C1541) $(D81_RESULT); fi >/dev/null; \
		echo \*\*\* Created fresh $(D81_RESULT).; \
	fi;

compressed_c65.prg: compressed.bin c65/uncrunch.o c65/loader.o
	$(LD) -C c65/loader.cfg c65/loader.o c65/uncrunch.o -o $@

compressed.prg: combined.prg
	$(PUCRUNCH) +f -c64 -x0x5000 $< $@

compressed.bin: combined.bin
	$(EXOMIZER) mem $<,0x5002 -o $@

combined.bin: $(ALL_BINS) $(DEPS) constructor.s
	$(CL) -t none -o $@ constructor.s
	rm -f constructor.o

combined.prg: combined.bin
	printf "\x00\x50" > $@
	cat $< >> $@

kernal.bin: $(KERNAL_OBJECTS) kernal/kernal.cfg
	$(LD) -C kernal/kernal.cfg $(KERNAL_OBJECTS) -o $@ -m kernal.map

lokernal.bin: kernal.bin

start.bin: kernal.bin

drv1541.bin: drv/drv1541.o drv/drv1541.cfg $(DEPS)
	$(LD) -C drv/drv1541.cfg drv/drv1541.o -o $@

drv1571.bin: drv/drv1571.o drv/drv1571.cfg $(DEPS)
	$(LD) -C drv/drv1571.cfg drv/drv1571.o -o $@

drv1581.bin: drv/drv1581.o drv/drv1581.cfg $(DEPS)
	$(LD) -C drv/drv1581.cfg drv/drv1581.o -o $@

drvf011.bin: c65/drvf011.o c65/drvf011.cfg $(DEPS)
	$(LD) -C c65/drvf011.cfg c65/drvf011.o -o $@

amigamse.bin: input/amigamse.o input/amigamse.cfg $(DEPS)
	$(LD) -C input/amigamse.cfg input/amigamse.o -o $@

joydrv.bin: input/joydrv.o input/joydrv.cfg $(DEPS)
	$(LD) -C input/joydrv.cfg input/joydrv.o -o $@

lightpen.bin: input/lightpen.o input/lightpen.cfg $(DEPS)
	$(LD) -C input/lightpen.cfg input/lightpen.o -o $@

mse1531.bin: input/mse1531.o input/mse1531.cfg $(DEPS)
	$(LD) -C input/mse1531.cfg input/mse1531.o -o $@

koalapad.bin: input/koalapad.o input/koalapad.cfg $(DEPS)
	$(LD) -C input/koalapad.cfg input/koalapad.o -o $@

pcanalog.bin: input/pcanalog.o input/pcanalog.cfg $(DEPS)
	$(LD) -C input/pcanalog.cfg input/pcanalog.o -o $@

%.o: %.s $(DEPS)
	$(AS) $(ASFLAGS) $< -o $@

# a must!
love:	
	@echo "Not war, eh?"
the:
	@echo "Just read the .PHONY line in Makefile ;-)"

.PHONY:
	clean all the love
