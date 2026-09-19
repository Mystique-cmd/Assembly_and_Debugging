global _start

section .bss
    buffer resb 64

section .text
_start:
    ;sys_read ( #write )
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 64
    syscall

    ;rax has no of bytes read
    ;---Write back to stdout---
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, rax        ;this makes the rdx be the no of bytes that have been input into rax
    syscall

    ;--Exit---
    mov rax, 60
    mov rdi, 0
    syscall