global _start

section .text
_start:
	push rbx
	push r12
	push r13
	push r14
	
	mov rbx, 0
	
	cmp rsi, 1
	jle .end_sort_no_ops
	
.outer_loop_start:
	mov r14, rsi
	dec r14
	cmp rbx, r14
	jge .end_sort
	mov r13, rbx
	mov r12, rbx
	inc r12

.inner_loop_start:
	cmp r12, rsi
	jge .inner_loop_end
	mov rax, [rdi + r12 * 8]
	mov rdx, [rdi + r13 * 8]
	cmp rax, rdx
	jge .no_new_min
	mov r13, r12

.no_new_min:
	inc r12
	jmp .inner_loop_start

.inner_loop_end:
	cmp r13, rbx
	je .skip_swap
	
	mov rax, [rdi + rbx * 8]
	mov rdx, [rdi + r13 * 8]
	mov [rdi + rbx * 8], rdx
	mov [rdi + r13 * 8], rax
	
.skip_swap:
	inc rbx
	jmp .outer_loop_start
	
.end_sort_no_ops:

.end_sort:
	pop r14
	pop r13
	pop r12
	pop rbx
	ret
	
