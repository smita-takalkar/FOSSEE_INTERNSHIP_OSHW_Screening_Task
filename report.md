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

```bash
# Clone the Repository 
git clone https://github.com/espressif/qemu.git

# install essential dependencies
sudo apt-get install -y git libglib2.0-dev libfdt-dev libpixman-1-dev ninja-build build essential zlib1g-dev libnfs-dev libiscsi-dev
```
<img width="1920" height="1080" alt="Screenshot 2025-11-17 221818" src="https://github.com/user-attachments/assets/5bc26303-f8c2-42c6-a83f-5ba3d7ee07bd" />
Error due to missing packages:
<img width="1920" height="1080" alt="Screenshot 2025-11-17 223226" src="https://github.com/user-attachments/assets/7f3660df-8731-451c-9768-6ed104f9b338" />
<img width="1920" height="1080" alt="Screenshot 2025-11-17 223240" src="https://github.com/user-attachments/assets/09419cbe-5994-4e7d-8aa2-0a66afa5493e" />
<img width="960" height="1020" alt="Screenshot 2025-11-17 225505" src="https://github.com/user-attachments/assets/db44d3d8-da77-4b25-9b65-9c5095102d76" />

```bash
# configure and compile
mkdir build
cd build
../configure --target-list=xtensa-softmmu
make -j$(nproc)
#Add path to ~/.bashrc
echo "Add to PATH: export PATH=\$HOME/esp/qemu/build:\$PATH" >> ~/.bashrc
source ~/.bashrc
```
<img width="1920" height="1080" alt="Screenshot 2025-11-17 225733" src="https://github.com/user-attachments/assets/23c46e11-40ac-4375-97f3-4e4b1600fb5d" />
<img width="1920" height="1080" alt="Screenshot 2025-11-17 225745" src="https://github.com/user-attachments/assets/cd5e0e28-dbf3-490a-ad51-30670b6276fa" />


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
