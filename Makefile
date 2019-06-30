
VARIANT     ?= mega65
DRIVE       ?= drvf011
INPUT       ?= megaphn
\INPUT       ?= mse1531

AS           = ca65
LD           = ld65
GRC          = grc65
C1541        = c1541
PUCRUNCH     = pucrunch
EXOMIZER     = exomizer
D64_TEMPLATE = GEOS64.D64
D64_RESULT   = geos.d64
D81_TEMPLATE = GEOS64.D81
D81_RESULT   = geos.d81
GEOS_OUT     = autoboot.c65
DESKTOP_CVT  = desktop.cvt

ASFLAGS      = -I inc -I .

# code that is in front bank of all variants
KERNAL_SOURCES= \
	kernal/bitmask/bitmask2.s \
	kernal/conio/conio1.s \
	kernal/conio/conio2.s \
	kernal/conio/conio3a.s \
	kernal/conio/conio4.s \
	kernal/conio/conio6.s \
	kernal/dlgbox/dlgbox1a.s \
	kernal/dlgbox/dlgbox1b.s \
	kernal/dlgbox/dlgbox1c.s \
	kernal/dlgbox/dlgbox1d.s \
	kernal/dlgbox/dlgbox1e1.s \
	kernal/dlgbox/dlgbox1e2.s \
	kernal/dlgbox/dlgbox1f.s \
	kernal/dlgbox/dlgbox1g.s \
	kernal/dlgbox/dlgbox1h.s \
	kernal/dlgbox/dlgbox1i.s \
	kernal/dlgbox/dlgbox1j.s \
	kernal/dlgbox/dlgbox1k.s \
	kernal/dlgbox/dlgbox2.s \
	kernal/files/files10.s \
	kernal/files/files1a2a.s \
	kernal/files/files1a2b.s \
	kernal/files/files1b.s \
	kernal/files/files2.s \
	kernal/files/files3.s \
	kernal/files/files6a.s \
	kernal/files/files6b.s \
	kernal/files/files6c.s \
	kernal/files/files7.s \
	kernal/files/files8.s \
	kernal/graph/clrscr.s \
	kernal/graph/inlinefunc.s \
	kernal/graph/graphicsstring.s \
	kernal/graph/graph2l1.s \
	kernal/graph/pattern.s \
	kernal/graph/inline.s \
	kernal/header/header.s \
	kernal/hw/hw1a.s \
	kernal/hw/hw1b.s \
	kernal/hw/hw2.s \
	kernal/hw/hw3.s \
	kernal/icon/icon1.s \
	kernal/icon/icon2.s \
	kernal/init/init1.s \
	kernal/init/init2.s \
	kernal/init/init3.s \
	kernal/init/init4.s \
	kernal/irq/irq.s \
	kernal/jumptab/jumptab.s \
	kernal/keyboard/keyboard1.s \
	kernal/keyboard/keyboard2.s \
	kernal/keyboard/keyboard3.s \
	kernal/load/deskacc.s \
	kernal/load/load1a.s \
	kernal/load/load1b.s \
	kernal/load/load1c.s \
	kernal/load/load2.s \
	kernal/load/load3.s \
	kernal/load/load4b.s \
	kernal/mainloop/mainloop1.s \
	kernal/mainloop/mainloop3.s \
	kernal/math/shl.s \
	kernal/math/shr.s \
	kernal/math/muldiv.s \
	kernal/math/neg.s \
	kernal/math/dec.s \
	kernal/math/random.s \
	kernal/math/crc.s \
	kernal/memory/memory1a.s \
	kernal/memory/memory1b.s \
	kernal/memory/memory2.s \
	kernal/memory/memory3.s \
	kernal/menu/menu1.s \
	kernal/menu/menu2.s \
	kernal/menu/menu3.s \
	kernal/misc/misc.s \
	kernal/mouse/mouse1.s \
	kernal/mouse/mouse2.s \
	kernal/mouse/mouse3.s \
	kernal/mouse/mouse4.s \
	kernal/mouse/mouseptr.s \
	kernal/panic/panic.s \
	kernal/patterns/patterns.s \
	kernal/process/process1.s \
	kernal/process/process2.s \
	kernal/process/process3a.s \
	kernal/process/process3aa.s \
	kernal/process/process3b.s \
	kernal/process/process3c.s \
	kernal/reu/reu.s \
	kernal/serial/serial1.s \
	kernal/serial/serial2.s \
	kernal/sprites/sprites.s \
	kernal/time/time1.s \
	kernal/time/time2.s \
	kernal/tobasic/tobasic2.s \
	kernal/vars/vars.s

