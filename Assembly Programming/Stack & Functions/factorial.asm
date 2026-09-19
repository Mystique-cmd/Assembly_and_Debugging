global _start

section .data
    newline db 0x0A

section .bss
    buffer resb 32

section .text
_start:
    mov rcx, 5      ; n=5( the no we want the factorial of )
    mov rax, 1      ;accumulator = 1

.loop_start:
    mul rcx         ;rax=rax*rcx
    dec rcx
    jnz .loop_start

    lea rsi, [buffer + 31]
    mov rbx, rsi

    test rax, rax
    jz .write_zero

.convert:
    xor rdx, rdx
    mov rdi, 10
    div rdi
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
    ;---Print Results---
    mov rax, 1
    mov rdi, 1
    mov rsi, rbx
    mov rdx, buffer + 32
    sub rdx, rbx
    syscall

    ;---Print Newline---
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall