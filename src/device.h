#ifndef DEVICE_H
#define DEVICE_H

#ifdef __cplusplus
extern "C" {
#endif

void __putc(const char c);
void print(const char*);
void panic(const char*);
void reset(void);

#ifdef __cplusplus
}
#endif

#endif /* DEVICE_H */
