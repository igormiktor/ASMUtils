/*
    multU16by16 - Multiplication routine written in assembler

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

.global multU16by16

multU16by16:

; r25:r24 = 16-bit multiplicand
; r23:r22 = 16-bit multiplicand
; r18:r19:r20:r21 = result

#define rM1L        r24
#define rM1H        r25
#define rM2L        r22
#define rM2H        r23
#define rProd0      r18
#define rProd1      r19
#define rProd2      r20
#define rProd3      r21
#define rZero       r26

#if C_COMPAT_ASM_CODE

    ; uint32_t multU16by8( uint16_t x, uint16_t y );
    ; x -> r25:r24
    ; y -> r23:r22
    ; return -> r25:r24:r23:r22

#define rReturn0    r22
#define rReturn1    r23
#define rReturn2    r24
#define rReturn3    r25

    ; Call-saved registers
    push r1

#endif

    ; Set zero
    clr rZero

    ; Multiply LSBs and store in result low word
    mul rM1L, rM2L
    movw rProd0, r0

    ; Multiply MSBs and store in result low word
    mul rM1H, rM2H
    movw rProd2, r0

    ; Cross multiply MSB x LSB and add it in
    mul rM1H, rM2L
    add rProd1, r0
    adc rProd2, r1
    adc rProd3, rZero   ; To pick up the carry

    ; Cross multiply LSB x MSB and add it in
    mul rM1L, rM2H
    add rProd1, r0
    adc rProd2, r1
    adc rProd3, rZero   ; To pick up the carry

#if C_COMPAT_ASM_CODE

    ; Move product to r25:r24:r23:r22
    movw rReturn0, rProd0
    movw rReturn2, rProd2

    ; Call-saved registers
    pop r1

#endif

    ret

