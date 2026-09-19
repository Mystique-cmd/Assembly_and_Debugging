global _start
section .data
	filename : db "input.txt",0
	
section .bss
	buffer : resb 4096
	count : resq 1
	num_buf resb 32
	nl db 10

section .text
_start:
	;---opening file in readonly mode
	mov rax, 2
	mov rdi, filename
	xor rsi, rsi
	syscall
	
	cmp rax, 0
	jl .exit_error
	
	mov r12, rax
	mov qword [count], 0
	
.read_loop:
	mov rax, 0
	mov rdi, r12
	mov rsi, buffer
	mov rdx, 4096
	syscall
	
	cmp rax, 0
	je .done_reading
	jl .exit_error
	
	mov rbx, [count]
	add rbx, rax
	mov [count], rax
	
	jmp .read_loop
	
.done_reading:
	mov rax, [count]
	mov rdi, rax
	call u64_to_string
	
	mov rax, 1
	mov rdi, 1
	syscall
	
	mov rax, 1
	mov rdi, 1
	mov rsi, nl
	mov rdx, 1
	syscall
	
	mov rax, 60
	xor rdi, rdi
	syscall

.exit_error:
	mov rax, 60
	mov rdi, 1
	syscall

u64_to_string:
	mov rcx, 0
	mov rbx, 10
	mov r8 , num_buf + 31
	mov byte[r8], 0
	dec r8
.convert_loop:
	xor rdx, rdx
	div rbx
	add dl , '0'
	mov [r8], dl
	dec r8
	inc rcx
	test rax, rax
	jnz .convert_loop
	
	inc r8
	mov rsi, r8
	mov rdx, rcx
	ret

	
		
	
