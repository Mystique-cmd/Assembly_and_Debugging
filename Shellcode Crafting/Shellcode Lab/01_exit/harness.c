#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>

unsigned char shellcode[] = {
	0xb8, 0x3c, 0x00, 0x00, 0x00,
	 0xbf, 0x2a, 0x00, 0x00, 0x00,
	 0x0f, 0x05
};

int main(void)
 {
	size_t size = sizeof(shellcode);
	void *mem = mmap(
		NULL,
		size,
		PROT_READ | PROT_WRITE | PROT_EXEC,
		MAP_PRIVATE | MAP_ANONYMOUS,
		-1,
		0
	);
	
	if(mem == MAP_FAILED){
		perror("mmap");
		return 1;
	}
	
	memcpy(mem, shellcode, size);
	void(*execute)(void) = mem;
	execute();
	return 0;
}
