global _start

section .data
    prefix db "Quotient: ", 0x0A
    prefix_len equ $ - prefix

section .bss
    buffer resb 32

section .text
_start:
    ;---Inputs---
    mov rax, 12
    mov rbx, 6
    xor rdx, rdx        ; clear high part before 64-bit division

    ;---Divide--
    div rbx     ;similar to mul you do not write both the operands ( registers )

    ;---Conversion---
    lea r8, [buffer + 31]   ;pointing to the end of the buffer

    cmp rax, 0
    jne .convert_loop
    mov byte [r8], '0'
    dec r8
    jmp .converted

.convert_loop:
    xor rdx, rdx                ; clear high part for div
    mov rcx, 10
    div rcx                     ; rax = rax / 10, rdx = remainder
    add dl, '0'                 ; remainder -> ASCII digit
    mov byte [r8], dl
    dec r8
    test rax, rax               ; stop when quotient becomes 0
    jne .convert_loop

.converted:
    ;---Write Prefix---
    mov rax, 1
    mov rdi, 1
    mov rsi, prefix
    mov rdx, prefix_len
    syscall

    ;---Write Quotient---
    lea rsi, [r8 + 1]   ;points to the first digit
    lea rdx, [buffer + 31]  ;points to the end of the buffer
    sub rdx,r8  ;length of buffer
    mov rax,1
    mov rdi,1
    syscall

    ;---Exit---
    mov rax, 60
    mov rdi, 0
    syscall