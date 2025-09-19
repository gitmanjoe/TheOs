#ifndef P_PORT_H
#define P_PORT_H

#include "t_types.h"

//Output on port: put specified byte on specified port 
// port: RANGE 0-65535; value RANGE 0-255;
void outb(uint16_t port, uint8_t value);

//Read port: Return value at specified port 
// port: RANGE 0-65535;
uint16_t inb(uint32_t port);

#endif //P_PORT_H