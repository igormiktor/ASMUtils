/*
    multU16by8.h - Multiplication routine written in assembler
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
    mov rProd2, r1      ; Copy MSB result to MSB result byte 3
    add rProd1, r0      ; Add LSB result to result byte 2
    brcc 1f             ; If not carry, done
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

