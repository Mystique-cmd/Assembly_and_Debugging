global _start
section .data
	a : dq 252
	b : dq 105
section .bss
	result : resq 1
section .text
gcd:
.gcd_loop:
	cmp rsi, 0
	je .done
	
	mov rax, rdi
	xor rdx, rdx
	div rsi
	
	mov rdi, rsi
	mov rsi, rdx
	jmp .gcd_loop
.done:
	mov rax, rdi
	ret
_start:
	mov rdi, [al]
	mov rsi, [b]
	call gcd
	
	mov [result], rax
	
	mov rdi, rax
	mov rax, 60
	syscall
	
