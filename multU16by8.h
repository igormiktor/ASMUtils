/*
    multU16by8.h - C interface to routine written in assembler
    Compile the corresponding assembler file with
        #define C_COMPAT_ASM_CODE  1
    Copyright (c) 2015 Igor Mikolic-Torreira.  All right reserved.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


#ifndef multU16by8_h
#define multU16by8_h

#include <stdint.h>


#ifdef __cplusplus
extern "C" {
#endif

uint32_t multU16by8( uint16_t x, uint8_t y );

#ifdef __cplusplus
}
#endif

#endif
