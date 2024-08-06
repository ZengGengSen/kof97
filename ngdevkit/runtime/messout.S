#include <ngdevkit/asm/registers.h>
#include <ngdevkit/asm/bios-ram.h>
#include <ngdevkit/asm/bios-calls.h>
#include <ngdevkit/asm/nvram.h>
#include <ngdevkit/asm/palette.h>

messout_loop:
  addq.b  #0x01,(BIOS_MESS_BUSY).l
  move.l  #BIOS_MESS_BUFFER,(BIOS_MESS_POINT).l
  lea     (REG_VRAMRW).l,%a1
  move.w  #1,REG_VRAMMOD-REG_VRAMRW(%a1)
  move.w  #0x20,%d0
  move.w  #0x7000,REG_VRAMADDR-REG_VRAMRW(%a1)
  move.w  #0x4FF,%d7

.loop:
  move.b  %d0,(REG_DIPSW).l
  move.w  %d0,(%a1)
  dbf     %d7,.loop

  subq.b  #1,(bios_mess_busy).l
  rts


// ?
check_reg_sound:
  move.b  (REG_SOUND).l,%d0
  subq.b  #1,%d0
  beq.w   .Lcheck_reg_sound_4

  move    %sr,-(%sp)
  move.l  %d1,-(%sp)
  move.b  #1,(BIOS_COMPULSION_FRAME_TIMER).l
  move    #0x2000,%sr
  move.w  #7,%d1

.Lcheck_reg_sound_1:
  swap    %d1
  move.w  (BIOS_FRAME_COUNTER+2).l,%d1
  addq.w  #4,%d1
  move.b  #1,(REG_SOUND).l

.Lcheck_reg_sound_2:
  move.b  %d0,(REG_DIPSW).l
  move.b  (REG_SOUND).l,%d0
  subq.b  #1,%d0
  beq.s   .Lcheck_reg_sound_3

  cmp.w   (BIOS_FRAME_COUNTER+2).l,%d1
  bne.s   .Lcheck_reg_sound_2

  swap    %d1
  dbf     %d1,.Lcheck_reg_sound_1

.Lcheck_reg_sound_3:
  move.l  (%sp)+,%d1
  move    (%sp)+,%sr
  bsr.w   .Lcheck_reg_sound_5

  clr.b   (BIOS_COMPULSION_FRAME_TIMER).l

.Lcheck_reg_sound_4:
  rts

.Lcheck_reg_sound_5:
  bsr.w   .Lcheck_reg_sound_6
  bsr.w   .Lcheck_reg_sound_6
  bsr.w   .Lcheck_reg_sound_7

.Lcheck_reg_sound_6:
  bsr.w   .Lcheck_reg_sound_7
  bsr.w   .Lcheck_reg_sound_7

.Lcheck_reg_sound_7:
  nop
  nop
  nop
  nop
  nop
  nop
  rts


wait_sys_stopper:
  move.b  #1,(BIOS_SYS_STOPPER).l

.Lwait_sys_stopper_1:
  tst.b   (BIOS_SYS_STOPPER).l
  bne.s   .Lwait_sys_stopper_1

  rts

eye_watch:
  bclr    #7,(BIOS_SYSTEM_MODE).l
  move.b  #3,(REG_SOUND).l
  moveq   #0,%d0
  move.w  %d0,(BIOS_EYE_CATCHER_STATUS).l
  move.w  %d0,(BIOS_EYE_CATCHER_PAL_UPDATE).l
  move.b  %d0,(REG_NOSHADOW).l
  andi    #0xf0ff,%sr
  bsr.s   wait_sys_stopper

.Leye_watcher1:
  addq.b  #1,(BIOS_MESS_BUSY).l
  movea.l (BIOS_MESS_POINT).l,%a0
  move.l  #.Leye_watcher_mess_out_data,(%a0)+
  move.l  %a0,(BIOS_MESS_POINT).l
  subq.b  #1,(BIOS_MESS_BUSY).l
  bsr.s   wait_sys_stopper

  tst.b   (BIOS_MVS_FLAG).l
  beq.s   .Leye_watcher_aes

  tst.w   (P1_CREDITS_BCD).l
  beq.s   .Leye_watcher4

  bra.w   .Leye_watcher41

.Leye_watcher_system_return:
  jmp     SYSTEM_RETURN

