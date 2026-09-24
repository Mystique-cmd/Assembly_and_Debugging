# Lab 01: Exit Shellcode

## Objective

Create a minimal x86-64 Linux shellcode payload that terminates the current process with a chosen exit status.

## Environment
- Architecture : x86-64
- OS: Linux
- Assembler: NASM
- Compiler: GCC
- Extraction Tool: GNU objcopy
- Debugger: GNU GDB

### Note

When `make` runs the compiled [autoharness.c](autoharness.c), the harness exits with status 42. `echo $?` therefore reports the shellcode's requested exit status.

## Debugging
```bash
	gdb ./autoharness
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
