syscall.objs := close
syscall.objs += _exit
syscall.objs += exit
syscall.objs += fstat
syscall.objs += getpid
syscall.objs += gettimeofday
syscall.objs += isatty
syscall.objs += kill
syscall.objs += lseek
syscall.objs += open
syscall.objs += raise
syscall.objs += read
syscall.objs += sbrk
syscall.objs += times
syscall.objs += unlink
syscall.objs += write

ngdevkit.objs := bios-ram
ngdevkit.objs += ng_text_tall_args
ngdevkit.objs += ng_text_args
ngdevkit.objs += ng_center_text_tall_args
ngdevkit.objs += ng_center_text_args
ngdevkit.objs += ng_cls_args
ngdevkit.objs += ng_wait_vblank

mvs-nvram.objs := mvs-nvram

runtime/libsyscalls.a: $(syscall.objs:%=runtime/syscall/%.o)
	$(M68KAR) cru $@ $^ && $(M68KRANLIB) $@

runtime/libngdevkit.a: $(ngdevkit.objs:%=runtime/ngdevkit/%.o)
	$(M68KAR) cru $@ $^ && $(M68KRANLIB) $@

runtime/libmvs-nvram.a: $(mvs-nvram.objs:%=runtime/%.o)
	$(M68KAR) cru $@ $^ && $(M68KRANLIB) $@

runtime/ngdevkit-specs:
	$(M68KGCC) -dumpspecs | sed -e 's/\(-lc\)/\1 -lsyscalls \1/' | sed -e 's/\(crtbegin.o%s\)/-T ngdevkit.ld%s \1/' > $@
