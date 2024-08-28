.section .data
mat_a:  .word 1, 2, 3, 4
mat_b:  .word 4, 5, 6, 7
mat_c:  .word 0, 0, 0, 0 // .space 16
.section .text
.global _start
_start:
    ldr r0, =mat_a // *mat_a
    ldr r1, =mat_b // *mat_b
    ldr r2, =mat_c
    mov r3, #0 // i counter

loop:
    cmp r3, #4
    beq exit
    ldr r4, [r0] // r4 = *r0 -> a = *mat_a
    ldr r5, [r1] // r5 = *r1 -> b = *mat_b
    add r6, r5, r4 // c = b + a
    str r6, [r2]// *mat_c = c
    add r0, r0, #4 // mat_a += 4
    add r1, r1, #4 // mat_b += 4
    add r2, r2, #4 // mat_c += 4
    add r3, r3, #1 // i += 1
    b loop

exit:
    mov r0, #0
    mov r7, #1
    swi 0
