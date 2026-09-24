#!/usr/bin/env/python3
 KEY = 0xAA
 data = open("payload.bin", "rb").read()
 encoded = bytes( byte ^ KEY for byte in data)
 open("encoded.bin", "wb").write(encoded)
 
 print(f"[+] Original size: {len(data)}bytes")
 print(f"[+] XOR Key: 0x{KEY:02x}")
 print("[+] Encoded payload written to encoded.bin")
