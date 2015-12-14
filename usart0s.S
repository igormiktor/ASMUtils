/*
    usart0s.h - Bare bones USART0 routines written in assembler

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

.global enableUSART0

enableUSART0:

; Enable USART0 at 115200 baud, 8 bits, no parity, 1 stop bit.

; r24 = temporary (various port values)
; r30 = ZL
; r31 = ZH
; Z = addressing for USART0 ports

#define rTmp        r24

#if C_COMPAT_ASM_CODE

    ; void enableUSART0();

    ; Nothing special needs to be done -- all registers are call-used registers

#endif

    ldi ZH, hi8( UBRR0H )

    ; Set baud rate of 115200
    clr rTmp
    ldi ZL, lo8( UBRR0H )
    st Z, rTmp
    ldi rTmp, 8
    ldi ZL, lo8( UBRR0L )
    st Z, rTmp

    ; Enable TX and RX
    ldi rTmp, _BV(RXEN0) | _BV(TXEN0)
    ldi ZL, lo8( UCSR0B )
    st Z, rTmp

    ; Configure 8-bit data, 1 stop bit, no parity
    ldi rTmp, _BV(UCSZ01) | _BV(UCSZ00)
    ldi ZL, lo8( UCSR0C )
    st Z, rTmp

    ret

#undef rTmp





;***************************************************************

.global sendUSART0

sendUSART0:

; r24 = byte to send
; r25 = temporary

#define rByteToSend         r24
#define rTmp                r25

#if C_COMPAT_ASM_CODE

    ; void sendUSART0( uint8_t byteToSend );
    ; byteToSend -> r24

    ; Nothing special needs to be done -- all registers are call-used registers

#endif

    ldi ZH, hi8( UCSR0A )
    ldi ZL, lo8( UCSR0A )

1:
    ld rTmp, Z
    sbrs rTmp, UDRE0                ; Wait for an empty transmit buffer (bit gets set when empty)
    rjmp 1b

    ldi ZL, lo8( UDR0 )
    st Z, rByteToSend               ; transmit byte

    ret

#undef rByteToSend
#undef rTmp





