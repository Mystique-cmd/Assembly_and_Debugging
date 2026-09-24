global _start
section .data
	message: 
		db " Hello from shellcode", 10
	message_len  equ $ - message
section .text
_start:
	mov rax, 1		; sys_write
	mov rdi, 1		;stdout
	mov rsi, message	
	mov rdx, message_len
	syscall
	
	mov rax, 60
	xor rdi, rdi
	syscall
