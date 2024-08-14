/*
 * Header for C development on Neo Geo
 * Copyright (c) 2015-2020 Damien Ciabrini
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

#ifndef __NGDEVKIT_NEOGEO_H__
#define __NGDEVKIT_NEOGEO_H__


/* Shortcut types for C development */
#include <ngdevkit/types.h>

/* Memory-mapped Neo Geo registers */
#include <ngdevkit/registers.h>

/* BIOS state variables in memory */
#include <ngdevkit/bios-ram.h>

/* BIOS system calls */
#include <ngdevkit/bios-calls.h>

/* MVS: Backup RAM */
#include <ngdevkit/backup-ram.h>

/* MVS: NVRAM */
#include <ngdevkit/mvs-nvram.h>

#include <ngdevkit/user-ram.h>

#include <fixlayer/fixlayer.h>

static inline void kick_watch_dog() {
  *REG_WATCHDOGW = 0;
}

#endif /* __NGDEVKIT_NEOGEO_H__ */
