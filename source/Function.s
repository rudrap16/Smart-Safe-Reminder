/*Smart Safe Reminder Timer
 * for Portable appliances
 * Rudra Sudhirbhai Patel
 * 159815224
 * Group-19 */

.syntax unified             @ unified syntax used
.cpu cortex-m4              @ cpu is cortex-m4
.thumb                      @ use thumb encoding

.text                       @ put code in the code section

@Setup Functions for Each LED Color

.global setup_red_led
.type setup_red_led, %function
setup_red_led:
    @Here enabling the clock for Port C (Red LED - PTC9)
    ldr r1, =0x40048038     @ System Clock Gate Control Register 5
    ldr r0, [r1]
    orr r0, r0, #(1<<11)    @ enable clock for port C (bit 11)
    str r0, [r1]

    @ Configuring PTC9 as a GPIO pin
    ldr r1, =0x4004B024     @ PORTC_PCR9 register controls pin 9
    mov r0, #0x00000100     @ set pin to GPIO mode
    str r0, [r1]

    @ Set PTC9 as output
    ldr r1, =0x400FF094     @GPIOC_PDDR is Direction Register
    ldr r0, [r1]
    orr r0, r0, #(1<<9)     @ set pin 9 to output mode
    str r0, [r1]
    bx  lr

.global setup_green_led
.type setup_green_led, %function
setup_green_led:
    @Here enabling the clock for Port E (Green LED - PTE6)
    ldr r1, =0x40048038     @ System Clock Gate Control Register 5
    ldr r0, [r1]
    orr r0, r0, #(1<<13)    @ enable clock for port E (bit 13)
    str r0, [r1]

    @ Configuring PTE6 as GPIO pin
    ldr r1, =0x4004D018     @ PORTE_PCR6 register controls pin 6
    mov r0, #0x00000100     @ set pin to GPIO mode
    str r0, [r1]

    @ Set PTE6 as output
    ldr r1, =0x400FF114     @ GPIOE_PDDR is Direction Register
    ldr r0, [r1]
    orr r0, r0, #(1<<6)     @ set pin 6 to output mode
    str r0, [r1]
    bx  lr

.global setup_blue_led
.type setup_blue_led, %function
setup_blue_led:
    @Here enabling clock for Port A (Blue LED - PTA11)
    ldr r1, =0x40048038     @ System Clock Gate Control Register 5
    ldr r0, [r1]
    orr r0, r0, #(1<<9)     @ enable clock for port A (bit 9)
    str r0, [r1]

    @ Set PTA11 to GPIO mode
    ldr r1, =0x4004902C     @PORTA_PCR11 register controls pin
    mov r0, #0x00000100     @ set pin to GPIO mode
    str r0, [r1]

    @ Set PTA11 as output
    ldr r1, =0x400FF014     @GPIOA_PDDR is Direction Register
    ldr r0, [r1]
    orr r0, r0, #(1<<11)    @ set pin 11 to output mode
    str r0, [r1]
    bx  lr

@ ========== RED LED Control ==========

.global red_led_on
.type red_led_on, %function
red_led_on:
    ldr r1, =0x400FF080     @GPIOC_PDOR is Output Register
    ldr r0, [r1]
    bic r0, r0, #(1<<9)     @ clear bit 9 (LOW = LED ON)
    str r0, [r1]
    bx  lr

.global red_led_off
.type red_led_off, %function
red_led_off:
    ldr r1, =0x400FF080     @GPIOC_PDOR is Output Register
    ldr r0, [r1]
    orr r0, r0, #(1<<9)     @ set bit 9 (HIGH = LED OFF)
    str r0, [r1]
    bx  lr

@ ========== GREEN LED Control ==========

.global green_led_on
.type green_led_on, %function
green_led_on:
    ldr r1, =0x400FF100     @GPIOE_PDOR is Output Register
    ldr r0, [r1]
    bic r0, r0, #(1<<6)     @ clear bit 6 (LOW = LED ON)
    str r0, [r1]
    bx  lr

.global green_led_off
.type green_led_off, %function
green_led_off:
    ldr r1, =0x400FF100     @GPIOE_PDOR is Output Register
    ldr r0, [r1]
    orr r0, r0, #(1<<6)     @ set bit 6 (HIGH = LED OFF)
    str r0, [r1]
    bx  lr

@ ========== BLUE LED Control ==========

.global blue_led_on
.type blue_led_on, %function
blue_led_on:
    ldr r1, =0x400FF000     @GPIOA_PDOR is Output Register
    ldr r0, [r1]
    bic r0, r0, #(1<<11)    @ clear bit 11 (LOW = LED ON)
    str r0, [r1]
    bx  lr

.global blue_led_off
.type blue_led_off, %function
blue_led_off:
    ldr r1, =0x400FF000     @GPIOA_PDOR is Output Register
    ldr r0, [r1]
    orr r0, r0, #(1<<11)    @ set bit 11 (HIGH = LED OFF)
    str r0, [r1]
    bx  lr

@ ========== Turn OFF All LEDs ==========

.global all_leds_off
.type all_leds_off, %function
all_leds_off:
    @ Turn off RED LED
    ldr r1, =0x400FF080
    ldr r0, [r1]
    orr r0, r0, #(1<<9)
    str r0, [r1]

    @ Turn off GREEN LED
    ldr r1, =0x400FF100
    ldr r0, [r1]
    orr r0, r0, #(1<<6)
    str r0, [r1]

    @ Turn off BLUE LED
    ldr r1, =0x400FF000
    ldr r0, [r1]
    orr r0, r0, #(1<<11)
    str r0, [r1]
    bx  lr
