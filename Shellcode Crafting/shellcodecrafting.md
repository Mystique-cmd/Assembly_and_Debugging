A shellcode is machine code intended to execute from a controlled/ injected memory location.
The execution reaches shellcode when the CPU's Instruction pointer is redirected to the address containing the shellcode bytes.

# Linux x86-64 Syscalls
A syscall ( system call ) is the mechanism a user space program uses to request service from the kernel.
### (i) syscall instruction
It is the primary instruction for entering the kernel.
Using the [exit a process program](exit.asm) We can see that:
- rax = syscall number
- rdi = 1st arg
- rsi = 2nd arg
- rdx = 3rd arg
- r10 = 4th arg
- r8 = 5th arg
- r9 = 6th arg
- rax = return value. The kernel returns the results in rax. The errors are represented in negative values in the syscall return convention ; libc normally converts these into -1 plus `errno`

### (ii) syscall numbers
Each syscall is assigned a number. Some of the important ones are.
- read = 0
- write = 1
- open = 2 
- close = 3
- mmap = 9
- munmap  = 11 ( unmap memory)
- mprotect = 10 (Change memory permisions)
- execve = 59 ( Execute a program )
-  exit = 60 
- fork = 57
- getpid = 39
The numbers are specific to the x86-64 Linux syscall ABI


In x86-64 when syscall is executing the CPU itself uses rcx and r11 as part of the transition which is different from the normal System V functioncall convention.
One can find the syscall of a particular machine from the kernel syscall table with
` grep -r "__NR__write" /usr/include/x86_64-linux-gnu/asm/unistd_64.h`
or better use 
`ausyscall --dump`, if the relevant audit utilities are installed.

The syscall can also be debugged uing GDB with the usual steps 
(i) Run the program : `gdb program`
(ii) Disassemble the starting point : `disassemble _start`
(iii) Set a breakpoint before the sysall : `break <address>`
(iv) Inpect the registers : ` info regisers rdi rsi rdx`
(v) Single step ` si`
(vi) Inspect rax ` info registers rax`

# Shellcode Constraints
## (i) Position Independence
A position independent shellcode is a shellcode that can execute correctly regardless of the memory address where it is placed.
This is important since shellcode cannot assume where its code would begin ( absolute address ) thus it needs to calculate the address at runtime
