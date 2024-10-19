#include "screen.h"
#include "cli.h"

extern "C" void kernel_main() {
    init_screen();  // Initialize the screen before any other output

    print("Welcome to the OS!\n");
    
    // Start CLI loop (you can implement this later)
    while (1) {
        cli();  // Assuming you have a CLI function defined elsewhere
    }
}