.Leye_watcher_aes:
  move.b  (BIOS_CP_P1CHANGE).l,%d0
  andi.b  #0xf0,%d0
  bne.s   .Leye_watcher_system_return

  btst    #0,(BIOS_STATCHANGE).l
  bne.s   .Leye_watcher_system_return

.Leye_watcher4:
  tst.w   (BIOS_EYE_CATCHER_PAL_UPDATE).l
  beq.s   .Leye_watcher6

  movea.l (BIOS_EYE_CATCHER_PAL).l,%a0
  lea     (PALETTE + 0x1E2).l,%a1
  moveq   #4,%d6

.Leye_watcher5:
  move.w  (%a0)+,(%a1)+
  dbf     %d6,.Leye_watcher5

  move.w  (%a0),(PALETTE + 0x1ffe).l
  clr.w   (BIOS_EYE_CATCHER_PAL_UPDATE).l

.Leye_watcher6:
  move.w  (BIOS_EYE_CATCHER_STATUS).l,%d0
  lsl.w   #2,%d0
  movea.l .Leye_watcher_switch_status(%pc,%d0.w),%a0
  jsr     (%a0)

  bra.w   .Leye_watcher1

.Leye_watcher_switch_status:
  dc.l .Leye_watcher7
  dc.l .Leye_watcher8
  dc.l .Leye_watcher9
  dc.l .Leye_watcher10
  dc.l .Leye_watcher11
  dc.l .Leye_watcher12
  dc.l .Leye_watcher13
  dc.l .Leye_watcher14
  dc.l .Leye_watcher15
  dc.l .Leye_watcher16

.Leye_watcher_mess_out_data:
  dc.w  0x0301, 0x0024                       // Data will be read in words, data length is 0x24.
  dc.w  0x0102                               // Set auto-inc to 0x01
  dc.w  0x0003, 0x8401                       // Set VRAM address to 0x8401
  dc.w  0x0004                               // Set Message
  dc.l  BIOS_EYE_CATCHER_MESS_OUT_1          // Message
  dc.w  0x0003, 0x8201                       // Set VRAM address to 0x8201
  dc.w  0x0006                               // Resume data output
  dc.w  0x0003, 0x8001                       // Set VRAM address to 0x8001
  dc.w  0x0006                               // Resume data output
  dc.w  0x0000

.Leye_watcher7:
  moveq   #0,%d0
  move.l  %d0,%d1
  move.l  %d0,%d2
  move.l  %d0,%d3
  move.b  %d0,(REG_PALBANK1).l
  move.w  #0x7F,%d7
  lea     (PALETTE_END).l,%a0
.Leye_watcher17:
  movem.l %d0-%d3,-(%a0)
  movem.l %d0-%d3,-(%a0)
  movem.l %d0-%d3,-(%a0)
  movem.l %d0-%d3,-(%a0)
  dbf     %d7,.Leye_watcher17

  move.b  %d0,(REG_PALBANK0).l
  move.w  #0x7F,%d7
  lea     (PALETTE_END).l,%a0

.Leye_watcher18:
  movem.l %d0-%d3,-(%a0)
  movem.l %d0-%d3,-(%a0)
  movem.l %d0-%d3,-(%a0)
  movem.l %d0-%d3,-(%a0)
  dbf     %d7,.Leye_watcher18

  addq.b  #1,(BIOS_MESS_BUSY).l
  jsr     FIX_CLEAR

  jsr     LSP_1st

  move.l  #0xDDD0000,(PALETTE + 2).l
  lea     .Leye_watcher_vram_data1(%pc),%a0
  nop
  move.w  #0x40,%d0
  move.b  (0x115).w,%d2
  lsl.w   #8,%d2
  move.w  #0xF01,%d1
  bsr.w   .Leye_catcher_write_vram

  lea     .Leye_watcher_vram_data2(%pc),%a0
  nop
  move.w  #0x4C0,%d0
  move.w  #0xF00,%d1
  bsr.w   .Leye_catcher_write_vram

  move.w  #0,-2(%a1)
  move.w  #2,2(%a1)
  moveq   #0x1F,%d6
.Leye_watcher19:
  move.w  %d2,(%a1)
  dbf     %d6,.Leye_watcher19

  movea.l (BIOS_MESS_POINT).l,%a0
  move.l  #.Leye_watcher_mess_out_data2,(%a0)+
  move.l  %a0,(BIOS_MESS_POINT).l
  lea     (BIOS_EYE_CATCHER_MESS_OUT_3).l,%a0
  move.w  #0xe404,(%a0)+

  moveq   #0x44,%d0
  moveq   #0x22,%d7
