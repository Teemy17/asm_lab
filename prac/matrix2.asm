.section .data
	matrixA: .word 6, 7
	         .word 1, 4
	matrixB: .word 1, 2
	         .word 3, 4
.section .bss
	matrixResult: .space 16
.section .text

.global _start
_start:
	mov r0, #0 						@ i loop counter

i_loop:
	mov r1, #0						@ j loop counter
		
j_loop:
	mov r2, #0						@ k loop counter

k_loop:
	@ R3 will be &matrixA[i][k]
	@ R4 will be &matrixB[k][j]
	@ R9 will be &matrixResult[i][j]
		
	mov r5, #4
	mov r6, #8

	ldr r3, =matrixA
	mul r8, r0, r6					@ i * 8
	add r3, r3, r8					@ &matrixA[i]
	mul r8, r2, r5					@ k * 4
	add r3, r3, r8					@ &matrixA[i][k]

	ldr r4, =matrixB
	mul r8, r2, r6					@ k * 8
	add r4, r4, r8					@ &matrixB[k]
	mul r8, r1, r5					@ j * 4
	add r4, r4, r8					@ &matrixB[k][j]
	
	ldr r9, =matrixResult
	mul r8, r0, r6					@ i * 8
	add r9, r9, r8					@ &matrixResult[i]
	mul r8, r1, r5					@ k * 4
	add r9, r9, r8					@ &matrixResult[i][k]
	
	ldr r5, [r3]					@ r5 = matrixA[i][k]
	ldr r6, [r4]					@ r6 = matrixB[k][j]
	
	mul r8, r5, r6				
	ldr r10, [r9]					@ tmp = matrixResult[i][j]	
	add r10, r10, r8				@ tmp = tmp + matrixA[i][k] * matrixB[k][j]
	
	str r10, [r9]
	
k_exit:
	cmp r2, #1
	beq j_exit
	
	add r2, r2, #1
	b k_loop

j_exit:
	cmp r1, #1
	beq i_exit
	
	add r1, r1, #1
	b j_loop
	
i_exit:
	cmp r0, #1
	beq return
	
	add r0, r0, #1
	b i_loop
	
return:
	@exit
    mov r7, #1
    mov r0, #0
    swi 0