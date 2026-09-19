global _start

section .data
    newline db 0x0A

section .bss
    buffer resb 32  ;space for number to string conversion

section .text
_start:
    mov rcx, 10         ; number of terms to print
    mov r12, 0          ; a = first term
    mov r13, 1          ; b = second term

.print_loop:
    ;---Convert current term (r12) to ASCII---
    mov rax, r12
    lea rbx, [buffer + 32]   ; rbx points one past the end

    test rax, rax
    jnz .convert
    ; handle zero
    mov byte [rbx - 1], '0'
    dec rbx
    jmp .print

.convert:
    xor rdx, rdx
    mov rdi, 10
    div rdi
    add dl, '0'
    dec rbx
    mov [rbx], dl
    test rax, rax
    jnz .convert

.print:
    ;---Print Number---
    push rcx                 ; preserve loop counter (syscall clobbers rcx)
    mov rax, 1
    mov rdi, 1
    mov rsi, rbx            ; pointer to string
    lea rdx, [buffer + 32]
    sub rdx, rbx            ; length
    syscall
    pop rcx

    ;---Print Newline---
    push rcx
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    pop rcx

    ;---Fibonacci update: (a,b) = (b, a+b)---
    mov rdx, r12            ; temp = a
    mov r12, r13            ; a = b
    add r13, rdx            ; b = b + temp

    loop .print_loop        ; rcx-- until 0

    ;---Exit---
    mov rax, 60
    xor rdi, rdi
    syscall