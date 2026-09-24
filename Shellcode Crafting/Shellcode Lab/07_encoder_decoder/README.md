# Lab 07: Encoder and Decoder

## Objective

XOR-encode a payload, place it inside a decoder, decode it in executable memory, and transfer control to the restored payload.

## Build and run

```bash
./build.sh
./harness
```

The payload is generated from `shellcode.asm`; `encode.py` writes `encoded.bin`, and `decoder.asm` includes that encoded payload.
