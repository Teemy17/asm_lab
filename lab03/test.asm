.global _start
.section .text

_start:
	mov r7, #4
	mov r0, #1
	ldr r1, =message
	mov r2, #13
	swi 0

	mov r7, #1
	mov r0, #65
	swi 0

.section .data
	message:
	.ascii "Hello, World\n"
