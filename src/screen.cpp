#include "screen.h"

volatile char* video_memory = (volatile char*)0xB8000;  // VGA text buffer starting address

void init_screen() {
    clear_screen();  // Optionally, clear the screen on initialization
}

void print(const char* message) {
    int offset = 0;
    while (*message) {
        video_memory[offset] = *message++;    // Write character to video memory
        video_memory[offset + 1] = 0x07;      // Attribute byte: light grey on black
        offset += 2;
    }
}

void clear_screen() {
    for (int i = 0; i < 80 * 25 * 2; i += 2) {
        video_memory[i] = ' ';               // Fill with spaces
        video_memory[i + 1] = 0x07;          // Attribute byte: light grey on black
    }
}
