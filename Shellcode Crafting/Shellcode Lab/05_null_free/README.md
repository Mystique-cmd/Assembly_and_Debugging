# Lab 05: Null-Free Shellcode

## Objective

Avoid null bytes in the machine-code representation. For example, use `xor rdi, rdi` instead of `mov rdi, 0` when both produce the same register value.

The build also checks for null bytes automatically:

```bash
python3 -c 'data = open("shellcode.bin", "rb").read(); print("null bytes:", data.count(b"\x00"))'
```

The instructions have the same effect, but their machine-code representations differ.
