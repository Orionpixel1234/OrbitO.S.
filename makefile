BUILD := build
BIN   := $(BUILD)/bin
IMG   := $(BIN)/img

BOOT1_SRC := boot/boot.asm
BOOT2_SRC := boot/boot2.asm
KERNEL_SRC := boot/boot.c

BOOT1_BIN := $(BIN)/boot.bin
BOOT2_O   := $(BIN)/boot2.o
KERNEL_O  := $(BIN)/kernel.o
STAGE2_BIN := $(BIN)/stage2.bin
MAIN_IMG  := $(IMG)/main.img

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

$(KERNEL_O): $(KERNEL_SRC) | $(BIN)
	$(GCC) -m32 -ffreestanding -fno-pic -fno-pie -O2 -c $< -o $@

$(STAGE2_BIN): $(BOOT2_O) $(KERNEL_O)
	$(LD) -m elf_i386 -Ttext 0x7E00 -e pm_entry --oformat binary -o $@ $(BOOT2_O) $(KERNEL_O)

$(MAIN_IMG): $(BOOT1_BIN) $(STAGE2_BIN) | $(IMG)
	cat $(BOOT1_BIN) $(STAGE2_BIN) > $(MAIN_IMG)

clean:
	rm -rf $(BUILD)
