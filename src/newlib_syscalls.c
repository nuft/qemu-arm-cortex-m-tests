#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

extern uint8_t __heap_base__[];
extern uint8_t __heap_end__[];
static uint8_t *_cur_brk = __heap_base__;

#define UART0DR ((volatile uint32_t*)0x4000C000)
static void _putc(char c)
{
    *UART0DR = c;
}

int _read_r(struct _reent *r, int file, char * ptr, int len)
{
    (void)r;
    (void)file;
    (void)ptr;
    (void)len;

    __errno_r(r) = EINVAL;
    return -1;
}

int _lseek_r(struct _reent *r, int file, int ptr, int dir)
{
    (void)r;
    (void)file;
    (void)ptr;
    (void)dir;

    return 0;
}

int _write_r(struct _reent *r, int file, char * ptr, int len)
{
    (void)r;
    (void)file;
    (void)ptr;

    if (file != 1) {
        __errno_r(r) = EINVAL;
        return -1;
    }

    for ( ; len > 0; len--, ptr++) {
        _putc(*ptr);
    }
    return len;
}

int _close_r(struct _reent *r, int file)
{
    (void)r;
    (void)file;
    __errno_r(r) = ENOMEM;

    return 0;
}

caddr_t _sbrk_r(struct _reent *r, ptrdiff_t incr)
{
    uint8_t *_old_brk;

    _old_brk = _cur_brk;
    if (_cur_brk + incr > __heap_end__) {
        __errno_r(r) = ENOMEM;
        return (caddr_t)-1;
    }
    _cur_brk += incr;
    return (caddr_t)_old_brk;
}

int _fstat_r(struct _reent *r, int file, struct stat * st)
{
    (void)r;
    (void)file;

    memset(st, 0, sizeof(*st));
    st->st_mode = S_IFCHR;
    return 0;
}

int _isatty_r(struct _reent *r, int fd)
{
    (void)r;
    (void)fd;

    return 1;
}

/* Called by __libc_fini_array() */
void _fini(void)
{
    /* empty */
}
