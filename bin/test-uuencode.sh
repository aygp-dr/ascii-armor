#!/bin/sh
set -e
INPUT=tests/fixtures/cat.txt
ENCODED=$(uuencode "$INPUT" cat.txt)
DECODED=$(echo "$ENCODED" | uudecode -o /dev/stdout 2>/dev/null \
          || echo "$ENCODED" | uudecode -p)

ORIG=$(cat "$INPUT")
if [ "$DECODED" = "$ORIG" ]; then
  echo "PASS uuencode round-trip: '$ORIG' → encoded → '$DECODED'"
else
  echo "FAIL uuencode round-trip: got '$DECODED' expected '$ORIG'"
  exit 1
fi

# Binary round-trip
uuencode tests/fixtures/binary.bin binary.bin > /tmp/binary.uu
uudecode -o /tmp/binary.out /tmp/binary.uu 2>/dev/null \
  || uudecode -p /tmp/binary.uu > /tmp/binary.out
if cmp -s tests/fixtures/binary.bin /tmp/binary.out; then
  echo "PASS uuencode binary round-trip (32 bytes)"
else
  echo "FAIL uuencode binary round-trip"
  exit 1
fi
