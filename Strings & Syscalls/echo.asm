global _start

section .rodata
    echo_msg db "Echo Message:", 0x0A
    echo_msg_len equ $ - echo_msg

section .text
_start:
    mov rbx, [rsp]          ; argc
    cmp rbx, 2              ; need at least 2 args
    jl .exit

    mov rsi, [rsp + 16]     ; argv[1] pointer

    ;---length of argv[1]---
    mov rdx, rsi
.find_end:
    cmp byte [rdx], 0
    je .got_len
    inc rdx
    jmp .find_end

.got_len:
    sub rdx, rsi            ; rdx = length
    mov r8, rsi             ; save pointer

    ; print prefix
    mov rax, 1              ; write
    mov rdi, 1              ; stdout
    mov rsi, echo_msg
    mov rdx, echo_msg_len
    syscall

    ; print argv[1]
    mov rax, 1
    mov rdi, 1
    mov rsi, r8
    ; rdx already has length
    syscall

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall
