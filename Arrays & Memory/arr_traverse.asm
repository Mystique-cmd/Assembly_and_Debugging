global _start

section .rodata
    prompt db " Enter your array values:",0x0A
    prompt_len equ $ - prompt

    no_args db "No values entered!!",0x0A
    no_args_len equ $ - no_args

section .bss
    array resb 64
    stdout resb 64

section .text
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, array
    mov rdx, 64
    syscall

    mov rsi, array      ; Use rsi as a pointer to the array

.loop:
    mov al, [rsi]       ; Load the byte (character) from the current array position
    cmp al, 0x0A        ; Compare with newline, which indicates end of input
    je .exit           ; If it's a newline, exit the loop

    mov [stdout], al    ; Move the character to our buffer for printing
    call .print         ; Call the print function
    inc rsi             ; Increment the pointer to the next character
    jmp .loop           ; Repeat the loop

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall

.done:
    mov rax, 1
    mov rdi, 1
    mov rsi, no_args
    mov rdx, no_args_len
    syscall
    jmp .exit

.print:
    mov rax, 1
    mov rdi, 1
    mov rdx, 1      ;here we using one so that it prints only one character per call
    syscall
    ret

