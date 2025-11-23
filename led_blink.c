#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

void app_main(void)
{
    int gpio_pin = 2; // GPIO 2- Built in LED in ESP32
    int pin_state =0; //Starting with LED OFF(LOW STATE)

    printf("GPIO Emulation Started\n");
    printf("Toggling Virtual GPIO %d\n", gpio_pin);

    while(1) {
        pin_state = !pin_state; //Toggle the pin_state

        if (pin_state){
            printf("GPIO %d set HIGH - LED ON\n", gpio_pin);
        }
        else{
            printf("GPIO %d set LOW - LED OFF\n", gpio_pin);
        }
        vTaskDelay(1000/portTICK_PERIOD_MS); //Delay of 1 sec
    }
}