; boatloader.s
section .boot
global start

bits 16
start:
    mov [ BOOT_DRIVE ], dl
    mov ah, 0x02
    mov al, 4
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [ BOOT_DRIVE ]
    mov bx, 0x7e00
    int 0x13
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    cli
    jmp 0x08:init_pm

BOOT_DRIVE: db 0

; GDT
gdt_start:
    dq 0x0000000000000000
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[bits 32]
init_pm:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov esp, 0x7C00

    jmp BEGIN_PM

BEGIN_PM:
    extern _start
    call _start
.hang:
    jmp .hang

times 510 - ($-$$) db 0
dw 0xAA55