.Leye_watcher20:
  move.w  %d0,(%a0)+
  dbf     %d7,.Leye_watcher20

  clr.w   (BIOS_EYE_CATCHER_MESS_OUT_4).l
  move.w  #0x4B80,(BIOS_EYE_CATCHER_MESS_OUT_1).l

  move.w  #0xFF,%d0
  lea     (BIOS_EYE_CATCHER_MESS_OUT_5).l,%a0
  moveq   #0x11,%d7
.Leye_watcher21:
  move.w  %d0,(%a0)+
  dbf     %d7,.Leye_watcher21

  move.w  #0xFFF,%d0
  moveq   #0x11,%d7
.Leye_watcher22:
  move.w  %d0,(%a0)+
  dbf     %d7,.Leye_watcher22

  move.w  #0,%d0
  bsr.w   .Leye_catcher_set_pal

  move.w  #0,(BIOS_EYE_CATCHER_TIMER).l
  move.w  #1,(BIOS_EYE_CATCHER_STATUS).l
  subq.b  #1,(BIOS_MESS_BUSY).l
  rts

.Leye_watcher41:
  cmpi.w  #9,(BIOS_EYE_CATCHER_STATUS).l
  bne.w   .Leye_watcher42

  tst.b   (byte_10FD83).l
  beq.w   .Leye_watcher42

  clr.l   (dword_400002).l
  bsr.w   messout_loop

  bsr.w   check_reg_sound

  bsr.w   wait_sys_stopper

  move.b  #3,(REG_SOUND).l
  move.b  %d0,(byte_3A001B).l
  move.b  %d0,(byte_3A0013).l
  clr.b   (byte_10FE8D).l

.Leye_watcher42:
  jmp     SYSTEM_RETURN

.Leye_watcher43:

  move.w  (BIOS_EYE_CATCHER_PALID).l,%d1
  lea     .Leye_catcher_plette_id_1(%pc),%a0
  nop
  moveq   #0,%d0
  move.b  (%a0,%d1.w),%d0
  bsr.w   .Leye_catcher_set_pal

  addq.w  #1,(BIOS_EYE_CATCHER_PALID).l
  rts

.Leye_catcher_write_vram:
  lea     (REG_VRAMRW).l,%a1
  move.w  #1,REG_VRAMMOD-REG_VRAMRW(%a1)
  moveq   #0x11,%d7

.Leye_catcher_write_vram1:
  move.w  %d0,REG_VRAMADDR-REG_VRAMRW(%a1)
  moveq   #3,%d6

.Leye_catcher_write_vram2:
  move.b  (%a0)+,%d2
  move.w  %d2,(%a1)
  nop
  move.w  %d1,(%a1)
  dbf     %d6,.Leye_catcher_write_vram2

  moveq   #0x1B,%d6
  move.b  #0xFF,%d2

.Leye_catcher_write_vram3:
  move.w  %d2,(%a1)
  nop
  move.w  #0,(%a1)
  dbf     %d6,.Leye_catcher_write_vram3

  addi.w  #0x40,%d0
  dbf     %d7,.Leye_catcher_write_vram1

  rts

.Leye_catcher_set_pal:
  move.w  #0xC,%d1
  mulu.w  %d1,%d0
  addi.l  #0xEEC,%d0
  move.l  %d0,(BIOS_EYE_CATCHER_PAL).l
  move.w  #1,(BIOS_EYE_CATCHER_PAL_UPDATE).l
  rts

.Leye_catcher_plette_id_1:
  dc.b 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
  dc.b 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
  dc.b 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17
  dc.b 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f

.Leye_catcher_plette_id_2:
  dc.b 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27
  dc.b 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f

