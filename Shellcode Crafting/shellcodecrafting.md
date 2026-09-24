# Shellcode Crafting

A shellcode is machine code intended to execute from a controlled or injected memory location.
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
## 1. Position Independence
A position independent shellcode is a shellcode that can execute correctly regardless of the memory address where it is placed.
This is important since shellcode cannot assume where its code would begin ( absolute address ) thus it needs to calculate the address at runtime
Position Independence is made up of many concepts which include 
### (a) Absolute vd Reltive Addresses
An absolute address directly contains the complete virtual address of something
``` asm
mov rax , 0x401234
```
The instruction contains an address tied to a particular location. If the code or the data moves the embedded address doesn't automatically change and thus it is position dependent.

A relative address specifies a displacement from some known reference point rather than storiting the complete address.
```
target = curret location + displacemnt 
```
Even if the code moves the displacement still remains the same and that is why relative addresssing is useful in Position independent Shellcodes

### (b) x86-64 and RIP -Relative Addressing
x86-64 has a useful mechanism 
```
[RIP + displacement ]
```
RIP is the address of the next instruction.
For instance given the instruction
``` asm
	lea rax , [rip + message]
```
It conceptually means  that RAX = address of the current RIP + displacement to message and the displacement from the relevant RIP remains the same if the entire shellcode moves

Relative branches is another way of relative addressing 
``` asm 
	jmp target
```
On x86-64 a near jmp can encode a relative displacemnt and if the shellcode moves both the jmp and the target move together

Although relative addressing is this helpful it is still challenged by external things such as :
- libc functions
- kernel APIs
- shared library symbols
- system calls
The shellcode may know where its own code / data is but it doesn't necessaritly know where an external function is located. For this reason dynamic symbol / API resolution is required.

### (c) Call / ret mechanics
Call interacts directly with the stack and instruction pointer thus its importance in this.
Consider :
``` asm
	call fucntion
```
Conceptually the CPU perfomrs two operation when the call function is called:
- push address of the next instruction
- jump to function

It changes both RIP and RSP in the following ways
- RSP = decreases by 8
- RIP = changes to target

Consider
```asm
	ret
```
On call the CPU performs
- Pop the return address
- Shift execution to the next function

### (d) Call / pop technique
It is a classic way of obtaining  a code-relative address on x86-64. 
The basic idea is that when call is called it places the address of the next instruction on the stack and then transfers execution to the fucntion in the argument pop then removes that address from the stack and put it back into a regiser rbx
This is position Independent sicne teh call function can be called at any address during runtime and the hardcoded address would only be the one that gets popped
This technique changes the stack thus forgetting to use the pop can interfere with later code particularly a subsequent ret

#### (e) Position Independent Data
It refers to data whose address does not depend on where the code was loaded.
The important property is that the distance between the code and data stays constant
By data we are referencing to :
- strings
- constants
- tables
- structures
- encoded data
- configuration values
- lookup tables

## 2. NULL byte avoidance
Null byte avoidance means designing the machine code bytes so the payload contains no 0x00 bytes.
This matters because many vulnerable programs treat input as  a C string, where 0x00 means 'end of string'. If your shellcode contains a null byte , function such as `strcpy` , `strcat` or similar string oriented paths may stop copying before the shellcode is complete
The common techniques include:
### (i) Zeroing Registers
Instead of 
``` asm 
	mov rax, 0
```
use 
```asm
	xor rax, rax	; |
	sub rax, rax
```
### (ii) Small constants
Instead of loading a large immediae containing lots of zero bytes, sometimes you can construct a value incrementatlly
``` asm
	xor rax, rax
	inc rax
```
You can also use operations such as
```asm
	xor rax, rax
	mov al, 60
```
This is useful when only the low byte needs to be changed

### (iiiv) Constructing Strings
A common conceptual approach is:
- represent the characters as hexadecimal bytes
- check whether the representation contains 00
- if necessary , transform / construct the value using arithmetic or register operations
- place the resulting bytes in memory
- ensure the machine code representation, not merely the final string is free of nulls

Simply checking the strings isnt enough since one might write assembly that looks like it avoids nulls but the assembler could produce an instruction encoding containing 00. You can inspect the executable using objdump to inspect the bytes and xxd for the shellcode blob

## 3. Character Restrictions
A restricted character set means that the shellcode cannot contains certain bytes values becasue something in the delivery path modifies, truncates or rejects them.
A common special case is the null byte `0x00` because C string functions may intepret it as the end of the input
The restricred character situations  and there reasonsinclude:
- 0x00  = C strings 
- 0x0a = newline terminates input
- 0x0d = carriage return handling
- 0x20 = space separated input
- 0x09 = tab handling
- 0x25 - application specific filtering
- High bytes = ASCII - only transport
This is how shelcode handles the restrictions
(i) Choosing alternative instruction encoding
(ii) Constructing the values at runtime instead of embedding problematic bytes
(iii) Encoding / Decoding the payload - a restricted byte representation can be used as the initial payload, followed by a small decoder that reconstructs the original bytes in memory
(iv) Avoid problematic data entirely - sometimes the restriction affects strings or embedded constants rather than instructions. One can generate the required data dynamically instead of storing it directly

