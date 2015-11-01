/*
    divU8by8 - Division routine written in assembler
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

.global divU8by8

divU8by8:

; Divides a 8-bit number by an 8-bit number
; Divides r24 by r22

; Registers
; r24   8-bit dividend & result
; r22   8-bit divisor

#define rDvdnd      r24
#define rDvsr       r22
#define rTmp        r25
#define rCntr       r23

#if C_COMPAT_ASM_CODE

    ; uint8_t divU8by8( uint8_t dividend, uint8_t divisor )
    ; dividend -> r24
    ; divisor -> r22
    ; return -> r24

    ; Nothing to do; all registers are call-used

#endif

    clr rTmp
    ldi rCntr, 9
    rjmp 2f

1:
    rol rTmp
    cp  rTmp, rDvsr
    brcs 2f
    sub rTmp, rDvsr

2:
    rol rDvdnd
    dec rCntr
    brne 1b
    com rDvdnd

    ret

