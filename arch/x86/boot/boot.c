#include "../../../shared/vga.h"


void bmain(void) {
    clear_screen();
    print(0x09, "Test");
    while (1);
}
