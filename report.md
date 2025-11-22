# SYSTEM INFORMATION
- OS: WSL (Ubuntu 24.04.3 LTS) 
- QEMU VERSION: QEMU emulator version 9.2.2 (v9.0.0-5104-g18a7345ed4)
- ESP-IDF Version: ESP-IDF v5.1.2

# SETUP STEPS:
### STEP 1: INSTALL PREREQUISITES
Install WSL :
```bash
wsl --install
```

Install Prerequists for Ubuntu:
```bash
sudo apt update 
sudo apt install -y git python3 python3-pip python3-venv cmake make gcc g++ ninja-build ccache
```

Verify Installations
```bash
# Check Python
python3 --version
pip3 --version

# Check build tools
git --version
cmake --version
make --version
gcc --version
g++ --version
```
<img width="1483" height="762" alt="Screenshot 2025-11-22 155235" src="https://github.com/user-attachments/assets/f259ca6f-f6ad-47f6-a06e-357d9a30924d" />


### STEP 2: BUILD QEMU FOR ESP32
Clone the Repository 
```bash
 git clone https://github.com/espressif/qemu.git
```
### STEP 3: SETUP ESP-IDF
### STEP 4:CREATE PROJECT
### STEP 5 : BUILD PROJECT AND RUN IN QEMU
# DEMONSTARTION OF BLINK LED:
# DEMONSTARTION OF TEMPERATURE READING (SIMULATED)



# REFERENCES:
**QEMU Official:** https://www.qemu.org/docs/master/

**Espressif QEMU REPO:** https://github.com/espressif/qemu

**ESP-IDF Get Started:** https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/index.html

**ESP-IDF GPIO Docs:** https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-ref erence//gpio.html

**Yaksh :** https://github.cperipheralsom/FOSSEE/online_test 

**Example ESP-IDF Projects:** https://github.com/espressif/esp-idf/tree/master/examples/get-started
