global _start

section .text
_start:
    ;---Moving to stack---
    mov rax, 10
    push rax

    mov rbx, 20
    push rbx

    ;---Swaping the stacks---
    pop rax             ;rax=20
    pop rbx             ;rbx=10

    ;---Push back---
    push rax
    push rbx

    ;---Exit---
    mov rax, 60
    mov rdi, 0
    syscall