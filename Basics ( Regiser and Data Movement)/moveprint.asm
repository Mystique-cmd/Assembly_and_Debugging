section .data
    newline db 0x0A

section .bss
    char resb 1     ;reserve 1 byte for storing character

section .text
    global _start

_start:
    ;----move constant into registers---
    mov rax, 65     ;ASCII 'A'
    mov rbx, 66     ;ASCII 'B'
    mov rcx, 67     ;ASCII 'C'

    ;---print 'A'---
    mov [char], al      ;store low 8 bits of RAX into memory
    mov rax, 1
    mov rdi, 1      ;stdout
    mov rsi, char   ;buffer address
    mov rdx, 1      ;length
    syscall

    ;---print 'B'---
    mov [char], bl      ;store 8 bits of RBX
    mov rax, 1
    mov rdi, 1
    mov rsi, char
    mov rdx, 1
    syscall

    ;---print 'C'---
    mov [char], cl      ;store 8 bits of RCX
    mov rax, 1
    mov rdi, 1
    mov rsi, char
    mov rdx, 1
    syscall

    ;---print newline---
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ;---Exit Program---
    mov rax, 60
    xor rdi, rdi
    syscall
