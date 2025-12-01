/*Smart Safe Reminder Timer
 * for Portable appliances
 * Rudra Sudhirbhai Patel
 * 159815224
 * Group-19 */

#include <stdio.h>
#include <stdbool.h>
#include "board.h"
#include "peripherals.h"
#include "pin_mux.h"
#include "clock_config.h"
#include "MK66F18.h"
#include "fsl_debug_console.h"
#include "fsl_pit.h"
#include "fsl_gpio.h"

/* These are the assembly functions for controlling the RGB LED */
void setup_red_led(void);
void setup_green_led(void);
void setup_blue_led(void);
void red_led_on(void);
void red_led_off(void);
void green_led_on(void);
void green_led_off(void);
void blue_led_on(void);
void blue_led_off(void);
void all_leds_off(void);

/* Variables used to track timer state and LED behavior */
volatile uint32_t target_time = 0;
volatile uint32_t elapsed_time = 0;
volatile uint8_t timer_running = 0;
volatile uint8_t timer_expired = 0;
volatile uint8_t blink_state = 0;
volatile uint8_t ready_mode = 0;
volatile uint32_t requested_time = 0;

/* This function to get user input from the terminal */
static uint32_t read_uint_from_console(void)
{
    uint32_t value = 0;
    int ch;
    bool got_digit = false;

    while (1)
    {
        ch = GETCHAR();      // waiting for user to type something

        if (ch == '\r' || ch == '\n')  // user pressed Enter
        {
            PUTCHAR('\r');
            PUTCHAR('\n');
            if (got_digit)
            {
                return value;
            }
            else
            {
                PRINTF("Please enter at least one digit: ");
                continue;
            }
        }

        // printing the user input
        PUTCHAR(ch);

        if (ch >= '0' && ch <= '9')
        {
            got_digit = true;
            value = value * 10u + (uint32_t)(ch - '0');
        }
        // Non-digit characters are ignored
    }
}

/* This function changes the LED color based on timer state*/
void set_led_color(char color) {
    all_leds_off();   // make sure starts with all off

    if (color == 'G' || color == 'g') {
        green_led_on();             // ONLY green on
    } else if (color == 'Y' || color == 'y') {
    	red_led_on();
    	green_led_on();           // RED + GREEN = YELLOW
    } else if (color == 'R' || color == 'r') {
        red_led_on();               // ONLY red
    }
}

/* PIT Interrupt Handler - Called every second to update timer*/
void PIT0_IRQHandler(void) {
    /* Clear interrupt flag */
    PIT_ClearStatusFlags(PIT, kPIT_Chnl_0, kPIT_TimerFlag);
    /* blue blink while waiting for SW2 meaning ready state*/
        if (ready_mode) {
            if (blink_state) {
                blue_led_off();
                blink_state = 0;
            } else {
                blue_led_on();
                blink_state = 1;
            }
            return;
        }
    if (timer_running) {
        elapsed_time++;

        /* Checks if 75% reached: turn GREEN off and YELLOW on */
        if (elapsed_time == (target_time * 3 / 4) && elapsed_time < target_time) {
            set_led_color('Y');     //LED set to yellow (red+green)
            PRINTF("\r\n*** WARNING: 75%% of time elapsed! ***\r\n");
        }

        /* check if we've reached the end of the timer */
        if (elapsed_time >= target_time) {
            timer_running = 0;
            timer_expired = 1;
            elapsed_time = 0;

            /* ensure GREEN and YELLOW (red+green) are off before blinking red */
            all_leds_off();
            blink_state = 0;       // start blink from LED OFF state

            PRINTF("\r\n*** TIMER EXPIRED! ***\r\n");
        }
    }

    /* blinking red LED to alert user when timer expired */
    if (timer_expired) {
        if (blink_state) {
            red_led_on();          // RED ON

            blink_state = 0;
        } else {
            red_led_off();         // RED OFF

            blink_state = 1;
        }
        PRINTF("!!! ALERT: Appliance timer finished - Please turn off! !!!\r\n");
    }
}

/* SW2 Interrupt Handler - Start Timer (PTD11) */
void PORTD_IRQHandler(void) {
    /* Clear interrupt flag */
    GPIO_PortClearInterruptFlags(GPIOD, 1U << 11U);

    /* Small delay for handling button bounce*/
    for(volatile int i = 0; i < 100000; i++);

    if (!timer_running && !timer_expired && target_time > 0) {
    	ready_mode = 0;
    	timer_running = 1;
        elapsed_time = 0;

        /* On start: ONLY GREEN ON */
        set_led_color('G');

        PRINTF("\r\n=== TIMER STARTED ===\r\n");
        PRINTF("Duration: %d seconds\r\n", requested_time);
    }
}

/* SW3 Interrupt Handler - stop timer and reset(PTA10) */
void PORTA_IRQHandler(void) {
    /* Clear interrupt flag */
    GPIO_PortClearInterruptFlags(GPIOA, 1U << 10U);

    /* Small delay for handling button bounce */
    for(volatile int i = 0; i < 100000; i++);

    if (timer_running || timer_expired) {
    	ready_mode = 0;
    	timer_running = 0;
        timer_expired = 0;
        elapsed_time = 0;

        /* Turn all LED off when appliance is turned off */
        all_leds_off();

        PRINTF("\r\n=== APPLIANCE TURNED OFF ===\r\n");
        PRINTF("Timer stopped. Ready for new timer.\r\n\n");
    }
}

int main(void) {
//    /* Init board hardware */
    BOARD_InitBootPins();
    BOARD_InitBootClocks();
    BOARD_InitBootPeripherals();
    BOARD_InitDebugConsole();

    /*call assembly functions to set up the RGB LED*/
    setup_red_led();
    setup_green_led();
    setup_blue_led();
    all_leds_off();

    PRINTF("\r\n");
    PRINTF("========================================\r\n");
    PRINTF("  Appliance Timer Controller - K66F\r\n");
    PRINTF("========================================\r\n");
    PRINTF("\r\n");

    /* Get timer duration from user using custom input function */
    while (1)
    {
        PRINTF("Enter timer duration in seconds: ");
        requested_time = read_uint_from_console();
        target_time= 4*requested_time;
        if (target_time == 0) {
            PRINTF("Timer must be greater than 0 seconds.\r\n");
        } else {
            break;
        }
    }
    ready_mode = 1;        // enable blue blink while waiting
    blink_state = 0;       // start with LED off
    PRINTF("\r\nTimer set to %d seconds\r\n", requested_time);
    PRINTF("\r\nInstructions:\r\n");
    PRINTF("  - Press SW2 to START the timer\r\n");
    PRINTF("  - Press SW3 to STOP/TURN OFF appliance\r\n");
    PRINTF("\r\nLED Indicators:\r\n");
    PRINTF("  - GREEN: Timer running\r\n");
    PRINTF("  - YELLOW: 75%% time elapsed (warning)\r\n");
    PRINTF("  - RED (blinking): Timer expired!\r\n");
    PRINTF("\r\nWaiting for SW2 press to start...\r\n\n");

    /* everything happens in the interrupt handlers now */
    while (1) {
        __asm volatile ("NOP"); // Wait for interrupt
    }

    return 0;
}
