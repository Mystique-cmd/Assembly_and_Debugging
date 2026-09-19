section .text
    global _start

_start:
    mov eax, 4  ;syscall: write
    mov ebx, 1  ;stdout
    mov ecx, message    ;pointer to message
    mov edx, msg_len    ;message lenght
    int 0x80            ;call kernel

    mov eax, 1          ;syscall: exit
    xor ebx, ebx        ;status 0
    int 0x80

section .data
message db "Hello from shellcode!", 0xA
msg_len equ $ - message