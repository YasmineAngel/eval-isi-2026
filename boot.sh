#!/usr/bin/env bash
#file: boot.sh
set -euo pipefail
mkdir -p ramdisk
# Must have encrypted keys on the "USB" dirs
[ -f usb_leg/key_leg.enc ] || { echo "missing usb_leg/key_leg.enc" >&2; exit 1; }
[ -f usb_tec/key_tec.enc ] || { echo "missing usb_tec/key_tec.enc" >&2; exit 1; }
echo "--== Legal officer unlock ==--"
# OpenSSL will prompt for the password
openssl enc -d -aes-256-cbc -in usb_leg/key_leg.enc -out ramdisk/key_leg.bin -pbkdf2
echo "--== Technical officer unlock ==--"
openssl enc -d -aes-256-cbc -in usb_tec/key_tec.enc -out ramdisk/key_tec.bin -pbkdf2
# master = xor(key_tec, key_jur)
python3 -c '
a=open("ramdisk/key_tec.bin","rb").read()
b=open("ramdisk/key_leg.bin","rb").read()
open("ramdisk/master.key","wb").write(bytes([x^y for x,y in zip(a,b)]))
'
# Cleanup: keep only master in ramdisk
rm -f ramdisk/key_tec.bin ramdisk/key_leg.bin
echo "system ready."
