global  _start

section .data
    prompt_msg db "Enter space-separated numbers (max 10, each max 9 digits): ", 0x0A
    prompt_msg_len equ $ - prompt_msg

    sorted_msg db "Sorted array: ", 0x0A
    sorted_msg_len equ $ - sorted_msg

section .bss
    input_buffer resb 64
    int_array resb 64

section .text
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_msg
    mov rdi, prompt_msg_lem
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, input_buffer
    mov rdx, 64
    syscall

    ; Store the number of bytes read (excluding newline)
    mov rbx, rax             ; rbx = number of bytes read
    cmp rbx, 0
    je exit_program          ; If nothing read, exit
    dec rbx                  ; Decrement to remove newline character from count
    ; Calculate the address for null-termination
    lea rbp, [input_buffer]    ; rbp = base address of input_buffer
    add rbp, rbx             ; rbp now points to the position to null-terminate
    mov byte [rbp], 0        ; Null-terminate the input string

    ; 3. Parse input string into integer array
    mov rsi, input_buffer    ; rsi points to the start of the input string
    lea rdi, [int_array]       ; rdi points to the start of the integer array
    mov dword [array_len], 0 ; Initialize array length to 0
    call parse_input_to_array

    ; 4. Perform Bubble Sort
    call bubble_sort

    ; 5. Print the sorted array
    lea rsi, [sorted_msg]
    call print_string

    mov ecx, dword [array_len] ; ecx = number of elements
    lea rsi, [int_array]         ; rsi points to the start of the integer array
    mov ebx, 0                 ; ebx = loop counter (index)

print_loop:
    cmp ebx, ecx
    jge end_print_loop

    mov eax, dword [rsi + ebx * 4] ; Get current integer from array
    call print_int                 ; Print the integer

    ; Print a space after each number (except the last one)
    inc ebx
    cmp ebx, ecx
    je end_print_loop
    lea rsi, [space_char]
    call print_string
    jmp print_loop

end_print_loop:
    call print_newline

    ; 6. Exit the program
exit_program:
    mov rax, 60              ; syscall number for exit
    xor rdi, rdi             ; exit code 0
    syscall

; --- Subroutines ---

; parse_input_to_array: Parses space-separated numbers from input_buffer
;                       and stores them in int_array. Updates array_len.
; Input: rsi = address of input_buffer (null-terminated)
;        rdi = address of int_array
;        dword [array_len] = current length (initialized to 0)
; Output: int_array populated, dword [array_len] updated
parse_input_to_array:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    mov rbx, rsi             ; rbx = current position in input_buffer
    mov rcx, 0               ; rcx = current index in int_array

next_number:
    ; Skip leading spaces
    mov al, byte [rbx]
    cmp al, 0
    je end_parse_loop        ; End of string
    cmp al, ' '
    je skip_space
    jmp start_parsing_int

skip_space:
    inc rbx
    jmp next_number

start_parsing_int:
    ; Find end of current number or end of string
    mov rdx, rbx             ; rdx = start of current number
    mov rax, 0               ; rax will hold the integer value
    mov r8, 0                ; r8 = sign (0 for positive, 1 for negative)

    ; Check for negative sign
    cmp byte [rdx], '-'
    jne not_negative
    mov r8, 1                ; Set sign to negative
    inc rdx                  ; Move past '-'

not_negative:
    ; Convert ASCII digits to integer
    mov r9, 0                ; r9 = current digit
    mov r10, 10              ; r10 = base 10

convert_digit_loop:
    mov al, byte [rdx]
    cmp al, '0'
    jl end_convert_digit
    cmp al, '9'
    jg end_convert_digit

    sub al, '0'              ; Convert ASCII digit to integer
    movzx r9, al             ; r9 = current digit

    imul rax, r10            ; rax = rax * 10
    add rax, r9              ; rax = rax + current_digit

    inc rdx
    jmp convert_digit_loop

end_convert_digit:
    ; Apply sign
    cmp r8, 1
    jne store_int
    neg rax                  ; Negate if it was a negative number

store_int:
    mov dword [rdi + rcx * 4], eax ; Store integer in int_array
    inc rcx                  ; Increment array index
    inc dword [array_len]    ; Increment array length

    mov rbx, rdx             ; Move rbx to the position after the current number
    cmp byte [rbx], 0
    jne next_number          ; Continue if not end of string

end_parse_loop:
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    ret

