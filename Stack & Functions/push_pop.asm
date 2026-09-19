global _start

section .text:
_start:
    ;---Pushing values into the stack[rsp]---
    mov rax, 10
    push rax

    mov rbx, 20
    push rax

    mov rcx, 30
    push rcx

    ;---Popping values from the stack[rsp]---
    ;---The registers are where the values are popped into--
    pop rdx
    pop rsi
    pop rdi

    ;---Exit---
    mov rax, 60
    mov rdi, 0
    syscall