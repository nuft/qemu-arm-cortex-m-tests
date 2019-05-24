
MCUOPT = -mcpu=cortex-m0 -mthumb
# -mfloat-abi=softfp

AOPS = --warn --fatal-warnings $(MCUOPT)
COPT = -Wall -Os -g
COPT += -nostartfiles -ffreestanding
COPT += -fomit-frame-pointer -falign-functions=16 -ffunction-sections -fdata-sections -fno-common
COPT += $(MCUOPT)



# C source list
CSRC = src/main.c src/crt1.c src/newlib_syscalls.c

# assembly source list
ASMSRC = src/startup.S

LDSCRIPT = linkerscript.ld

LDFLAGS = $(MCUOPT) -nostartfiles
LDFLAGS += -Wl,--gc-sections,--no-warn-mismatch,--script=$(LDSCRIPT)

OBJECTS = $(CSRC:.c=.o) $(ASMSRC:.S=.o)

ARMGNU = arm-none-eabi

TRGT = arm-none-eabi-
CC = $(TRGT)gcc
CPPC = $(TRGT)g++
# AS = $(TRGT)gcc -x assembler-with-cpp
AS = $(TRGT)as
LD = $(TRGT)gcc
CP = $(TRGT)objcopy
OD = $(TRGT)objdump

all: main.bin Makefile $(CSRC) $(ASMSRC)

clean:
	rm -f *.bin
	rm -f *.o
	rm -f *.elf
	rm -f *.list

# object form assembly
.S.o: Makefile
	@ echo "> assemble $<"
	$(AS) $(AOPS) -o $@ $<

# object from C
.c.o: Makefile
	@ echo "> compile $<"
	$(CC) $(COPT) -c $< -o $@

main.elf: $(LDSCRIPT) $(OBJECTS)
	$(LD) $(OBJECTS) $(LDFLAGS) -o $@

main.bin: main.elf
	$(OD) -D main.elf > main.list
	$(CP) main.elf main.bin -O binary

# exit with C-a x
qemu: main.bin
	qemu-system-arm -M lm3s811evb -m 64K -nographic -no-reboot -gdb tcp::3333 -kernel main.bin

