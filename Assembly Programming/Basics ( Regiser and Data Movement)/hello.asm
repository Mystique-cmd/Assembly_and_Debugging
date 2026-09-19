section .data
    msg db "Hello, World!", 0x0A    ;our string with newline
    len equ $ - msg                 ;length of the string

section .text
    global _start                   ;entry point

_start:
    ; write(fd=1, buf=msg, count=len)
    mov rax, 1  ;syscall number for write
    mov rdi, 1  ;file descriptor 1 = stdout
    mov rsi, msg    ;pointer to string
    mov rdx, len    ;length of the string
    syscall

    ;exit(status=0)
    mov rax, 60     ;syscall for exit
    xor rdi, rdi    ;status=0
    syscall