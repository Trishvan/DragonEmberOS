#!/bin/bash

# Variables
BOOT_IMG="../build/os_image.img"
PADDING_IMG="../build/padded.img"
ISO_FILE="../build/os_image.iso"
BOOT_BIN="../boot/boot.bin"  # Bootloader binary
KERNEL_BIN="../build/kernel.bin"  # Kernel binary to be appended

# Padding size for a 1.44MB image
PADDING_SIZE=$((1440 * 1024))  # 1.44MB in bytes

# Create a padded image (empty sectors filled with zeros to match 1.44MB)
echo "Padding the boot image to 1.44MB..."
dd if=/dev/zero bs=1 count=$PADDING_SIZE of="$PADDING_IMG"

# Concatenate boot.bin and kernel.bin into the final padded image
cat "$BOOT_BIN" "$KERNEL_BIN" > "$BOOT_IMG"

# Pad the final image to 1.44MB
dd if="$BOOT_IMG" of="$PADDING_IMG" conv=notrunc bs=1 count=$PADDING_SIZE

# Replace the boot image with the padded one
mv "$PADDING_IMG" "$BOOT_IMG"

# Create the ISO file
echo "Creating ISO file..."
xorriso -as mkisofs -r -J -b os_image.img -no-emul-boot -boot-load-size 4 -boot-info-table -o "$ISO_FILE" ../build/

# Clean up
echo "Cleaning up..."
rm "$PADDING_IMG"

echo "Done! The ISO file is: $ISO_FILE"
