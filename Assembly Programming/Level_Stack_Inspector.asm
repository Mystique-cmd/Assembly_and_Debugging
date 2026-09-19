section .data
    msg db "Enter a number:", 0
    newline db 10, 0

section .bss
    input resb 4

section .text
    global _start

_start:
    ; Print prompt
    mov eax, 4  ;syscall: write
    mov ebx, 1  ;stdout
    mov ecx, msg
    mov edx, 15
    int 0x80

    ;Read input
    mov eax, 3  ;syscall: Read
    mov ebx, 0  ;stdin
    mov ecx, input
    mov edx, 4
    int 0x80

    ;Push input onto stack
    mov eax, [input]
    push eax

    ;Manipulate value
    pop ebx
    add ebx, 5
    push ebx

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Print input (raw)
    mov eax, 4
    mov ebx, 1
    mov ecx, input
    mov edx, 4
    int 0x80

    ;Exit 
    mov eax, 1
    xor ebx, ebx
    int 0x80