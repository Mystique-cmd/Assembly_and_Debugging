global _start
section .text
_start:
	;---read(0, buffer, 64)
	xor rax, rax
	xor rdi, rdi
	mov rsi, buffer
	mov rdx, 64
	syscall
	
	;---rax = bytes read
	;---write(1, buffer, bytes read)
	mov rdx, rax
	mov rax, 1
	mov rsi, buffer
	syscall
	
	;--exit(0)
	push 60
	pop rax
	xor rdi, rdi
	syscall
buffer:
	times 64 db 0
