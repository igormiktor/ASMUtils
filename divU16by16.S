/*
    divU16by16 - Division routine written in assembler

    The MIT License (MIT)

    Copyright (c) 2015 Igor Mikolic-Torreira

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
*/


#include <avr/io.h>

.section .text


;***************************************************************

.global divU16by16

divU16by16:

; Divide a 16-bit number by a 16-bit number
; Divide r25:r24 by r23:r22, return result in r25:r24

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

#if C_COMPAT_ASM_CODE

    ; uint16_t divU8by8( uint16_t dividend, uint16_t divisor )
    ; dividend -> r25:r24
    ; divisor -> r23:r22
    ; return -> r25:r24

    ; Nothing to do; all registers are call-used

#endif

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
