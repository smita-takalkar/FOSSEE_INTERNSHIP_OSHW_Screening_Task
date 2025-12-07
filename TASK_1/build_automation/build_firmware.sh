#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <path-to-converted-cpp> [output-dir]"
  exit 2
fi

CPP_PATH="$(realpath "$1")"
OUTDIR="$(realpath "${2:-./build_project}")"
TEMPLATE_DIR="$(realpath "$(dirname "$0")/../espidf_template")"
LOGFILE="$OUTDIR/build.log"
ARTIFACT_FILE="$OUTDIR/artifact.txt"

if [ ! -f "$CPP_PATH" ]; then
  echo "Error: converted file not found: $CPP_PATH"
  exit 3
fi
if [ ! -d "$TEMPLATE_DIR" ]; then
  echo "Error: espidf_template not found at $TEMPLATE_DIR"
  exit 4
fi

# clean workspace
rm -rf "$OUTDIR"
mkdir -p "$OUTDIR/main"

# copy template and converted file
cp -r "$TEMPLATE_DIR/"* "$OUTDIR/"
cp "$CPP_PATH" "$OUTDIR/main/Main.ino.cpp"

echo "Building from converted file: $CPP_PATH"
echo "Working dir: $OUTDIR"
echo "Build log: $LOGFILE"

# source ESP-IDF export if IDF_PATH is set and export.sh exists
if [ -n "${IDF_PATH:-}" ] && [ -f "$IDF_PATH/export.sh" ]; then
  source "$IDF_PATH/export.sh"
fi

if ! command -v idf.py >/dev/null 2>&1; then
  echo "Error: idf.py not found in PATH. Make sure ESP-IDF is installed and export.sh is sourced."
  exit 5
fi

cd "$OUTDIR"
set +e
idf.py build > "$LOGFILE" 2>&1
BUILD_RC=$?
set -e

if [ $BUILD_RC -ne 0 ]; then
  echo "BUILD FAILED. See $LOGFILE"
  exit $BUILD_RC
fi

ARTIFACT=$(find build -type f \( -name "*.elf" -o -name "*.bin" \) -printf "%s %p\n" 2>/dev/null | sort -nr | awk 'NR==1{print $2}' || true)

if [ -z "$ARTIFACT" ]; then
  echo "ERROR: build succeeded but no artifact found in build/"
  exit 6
fi

ARTIFACT_PATH="$(realpath "$OUTDIR/$ARTIFACT")"
echo "$ARTIFACT_PATH" > "$ARTIFACT_FILE"

echo "BUILD SUCCESS"
echo "Artifact: $ARTIFACT_PATH"
echo "Artifact path written to: $ARTIFACT_FILE"
echo "Full log: $LOGFILE"
exit 0

