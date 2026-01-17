BUILD := build
BIN   := $(BUILD)/bin
IMG   := $(BIN)/img/

BOOT_SRC := boot/boot.asm
BOOT2_SRC := boot/boot2.asm
BOOT_BIN := $(BIN)/boot.bin
BOOT2_BIN := $(BIN)/boot2.bin
MAIN_IMG := $(IMG)/main.img

NASM := nasm
QEMU := qemu-system-x86_64
QEMU_FORMAT := raw
CAT := cat

all: clean $(BOOT_BIN) qemu

$(IMG):
	mkdir -p $(IMG)

$(BOOT_BIN): $(BOOT_SRC) | $(IMG)
	$(NASM) -f bin $(BOOT_SRC) -o $(BOOT_BIN)
	$(NASM) -f bin $(BOOT2_SRC) -o $(BOOT2_BIN)
	$(CAT) $(BOOT_BIN) $(BOOT2_BIN) > $(MAIN_IMG)

clean:
	rm -rf $(BUILD)

qemu: $(MAIN_IMG)
	$(QEMU) -drive format=$(QEMU_FORMAT),file=$(MAIN_IMG)
