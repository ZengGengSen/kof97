# Copyright (c) 2015-2020 Damien Ciabrini
# This file is part of ngdevkit
#
# ngdevkit is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# ngdevkit is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ngdevkit.  If not, see <http://www.gnu.org/licenses/>.

OBJS=libsyscalls.a libngdevkit.a ngdevkit-crt0.o messout.o
SYSCALL_OBJS=\
  close \
  _exit \
  exit \
  fstat \
  getpid \
  gettimeofday \
  isatty \
  kill \
  link \
  lseek \
  open \
  raise \
  read \
  sbrk \
  times \
  unlink \
  write
NGDEVKIT_OBJS=\
  soft-dip-jp \
  soft-dip-us \
  soft-dip-eu \
  bios-ram \
  ng_text_tall_args \
  ng_text_args \
  ng_center_text_tall_args \
  ng_center_text_args \
  ng_cls_args \
  ng_wait_vblank

all: $(OBJS) ngdevkit-specs

-include ../../Makefile.config

libsyscalls.a: $(SYSCALL_OBJS:%=syscall/%.o)
	$(M68KAR) cru $@ $^ && $(M68KRANLIB) $@

libngdevkit.a: $(NGDEVKIT_OBJS:%=ngdevkit/%.o)
	$(M68KAR) cru $@ $^ && $(M68KRANLIB) $@

ngdevkit-specs:
	$(M68KGCC) -dumpspecs | sed -e 's/\(-lc\)/\1 -lsyscalls \1/' | \
	sed -e 's/\(crtbegin.o%s\)/-T ngdevkit.ld%s \1/' > $@

%.o: %.c
	$(M68KGCC) -std=c99 -fomit-frame-pointer -I../include -c $< -o $@

%.o: %.S
	$(M68KGCC) -I../include -c $< -o $@

install: install-objs install-specs

install-dirs:
	OBJDIR=$(DESTDIR)$(prefix)/$$(dirname $$($(M68KGCC) --print-file-name=crt0.o) | sed -n 's%^.*\(m68k-neogeo-elf/lib/gcc\)%\1%p') && \
	SPECSDIR=$(DESTDIR)$(prefix)/$$(dirname $$($(M68KGCC) --print-libgcc-file-name) | sed -n 's%^.*\(m68k-neogeo-elf/lib/gcc\)%\1%p') && \
	$(INSTALL) -d $$OBJDIR && $(INSTALL) -d $$SPECSDIR

install-objs: install-dirs $(OBJS) ngdevkit.ld
	DIR=$(DESTDIR)$(prefix)/$$(dirname $$($(M68KGCC) --print-file-name=crt0.o) | sed -n 's%^.*\(m68k-neogeo-elf/lib/gcc\)%\1%p') && \
	$(INSTALL) $(filter-out install-dirs,$^) $$DIR

install-specs: install-dirs ngdevkit-specs
	DIR=$(DESTDIR)$(prefix)/$$(dirname $$($(M68KGCC) --print-libgcc-file-name) | sed -n 's%^.*\(m68k-neogeo-elf/lib/gcc\)%\1%p') && \
	$(INSTALL) $(filter-out install-dirs,$^) $$DIR

clean:
	rm -f *.o ngdevkit/*.o syscall/*.o *~ *.a ngdevkit-specs

.PHONY: install clean
