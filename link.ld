ENTRY(start)

SECTIONS
{
    /* Start the kernel at 1MB (0x100000) */
    . = 0x100000;

    .text : {
        *(.text)
    }

    .rodata : {
        *(.rodata)
    }

    .data : {
        *(.data)
    }

    .bss : {
        *(.bss COMMON)
        . = ALIGN(4);
    }
}
