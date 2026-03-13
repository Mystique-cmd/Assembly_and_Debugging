%define SYS_READ 0
%define SYS_WRITE 1
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define SYS_LSEEK 8
%define SYS_EXIT 60

%define O_RDONLY 0 
%define O_WRONLY 1
%define O_RDWR 2
%define O_CREAT 64
%define O_TRUNC 512

section .bss
	buffer : resb 65536
	buflen : equ 65536
	
section .data
	err_args: db "Usage ./replace <file> <old> <new>", 10
	err_args_len: equ $ - err_args
section .text
global _start
_start:
	mov rdi, [rsp]
	cmp rdi, 4
	jne bad_args
	
	mov rsi, [rsp+16}
	mov rdx, [rsp+24]
	mov rcx, [rsp+32]
	
	mov [filename], rsi
	mov [oldword], rdx
	mov[newword], rcx
	
	mov rax, SYS_OPEN
	mov rdi, [filename]
	mov rsi, O_RDWR
	mov rdx, 0
	syscall
	mov r12, rax
	
	mov rax, SYS_READ
	mov rdi, r12
	mov rsi, buffer
	mov rdx, buflen
	syscall
	mov r13, rax
	
	mov rdi, buffer
	mov rsi, r13
	mov rdx, [oldword]
	mov rcx, [newword]
	call replace_word
	
	mov rax, SYS_LSEEK
	mov rdi, r12
	xor rsi, rsi
	xor rdx,rdx
	syscall
	
	mov rax, SYS_WRITE
	mov rdi, r12
	mov rsi, buffer
	mov rdx, rax
	syscall
	
	mov rax, SYS_CLOSE
	mov rdi, r12
	syscall
	
	mov rax, SYS_EXIT
	xor rdi, rdi
	syscall
bad_args:
	mov rax, SYS_WRITE
	mov rdi, 1
	mov rsi, err_args
	mov rdx, err_args_len
	syscall
	
	mov rax, SYS_EXIT
	mov rdi, 1
	syscall
replace_word:
	push rbp
	mov rbp, rsp
	
	mov r8, rdi
	mov r9, rsi
	mov r10, rdx
	mov r11, rcx
	
	call strlen_old
	mov r14, rax
	
	call strlen_new
	mov r15, rax
	
	xor rbx, rbx
.loop:
	cmp rbx, r9
	jge .done
	
	mov rdi, r8
	add rdi, rbx
	mov rsi, r10
	mov rdx, r14
	call memcmp
	cmp rax, 0
	jne .next
	
	mov rdi, r8
	add rdi, rbx
	mov rsi, r11
	mov rdx, r15
	call memcmp
	
	add rbx, r15
	jmp .loop
.next:
	inc rbx
	jmp .loop
.done:
	mov rax, r9
	pop rbp
	ret
strlen_common:
	xor rax, rax
.lenloop:
	cmp byte[rdi+rax],0
	je .end
	inc rax
	jmp .lenloop
.end:
	ret
memcmp:
	xor rax, rax
.cmp_loop:
	cmp rdx, 0
	je .equal
	mov bl, [rdi]
	mov cl, [rsi]
	cmp bl, cl
	jne .notequal
	inc rdi
	inc rsi
	dec rdx
	jmp .cmp_loop
.equal:
	xor rax, rax
	ret
.notequal:
	mov rax, 1
	ret
memcpy:
	cmp rdx, 0
	je .done
.copy_loop:
	mov al, [rsi]
	mov [rdi], al
	inc rdi
	inc rsi
	dec rdx
	jnz .copy_loop
.done:
	ret
section .bss
filename: resq 1
oldword: resq 1
newword : resq 1
