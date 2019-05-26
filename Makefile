MAKEFLAGS += --silent

CC = gcc
C_FLAGS = -g -ffreestanding -fno-PIC -Wall -Wextra -m32

LD = ld
LD_FLAGS = -Ttext=0x1000 --oformat=binary -melf_i386

AS = nasm

C_SOURCES = $(wildcard src/kernel/*.c src/kernel/drivers/*.c)
C_OBJECTS = $(subst src/,out/, $(subst .c,.o, ${C_SOURCES}))


# Standard
all: out/os.bin


# Run
run:
	qemu-system-x86_64 -fda out/os.bin

run-curses:
	qemu-system-x86_64 -fda out/os.bin -curses


# Bootloader
out/bootloader.bin: src/bootloader/bootloader.asm
	${AS} -i src/bootloader/ -f bin -o $@ $<


# Kernel
out/kernel_entry.elf: src/kernel/kernel_entry.asm
	${AS} -i src/kernel/ -f elf -o $@ $<

${C_OBJECTS}: ${C_SOURCES}
	mkdir -p $(dir $@)
	${CC} ${C_FLAGS} -o $@ -c $(subst out/, src/, $(subst .o,.c, $@))

out/kernel.bin: out/kernel_entry.elf ${C_OBJECTS}
	${LD} ${LD_FLAGS} -o $@ $^


# OS Image
out/os.bin: out/bootloader.bin out/kernel.bin
	cat $^ > $@


# Clean
clean:
	rm -rf out/*