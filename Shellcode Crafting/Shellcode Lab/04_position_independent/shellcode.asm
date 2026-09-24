global _start
section .text
_start:
	jmp short get_message
	
print_message:
	pop rsi
	
	mov rax, 1
	mov rdi, 1
	mov rdx, message_len
	syscall
	
	mov rax, 60
	xor rdi, rdi
	syscall

get_message:
	call print_message

message:
	db "Position Independent", 10

message_len equ $ - message