# code that is in front bank of C64 only
ifneq ($(VARIANT), bsw128)
	KERNAL_SOURCES += \
	kernal/start/start64.s \
	kernal/bitmask/bitmask1.s \
	kernal/bitmask/bitmask3.s \
	kernal/bswfont/bswfont.s \
	kernal/conio/conio3b.s \
	kernal/conio/conio5.s \
	kernal/files/files9.s \
	kernal/fonts/fonts1.s \
	kernal/fonts/fonts2.s \
	kernal/fonts/fonts3.s \
	kernal/fonts/fonts4.s \
	kernal/fonts/fonts4a.s \
	kernal/fonts/fonts4b.s \
	kernal/graph/bitmapclip.s \
	kernal/graph/bitmapup.s \
	kernal/graph/line.s \
	kernal/graph/point.s \
	kernal/graph/rect.s \
	kernal/graph/scanline.s \
	kernal/mainloop/mainloop2.s \
	kernal/ramexp/ramexp1.s \
	kernal/ramexp/ramexp2.s \
	kernal/rename.s \
	kernal/tobasic/tobasic1.s
endif

# code that is in front bank of C128 only
ifeq ($(VARIANT), bsw128)
	KERNAL_SOURCES += \
	kernal/start/start128.s \
	kernal/128k/bank_jmptab_front.s \
	kernal/128k/banking.s \
	kernal/128k/cbm_jmptab.s \
	kernal/c128/iojmptab.s \
	kernal/c128/iowrapper.s \
	kernal/c128/irq_front.s \
	kernal/c128/junk_front.s \
	kernal/c128/low_jmptab.s \
	kernal/c128/mouseproxy.s \
	kernal/c128/vdc_base.s \
	kernal/c128/vdc_init.s \
	kernal/c128/vectors_front.s \
	kernal/files/compat.s \
	kernal/graph/normalize.s \
	kernal/graph/mode.s \
	kernal/memory/memory_128.s
endif


ifeq ($(VARIANT), mega65)
	KERNAL_SOURCES += \
	kernal/graph/normalize.s \
	kernal/graph/mode.s \
	kernal/640/bswfont80.s \
	kernal/graph/graph2p.s \
	kernal/c65/map.s \
	kernal/c65/iojmp.s \
	kernal/128k/swapdiskdriver.s
endif

# code that is in C128 back bank
KERNAL2_SOURCES= \
	kernal/128k/bank_jmptab_back.s \
	kernal/128k/cache.s \
	kernal/128k/swapdiskdriver.s \
	kernal/640/bswfont80.s \
	kernal/bitmask/bitmask1.s \
	kernal/bitmask/bitmask2.s \
	kernal/bitmask/bitmask3.s \
	kernal/bswfont/bswfont.s \
	kernal/c128/irq_back.s \
	kernal/c128/junk_back.s \
	kernal/c128/softsprites.s \
	kernal/c128/vdc.s \
	kernal/c128/vdc_base.s \
	kernal/c128/vectors_back.s \
	kernal/conio/conio3b.s \
	kernal/conio/conio5.s \
	kernal/files/files1a2a.s \
	kernal/files/files9.s \
	kernal/fonts/fonts1.s \
	kernal/fonts/fonts2.s \
	kernal/fonts/fonts3.s \
	kernal/fonts/fonts4.s \
	kernal/fonts/fonts4a.s \
	kernal/fonts/fonts4b.s \
	kernal/graph/line.s \
	kernal/graph/rect.s \
	kernal/graph/scanline.s \
	kernal/graph/graph2p.s \
	kernal/graph/bitmapclip.s \
	kernal/graph/bitmapup.s \
	kernal/graph/point.s \
	kernal/graph/normalize.s \
	kernal/math/shl.s \
	kernal/math/neg.s \
	kernal/memory/backram.s \
	kernal/tobasic/tobasic2_128.s

