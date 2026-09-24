#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char **argv)
{
	const char *path = argc > 1 ? argv[1] : "shellcodeV1.0.1.bin";
	int file = open(path, O_RDONLY);
	struct stat file_info;
	unsigned char *shellcode;
	size_t file_size;
	
	if (file == -1 || fstat(file, &file_info) == -1) {
		perror("open");
		return 1;
	}
	file_size = (size_t)file_info.st_size;
	
	if (file_size == 0) {
		fprintf(stderr, "[-] Invalid Shellcode Size\n");
		close(file);
		return 1;
	}
	printf("[+] Shellcode size: %zu bytes\n", file_size);
	
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
		close(file);
		return 1;
	}
	
	if (read(file, shellcode, file_size) != (ssize_t)file_size) {
		perror("read");
		munmap(shellcode, file_size);
		close(file);
		return 1;
	}
	
	close(file);
	printf("[+] Shellcode loaded at %p \n", (void *)shellcode);
	printf("[+] Executing Shellcode....\n");
	
	// Actual data to code transition
	void (*execute_shellcode)(void) = (void (*)(void))shellcode;
	execute_shellcode();
	
	printf("[+] Shellcode returned\n");
	munmap(shellcode, file_size);
	return 0;
	
}
