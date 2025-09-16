UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
    CC = gcc
    ASMC = nasm
    LD = ld
    CAT = cat
    OBJCPY = objcopy
    STAT = stat -c%s
    DD = dd
    LDFLAGS = -Ttext 0x7e00 -m elf_i386
endif
# No need for Windows support

BUILDDIR := bin

CFLAGS = -Wall -m32 -ffreestanding -fno-pic -fno-pie
ASMFLAGS = -f elf
BOOTLOADERFLAGS = -f bin

BOOTLOADER = bootloader.s

C_SOURCES := $(wildcard *.c)
ASM_SOURCES := $(filter-out $(BOOTLOADER), $(wildcard *.s))

C_OBJECTS := $(patsubst %.c,$(BUILDDIR)/%.o,$(C_SOURCES))
ASM_OBJECTS := $(patsubst %.s,$(BUILDDIR)/%.o,$(ASM_SOURCES))

BOOTLOADER_BIN := $(BUILDDIR)/$(BOOTLOADER:.s=.bin)

KERNEL_TMP := $(BUILDDIR)/kernel.tmp
KERNEL_BIN := $(BUILDDIR)/kernel.bin
PADDING := $(BUILDDIR)/padding.bin

OS_IMAGE := $(BUILDDIR)/TheOs.img

SECTOR_SIZE := 512

all: $(OS_IMAGE)

#Create build directory
$(BUILDDIR):
	mkdir -p $(BUILDDIR)

#Assemble bootloader
$(BOOTLOADER_BIN): $(BOOTLOADER) | $(BUILDDIR)
	$(ASMC) $(BOOTLOADERFLAGS) $< -o $@

#Compile C sources
$(BUILDDIR)/%.o: %.c | $(BUILDDIR)
	$(CC) $(CFLAGS) -c $< -o $@

#Assemble assembly sources
$(BUILDDIR)/%.o: %.s | $(BUILDDIR)
	$(ASMC) $(ASMFLAGS) $< -o $@

#Link kernel
$(KERNEL_TMP): $(C_OBJECTS) $(ASM_OBJECTS) | $(BUILDDIR)
	$(LD) $(LDFLAGS) -o $@ $^

#Extract binary from ELF
$(KERNEL_BIN): $(KERNEL_TMP) | $(BUILDDIR)
	$(OBJCPY) -O binary -j .text -j .data -j .rodata $< $@

#Create padding.bin
$(PADDING): | $(BUILDDIR)
	dd if=/dev/zero of=$@ bs=1 count=8264 2>/dev/null

#Create OS image
$(OS_IMAGE): $(BOOTLOADER_BIN) $(KERNEL_BIN) $(PADDING) | $(BUILDDIR)
	$(CAT) $^ > $@
	@echo Image built: $(OS_IMAGE)

clean:
	rm -rf $(BUILDDIR)
