global _start

section .data
    newline db 0x0A

section .bss
    buffer resb 32

section .text
_start:
    mov rcx, 1

.loop_start:
    cmp rcx, 21
    jge .exit

    ;---Check if rcx is even---
    mov rax, rcx
    test rax, 1     ; check evenness without modifying RAX
    jnz .skip_print

    ;---Convert to ascii---
    lea rsi , [buffer + 31]
    mov rbx, rsi

.convert:
    xor rdx, rdx
    mov rdi, 10
    div rdi
    add dl,'0'
    dec rbx
    mov [rbx],dl
    test rax, rax
    jnz .convert

    ;---Print Number--
    push rcx
    mov rax, 1
    mov rdi ,1
    mov rsi, rbx
    mov rdx, buffer + 32
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

.skip_print:
    inc rcx
    jmp .loop_start

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall
