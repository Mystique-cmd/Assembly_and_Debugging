global _start

section .text
_start:
    mov     rbx, [rsp]         ; load argc
    lea     rsi, [rsp+8]       ; point to argv[0] - program name.{ computes rsp+ 8 then loads it onto rsi }

    ;---Check For Arguments---
    cmp     rbx, 0
    je      .exit

    ; Iterate argv[i], i = 0..argc-1
    xor     rcx, rcx           ; rcx = i = 0

.next_arg:
    ; Load argv[i] pointer
    mov     rdi, [rsi + rcx*8] ; rdi = argv[i]
    test    rdi, rdi
    je      .exit

    ; Compute strlen(argv[i]) into rdx
    mov     rdx, rdi           ; rdx = scan pointer
.find_nul:
    cmp     byte [rdx], 0
    je      .got_len
    inc     rdx
    jmp     .find_nul

.got_len:
    ; rdx = end pointer, rdi = start pointer
    sub     rdx, rdi           ; rdx = length

    ; write(1, argv[i], len)
    mov     rax, 1             ; sys_write
    mov     rsi, rdi           ; buf
    mov     rdi, 1             ; fd = stdout
    syscall

    ; write(1, "\n", 1)
    mov     rax, 1             ; sys_write
    mov     rdi, 1             ; fd = stdout
    lea     rsi, [rel newline]
    mov     rdx, 1
    syscall

    ; i++
    inc     rcx
    cmp     rcx, rbx
    jl      .next_arg

.done:
.exit:
    mov     rax, 60            ; sys_exit
    xor     rdi, rdi           ; status = 0
    syscall

section .rodata
newline: db 10
