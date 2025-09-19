#ifndef V_VGA_H
#define V_VGA_H

#include "t_types.h"

//Define cursor character: starting and ending scanline of cursor
// cursor_start: RANGE 0-15; cursor_end RANGE 0-15;
void enablecursor(uint8_t cursor_start, uint8_t cursor_end);

//Disable cursor: Turn off cursor
//NULL
void disable_cursor();

#endif //V_VGA_H