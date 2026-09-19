global _start

section .rodata
    First_No db "First No.:",0x0a
    First_No_Len equ $ - First_No

    Second_No db "Second No.:",0x0a
    Second_No_Len equ $ - Second_No

    Third_No db "Third No.:",0x0a
    Third_No_Len equ $ - Third_No

    Sum db "Sum :",0x0a
    Sum_Len equ $ - Sum
    
section .bss
    fn resb 32
    sn resb 32
    tn resb 32
    sum resb 32

section .text
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, First_No
    mov rdx, First_No_Len
    syscall 

    mov rax, 0
    mov rdi, 0
    mov rsi, fn  
    mov rdx, 32
    syscall
    call atoi
    mov r8, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, Second_No
    mov rdx, Second_No_Len
    syscall 

    mov rax, 0
    mov rdi, 0
    mov rsi, sn
    mov rdx, 32
    syscall
    call atoi
    mov r9, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, Third_No
    mov rdx, Third_No_Len
    syscall 

    mov rax, 0
    mov rdi, 0
    mov rsi, tn
    mov rdx, 32
    syscall
    call atoi
    mov r10, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, Sum
    mov rdx, Sum_Len
    syscall

    xor rcx, rcx
    add rcx, r8
    add rcx, r9
    add rcx, r10
    
    mov rax, rcx
    mov rdi, sum
    call itoa

    mov rax, 1
    mov rdi, 1      ;rsi and rdx are set by itoa
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

atoi:
    push rbx
    xor rax, rax
    xor rbx, rbx    ;for the sign
.a_skip:
    mov dl, [rsi]
    cmp dl, ' '
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
    mov bl, 1           ;negative
    inc rsi
    jmp .a_loop
.a_chk_plus:
    cmp dl , '+'
    jne .a_loop
    inc rsi
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
    pop rbx
    ret

itoa:
    push rbx
    mov rbx, rax
    mov rsi, rdi
    add rsi, 31
    mov byte [rsi], 0       ;loading the terminator
    mov rcx, 0              ;counter

    ;---Handling 0 explicitly---
    test rax, rax
    jnz .i_check_sign
    dec rsi
    mov byte [rsi], '0'
    mov rdx, 1
    pop rbx
    ret
.i_check_sign:
    mov rdx, 0
    cmp rax, 0
    jge .i_abs
    neg rax
    mov rdx, 1
.i_abs:
.i_loop:
    xor r11, r11
    mov r12, 10
    xor rdx, rdx
    div r12
    add dl , '0'
    dec rsi
    mov [rsi], dl
    inc rcx
    test rax, rax
    jnz .i_loop

    cmp rbx, 0
    jge .i_done
    dec rsi
    mov byte [rsi], '-'
    inc rcx
.i_done:
    mov rdx, rcx
    pop rbx
    ret