# code that is in Wheels front bank only
ifeq ($(VARIANT), wheels)
KERNAL_SOURCES += \
	kernal/wheels/wheels.s \
	kernal/wheels/ram.s \
	kernal/wheels/devnum.s \
	kernal/wheels/format.s \
	kernal/wheels/partition.s \
	kernal/wheels/directory.s \
	kernal/wheels/validate.s \
	kernal/wheels/copydisk.s \
	kernal/wheels/copyfile.s \
	kernal/wheels/loadb.s \
	kernal/wheels/tobasicb.s \
	kernal/wheels/reux.s
endif

ifeq ($(VARIANT), bsw128)
RELOCATOR_SOURCES = \
	kernal/start/relocator128.s
endif


DRIVER_SOURCES= \
	drv/drv1541.bin \
	drv/drv1571.bin \
	drv/drv1581.bin \
	drv/drv1581_21hd.bin \
	drv/drv1571ram.bin \
	drv/drv1581ram.bin \
	input/joydrv.bin \
	input/megaphn.bin \
	input/amigamse.bin \
	input/lightpen.bin \
	input/mse1531.bin \
	input/koalapad.bin \
	input/pcanalog.bin

# code that is in MEGA65 compiled with 4502 cpu
ifeq ($(VARIANT), mega65)
DRIVER_SOURCES += \
	drv/drvf011.bin
endif

DEPS= \
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

KERNAL_OBJS=$(KERNAL_SOURCES:.s=.o)
KERNAL2_OBJS=$(KERNAL2_SOURCES:.s=.o)
RELOCATOR_OBJS=$(RELOCATOR_SOURCES:.s=.o)
DRIVER_OBJS=$(DRIVER_SOURCES:.s=.o)
ALL_OBJS=$(KERNAL_OBJS) $(DRIVER_OBJS)

BUILD_DIR=build/$(VARIANT)

PREFIXED_KERNAL_OBJS = $(addprefix $(BUILD_DIR)/, $(KERNAL_OBJS))
PREFIXED_KERNAL2_OBJS = $(addprefix $(BUILD_DIR)/, $(KERNAL2_OBJS))
PREFIXED_RELOCATOR_OBJS = $(addprefix $(BUILD_DIR)/, $(RELOCATOR_OBJS))

ALL_BINS= \
	$(BUILD_DIR)/kernal/kernal.bin \
	$(BUILD_DIR)/drv/drv1541.bin \
	$(BUILD_DIR)/drv/drv1571.bin \
	$(BUILD_DIR)/drv/drv1581.bin \
	$(BUILD_DIR)/drv/drv1581_21hd.bin \
	$(BUILD_DIR)/drv/drv1571ram.bin \
	$(BUILD_DIR)/drv/drv1581ram.bin \
	$(BUILD_DIR)/input/joydrv.bin \
	$(BUILD_DIR)/input/megaphn.bin \
	$(BUILD_DIR)/input/amigamse.bin \
	$(BUILD_DIR)/input/lightpen.bin \
	$(BUILD_DIR)/input/mse1531.bin \
	$(BUILD_DIR)/input/koalapad.bin \
	$(BUILD_DIR)/input/pcanalog.bin


# code that is in MEGA65 compiled with 4502 cpu
ifeq ($(VARIANT), mega65)
ALL_BINS += \
	$(BUILD_DIR)/drv/drvf011.bin
endif

ifeq ($(VARIANT), bsw128)
	ALL_BINS += \
	$(BUILD_DIR)/kernal/kernal2.bin \
	$(BUILD_DIR)/kernal/relocator.bin
endif

all: $(BUILD_DIR)/$(D64_RESULT) $(BUILD_DIR)/$(D81_RESULT)

regress:
	@echo "********** Building variant 'bsw'"
	@$(MAKE) VARIANT=bsw all
	./regress.sh bsw
	@echo "********** Building variant 'wheels'"
	@$(MAKE) VARIANT=wheels all
	./regress.sh wheels

clean:
	rm -rf build

