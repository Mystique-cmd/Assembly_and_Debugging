global _start

section .rodata
    array db "Reversed String", 0x0A
    array_len equ $ - array

section .bss
    stdout resb  1

section .text
_start:
    mov r8, array + array_len - 2 ; r8 now holds the address of the last char

.loop:
    mov al, [r8]        ; get the character
    mov [stdout], al    ; move it to the buffer
    call .print
    dec r8
    cmp r8, array
    jge .loop

    mov rax, 60
    xor rdi, rdi
    syscall

.print:
    mov rax, 1
    mov rdi, 1
    mov rsi, stdout
    mov rdx, 1
    syscall
    ret
