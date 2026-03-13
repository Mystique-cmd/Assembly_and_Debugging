global _start

section .data
    msg db "Stored Value: ", 0x0A
    msg_len equ $ - msg

section .bss
    storage resq 1  ;reserve 8 bytes ( 1 quadword )
     buffer resb 32

section .text
_start:
    ;---Store Value---
    mov rax, 12345
    mov [storage], rax  ;store into memory

    ;---Load Value---
    mov rax, [storage]  ;load from memory

    ;---Convert to ASCII---
    lea r8, [buffer + 31]  ; pointer to the end of buffer

    cmp rax, 0
    jne .convert
    mov byte [r8], '0'
    dec r8
    jmp .print

.convert:
    xor rdx, rdx
    mov rdi, 10
    div rdi                    ; RAX = RAX / 10, RDX = RAX % 10
    add dl, '0'
    mov [r8], dl
    dec r8
    test rax, rax
    jnz .convert

.print:
    ;---Print Prefix---
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    ;---Print Value---
    lea rsi, [r8 + 1]
    lea rdx, [buffer + 31]
    sub rdx,r8
    mov rax, 1
    mov rdi, 1
    syscall

    ;---Exit---
    mov rax, 60
    mov rdi, 0
    syscall
