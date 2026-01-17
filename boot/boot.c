void kmain(void) {
    volatile char* vga = (volatile char*)0xB8000;
    const char* msg = "HELLO FROM C";
    for (int i = 0; msg[i]; i++) {
        vga[i*2] = msg[i];       // character
        vga[i*2+1] = 0x0F;       // color attribute (white on black)
    }
    while(1);  // loop forever
}