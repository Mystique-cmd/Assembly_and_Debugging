global _start

section .data
    newline db 0x0A

section .bss
    buffer resb 32

section .text
_start:
    mov rcx, 1

.do_body:
    ;---ascii conversion---
    mov rax, rcx
    lea rsi, [buffer + 31]
    mov rbx, rsi

.convert:
    xor rdx, rdx
    mov rdi, 10
    div rdi
    add dl, '0'
    dec rbx
    mov [rbx], dl
    test rax, rax
    jnz .convert

    ;---Print Number---
    push rcx
    mov rax, 1
    mov rdi, 1
    mov rsi, rbx
    mov rdx, buffer + 32
    sub rdx, rbx
    syscall
    pop rcx

    ;---Print Newline---
    push rcx
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    pop rcx

    ;---Increment Counter---
    inc rcx

    ;---Condition check at the end---
    cmp rcx, 6
    jl .do_body

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall
