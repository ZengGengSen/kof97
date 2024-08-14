#ifndef __NGDEVKIT_USER_RAM_H__
#define __NGDEVKIT_USER_RAM_H__

struct PaletteEntry {
  s16 index;
  u16 color[15];
};

struct PaletteList {
  struct PaletteEntry entrys[200];
  u16 padding;
  uintptr cur_palette_ptr;
};

struct FixLayer {
  u16 x;
  u16 y;
  u8  flags;
  u8  padding[3];
  const u8 *data;
};

#define backup_data       (*(volatile u32*)0x100000) // 4 bytes

#define screen_flag       (*(volatile u8 *)0x10a784) // 1 byte
#define key_remap_flag    (*(volatile u8 *)0x10a786) // 1 byte
#define player_start_flag ( (volatile u8 *)0x10a790) // 2 bytes

#define unknown_flag_a816 ( (volatile u8 *)0x10a816) // 2 byte

#define title_fix_layer   ((volatile struct FixLayer*)0x10a82a) // 16 bytes

// 200 palette entries
#define palette_ptr       ((volatile struct PaletteList*)0x10c022) // 6402 bytes

#define is_player_exit_copy (*(volatile u8 *)0x10e6bb) // 1 byte

/// maybe related background object
#define unknown_flag_ec33 (*(volatile u8 *)0x10ec33) // 1 byte

#endif
