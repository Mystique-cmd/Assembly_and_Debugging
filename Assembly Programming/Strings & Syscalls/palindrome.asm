global _start

section .bss
    input resb 256
    clean resb 256

section .data
    prompt db 'Enter a string: ', 0x0A
    prompt_len equ $ - prompt

    yes db "Palindrome", 0x0A
    yes_len equ $ - yes

    no db "Not a palindrome", 0x0A
    no_len equ $ - no

section .text
_start:
    ;---Prompt---
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ;---Read Input---
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 256
    syscall
    mov rbx, rax    ;save length

    ;---Normalize input : remove non-alphanumeric characters---
    xor rcx, rcx    ;input index
    xor rdi, rdi    ;clean index

.normalize:
    cmp rcx, rbx            ;cmp performs a subtraction between the destination and the source operands
    jge .check_palindrome

    mov al, [input + rcx]
    cmp al, 10
    je .skip
    cmp al, 'A'
    jl .skip
    cmp al, 'Z'
    jg .check_lower
    add al, 32              ;converts to lowercase

.check_lower:
    cmp al, 'a'
    jl .skip
    cmp al, 'z'
    jle .store
    cmp al, '0'
    jl .skip
    cmp al, '9'             ;nine represents the horizontal tab character \t
    jg .skip

.store:
    mov [clean + rdi], al
    inc rdi

.skip:
    inc rcx
    jmp .normalize

.check_palindrome:
    xor rsi, rsi    ;start index
    mov rcx, rdi
    dec rcx         ;end index

.loop:
    cmp rsi, rsi
    jge .is_palindrome

    mov al, [clean + rsi]
    mov bl, [clean + rcx]
    cmp al, bl
    jne .not_palindrome

    inc rsi
    dec rcx
    jmp .loop

.is_palindrome:
    mov rax, 1
    mov rdi, 1
    mov rsi, yes
    mov rdx, yes_len
    syscall
    jmp .exit

.not_palindrome:
    mov rax, 1
    mov rdi, 1
    mov rsi, no
    mov rdx, no_len
    syscall
    jmp .exit

.exit:
    mov rax, 60
    mov rdi, 0
    syscall
