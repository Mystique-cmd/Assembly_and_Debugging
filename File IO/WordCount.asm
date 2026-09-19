global _start
section .data	
	buffsize equ 4096
	filename db 0
	buffer times bufsize db 0
section .bss
	word_count resq 1
	in_word resb 1
section .text
_start:
	mov rdi , [rsp + 16]
	test rdi, rdi
	jz no_file
	mov [filename], rdi
	
	mov rax, 2
	mov rdi, [filename]
	xor rsi, rsi
	syscall
	jl no_file
	mov r12, rax
	
	xor rbx, rbx
	mov [word_count], rbx
	mov byte[in_word]. 0
read_loop:
	mov rax, 0
	mov rdi, r2
	mov rsi, buffer
	mov rdx, bufsize
	syscall
	
	cmp rax, 0
	je done_reading
	jl done_reading
	
	mov rcx, rax
	mov rsi, buffer
process_chunk:
	cmp rcx, rax
	je read_loop
	mov al, [rsi]
	
	cmp al, ' '
	je ws
	cmp al, 10
	je ws
	cmp al, 9
	je ws
	
	cmp byte[in_word], 1
	je cont
	mov byte[in_word], 1
	inc qword[word_count]
	jmp cont
ws:
	mov byte[in_word] 0
cont:	
	inc rsi
	dec rcx
	jmp process_chunk
done_reading:
	mov rax, 3
	mov rdi, r12
	syscall
	
	mov rax, [word_count]
	call print_number
	call print_newline
	
	mov rax, 60
	mov rdi, 1
	syscall
print_number:
	mov rbx, 10
	lea rdi, [rsp-32]
	mov rsi, rdi
.convert:
	xor rdx, rdx
	div rbx
	add dl  '0'
	dec rsi
	mov [rsi], dl
	test rax, rax
	jnz .convert
	
	mov rdx, rdi
	sub rdx, rsi
	mov rax, 1
	mov rdi, 1
	mov rdx, rdx
	mov rsi, rsi
	syscall
	ret
print_newline:
	mov rax, 1
	mov rdi , 1
	mov rsi, nl
	mov rdx, 1
	syscall
	ret
section .data
nl : db 10
	
