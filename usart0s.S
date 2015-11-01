/*
    usart0s.h - Bare bones USART0 routines written in assembler
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

.global enableUSART0

enableUSART0:

; Enable USART0 at 11520 baud, 8 bits, no parity, 1 stop bit.

; r24 = temporary
; r30 = ZL
; r31 = ZH
; Z = addressing for A2D ports

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

    ; Configure 8-bit data, 1 stopo-bit, no parity
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

    ldi ZL, lo8(UDR0)
    st Z, rByteToSend               ; transmit byte

    ret

#undef rByteToSend
#undef rTmp





