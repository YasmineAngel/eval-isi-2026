#!/usr/bin/env bash
#file: add.sh
set -euo pipefail
NAME="${1:-}"
CARD="${2:-}"
[ -n "$NAME" ] && [ -n "$CARD" ] || { echo "Usage: $0 name card" >&2; exit 1; }
[ -f ramdisk/master.key ] || { echo "master key missing (run ./boot.sh)" >&2; exit 1; }
# Key (hex) for openssl -K
KHEX="$(hexdump -ve '1/1 "%02X"' ramdisk/master.key)"
# Random IV (16 bytes) in hex (as required)
IVHEX="$(dd if=/dev/urandom bs=16 count=1 2>/dev/null | hexdump -ve '1/1 "%02X"')"
# Encrypt card -> base64
CIPH_B64="$(echo "$CARD" | openssl enc -aes-256-cbc -K "$KHEX" -iv "$IVHEX" -nosalt | base64)"
# Append entry: name§ivhex§base64
printf "%s§%s§%s\n" "$NAME" "$IVHEX" "$CIPH_B64" >> data.txt
echo "done"

