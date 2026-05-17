#!/usr/bin/env bash

set -euo pipefail

LOGFILE="$HOME/Library/Logs/LaunchAgents/cleanup-downloads.script.log"
exec >> "$LOGFILE" 2>&1

echo "=== $(date): Running cleanup_downloads.sh ==="

DOWNLOADS="$HOME/Downloads"

find "$DOWNLOADS" -maxdepth 1 -type f -mtime +1 \( \
  -name "*.dmg" -o \
  -name "*.icns" -o \
  -name "*.crdownload" -o \
  -name "*.part" \
\) -print -delete

echo "=== $(date): Completed cleanup_downloads.sh ==="
