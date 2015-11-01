/*
    divU8by8 - Division routine written in assembler

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

.global divU8by8

divU8by8:

; Divides a 8-bit number by an 8-bit number
; Divides r24 by r22, returns results in r24

; Registers
; r24   8-bit dividend & 8-bit result
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

