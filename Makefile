
MCUOPT = -mcpu=cortex-m3 -mthumb
# MCUOPT += -mfloat-abi=soft -mfpu=fpv5-sp-d16

AOPS = --warn --fatal-warnings $(MCUOPT)
OPT = -Wall -Wextra -Wundef -O0 -ggdb
OPT += -nostartfiles -ffreestanding
OPT += -fomit-frame-pointer -falign-functions=16 -ffunction-sections -fdata-sections -fno-common
OPT += $(MCUOPT)

COPT = $(OPT)
COPT += -Wstrict-prototypes

CPPOPT = $(OPT)
CPPOPT += -fno-rtti
CPPOPT += -std=gnu++11
CPPOPT += -fno-use-cxa-atexit
CPPOPT += -fno-exceptions -fno-unwind-tables -fno-threadsafe-statics

# C source list
CSRC = src/main.c src/device.c src/crt1.c src/newlib_syscalls.c
CPPSRC = src/test.cpp src/stubs.cpp

# assembly source list
ASMSRC = src/startup.S

LDSCRIPT = linkerscript.ld

LDFLAGS = $(MCUOPT) -nostartfiles
LDFLAGS += -Wl,--gc-sections,--no-warn-mismatch,--script=$(LDSCRIPT)

OBJECTS = $(ASMSRC:.S=.o) $(CSRC:.c=.o) $(CPPSRC:.cpp=.o)

ARMGNU = arm-none-eabi

TRGT = arm-none-eabi-
CC = $(TRGT)gcc
CPPC = $(TRGT)g++
# AS = $(TRGT)gcc -x assembler-with-cpp
AS = $(TRGT)as
LD = $(TRGT)gcc
CP = $(TRGT)objcopy
OD = $(TRGT)objdump

all: main.bin main.addr main.size Makefile $(CSRC) $(ASMSRC)

clean:
	rm -f *.bin
	rm -f *.o
	rm -f *.elf
	rm -f *.list

# object form assembly
.S.o: Makefile
	$(AS) $(AOPS) -o $@ $<

# object from C
.c.o: Makefile
	$(CC) $(COPT) -c $< -o $@

# object from C
.cpp.o: Makefile
	$(CPPC) $(CPPOPT) -c $< -o $@

main.elf: $(LDSCRIPT) $(OBJECTS)
	$(LD) $(OBJECTS) $(LDFLAGS) -o $@

main.bin: main.elf
	$(OD) -D main.elf > main.list
	$(CP) main.elf main.bin -O binary

main.size: main.elf
	arm-none-eabi-nm -C --size-sort --print-size main.elf > main.size

main.addr: main.elf
	arm-none-eabi-nm -C --numeric-sort --print-size main.elf > main.addr

# exit with C-a x
.PHONY: qemu
qemu: all
	qemu-system-arm -M lm3s6965evb -m 64K -nographic -no-reboot -gdb tcp::3333 -kernel main.bin

.PHONY: debug
debug: all
	qemu-system-arm -S -M lm3s6965evb -m 64K -nographic -gdb tcp::3333 -kernel main.bin

.PHONY: gdb
gdb: all
	arm-none-eabi-gdb --eval-command='target remote localhost:3333' main.elf