; bubble_sort: Sorts the integer array using bubble sort algorithm.
; Input: int_array, dword [array_len]
; Output: int_array sorted in ascending order
bubble_sort:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    mov ecx, dword [array_len] ; ecx = n (number of elements)
    cmp ecx, 1
    jle end_bubble_sort        ; If n <= 1, array is already sorted

    mov ebx, 0                 ; ebx = i (outer loop counter)

outer_loop:
    cmp ebx, ecx
    jge end_bubble_sort

    mov edx, 0                 ; edx = j (inner loop counter)
    mov esi, 0                 ; esi = swapped flag (0 = false, 1 = true)

inner_loop:
    mov r8d, ecx
    sub r8d, ebx
    dec r8d                    ; r8d = n - i - 1
    cmp edx, r8d
    jge end_inner_loop

    ; Compare int_array[j] and int_array[j+1]
    mov r9d, dword [int_array + edx * 4]     ; r9d = int_array[j]
    mov r10d, dword [int_array + edx * 4 + 4] ; r10d = int_array[j+1]

    cmp r9d, r10d
    jle no_swap_needed

    ; Swap int_array[j] and int_array[j+1]
    mov dword [int_array + edx * 4], r10d
    mov dword [int_array + edx * 4 + 4], r9d
    mov esi, 1                 ; Set swapped flag to true

no_swap_needed:
    inc edx
    jmp inner_loop

end_inner_loop:
    cmp esi, 0                 ; If no swaps in inner loop, array is sorted
    je end_bubble_sort

    inc ebx
    jmp outer_loop

end_bubble_sort:
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    ret

; print_string: Prints a null-terminated string to stdout.
; Input: rsi = address of the string
print_string:
    push rax
    push rdi
    push rdx
    push rsi

    mov rdx, 0
    mov rax, rsi
    ; Calculate string length
.strlen_loop:
    cmp byte [rax], 0
    je .strlen_done
    inc rdx
    inc rax
    jmp .strlen_loop
.strlen_done:

    mov rax, 1               ; syscall number for write
    mov rdi, 1               ; file descriptor 1 (stdout)
    ; rsi already points to string
    ; rdx already has length
    syscall

    pop rsi
    pop rdx
    pop rdi
    pop rax
    ret

; print_char: Prints a single character to stdout.
; Input: al = character to print
print_char:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    mov byte [int_to_ascii_buffer], al ; Store char in buffer
    mov rax, 1               ; syscall number for write
    mov rdi, 1               ; file descriptor 1 (stdout)
    mov rsi, int_to_ascii_buffer ; address of buffer
    mov rdx, 1               ; length 1
    syscall

    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    ret

; print_newline: Prints a newline character to stdout.
print_newline:
    push rsi
    lea rsi, [newline_char]
    call print_string
    pop rsi
    ret

; print_int: Converts an integer to ASCII and prints it to stdout.
; Input: eax = integer to print
print_int:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    mov rbx, 10              ; Divisor for decimal conversion
    mov rcx, 0               ; Counter for digits

    cmp eax, 0
    jge .positive_number

    ; Handle negative numbers
    mov byte [int_to_ascii_buffer], '-' ; Store '-' sign
    inc rcx                  ; Increment digit counter for '-'
    neg eax                  ; Make number positive for conversion

.positive_number:
    mov rdi, int_to_ascii_buffer + INT_BUFFER_SIZE - 2 ; Point to second to last byte for null terminator
    mov byte [rdi + 1], 0    ; Null terminate the buffer

.convert_loop:
    xor edx, edx             ; Clear edx for division
    div ebx                  ; eax = eax / 10, edx = eax % 10
    add dl, '0'              ; Convert remainder to ASCII digit
    mov byte [rdi], dl       ; Store digit in buffer
    dec rdi                  ; Move to previous position
    inc rcx                  ; Increment digit counter
    cmp eax, 0
    jne .convert_loop

    ; If it was a negative number, rdi points to the digit after '-'
    ; We need to adjust rsi to point to the start of the number string
    mov rsi, rdi
    cmp byte [int_to_ascii_buffer], '-'
    je .handle_negative_print

    jmp .print_converted_int

.handle_negative_print:
    ; If negative, rsi should point to the '-' sign
    mov rsi, int_to_ascii_buffer
    ; rcx already includes the '-' in its count

.print_converted_int:
    mov rax, 1               ; syscall number for write
    mov rdi, 1               ; file descriptor 1 (stdout)
    ; rsi already points to the start of the string
    mov rdx, rcx             ; rcx has the length of the number string
    syscall

    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret