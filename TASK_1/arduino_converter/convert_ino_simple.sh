#!/bin/bash
# .ino to .cpp converter

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
