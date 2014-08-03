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
@ ^ prepare 16th GPIO pin for output.

mov r1,#1
lsl r1,#16 @ pin 16!


loop$:

str r1,[r0,#40] @ +40 - pin off

mov r2,#0x3F0000 @ about 2 seconds
wait1$:
sub r2,#1
cmp r2,#0
bne wait1$

str r1,[r0,#28] @ +28 - pin on

mov r2,#0x3F0000 @ about 2 seconds
wait2$:
sub r2,#1
cmp r2,#0
bne wait2$

b loop$
