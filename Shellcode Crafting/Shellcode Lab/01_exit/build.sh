#!/bin/bash
set -e
echo "[+] Building Shellcode Laboratory"
make clean
make

echo 
echo "[+] Build Complete"
echo "[+] Generated Files"
ls -lh shellcode.o shellcode.bin autoharness
