BITS 64
org 0x7c00

start:
    ; Switch to 64-bit mode
    ; Setup the stack and call the kernel
    ; More setup code can go here

    ; Jump to the kernel
    jmp kernel_main

kernel_main:
    ; Your kernel's main code goes here
    ; For example, initializing the screen or CLI
    jmp $

times 510 - ($ - $$) db 0
dw 0xaa55
