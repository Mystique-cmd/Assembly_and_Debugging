# 01 - Exit Shellcode
## Objective
Create a minimal x86-64 Linux shellcode payload that terminates the current process with a chosen exit status

## Environment
- Architecture : x86-64
- OS: Linux
- Assembler: NASM
- Compiler: GCC
- Extraction Tool: GNU objcopy
- Debugger: GNU GDB

###Note 
When using make to run the [compiled autoharness.c ](autoharness.c)  make may return the exit code 2 when you run `echo $?`  which its it return value for an error.

## Debugging
``` bash
	gdb ./program
	break main
	run
	next ...
	print /x shellcode
	break *shellcode address
	continue
	x/5i $pc
	info registers rax, rdi
	stepi
	info registers rax
	stepi
	info registers rdi
	x/i $pc
	stepi
```
