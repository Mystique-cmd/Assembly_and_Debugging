#!/bin/bash
set -euo pipefail

objcopy -O binary --only-section=.text shellcodeV1.0.1.o shellcodeV1.0.1.bin
xxd -g 1 shellcodeV1.0.1.bin
printf '[+] Shellcode size: '
wc -c < shellcodeV1.0.1.bin
