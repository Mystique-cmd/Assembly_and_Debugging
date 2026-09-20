;---the following program returns a value 42
section .text
global _start
_start:
	mov rax , 60 ;sys_exit
	mov rdi, 42	; exit status = 42
	syscall
