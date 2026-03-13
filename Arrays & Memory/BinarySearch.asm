global binary_search

section .text
binary_search:
	push rbp
	mov rbp, rsp
	
	;--rdi = arr
	;--rsi = n
	;--rdx = target
	
	mov r8, 0
	mov r9, rsi
	dec r9
	
.loop:
	cmp r8, r9
	jg .not_found 	;--if r8 is > r9
	
	;---Mid value
	mov rax, r8
	add rax, r9
	shr rax, 1	;--mid in rax
	
	;--Loading arr[mid]
	mov ecx, [rdi + rax * 4]
	
	cmp ecx, edx
	je .found
	jl .go_right
	
.go_left:
	dec rax
	mov r9, rax
	jmp .loop
	
.go_right:
	inc rax
	mov r8, rax
	jmp .loop
	
.found:
	mov eax, eax
	jmp .done
	
.not_found:
	mov eax, -1
	
.done:
	pop rbp
	ret
