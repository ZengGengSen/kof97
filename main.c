#include <ngdevkit/neogeo.h>

/// Start of character tiles in GAME ROM
#define SROM_TXT_TILE_OFFSET 0

/// Transparent tile in GAME ROM
#define SROM_EMPTY_TILE 255


/// Clear the 40*32 tiles of fix map
void ng_cls() {
    u16 val = SROM_EMPTY_TILE;
    *REG_VRAMADDR = ADDR_FIXMAP;
    *REG_VRAMMOD = 1;
    for (u16 i=1280; i!=0; i--) *REG_VRAMRW = val;
}

/// Handy function to display a string on the fix map
void ng_text(u8 x, u8 y, const char *text) {
    u16 base_val = SROM_TXT_TILE_OFFSET;
    *REG_VRAMADDR=ADDR_FIXMAP+(x<<5)+y;
    *REG_VRAMMOD=32;
    while (*text) *REG_VRAMRW = (u16)(base_val+*text++);
}

static void ng_write_hori_text(int x, int y, const char *text) {
  *REG_VRAMADDR = ADDR_FIXMAP + x * 0x20 + y;
  *REG_VRAMMOD  = 0x20;

  for (int i = 0; text[i] != '\0'; ++i)
    *REG_VRAMRW = text[i];
}

int main(void) {
  ng_cls();

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
  static const char title[] = "WARNING";
  static const char lines[][35] = {
    "THIS ROM CARTRIDGE IS FOR USE WITH ",
    "ORIGINAL SNK BOARDS ONLY.          ",
    "COPYING OF SNK BOARDS IS PROHIBITED",
    "AND MAY RESULT IN SEVERE CIVIL AND ",
    "CRIMINAL PENALTIES AND WILL BE     ",
    "PROSECUTED TO THE MAXIMUM EXTENT   ",
    "OF THE LAW.                        ",
  };

  for (int i = 0; i < 16; ++i)
    *(MMAP_PALBANK1 + i) = palette[i];

  ng_write_hori_text(16,  5, title);
  for (int i = 0; i < sizeof(lines) / sizeof(lines[0]); ++i)
    ng_write_hori_text(3, 9 + i, lines[i]);

  for(;;) {}
  return 0;
}
