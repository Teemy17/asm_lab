.section .data
.align 4
input1: .word 1, 2, 3, 4
input2: .word 5, 6, 7, 8
result: .space 16

.section .text
.global _start

_start:
    LDR r0, =input1
    LDR r1, =input2
    LDR r2, =result

    VLD1.32 {q0}, [r0]
    VLD1.32 {q1}, [r1]

    VADD.I32 q2, q0, q1

    VST1.32 {q2}, [r2]

    MOV r7, #1
    MOV r0, #0
    SWI 0
