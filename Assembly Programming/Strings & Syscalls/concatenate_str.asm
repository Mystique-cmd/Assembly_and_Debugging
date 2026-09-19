global _start

section .bss
    string1 resb 128
    string2 resb 128
    results resb 256

section .data
    prompt1 db "Enter the first string: ", 0x0a
    prompt1_len equ $ - prompt1

    prompt2 db "Enter the second string: ", 0x0a
    prompt2_len equ $ - prompt2

    msg db "The result is: ", 0x0a
    msg_len equ $ - msg

section .text
_start:
    ;---Print the prompts---
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt1
    mov rdx, prompt1_len
    syscall

    ;---Read the first string---
    mov rax, 0
    mov rdi, 0
    mov rsi, string1
    mov rdx, 128
    syscall
    mov rcx, rax

    ;---Strip the newline---
    dec rcx
    mov byte [ string1 + rcx ], 0

    ;---Print the prompts---
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt2
    mov rdx, prompt2_len
    syscall

    ;---Read the second string---
    mov rax, 0
    mov rdi, 0
    mov rsi, string2
    mov rdx, 128
    syscall
    mov rcx, rax

    ;---Strip the newline---
    dec rcx
    mov byte [ string2 + rcx ], 0

    ;---Copy the strings---
    mov rsi, string1
    mov rdi, results

.copy1:
    lodsb
    stosb
    test al, al
    jnz .copy1
    dec rdi
    mov rsi, string2

.copy2:
    lodsb
    stosb
    test al, al
    jnz .copy2

    ;---Print the prompt---
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    ;---Print the result---
    mov rax, 1
    mov rdi, 1
    mov rsi, results
    mov rdx, 256
    syscall

    ;---Exit---
    mov rax, 60
    mov rdi, 0
    syscall
