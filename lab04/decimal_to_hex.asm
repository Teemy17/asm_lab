.section .data
prompt_msg:
    .asciz "Please enter a positive decimal number: "
error_msg:
    .asciz "Invalid input. Please enter a valid positive decimal number.\n"
name_buffer:
    .space 20  @ Reserve 20 bytes for number input

.section .bss
number:
    .skip 4    @ Space to store the converted number (integer)

.section .text
.global _start

_start:
    @ --- Ask for Number ---
    mov r0, #1                  @ File descriptor (stdout)
    ldr r1, =prompt_msg         @ Address of the prompt message
    ldr r2, =37                 @ Length of the prompt message
    mov r7, #4                  @ System call number for write
    swi 0                       @ Make the system call

    @ --- Get Input ---
    mov r0, #0                  @ File descriptor (stdin)
    ldr r1, =name_buffer        @ Address to store the input
    mov r2, #19                 @ Maximum bytes to read (leave space for null terminator)
    mov r7, #3                  @ System call number for read
    swi 0                       @ Make the system call
    mov r4, r0                  @ Save the number of bytes read to r4

    @ --- Add Null Terminator ---
    ldr r1, =name_buffer        @ Load address of input string
    add r1, r1, r4              @ Move to the end of the input
    sub r1, r1, #1              @ Move back one byte to overwrite the newline
    mov r2, #0                  @ Null terminator
    strb r2, [r1]               @ Store null terminator

    @ --- Convert String to Integer ---
    ldr r0, =name_buffer        @ Load address of input string
    mov r1, #0                  @ Initialize result to 0
    mov r2, #10                 @ Base 10 for decimal conversion

convert_loop:
    ldrb r3, [r0]               @ Load a byte from the input string
    cmp r3, #0                  @ Check for null terminator
    beq done_conversion         @ If null terminator, we're done
    sub r3, r3, #48             @ Convert ASCII to integer ('0' -> 0, '1' -> 1, ..., '9' -> 9)
    cmp r3, #9                  @ Check if it's a valid digit
    blo valid_digit
    b error_input               @ If invalid, go to error handling

valid_digit:
    mul r1, r1, r2              @ result = result * 10
    add r1, r1, r3              @ result = result + current digit
    add r0, r0, #1              @ Move to the next character
    b convert_loop              @ Repeat for the next character

done_conversion:
    ldr r2, =number             @ Address to store the result
    str r1, [r2]                @ Store the converted number in memory

    @ --- Convert Integer to Hexadecimal ---
    ldr r1, [r2]                @ Load the integer from memory
    mov r0, r1                  @ Move integer to r0 for conversion

    @ --- Load the hexadecimal value into R0 ---
    mov r0, r1                  @ The hexadecimal value is now in r0

    @ --- Exit Program ---
    mov r7, #1                  @ System call number for exit
    swi 0                       @ Make the system call

error_input:
    @ Display error message if needed (omitted in this example)
    b _start                    @ Restart program (or handle appropriately)

