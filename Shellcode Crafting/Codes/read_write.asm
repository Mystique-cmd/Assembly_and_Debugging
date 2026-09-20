;--- the program below reads from and writes to memory
section .data
	value dq 42

section .text
global _start
_start:
	mov rax, [value]	;reads 42 from the memory into rax
	add rax, 8	;rax= 42 + 8
	
	mov [value], rax	; write the result of rax back to the memory 
	
	mov rdi, [value]	; reads the results from memory / exit status
	mov rax, 60 	;sys_exit
	syscall
