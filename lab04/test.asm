.section .data
prompt_msg: 
    .asciz "Please enter your name: "
greet_prefix:
    .asciz "Hello, "
greet_suffix:
    .asciz "! Welcome to the Raspberry Pi!\n"
name_buffer: 
    .space 20     @ Reserve 20 bytes for name input

.section .text
.global _start
_start:
    @ --- Ask for Name --- 
    mov r0, #1          @ File descriptor (stdout)
    ldr r1, =prompt_msg
    ldr r2, =23         @ Length of prompt message
    mov r7, #4          @ System call number for write
    swi 0               @ Make the system call

    @ --- Get Input --- 
    mov r0, #0          @ File descriptor (stdin)
    ldr r1, =name_buffer
    mov r2, #19         @ Maximum bytes to read (leave space for null terminator)
    mov r7, #3          @ System call number for read
    swi 0               @ Make the system call
    mov r4, r0          @ Save the number of bytes read to r4

    @ --- Add Null Terminator ---
    ldr r1, =name_buffer
    add r1, r1, r4      @ Move to the end of the input
    sub r1, r1, #1      @ Move back one byte to overwrite the newline
    mov r2, #0          @ Null terminator
    strb r2, [r1]       @ Store null terminator

    @ --- Display Greeting --- 
    mov r0, #1          @ File descriptor (stdout)
    ldr r1, =greet_prefix @ Address of the "Hello, " string
    ldr r2, =7          @ Length of the prefix string
    mov r7, #4          @ System call: write
    swi 0               @ Execute the write syscall

    mov r0, #1          @ File descriptor (stdout)
    ldr r1, =name_buffer @ Address of the name buffer
    mov r2, r4          @ Length of the name (from bytes read)
    sub r2, r2, #1      @ Subtract 1 to exclude newline
    mov r7, #4          @ System call: write
    swi 0               @ Execute the write syscall

    mov r0, #1          @ File descriptor (stdout)
    ldr r1, =greet_suffix @ Address of the suffix string
    ldr r2, =31         @ Length of the suffix string
    mov r7, #4          @ System call: write
    swi 0               @ Execute the write syscall

    @ --- Exit ---
    mov r0, #0          @ Exit code
    mov r7, #1          @ System call number for exit
    swi 0 
