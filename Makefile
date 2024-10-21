# Define directories
SRC_DIR = src
BUILD_DIR = build
ISO_DIR = isodir
GRUB_DIR = $(ISO_DIR)/boot/grub

# Targets
all: os_image

os_image: $(BUILD_DIR)/kernel.bin
	mkdir -p $(GRUB_DIR)
	cp boot/grub.cfg $(GRUB_DIR)/
	cp $(BUILD_DIR)/kernel.bin $(ISO_DIR)/boot/
	grub-mkrescue -o $(BUILD_DIR)/os_image.iso $(ISO_DIR)

$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/kernel.o $(BUILD_DIR)/screen.o $(BUILD_DIR)/cli.o $(BUILD_DIR)/string.o
	ld -m elf_x86_64 -o $(BUILD_DIR)/kernel.bin -T link.ld $(BUILD_DIR)/kernel.o $(BUILD_DIR)/screen.o $(BUILD_DIR)/cli.o $(BUILD_DIR)/string.o

$(BUILD_DIR)/kernel.o: $(SRC_DIR)/kernel.cpp
	g++ -m64 -ffreestanding -Iinclude -c $(SRC_DIR)/kernel.cpp -o $(BUILD_DIR)/kernel.o

$(BUILD_DIR)/screen.o: $(SRC_DIR)/screen.cpp include/screen.h
	g++ -m64 -ffreestanding -Iinclude -c $(SRC_DIR)/screen.cpp -o $(BUILD_DIR)/screen.o

$(BUILD_DIR)/cli.o: $(SRC_DIR)/cli.cpp include/cli.h
	g++ -m64 -ffreestanding -Iinclude -c $(SRC_DIR)/cli.cpp -o $(BUILD_DIR)/cli.o

$(BUILD_DIR)/string.o: $(SRC_DIR)/string.cpp include/string.h
	g++ -m64 -ffreestanding -Iinclude -c $(SRC_DIR)/string.cpp -o $(BUILD_DIR)/string.o

clean:
	rm -rf $(BUILD_DIR)/*.o $(BUILD_DIR)/*.bin $(BUILD_DIR)/*.iso $(ISO_DIR)
