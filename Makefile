M68KGCC    := /ucrt64/bin/m68k-neogeo-elf-gcc
M68KAR     := /ucrt64/bin/m68k-neogeo-elf-ar
M68KRANLIB := /ucrt64/bin/m68k-neogeo-elf-ranlib
M68KOBJCOPY:= /ucrt64/bin/m68k-neogeo-elf-objcopy

PROM := rom/232-p1.p1

OBJS := main
OBJS += soft-dip
OBJS += kof97
ELF   = rom.elf

all: out/kof97.zip

out/kof97.zip: $(PROM)
	zip -qj out/kof97.zip rom/*

include runtime/Makefile

$(ELF):	$(OBJS:%=%.o) runtime/ngdevkit-specs runtime/libsyscalls.a runtime/libngdevkit.a runtime/ngdevkit-crt0.o
	$(M68KGCC) -o $@ $(OBJS:%=%.o) -Lruntime -L. -B. -specs ngdevkit-specs -lngdevkit -Wl,--enable-non-contiguous-regions

%.o: %.c
	$(M68KGCC) -O3 -MMD -MP	-I. -Iinclude -std=c99 -fomit-frame-pointer -g -c $< -o $@

%.o: %.S
	$(M68KGCC) -Iinclude -c $< -o $@

PROMSIZE:=0x100000
$(PROM): $(ELF)
	$(M68KOBJCOPY) -O binary -S -R .comment --gap-fill 0xff --pad-to $(PROMSIZE) $< $@
	dd if=$@ of=$@ conv=notrunc,swab

clean:
	rm -f *.o
	rm -f runtime/*.a runtime/*.o runtime/ngdevkit-specs runtime/ngdevkit/*.o runtime/syscall/*.o
	rm -f $(ELF)
	rm -f $(PROM)
	rm -f out/kof97.zip

.PHONY: clean

-include $(OBJS:%=%.d)
