#include "../../../shared/vga.h"

// Boot main (C)
// TODO:
// Connenct to Kernel via inline ASM (C)
void bmain(void)
{
    vga_clear();
    vga_print("HELLO FROM KERNEL", 0x0F);
    for (;;);
}
