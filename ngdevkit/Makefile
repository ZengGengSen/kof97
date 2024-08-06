bios=$(output.dir)/neogeo.zip
bios.dir=nullbios
bios.version=0.4

bios.objs := $(output.dir)/bios/sm1.sm1
bios.objs += $(output.dir)/bios/sfix.sfix
bios.objs += $(output.dir)/bios/sp-s2.sp1
bios.objs += $(output.dir)/bios/aes-bios.bin
bios.objs += $(output.dir)/bios/000-lo.lo

$(bios): $(bios.objs)
	zip -qz $@ $<

$(output.dir)/bios:
	mkdir -p $@

$(bios.objs): | $(output.dir)/bios

$(output.dir)/bios/sm1.sm1: $(z80.hex)
	$(M68KOBJCOPY) -I ihex -O binary $< $@ --pad-to 131072

$(output.dir)/bios/sfix.sfix:
	dd if=/dev/zero bs=1024 count=128 of=$@

$(output.dir)/bios/sp-s2.sp1: $(output.dir)/bios/sp-s2.elf
	$(M68KOBJCOPY) -O binary -S -R .comment --reverse-bytes=2 $< $@

$(output.dir)/bios/aes-bios.bin: $(output.dir)/bios/aes-bios.elf
	$(M68KOBJCOPY) -O binary -S -R .comment --reverse-bytes=2 $< $@

$(output.dir)/bios/000-lo.lo:
	$(PYTHON) zoom-rom.py -o $@

# z80 hex
$(Z80_HEX): $(Z80_OBJS:%=%.rel)
	$(MAKE) -C $(NULLSOUNDSRCDIR)
	$(Z80SDLD) -b DATA=0xf800 -i $@ $(NULLSOUND) $^

$(output.dir)/bios/sp-s2.elf: $(output.dir)/bios/sp-s2.o
	$(M68KGCC) -nostartfiles -T $(bios.dir)/bios.ld $^ -o $@

$(output.dir)/bios/aes-bios.elf: $(output.dir)/bios/aes-bios.o
	$(M68KGCC) -nostartfiles -T $(bios.dir)/bios.ld $^ -o $@

$(output.dir)/bios/sp-s2.o: $(bios.dir)/biosstart.S
	$(M68KGCC) -DBIOS_ROM_HARDWARE=1 -DBIOS_ROM_COUNTRY=2 -Iinclude -c $< -o $@

$(output.dir)/bios/aes-bios.o: $(bios.dir)/biosstart.S
	$(M68KGCC) -DBIOS_ROM_HARDWARE=0 -DBIOS_ROM_COUNTRY=2 -Iinclude -c $< -o $@

user_commands.rel: user_commands.s
	$(Z80SDAS) -g -l -p -u -I$(nullsound.src.dir) -o $@ $<

