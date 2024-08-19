.section .data
matrix_a:
	.word 1, 2, 3
	.word 3, 5, 6
matrix_b:
	.word 7, 8, 9
	.word 10, 11, 12
matrix_c:
	.space 24 
.section .text
.global _start
_start:
	LDR R0, =matrix_a
	LDR R1, =matrix_b
	LDR R2, =matrix_c
	MOV R3, #6
loop:
	CMP R3, #0          
	BEQ end             

   	LDR R4, [R0], #4   
    	LDR R5, [R1], #4    
    	ADD R6, R4, R5      
    	STR R6, [R2], #4    

    	SUB R3, R3, #1      
    	B loop
	
end:
	MOV r0, #10
	MOV r7, #1
	SWI 0
