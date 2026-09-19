global _start

section .bss
    buffer resb 64

section .text
_start:
    ;---Input---
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 64
    syscall

    mov r8, rax         ; save the length safely (won't be clobbered by dl)
    mov rbx, rax        ; save the length in rbx for high index initialization

    ;---Reverse Loop---
    dec rbx         ;last index = length - 1
    xor rcx, rcx    ;rcx = start index = 0

.reverse_loop:
    cmp rcx, rbx
    jge .done_reverse

    ;---swap buffer[rcx] and buffer[rbx]
    mov al , [buffer + rcx]
    mov dl , [buffer + rbx]
    mov [buffer + rcx], dl
    mov [buffer + rbx], al

    inc rcx
    dec rbx
    jmp .reverse_loop

.done_reverse:
    ;---Write output---
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, r8         ; use saved input length
    syscall

    ;---exit---
    mov rax, 60
    mov rdi, 0
    syscall
