BITS 16                    ; Start in 16-bit mode
org 0x7c00                 ; BIOS loads the bootloader here

start:
    cli                    ; Disable interrupts
    xor ax, ax             ; Clear AX register
    mov ds, ax             ; Set data segment to zero
    mov es, ax             ; Set extra segment to zero
    mov ss, ax             ; Set stack segment to zero
    mov sp, 0x7c00         ; Set stack pointer

    ; Load the kernel
    call load_kernel
    jmp $                   ; Infinite loop

load_kernel:
    ; Load kernel from disk (assuming kernel is on sectors 2 and 3)
    mov bx, 0x1000         ; Load kernel to address 0x1000
    mov ah, 0x02           ; BIOS function: read sectors
    mov al, 0x02           ; Number of sectors to read (2 sectors)
    mov ch, 0x00           ; Cylinder number
    mov cl, 0x02           ; Sector number (start at sector 2)
    mov dh, 0x00           ; Head number
    mov dl, 0x80           ; Drive number (0x80 = first hard drive)
    int 0x13               ; Call BIOS interrupt to read from disk
    jc disk_error           ; Jump if carry flag is set (read error)

    ret                     ; Return from load_kernel

disk_error:
    hlt                    ; Halt the system if an error occurs

times 510 - ($ - $$) db 0  ; Fill remaining space to make 512 bytes
dw 0xaa55                  ; Boot signature
