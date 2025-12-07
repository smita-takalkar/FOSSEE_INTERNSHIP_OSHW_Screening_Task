# Automated Firmware Build Pipeline 

## Overview
This repository contains an automated build pipeline that compiles `.cpp` firmware files using **ESP-IDF**, generates output artifacts, and prepares the firmware to run on **QEMU**.  
This automation helps ensure a reproducible build environment for testing firmware without physical hardware.

---

## ESP-IDF Setup
Ensure ESP-IDF environment is set correctly before running the script.

```bash
# Check if IDF is installed
echo $IDF_PATH

# If not set:
export IDF_PATH=~/esp/esp-idf
source $IDF_PATH/export.sh 
```

## Build Automation Script
This script automates firmware building using ESP-IDF.
This script automates firmware building using ESP-IDF.
It accepts a converted .cpp file as input, creates a temporary ESP-IDF project structure, compiles the code, and generates all necessary build outputs — including:
- the final .elf firmware file (ready to be executed or run in QEMU)
- build.log (full record of the build process for debugging)
- artifact.txt (contains the absolute path of the .elf file for automation in the next pipeline stage)

**File: scripts/build_firmware.sh**

## Sample Test Program
A minimal example program used to verify compilation and QEMU execution.

**File: sample_input/main.cpp**
```bash
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"

extern "C" void app_main(void) {
    gpio_reset_pin(GPIO_NUM_2);
    gpio_set_direction(GPIO_NUM_2, GPIO_MODE_OUTPUT);
    while(1) {
        gpio_set_level(GPIO_NUM_2, 1);
        vTaskDelay(500 / portTICK_PERIOD_MS);
        gpio_set_level(GPIO_NUM_2, 0);
        vTaskDelay(500 / portTICK_PERIOD_MS);
    }
}
```
Purpose: Blinks LED on GPIO2 every 500ms.

## Running the Build
```bash
./scripts/build_firmware.sh sample_input/main.cpp
```

## Expected Output Files

After running the script, the generated files are stored inside sample_output/:

| File             | Purpose                                       |
| ---------------- | --------------------------------------------- |
| `blink_temp.elf` | Compiled firmware binary (for QEMU execution) |
| `artifact.txt`   | Contains absolute path of `.elf`              |
| `build.log`      | Build process log for debugging               |

