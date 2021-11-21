
VARIANT     ?= mega65
DRIVE       ?= drvf011
#INPUT       ?= megaphn
#INPUT       ?= mse1351
INPUT      ?= joydrv
#INPUT       ?= amigamse

AS           = ca65
LD           = ld65
CL           = cl65
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
WEEIP_SRC    = test/mega65-weeip/src

CONFIRM_CBMFILES_PERSONAL_USE_LICENSE	?= NO

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
	kernal/vars/vars.s \
	kernal/debug/main.s \

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
	kernal/128k/swapdiskdriver.s \
	kernal/files/compat.s \
	kernal/memory/backram.s
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
	input/mse1351.bin \
	input/mega1351.bin \
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
	$(BUILD_DIR)/input/mse1351.bin \
	$(BUILD_DIR)/input/mega1351.bin \
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

prmgr128.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/PRMGR128.CVT

pdmgr128.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/PDMGR128.CVT

calc128.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/CALC128.CVT

spell128.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/SPELL128.CVT

spelldata.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/DICT.CVT

merge128.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/GM128.CVT

alarm128.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/ALARM128.CVT

california.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/CALIF.CVT

cory.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/CORY.CVT

dwinelle.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/DWIN.CVT

roma.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/ROMA.CVT

university.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/UNIV.CVT

commfont.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/COMMFONT.CVT

lwroma.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/LWROMA.CVT

lwcal.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/LWCAL.CVT

lwgreek.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/LWGREEK.CVT

lwbarrows.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/LWBARR.CVT

notepad.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/NOTE128.CVT

photo_mgr.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/PHMGR128.CVT

text_mgr.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/TXMGR128.CVT

gw128.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/GW128.CVT

gpt128.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/GPT128.CVT

paint_drivers.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/PNTDRVRS.CVT

geolaser.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/GEOLASER.CVT

text_grabber128.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/TG128.CVT

tgfs4128.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/TGFS4128.CVT

tgpc2128.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/TGPC2128.CVT

tgww128.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/TGWW128.CVT

tgg1128.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/TGG1128.CVT

tgg2128.cvt:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/TGG2128.CVT
dt128.cvt:
	curl --output $(BUILD_DIR)/G1281581.ZIP https://cbmfiles.com/geos/geosfiles/G1281581.ZIP
	unzip $(BUILD_DIR)/G1281581.ZIP
	echo geosread \"128 DESKTOP\" dt128.cvt | $(C1541) GEOS128.D81 >/dev/null;
%.CVT:
	curl --output $@ https://cbmfiles.com/geos/geosfiles/$@

ifdef XCV
1526.CVT
ASC.CVT
BCM120.CVT
CI8510.CVT
CI8510A.CVT
CI8510DS.CVT
CI8510QS.CVT
CIRED.CVT
COMMCOMP.CVT
EPFX80.CVT
EPFX80DS.CVT
EPFX80QS.CVT
EPJX80.CVT
EPLQ1500.CVT
EPLX80.CVT
EPMX80.CVT
EPRED.CVT
GEM10X.CVT
GEMDS.CVT
GEMQS.CVT
IBM51P.CVT
IBM51PDS.CVT
IBM51PQS.CVT
IMW.CVT
IMWDS.CVT
IMWQS.CVT
IMW2.CVT
IMW2DS.CVT
IMW2QS.CVT
LJPAR.CVT
LJSER.CVT
LW21.CVT
MPS801.CVT
MPS803.CVT
MPS1000.CVT
MPS1200.CVT
MPS1200DS.CVT
MPS1200QS.CVT
OK120.CVT
OK120NLQ.CVT
OKML92.CVT
OK10.CVT
OK20.CVT
OLPR2300.CVT
RITECP.CVT
SCRIBE.CVT
SNB15.CVT
SNL10COM.CVT
SNX10.CVT
SNX10DS.CVT
SNX10QS.CVT
SNX10C.CVT
NX1000R.CVT
SSG10.CVT
TOSHP321.CVT
dt128.cvt
endif

