//
// ZoneMinder Core Interfaces, $Date$, $Revision$
// $Copyright$
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
// 

#if !defined(PATH_MAX)
#define PATH_MAX 1024
#endif

#ifndef ZM_H
#define ZM_H

#include "zm_config.h"
#ifdef SOLARIS
#undef DEFAULT_TYPE  // pthread defines this which breaks StreamType DEFAULT_TYPE
#include <string.h>  // define strerror() and friends
#endif
#include "zm_logger.h"

#include <stdint.h>

#include <iostream>

extern const char* self;

#endif // ZM_H
