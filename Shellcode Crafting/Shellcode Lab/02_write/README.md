# Lab 02 - write syscall
## Objective
 Learn how Linux x86-64 shellcode prepares arguments for the `write` syscall
 
## Tools
- NASM
- GNU ld
- objcopy
- objdump
- xxd
- GDB
- GCC



In this lab the shellcode has both the code in the .text section and data in the .data section. This introuduces a shellcode problem. 
" How does shellcode reliably know where its data is located once its extracted from an ELF object and placed somowhere else in memory
When assembling the shellcode.o using GNU objdump tool use the -r flag to get the relocation data. 
``` bash
	objdump -dr shellcode.o
```
The relocation information shows the annotations annotating the places where the linker still needs to fix an address/value
When extracting the .text section using the tools GNU objcopy and xxd it is important to note that those would be only the shellcode for the instructions but not the string in the .data section
For shellcode it is convenient to keep code and data together in the extracted byte stream. For this reason we need a [version 2 ](shellcodeV1.0.1) of the [shellcode.asm ](shellcode.asm)file which does exactly that.

Known Limitation :
	This version contains an absolute referenece to 'message'  and is therefore not position independent
