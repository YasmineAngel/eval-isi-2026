#!/usr/bin/env bash
#file: find.sh
set -euo pipefail
NAME="${1:-}"
[ -n "$NAME" ] || { echo "Usage: $0 name" >&2; exit 1; }
[ -f ramdisk/master.key ] || { echo "master key missing (run ./boot.sh)" >&2; exit 1; }
KHEX="$(hexdump -ve '1/1 "%02X"' ramdisk/master.key)"
# Find first matching line
LINE="$(grep -m1 -F -- "${NAME}§" data.txt 2>/dev/null || true)"
[ -n "$LINE" ] || exit 1
IFS='§' read -r N IVHEX CIPH_B64 <<< "$LINE"
# Decrypt and output plaintext card
echo "$CIPH_B64" | base64 -d | openssl enc -d -aes-256-cbc -K "$KHEX" -iv "$IVHEX"
