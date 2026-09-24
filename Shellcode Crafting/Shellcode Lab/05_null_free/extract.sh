# change the file name to the name of the actual file to test
if xxd -p shellcode.bin | grep -q '00'; then
	echo "[-] Null bytes found"
else
	echo"[+] Shellcode is null free"
fi
