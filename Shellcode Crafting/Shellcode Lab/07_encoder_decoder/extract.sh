#!/bin/bash
set -euo pipefail

objcopy -O binary --only-section=.text decoder.o decoder.bin
xxd -g 1 decoder.bin
printf '[+] Decoder size: '
wc -c < decoder.bin
