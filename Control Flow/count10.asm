global _start

section .data
    newline db 0x0A

section .bss
    buffer resb 32

section .text
_start:
      mov r12, 1 ; counter =1 (avoid RCX because syscall clobbers it)

.loop_start:
    ;---convert r12 to ascii string so that it would not display the binary---
    mov rax, r12

    ;--The reason for using the two steps into loading the buffer address to rbx is:
    ;--rsi is required for syscall
    ;--rbx is used as a scratch pointer
    lea rsi, [buffer + 31]
    mov rbx, rsi

    test rax, rax
    jz .write_zero

.convert:
;---After every division rax= quotient and rdx = remainder
    xor rdx, rdx
    mov rdi, 10
    div rdi
    add dl, '0'
    dec rbx
    mov [rbx], dl

    test rax, rax
    jnz .convert
    jmp .print

.write_zero:
    mov byte [rbx - 1], '0'
    dec rbx

.print:
    ;---Print Number---
    mov rax, 1
    mov rdi, 1
    mov rsi, rbx    ;pointer to string
    mov rdx, buffer +32
    sub rdx, rbx
    syscall

    ;---Print newline---
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx,1
    syscall

    ;---Increment Counter---
    inc r12
    cmp r12, 11     ;stop when r12 == 11
    jl .loop_start

.exit:
    mov rax, 60
    mov rdi, 0
    syscall