$(BUILD_DIR)/$(D81_RESULT): $(BUILD_DIR)/kernal_compressed.prg $(BUILD_DIR)/topdesk.cvt \
	$(BUILD_DIR)/mount.cvt $(BUILD_DIR)/clock.cvt $(BUILD_DIR)/config.cvt \
	$(BUILD_DIR)/joydrv.cvt $(BUILD_DIR)/mse1351.cvt $(BUILD_DIR)/mega1351.cvt \
	prmgr128.cvt pdmgr128.cvt alarm128.cvt calc128.cvt \
	spell128.cvt merge128.cvt spelldata.cvt gw128.cvt gpt128.cvt \
	$(BUILD_DIR)/printer_driver.cvt $(BUILD_DIR)/document.cvt \
	$(BUILD_DIR)/font.cvt $(BUILD_DIR)/other_data.cvt \
	$(BUILD_DIR)/misc.cvt \
	$(BUILD_DIR)/coding.cvt \
	$(BUILD_DIR)/input_driver.cvt $(BUILD_DIR)/utilities.cvt \
	$(BUILD_DIR)/application.cvt $(BUILD_DIR)/autostart.cvt $(BUILD_DIR)/desk_accessory.cvt \
	california.cvt cory.cvt dwinelle.cvt roma.cvt university.cvt \
	commfont.cvt lwroma.cvt lwcal.cvt lwgreek.cvt lwbarrows.cvt \
	notepad.cvt photo_mgr.cvt text_mgr.cvt \
	geolaser.cvt paint_drivers.cvt \
	text_grabber128.cvt tgfs4128.cvt tgpc2128.cvt tgww128.cvt \
	tgg1128.cvt tgg2128.cvt \
	1526.CVT \
	ASC.CVT \
	BCM120.CVT \
	CI8510.CVT \
	CI8510A.CVT \
	CI8510DS.CVT \
	CI8510QS.CVT \
	CIRED.CVT \
	COMMCOMP.CVT \
	EPFX80.CVT \
	EPFX80DS.CVT \
	EPFX80QS.CVT \
	EPJX80.CVT \
	EPLQ1500.CVT \
	EPLX80.CVT \
	EPMX80.CVT \
	EPRED.CVT \
	GEM10X.CVT \
	GEMDS.CVT \
	GEMQS.CVT \
	IBM51P.CVT \
	IBM51PDS.CVT \
	IBM51PQS.CVT \
	IMW.CVT \
	IMWDS.CVT \
	IMWQS.CVT \
	IMW2.CVT \
	IMW2DS.CVT \
	IMW2QS.CVT \
	LJPAR.CVT \
	LJSER.CVT \
	LW21.CVT \
	MPS801.CVT \
	MPS803.CVT \
	MPS1000.CVT \
	MPS1200.CVT \
	MP1200DS.CVT \
	MP1200QS.CVT \
	OK120.CVT \
	OK120NLQ.CVT \
	OKML92.CVT \
	OK10.CVT \
	OK20.CVT \
	OLPR2300.CVT \
	RITECP.CVT \
	SCRIBE.CVT \
	SNB15.CVT \
	SNL10COM.CVT \
	SNX10.CVT \
	SNX10DS.CVT \
	SNX10QS.CVT \
	NX1000R.CVT \
	SNX10C.CVT \
	SSG10.CVT \
	TOSHP321.CVT \
	$(BUILD_DIR)/geospace.cvt \
	dt128.cvt
	@if [ -e $(D81_TEMPLATE) ]; then \
		cp $(D81_TEMPLATE) $@; \
		echo delete geos $(GEOS_OUT) configure geoboot | $(C1541) $@ >/dev/null; \
		echo write $< $(GEOS_OUT) | $(C1541) $@ >/dev/null; \
		echo delete \"desk top\"| $(C1541) $@ >/dev/null; \
		echo delete \"65 desktop\"| $(C1541) $@ >/dev/null; \
		echo delete \"65 configure\"| $(C1541) $@ >/dev/null; \
		echo delete \"geopaint\"| $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/config.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/mount.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/clock.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/topdesk.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/mega1351.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/mse1351.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/joydrv.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite gpt64.cvt | $(C1541) $@ >/dev/null; \
		echo \*\*\* Created $@ based on $(D81_TEMPLATE).; \
	else \
		echo format \"mega65 geos,00\" d81 $@ | $(C1541) >/dev/null; \
		echo write $< $(GEOS_OUT) | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/config.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/geospace.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/mount.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/clock.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/mega1351.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/mse1351.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/joydrv.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/autostart.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/topdesk.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite prmgr128.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite pdmgr128.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/input_driver.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/document.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/desk_accessory.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/application.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/printer_driver.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/utilities.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/font.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/other_data.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/coding.cvt | $(C1541) $@ >/dev/null; \
		echo geoswrite $(BUILD_DIR)/misc.cvt | $(C1541) $@ >/dev/null; \
		echo geosfolder "Startup" "MEGA\\ MOUNT"| $(C1541) $@ >/dev/null; \
		echo geosfolder "Startup" "MEGA\\ RTC"| $(C1541) $@ >/dev/null; \
		echo geosfolder "Input\\ Drivers" "COMM\\ 1351"| $(C1541) $@ >/dev/null; \
		echo geosfolder "Input\\ Drivers" "JOYSTICK"| $(C1541) $@ >/dev/null; \
		echo geosfolder "Input\\ Drivers" "MEGA\\ 1351"| $(C1541) $@ >/dev/null; \
		if [ "$(CONFIRM_CBMFILES_PERSONAL_USE_LICENSE)" = "ACCEPT_CBMFILES_LICENSE" ]; then \
			echo geoswrite gw128.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite gpt128.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite photo_mgr.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite text_mgr.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite alarm128.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite calc128.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite notepad.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite spell128.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite spelldata.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite merge128.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite california.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite cory.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite dwinelle.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite roma.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite university.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite commfont.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite lwroma.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite lwcal.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite lwgreek.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite lwbarrows.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite paint_drivers.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite geolaser.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite text_grabber128.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite tgfs4128.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite tgpc2128.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite tgww128.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite tgg1128.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite tgg2128.cvt | $(C1541) $@ >/dev/null; \
			echo geoswrite COMMCOMP.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite 1526.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite ASC.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite BCM120.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite CI8510.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite CI8510A.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite CI8510DS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite CI8510QS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite CIRED.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite EPFX80.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite EPFX80DS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite EPFX80QS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite EPJX80.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite EPLQ1500.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite EPLX80.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite EPMX80.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite EPRED.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite GEM10X.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite GEMDS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite GEMQS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite IBM51P.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite IBM51PDS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite IBM51PQS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite IMW.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite IMWDS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite IMWQS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite IMW2.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite IMW2DS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite IMW2QS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite LJPAR.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite LJSER.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite LW21.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite MPS801.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite MPS803.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite MPS1000.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite MPS1200.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite MP1200DS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite MP1200QS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite OK120.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite OK120NLQ.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite OKML92.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite OK10.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite OK20.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite OLPR2300.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite RITECP.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite SCRIBE.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite SNB15.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite SNL10COM.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite SNX10.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite SNX10DS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite SNX10QS.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite SNX10C.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite NX1000R.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite SSG10.CVT | $(C1541) $@ >/dev/null; \
			echo geoswrite TOSHP321.CVT | $(C1541) $@ >/dev/null; \
			echo geosfolder "Applications" "GEOWRITE\\ 128"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Applications" "GEOPAINT"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Applications" "GEOSPELL\\ 128"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Applications" "GEOMERGE"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Utilities" "GEOLASER"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Utilities" "PAINT\\ DRIVERS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Utilities" "TEXT\\ GRABBER\\ 128"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Desk\\ Accessories" "alarm\\ clock"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Desk\\ Accessories" "calculator"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Desk\\ Accessories" "photo\\ manager"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Desk\\ Accessories" "text\\ manager"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Desk\\ Accessories" "note\\ pad"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Other\\ Data" "GeoDictionary"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Other\\ Data" "FleetSystem\\ 4"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Other\\ Data" "PaperClip\\ II"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Other\\ Data" "WordWriter\\ 128"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Other\\ Data" "C128\\ Generic\\ I"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Other\\ Data" "C128\\ Generic\\ II"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Fonts" "California"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Fonts" "Cory"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Fonts" "Dwinelle"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Fonts" "Roma"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Fonts" "University"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Fonts" "Commodore"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Fonts" "LW_Roma"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Fonts" "LW_Cal"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Fonts" "LW_Greek"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Fonts" "LW_Barrows"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "1526"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "ASCII\\ Only"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "BlueChip\\ M120"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "C.Itoh\\ 8510"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "C.Itoh\\ 8510A"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "C.Itoh\\ 8510\\ D.S."| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "C.Itoh\\ 8510\\ Q.S."| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "C.Itoh\\ RED."| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Comm.\\ Compat."| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Epson\\ FX-80"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Epson\\ FX-80\\ DS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Epson\\ FX-80\\ QS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Epson\\ JX-80"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Epson\\ LQ-1500"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Epson\\ LX-80"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Epson\\ MX-80"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Epson\\ RED."| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Gemini\\ 10x"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Gemini\\ DS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Gemini\\ QS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "IBM\\ 5152+"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "IBM\\ 5152+\\ DS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "IBM\\ 5152+\\ QS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "ImageWriter"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "ImageWriterDS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "ImageWriterQS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "ImageWriter\\ II"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "ImWrtr\\ II\\ DS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "ImWrtr\\ II\\ QS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "LaserJet\\ PAR."| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "LaserJet\\ SER."| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "LaserWriter\\ 2.1"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "MPS-801"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "MPS-803"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "MPS-1000"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "MPS\\ 1200"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "MPS-1200\\ DS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "MPS\\ 1200\\ QS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Oki\\ 120"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Oki\\ 120\\ NLQ"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Oki\\ ML-92/93"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Okimate\\ 10"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Okimate\\ 20"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Olivetti\\ PR2300"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Riteman\\ C+"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Scribe"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Star\\ NB-15"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Star\\ NL-10(com)"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Star\\ NX-10"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Star\\ NX-10\\ DS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Star\\ NX-10\\ QS"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Star\\ NX-10C"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "NX-1000\\ Rainbow"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Star\\ SG-10/15"| $(C1541) $@ >/dev/null; \
			echo geosfolder "Printer\\ Drivers" "Toshiba\\ P321"| $(C1541) $@ >/dev/null; \
		fi; \
		if [ -e $(DESKTOP_CVT) ]; then echo geoswrite $(DESKTOP_CVT) | $(C1541) $@; fi >/dev/null; \
		echo \*\*\* Created fresh $@.; \
	fi;

