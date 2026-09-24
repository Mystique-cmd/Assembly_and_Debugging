#include <stdio.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(void)
{
	int file = open("shellcode.bin", O_RDONLY);
	struct stat file_info;
	if (file == -1 || fstat(file, &file_info) == -1) {
		perror("open");
		return 1;
	}
	size_t size = (size_t)file_info.st_size;
	unsigned char *shellcode = mmap(NULL, size, PROT_READ | PROT_WRITE | PROT_EXEC,
		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (shellcode == MAP_FAILED) {
		perror("mmap");
		return 1;
	}
	if (read(file, shellcode, size) != (ssize_t)size) {
		perror("read");
		return 1;
	}
	close(file);
	((void (*)(void))shellcode)();
	return 0;
}
