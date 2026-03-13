global _start

section .rodata
    no_args_msg db "No arguments", 0x0A
    no_args_len equ $ - no_args_msg
    newline db 0x0A

section .bss
    buffer resb 32         ; for number-to-string conversion
    n_value resq 1         ; stores the input n
    i_value resq 1         ; loop counter i

section .text
_start:
    sub rsp, 8
    mov rbx, [rsp+8]         ; argc (original [rsp] before alignment)
    cmp rbx, 2
    jne .no_args

    mov rsi, [rsp+24]        ; pointer to string argv[1]
    call .parse_decimal       ; rax = n

    ; store n and init i=0
    mov [n_value], rax
    xor rax, rax
    mov [i_value], rax

.print_loop:
    ; rdi = current i
    mov rax, [i_value]
    mov rdi, rax
    call .fib                 ; rax = fib(i)

    ; print fib(i)
    call .print_number
    call .print_newline

    ; i++
    mov rax, [i_value]
    inc rax
    mov [i_value], rax

    ; continue if i <= n
    mov rdx, [n_value]
    cmp rax, rdx
    jbe .print_loop

.exit:
    add rsp, 8               ; restore stack before exit
    mov rax, 60              ; sys_exit
    xor rdi, rdi
    syscall

.fib:
    push rbp
    mov rbp, rsp
    sub rsp, 16              ; locals: [rbp-8]=n, [rbp-16]=fib(n-1)
    mov [rbp-8], rdi

    cmp rdi, 1
    jbe .base_case

    ; compute fib(n-1)
    mov rax, rdi
    dec rax
    mov rdi, rax
    call .fib                 ; rax = fib(n-1)
    mov [rbp-16], rax

    ; compute fib(n-2)
    mov rdi, [rbp-8]
    sub rdi, 2
    call .fib                 ; rax = fib(n-2)

    ; sum = f1 + f2
    add rax, [rbp-16]


    leave
    ret

.base_case:
    mov rax, rdi             ; 0 or 1
    leave
    ret

.parse_decimal:
    xor rax, rax             ; result = 0
.parse_loop:
    mov bl, byte [rsi]
    cmp bl, '0'
    jb .done
    cmp bl, '9'
    ja .done
    imul rax, rax, 10
    movzx rdx, bl
    sub rdx, '0'
    add rax, rdx
    inc rsi
    jmp .parse_loop
.done:
    ret


.print_number:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp-8], rax         ; save original (optional)

    lea rbx, [buffer + 32]   ; write digits backwards
    mov rdx, rax
    test rdx, rdx
    jnz .convert
    ; handle zero
    mov byte [rbx-1], '0'
    dec rbx
    jmp .do_write

.convert:
    xor rax, rax
.convert_loop:
    xor rdx, rdx
    mov rax, [rbp-8]         ; current value
    mov rcx, 10
    div rcx                  ; quotient in rax, remainder in rdx
    add dl, '0'
    dec rbx
    mov [rbx], dl
    mov [rbp-8], rax
    test rax, rax
    jnz .convert_loop

.do_write:
    ; write the number string at [rbx .. buffer+32)
    mov rax, 1               ; sys_write
    mov rdi, 1               ; stdout
    mov rsi, rbx
    lea rdx, [buffer + 32]
    sub rdx, rbx             ; length
    syscall

    leave
    ret

.print_newline:
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret

.no_args:
    mov rax, 1
    mov rdi, 1
    mov rsi, no_args_msg
    mov rdx, no_args_len
    syscall
    jmp .exit
