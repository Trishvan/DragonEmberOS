; Bootloader - Switch to Long Mode
bits 16
[org 0x7c00]

start:
    cli                       ; Disable interrupts
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00            ; Set up stack

    ; Enable A20 line (necessary for protected mode)
    in al, 0x92
    or al, 00000010b
    out 0x92, al

    ; Load GDT
    lgdt [gdt_descriptor]

    ; Enter Protected Mode
    mov eax, cr0
    or eax, 1                 ; Set the PE (Protection Enable) bit
    mov cr0, eax

    jmp CODE_SEG:init_pm       ; Far jump to 32-bit code segment

[bits 32]
init_pm:
    ; Set up segment registers for protected mode
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Switch to Long Mode
    mov ecx, 0xC0000080        ; Read Extended Feature Enable Register (EFER)
    rdmsr
    or eax, 0x00000100         ; Set Long Mode Enable bit
    wrmsr

    mov eax, cr4
    or eax, 0x20               ; Enable PAE (Physical Address Extension)
    mov cr4, eax

    ; Enable Long Mode
    mov eax, cr0
    or eax, 0x80000001         ; Enable Paging and Protection Mode
    mov cr0, eax

    ; Load 64-bit kernel
    jmp 0x28:kernel_start      ; Jump to Long Mode code at CODE_SEG descriptor

[bits 64]
kernel_start:
    ; 64-bit kernel starts here
    hlt                        ; Hang the system

; GDT definition
align 8
gdt_start:
    dq 0                       ; Null descriptor
    dq 0x00AF9A000000FFFF       ; Code Segment descriptor (64-bit code segment)
    dq 0x00AF92000000FFFF       ; Data Segment descriptor (64-bit data segment)

gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; GDT size
    dd gdt_start                ; GDT base address
gdt_end:

; Define segment selectors
CODE_SEG equ 0x08              ; Code segment offset in GDT
DATA_SEG equ 0x10              ; Data segment offset in GDT

times 510 - ($ - $$) db 0       ; Pad to 512 bytes
dw 0xAA55                       ; Boot signature
