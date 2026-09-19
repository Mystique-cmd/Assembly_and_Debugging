global _start

section .data
    no_entry db "No input", 0x0A
    len_no_entry equ $ - no_entry

section .bss
    buffer  resb 64
    outbuf  resb 32

section .text
_start:
    ;---Read Input---
    mov rax, 0            ; sys_read
    mov rdi, 0            ; stdin
    mov rsi, buffer       ; buf
    mov rdx, 64           ; count
    syscall               ; rax = bytes read

    ;---Compute character count (exclude trailing newline if present)---
    mov rcx, rax                ; rcx = bytes read
    test rcx, rcx
    jz .no_input                ; nothing read
    cmp byte [buffer + rcx - 1], 10 ; last byte '\n'?
    jne .after_trim
    dec rcx                     ; remove trailing newline
.after_trim:
    test rcx, rcx
    jz .no_input                ; only newline entered -> treat as no input

    ;---Convert RCX (count) to decimal into outbuf---
    mov rax, rcx
    lea rdi, [outbuf + 31]      ; point to end of outbuf
    mov r8, rdi                 ; remember end pointer
    jmp .conv_iter

.no_input:
    mov rax, 1
    mov rdi, 1
    mov rsi, no_entry
    mov rdx, len_no_entry
    syscall
    jmp .exit

.conv_iter:
    xor rdx, rdx
    mov rbx, 10
    div rbx               ; rax = rax/10, rdx = remainder
    add dl, '0'
    mov byte [rdi], dl
    dec rdi
    test rax, rax
    jne .conv_iter
    inc rdi               ; move to first digit
    mov rsi, rdi
    mov rdx, r8
    sub rdx, rdi
    inc rdx               ; number of bytes to write

.write:
    ;---Write the number---
    mov rax, 1            ; sys_write
    mov rdi, 1            ; stdout
    syscall

    ;---Write newline---
    mov byte [outbuf], 10
    mov rax, 1
    mov rdi, 1
    mov rsi, outbuf
    mov rdx, 1
    syscall

.exit:
    mov rax, 60           ; sys_exit
    xor rdi, rdi
    syscall