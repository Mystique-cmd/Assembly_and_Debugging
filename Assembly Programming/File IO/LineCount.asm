section .data
	filename db "input.txt",0
	newline db 10
	msg db "Number of lines",0
	msg_len equ $ - msg
	bufsize equ 1024
section .bss
	buffer resb bufsize
	count resq 1
section .text
global _start
_start:
	mov rax, 2
	mov rdi, filename
	mov rsi, 0
	syscall
	mov r12, rax
	
	xor rbx, rbx
.read_loop:
	mov rax, 0
	mov rdi, r12
	mov rsi, buffer
	mov rdx, bufsize
	syscall
	cmp rax, 0
	je .done
	
	mov rcx, rax
	mov rsi, buffer
.scan_buff:
	cmp rcx, 0
	je .read_loop
	mov al , [rsi]
	cmp al, newline
	je .next_char
	inc rbx
.next_char:
	inc rsi
	dec rcx
	jmp .scan_buff
.done:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg
	mov rdx, msg_len
	syscall
	
	mov rax, rbx
	call pring_number
	
	mov rax, 60
	xor rdi, rdi
	syscall
print_number:
	mov rcx, 10
	lea rsi, [buffer + bufsize ]
.convert:
	xor rdx, rdx
	div rcx
	dec rsi
	add dl ,'0'
	mov [rsi], sl
	test rax, rax
	jnz .convert
	
	mov rax, 1
	mov rdi, 1
	mov rdx, buffer + bufsize -rsi
	syscall
	ret
