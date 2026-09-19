global _start

section .data
    equal db "Strings are equal", 0x0A
    equal_len equ $ - equal

    not_equal db "The strings are not equal", 0x0A
    not_equal_len equ $ - not_equal

section .bss
    buffer1 resb 128
    buffer2 resb 128

section .text
_start:
    ;---Read the first string---
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer1
    mov rdx, 128
    syscall

    ;---Save the length in rcx1---
    mov r8, rax

    ;---Read the second string---
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer2
    mov rdx, 128
    syscall

    ;---Save the length in rcx2
    mov r9, rax

    ;---Setup pointers ---
    mov rbx, buffer1
    mov rdx, buffer2

.compare_loop:
    mov al, [rbx]
    mov bl, [rdx]

    cmp al, bl
    jz .equal       ; if the result is 0 ZF=0
    jg .not_equal   ;if SF=1
    jl .not_equal  ;if SF=0

    ;--Advanced Pointers---
    inc rbx
    inc rdx
    jmp .compare_loop

.equal:
    mov rax, 1
    mov rdi, 1
    mov rsi, equal
    mov rdx, equal_len
    syscall
    jmp .exit

.not_equal:
    mov rax, 1
    mov rdi, 1
    mov rsi, not_equal
    mov rdx, not_equal_len
    syscall
    jmp .exit

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall