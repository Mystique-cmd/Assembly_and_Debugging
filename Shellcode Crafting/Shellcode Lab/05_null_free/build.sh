#!/bin/bash
set -euo pipefail

echo '[+] Building Lab 05'
nasm -f elf64 shellcode.asm -o shellcode.o
objcopy -O binary --only-section=.text shellcode.o shellcode.bin
gcc -Wall -Wextra harness.c -o harness
./extract.sh
echo '[+] Build complete'
