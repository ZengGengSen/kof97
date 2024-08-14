/*
 * BIOS system calls
 * Copyright (c) 2020 Damien Ciabrini
 * This file is part of ngdevkit
 *
 * ngdevkit is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * ngdevkit is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with ngdevkit.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef __NGDEVKIT_BIOS_CALLS_H__
#define __NGDEVKIT_BIOS_CALLS_H__

typedef void (*bios_call_t)(void);
typedef volatile bios_call_t bios_call_ptr;

#define system_return ((bios_call_ptr)0xc00444)

#endif /* __NGDEVKIT_BIOS_CALLS_H__ */
