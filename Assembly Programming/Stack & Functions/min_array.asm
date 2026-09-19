global _start

section .data
    stNo db "First No.:",0x0a
    stNo_len equ $ - stNo

    ndNo db "Second No.:",0x0a
    ndNo_len equ $ - ndNo

    rdNo db "Third No.:",0x0a
    rdNo_len equ $ - rdNo

    min_no db "Minimum No.:"
    min_no_len equ $ - min_no

section .bss    
    fn resb 64
    sn resb 64
    tn resb 64
    res resb 64

section .text
_start:
    ;---Getting the array values---
    mov rax, 1
    mov rdi, 1
    mov rsi, stNo
    mov rdx, stNo_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, fn
    mov rdx, 64
    syscall
    call atoi
    mov r12, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, ndNo
    mov rdx, ndNo_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, sn
    mov rdx, 64
    syscall
    call atoi
    mov r13, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, rdNo
    mov rdx, rdNo_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, tn
    mov rdx, 64
    syscall
    call atoi
    mov r14, rax

    ;---Computing the Minimum No.---
    mov r15, r12
    cmp r13, r15
    cmovl r15, r13
    cmp r14, r15
    cmovl r15, r14

    ;---Printing the minimum No---
    mov rax, 1
    mov rdi, 1
    mov rsi, min_no
    mov rdx, min_no_len
    syscall

    mov rax, r15
    mov rdi, res
    call itoa

    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    xor rdi, rdi    
    syscall

atoi:
    xor rax, rax
    xor rbx, rbx
    ;---skipping leading spaces
.a_skip:
    mov dl , [rsi]
    cmp dl, ''
    je .a_adv
    cmp dl, 9
    je .a_adv
    jmp .a_chk_sign

.a_adv:
    inc rsi
    jmp .a_skip
    
.a_chk_sign:
    mov dl, [rsi]
    cmp dl, '-'
    jne .a_chk_plus
    mov bl, 1
    inc rsi
    jmp .a_loop

.a_chk_plus:
    cmp dl, '+'
    jne .a_loop

.a_loop:
    mov dl, [rsi]
    cmp dl, '0'
    jb .a_done
    cmp dl, '9'
    ja .a_done
    imul rax, rax, 10
    sub dl, '0'
    movzx rdx, dl
    add rax, rdx
    inc rsi
    jmp .a_loop

.a_done:
    test bl, bl
    jz .a_ret
    neg rax

.a_ret:
    ret

itoa:
    push rbx
    mov rbx, rax
    mov rsi, rdi
    add rsi, 63
    mov byte [rsi], 0
    mov rcx, 0

    test rax, rax
    jnz .i_chk_sign
    dec rsi
    mov byte [rsi], '0'
    mov rdx, 1
    pop rbx
    ret

.i_chk_sign:
    mov rdx, 0
    cmp rax, 0
    jge .i_abs

.i_abs:

.i_loop:
    xor r8, r8
    mov r9, 10
    xor rdx, rdx
    div r9
    add rdx, '0'
    dec rsi
    mov [rsi], dl
    inc rcx
    test rax, rax
    jnz .i_loop

    ;---Sign--
    cmp rbx, 0
    jge .i_done
    dec rsi
    mov byte [rsi], '-'
    inc rcx

.i_done:
    mov rdx, rcx
    pop rbx
    ret