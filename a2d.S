/*
    a2d - analog-to-digital routines written in assembler

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

.global enableA2D

enableA2D:

; r24 = temporary
; r30 = ZL
; r31 = ZH
; Z = addressing for A2D ports
; r30 = delay counter LSB
; r31 = delay coutner MSB

#define rTmp        r24

#if C_COMPAT_ASM_CODE

    ; void enableA2D();

    ; Nothing to do; all registers are call-used

#endif

    ldi ZH, hi8( ADMUX )

    ; ref = AVCC, right-adjusted, default channel = ADC0
    ldi ZL, lo8( ADMUX )
    ldi rTmp, _BV(REFS0)
    st Z, rTmp

    ; Zero ADCSRB
    ldi ZL, lo8( ADCSRB )
    clr rTmp
    st Z, rTmp

    ; Enable A2D with divider = 128
    ldi ZL, lo8( ADCSRA )
    ldi rTmp, _BV(ADEN) | _BV(ADPS2) | _BV(ADPS1) | _BV(ADPS0)
    st Z, rTmp

    ret

#undef rTmp






;***************************************************************

.global stabilizeA2D

stabilizeA2D:

; r24 = channel to set; temporary
; r30 = ZL
; r31 = ZH
; Z = addressing for A2D ports

#define rCntrL      r24
#define rCntrH      r25
#define rTmp        r24

#if C_COMPAT_ASM_CODE

    ; void stabilizeA2D();

    ; Nothing to do; all registers are call-used

#endif


    ; Delay about 125 usec for hardware to stabilize
    ; 2000 cycles at 16 MHz (a bit short, but there is also call overhead
    ldi rCntrL, 0xF3
    ldi rCntrH, 0x01
1:
    sbiw rCntrL, 1                  ; 2 cycles
    brne 1b                         ; 1 cycle on exit, 2 cycles on loop

    ; Prime the A2D system by forcing a read
    ; Start A2D conversion
    ldi ZH, hi8( ADCSRA )
    ldi ZL, lo8( ADCSRA )
    ld rTmp, Z
    ori rTmp, _BV(ADSC)
    st Z, rTmp

    ; ADSC is cleared when the conversion finishes
2:
    ld rTmp, Z
    sbrc rTmp, ADSC
    rjmp 2b                         ; loop until transmit complete

    ; Need to read ADCH to complete the process
    ldi ZL, lo8( ADCH )
    ld rTmp, Z

    ret

#undef rCntrL
#undef rCntrH
#undef rTmp





;***************************************************************

.global setA2Dchannel

setA2Dchannel:

; r24 = channel to set
; r30 = ZL
; r31 = ZH
; Z = addressing for A2D ports

#define rChannel    r24
#define rADCSRA     r25
#define rADCSRB     r25
#define rADMUX      r25

#if C_COMPAT_ASM_CODE

    ; void setA2Dchannel( uint8_t channel );
    ; channel -> r24

    ; Nothing to do; all registers are call-used

#endif

    ldi ZH, hi8( ADMUX )

#if defined(__AVR_ATmega2560__)

    ; Deal with higher channels (8-15)

    ; Get current value of ADCSRB
    ldi ZL, lo8( ADCSRB )
    ld rADCSRB, Z

    sbrc rChannel, MUX5
    rjmp 1f

    ; Clear MUX5 bit in register representation of ADCSRB
    cbr rADCSRB, _BV(MUX5)
    rjmp 2f

1:  ; Set MUX5 bit in register representation of ADCSRB
    sbr rADCSRB, _BV(MUX5)

2:  ; Store the value back into ADCSRB
    st Z, rADCSRB

#endif

    ; Get the last 3 bits of the channel and use them to set the channel
    cbr rChannel, 0xF8

    ; Get current channel setting
    ldi ZL, lo8( ADMUX )
    ld rADMUX, Z

    ; Clear the channel bits of the current settings and set them as desired
    cbr rADMUX, 7
    or rADMUX, rChannel
    st Z, rADMUX

    ret

#undef rChannel
#undef rADCSRA
#undef rADCSRB
#undef rADMUX






;***************************************************************

.global readA2D

readA2D:

; r24 = temporary; return value (L)
; r25 = return value (H)
; r30 = ZL
; r31 = ZH
; Z = addressing for A2D ports

#define rTmp        r24
#define rRetL       r24
#define rRetH       r25

#if C_COMPAT_ASM_CODE

    ; uint16_t readA2D();

    ; Nothing to do; all registers are call-used

#endif

    ldi ZH, hi8( ADCSRA )

    ; Start A2D conversion
    ldi ZL, lo8( ADCSRA )
    ld rTmp, Z
    ori rTmp, _BV(ADSC)
    st Z, rTmp

    ; ADSC is cleared when the conversion finishes
1:
    ld rTmp, Z
    sbrc rTmp, ADSC
    rjmp 1b                         ; loop until transmit complete

    ; Get the result
    ldi ZL, lo8( ADCL )
    ld rRetL, Z
    ldi ZL, lo8( ADCH )             ; Must read ADCH second.
    ld rRetH, Z

    cbr rRetH, 0xFC

    ret

#undef rTmp
#undef rRetL
#undef rRetH
