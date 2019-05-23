
ARMGNU = arm-none-eabi

AOPS = --warn --fatal-warnings -mcpu=cortex-m0 -mfloat-abi=softfp
COPS = -Wall -O0 -g
COPS += -nostartfiles -ffreestanding
COPS += -mcpu=cortex-m0 -mthumb

# C source list
CSRC = src/main.c

# assembly source list
ASMSRC = src/startup.S

LDSCRIPT = linkerscript.ld

OBJECTS = $(CSRC:.c=.o) $(ASMSRC:.S=.o)

all: main.bin Makefile $(CSRC) $(ASMSRC)

clean:
	rm -f *.bin
	rm -f *.o
	rm -f *.elf
	rm -f *.list

# object form assembly
.S.o: Makefile
	@ echo "> assemble $<"
	$(ARMGNU)-as $(AOPS) -o $@ $<

# object from C
.c.o: Makefile
	@ echo "> compile $<"
	$(ARMGNU)-gcc $(COPS) -c $< -o $@

main.bin: $(LDSCRIPT) $(OBJECTS)
	$(ARMGNU)-ld  $(LDFLAGS) -o main.elf -T $(LDSCRIPT) $(OBJECTS)
	$(ARMGNU)-objdump -D main.elf > main.list
	$(ARMGNU)-objcopy main.elf main.bin -O binary

# exit with C-a x
qemu: main.bin
	qemu-system-arm -M lm3s811evb -m 8K -nographic -no-reboot -gdb tcp::3333 -kernel main.bin

