# ASMUtils

This is a collection of assembler routines that provide commonly needed functionality
for programming in assembler.  These routines are designed for the AVR ATmega328 and ATmega2560 8-bit
microcontrollers.  I put this together because I didn't find a convenient location with a good set
of compile-ready routines.

These routines are written for the AVR-GCC assembler (`avr-as`) and follow its conventions (which are
different in small but significant ways from the Atmel assembler conventions).  In particular, the routines
in the ASMUtils collection are coded as `*.S` files and make liberal use of the GCC preprocessor.  More
information on the AVR-GCC assembler can be found in the
[AVR Libc User Manual] (http://www.nongnu.org/avr-libc/user-manual/pages.html).

A perhaps unique feature of this collection is that by setting the preprocessor symbol `C_COMPAT_ASM_CODE` to
a non-zero value at compile time, all the ASMUtils routines will follow the
[GCC register usage and calling conventions] (http://www.nongnu.org/avr-libc/user-manual/FAQ.html#faq_reg_usage),
which means they can be called from C or C++ code.  Suitable header files are included in the collection for this
purpose.  This feature, when activated, may introduce overhead into some of the routines,
usually in the form of preserving registers by pushing and popping.  This inefficiency only affects a few
of the routines because I wrote routines to be compatible with the GCC calling conventions and
register usage rules whenever I could do so without introducing inefficiencies, (e.g., `divU8by8.S`
is compatible with C as written).  Only a few routines cannot be written to be compatible "out of the box"
(e.g., `multU16by8.S` because it uses the `mult` instruction which trashes register `r1`).
I originally coded this feature to facilitate testing (it's much easier to drive tests using a test harness
written in C), but it has proven useful enough to retain as a standard feature of this collection.

Documentation on this collection is provided directly as comments in the various files.  The routines are not
always written in the most general way (e.g., the USART0 routines are hard coded for serial communications at
115,200 baud, 8-bits, no parity, 1 stop bit).  The contents of the
collection is driven entirely by the needs of the various AVR projects I work on in my spare time.  It will
grow and evolve over time driven by those needs and my interests, which may resemble a random walk. If you
have a particular need, let me know and I will do what I can.




