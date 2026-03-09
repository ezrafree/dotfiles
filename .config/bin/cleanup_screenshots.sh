#!/usr/bin/env bash
set -euo pipefail
exec >> "$HOME/cleanup_screenshots.log" 2>&1
echo "=== $(date): Running cleanup_screenshots.sh ==="
rm -f "$HOME/Pictures/Screenshots/"*
echo "=== $(date): Completed cleanup_screenshots.sh ==="
