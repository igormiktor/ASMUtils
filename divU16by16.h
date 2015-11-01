/*
    divU16by16.h - C interface to routine written in assembler
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


#ifndef divU16by16_h
#define divU16by16_h

#include <stdint.h>


#ifdef __cplusplus
extern "C" {
#endif

uint16_t divU16by16( uint16_t dividend, uint16_t divisor );

#ifdef __cplusplus
}
#endif

#endif
