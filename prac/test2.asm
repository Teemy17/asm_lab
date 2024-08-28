.section .data
    matrixA: .word 3,1,4
    matrixB: .word 4,3
             .word 2,5
             .word 6,8

.section .bss
    matrixResult: .space 8

.section .text
.global _start
_start:
    ldr r0, =matrixA
    ldr r1, [r0]
    ldr r2, =matrixB
    ldr r3, [r2]
    ldr r4, =matrixResult
    mov r9, #2            @ Loop 2 times
    mov r5, #0        @ Sum
    mov r6, #3        @ Loop counter

loop:
    mul r10, r1, r3
    add r5, r5, r10        @ 12 + 2 + 24
    ldr r1, [r0, #4]!
    ldr r3, [r2, #8]!
    sub r6, r6, #1
    cmp r6, #0
    bne loop
    str r5, [r4], #4
    sub r9, r9, #1
    cmp r9, #0
    beq exit


moveAandB:
    mov r5, #0        @ Sum
    mov r6, #3        @ Loop counter
    ldr r0, =matrixA
    ldr r1, [r0]
    ldr r2, =matrixB
    ldr r3, [r2, #4]!
    b loop

exit:
    mov r7, #1
    mov r0, #0
    svc 0