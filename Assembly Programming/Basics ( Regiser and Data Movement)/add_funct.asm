global _start

section .rodata
    no_args_msg     db "No or less arguments provided", 0x0a
    no_args_msg_len equ $ - no_args_msg

    result_lbl      db "Result: ", 0
    result_lbl_len  equ $ - result_lbl

section .bss
    output_buffer   resb 64      ; buffer to hold ASCII result
    newline_buf     resb 1

section .text
_start:
    mov rcx, [rsp]                  ;loading the argc
    cmp rcx, 3                      ;checking if there are 3 arguments
    jl .no_args

    ;---Parsing arg[1]---
    mov rsi, [rsp + 16]
    call .ascii_to_int
    mov r8, rax                    

    ;---Parsing arg[2]---
    mov rsi, [rsp + 24]
    call .ascii_to_int
    mov r9, rax                     

    ;---Add---
    call .add_funct                

    ;---Print prefix---
    mov rax, 1                      
    mov rdi, 1                      
    mov rsi, result_lbl
    mov rdx, result_lbl_len
    syscall

    ;---Integer to ASCII conversion---
    mov rax, r8
    mov rsi, output_buffer
    call .int_to_ascii              

    ; print result
    mov rax, 1
    mov rdi, 1
    ; rsi already points to first digit
    mov rdx, rbx                    ; length
    syscall

    ; print newline
    mov byte [newline_buf], 0x0a
    mov rax, 1
    mov rdi, 1
    mov rsi, newline_buf
    mov rdx, 1
    syscall

    jmp .exit

.no_args:
    mov rax, 1
    mov rdi, 1
    mov rsi, no_args_msg
    mov rdx, no_args_msg_len
    syscall
    jmp .exit

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall


.ascii_to_int:
    xor rax, rax              ; result = 0
.ascii_loop:
    movzx rcx, byte [rsi]
    test rcx, rcx
    jz .ascii_done
    sub rcx, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rsi
    jmp .ascii_loop
.ascii_done:
    ret

.add_funct:
    add r8, r9
    ret

.int_to_ascii:
    mov rcx, 10
    xor rbx, rbx

    test rax, rax
    jnz .convert_start
    mov byte [rsi], '0'
    mov rbx, 1
    ret

.convert_start:
    mov rdi, rsi
    add rdi, 63                 ; last valid index in 64-byte buffer
    mov byte [rdi], 0           ; optional terminator (not required for write)
    dec rdi

.convert_loop:
    xor rdx, rdx                ; clear high bits for div
    div rcx                     ; RAX / 10 -> quotient in RAX, remainder in RDX
    add dl, '0'                 ; remainder -> ASCII
    mov [rdi], dl
    dec rdi
    inc rbx
    test rax, rax
    jnz .convert_loop

    inc rdi
    mov rsi, rdi
    ret