.Leye_catcher_plette:
  dc.w 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000 // 0x00
  dc.w 0x1b58, 0x1ca5, 0x0007, 0x0007, 0x0007, 0x0007 // 0x01
  dc.w 0x006f, 0x01bc, 0x0007, 0x0007, 0x0000, 0x0000 // 0x02
  dc.w 0x1bc7, 0x01bc, 0x0007, 0x0007, 0x0007, 0x0007 // 0x03
  dc.w 0x00de, 0x1d14, 0x0007, 0x0007, 0x0000, 0x0000 // 0x04
  dc.w 0x1c36, 0x1d14, 0x0007, 0x0000, 0x0007, 0x0007 // 0x05
  dc.w 0x014d, 0x022b, 0x0007, 0x0000, 0x0007, 0x0007 // 0x06
  dc.w 0x1ca5, 0x022b, 0x0007, 0x0000, 0x0000, 0x0000 // 0x07
  dc.w 0x01bc, 0x1d83, 0x0007, 0x0007, 0x0007, 0x0007 // 0x08
  dc.w 0x1d14, 0x1d83, 0x0007, 0x0000, 0x0000, 0x0000 // 0x09
  dc.w 0x022b, 0x029a, 0x0007, 0x0007, 0x0007, 0x0007 // 0x0a
  dc.w 0x1d83, 0x029a, 0x0007, 0x0000, 0x0000, 0x0000 // 0x0b
  dc.w 0x029a, 0x1df2, 0x0007, 0x0007, 0x1f3f, 0x1f3f // 0x0c
  dc.w 0x1df2, 0x1df2, 0x0007, 0x0000, 0x03e7, 0x03e7 // 0x0d
  dc.w 0x0309, 0x0309, 0x0007, 0x1f3f, 0x1ed0, 0x1ed0 // 0x0e
  dc.w 0x1e61, 0x1e61, 0x0007, 0x1f3f, 0x1ed0, 0x1ed0 // 0x0f
  dc.w 0x1ed0, 0x1ed0, 0x0007, 0x1f3f, 0x1ed0, 0x1ed0 // 0x10
  dc.w 0x03e7, 0x1ed0, 0x0007, 0x1f3f, 0x0378, 0x0378 // 0x11
  dc.w 0x1f3f, 0x1ed0, 0x0007, 0x03e7, 0x1e61, 0x1e61 // 0x12
  dc.w 0x0000, 0x03e7, 0x0000, 0x03e7, 0x0309, 0x0309 // 0x13
  dc.w 0x0007, 0x03e7, 0x0000, 0x1ed0, 0x1df2, 0x1df2 // 0x14
  dc.w 0x0000, 0x1f3f, 0x0000, 0x1ed0, 0x029a, 0x029a // 0x15
  dc.w 0x0007, 0x1f3f, 0x0000, 0x1ed0, 0x1d83, 0x1d83 // 0x16
  dc.w 0x0000, 0x0000, 0x0000, 0x0378, 0x022b, 0x022b // 0x17
  dc.w 0x0007, 0x0007, 0x0007, 0x1e61, 0x1d14, 0x1d14 // 0x18
  dc.w 0x0000, 0x0000, 0x0007, 0x1e61, 0x01bc, 0x01bc // 0x19
  dc.w 0x0007, 0x0007, 0x0007, 0x0309, 0x1ca5, 0x1ca5 // 0x1a
  dc.w 0x0000, 0x0000, 0x0007, 0x1df2, 0x014d, 0x014d // 0x1b
  dc.w 0x0007, 0x0007, 0x0007, 0x029a, 0x1c36, 0x1c36 // 0x1c
  dc.w 0x0000, 0x0000, 0x0007, 0x029a, 0x00de, 0x00de // 0x1d
  dc.w 0x0000, 0x0000, 0x0007, 0x1d83, 0x006f, 0x006f // 0x1e
  dc.w 0x0000, 0x0000, 0x0000, 0x1d83, 0x0000, 0x0000 // 0x1f
  dc.w 0x0000, 0x0000, 0x0000, 0x1d83, 0x03ea, 0x0000 // 0x20
  dc.w 0x0000, 0x0000, 0x0000, 0x1d83, 0x0004, 0x0000 // 0x21
  dc.w 0x0000, 0x0000, 0x0000, 0x1d83, 0x03ed, 0x0000 // 0x22
  dc.w 0x0000, 0x0000, 0x0000, 0x1d83, 0x0007, 0x0000 // 0x23
  dc.w 0x0000, 0x0000, 0x0000, 0x1d83, 0x03f0, 0x0000 // 0x24
  dc.w 0x0000, 0x0000, 0x0000, 0x1d83, 0x0000, 0x0000 // 0x25
  dc.w 0x0000, 0x0000, 0x0000, 0x1d83, 0x0064, 0x0000 // 0x26
  dc.w 0x0001, 0x0005, 0x0000, 0x1d83, 0x012e, 0x0000 // 0x27
  dc.w 0x0005, 0x0000, 0x0000, 0x1d83, 0x0068, 0x0000 // 0x28
  dc.w 0x0001, 0x0005, 0x003a, 0x0999, 0x006d, 0x0000 // 0x29
  dc.w 0x0005, 0x0000, 0x0000, 0x1d83, 0x000a, 0x0000 // 0x2a
  dc.w 0x0001, 0x0005, 0x0000, 0x1d83, 0x000a, 0x0000 // 0x2b
  dc.w 0x0000, 0x0000, 0x0000, 0x1d83, 0x006d, 0x0000 // 0x2c
  dc.w 0x0000, 0x0000, 0x0000, 0x1d83, 0x0008, 0x0000 // 0x2d
  dc.w 0x0000, 0x0000, 0x0000, 0x1d83, 0x0007, 0x0000 // 0x2e
  dc.w 0x0000, 0x0000, 0x0000, 0x1d83, 0x0132, 0x0000 // 0x2f

