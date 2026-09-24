#!/bin/bash
set -euo pipefail

objcopy -O binary --only-section=.text shellcode.o shellcode.bin
if xxd -p shellcode.bin | grep -q '00'; then
	echo "[-] Null bytes found"
	exit 1
else
	echo "[+] Shellcode is null free"
fi
