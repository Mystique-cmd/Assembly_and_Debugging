ASM = nasm
ASFLAGS = -f elf64
CC = gcc
CFLAGS = -Wall -Wextra

TARGET = autoharness
OBJECT = shellcode.o
BINARY = shellcode.bin

.PHONY: all build extract run clean
all: build extract
build: $(OBJECT) $(TARGET)

$(OBJECT):shellcode.asm
	$(ASM) $(ASFLAGS) shellcode.asm -o $(OBJECT)
	
$(TARGET): autoharness.c
	$(CC) $(CFLAGS)  autoharness.c -o $(TARGET)

extract: $(OBJECT)
	objcopy -O binary --only-section=.text $(OBJECT) $(BINARY)
	
run:all
	./$(TARGET)
clean:
	rm -f $(OBJECT) $(BINARY) $(TARGET)