.Leye_watcher_vram_data1:
  dc.b 0xff, 0xff, 0xff, 0xff
  dc.b 0xff, 0x1c, 0x2b, 0xff
  dc.b 0x0d, 0x1b, 0x2a, 0x39
  dc.b 0x0c, 0x1a, 0x29, 0x38
  dc.b 0x0b, 0x19, 0x28, 0x37
  dc.b 0x0a, 0x18, 0x27, 0x36
  dc.b 0x09, 0x17, 0x26, 0x35
  dc.b 0x08, 0x16, 0x25, 0x34
  dc.b 0x07, 0x15, 0x24, 0x33
  dc.b 0x06, 0x14, 0x23, 0x32
  dc.b 0x05, 0x13, 0x22, 0x31
  dc.b 0x04, 0x12, 0x21, 0x30
  dc.b 0x03, 0x11, 0x20, 0x2f
  dc.b 0x02, 0x10, 0x1f, 0x2e
  dc.b 0x01, 0x0f, 0x1e, 0x2d
  dc.b 0x00, 0x0e, 0x1d, 0x2c
  dc.b 0xff, 0xff, 0xff, 0xff
  dc.b 0xff, 0xff, 0xff, 0xff

.Leye_watcher_vram_data2:
  dc.b 0xff, 0xff, 0xff, 0xff
  dc.b 0xff, 0xff, 0xff, 0xff
  dc.b 0x00, 0x0e, 0x1d, 0x2c
  dc.b 0x01, 0x0f, 0x1e, 0x2d
  dc.b 0x02, 0x10, 0x1f, 0x2e
  dc.b 0x03, 0x11, 0x20, 0x2f
  dc.b 0x04, 0x12, 0x21, 0x30
  dc.b 0x05, 0x13, 0x22, 0x31
  dc.b 0x06, 0x14, 0x23, 0x32
  dc.b 0x07, 0x15, 0x24, 0x33
  dc.b 0x08, 0x16, 0x25, 0x34
  dc.b 0x09, 0x17, 0x26, 0x35
  dc.b 0x0a, 0x18, 0x27, 0x36
  dc.b 0x0b, 0x19, 0x28, 0x37
  dc.b 0x0c, 0x1a, 0x29, 0x38
  dc.b 0x0d, 0x1b, 0x2a, 0x39
  dc.b 0xff, 0x1c, 0x2b, 0xff
  dc.b 0xff, 0xff, 0xff, 0xff

.Leye_watcher_mess_out_data2:
  dc.w 0x0101, 0xf20a         // Data will be read in bytes, upper byte will always be 0xf2, data length is 0x0a.
  dc.w 0x2002                 // Set auto-inc to 0x20
  dc.w 0x0003, 0x71f6         // Set VRAM address to 0x71f6
  dc.w 0x0004                 // Set Message
  dc.l .Leye_watcher_message  // Message
  dc.w 0x0005, 0x0001         // Add 0x01 to the current VRAM address
  dc.w 0x0006                 // Resume data output
  dc.w 0x0005, 0x0001         // Add 0x01 to the current VRAM address
  dc.w 0x0006                 // Resume data output
  dc.w 0x0000                 // End of data

.Leye_watcher_message:
  dc.b 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09
  dc.b 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x14, 0x15, 0x16, 0x17
  dc.b 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x40, 0x5e
