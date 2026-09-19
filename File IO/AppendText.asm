global _start
section .data
	filename db "output.txt", 0
	text_to_write db "Hello from NASM ", 10
	text_len equ $ - text_to_write
	
section .text
_start:
	mov rax, 2
	mov rdi, filename
	mov rsi, 0x041
	mov rdx, 0644
	syscall
	
	mov r12, rax
	
	mov rax, 1
	mov rdi, r12
	mov rsi, text_to_write
	mov rdi, text_len
	syscall
	
	mov rax, 3
	mov rdi, r12
	syscall
	
	mov rax, 60
	xor rdi, rdi
	syscall