$(BUILD_DIR)/$(D64_RESULT): $(BUILD_DIR)/kernal_compressed.prg
	@if [ -e $(D64_TEMPLATE) ]; then \
		cp $(D64_TEMPLATE) $@; \
		echo delete geos geoboot | $(C1541) $@ >/dev/null; \
		echo write $< geos $(GEOS_OUT) | $(C1541) $@ >/dev/null; \
		echo \*\*\* Created $@ based on $(D64_TEMPLATE).; \
	else \
		echo format geos,00 d64 $@ | $(C1541) >/dev/null; \
		echo write $< geos | $(C1541) $@ >/dev/null; \
		if [ -e $(DESKTOP_CVT) ]; then echo geoswrite $(DESKTOP_CVT) | $(C1541) $@; fi >/dev/null; \
		echo \*\*\* Created fresh $@.; \
	fi;

$(BUILD_DIR)/$(D81_RESULT): $(BUILD_DIR)/kernal_compressed.prg $(BUILD_DIR)/topdesk.cvt $(BUILD_DIR)/config.cvt
	@if [ -e $(D81_TEMPLATE) ]; then \
		cp $(D81_TEMPLATE) $@; \
		echo delete geos $(GEOS_OUT) configure geoboot | $(C1541) $@ >/dev/null; \
		echo write $< $(GEOS_OUT) | $(C1541) $@ >/dev/null; \
		echo delete \"desk top\"| $(C1541) $@ >/dev/null; \
		echo delete \"65 desktop\"| $(C1541) $@ >/dev/null; \
		echo delete \"65 configure\"| $(C1541) $@ >/dev/null; \
		echo delete \"geopaint\"| $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/topdesk.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/config.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite gpt64.cvt | $(C1541) $@ >/dev/null; \
		echo \*\*\* Created $@ based on $(D81_TEMPLATE).; \
	else \
		echo format geos,00 d81 $@ | $(C1541) >/dev/null; \
		echo write $< $(GEOS_OUT) | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/config.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/topdesk.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite GW128.CVT | $(C1541) $@ >/dev/null; \
		echo geoswrite gpt64.cvt | $(C1541) $@ >/dev/null; \
		if [ -e $(DESKTOP_CVT) ]; then echo geoswrite $(DESKTOP_CVT) | $(C1541) $@; fi >/dev/null; \
		echo \*\*\* Created fresh $@.; \
	fi;


ifeq ($(VARIANT), mega65)

$(BUILD_DIR)/topdesk/topdesk.o:
	@mkdir -p `dirname $@`
	$(GRC) -s $(BUILD_DIR)/topdesk/topdesk.s -o $(BUILD_DIR)/topdesk/topdesk.c topdesk/topdesk65.grc
	$(AS) -D $(VARIANT)=1 -D $(DRIVE)=1 -D $(INPUT)=1 $(ASFLAGS) $(BUILD_DIR)/topdesk/topdesk.s -o $@
else

$(BUILD_DIR)/topdesk/topdesk.o:
	@mkdir -p `dirname $@`
	$(GRC) -s $(BUILD_DIR)/topdesk/topdesk.s -o $(BUILD_DIR)/topdesk/topdesk.c topdesk/topdesk.grc
	$(AS) -D $(VARIANT)=1 -D $(DRIVE)=1 -D $(INPUT)=1 $(ASFLAGS) $(BUILD_DIR)/topdesk/topdesk.s -o $@
endif

ifeq ($(VARIANT), mega65)
$(BUILD_DIR)/configure/configure.o:
	@mkdir -p `dirname $@`
	$(GRC) -s $(BUILD_DIR)/configure/configure.s -o $(BUILD_DIR)/configure/configure.c configure/configure65.grc
	$(AS) -D $(VARIANT)=1 -D $(DRIVE)=1 -D $(INPUT)=1 $(ASFLAGS) $(BUILD_DIR)/configure/configure.s -o $@

else
$(BUILD_DIR)/configure/configure.o:
	@mkdir -p `dirname $@`
	$(GRC) -s $(BUILD_DIR)/configure/configure.s -o $(BUILD_DIR)/configure/configure.c configure/configure.grc
	$(AS) -D $(VARIANT)=1 -D $(DRIVE)=1 -D $(INPUT)=1 $(ASFLAGS) $(BUILD_DIR)/configure/configure.s -o $@
endif

