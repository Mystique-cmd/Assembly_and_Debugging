#!/bin/bash
set -e
echo "[+] Extracting .text section...."
objcopy -O binary\
	--only-section=.text \
	shellcode.o\
	shellcode.bin
	
echo "[+] Extracted shellcode"
echo

xxd -g 1 shellcode.bin

echo 
echo "[+] Shellcode size:"
wc -c < shellcode.bin
