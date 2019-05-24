#include <stdio.h>
#include <malloc.h>
#include "device.h"

int main(void)
{
    print("hello world\n");
    void *p = malloc(4);
    printf("malloc(4) -> %p\n", p);

    int i;
    for (i = 0; i < 100; i++) {
        p = malloc(4); printf("malloc(4) -> %p\n", p);
        if (p == NULL) {
            break;
        }
    }

    extern void test(void);
    test();

    print("OK\n");
    reset();
    return 0;
}
