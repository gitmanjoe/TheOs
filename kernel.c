#include <stdint.h>
#include "types.h"

//TEST CODE!!!!! REMOVE ALL OF THIS AFTER!!!!!!!!!

#define VIDEO_MEMORY ((uint16_t*)0xB8000)
#define SCREEN_WIDTH 80

void print_char(char c, int x, int y, uint8_t color) {
    uint16_t *pos = VIDEO_MEMORY + y * SCREEN_WIDTH + x;
    *pos = (uint16_t)c | ((uint16_t)color << 8);
}

void kernel() {
    print_char('P', 0, 0, 0x0F);
    print_char('E', 0, 0, 0x0F);
    print_char('N', 0, 0, 0x0F);
    print_char('I', 0, 0, 0x0F);
    print_char('S', 0, 0, 0x0F);
    print_char(' ', 0, 0, 0x0F);
    print_char('P', 0, 0, 0x0F);
    print_char('A', 0, 0, 0x0F);
    print_char('R', 0, 0, 0x0F);
    print_char('S', 0, 0, 0x0F);
    print_char('E', 0, 0, 0x0F);
    print_char('R', 0, 0, 0x0F);
}