## 4. Register Preservation
It means making sure the shellcode does not unnecessarily destroy CPU register values that the surrounding program may still need.
This matters because shellcode is usually injected into an existing execution context and one does not control what values are already in registers when execution reaches your shellcode
Not every register must be preserved though. This is where the calling conention become important. In System V AMD64 ABI the registers are broadly categorized into:
a) Caller saved :
The called function is allowed to destroy these
- rax
- rcx
- rdx
- rsi
- rdi
- r8 - r11
b) Callee saved:
A function that uses these is expected to restore them before returning 
- rbx
- rbp
- r12 - r15

rsp has its own special requirements because it controls the stack
Stack preservation is also important so the order or pushing and popping should also consider its preservation ( leaving the stack balanced ) leaving the stack unbalanced can cause the eventual ret to fetch the wrong address

## 5. Stack Alignement
It means ensuring that rsp points to an address with the alignment expected by the CPU/ABI when the shellcode executes instruction or calls functions
On x86-64 Linux ( System V ABI ) the important rule is: " Before executing a call, the stack should be 16-byte aligned according to the ABI convention,
And call itself pushes an 8 byte return address so the value of the rsp changes by 8 bytes
Suppose a shellcode:
```asm 
	push ...
	push ...
	call ...
```
every push subtracts 8 bytes from rsp thus if one makes an odd number of pushes one can shift the stack alignment by 8 bytes
If the rsp was aligned before the push , the push changes the alignement then call pushes another 8 bytes thus depending on where you are entering from and what you are calling the alignemnt can be wrong or right.
This can be inspected using GNU GDB:
``` bash 
	p/x $rsp
	p $rsp % 16
```
For pure syscall shellcode , stack alignment is often much less important because you are communicating directly with the kernel
It becomes more important when the shellcode
- calls existing functions
- jumps into compiled code
- uses instructions / instruction sequences requiring particular alignment
- build more complex stack based data structures

## 6. Executable vs Non Executable Memory
A  memory page can have permission such as :
- R = read
- W = write
- X = execute
.text and dynamically allocated memory are explicitly given execute permissions
A non executable memory is a memory withoyt the X flag
Modern systems with NX/DEP normally prevent instruction fetching from a page in memory
This is important in shellcode since simply redirecting RIP is not enough the target memory  must also be executable

## 7. Seccomp Restrictions
Seccomp ( Secure Computing )  is a LInux Kernel Mechanism that restricts which system calls a process can make.
This matters in shellcode since it interacts with the  kernel through syscalls
A seccomp filter can restrict syscalls such as :
- read
- write
- openat
- mmap
- mprotect
- execve
- exit
- clone
- socket
- ptrace
It can also restrict them basedon syscall arguments
A shellcode payload has to operate within the syscall policy imposed on its process.
The seccomp filter can exist in two modes
### (a) Strict Mode
The traditional strict mode permits only a very small set of syscalls, historically centered around
- read
- write
- _exit
- sigreturn
### (b) Filter mode - SECCOMP_MODE_FILTER
It uses a BPF based filter to decide what happens when a syscall is attempted.
The filter can return different action including allowing the syscall, returning an error, killing the process or trapping it.
With this the shellcode development workflow becomes:
- Identifying the architecture
- identifying syscall ABI
- Determining seccomp policy
- Identifying allowed syscalls
- Determining allowed arguments
- Designing functionality arount the constraints
- Testing each syscall independently
Seccomp sits after the syscall instruction reaches the kernel, thus having the correct registers doesn't guarantee the operation will succeed

## 8. Syscall Availability
It means which syscalls the shellcode can actually invoke successfully in the environment where it executes
The syscall can be unavailabale due to the OS , architecture, sandbox or security policy
The architecture determines the syscall interface this makes the shellcode inherently architecture specific unless deliberately designed otherwise.

Architecture | Instruction | Sycall number register
|--------------|-------------|-------------------------
x86-64| syscall | rax
x86| int 0x80 | eax
ARM64| svc #0| x8
ARM32 | svc |r7

Availability doesnt mean the operation will necessarily succeed the kernel can also return an error because of:
- invalid arguments
- invalid address
- insufficient permissions
- nonexistent file
- unavailable resource
- sandbox restrictions
shellcode is designed to operate with very little environment support by interacting directly with the kernel 






















