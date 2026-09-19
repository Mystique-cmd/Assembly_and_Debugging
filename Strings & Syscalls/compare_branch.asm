global _start

section .data
    msg_equal db " Numbers are equal", 0xA
    len_equal equ $ - msg_equal

    msg_less db " First number is less", 0xA
    len_less equ $ - msg_less

    msg_greater db " First number is greater", 0xA
    len_greater equ $ - msg_greater

section .text
_start:
    ;---Load Numbers---
    mov rax, 10
    mov rbx, 20

    ;---Compare---
    cmp rax, rbx
    je .equal
    jg .greater
    jl .less

.equal:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_equal
    mov rdx, len_equal
    syscall
    jmp .exit

.greater:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_greater
    mov rdx, len_greater
    syscall
    jmp .exit

.less:
   mov rax, 1
   mov rdi, 1
   mov rsi, msg_less
   mov rdx, len_less
   syscall
   jmp .exit

.exit:
    mov rax, 60
    mov rdi, 0
    syscall
