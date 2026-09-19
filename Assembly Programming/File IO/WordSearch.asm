global _start
section .data
	found_msg: db "FOUND", 0
	found_en equ $ - found_msg
	
	notfound_msg: db "NOT FOUND ", 0
	notfound_len equ $ - notfound_msg
	
	buffer_size equ 4096
section .bss
	buffer : resb buffer_size
section .text
_start:
	mov rbx, rsi
	cmp rdi, 2
	jl print_notfound_exit
	
	mov rdi, [rbx + 8]
	mov rsi, 0
	mov rax, 2
	syscall
	cmp rax, 0
	jl print_notfound_exit
	mov r12, rax
	mov r13, [rbx + 16]
	mov rdi, r13
	call strlen
	mov r14, rax
read_loop:
	mov rdi, r12
	mov rsi, buffer
	mov rdx, buffer_size
	mov rax, 0
	syscall
	
	cmp rax, 0
	jle not_found
	
	mov rdi, buffer
	mov rsi, r13
	mov rdx, rax
	mov rcx, r14
	call find_substring
	cmp rax, 1
	je found
	
	jmp read_loop
found:
	mov rdi, 1
	mov rsi, found_msg
	mov rdx, found_len
	mov rax, 1
	syscall
	jmp exit
not_found:
print_notfound_exit:
	mov rdi, 1
	mov rsi, notfound_msg
	mov rdx, notfound_len
	mov rax, 1
	syscall
	jmp exit
exit:
	mov rax, 60
	xor rdi, rdi
strlen:
	mov rax, 0
.str_loop:
	cmp byte[rdi +rax], 0
	je .done
	inc rax
	jmp .str_loop
.done:
	ret
find_substring:
	mov r8, rdi
	mov r9, rsi
	mov r10, rdx
	mov r11, rcx
	
	cmp r11, o
	je .notfound
	
	sub r10, r11
	jl .notfound
.outer:
	mov rax, r11
	mov rdi, r8
	mov rsi, r9
.inner:
	mov bl , [rdi]
	cmp bl, [rsi]
	jne .next
	inc rdi
	inc rsi
	dec rax
	jnz .inner
	
	mov rax, 1
	ret
.next:
	inc r8
	mov rsi, r9
	cmp r8, buffer + buffer_size
	jae .notfound
	dec r10
	jge .outer
.notfound:
	xor rax, rax
	ret	
