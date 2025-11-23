#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

void app_main(void)
{
    int reading_count = 0; //Tracking number of readings
    while (1) {
        reading_count++;
        float temperature = 15.0 + ((float)rand() / RAND_MAX) * 17.0; //Generating random temperature between 15-32 degrees

        printf("Reading #%d: ", reading_count);

        //Checking if the temperature is Cold, Hot, or Normal
        if (temperature < 18.0){
            printf("Temperature is Cold: ");
        } else if (temperature <= 24.0){
            printf("Temperature is Normal: ");
        } else{
            printf("Temperature is Hot: ");
        }

        printf("%.1f Degree Celsius\n", temperature);
        vTaskDelay(2000 / portTICK_PERIOD_MS); //Delay of 2 sec
    }
}