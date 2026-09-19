global _start

section .bss
    buffer resb 128

section .text
_start:
    ;---Read Input---
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 128
    syscall

    mov rcx, rax
    mov rbx, buffer

.convert_loop:
    test rcx, rcx
    jz .write_out       ;it jumps there because there would be nothing to convert

;The letters a and z provide the range within which you want the alphabets to be changed.
    mov al, [rbx]
    cmp al, 'a'         ;checks if the value is below ascii 'a' ( not lowercase )
    jb .skip
    cmp al, 'z'         ;checks if the value is above ascii 'z' ( not lowercase )
    ja .skip
    sub al, 32          ;this sbtracts the value 32 to change the values in the al to uppercase
    mov [rbx], al

.skip:
    inc rbx
    dec rcx         ;rcx is holding the length of the input string copied from rax
    jmp .convert_loop

.write_out:
    ;---Write buffer back---
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, 128
    syscall

    ;---Exit---
    mov rax, 60
    mov rdi, 0
    syscall