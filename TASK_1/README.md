# Task 1

1.  Verify ESP-IDF Installation
2. Install Required Dependencies
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
# For understanding the conversion manual simple converter script
``` bash
mkdir ~/arduino_converter
cd ~/arduino_converter

# Create the converter script
cat > convert_ino_simple.sh << 'EOF'
#!/bin/bash
# Simple .ino to .cpp converter

if [ $# -ne 1 ]; then
    echo "Usage: $0 <filename.ino>"
    exit 1
fi

INOFILE="$1"
CPPFILE="${INOFILE%.ino}.cpp"

echo "Converting $INOFILE to $CPPFILE..."

# Add Arduino.h if missing and create prototypes
echo "// Auto-converted from $INOFILE" > "$CPPFILE"
echo "" >> "$CPPFILE"

# Check if Arduino.h is included
if ! grep -q "#include.*Arduino.h" "$INOFILE"; then
    echo "#include <Arduino.h>" >> "$CPPFILE"
    echo "" >> "$CPPFILE"
fi

# Add function prototypes (excluding setup and loop)
echo "// Function prototypes" >> "$CPPFILE"
grep -E "^(void|int|float|double|char|bool|String|byte|word|long|unsigned)" "$INOFILE" | \
    grep -v "void setup\|void loop" | \
    grep "(" | \
    sed 's/{.*/;/' | \
    sort -u >> "$CPPFILE"
echo "" >> "$CPPFILE"

# Copy the rest of the file
cat "$INOFILE" >> "$CPPFILE"

echo "✓ Conversion complete: $CPPFILE"
EOF

chmod +x convert_ino_simple.sh
```
## created test .ino file
``` bash
# Create a test Arduino file
cat > my_sketch.ino << 'EOF'
// My Arduino sketch
int readSensor(int pin) {
  return analogRead(pin);
}

void setupLED() {
  pinMode(13, OUTPUT);
}

void setup() {
  Serial.begin(115200);
  setupLED();
  Serial.println("Started!");
}

void loop() {
  int value = readSensor(A0);
  Serial.print("Sensor: ");
  Serial.println(value);
  delay(1000);
}
EOF
```
# for conversion 
``` bash
# Run the converter
./convert_ino_simple.sh my_sketch.ino

# View the converted file
cat my_sketch.cpp
```
# after running the script we'll get my_sketch.cpp file 
