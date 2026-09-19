global _start

section .data
    newline db 0x0A

section .bss
    buffer resb 32

section .text
_start:
    xor rax, rax        ;rax=0 ( accumulator for sum )
    mov rcx, 1

.loop_start:
    add rax, rcx        ;sum += rcx
    inc rcx
    cmp rcx, 101
    jl .loop_start

    ;---Convert to ASCII---
    lea rsi, [buffer + 31 ]
    mov rbx, rsi
    test rax, rax   ;performs bitwise AND
    jz .write_zero

.convert:
    xor rdx,rdx
    mov rdi, 10
    div rdi
    add dl, '0'
    dec rbx
    mov [rbx], dl
    test rax, rax
    jnz .convert
    jmp .print

.write_zero:
    mov byte [rbx - 1 ], '0'
    dec rbx

.print:
    ;---Print Result---
    mov rax, 1
    mov rdi, 1
    mov rsi, rbx    ;pointer to string
    mov rdx, buffer +32
    sub rdx, rbx
    syscall

    ;---Print Newline---
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx,1
    syscall

.exit:
    mov rax, 60
    xor rdi, rdi    ;an alternative of making the rdi status to 0
    syscall