# Lab 06: Chaining Syscalls

## Objective

Chain different syscalls by using the result of one syscall as an input to the next. This lab uses the byte count returned by `read` as the length passed to `write`.

## Build and run

```bash
./build.sh
printf 'hello\n' | ./harness
```
