    .cpu cortex-m0
    .thumb

    .section .isr_vector, "ax"
    .global _vectors
_vectors:
    .word 0x20001000
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
    bl main
    b hang

.thumb_func
hang:   b .
