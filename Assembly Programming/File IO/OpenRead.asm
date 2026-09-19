%define SYS_READ 0
%define SYS_WRITE 1
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define SYS_EXIT 60

%define O_RDONLY 0

global _start
section .data
	file name db "input.txt",0
	bufsize equ 1024
	
section .bss
	buffer resb bufsize

section .text
_start:
	mov rax, SYS_READ
	mov rdi , r12
	mov rsi,  buffer
	mov rdi, bufsize
	syscall
	
	cmp rax, 0
	jle .close_file
	
	mov rdi, 1
	mov rax, SYS_WRITE
	mov rsi, buffer
	
	mov rdx, rax
	syscall
	
	jmp .read_loop
	
.close_file:
	mov rax, SYS_CLOSE
	mov rdi, r12
	syscall
	
.exit_error:
	mov rax, SYS_EXIT
	xor rdi, rdi
	syscall
