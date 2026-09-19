global _start

section .rodata
    Results db "Results", 0x0a
    Results_length equ $ - Results

    no_arguments db "No argument!", 0x0a
    no_arguments_length equ $ - no_arguments

section .bss 
    output resb 32

section .text
_start:
    mov rcx, [rsp]                  ; argc

    ;---Confirming argument presence--
    cmp rcx, 2
    jnz .no_arguments

    ;---Parsing the argument---
    mov rsi, [rsp+16]               ; argv[1]
    call .ascii_to_integer_conversion
    mov r8, rax
    mov rdi, r8                      ; n in rdi

    ;---Factorial function---
    call .recursive_factorial_function   ; rax = n!

    ;---Converting result to ASCII---
    call .integer_to_ascii_conversion    ; rcx = start of digits

    ; Preserve start pointer across syscalls (syscall clobbers rcx!)
    mov r13, rcx

    ;---Results Prefix---
    mov rax, 1
    mov rdi, 1
    mov rsi, Results
    mov rdx, Results_length
    syscall

    ;---Results Length---
    lea r12, [output+31]            ; end (one past last)
    sub r12, r13                    ; length = end - start

    ;--Printing the Result---
    mov rax, 1
    mov rdi, 1
    mov rsi, r13                    ; start of digits (preserved)
    mov rdx, r12                    ; length
    syscall

    jmp .exit

.no_arguments:
    mov rax, 1
    mov rdi, 1
    mov rsi, no_arguments
    mov rdx, no_arguments_length
    syscall
    jmp .exit

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall

.recursive_factorial_function:
    cmp rdi, 1
    jle .base_case_factorial

    push rdi
    dec rdi
    call .recursive_factorial_function
    pop rdi
    imul rax, rdi
    ret

.base_case_factorial:
    mov rax, 1
    ret

.ascii_to_integer_conversion:
    xor rax, rax
.loop:
    movzx rdi, byte [rsi]
    test rdi, rdi
    je .done
    sub rdi, '0'
    imul rax, rax, 10
    add rax, rdi
    inc rsi
    jmp .loop
.done:
    ret

.integer_to_ascii_conversion:
    mov rcx, output+31
    mov rbx, 10
    test rax, rax
    jnz .loopy
    ; handle zero
    dec rcx
    mov byte [rcx], '0'
    ret
.loopy:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rcx
    mov [rcx], dl
    test rax, rax
    jnz .loopy
    ret
