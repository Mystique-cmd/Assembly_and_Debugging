global _start
section .text
_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, message
	mov rdx, message_len
	syscall
	
	mov rax, 60
	xor rdi, rdi
	syscall
	
	message:
		db "Hello from shellcode!",10
	message_len equ $ - message

;--- Here the message is physically inside the .text section.
