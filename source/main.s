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

ptrn .req r4
ldr ptrn,=pattern
ldr ptrn,[ptrn]
seq .req r5
mov seq,#0

loop$:

    mov r1,#1
    lsl r1,seq
    and r1,ptrn

    mov r0,#16
    bl SetGpio

    ldr r0,=250000
    bl wait

    add seq,#1
    and seq,#31

b loop$

.section .data
.align 2
pattern:
.int 0b10101011000100010001101010111111

