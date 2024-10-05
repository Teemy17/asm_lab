        .section .data
        .equ array_size, 5000000    // Define array_size as 1,000,000 elements
        .align 4                    // Ensure 16-byte (128-bit) alignment

input1:
        .rept array_size
        .word 1                     // Fill array with 1 million elements (value 1)
        .endr

input2:
        .align 4                    // Ensure the next array starts at 128-bit aligned address
        .rept array_size
        .word 1                     // Fill array with 1 million elements (value 1)
        .endr

result:
        .align 4                    // Ensure result array is 128-bit aligned
        .space 20000000              // Reserve 4MB space (1,000,000 * 4 bytes)

        .section .text
        .global _start

_start:
    // Load base addresses of input1, input2, and result
    LDR r0, =input1               // Load address of input1 into r0
    LDR r1, =input2               // Load address of input2 into r1
    LDR r2, =result               // Load address of result into r2

    // Load array size into r3
    LDR r3, =array_size           // Load array size into r3 (1000000)
    MOV r4, #0                    // r4 = loop counter (starting at 0)

loop:
    CMP r4, r3                    // Compare loop counter (r4) with total elements (r3)
    BEQ end_loop                  // If r4 == array_size, exit the loop

    // Load one element at a time from input1 and input2
    LDR r5, [r0], #4              // Load one 32-bit integer from input1 into r5 and increment r0
    LDR r6, [r1], #4              // Load one 32-bit integer from input2 into r6 and increment r1

    // Perform addition
    ADD r7, r5, r6                // r7 = r5 + r6 (element-wise addition)

    // Store the result back into memory
    STR r7, [r2], #4              // Store the result into memory and increment r2

    // Increment the loop counter by 1 (since we process 1 element at a time)
    ADD r4, r4, #1                // r4 = r4 + 1
    B loop                        // Repeat the loop

end_loop:
    // Exit the program
    MOV r7, #1                    // System call number for exit
    MOV r0, #0                    // Status code
    SWI 0                         // Exit system call
