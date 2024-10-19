#!/bin/bash

# Create the build directory if it doesn't exist
if [ ! -d "../build" ]; then
  mkdir ../build
fi

# Padding the os_image.img file to 1.44MB
dd if=/dev/zero bs=512 count=2880 of=../build/os_image.img
dd if=../build/os_image.img bs=512 conv=notrunc seek=0 count=2880

# Move boot binary and kernel binary into os_image.img
cat ../boot/boot.bin ../build/kernel.bin > ../build/os_image.img

# Create an ISO file
xorriso -as mkisofs -b os_image.img -no-emul-boot -boot-load-size 4 -boot-info-table -o ../build/os_image.iso ../build/os_image.img

if [ $? -eq 0 ]; then
  echo "ISO successfully created."
else
  echo "Error creating ISO."
  exit 1
fi
