.global reverse_string

reverse_string:
	push {lr}
	add r3, r0, r1
	sub r3, r3, #1

reverse_loop:
	cmp r0, r3
	bge reverse_done
	
	ldrb r2, [r0]
	ldrb r4, [r3]

	strb r4, [r0]
	strb r2, [r3]

	add r0, r0, #1
	sub r3, r3, #1

	b reverse_loop

reverse_done:
	pop {lr}
	bx lr
