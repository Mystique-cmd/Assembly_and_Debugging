global _start

section .data
    string db "The string from the data section", 0xA
    len equ $ - string

section .text
_start:
    ;---Print the string---
    mov rax, 1          ; sys_write
    mov rdi, 1          ; fd = stdout
    mov rsi, string     ; buf
    mov rdx, len        ; count = length of string
    syscall

    ;---Exit---
    mov rax, 60         ; sys_exit
    mov rdi, 0
    syscall