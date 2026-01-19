#ifndef VGA_H
#define VGA_H

#include <stdint.h>

// VGA Width/Height
#define VGA_WIDTH  80
#define VGA_HEIGHT 25

// Space in memory
#define VGA_MEMORY ((volatile uint16_t*)0xB8000)

// Black and white helpers
#define VGA_COLOR_BLACK 0x0
#define VGA_COLOR_WHITE 0xF

// VGA Helpers
void vga_clear(void);
void vga_putc(char c, uint8_t color);
void vga_print(const char* s, uint8_t color);

#endif
