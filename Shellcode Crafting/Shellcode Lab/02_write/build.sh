#!/bin/bash
set -euo pipefail

echo '[+] Building Lab 02'
nasm -f elf64 shellcode.asm -o shellcode.o
nasm -f elf64 shellcodeV1.0.1.asm -o shellcodeV1.0.1.o
objcopy -O binary --only-section=.text shellcode.o shellcode.bin
objcopy -O binary --only-section=.text shellcodeV1.0.1.o shellcodeV1.0.1.bin
gcc -Wall -Wextra harness.c -o harness
echo '[+] Build complete'
ls -lh shellcode.o shellcode.bin shellcodeV1.0.1.o shellcodeV1.0.1.bin harness