#		echo rename \"65 desktop\" \"65 topdesk\" | $(C1541) $@ >/dev/null;
#		echo rename \"128 desktop\" \"65 desktop\" | $(C1541) $@ >/dev/null;

ifeq ($(VARIANT), mega65)

$(BUILD_DIR)/topdesk/topdesk.o:
	@mkdir -p `dirname $@`
	$(GRC) -s $(BUILD_DIR)/topdesk/topdesk.s2 -o $(BUILD_DIR)/topdesk/topdesk.c2 topdesk/topdesk65.grc
	sed 's/192/1/g' $(BUILD_DIR)/topdesk/topdesk.s2 > $(BUILD_DIR)/topdesk/topdesk.s
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
	$(GRC) -s $(BUILD_DIR)/configure/configure.s2 -o $(BUILD_DIR)/configure/configure.c2 configure/configure65.grc
	sed 's/192/1/g' $(BUILD_DIR)/configure/configure.s2 > $(BUILD_DIR)/configure/configure.s
	$(AS) -D $(VARIANT)=1 -D $(DRIVE)=1 -D $(INPUT)=1 $(ASFLAGS) $(BUILD_DIR)/configure/configure.s -o $@

else
$(BUILD_DIR)/configure/configure.o:
	@mkdir -p `dirname $@`
	$(GRC) -s $(BUILD_DIR)/configure/configure.s -o $(BUILD_DIR)/configure/configure.c configure/configure.grc
	$(AS) -D $(VARIANT)=1 -D $(DRIVE)=1 -D $(INPUT)=1 $(ASFLAGS) $(BUILD_DIR)/configure/configure.s -o $@
