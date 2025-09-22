#ifndef V_VGA_H
#define V_VGA_H

#include "t_types.h"

//Define cursor character
//cursor_start: scanline that cursor starts, RANGE 0-15; cursor_end: scanline that cursor starts, RANGE 0-15;
void enablecursor(uint8_t cursor_start, uint8_t cursor_end);

//Disable cursor
//NULL
void disable_cursor();

#endif //V_VGA_H