$(BUILD_DIR)/config.cvt: $(BUILD_DIR)/configure/configure.o $(BUILD_DIR)/configure/r0.o $(BUILD_DIR)/configure/r2.o \
                                $(BUILD_DIR)/configure/r3.o $(BUILD_DIR)/configure/r4.o $(BUILD_DIR)/configure/r5.o \
								$(BUILD_DIR)/configure/r6.o $(BUILD_DIR)/configure/r1.o
	$(LD) -C configure/configure.cfg -o $@ $(BUILD_DIR)/configure/configure.o -m $(BUILD_DIR)/configure.map $(BUILD_DIR)/configure/r0.o \
			$(BUILD_DIR)/configure/r2.o $(BUILD_DIR)/configure/r3.o $(BUILD_DIR)/configure/r4.o \
			$(BUILD_DIR)/configure/r5.o $(BUILD_DIR)/configure/r6.o $(BUILD_DIR)/configure/r1.o

$(BUILD_DIR)/topdesk.cvt: $(BUILD_DIR)/topdesk/topdesk.o $(BUILD_DIR)/topdesk/Main/DeskTop.main.o $(BUILD_DIR)/topdesk/Main/DeskTop.sub.o \
											$(BUILD_DIR)/topdesk/Main/DeskTop.sub2.o \
											$(BUILD_DIR)/topdesk/Main/DeskTop.sub3.o \
											$(BUILD_DIR)/topdesk/Main/DeskTop.sub4.o \
											$(BUILD_DIR)/topdesk/Main/DeskTop.sub5.o \
											$(BUILD_DIR)/topdesk/Main/DeskTop.sub6.o \
											$(BUILD_DIR)/topdesk/Main/DeskTop.sub7.o \
											$(BUILD_DIR)/topdesk/Main/DeskTop.sub8.o \
											$(BUILD_DIR)/topdesk/Main/DeskTop.sub9.o \
											$(BUILD_DIR)/topdesk/Main/DeskTop.sub10.o
	$(LD) -C topdesk/topdesk.cfg -o $@ $(BUILD_DIR)/topdesk/topdesk.o -m $(BUILD_DIR)/topdesk.map $(BUILD_DIR)/topdesk/Main/DeskTop.main.o \
								$(BUILD_DIR)/topdesk/Main/DeskTop.sub.o $(BUILD_DIR)/topdesk/Main/DeskTop.sub2.o \
								$(BUILD_DIR)/topdesk/Main/DeskTop.sub3.o $(BUILD_DIR)/topdesk/Main/DeskTop.sub4.o \
								$(BUILD_DIR)/topdesk/Main/DeskTop.sub5.o $(BUILD_DIR)/topdesk/Main/DeskTop.sub6.o \
								$(BUILD_DIR)/topdesk/Main/DeskTop.sub7.o $(BUILD_DIR)/topdesk/Main/DeskTop.sub8.o \
								$(BUILD_DIR)/topdesk/Main/DeskTop.sub9.o $(BUILD_DIR)/topdesk/Main/DeskTop.sub10.o

ifeq ($(VARIANT), mega65)
$(BUILD_DIR)/compressed.bin: $(BUILD_DIR)/kernal_combined.prg
	$(EXOMIZER) mem $<,0x5000 -o $@

$(BUILD_DIR)/compressed_mega65.prg: $(BUILD_DIR)/compressed.bin $(BUILD_DIR)/loader/uncrunch.o $(BUILD_DIR)/loader/loader.o
	$(LD) -C loader/loader.cfg $(BUILD_DIR)/loader/loader.o -m $(BUILD_DIR)/kernel.map $(BUILD_DIR)/loader/uncrunch.o -o $@
endif

ifeq ($(VARIANT), mega65)
$(BUILD_DIR)/kernal_compressed.prg: $(BUILD_DIR)/compressed_mega65.prg
else
$(BUILD_DIR)/kernal_compressed.prg: $(BUILD_DIR)/kernal_combined.prg
endif
	@echo Creating $@
ifeq ($(VARIANT), bsw128)
	# pucrunch can't compress for C128 :(
	cp $< $@
else ifeq ($(VARIANT), mega65)
	cp $< $@
else
	$(PUCRUNCH) -f -c64 -x0x5000 $< $@ 2> /dev/null
endif

