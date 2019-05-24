
/** Call static constructors */
void __libc_init_array(void)
{
    typedef void (*funcp_t)(void);
    extern funcp_t __preinit_array_start[];
    extern funcp_t __preinit_array_end[];
    extern funcp_t __init_array_start[];
    extern funcp_t __init_array_end[];

    funcp_t *fp;

    for (fp = __preinit_array_start; fp < __preinit_array_end; fp++) {
        (*fp)();
    }

    for (fp = __init_array_start; fp < __init_array_end; fp++) {
        (*fp)();
    }
}
