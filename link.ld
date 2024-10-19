OUTPUT_FORMAT(elf64-x86-64)
ENTRY(start)

SECTIONS {
    . = 0x100000;  /* Load kernel at address 1MB */

    .text : {
        *(.text)   /* Code section */
    }

    .rodata : {
        *(.rodata*) /* Read-only data section */
    }

    .data : {
        *(.data)   /* Initialized data section */
    }

    .bss : {
        *(.bss)    /* Uninitialized data section */
    }

    /DISCARD/ : {
        *(.eh_frame) /* Discard exception handling info */
    }
}
