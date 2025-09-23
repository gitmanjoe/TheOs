ENTRY(start)

SECTIONS {
    /* Boot sector at 0x7C00 */
    . = 0x7C00;
    .boot :
    {
        KEEP(*(.boot))
    }

    /* Kernel at 0x7E00 */
    . = 0x7E00;
    .text :
    {
        *(.text*)
    }
    .rodata :
    {
        *(.rodata*)
    }
    .data :
    {
        *(.data*)
    }
    .bss :
    {
        *(.bss*)
        *(COMMON)
    }
}