endif

$(BUILD_DIR)/mount/mount.o:
	@mkdir -p `dirname $@`
	$(AS) mount/mountIcon.s -o $(BUILD_DIR)/mount/mountIcon.o
	$(LD) -C mount/mountIcon.cfg $(BUILD_DIR)/mount/mountIcon.o -o $(BUILD_DIR)/mount/mount.bf
	$(GRC) -s $(BUILD_DIR)/mount/mount.s2 -o $(BUILD_DIR)/mount/mount.c mount/mount.grc
	sed 's/192/1/g' $(BUILD_DIR)/mount/mount.s2 > $(BUILD_DIR)/mount/mount.s
	$(AS) -D $(VARIANT)=1 -D $(DRIVE)=1 -D $(INPUT)=1 $(ASFLAGS) $(BUILD_DIR)/mount/mount.s -o $@

$(BUILD_DIR)/space/space.o:
	@mkdir -p `dirname $@`
	$(AS) space/spaceIcon.s -o $(BUILD_DIR)/space/spaceIcon.o
	$(LD) -C space/spaceIcon.cfg $(BUILD_DIR)/space/spaceIcon.o -o $(BUILD_DIR)/space/space.bf
	$(GRC) -s $(BUILD_DIR)/space/space.s2 -o $(BUILD_DIR)/space/space.c space/space.grc
	sed 's/192/1/g' $(BUILD_DIR)/space/space.s2 > $(BUILD_DIR)/space/space.s
	$(AS) -D $(VARIANT)=1 -D $(DRIVE)=1 -D $(INPUT)=1 $(ASFLAGS) $(BUILD_DIR)/space/space.s -o $@

