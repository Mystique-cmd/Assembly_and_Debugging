# Lab 04: Position-Independent Shellcode

## Objective

Previous labs used absolute addresses such as:

```asm
mov rsi, message
mov rsi, buffer
```

Those instructions create relocation issues when raw `.text` is extracted. This lab uses a `call`/`pop` sequence to discover the message address at runtime.

## Build and run

```bash
./build.sh
./harness
```
