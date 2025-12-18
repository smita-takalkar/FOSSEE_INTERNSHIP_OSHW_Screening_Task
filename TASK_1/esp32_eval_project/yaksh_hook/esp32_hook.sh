#!/usr/bin/env bash
set -euo pipefail

# ----------------------------
# Input arguments
# ----------------------------
SUBMISSION_FILE="${1:-}"
BASE_DIR="$(realpath "$(dirname "$0")/..")"
OUTDIR="$(realpath "${2:-$BASE_DIR/workdir}")"
CONVERTER="$BASE_DIR/scripts/converter_ino_cpp.sh"
TEMPLATE_DIR="$BASE_DIR/espidf_template"

LOGFILE="$OUTDIR/yaksh_build.log"
ARTIFACT_FILE="$OUTDIR/artifact.txt"

if [ -z "$SUBMISSION_FILE" ]; then
  echo "ERROR: No submission file provided"
  exit 1
fi

if [ ! -f "$SUBMISSION_FILE" ]; then
  echo "ERROR: Submission file not found: $SUBMISSION_FILE"
  exit 2
fi

# ----------------------------
# Prepare workspace
# ----------------------------
rm -rf "$OUTDIR"
mkdir -p "$OUTDIR/main"
mkdir -p "$(dirname "$LOGFILE")"

cp -r "$TEMPLATE_DIR/"* "$OUTDIR/"
cp "$SUBMISSION_FILE" "$OUTDIR/main/main.ino"

# ----------------------------
# Convert Arduino → ESP-IDF C++
# ----------------------------
echo "[INFO] Converting Arduino sketch"
"$CONVERTER" "$OUTDIR/main/main.ino" "$OUTDIR/main/main.cpp"

# ----------------------------
# Build with ESP-IDF
# ----------------------------
echo "===================================="
echo "Building firmware"
echo "Source: $SUBMISSION_FILE"
echo "Workdir: $OUTDIR"
echo "Log:     $LOGFILE"
echo "===================================="

if [ -f "$HOME/esp/esp-idf/export.sh" ]; then
  source "$HOME/esp/esp-idf/export.sh"
else
  echo "ERROR: ESP-IDF export.sh not found"
  exit 3
fi

command -v idf.py >/dev/null || { echo "ERROR: idf.py not found"; exit 4; }

cd "$OUTDIR"

set +e
idf.py build > "$LOGFILE" 2>&1
RC=$?
set -e

if [ $RC -ne 0 ]; then
  echo "FAIL: Build error"
  echo "See log: $LOGFILE"
  exit $RC
fi

# ----------------------------
# Capture artifact
# ----------------------------
ELF=$(find build -name "*.elf" | head -n 1)
if [ -z "$ELF" ]; then
  echo "ERROR: No ELF produced"
  exit 5
fi

realpath "$ELF" > "$ARTIFACT_FILE"

echo "===================================="
echo "BUILD SUCCESS"
echo "Artifact: $(cat "$ARTIFACT_FILE")"
echo "===================================="