$(BUILD_DIR)/clock/clock.o:
	@mkdir -p `dirname $@`
	$(AS) clock/clockIcon.s -o $(BUILD_DIR)/clock/clockIcon.o
	$(LD) -C clock/clockIcon.cfg $(BUILD_DIR)/clock/clockIcon.o -m $(BUILD_DIR)/clock.map -o $(BUILD_DIR)/clock/clock.bf
	$(GRC) -s $(BUILD_DIR)/clock/clock.s2 -o $(BUILD_DIR)/clock/clock.c clock/clock.grc
	sed 's/192/1/g' $(BUILD_DIR)/clock/clock.s2 > $(BUILD_DIR)/clock/clock.s
	$(AS) -D $(VARIANT)=1 -D $(DRIVE)=1 -D $(INPUT)=1 $(ASFLAGS) $(BUILD_DIR)/clock/clock.s -o $@

$(BUILD_DIR)/input/joydrvHdr.o:
	@mkdir -p `dirname $@`
	$(AS) input/joydrvIcon.s -o $(BUILD_DIR)/input/joydrvIcon.o
	$(LD) -C input/joydrvIcon.cfg $(BUILD_DIR)/input/joydrvIcon.o -o $(BUILD_DIR)/input/joydrv.bf
	$(GRC) -s $(BUILD_DIR)/input/joydrv.s2 -o $(BUILD_DIR)/input/joydrv.c input/joydrv.grc
	sed 's/192/1/g' $(BUILD_DIR)/input/joydrv.s2 > $(BUILD_DIR)/input/joydrv.s3
	sed 's/131, 6/131, 10/g' $(BUILD_DIR)/input/joydrv.s3 > $(BUILD_DIR)/input/joydrv.s4
	sed 's/.byte 6/.byte 10/g' $(BUILD_DIR)/input/joydrv.s4 > $(BUILD_DIR)/input/joydrv.s5
	$(AS) -D $(VARIANT)=1 -D $(DRIVE)=1 -D $(INPUT)=1 $(ASFLAGS) $(BUILD_DIR)/input/joydrv.s5 -o $@

$(BUILD_DIR)/input/mse1351Hdr.o:
	@mkdir -p `dirname $@`
	$(AS) input/mse1351Icon.s -o $(BUILD_DIR)/input/mse1351Icon.o
	$(LD) -C input/mse1351Icon.cfg $(BUILD_DIR)/input/mse1351Icon.o -o $(BUILD_DIR)/input/mse1351.bf
	$(GRC) -s $(BUILD_DIR)/input/mse1351.s2 -o $(BUILD_DIR)/input/mse1351.c input/mse1351.grc
	sed 's/192/1/g' $(BUILD_DIR)/input/mse1351.s2 > $(BUILD_DIR)/input/mse1351.s3
	sed 's/131, 6/131, 10/g' $(BUILD_DIR)/input/mse1351.s3 > $(BUILD_DIR)/input/mse1351.s4
	sed 's/.byte 6/.byte 10/g' $(BUILD_DIR)/input/mse1351.s4 > $(BUILD_DIR)/input/mse1351.s5
	$(AS) -D $(VARIANT)=1 -D $(DRIVE)=1 -D $(INPUT)=1 $(ASFLAGS) $(BUILD_DIR)/input/mse1351.s5 -o $@

