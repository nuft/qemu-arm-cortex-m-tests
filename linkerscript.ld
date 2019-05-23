ENTRY(Reset_Handler)

MEMORY
{
    rom : ORIGIN = 0x00000000, LENGTH = 0x1000
    ram : ORIGIN = 0x20000000, LENGTH = 0x1000
}

SECTIONS
{
    .text : {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        . = ALIGN(4);
        *(.text*)
    } > rom
    .rodata : { *(.rodata*) } > rom
    .bss : { *(.bss*) } > ram
}

