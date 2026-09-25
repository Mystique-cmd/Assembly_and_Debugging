A system call is a mechanism  by which user space code request services from the OS kernel.
# Linux x86-64
Linux exposes a syscall interface directly to user space
The basic instruction is:
```asm
	syscall
```
## Linux syscall ABI
It is the contract between your user space program and the Linux kernel when you execute the syscall function
Before executing syscall
Register | Purpose
----------|---------
rax | syscall number
rdi | arg1
rsi | arg2
rdx | arg3
r10 | arg4
r8 | arg5
r9 | arg6
rax | return value
Why r10 and not rcx?
This is one of the most important differences between the normal x86-64 function calling convention and the Linux syscall ABI. The aboveis for Linux syscalls but for System V they are:
- rdi
- rsi
- rdx
- rcx
- r8
- r9
The reason for this is that the syscall itself clobbers rcx and r11
The CPU puts the return address in rcx and saves flags in r11.

## libc and syscall relationship
Libc is a user space library sitting between the application and the kernel
The relationship is basically :
program > libc > syscall > kernel
The libc translates the C function interface into the Linux syscall ABI. It may then translate kernel error conventions into the C/POSIX interface
# Windows
Normal windows applications generally don't nvoke kernel services through Linux-style public sycall inter
face
The architecture is as follows:
Application > Win32 API > Windows DLLs > Native API / NT Layer > System call >  Windows Kernel
Note: Win32 API is not a syscall
The actual kernel  transition occurs deeper in the stack.
On modern 64-bit Windows , the relevant transition instruction is :
```asm
	syscall
```
The exact  implementation and surrounding details vary by Windows version and architecture, so one should not treat syscall numbers as stable constants the way one might with a particular Linux syscall table.

## Windows-NT API
It is the lower level native interface exposed by the `ntdll.dll`
It sits below the Win32 API and is much closer to the Windows Kernel
The NT API functions commonly have names like:
- NtCreateFile
- NtReadFile
- NtWriteFile
- NtClose
- NtAllocateVirtualMemory
- NtProtectVirtualMemory
- NtCreateProcess
- NtCreateThreadEx
- NtQueryInformationProcess
- NtQuerySystemInformation
There are also Zw* variants
From the user mode Nt* and Zw* generally enter the same native system-service mechanism, there disticntion becomes more significant inside kernel mode code
