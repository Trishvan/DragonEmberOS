all: os_image

os_image: boot/boot.bin kernel.bin
	cat boot/boot.bin kernel.bin > os_image.img

boot/boot.bin: boot/boot.asm
	nasm -f bin boot/boot.asm -o boot/boot.bin

kernel.bin: src/kernel.o screen.o cli.o string.o
	ld -o kernel.bin -T link.ld src/kernel.o screen.o cli.o string.o

# Compile source files into object files
src/kernel.o: src/kernel.cpp include/screen.h include/cli.h include/string.h
	g++ -m32 -ffreestanding -Iinclude -c src/kernel.cpp -o src/kernel.o

screen.o: src/screen.cpp include/screen.h
	g++ -m32 -ffreestanding -Iinclude -c src/screen.cpp -o screen.o

cli.o: src/cli.cpp include/cli.h
	g++ -m32 -ffreestanding -Iinclude -c src/cli.cpp -o cli.o

string.o: src/string.cpp include/string.h
	g++ -m32 -ffreestanding -Iinclude -c src/string.cpp -o string.o

clean:
	rm -f boot/*.bin src/*.o os_image.img kernel.bin
