#!/bin/bash
# Convert Arduino .ino to ESP-IDF .cpp (with fixes)

set -e

# ----------------------------
# Argument check
# ----------------------------
if [ $# -lt 1 ]; then
    echo "Usage: $0 <input.ino> [output.cpp]"
    exit 1
fi

INO_FILE="$1"
CPP_FILE="${2:-${INO_FILE%.ino}.cpp}"

if [ ! -f "$INO_FILE" ]; then
    echo "Error: Input file not found: $INO_FILE"
    exit 1
fi

echo "Converting $INO_FILE -> $CPP_FILE"

# ----------------------------
# Write header
# ----------------------------
cat > "$CPP_FILE" << 'HEADER_EOF'

// Arduino to ESP-IDF Conversion 

#include <stdio.h>
#include <string.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"
#include "driver/uart.h"

// ----------------------------
// Arduino constants
// ----------------------------
#define INPUT 0
#define OUTPUT 1
#define INPUT_PULLUP 2
#define HIGH 1
#define LOW 0

// ----------------------------
// Arduino to ESP32 GPIO mapping
// ----------------------------
gpio_num_t arduino_to_esp32(int pin) {
    const gpio_num_t mapping[] = {
        GPIO_NUM_3, GPIO_NUM_1, GPIO_NUM_2, GPIO_NUM_4, GPIO_NUM_5,
        GPIO_NUM_18, GPIO_NUM_19, GPIO_NUM_21, GPIO_NUM_22, GPIO_NUM_23,
        GPIO_NUM_25, GPIO_NUM_26, GPIO_NUM_27, GPIO_NUM_14
    };
    if (pin >= 0 && pin < 14) return mapping[pin];
    return (gpio_num_t)pin;
}

// ----------------------------
// Arduino API replacements
// ----------------------------
void pinMode(int pin, int mode) {
    gpio_num_t gpio = arduino_to_esp32(pin);
    gpio_reset_pin(gpio);

    gpio_config_t io_conf = {};
    io_conf.pin_bit_mask = (1ULL << gpio);
    io_conf.intr_type = GPIO_INTR_DISABLE;

    if (mode == OUTPUT) io_conf.mode = GPIO_MODE_OUTPUT;
    else io_conf.mode = GPIO_MODE_INPUT;

    io_conf.pull_up_en = (mode == INPUT_PULLUP) ? GPIO_PULLUP_ENABLE : GPIO_PULLUP_DISABLE;
    io_conf.pull_down_en = GPIO_PULLDOWN_DISABLE;

    gpio_config(&io_conf);
}

void digitalWrite(int pin, int value) {
    gpio_set_level(arduino_to_esp32(pin), value);
}

void delay(unsigned long ms) {
    vTaskDelay(pdMS_TO_TICKS(ms));
}

// ----------------------------
// Serial (UART0 to stdout)
// ----------------------------
void Serial_begin(unsigned long baud) {
    uart_config_t cfg = {
        .baud_rate = static_cast<int>(baud),  // FIX: cast to int
        .data_bits = UART_DATA_8_BITS,
        .parity    = UART_PARITY_DISABLE,
        .stop_bits = UART_STOP_BITS_1,
        .flow_ctrl = UART_HW_FLOWCTRL_DISABLE,
        .rx_flow_ctrl_thresh = 0,
        .source_clk = UART_SCLK_APB
    };
    uart_param_config(UART_NUM_0, &cfg);
    uart_driver_install(UART_NUM_0, 256, 0, 0, NULL, 0);
}

void Serial_print(const char *text) { printf("%s", text); fflush(stdout); }
void Serial_println(const char *text) { printf("%s\n", text); fflush(stdout); }
void Serial_print(int value) { printf("%d", value); fflush(stdout); }
void Serial_println(int value) { printf("%d\n", value); fflush(stdout); }

// ===================================================
// USER ARDUINO CODE
// ===================================================
HEADER_EOF

# ----------------------------
# Process Arduino file
# ----------------------------
while IFS= read -r line; do
    [[ "$line" == *"#include <Arduino.h>"* ]] && continue

    line="${line//Serial.begin(/Serial_begin(}"    # redirect to Serial_begin
    line="${line//Serial.println/Serial_println}"
    line="${line//Serial.print/Serial_print}"

    echo "$line" >> "$CPP_FILE"
done < "$INO_FILE"

# ----------------------------
# ESP-IDF entry point
# ----------------------------
cat >> "$CPP_FILE" << 'FOOTER_EOF'

extern "C" void app_main(void) {
    setup();
    while (1) {
        loop();
        delay(10);
    }
}
FOOTER_EOF

echo "Conversion complete: $CPP_FILE"
