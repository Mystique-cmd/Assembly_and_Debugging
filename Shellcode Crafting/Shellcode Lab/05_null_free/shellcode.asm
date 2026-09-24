;----- replacing mov rdi, 0 with xor rdi, rdi
global _start
section .text
_start:
	mov rax, 60
	xor rdi, rdi
	sycall
