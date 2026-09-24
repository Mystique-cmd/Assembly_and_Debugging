global _start
section .text
_start:
	;----read(0, buffer, 64)
	mov rax, 0		;sys_read
	mov rdi, 0		;stdin
	lea rsi, [rel buffer]
	mov rdx, 64
	syscall
	
	;----write(1, buffer, 64)
	mov rax, 1
	mov rdi, 1
	lea rsi, [rel buffer]
	mov rdx, 64
	syscall
	
	;---exit(0)
	mov rax, 60
	xor rdi, rdi
	syscall
	
buffer:
	times 64 db 0
