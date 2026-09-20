;--- the following program invokes a  write system call to print Hello to stdout.
section .data
	message db "Hello", 10
	length equ $ - message
	
section .text
global _start
_start:
	mov rax, 1	;sys_write
	mov rdi, 1	;stdout
	mov rsi, message		;address of the message
	mov rdx, length 		; number of bytes
	syscall
	
	mov rax , 60 		; sys_exit
	mov rdi, rdi		; exit status = 0
	syscall
