#include "vga.h"

int vga_column = 0;
int vga_row = 0;

void outb(uint16_t port, uint8_t val)
{
    asm volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

void set_cursor(int x, int y)
{
    uint16_t pos = y * 80 + x;
    outb(VGA_CURSOR_PORT_INDEX, 0x0F);
    outb(VGA_CURSOR_PORT_DATA, pos & 0xFF);
    outb(VGA_CURSOR_PORT_INDEX, 0x0E);
    outb(VGA_CURSOR_PORT_DATA, (pos >> 8) & 0xFF);
}

void reset_cursor(void)
{
    set_cursor(0, 0);
}

void print(int color, const char* msg)
{
    reset_cursor();
    volatile char* vga = (volatile char*)0xB8000;
    int i;
    for (i = 0; msg[i]; i++) {
    
        vga[i * 2] = msg[i];
        vga[i * 2 + 1] = color;
    }
}

void clear_screen(void)
{
    for (int r = 0; r < VGA_HEIGHT; r++)
    {
        for (int c = 0; c < VGA_WIDTH; c++)
        {
            volatile char* vga = VGA_MEMORY + (r * VGA_WIDTH + c) * 2;
            vga[0] = ' ';
            vga[1] = 0x0F;
        }
    }
    reset_cursor();
}