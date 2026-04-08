#!/bin/sh
set -e
INPUT=tests/fixtures/binary.bin

# xxd → reverse xxd
xxd "$INPUT" > /tmp/binary.xxd
xxd -r /tmp/binary.xxd > /tmp/binary.xxd.out

if cmp -s "$INPUT" /tmp/binary.xxd.out; then
  echo "PASS xxd round-trip"
else
  echo "FAIL xxd round-trip"
  exit 1
fi
