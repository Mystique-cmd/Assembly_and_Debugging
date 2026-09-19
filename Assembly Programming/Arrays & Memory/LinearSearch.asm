global linear_search
section .text
linear_search:
	push rbp
	mov rbp, rsp
	
	xor eax, eax 		;--i = 0
	
.loop:
	cmp rax, rsi		;--i>=n
	jge .not_found
	
	mov ecx, [rdi + rax*4]		;--ecx=arr[i]
	cmp ecx, edx			;--arr[i] == target?
	je .found
	
	inc rax
	jmp .loop
	
.found:
	mov eax, eax
	jmp .done
	
.not_found:
	mov eax, -1
	
.done:
	pop rbp
	re
