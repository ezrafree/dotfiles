#!/usr/bin/env bash

set -euo pipefail

echo "=== $(date): Running cleanup_screenshots.sh ==="

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

find "$SCREENSHOT_DIR" \
  -maxdepth 1 \
  -type f \
  ! -name ".DS_Store" \
  -mmin +240 \
  -print \
  -exec /usr/bin/trash {} \;

echo "=== $(date): Completed cleanup_screenshots.sh ==="
