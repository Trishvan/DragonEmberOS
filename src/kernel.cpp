#include "screen.h"

extern "C" void kernel_main() {
    print("Hello from my kernel!");
    while (1); // Loop to keep the kernel running
}
