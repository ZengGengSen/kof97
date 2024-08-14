static void show_illegal_screen();
static void demo() {
  BIOS_SYSTEM_MODE &= ~0x80;
  if (BIOS_MVS_FLAG != 0 && NVRAM_LEGAL_BOARD != 0)
    show_illegal_screen();

  init_system();
}

static void ng_write_screen(u16 addr, const u8 *line) {
  for (;;) {
    const u8 *text = line;
    *REG_VRAMADDR = addr;
    *REG_VRAMMOD  = 0x20;
    u16 data = 0x100;
    while (*text != 0xff)
      *REG_VRAMRW = data | *text++;

    addr++;
    *REG_VRAMADDR = addr;
    data = 0x200;
    while (*line != 0xff)
      *REG_VRAMRW = data | *line++;

    addr += 2;
    line++;
    if (*line == 0xff)
      break;
  }
}

static void show_illegal_screen() {
  static const u16 palette[16] = {
    0x0000, // r: 0x00 g: 0x00 b: 0x00
    0x4f22, // r: 0xf8 g: 0x20 b: 0x20
    0x0000, // r: 0x00 g: 0x00 b: 0x00
    0x3900, // r: 0x90 g: 0x08 b: 0x08
    0x7444, // r: 0x48 g: 0x48 b: 0x48
    0x100f, // r: 0x00 g: 0x00 b: 0xf8
    0x6bb0, // r: 0xb8 g: 0xb8 b: 0x00
    0x6770, // r: 0x78 g: 0x78 b: 0x70
    0x0500, // r: 0x50 g: 0x00 b: 0x00
    0x4a00, // r: 0xa8 g: 0x00 b: 0x00
    0x4e00, // r: 0xe8 g: 0x00 b: 0x00
    0x0004, // r: 0x00 g: 0x00 b: 0x40
    0x000d, // r: 0x00 g: 0x00 b: 0xd0
    0x204f, // r: 0x00 g: 0x48 b: 0xf0
    0x6ff0, // r: 0xf8 g: 0xf8 b: 0x00
    0x0000, // r: 0x00 g: 0x00 b: 0x00
  };
  static const u8 title[] = "WARNING\xff\xff";
  static const u8 lines[] = {
    "THIS ROM CARTRIDGE IS FOR USE WITH \xff"
    "ORIGINAL SNK BOARDS ONLY.          \xff"
    "COPYING OF SNK BOARDS IS PROHIBITED\xff"
    "AND MAY RESULT IN SEVERE CIVIL AND \xff"
    "CRIMINAL PENALTIES AND WILL BE     \xff"
    "PROSECUTED TO THE MAXIMUM EXTENT   \xff"
    "OF THE LAW.                        \xff"
    "\xff"
  };

  for (int i = 0; i < 16; ++i)
    MMAP_PALBANK1[i] = palette[i];

  ng_write_screen(ADDR_FIXMAP +  3 * 0x20 + 9, lines);
  ng_write_screen(ADDR_FIXMAP + 16 * 0x20 + 5, title);

  // kick watch dog
  for(;;) *REG_WATCHDOGW = 0;
}
