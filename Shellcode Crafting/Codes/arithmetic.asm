;--- the following program perfoms an arithmetic operation ( addtion ) for the values 7 and 5 
section .text
global _start
_start:
	mov rax, 7	;first no
	add rax, 5	; rax = 7 + 5
	
	mov rdi, rax	;exit status = result
	mov rax, 60 	;exit status
	syscall
