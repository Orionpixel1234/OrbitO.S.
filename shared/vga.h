#include <stdint.h>
#include "helpers/libc/strings.h"

#define VGA_WIDTH  80
#define VGA_HEIGHT 25
#define VGA_MEMORY ((volatile char*)0xB8000)
#define VGA_CURSOR_PORT_INDEX 0x3D4
#define VGA_CURSOR_PORT_DATA  0x3D5
extern int vga_column;
extern int vga_row;

void outb(uint16_t port, uint8_t val);
void set_cursor(int x, int y);
void reset_cursor(void);
void clear_screen(void);
void print(int color, const char *string);

