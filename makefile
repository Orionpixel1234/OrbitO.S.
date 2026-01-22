BUILD := build
BIN   := $(BUILD)/bin

BOOT_SRC := arch/x86/boot/boot.asm

CC := gcc
AS := nasm
LD := ld

CFLAGS := -m32 -ffreestanding -fno-pie -O0
ASFLAGS := -f elf32

include arch/x86/Makefile

all: qemu-system-x86_64 -drive format=raw,file=$(BIN)/boot.bin
