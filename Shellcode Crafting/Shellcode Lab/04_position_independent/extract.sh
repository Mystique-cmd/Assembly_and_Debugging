#!/bin/bash
set -euo pipefail

objcopy -O binary --only-section=.text shellcode.o shellcode.bin
xxd -g 1 shellcode.bin
printf '[+] Shellcode size: '
wc -c < shellcode.bin
