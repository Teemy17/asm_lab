.section .data
matrix_a: .word 1, 2
    .word 3, 4

matrix_b: .word 5, 6
    .word 7, 8

matrix_c: .space 16

    .section .text
    .global _start
_start:
    ldr r0, =matrix_a
    ldr r1, =matrix_b
    ldr r2, =matrix_c

    mov r3, #2
    mov r10, #1 @ for outer loop
loop:
    cmp r3, #0
    beq end_loop @ if corrent matrix c will now have 8 bytes when loop ends

    ldr r4, [r0]
    ldr r5, [r1]

    push {r0}    @ keep address of 1

    mul r6, r4, r5

    add r0, #4
    add r1, #8

    ldr r4, [r0]
    ldr r5, [r1]
    mul r7, r4, r5

    mov r8, #0
    add r8, r6, r7

    str r8, [r2]

    pop {r0} @ r0 resets to address of the previous number
    sub r1, #4  @ new loop r1 will point at 6 
    add r2, #4 @ next position of result matrix
    sub r3, #1 @ decrement loop counter

    b loop

end_loop:
    cmp r10, #0
    beq end_program

    mov r3, #2 @ resets the counter for last 8 bytes of result matrix
    add r0, #8  @ move to loop the 3 and 4
    ldr r1, =matrix_b @ resets the pointer of matrix b


    sub r10, #1 @ runs the outer loop for one more time
    b loop

end_program:
    mov r0, #0
    mov r7, #1
    svc 0