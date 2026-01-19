BUILD := build
BIN   := $(BUILD)/bin
IMG   := $(BIN)/img

BOOT1_SRC := arch/x86/boot/boot.asm
BOOT2_SRC := arch/x86/boot/boot2.asm
GDT_SRC := arch/x86/boot/gdt_descriptor.asm
PM_SRC := arch/x86/boot/pm_entry.asm
KERNEL_SRC := arch/x86/boot/boot.c
VGA_SRC := shared/vga.c

BOOT1_BIN := $(BIN)/boot.bin
BOOT2_O   := $(BIN)/boot2.o
KERNEL_O  := $(BIN)/kernel.o
GDT_O := $(BIN)/gdt.o
PM_O := $(BIN)/pm.o
BOOT_FULL_BIN := $(BIN)/boot_full.bin
MAIN_IMG  := $(IMG)/main.img
VGA_O := $(BIN)/vga.o

NASM := nasm
GCC  := gcc
LD   := ld
QEMU := qemu-system-x86_64

all: $(MAIN_IMG)
	$(QEMU) -drive format=raw,file=$(MAIN_IMG)

$(BIN):
	mkdir -p $(BIN)
$(IMG):
	mkdir -p $(IMG)

$(BOOT1_BIN): $(BOOT1_SRC) | $(BIN)
	$(NASM) -f bin $< -o $@

$(BOOT2_O): $(BOOT2_SRC) | $(BIN)
	$(NASM) -f elf32 $< -o $@

$(GDT_O): $(GDT_SRC) | $(BIN)
	$(NASM) -f elf32 $< -o $@

$(PM_O): $(PM_SRC) | $(BIN)
	$(NASM) -f elf32 $< -o $@

$(KERNEL_O): $(KERNEL_SRC) $(VGA_O) | $(BIN)
	$(GCC) -m32 -ffreestanding -fno-pic -fno-pie -O0 -c $< -o $@

$(VGA_O): $(VGA_SRC) $(STR_HELPERS) | $(BIN)
	$(GCC) -m32 -ffreestanding -fno-pic -fno-pie -O0 -c $< -o $@

$(BOOT_FULL_BIN): $(BOOT2_O) $(GDT_O) $(PM_O) $(KERNEL_O)
	$(LD) -m elf_i386 -Ttext 0x7E00  -e pm_entry --oformat binary -o $(BOOT_FULL_BIN) $(BOOT2_O) $(GDT_O) $(PM_O) $(KERNEL_O) $(VGA_O)

$(MAIN_IMG): $(BOOT1_BIN) $(BOOT_FULL_BIN) | $(IMG)
	cat $(BOOT1_BIN) $(BOOT_FULL_BIN) > $(MAIN_IMG)

clean:
	rm -rf $(BUILD)
