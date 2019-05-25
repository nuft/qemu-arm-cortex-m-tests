#include <stdio.h>

namespace {
static int _cnt = 0;
struct Value {
    int _val;

    Value()
    {
        _val = _cnt++;
        printf("ctor(%p) %d\n", this, _val);
    }

    ~Value()
    {
        printf("dtor(%p) %d\n", this, _val);
    }

    void print()
    {
        printf("Value: %d\n", _val);
    }
};
}

Value v;

extern "C" {

void test(void)
{
    v.print();
    Value a;
    a._val = 123;

    Value *b = new Value;

    delete b;
}
}
