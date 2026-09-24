#!/usr/bin/env python3

KEY = 0xAA

with open("payload.bin", "rb") as payload_file:
	data = payload_file.read()

encoded = bytes(byte ^ KEY for byte in data)
with open("encoded.bin", "wb") as encoded_file:
	encoded_file.write(encoded)

print(f"[+] Original size: {len(data)} bytes")
print(f"[+] XOR key: 0x{KEY:02x}")
print("[+] Encoded payload written to encoded.bin")
