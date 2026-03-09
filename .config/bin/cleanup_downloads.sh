#!/usr/bin/env bash
set -euo pipefail
LOGFILE="$HOME/cleanup_downloads.log"
exec >> "$LOGFILE" 2>&1
echo "=== $(date): Running cleanup_downloads.sh ==="
DOWNLOADS="$HOME/Downloads"
find "$DOWNLOADS" -maxdepth 1 -type f -name "*.dmg" -mtime +1 -print -delete
find "$DOWNLOADS" -maxdepth 1 -type f -name "*.icns" -mtime +1 -print -delete
find "$DOWNLOADS" -maxdepth 1 -type f -name "*.crdownload" -mtime +1 -print -delete
find "$DOWNLOADS" -maxdepth 1 -type f -name "*.part" -mtime +1 -print -delete
echo "=== $(date): Completed cleanup_downloads.sh ==="
