#include "screen.h"
#include "cli.h"
#include "string.h"

// Function prototypes
void puts(const char* str);
void gets(char* buffer);
extern "C" char get_key();

void cli() {
    char input[256];  // Buffer for user input
    while (1) {
        // Display prompt
        puts("> ");   // You might need to implement a custom puts() for your OS to print strings to the screen
        
        // Get user input
        gets(input);  // Low-level input capture
        
        // Process the command
        if (strcmp(input, "help") == 0) {
            puts("Available commands: help, exit\n");
        } else if (strcmp(input, "exit") == 0) {
            puts("Shutting down...\n");
            break;  // Exit the loop to shut down the OS
        } else {
            puts("Unknown command\n");
        }
    }
}

// Simple function to get input from the user
void gets(char* buffer) {
    char c;
    int i = 0;
    while ((c = get_key()) != '\r') {  // '\r' is the Enter key in BIOS input
        if (c == '\b') {  // Handle backspace
            if (i > 0) {
                i--;
                // Optionally: Clear the character on the screen
                print("\b \b");  // Move back, print space, move back again
            }
        } else if (i < 255) {  // Prevent buffer overflow
            buffer[i++] = c;  // Store character
            print(&c);  // Print the character to the screen
        }
    }
    buffer[i] = '\0';  // Null-terminate the string
}


// Mock function to simulate getting a key from the keyboard (replace with real input later)


char get_key() {
    char key;
    asm volatile (
        "int $0x16"          // BIOS interrupt for keyboard input
        : "=a" (key)         // Output: store the result in 'key'
        : "a" (0x00)         // Input: AH=0, BIOS waits for key press
    );
    return key;
}

#define VGA_MEMORY 0xB8000  // Base address for VGA text buffer
#define SCREEN_WIDTH 80      // Number of characters per line
#define SCREEN_HEIGHT 25     // Number of lines on the screen

// Function to write a string to the VGA text buffer
void puts(const char* str) {
    volatile unsigned short* vga_buffer = (unsigned short*)VGA_MEMORY;  // Pointer to VGA memory
    static int cursor_x = 0;  // Cursor position
    static int cursor_y = 0;

    while (*str) {
        // Write character and attribute (white on black)
        if (*str == '\n') {  // Handle new lines
            cursor_x = 0;
            cursor_y++;
        } else {
            // Write character to VGA memory
            vga_buffer[cursor_y * SCREEN_WIDTH + cursor_x] = (*str | 0x0F00);  // White foreground, black background
            cursor_x++;
        }

        // Wrap text if it exceeds screen width
        if (cursor_x >= SCREEN_WIDTH) {
            cursor_x = 0;
            cursor_y++;
        }

        // Scroll the screen if we exceed screen height
        if (cursor_y >= SCREEN_HEIGHT) {
            cursor_y = SCREEN_HEIGHT - 1;  // Keep the last line
            // Simple scrolling
            for (int i = 0; i < SCREEN_WIDTH * (SCREEN_HEIGHT - 1); i++) {
                vga_buffer[i] = vga_buffer[i + SCREEN_WIDTH];  // Shift lines up
            }
            // Clear the last line
            for (int i = 0; i < SCREEN_WIDTH; i++) {
                vga_buffer[(SCREEN_HEIGHT - 1) * SCREEN_WIDTH + i] = ' ' | 0x0F00;  // Clear with spaces
            }
        }

        str++;  // Move to the next character
    }
    
}