$(BUILD_DIR)/kernal_combined.prg: $(ALL_BINS)
ifeq ($(VARIANT), bsw128)
	@echo Creating $@ from kernal.bin $(DRIVE).bin kernal2.bin relocator.bin $(INPUT).bin
	printf "\x00\x48" > $(BUILD_DIR)/tmp.bin
# relocator.bin($4800) @ $4800-$4C00 -> $4800
	cat $(BUILD_DIR)/kernal/relocator.bin /dev/zero | dd bs=1 count=1024 >> $(BUILD_DIR)/tmp.bin 2> /dev/null
# kernal.bin($5000)    @ $5000-$5400 -> $4C00
	cat $(BUILD_DIR)/kernal/kernal.bin /dev/zero | dd bs=1 count=1024 >> $(BUILD_DIR)/tmp.bin 2> /dev/null
# kernal.bin($5000)    @ $C000-$0000 -> $5000
	cat $(BUILD_DIR)/kernal/kernal.bin /dev/zero | dd bs=1 count=16384 skip=28672 >> $(BUILD_DIR)/tmp.bin 2> /dev/null
# drv*.bin($9000)      @ $9000-$9D80 -> $9000
	cat $(BUILD_DIR)/drv/$(DRIVE).bin /dev/zero | dd bs=1 count=3456 >> $(BUILD_DIR)/tmp.bin 2> /dev/null
# kernal.bin($5000)    @ $9D80-$A000 -> $9D80
	cat $(BUILD_DIR)/kernal/kernal.bin /dev/zero | dd bs=1 count=640 skip=19840 >> $(BUILD_DIR)/tmp.bin 2> /dev/null
# kernal2.bin($C000)   @ $E000-$0000 -> $A000
	cat $(BUILD_DIR)/kernal/kernal2.bin /dev/zero | dd bs=1 count=8192 skip=8192 >> $(BUILD_DIR)/tmp.bin 2> /dev/null
# kernal2.bin($C000)   @ $C000-$E000 -> $C000
	cat $(BUILD_DIR)/kernal/kernal2.bin /dev/zero | dd bs=1 count=8192 >> $(BUILD_DIR)/tmp.bin 2> /dev/null

	@mv $(BUILD_DIR)/tmp.bin $(BUILD_DIR)/kernal_combined.prg

else
	@echo Creating $@ from kernal.bin $(DRIVE).bin $(INPUT).bin
	cp tmp2.bin $(BUILD_DIR)/tmp.bin
	dd if=$(BUILD_DIR)/kernal/kernal.bin bs=1 count=16384 >> $(BUILD_DIR)/tmp.bin 2> /dev/null
	cat $(BUILD_DIR)/drv/$(DRIVE).bin /dev/zero | dd bs=1 count=3456 >> $(BUILD_DIR)/tmp.bin 2> /dev/null
	cat $(BUILD_DIR)/kernal/kernal.bin /dev/zero | dd bs=1 count=24832 skip=19840 >> $(BUILD_DIR)/tmp.bin 2> /dev/null
	@cat $(BUILD_DIR)/input/$(INPUT).bin >> $(BUILD_DIR)/tmp.bin 2> /dev/null
	@mv $(BUILD_DIR)/tmp.bin $(BUILD_DIR)/kernal_combined.prg
endif

$(BUILD_DIR)/drv/drv1541.bin: $(BUILD_DIR)/drv/drv1541.o drv/drv1541.cfg $(DEPS)
	$(LD) -C drv/drv1541.cfg $(BUILD_DIR)/drv/drv1541.o -o $@

$(BUILD_DIR)/drv/drv1571.bin: $(BUILD_DIR)/drv/drv1571.o drv/drv1571.cfg $(DEPS)
	$(LD) -C drv/drv1571.cfg $(BUILD_DIR)/drv/drv1571.o -o $@

$(BUILD_DIR)/drv/drv1581.bin: $(BUILD_DIR)/drv/drv1581.o drv/drv1581.cfg $(DEPS)
	$(LD) -C drv/drv1581.cfg $(BUILD_DIR)/drv/drv1581.o -o $@

$(BUILD_DIR)/drv/drv1581_21hd.bin: $(BUILD_DIR)/drv/drv1581_21hd.o drv/drv1581_21hd.cfg $(DEPS)
	$(LD) -C drv/drv1581_21hd.cfg $(BUILD_DIR)/drv/drv1581_21hd.o -o $@

