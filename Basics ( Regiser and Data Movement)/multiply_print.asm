global _start

section .data
    msg_prefix db "Product: ", 0x0A
    msg_prefix_len equ $ - msg_prefix

section .bss
    buffer resb 32

section .text
_start:
    ;---Inputs---
    mov rax, 4
    mov rbx, 6

    ;--Multiply---
    ;mul is for signed operation whereas imul is for unsigned
    mul  rbx    ;in multiplication you do not write the rax register

    ;---Conversions---
    lea r8, [buffer + 31 ]  ;points to the end of the buffer

    cmp rax, 0
    jne .convert_loop
    mov byte [r8], '0'
    dec r8
    jmp .converted

.convert_loop:
    xor rdx, rdx        ; clear remainder
    mov rdi, 10         ; divisor
    div rdi             ; rax / rdi → quotient in rax, remainder in rdx
    add dl, '0'         ; convert to ASCII
    mov [r8], dl
    dec r8
    test rax, rax
   jnz .convert_loop

.converted:
    ;---Write Prefix---
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_prefix
    mov rdx, msg_prefix_len
    syscall

    ;---Write Results---
    lea rsi, [r8+1]          ; pointer to first digit
    lea rdx, [buffer + 31]   ; end of buffer
    sub rdx, r8              ; length = (buffer+31) - r8
    mov rax, 1               ; write syscall
    mov rdi, 1               ; stdout
    syscall

    ;---Exit---
    mov rax, 60
    mov rdi, 0
    syscall
