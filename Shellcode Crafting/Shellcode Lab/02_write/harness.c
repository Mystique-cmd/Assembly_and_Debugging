#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>

int main(void)
{
	FILE *file;
	unsigned char *shellcode;
	long file_size;
	
	//Openomg the raw shellcode file
	file = fopen("shellcodeV.1.0.1.bin", "rb");
	if ( file == NULL){
		perror("fopen");
		return 1;
	}
	
	// Determine the size of the shellcode
	fseek ( file, 0, SEEK_END);
	file_size = ftell(file);
	rewind(file);
	
	if ( file_size <= 0){
		fprintf(stderr, "[-] Invalid Shellcode Size\n");
		fclose(file);
		return 1;
	}
	printf("[+] Shellcode size: %ld bytes \n", file_size);
	
	//Allocate executable memory
	shellcode = mmap(
		NULL,
		file_size,
		PROT_READ | PROT_WRITE | PROT_EXEC,
		MAP_PRIVATE | MAP_ANONYMOUS,
		-1,
		0
	);
	if (shellcode == MAP_FAILED){
		perror("mmap");
		fclose(file);
		return 1;
	}
	
	// Load shellcodeV1.0.1.bin into executable memory
	if (fread(shellcode, 1, file_size, file) != (size_t)file_size){
		perror("fread");
		munmap(shellcode, file_size);
		fclose(file);
		return 1;
	}
	
	fclose(file);
	printf("[+] Shellcode loaded at %p \n", (void *)shellcode);
	printf("[+] Executing Shellcode....\n");
	
	// Actual data to code transition
	void (*execute_shellcode)(void) = (void (*)(void))shellcode;
	execute_shellcode();
	
	printf("[+] Shellcode returned \n");
	munmap(shellcode, file_size);
	return 0;
	
}
