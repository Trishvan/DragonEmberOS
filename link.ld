OUTPUT_FORMAT(elf64-x86-64)
ENTRY(kernel_start)

SECTIONS
{
    . = 0x100000;          /* Load kernel at address 1MB */

    .text : {
        *(.text)           /* Code section */
    }

    .rodata : {
        *(.rodata*)        /* Read-only data */
    }

    .data : {
        *(.data)           /* Initialized data */
    }

    .bss : {
        *(.bss)            /* Uninitialized data */
    }

    /DISCARD/ : {
        *(.eh_frame)       /* Discard exception handling */
    }
}
