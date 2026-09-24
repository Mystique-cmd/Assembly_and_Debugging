On the previous labs I used things like 
``` asm 
	mov rsi, message
	mov rsi, buffer
```
The above create address/ relocation issues when raw .text is extracted. This shellcode now solves that
