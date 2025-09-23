#include <stdint.h>
#include <stdbool.h>
#include "p_port.h"
#include "p_serial.h"
#include "t_types.h"

//TEST CODE!!!!! REMOVE ALL OF THIS AFTER!!!!!!!!!

#define VIDEO_MEMORY ((uint16_t*)0xB8000)
#define SCREEN_WIDTH 80

void print_char(char c, int x, int y, uint8_t color) {
    uint16_t *pos = VIDEO_MEMORY + y * SCREEN_WIDTH + x;
    *pos = (uint16_t)c | ((uint16_t)color << 8);
}

void kernel() {

    initserial(COM1);

    print_char('P', 0, 0, 0x0F);
    print_char('E', 1, 0, 0x0F);
    print_char('N', 2, 0, 0x0F);
    print_char('I', 3, 0, 0x0F);
    print_char('S', 4, 0, 0x0F);
    print_char(' ', 5, 0, 0x0F);
    print_char('P', 6, 0, 0x0F);
    print_char('A', 7, 0, 0x0F);
    print_char('R', 8, 0, 0x0F);
    print_char('S', 9, 0, 0x0F);
    print_char('E', 10, 0, 0x0F);
    print_char('R', 11, 0, 0x0F);

    serialwrite(COM1, "TheOS Version 0.1\n(c) 2025 Benjamin Zdunich, Justin Bustin");
    while(true) {
        serialwritechar(COM1, serialread(COM1));
    }
    
}

void _start() {
    kernel();
}