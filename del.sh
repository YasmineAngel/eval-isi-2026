#!/usr/bin/env bash
#file: del.sh
set -euo pipefail
NAME="${1:-}"
[ -n "$NAME" ] || { echo "Usage: $0 name" >&2; exit 1; }
[ -f data.txt ] || { echo "done"; exit 0; }
# Remove all lines starting with NAME§
grep -v -F -- "${NAME}§" data.txt > data.txt.new || true
mv data.txt.new data.txt
echo "done"

