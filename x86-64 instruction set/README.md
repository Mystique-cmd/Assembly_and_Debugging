The x86-64 instruction set is the set of machine instructions understood by 64-bit x86 CPUs ( AMD64/Intel 64).
At the lowest level a program becomes a sequence of bytes. We can confirm this using the command `hexdump -C  -s <address> -n 32 <program name>`.
The CPU decodes those bytes into an instruction. The instructions are in assembly.

## x86-64 Registers.
A register is a small, fast storage location inside the CPU that holds data the processor is currently working with.
The general purpose registers each 64-bits wide include:
- rax
- rbx
- rcx
- rdx
- rsi
- rdi
- rbp
- rsp
- r8
- r9
- r10
- r11
- r12
- r13
- r14
- r15
 Smaller versions of the same registers for 32-bit and 8-bit can also be accessed.
 Among the general purpose registers there are those that are special, in that they have important roles.
 - rsp - Stack pointer; it points to the current top of the stack. It value can be checked on GNU GDB using `x/40gx $rsp`
 - rbp - Frame pointer; traditionally used to identify the current stack frame although modern compilers may omit the frame pointer
 - rip - Instruction Pointer; it contains the address of the next instruction to execute. Can be checked inside GNU GDB with `info registers rip`

## RFLAGS
It is a special 64-bit CPU register that stores the current state of the processor using indiviual flags ( bits).
THe important flags it stores include
- ZF - Zero Flag
- CF - Carry Flag
- SF - Sign Flag
-OF - Overflow Flag
This flags are heavily used by conditional instructions

## Data Movement Instructions
The fundamental instruction is `mov`
The conceptual syntax is `mov destination , source`
When source is `[source]` it is referencing to the memory address of the source and the same applies for the destination `[destination]`

## Arithmetic Instructions
The common ones include
- add
- sub 
- inc
- dec
- imul
- idiv
- neg

## Logical and Bitwise Instructions
The important ones are
- and
- or 
- xor - `xor rax, rax` is the common compiler-generated assembly
- not
- test - it effectively performs AND for purposes of setting flags without storing the results and it is commonly followed by a conditional instruction

## Comparison Instructions
- cmp
- test
The results isn't normally stored, instead , flags are modified and the conditional jumps are used to examine the flags

## Control Flow Instructions
They are essential in the program execution. They are categorized into two:
### (i) Conditional Jumps:
jmp <address>

### (ii) Unconditonal jumps
- je
- jne
- jg
- jge
- jl
- jle
- ja
- jb
- jae
- jbe

## Call and Ret
They are important in understanding functions and the stack.
The syntax is `call <function>` and `ret`
ret retrieves teh return address and continues the execution there

## Stack Instuctions
The primary ones are
- push
- pop

## Memory Addressing
The general addressing form is `[base + index * scale + displacement]` where
- base = register
- index = register
- scale = 1, 2, 4 or 8
- displacement = constant

## Shifts and Rotations
The instructions are:
- shl
- shr
- sal
- sar
- rol
- ror
They are usually used in unsigned division / multiplication by powers of two

## Sign and Zero Extension
They are important when dealing with different integer sizes
The instructions include:
- movzx
- movsx
- movsxd

## lea instuction
It calculates the address expression rather than loading memory from that address.
It is often used for arithmetic and address calculations

## nop instruction
It means do nothing
It advances execution without changing the meaningful machine state

## Conditional Moves
They allow data movement without necessarily branching
- cmove
- cmovne
- cmovg
- cmovl

## String and Specialized Instruction
- rep
- movs
- stos
- lods
- scas
- cmps
And other instructions for
- bit manipulation
- atomic operations
- SIMD
- floating point
- cryptography
- virtualilzation
- system operations
Examples include:
- lock
- xchg
- bsf
- bsr
- popcnt
- cpuid
- syscall
- sysret

## syscalls
It is the way the kernel and user programs interact

## Instruction Encoding
An x86-64 instruction isn't necessarily one fixed number or bytes.
A machine instruction can contain components such as 
- prefix
- REX
- Opcode
- ModR/M
- SIB
But not every instruction has every component.

