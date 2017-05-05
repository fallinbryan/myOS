# Automagically generate lists of sources using wildcards
C_SOURCES = $(wildcard ./kernel/*.c ./drivers/*.c)
HEADERS = $(wildcard ./kernel/*.h ./drivers/*.h)
BOOTSECTOR = $(wildcard boot/*.asm)

# TODO: make sources dep on all header files

# Convers the *.c filenames to *.o to give a list object files to build
OBJ = ${C_SOURCES:.c=.o}

#Default build target
all: os-image



# Run qemu to simulate booting
run: all
	qemu-system-i386 -fda os-image

# This is the disk image the the computer loads
# It is the combination of our compiled bootsector and kernel
os-image: boot/boot_sector.bin kernel.bin
	cat $^ > os-image



# This builds the binary of our kernel from two object files:
#	- the kernel_entry, which jumps to main() in the kernel
#	- the compiled C kernel
kernel.bin : kernel/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary -m elf_i386


# Generic rule for compiling C code to an obj file
# For simplicity, the C files depend on all header files
%.o : %.c ${HEADERS}
	gcc -ffreestanding -m32 -c $< -o $@


# Build the kernel entry obj file
kernel/kernel_entry.o : kernel/kernel_entry.asm
	nasm $< -f elf -I ./as/ -o $@
	
	
#%.bin : %.asm{BOOTSECTOR}
boot/boot_sector.bin : boot/boot_sector.asm
	nasm $< -f bin -I ./asm/ -o $@

# Assemble the boot sector to raw machine code
#	the -I option tells nasm where to find our useful assembly
# 	routines that we incldue in boot_sect.asm
#boot_sector.bin : boot_sector.asm
#	nasm $< -f bin -I './asm/' -o $@

# Clean up
clean:
	rm -fr *.bin *.dis *.o os-image *.map
	rm boot/*.bin
	rm kernel/*.o
	rm drivers/*.o
	
# Disassemble the kernel - for debugging purposes
kernel.dis : kernel.bin
	ndisasm -b 32 $< > $@

touch:
	touch kernel/*
	touch drivers/*
	touch boot/*
	touch *
