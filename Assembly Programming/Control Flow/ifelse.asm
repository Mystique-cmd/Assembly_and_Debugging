global _start

section .data
    msg_if db "First is greater", 0x0A
    len_if equ $ - msg_if

    msg_else db "Second is greater", 0x0A
    len_else equ $ - msg_else

section .text
_start:
    ;---Load numbers---
    mov rax, 15
    mov rbx, 20

    ;---Compare---
    cmp rax, rbx
    jg .if_block

.else_block:
    mov rax, 1
    mov rdi,1
    mov rsi, msg_else
    mov rdx, len_else
    syscall
    jmp .exit

.if_block:
    mov rax, 1
    mov rdi,1
    mov rsi, msg_if
    mov rdx, len_if
    syscall
    jmp .exit

.exit:
    mov rax, 60
    mov rdi, 0
    syscall