.section .init
.globl _start
_start:

ldr r0,=0x20200000 @ base of GPIO

@ 54 pins exist on RPi
@ every 4 bytes refer to set of 10 pins
@ ceil(54 pins / 4 bytes/10pin * 10pin) = 24 bytes
@ 4 bytes = 32 bits; 3 bits per pin
@ 32/3 = 10 mod 2

mov r1,#1
lsl r1,#18 @ 6th set of 3 bits = (6*3) = 18
str r1,[r0,#4] @ 2nd set of 4 bytes = pins # 10-19 = [r0,#4]
@ ^ prepare 16th GPI pin for output.

mov r1,#1
lsl r1,#16 @ pin 16!
str r1,[r0,#40]
@ ^ +40 is the address to turn a pin off (+28 turns it on)

loop$:
b loop$

