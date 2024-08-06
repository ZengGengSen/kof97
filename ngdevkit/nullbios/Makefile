MROM=rom/sm1.sm1
SROM=rom/sfix.sfix
PROMS=rom/sp-s2.sp1 rom/aes-bios.bin
ZROM=rom/000-lo.lo

BIOS=rom/neogeo.zip

all: $(BIOS)

-include ../../Makefile.config

NULLSOUNDSRCDIR=../nullsound
NULLSOUND=../nullsound/libnullsound.a
Z80_OBJS=user_commands
Z80_HEX=nullsound_driver.ihx

VERSION=0.4

$(BIOS): $(PROMS) $(ZROM) $(SROM) $(MROM)
	cd rom && /bin/echo -e "\
nullbios $(VERSION), an open source BIOS for Neo Geo\n\
https://github.com/dciabrin/ngdevkit\n\
." | /usr/bin/zip -qz neogeo.zip *.lo *.s* *.bin

$(MROM): $(Z80_HEX) | rom
	$(M68KOBJCOPY) -I ihex -O binary $< $@ --pad-to 131072

user_commands.rel: user_commands.s
	$(Z80SDAS) -g -l -p -u -I$(NULLSOUNDSRCDIR) -o $@ $<

$(SROM): | rom
	dd if=/dev/zero bs=1024 count=128 of=$@

rom/sp-s2.sp1: sp-s2.elf | rom
	$(M68KOBJCOPY) -O binary -S -R .comment --reverse-bytes=2 $< $@

rom/aes-bios.bin: aes-bios.elf | rom
	$(M68KOBJCOPY) -O binary -S -R .comment --reverse-bytes=2 $< $@

$(ZROM): | rom
	$(PYTHON) zoom-rom.py -o $@

rom:
	mkdir $@

sp-s2.elf: sp-s2.o
	$(M68KGCC) -nostartfiles -T bios.ld $^ -o $@

sp-s2.o: biosstart.S
	$(M68KGCC) -DBIOS_ROM_HARDWARE=1 -DBIOS_ROM_COUNTRY=2 -I../include -c $< -o $@

aes-bios.elf: aes-bios.o
	$(M68KGCC) -nostartfiles -T bios.ld $^ -o $@

aes-bios.o: biosstart.S
	$(M68KGCC) -DBIOS_ROM_HARDWARE=0 -DBIOS_ROM_COUNTRY=2 -I../include -c $< -o $@

$(Z80_HEX): $(Z80_OBJS:%=%.rel)
	$(MAKE) -C $(NULLSOUNDSRCDIR)
	$(Z80SDLD) -b DATA=0xf800 -i $@ $(NULLSOUND) $^

install: $(BIOS) $(Z80_HEX)
	$(INSTALL) -d $(DESTDIR)$(prefix)/share/ngdevkit && \
	$(INSTALL) $^ $(DESTDIR)$(prefix)/share/ngdevkit


clean:
	rm -f *.o *~ *.elf *.rel *.lst *.rst *.ihx rom/*.*

.PHONY: install clean bios
