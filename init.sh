#!/usr/bin/env bash
#file: init.sh 
set -euo pipefail
mkdir -p usb_tec usb_leg ramdisk
touch data.txt
# Generate 32-byte random keys for each role
dd if=/dev/urandom of=ramdisk/key_tec.bin bs=32 count=1 2>/dev/null
dd if=/dev/urandom of=ramdisk/key_leg.bin bs=32 count=1 2>/dev/null
# master = xor(key_tec, key_jur)
python3 -c '
a=open("ramdisk/key_tec.bin","rb").read()
b=open("ramdisk/key_leg.bin","rb").read()
open("ramdisk/master.key","wb").write(bytes([x^y for x,y in zip(a,b)]))
'
echo "--== Legal officer setup ==--"
# Encrypt legal key onto the legal USB dir (OpenSSL prompts for the password)
openssl enc -aes-256-cbc -in ramdisk/key_leg.bin -out usb_leg/key_leg.enc -pbkdf2
echo "--== Technical officer setup ==--"
# Encrypt technical key onto the technical USB dir
openssl enc -aes-256-cbc -in ramdisk/key_tec.bin -out usb_tec/key_tec.enc -pbkdf2
# Cleanup clear key material in ramdisk except master
rm -f ramdisk/key_tec.bin ramdisk/key_leg.bin
echo "done."
