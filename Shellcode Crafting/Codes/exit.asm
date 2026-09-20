;---the following program exits a process
section .text
global _start

_start:
	mov rax, 60 	;sys_exit
	mov rdi, 0	; exit status = 0
	syscall
