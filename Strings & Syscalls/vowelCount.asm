section .data
    prompt db 'Enter a string: ', 0
    len_prompt equ $ - prompt
    result db 'The number of vowels is: ', 0
    len_result equ $ - result
    vowel_count db 0

section .bss
    user_input resb 255

section .text
    global _start

_start:
    ; Prompt for user input
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, len_prompt
    syscall

    ; Read user input
    mov rax, 0
    mov rdi, 0
    mov rsi, user_input
    mov rdx, 255
    syscall

    ; Count vowels
    mov rsi, user_input
    mov rcx, rax ; rax contains the number of bytes read
    xor rbx, rbx ; rbx will be our vowel counter

count_loop:
    cmp rcx, 0
    je end_count
    mov al, [rsi]
    cmp al, 'a'
    je is_vowel
    cmp al, 'e'
    je is_vowel
    cmp al, 'i'
    je is_vowel
    cmp al, 'o'
    je is_vowel
    cmp al, 'u'
    je is_vowel
    cmp al, 'A'
    je is_vowel
    cmp al, 'E'
    je is_vowel
    cmp al, 'I'
    je is_vowel
    cmp al, 'O'
    je is_vowel
    cmp al, 'U'
    je is_vowel
    jmp not_vowel

is_vowel:
    inc rbx

not_vowel:
    inc rsi
    dec rcx
    jmp count_loop

end_count:
    ; Convert vowel count to ASCII and store it
    add rbx, '0'
    mov [vowel_count], bl

    ; Print the result message
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, len_result
    syscall

    ; Print the vowel count
    mov rax, 1
    mov rdi, 1
    mov rsi, vowel_count
    mov rdx, 1
    syscall

    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall
