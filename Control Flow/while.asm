global _start

section .data
    newline db 0x0A

section .bss
    buffer resb 32

section .text
_start:
    mov rcx , 1     ; counter = 1

.while_check:
    cmp rcx, 6
    jge .exit

    ;--ascii conversion---
    mov rax, rcx        ; load current counter into RAX for conversion
    lea rsi, [buffer + 31]
    mov rbx, rsi

.convert:
    xor rdx, rdx
    mov rdi, 10
    div rdi
    add dl , '0'
    dec rbx
    mov [rbx], dl
    test rax, rax
    jnz .convert

    ;---Print Number---
    push rcx            ; preserve loop counter (syscalls clobber rcx)
    mov rax, 1
    mov rdi, 1
    mov rsi, rbx
    mov rdx , buffer + 32
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

    ;---Increment Counter--
    inc rcx
    jmp .while_check

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall
