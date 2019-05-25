    .syntax unified /* unified ARM/THUMB syntax */
    .fpu softvfp
    .cpu cortex-m3
    .thumb

    .section .isr_vector, "ax"
    .global _vectors
_vectors:
    .word _estack
    .word Reset_Handler
    .word hang /* NMI_Handler */
    .word hang /* HardFault_Handler */
    .word hang /* MemManage_Handler */
    .word hang /* BusFault_Handler */
    .word hang /* UsageFault_Handler */
    .word hang /* 0 */
    .word hang /* 0 */
    .word hang /* 0 */
    .word hang /* 0 */
    .word hang /* SVC_Handler */
    .word hang /* DebugMon_Handler */
    .word hang /* 0 */
    .word hang /* PendSV_Handler */
    .word hang /* SysTick_Handler */

.thumb_func
.section .text
.global Reset_Handler
Reset_Handler:
    ldr   sp, =_estack             /* set stack pointer */
    /* Copy the data segment initializers from flash to SRAM */
    movs  r1, #0
    b  LoopCopyDataInit

CopyDataInit:
    ldr  r3, =_sidata
    ldr  r3, [r3, r1]
    str  r3, [r0, r1]
    adds  r1, r1, #4

LoopCopyDataInit:
    ldr  r0, =_sdata
    ldr  r3, =_edata
    adds  r2, r0, r1
    cmp  r2, r3
    bcc  CopyDataInit
    ldr  r2, =_sbss
    b  LoopFillZerobss
    /* Zero fill the bss segment. */
FillZerobss:
    movs  r3, #0
    str  r3, [r2], #4

LoopFillZerobss:
    ldr  r3, = _ebss
    cmp  r2, r3
    bcc  FillZerobss

    /* Call static constructors */
    bl __libc_init_array
    /* Call the application's entry point.*/
    bl  main
    /* Call static destructors */
    bl __libc_fini_array
    bl _exit
    b   hang
    .size  Reset_Handler, .-Reset_Handler

.thumb_func
hang:   b .
