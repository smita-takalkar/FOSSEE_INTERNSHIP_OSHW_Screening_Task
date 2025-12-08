# Project Goal
Create an automated evaluation pipeline where Arduino (.ino) C code and MicroPython scripts for ESP32 can be executed/emulated and their outputs captured. This system will later integrate with Yaksh to automatically evaluate student submissions
## SubTask— Arduino/ESP32 C Code Execution (via ESP-IDF/QEMU-ESP32)
## Objectives
1. Learn how Arduino C/C++ (.ino) fi les are compiled into the ESP-IDF framework.
2. Re-implement the Arduino build process manually:
○ Convert .ino → .cpp
○ Link with Arduino Core for ESP32
○ Compile using idf.py or direct xtensa-esp32-elf-gcc
3. Run the compiled fi rmware on QEMU-ESP32 and capture console output.
4. Create a simple demo process:
○ Students submit .ino
○ Your script compiles it through ESP-IDF
○ Emulator runs it
○ Emulator output is saved for test-case evaluation
