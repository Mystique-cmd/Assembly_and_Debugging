BITS 64
global _start
section .data
	BUF_SIZE equ 4096
	msg_usage db "Usage : ./copy source_file dest_file", 10
	len_usage equ $ - msg_usage
	
	msg_open_src_fail db "Error : cannot open source file:, 10
	len_open_src_fail equ $ - msg_open_src_fail
	
	msg_open_dst_fail db "Error : cannot open/create dest file", 10
	len_open_dst_fail equ $ - msg_open_dst_fail
	
section .bss
	buffer resb BUF_SIZE
	
section .text
_start:
	mov rbx, rsp 
	mov rdi, [rbx]
	cmp rdi, 3
	jne .print_usage_and_exit
	
	mov rsi, [rbx + 16]
	mov rdxx, [rbx + 24]
	
	mov rax, 2
	mov rdi, rsi
	mov rsi, 0
	mov rdx, 0
	syscall
	
	cmp rax, 0
	js .open_src_fail
	mov r12, rax
	
	mov rax, 2
	mov rdi, rdx
	mov rsi, 1 + 64 + 512
	mov rdx, 0o644
	syscall
	
	cmp rax, 0
	js .open_dst_fail
	mov r13, rax
	
.copy_loop:
	mov rax, 0
	mov rdi, r12
	mov rsi, buffer
	mov rdx, BUF_SIZE
	syscall
	
	cmp rax, 0
	je .done_copy
	js .done_copy
	
	mov r14, rax
	
	mov rax, 1
	mov rdi, r13
	mov rsi, buffer
	mov rdx, r14
	syscall
	
	jmp .copy_loop
	
.done_copy:
	mov rax, 3
	mov rdi, r12
	syscall
	
	mov rax, 3
	mov rdi, r13
	syscall
	
	mov rax, 60
	xor rdi, rdi
	syscall
	
.print_usage_and_exit:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg_usage
	mov rdx, len_usage
	syscall
	
	mov rax, 60
	mov rdi, 1
	syscall
	
.open_src_fail:
	mov rax, 1
	mov rdi, 2
	mov rsi, msg_open_src_fail
	mov rdx, len_open_src_fail
	syscall
	
	mov rax, 60
	mov rdi, 2
	syscall
	
.open_dst_fail:
	cmp r12, 0
	jl .skip_close_src
	mov rax, 3
	mov rdi, r12
	syscall
	
.skip_close_src:
	mov rax, 1
	mov rdi, 2
	mov rsi, msg_open_dst_fail
	mov rdx, len_open_dst_fail
	syscall
	
	mov rax, 60
	mov rdi, 3
	syscall
