#ifndef P_PORT_H
#define P_PORT_H

#include "t_types.h"

enum ports {
    COM1 = 0x3F8,
    COM2 = 0x2F8,
    COM3 = 0x3E8,
    COM4 = 0x2E8,
    COM5 = 0x5F8,
    COM6 = 0x4F8,
    COM7 = 0x5E8,
    COM8 = 0x4E8,
};

//Output to port
//port: RANGE 0-65535; value: RANGE 0-255;
void outb(uint16_t port, uint8_t value);

//Read port
//port: RANGE 0-65535;
uint16_t inb(uint32_t port);

#endif //P_PORT_H