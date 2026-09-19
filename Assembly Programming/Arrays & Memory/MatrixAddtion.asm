global mat_add
section .text
mat_add:
	push rbp
	mov rbp, rsp
	
	xor r9,r9
.outer_loop:
	cmp r9,rcx
	jge .done
	
	xor r10, r10
	
.inner_loop:
	cmp r10, r8
	jge .next_row
	
	mov r11, r9
	imul r11, r8
	add r11, r10
	
	shl r11, 2
	
	mov eax, [rdi + 11]
	mov edx, [rsi + r11]
	
	add eax, edx
	
	mov [rdx + 11], eax
	
	inc r10
	jmp .inner_loop
.next_row:
	inc r9
	jmp .outer_loop
	
.done:
	mov rsp, rbp
	pop rbp
	ret