$(BUILD_DIR)/input/mega1351Hdr.o:
	@mkdir -p `dirname $@`
	$(AS) input/mega1351Icon.s -o $(BUILD_DIR)/input/mega1351Icon.o
	$(LD) -C input/mega1351Icon.cfg $(BUILD_DIR)/input/mega1351Icon.o -o $(BUILD_DIR)/input/mega1351.bf
	$(GRC) -s $(BUILD_DIR)/input/mega1351.s2 -o $(BUILD_DIR)/input/mega1351.c input/mega1351.grc
	sed 's/192/1/g' $(BUILD_DIR)/input/mega1351.s2 > $(BUILD_DIR)/input/mega1351.s3
	sed 's/131, 6/131, 10/g' $(BUILD_DIR)/input/mega1351.s3 > $(BUILD_DIR)/input/mega1351.s4
	sed 's/.byte 6/.byte 10/g' $(BUILD_DIR)/input/mega1351.s4 > $(BUILD_DIR)/input/mega1351.s5
	$(AS) -D $(VARIANT)=1 -D $(DRIVE)=1 -D $(INPUT)=1 $(ASFLAGS) $(BUILD_DIR)/input/mega1351.s5 -o $@

$(BUILD_DIR)/folder/input_driver.o:
	@mkdir -p `dirname $@`
	$(AS) folder/input_driver.s -o $(BUILD_DIR)/folder/input_driver.o

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

$(BUILD_DIR)/mount.cvt: $(BUILD_DIR)/mount/mount.o $(BUILD_DIR)/mount/main.o
	$(LD) -t geos-cbm -o $@ $(BUILD_DIR)/mount/mount.o -m $(BUILD_DIR)/mount.map $(BUILD_DIR)/mount/main.o

$(BUILD_DIR)/geospace.cvt: $(BUILD_DIR)/space/space.o $(BUILD_DIR)/space/main.o \
	$(BUILD_DIR)/space/ip/eth.o $(BUILD_DIR)/space/ip/arp.o $(BUILD_DIR)/space/ip/nwk.o $(BUILD_DIR)/space/ip/socket.o $(BUILD_DIR)/space/ip/socket.o $(BUILD_DIR)/space/ip/checksum.o $(BUILD_DIR)/space/ip/dhcp.o $(BUILD_DIR)/space/ip/dns.o $(BUILD_DIR)/space/ip/task.o
	$(LD) -t geos-cbm -o $@ $(BUILD_DIR)/space/space.o -m $(BUILD_DIR)/space.map $(BUILD_DIR)/space/main.o $(BUILD_DIR)/space/ip/eth.o $(BUILD_DIR)/space/ip/arp.o $(BUILD_DIR)/space/ip/nwk.o $(BUILD_DIR)/space/ip/socket.o $(BUILD_DIR)/space/ip/checksum.o $(BUILD_DIR)/space/ip/dhcp.o $(BUILD_DIR)/space/ip/dns.o $(BUILD_DIR)/space/ip/task.o

$(BUILD_DIR)/clock.cvt: $(BUILD_DIR)/clock/clock.o $(BUILD_DIR)/clock/main.o
	$(LD) -t geos-cbm -o $@ $(BUILD_DIR)/clock/clock.o -m $(BUILD_DIR)/clock.map $(BUILD_DIR)/clock/main.o

$(BUILD_DIR)/input_driver.cvt: $(BUILD_DIR)/folder/input_driver.o
	$(LD) -C folder/folder.cfg -o $@ $(BUILD_DIR)/folder/input_driver.o -m $(BUILD_DIR)/input_driver.map

$(BUILD_DIR)/application.cvt: $(BUILD_DIR)/folder/application.o
	$(LD) -C folder/folder.cfg -o $@ $(BUILD_DIR)/folder/application.o -m $(BUILD_DIR)/application.map

$(BUILD_DIR)/autostart.cvt: $(BUILD_DIR)/folder/autostart.o
	$(LD) -C folder/folder.cfg -o $@ $(BUILD_DIR)/folder/autostart.o -m $(BUILD_DIR)/autostart.map

$(BUILD_DIR)/desk_accessory.cvt: $(BUILD_DIR)/folder/desk_accessory.o
	$(LD) -C folder/folder.cfg -o $@ $(BUILD_DIR)/folder/desk_accessory.o -m $(BUILD_DIR)/desk_accessory.map

