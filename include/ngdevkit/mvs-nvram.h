#ifndef __NGDEVKIT_MVS_NVRAM_H__
#define __NGDEVKIT_MVS_NVRAM_H__

// extern u8 nvram_legal_board;
#define MEM_NVRAM ((volatile u8*)0xd00000)

#define NVRAM_LEGAL_BOARD (*(volatile u8*)0xd00000)

#endif /* __NGDEVKIT_MVS_NVRAM_H__ */
