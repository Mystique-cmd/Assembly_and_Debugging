global _start

section .data
    prompt db "Enter Your Integer Array:",0x0A
    prompt_len equ $ - prompt

;each number is a byte each, thus this will store 10 bytes
    arr db " 0, 0, 0, 0, 0, 0, 0, 0, 0, 0", 0x0A

 section .bss
    stdin resb 32

section .text
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    mov rax, 0
    mov rdi, 0
    lea rsi, [rel stdin]
    mov rdx, 64
    syscall
    mov rcx, rax

    lea rsi, [rel stdin]    ;source
    lea rdi, [rel arr]      ;destination

.copy_loop:
    test rcx, rcx
    jz .done
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .copy_loop

.done:
    mov rax, 60
    xor rdi, rdi
    syscall

;writing the user input in the .data section is impossible at runtime the only way to go about it is
;to initialize an array in the .data section and fill it with the dummy values then overwrite it.