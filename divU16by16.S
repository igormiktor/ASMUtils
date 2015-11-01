/*
    divU16by16 - Division routine written in assembler
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


#include <avr/io.h>

.section .text


;***************************************************************

.global divU16by16

divU16by16:

; Divides a 16-bit-number by a 8-bit-number
; Divide r25:r24 by r22

; Registers
; r24   LSB 16-bit dividend & 16-bit result
; r25   MSB 16-bit dividend & 16-bit result
; r22   LSB 16-bit divisor
; r23   MSB 16-bit divisor

#define rDvdndL     r24
#define rDvdndH     r25
#define rDvsrL      r22
#define rDvsrH      r23
#define rTmpL       r26
#define rTmpH       r27
#define rCntr       r21

    clr rTmpL
    clr rTmpH
    ldi rCntr, 17
    rjmp 2f

1:
    rol rTmpL
    rol rTmpH
    cp  rTmpL, rDvsrL
    cpc rTmpH, rDvsrH
    brcs 2f
    sub rTmpL, rDvsrL
    sbc rTmpH, rDvsrH

2:
    rol rDvdndL
    rol rDvdndH
    dec rCntr
    brne 1b
    com rDvdndL
    com rDvdndH
    ret
