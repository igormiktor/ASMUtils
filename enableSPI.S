/*
    enableSPI - enableSPI routine written in assembler

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

.global enableSPI

enableSPI:

; r25 = temporary

#define rTmp    r25

#if C_COMPAT_ASM_CODE

    ; void enableSPI();

    ; Nothing to do; all registers are call-used

#endif

    ; If Pin 10 (PB2) is in output mode, skip next
    sbis _SFR_IO_ADDR( DDRB ), DDB2
    sbi _SFR_IO_ADDR( PORTB ), PORTB2    ; if in input mode, set it high

    ; No matter, what, set PB2 to output mode
    sbi _SFR_IO_ADDR( DDRB ), DDB2

    ; Clear the transmit register
    clr rTmp
    out _SFR_IO_ADDR( SPDR ), rTmp

    ; Set SPI configuration
    ldi rTmp, _BV(SPE) | _BV(DORD) | _BV(MSTR)
    out _SFR_IO_ADDR( SPCR ), rTmp       ; Enable SPI, LSB first, Master mode, speed 4MHz
    ldi rTmp, _BV(SPI2X)
    out _SFR_IO_ADDR( SPSR ), rTmp       ; Double speed (so 2 x 4MHz = 8MHz)

    ; Set SCK and MOSI to output mode
    ; SCK = Pin 13 = PB5
    ; MOSI = Pin 11 = PB3
    sbi _SFR_IO_ADDR( DDRB ), DDB5
    sbi _SFR_IO_ADDR( DDRB ), DDB3

    ret

#undef rTmp