$(BUILD_DIR)/drv/drv1571ram.bin: $(BUILD_DIR)/drv/drv1571ram.o drv/drv1571ram.cfg $(DEPS)
	$(LD) -C drv/drv1571ram.cfg $(BUILD_DIR)/drv/drv1571ram.o -o $@

$(BUILD_DIR)/drv/drv1581ram.bin: $(BUILD_DIR)/drv/drv1581ram.o drv/drv1581ram.cfg $(DEPS)
	$(LD) -C drv/drv1581ram.cfg $(BUILD_DIR)/drv/drv1581ram.o -o $@

$(BUILD_DIR)/drv/drvf011.bin: $(BUILD_DIR)/drv/drvf011.o drv/drvf011.cfg $(DEPS)
	$(LD) -C drv/drvf011.cfg $(BUILD_DIR)/drv/drvf011.o -o $@

$(BUILD_DIR)/input/amigamse.bin: $(BUILD_DIR)/input/amigamse.o input/amigamse.cfg $(DEPS)
	$(LD) -C input/amigamse.cfg $(BUILD_DIR)/input/amigamse.o -o $@

$(BUILD_DIR)/input/joydrv.bin: $(BUILD_DIR)/input/joydrv.o input/joydrv.cfg $(DEPS)
	$(LD) -C input/joydrv.cfg $(BUILD_DIR)/input/joydrv.o -o $@

$(BUILD_DIR)/input/megaphn.bin: $(BUILD_DIR)/input/megaphn.o input/megaphn.cfg $(DEPS)
	$(LD) -C input/megaphn.cfg $(BUILD_DIR)/input/megaphn.o -o $@

$(BUILD_DIR)/input/lightpen.bin: $(BUILD_DIR)/input/lightpen.o input/lightpen.cfg $(DEPS)
	$(LD) -C input/lightpen.cfg $(BUILD_DIR)/input/lightpen.o -o $@

$(BUILD_DIR)/input/mse1531.bin: $(BUILD_DIR)/input/mse1531.o input/mse1531.cfg $(DEPS)
	$(LD) -C input/mse1531.cfg $(BUILD_DIR)/input/mse1531.o -o $@

$(BUILD_DIR)/input/koalapad.bin: $(BUILD_DIR)/input/koalapad.o input/koalapad.cfg $(DEPS)
	$(LD) -C input/koalapad.cfg $(BUILD_DIR)/input/koalapad.o -o $@

$(BUILD_DIR)/input/pcanalog.bin: $(BUILD_DIR)/input/pcanalog.o input/pcanalog.cfg $(DEPS)
	$(LD) -C input/pcanalog.cfg $(BUILD_DIR)/input/pcanalog.o -o $@

$(BUILD_DIR)/%.o: %.s
	@mkdir -p `dirname $@`
	$(AS) -D $(VARIANT)=1 -D $(DRIVE)=1 -D $(INPUT)=1 $(ASFLAGS) $< -o $@

$(BUILD_DIR)/kernal/kernal.bin: $(PREFIXED_KERNAL_OBJS) kernal/kernal_$(VARIANT).cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C kernal/kernal_$(VARIANT).cfg $(PREFIXED_KERNAL_OBJS) -o $@ -m $(BUILD_DIR)/kernal/kernal.map -Ln $(BUILD_DIR)/kernal/kernal.lab

$(BUILD_DIR)/kernal/kernal2.bin: $(PREFIXED_KERNAL2_OBJS) kernal/kernal2_$(VARIANT).cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C kernal/kernal2_$(VARIANT).cfg $(PREFIXED_KERNAL2_OBJS) -o $@ -m $(BUILD_DIR)/kernal/kernal2.map  -Ln $(BUILD_DIR)/kernal/kernal2.lab

$(BUILD_DIR)/kernal/relocator.bin: $(PREFIXED_RELOCATOR_OBJS) kernal/relocator_$(VARIANT).cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C kernal/relocator_$(VARIANT).cfg $(PREFIXED_RELOCATOR_OBJS) -o $@ -m $(BUILD_DIR)/kernal/relocator.map  -Ln $(BUILD_DIR)/kernal/relocator.lab

# a must!
love:
	@echo "Not war, eh?"
