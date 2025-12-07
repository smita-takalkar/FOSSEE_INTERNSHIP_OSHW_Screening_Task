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

##Build Automation Script
The script compiles the .cpp file using ESP-IDF and collects all build output files automatically.

File: scripts/build_firmware.sh

## Sample Test Program
A minimal example program used to verify compilation and QEMU execution.

File: sample_input/main.cpp
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

