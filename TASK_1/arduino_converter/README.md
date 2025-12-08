# Task 1

1.  Verify ESP-IDF Installation
``` bash
# Check if ESP-IDF is installed
echo $IDF_PATH
# Should show: /home/yourname/esp/esp-idf

# If not set, set it:
export IDF_PATH=~/esp/esp-idf
source $IDF_PATH/export.sh
```
2. Install Required Dependencies
 ``` bash
   sudo apt update
sudo apt install -y \
    git wget flex bison gperf python3 python3-pip python3-venv \
    cmake ninja-build ccache libffi-dev libssl-dev dfu-util \
    libusb-1.0-0-dev python3-setuptools
 ```
3. Manual installation of Arduino framework
``` bash
# Go to your project directory
cd ~/esp32-auto-evaluator

# Create components directory
mkdir -p components
cd components

# Clone the repository (use --depth 1 for faster download)
git clone --depth 1 https://github.com/espressif/arduino-esp32.git arduino

cd arduino

# Initialize submodules (this may take a while)
git submodule update --init --recursive
```
### convert_ino_simple.sh was converting .ino to .cpp but the output was arduino code that needs arduino libraries to compile. So the output file won't compile with ESP-IDF

### Updated convert_ino_cpp.sh converts .ino to ESP-IDF native code(.cpp) 
1. It replaces arduino fuctions with esp-idf equivalents
2. ads esp-idf headers
3. creates esp-idf entry point(app_main)
4. Compiles with ESP-IDF directly:)


