global _start
section .text
_start:
	lea rsi, [rel encoded_payload]
	mov rcx, encoded_len
	mov al, 0XAA
	
decode_loop:
	xor byte[rsi], al
	inc rsi
	loop decode_loop
	
	jmp encoded_payload
	
encoded_payload
	incbin "encoded.bin"
	
encoded_len equ $ - encoded_payload
