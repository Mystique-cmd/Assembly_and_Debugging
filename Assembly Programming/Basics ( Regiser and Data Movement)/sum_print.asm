global _start

section .data
    msg_prefix db "Result: ", 0x0A
    msg_prefix_len equ $ - msg_prefix

section .bss
    numbuf resb 32

section .text
_start:
    ;---Inputs---
    mov rax, 123
    mov rbx, 456

    ;---Add---
    add rax, rbx

    ;The conversion is necessary because the CPU does not know about decimals
    ;we are using r8 instead of rdx because it would conflict with  division and syscall argument

    mov rcx, numbuf     ;rcx = address of numbuf
    mov r8, rcx     ;save the original base address of numbuf here
    add rcx, 31     ;point to enter the buffer region which is at the end
    mov r9, rcx     ;r9 = current write ptr ( backwards )

    cmp rax, 0
    jne .convert_loop
    mov byte [r9], '0' ; the '0' character is written into the buffer
    dec r9
    jmp .converted

.convert_loop:
    xor rdx, rdx
    mov rdi, 10
    div rdi
    add dl , '0'    ;convert digit to ASCII
    mov byte[r9], dl
    dec r9
    test rax, rax
    jnz .convert_loop

.converted:
    ;---Write Prefix ---
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_prefix
    mov rdx, msg_prefix_len
    syscall

    ;---Write digits ( forward )--
    lea rsi, [r9+1]     ;start of digits
    mov rdx, r8         ;r8=number base
    add rdx, 31         ;point to end of buffer
    sub rdx, r9         ;length = end - r9
    dec rdx             ; adjust because r9+1 is start

    mov rax, 1
    mov rdi, 1
    syscall

    ;---Exit---
    mov rax, 60
    xor rdi, rdi
    syscall

