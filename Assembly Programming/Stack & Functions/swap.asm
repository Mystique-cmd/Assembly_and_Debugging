global _start

section .text
_start:
    ;---Initialize the registers---
    mov rax, 123
    mov rbx, 456

    ;--Swap using temporary register---
    mov rcx, rax
    mov rax, rbx
    mov rbx, rcx

    ;--Exit cleanly---
    mov rax, 60
    mov rdi, 0
    syscall