# Lab 02: `write` Syscall

## Objective

Learn how Linux x86-64 shellcode prepares arguments for the `write` syscall.
 
## Tools
- NASM
- GNU ld
- objcopy
- objdump
- xxd
- GDB
- GCC



In the first version, the shellcode has code in the `.text` section and data in the `.data` section. This introduces a shellcode problem: how does shellcode reliably find its data after it is extracted from an ELF object and placed somewhere else in memory?

When inspecting `shellcode.o`, use the `-r` flag to display relocation data:

```bash
	objdump -dr shellcode.o
```

Relocation information identifies places where the linker still needs to fix an address or value. Extracting only `.text` with `objcopy` does not include a string stored in `.data`.

For shellcode, it is convenient to keep code and data together in the extracted byte stream. [Version 2](shellcodeV1.0.1.asm) of [shellcode.asm](shellcode.asm) does that.

## Known limitation

Version 2 contains an absolute reference to `message` and is therefore not position independent.
