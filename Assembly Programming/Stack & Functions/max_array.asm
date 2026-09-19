global _start

section .data
    prompt1 db "First No.:", 10
    prompt1_len equ $ - prompt1
    prompt2 db "Second No.:", 10
    prompt2_len equ $ - prompt2
    prompt3 db "Third No.:", 10
    prompt3_len equ $ - prompt3
    max_no db "Maximum No.:",10
    max_no_len equ $ - max_no
    
section .bss
    buf1    resb 32
    buf2    resb 32
    buf3    resb 32
    outbuf  resb 32

section .text
_start:
    ; prompt and read first number
    mov rax, 1              ; write
    mov rdi, 1
    mov rsi, prompt1
    mov rdx, prompt1_len
    syscall

    mov rax, 0              ; read
    mov rdi, 0
    mov rsi, buf1
    mov rdx, 31
    syscall                 ; RAX = bytes read
    mov rsi, buf1
    call atoi               ; RAX = first
    mov r12, rax

    ; prompt and read second number
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt2
    mov rdx, prompt2_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, buf2
    mov rdx, 31
    syscall
    mov rsi, buf2
    call atoi               ; RAX = second
    mov r13, rax

    ; prompt and read third number
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt3
    mov rdx, prompt3_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, buf3
    mov rdx, 31
    syscall
    mov rsi, buf3
    call atoi               ; RAX = third
    mov r14, rax

    ; compute max of r12, r13, r14
    mov r15, r12
    cmp r13, r15
    cmovg r15, r13
    cmp r14, r15
    cmovg r15, r14

    ; print max
    mov rax,1
    mov rdi,1
    mov rsi,max_no
    mov rdx, max_no_len
    syscall

    mov rax, r15
    mov rdi, outbuf
    call itoa               ; returns RSI=start, RDX=len

    mov rax, 1
    mov rdi, 1
    ; RSI and RDX set by itoa
    syscall

    ; print newline
    mov byte [outbuf], 10
    mov rax, 1
    mov rdi, 1
    mov rsi, outbuf
    mov rdx, 1
    syscall

    ; exit
    mov rax, 60
    xor rdi, rdi
    syscall

atoi:
    xor rax, rax            ; result
    xor rbx, rbx            ; sign flag (0=positive, 1=negative)

    ; skip leading spaces
.a_skip:
    mov dl, [rsi]
    cmp dl, ' '
    je .a_adv
    cmp dl, 9               ; TAB
    je .a_adv
    jmp .a_chk_sign
.a_adv:
    inc rsi
    jmp .a_skip

.a_chk_sign:
    mov dl, [rsi]
    cmp dl, '-'
    jne .a_chk_plus
    mov bl, 1               ; negative
    inc rsi
    jmp .a_loop
.a_chk_plus:
    cmp dl, '+'
    jne .a_loop
    inc rsi

.a_loop:
    mov dl, [rsi]
    cmp dl, '0'
    jb .a_done
    cmp dl, '9'
    ja .a_done
    ; rax = rax*10 + (dl-'0')
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
    mov rbx, rax            ; save original
    mov rsi, rdi
    add rsi, 31             ; point to last byte in buffer
    mov byte [rsi], 0       ; terminator (not strictly needed for write)
    mov rcx, 0              ; length counter

    ; handle zero explicitly
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
    mov rdx, 1              ; need '-' later
.i_abs:
.i_loop:
    xor r8, r8
    mov r9, 10
    xor rdx, rdx
    div r9                  ; rax/=10, rdx=remainder
    add dl, '0'
    dec rsi
    mov [rsi], dl
    inc rcx
    test rax, rax
    jnz .i_loop

    ; add sign if needed (stored in rbx's sign)
    cmp rbx, 0
    jge .i_done
    dec rsi
    mov byte [rsi], '-'
    inc rcx
.i_done:
    mov rdx, rcx
    ; RSI already points to start
    pop rbx
    ret
