#include <stdint.h>

#define UART0DR ((volatile unsigned int*)0x4000C000)
void __putc(const char c)
{
    *UART0DR = c;
}

void print(const char* c)
{
    while(*c) {
        __putc(*c++);
    }
}

#define SCB_AIRCR_RESET ((0x5FAUL << 16) | (1UL << 2))
#define SCB_AIRCR       (*(volatile uint32_t *)(0xE000E000UL + 0x0D00UL + 0x00CUL))
void reset(void)
{
    print("RESET\n");
    SCB_AIRCR = SCB_AIRCR_RESET;
}

void panic(const char *msg)
{
    print("PANIC: ");
    print(msg);
    print("\n");

    reset();

    while (1) {
        ;
    }
}
