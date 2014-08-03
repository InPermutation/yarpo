.globl GetGpioAddress
GetGpioAddress:
ldr r0,=0x20200000
mov pc,lr

.globl SetGpioFunction
SetGpioFunction:
@ r0: GPIO pin number
@ r1: function number

@ sanity check: quit if r0>53 or r1>7
cmp r0,#53
cmpls r1,#7
movhi pc,lr

@ store return address on stack
push {lr}

@ GetGpioAddress overwrites r0, so move it to r2
mov r2,r0

bl GetGpioAddress

@ Subtract 10 from r2 until it is <= 9; adding 4 to r0
functionLoop$:
    cmp r2,#9
    subhi r2,#10
    addhi r0,#4
    bhi functionLoop$

@ r2 *= 3 to get the bit#
add r2, r2,lsl #1

@ r0 is the GPIO base for this set of 10 pins
@ r1 is the function number
@ r2 is the bit offset into the base
@ Now write the function number to the correct location by shifting it into position...
lsl r1,r2
@ ...and writing it to [r0]
str r1,[r0]

@BUG: this overwrites all other bits in this block of 10 pins to 0!

@ all done; restore lr from stack directly into pc
pop {pc}

.globl SetGpio
SetGpio:
@ use aliases
pinNum .req r0
pinVal .req r1

@sanity check
cmp pinNum,#53
movhi pc,lr

push {lr}

@ save pinNum in r2
mov r2,pinNum
.unreq pinNum
pinNum .req r2

@ save GetGpioAddress in gpioAddr (r0)
bl GetGpioAddress
gpioAddr .req r0

@ add the pin to the gpioAddr base
pinBank .req r3
lsr pinBank,pinNum,#5 @ pinBank = pinNum / 32
lsl pinBank,#2 @ * set of 4 bytes
add gpioAddr,pinBank
.unreq pinBank

@ calculate the bit to set
and pinNum,#31 @ pinNum = pinNum % 32
setBit .req r3
mov setBit,#1
lsl setBit,pinNum
.unreq pinNum

@ store the bit to set in the correct offset depending on whether pinVal is clear
teq pinVal,#0
.unreq pinVal
streq setBit,[gpioAddr,#40] @ off
strne setBit,[gpioAddr,#28] @ on
.unreq setBit
.unreq gpioAddr

@ get outta dodge
pop {pc}

