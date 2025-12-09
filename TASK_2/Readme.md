# MicroPython on QEMU (ESP32)

This guide shows how to set up **MicroPython (ESP32 port)** and run it fully inside QEMU.

---

## ✅ 1. Get QEMU (Espressif Fork)
Clone the Espressif QEMU repository:
```bash
git clone https://github.com/espressif/qemu
```
Build QEMU:
```bash
./configure --target-list=xtensa-softmmu \
    --enable-gcrypt \
    --enable-slirp \
    --enable-debug \
    --enable-sdl \
    --disable-strip --disable-user \
    --disable-capstone --disable-vnc \
    --disable-gtk
```

---

## ✅ 2. Get ESP-IDF **v5.5.1**
> ⚠️ MicroPython works only with **ESP-IDF v5.5.1**.

Clone ESP-IDF 5.5.1:
```bash
git clone -b v5.5.1 --recursive https://github.com/espressif/esp-idf.git
```

For detailed setup, follow:
- https://github.com/AkshatSharma05/FOSSEE-OSHW

---

## ✅ 3. Clone MicroPython
```bash
git clone https://github.com/micropython/micropython
```

---

## ✅ 4. Build the MicroPython cross‑compiler
```bash
make -C mpy-cross
```

---

## ✅ 5. Build MicroPython for ESP32
```bash
cd micropython/ports/esp32
make submodules
make
```
This creates the firmware in:
```
build-ESP32_GENERIC/
```
The build produces:
- `bootloader.bin`
- `partitions.bin`
- `micropython.bin`
- **combined** `firmware.bin`

---

## ✅ 6. Create a merged 4MB flash image
Go to the build folder:
```bash
cd build-ESP32_GENERIC
```
Run:
```bash
esptool.py --chip esp32 merge_bin --fill-flash-size 4MB -o flash_image.bin @flash_args
```
If `esptool` is missing, install it:
```bash
pip install esptool
```

---

## ✅ 7. Run MicroPython on QEMU
```bash
/home/<your_path>/qemu/build/qemu-system-xtensa -nographic \  
    -machine esp32 \  
    -drive file=flash_image.bin,if=mtd,format=raw
```
Replace `<your_path>` with the actual QEMU directory path.

---

## 📌 Python Automation Script (pyauto.py)
`pyauto.py` is a Python automation tool that:
- Launches QEMU running the ESP32 MicroPython firmware
- Waits for the MicroPython boot process to complete
- Automatically enters **paste mode** (Ctrl‑E)
- Pastes the contents of a Python script (`temp.py` by default)
- Automatically executes it using **Ctrl‑D**
- Then returns to normal REPL mode so you can type interactively

### 🔍 How `pyauto.py` works
1. It starts QEMU using MicroPython `firmware.bin`.
2. It creates a *pseudo‑terminal* (PTY) to communicate with QEMU like a real terminal.
3. It continuously reads QEMU output and waits until MicroPython prints the startup text ending with:
   ```
   help()
   ```
4. After MicroPython is ready, it sends:
   - **Ctrl‑E** → enters paste mode
   - the entire contents of `temp.py`
   - **Ctrl‑D** → executes the pasted code
5. It then switches back to normal REPL, so anything typed into your terminal goes into the MicroPython REPL.

### 📌 Files used
- **temp.py** → contains your MicroPython code (ex: fake temperature sensor)
- **firmware.bin** → MicroPython firmware (bootloader + partitions + micropython.bin merged)

### 📌 Why this script is useful
This script automates repetitive tasks like:
- manually typing code into REPL
- copying & pasting large code blocks
- testing scripts automatically 

---
## 📌 About `firmware.bin`
The generated `firmware.bin` is a combination of:
- bootloader
- partition table
- MicroPython firmware

This is expanded to **4MB** Flash to allow QEMU to emulate ESP32 properly.

---
