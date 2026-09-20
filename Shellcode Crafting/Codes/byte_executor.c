#include <stdio.h>
#include <string.h>
#include <sys/mman.h>

//The output from the command xxd -i exit.bin that makes the bytes to C-style

unsigned char exit_bin[] = {
  0xb8, 0x3c, 0x00, 0x00, 0x00, 0xbf, 0x00, 0x00, 0x00, 0x00, 0x0f, 0x05
};

int main(void)
{
	void *mem = mmap(
		NULL,
		sizeof(exit_bin),
		PROT_READ | PROT_WRITE | PROT_EXEC,
		MAP_PRIVATE | MAP_ANONYMOUS,
		-1,
		0
	);
	
	memcpy(mem, exit_bin, sizeof(exit_bin));
	
	void(*shellcode)(void) = mem;
	shellcode();
	
	return 0;
}
