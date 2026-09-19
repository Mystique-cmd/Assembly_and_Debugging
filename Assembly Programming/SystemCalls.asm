section .data		;data segment
	userMsg db 'Please enter a number:', 	;Ask the user to enter a number
	lenUserMsg equ $ - userMsg	;the length of the message
	
	dispMsg db 'You have entered:'
	lenDispMsg equ $ - dispMsg

section .bss		;unitialized data
	num resb 5
	
section .text		;code segment
	global _start

_start:	;user prompt
	mov eax, 4
	mov ebx, 1
	mov ecx, userMsg
	mov edx, lenUserMsg
	int 80h
	
	;Read and store user input
	mov eax, 3
	mov ebx, 2
	mov ecx, num
	mov edx, 5
	int 80h
	
	;Output the message 'The entered no is '
	mov eax, 4
	mov ebx, 1
	mov ecx, dispMsg
	mov edx, lenDispMsg
	int 80h
	
	;Output the no entered
	mov eax, 4
	mov ebx, 1
	mov ecx, num
	mov edx, 5
	int 80h
	
	;exit code
	mov eax, 1
	mov ebx, 0
	int 80h
