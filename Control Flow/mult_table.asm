global _start

section .data
    space db " ", 0
    newline db 0x0A

section .bss
    buffer resb 32

section .text
_start:
    mov r8, 1       ;outer loop counter ( row = 1 )

.outer_loop:
    cmp r8, 6
    jge .exit

    mov r9, 1       ;inner loop counter (col = 1)

.inner_loop:
    cmp r9, 6
    jge .row_done

    ;---Product row * col---

    mov rax, r8
    mul r9

    ;---ascii conversion---
    ;the reason we are not loading rcx into rax is because the no we are trying to
        ;convert to ascii r8 is already in rax
     lea rsi, [buffer + 31]
     mov rbx, rsi

.convert:
    xor rdx, rdx
    mov rdi, 10
    div rdi
    add dl, '0'
    dec rbx
    mov [rbx], dl
    test rax, rax
    jnz .convert

    ;---Print Number---
    mov rax, 1
    mov rdi, 1
    mov rsi, rbx
    mov rdx, buffer + 32
    sub rdx, rbx
    syscall

    ;---Print Space
    mov rax, 1
    mov rdi, 1
    mov rsi,space
    mov rdx, 1
    syscall

    ;---Increment column--
    inc r9
    jmp .inner_loop

.row_done:
    ;---Print Newline at the end of the row---
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ;---Increment row--
    inc r8
    jmp .outer_loop

.exit:
    mov rax, 60
    xor rdi,rdi
    syscall