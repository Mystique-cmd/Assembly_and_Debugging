global _start

section .data
    msg db "Final Counter: ", 0x0A
    msg_len equ $ - msg

section .bss
    buffer resb 32

section .text
_start:
    ;---Initialize counter---
    xor rax, rax    ; counter = 0

    ;---Increment x5---
    mov rcx, 5
;Its not necessary to jump to the  label it would be executed sequentially with the program
.inc_loop:
    inc rax
    loop .inc_loop

    ;---Decrement x3---
    mov rcx, 3

.dec_loop:
    dec rax
    loop .dec_loop

    ;---Convert counter to ASCII---
    ; Build number into buffer from the end
    lea rbx, [buffer + 32]

    test rax, rax
    jz .write_zero

.convert:
    xor rdx, rdx             ; clear high part for div
    mov rdi, 10
    div rdi                  ; RAX = RAX/10, RDX = RAX%10
    add dl, '0'
    dec rbx
    mov [rbx], dl
    test rax, rax
    jnz .convert
    jmp .print

.write_zero:
    mov byte [rbx - 1], '0'
    dec rbx

.print:
    ;---Print Prefix---
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    ;---Print Counter---
    mov rax, 1
    mov rdi, 1
    mov rsi, rbx
    lea rdx, [buffer + 32]
    sub rdx, rbx
    syscall

    ;---Exit---
    mov rax, 60
    mov rdi, 0
    syscall