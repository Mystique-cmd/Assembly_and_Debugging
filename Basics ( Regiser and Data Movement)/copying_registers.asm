section .text
    global _start

_start:
    ;initialize registers
    mov rax, 42
    mov rbx, rax
    mov rcx, rbx
    mov rdx, rcx

    ;exit syscall ( Linux )
    mov rax, 60
    xor rdi, rdi
    syscall