#include "screen.h"

// Define the VGA buffer location
volatile char* video = (volatile char*)0xB8000;

void print(const char* str) {
    unsigned int i = 0;
    while (str[i] != '\0') {
        video[i * 2] = str[i];      // Character byte
        video[i * 2 + 1] = 0x07;    // Attribute byte (white on black)
        i++;
    }
}
