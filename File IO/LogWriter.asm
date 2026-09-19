global _Start
section .data
	filename : db "log.txt", 0
	logmsg : db "Log entry",10
	logmsq_len : equ $ - logmsg
section .text
_start:
	mov rax, 2
	mov rdi, filename
	mov rsi, 0x04101
	mov rdx, 0o644
	syscall
	mov r12, rax
	
	mov rax, 1
	mov rdi, r12
	mov rsi, logmsg
	mmov rdx, logmsg_len
	syscall
	
	mov rax, 3
	mov rdi, r12
	syscall
	
	mov rax, 60
	xor rdi, rdi
	syscall
