/*
    multU16by8.h - Multiplication routine written in assembler

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

.global multU16by8

multU16by8:

; r25:r24 = 16-bit multiplicand
; r22 = 8-bit multiplicand
; r18:r19:r20 = result

#define rM16L       r24
#define rM16H       r25
#define rM8         r22
#define rProd0      r18
#define rProd1      r19
#define rProd2      r20

#if C_COMPAT_ASM_CODE

    ; uint32_t multU16by8( uint16_t x, uint8_t y );
    ; x -> r25:r24
    ; y -> r22
    ; return -> r25:r24:r23:r22

#define rReturn0    r22
#define rReturn1    r23
#define rReturn2    r24
#define rReturn3    r25

    ; Call-saved registers
    push r1

#endif

    mul rM16L, rM8      ; Multiply LSB
    movw rProd0, r0     ; Copy result

    mul rM16H, rM8      ; Multiply MSB
    mov rProd2, r1      ; Copy MSB result to result byte 3
    add rProd1, r0      ; Add LSB result to result byte 2
    brcc 1f             ; If no carry, done
    inc rProd2          ; Do the carry
1:

#if C_COMPAT_ASM_CODE

    ; Move product to r25:r24:r23:r22
    movw rReturn0, rProd0
    mov rReturn2, rProd2
    clr rReturn3

    ; Call-saved registers
    pop r1

#endif

    ret

