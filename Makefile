UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
    CC = gcc
    ASMC = nasm
    LD = ld
    CAT = cat
    OBJCPY = objcopy
    STAT = stat -c%s
    DD = dd
    LDFLAGS = -m elf_i386 -T linker.ld
endif
# No need for Windows support

BUILDDIR := bin

CFLAGS = -Wall -m32 -ffreestanding -fno-pic -fno-pie
ASMFLAGS = -f elf32
BOOTLOADERFLAGS = -f elf32

BOOTLOADER = bootloader.s
LINKER_SCRIPT = linker.ld

C_SOURCES := $(wildcard *.c)
ASM_SOURCES := $(filter-out $(BOOTLOADER), $(wildcard *.s))

C_OBJECTS := $(patsubst %.c,$(BUILDDIR)/%.o,$(C_SOURCES))
ASM_OBJECTS := $(patsubst %.s,$(BUILDDIR)/%.o,$(ASM_SOURCES))
BOOTLOADER_OBJ := $(BUILDDIR)/$(BOOTLOADER:.s=.o)

KERNEL_TMP := $(BUILDDIR)/kernel.tmp
KERNEL_BIN := $(BUILDDIR)/kernel.bin

OS_IMAGE := $(BUILDDIR)/TheOS.img

SECTOR_SIZE := 512

all: $(OS_IMAGE)

#Create build directory
$(BUILDDIR):
	mkdir -p $(BUILDDIR)

#Assemble bootloader
$(BOOTLOADER_OBJ): $(BOOTLOADER) | $(BUILDDIR)
	$(ASMC) $(BOOTLOADERFLAGS) $< -o $@

#Compile C sources
$(BUILDDIR)/%.o: %.c | $(BUILDDIR)
	$(CC) $(CFLAGS) -c $< -o $@

#Assemble assembly sources
$(BUILDDIR)/%.o: %.s | $(BUILDDIR)
	$(ASMC) $(ASMFLAGS) $< -o $@

#Link bootloader + kernel
$(KERNEL_TMP): $(BOOTLOADER_OBJ) $(C_OBJECTS) $(ASM_OBJECTS) | $(BUILDDIR)
	$(LD) $(LDFLAGS) -o $@ $^

#Extract binary from ELF
$(KERNEL_BIN): $(KERNEL_TMP) | $(BUILDDIR)
	$(OBJCPY) -O binary $< $@

#Create OS image (just the kernel.bin now, includes bootloader)
$(OS_IMAGE): $(KERNEL_BIN) | $(BUILDDIR)
	$(CAT) $^ > $@
	@echo Image built: $(OS_IMAGE)

clean:
	rm -rf $(BUILDDIR)

run: $(OS_IMAGE)
	qemu-system-x86_64 -drive file=$(OS_IMAGE),format=raw -nographic -monitor tcp:127.0.0.1:55555,server,nowait