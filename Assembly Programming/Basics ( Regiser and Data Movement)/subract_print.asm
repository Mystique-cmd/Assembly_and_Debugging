global _start

section .data
    msg_prefix db "Result: ", 0x0A
    msg_prefix_len equ $ - msg_prefix

section .bss
    result_buffer resb 64

section .text
_start:
    ;---Inputs---
    mov rax, 40
    mov rbx, 10

    ;---Subtraction---
    sub rax, rbx

    ;---Conversion---
    lea r9, [result_buffer + 63] ; end of buffer

    cmp rax, 0
    jne .convert_loop
    mov byte [r9], '0'
    dec r9
    jmp .converted

.convert_loop:
    xor rdx, rdx
    mov rdi, 10  ;using 10 because we are changing to decimal which is base 10
    div rdi
    add dl, '0' ;converts to ASCII
    mov byte [r9], dl
    dec r9
    test rax, rax
    jnz .convert_loop

.converted:
    ;---Write Prefix ---
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_prefix
    mov rdx, msg_prefix_len
    syscall

    ;---Write Results---
    lea rsi, [r9 + 1]
    mov rdx, result_buffer
    sub rdx, 63
    dec rdx

    mov rax,1
    mov rdi,1
    syscall

    ;---Exit---
    mov rax, 60
    mov rdi, rdi
    syscall