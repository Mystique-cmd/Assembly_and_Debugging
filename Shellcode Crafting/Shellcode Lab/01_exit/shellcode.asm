BITS 64

global _start
section .text
_start:
	mov rax, 60		;sys_exit
	mov rdi, 42		; exit status
	syscall
