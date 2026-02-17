PoC "Bank card file" (biased / simplified version)
===================================================

Goal
----
This proof-of-concept demonstrates a very simplified scheme where:
- bank card numbers are stored encrypted (AES-256-CBC),
- user names are stored in clear text,
- the "master key" is only available after a shared-authority boot (2 officers),
- NO integrity / authentication is provided (deliberate for this PoC).

Directory layout
----------------
- `./usb_tec/`   : simulated USB directory for the Technical officer
- `./usb_jur/`   : simulated USB directory for the Legal officer
- `./ramdisk/`   : simulated RAM disk (session material, master key)
- `./data.txt`   : the encrypted database (one entry per line)
- `./init.sh`    : initialize USB keys + produce encrypted USB blobs
- `./boot.sh`    : unlock USB keys and rebuild the master key in ramdisk
- `./add.sh`     : add an entry (name + card)
- `./find.sh`    : decrypt and print a card number by name
- `./del.sh`     : delete an entry by name (optionally check card matches)

Data format (data.txt)
----------------------
Each line is:
  `NAME§IVHEX§CIPHERTEXT_BASE64`

Where:
- `NAME` is in clear text
- `IVHEX` is 16 bytes IV encoded in hex (32 hex chars)
- `CIPHERTEXT_BASE64` is the AES-256-CBC encryption of the card number (base64)

Cryptography (two officer)
--------------------------
- Two random 32-byte secrets are generated at init:
    `ramdisk/key_tec.bin`  (technical officer secret)
    `ramdisk/key_jur.bin`  (legal officer secret)
- The master key is computed as:
    master = key_tec XOR key_jur
  (computed with a short python3 one-liner)
- Each officer secret is stored on its USB directory as an OpenSSL-encrypted blob:
    `usb_tec/key_tec.enc`
    `usb_jur/key_jur.enc`
  using:
    `openssl enc -aes-256-cbc -pbkdf2`
  OpenSSL prompts for a password interactively.

- During boot, both officers are required to unlock their USB blobs.
  The two decrypted secrets are XORed again to rebuild:
    `ramdisk/master.key`

Requirements
------------
- bash
- openssl
- python3
- dd, hexdump, grep

Example session
---------------
```bash
$ ./init.sh
```
--== Legal officer setup ==--
(enter password when prompted by OpenSSL)
--== Technical officer setup ==--
(enter password when prompted by OpenSSL)
done.
```bash
$ ./boot.sh
```
--== Legal officer unlock ==--
(enter password when prompted by OpenSSL)
--== Technical officer unlock ==--
(enter password when prompted by OpenSSL)
system ready.

```bash
$ ./add.sh Gilles 411111
done
```

```bash
$ ./add.sh Asli 311111
done
```

```bash
$ ./add.sh Marc 211111
done
```

```bash
$ ./find.sh Asli
311111
```

```bash
$ ./del.sh Asli
done
```

Optional delete with card check
-------------------------------
```bash
$ ./del.sh Asli 311111
done
```

Notes
-----
- If `ramdisk/master.key` is missing, add/find/del will refuse to run
  and you must run `./boot.sh` first.
- IVs are generated from `/dev/urandom` using dd and stored in hex.
- The card ciphertext is stored in base64 for convenience.

