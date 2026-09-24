;---- replacing mov rax, 60 with push 60 pop rax
global _start
section .text
_start:
	push 60
	pop rax
	
	xor rdi , rdi
	syscall