$(BUILD_DIR)/utilities.cvt: $(BUILD_DIR)/folder/utilities.o
	$(LD) -C folder/folder.cfg -o $@ $(BUILD_DIR)/folder/utilities.o -m $(BUILD_DIR)/utilities.map

$(BUILD_DIR)/document.cvt: $(BUILD_DIR)/folder/document.o
	$(LD) -C folder/folder.cfg -o $@ $(BUILD_DIR)/folder/document.o -m $(BUILD_DIR)/document.map

$(BUILD_DIR)/printer_driver.cvt: $(BUILD_DIR)/folder/printer_driver.o
	$(LD) -C folder/folder.cfg -o $@ $(BUILD_DIR)/folder/printer_driver.o -m $(BUILD_DIR)/printer_driver.map

$(BUILD_DIR)/font.cvt: $(BUILD_DIR)/folder/font.o
	$(LD) -C folder/folder.cfg -o $@ $(BUILD_DIR)/folder/font.o -m $(BUILD_DIR)/font.map

$(BUILD_DIR)/other_data.cvt: $(BUILD_DIR)/folder/other_data.o
	$(LD) -C folder/folder.cfg -o $@ $(BUILD_DIR)/folder/other_data.o -m $(BUILD_DIR)/other_data.map

$(BUILD_DIR)/misc.cvt: $(BUILD_DIR)/folder/misc.o
	$(LD) -C folder/folder.cfg -o $@ $(BUILD_DIR)/folder/misc.o -m $(BUILD_DIR)/misc.map

$(BUILD_DIR)/coding.cvt: $(BUILD_DIR)/folder/coding.o
	$(LD) -C folder/folder.cfg -o $@ $(BUILD_DIR)/folder/coding.o -m $(BUILD_DIR)/coding.map

$(BUILD_DIR)/joydrv.cvt: $(BUILD_DIR)/input/joydrvHdr.o $(BUILD_DIR)/input/joydrv.o
	$(LD) -C input/joydrv_cvt.cfg -o $@ $(BUILD_DIR)/input/joydrvHdr.o -m $(BUILD_DIR)/joydrv.map $(BUILD_DIR)/input/joydrv.o

$(BUILD_DIR)/mse1351.cvt: $(BUILD_DIR)/input/mse1351Hdr.o $(BUILD_DIR)/input/mse1351.o
	$(LD) -C input/mse1351_cvt.cfg -o $@ $(BUILD_DIR)/input/mse1351Hdr.o -m $(BUILD_DIR)/mse1351.map $(BUILD_DIR)/input/mse1351.o

$(BUILD_DIR)/mega1351.cvt: $(BUILD_DIR)/input/mega1351Hdr.o $(BUILD_DIR)/input/mega1351.o
	$(LD) -C input/mega1351_cvt.cfg -o $@ $(BUILD_DIR)/input/mega1351Hdr.o -m $(BUILD_DIR)/mega1351.map $(BUILD_DIR)/input/mega1351.o

TCPSRCS=$(WEEIP_SRC)/arp.c \
	$(WEEIP_SRC)/checksum.c \
	$(WEEIP_SRC)/eth.c \
	$(WEEIP_SRC)/nwk.c \
	$(WEEIP_SRC)/socket.c \
	$(WEEIP_SRC)/task.c \
	$(WEEIP_SRC)/dhcp.c \
	$(WEEIP_SRC)/dns.c

#$(BUILD_DIR)/test.cvt: test/testres.grc test/test.c
#	$(CL) -t geos-cbm -O -o $(BUILD_DIR)/test.cvt -m $(BUILD_DIR)/test.map -I $(WEEIP_SRC)/mega65-libc/cc65/include -I $(WEEIP_SRC)/../include test/testres.grc test/test.c $(TCPSRCS)

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

$(BUILD_DIR)/input/mse1351.bin: $(BUILD_DIR)/input/mse1351.o input/mse1351.cfg $(DEPS)
	$(LD) -C input/mse1351.cfg $(BUILD_DIR)/input/mse1351.o -o $@

$(BUILD_DIR)/input/mega1351.bin: $(BUILD_DIR)/input/mega1351.o input/mega1351.cfg $(DEPS)
	$(LD) -C input/mega1351.cfg $(BUILD_DIR)/input/mega1351.o -o $@

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
