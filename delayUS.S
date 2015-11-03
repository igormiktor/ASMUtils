/*
    delayUS - quarter-of-a-microsecond delay routine written in assembler

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
    delayQuartersOfMicroSeconds subroutine

    Takes a single argument passed in r25:r24

    That parameter is the number of quarter milliseconds to delay.

    The delay loop using a 16-bit counter, so up to 65535 iterations are possible
    (equal to 16383.75 microseconds or ~16.4 milliseconds).  The loop executes
    four CPU cycles per iteration, not including the function call overhead.
*/

.global delayQuartersOfMicroSeconds

delayQuartersOfMicroSeconds:

; Register r25:24 is passed as parameter (the number of quarter
; microseconds to delay)

; r24 = LSB number of quarter microseconds to delay
; r25 = MSB number of quarter microseconds to delay

#define rDelayL     r24
#define rDelayH     r25

#if C_COMPAT_ASM_CODE

    ; void delayQuartersOfMicroSeconds( uint16_t nbrOfQuartersOfMicroSeconds );

    ; Nothing to do; all registers are call-used

#endif

; Function call/return overhead takes about 1+1/8 microseconds, or 18 cycles,
; or between 4 and 5 quarter microseconds.
; Takes 4 cycles (= 1 quarter microsecond) to determine the requested delay is small,
; so return for any delay of less than 7 quarter microseconds;

#define kMinDelay       6

    cpi rDelayH, 0                  ; 1 cycle
    brne 1f                         ; 1 cycle if false, 2 cycles if true
    cpi rDelayL, (kMinDelay + 1)    ; 1 cycle
    brge 2f                         ; 1 cycle if false, 2 cycles if true
    ret                             ; Getting to here takes 4 cycles = 1 quarter microsecond
                                    ; or 22 cycles including the function call overhead
                                    ; We are two cycles short if r24 == 6, but long if r24 < 6

1:
    nop                             ; need to add a little extra delay if we branched at first brne
    nop

2:
    sbiw rDelayL, kMinDelay         ; 2 cycles

3:                                  ; Getting to here takes 7 cycles (1 short of 2 delay loops),
                                    ; for a total of 25 cycles including function call overhead.
                                    ; We're always 1 cycle short on loop exit, so things balance out.
    sbiw rDelayL, 1                 ; 2 cycles
    brne 3b                         ; 1 cycle on exit, 2 cycles on loop

    ret

