all: os_image

os_image: boot/boot.bin kernel.bin
	cat build/boot.bin build/kernel.bin > build/os_image.img

boot/boot.bin: boot/boot.asm
	nasm -f bin boot/boot.asm -o build/boot.bin

kernel.bin: src/kernel.o screen.o cli.o string.o
	ld -m elf_x86_64 -o build/kernel.bin -T link.ld build/kernel.o build/screen.o build/cli.o build/string.o

# Compile source files into object files
src/kernel.o: src/kernel.cpp include/screen.h include/cli.h include/string.h
	g++ -m64 -ffreestanding -Iinclude -c src/kernel.cpp -o build/kernel.o

screen.o: src/screen.cpp include/screen.h
	g++ -m64 -ffreestanding -Iinclude -c src/screen.cpp -o build/screen.o

cli.o: src/cli.cpp include/cli.h
	g++ -m64 -ffreestanding -Iinclude -c src/cli.cpp -o build/cli.o

string.o: src/string.cpp include/string.h
	g++ -m64 -ffreestanding -Iinclude -c src/string.cpp -o build/string.o

clean:
	rm -f build/*.bin src/*.o build/*.o os_image.img kernel.bin
	rm -f *.o
