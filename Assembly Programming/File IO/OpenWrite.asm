global _start
section .data
	filename : db "output.txt", 0
	
section .bss
	buffer resb 1024
	
section .text
_start:
	mov rax, 2		;sys_open
	mov rdi, filename
	mov rsi, 0101o
	or rsi, 01000o
	mov rdx, 0644o
	
	cmp rax, 0
	js .exit
	mov r12, rax

.read_loop:
	mov rax, 0
	mov rdi, 0
	mov rsi, buffer
	mov rdx, 1024
	syscall
	
	cmp rax, 0
	jle .close_file
	
	mov rdi, r12
	mov rsi, buffer
	mov rdx, rax
	mov rax, 1
	syscall
	
	jmp .read_loop

.close_file:
	mov rax, 3
	mov rdi, r12
	syscall

.exit:
	mov rax, 60
	xor rdi, rdi
	syscall
	
