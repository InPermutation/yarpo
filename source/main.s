.section .init
.globl _start
_start:

b main


.section .text
main:
mov sp,#0x8000

pinNum .req r0
pinFunc .req r1
mov pinNum,#16
mov pinFunc,#1
bl SetGpioFunction
.unreq pinNum
.unreq pinFunc

loop$:

pinNum .req r0
pinVal .req r1
mov pinNum,#16
mov pinVal,#0
bl SetGpio
.unreq pinNum
.unreq pinVal

ldr r0,=2000000
bl wait

pinNum .req r0
pinVal .req r1
mov pinNum,#16
mov pinVal,#1
bl SetGpio
.unreq pinNum
.unreq pinVal

ldr r0,=2000000
bl wait

b loop$

