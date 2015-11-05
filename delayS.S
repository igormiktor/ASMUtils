/*
    delayS - tenth of second delay routine written in assembler

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



/*
    delayTenthsOfSeconds subroutine

    Delay loop using an 8-bit counter that iterates a set of inner loops.
    The set of inner loops takes 1/10 second to execute.

    The 8-bit parameter is the number of tenths of a second to delay, for
    a maximum of 256 tenths of a second or 25.6 secondz.  Note that the
    value 256 would have to be passed as 0.

    Although the 1/10 second timing loop itself is accurate to within
    10-20 microseconds at 16 MHz, the call overhead and the loop for
    multiple tenths of a second will increase the inaccuracy, but the
    error will remain at most a few hundreds of microseconds.

    Takes a single uint8_t argument passed in r24

    That parameter is the number of tenths of seconds
    to delay.

*/

.global delayTenthsOfSeconds

delayTenthsOfSeconds:

; Register r24 (tenthOfSecCounter) is passed as parameter
; r24 = number of tenths-of-seconds to count (comes in as argument)
;     = number of times to execute the outer+inner loops combined
; r25 = outer loop counter byte
; r26 = low byte of inner loop counter word
; r27 = high byte of inner loop counter word

#define r10ths          r24
#define rOuter          r25
#define rInnerL         r26
#define rInnerH         r27

#if C_COMPAT_ASM_CODE

    ; void delayTenthsOfSeconds( uint8_t nbrOfTenthsOfSeconds );

    ; Nothing to do; all registers are call-used

#endif

; Executing the following combination of inner and outer loop cycles takes almost precisely 0.1 seconds
#define kOuterCount     7
#define kInnerCount     57142



; Top of loop for number of tenths-of-seconds
1:
    ; Initialize outer loop (uses a byte counter and counts down)
    ldi rOuter, kOuterCount

; Top of outer loop
2:
    ; Initialze inner loop (uses a word counter and counts down)
    ldi rInnerL, lo8( kInnerCount )
    ldi rInnerH, hi8( kInnerCount )

; Top of inner loop
3:
    ; Decrement and test inner loop
    sbiw rInnerL, 1
    brne 3b
    ; Done with inner loop

    ; Decrement and test outer loop
    dec rOuter
    brne 2b
    ; Done with inner loop

    ; Decrement and test tenth-of-second loop
    dec r10ths
    brne 1b
    ; Done with the requested number of tenths-of-seconds

    ret

#undef r10ths
#undef rOuter
#undef rInnerL
#undef rInnerH
#undef kInnerCount
#undef kOuterCount
