.globl wait
wait:
push {lr}

mov r3,r0
waitDiff .req r3

@ calculate the lo-time to wait until
bl GetCounter
add waitDiff,r0
.unreq waitDiff
waitTime .req r3

@ read a value from counter, then branch until counter > alarm
inner:
    bl GetCounter
    cmp r0,waitTime
    bls inner

.unreq waitTime
pop {pc}

GetCounter:
@ The base address for the GPIO timer
ldr r2,=0x20003000

counter .req r2
ldrd r0,r1,[counter,#4] @ +4 -> Counter
.unreq counter

mov pc,lr
