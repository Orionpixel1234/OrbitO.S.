#include "vga.h"

// Cursor row/column
static uint16_t cursor_row = 0;
static uint16_t cursor_col = 0;

// Print 1 character to VGA
static inline uint16_t vga_entry(char c, uint8_t color)
{
    return (uint16_t)c | ((uint16_t)color << 8);
}

// Clear VGA
void vga_clear(void)
{
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        VGA_MEMORY[i] = vga_entry(' ', VGA_COLOR_WHITE);
    }

    cursor_row = 0;
    cursor_col = 0;
}

// Better printing stuff to VGA
void vga_putc(char c, uint8_t color)
{
    if (c == '\n') {
        cursor_col = 0;
        cursor_row++;
        return;
    }

    VGA_MEMORY[cursor_row * VGA_WIDTH + cursor_col] =
        vga_entry(c, color);

    cursor_col++;

    if (cursor_col >= VGA_WIDTH) {
        cursor_col = 0;
        cursor_row++;
    }
}

// Print a string
void vga_print(const char* s, uint8_t color)
{
    for (int i = 0; s[i]; i++) {
        vga_putc(s[i], color);
    }
}
