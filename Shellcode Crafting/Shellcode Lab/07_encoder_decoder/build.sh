#!/bin/bash
set -euo pipefail

echo '[+] Building Lab 07'
nasm -f elf64 shellcode.asm -o payload.o
objcopy -O binary --only-section=.text payload.o payload.bin
python3 encode.py
nasm -f elf64 decoder.asm -o decoder.o
objcopy -O binary --only-section=.text decoder.o decoder.bin
gcc -Wall -Wextra harness.c -o harness
echo '[+] Build complete'
