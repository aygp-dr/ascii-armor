#!/bin/sh
XBM=tests/fixtures/xlogo16.xbm

echo "=== XBM structure check ==="
grep '#define' "$XBM"
grep 'static unsigned char' "$XBM"

# Count hex bytes
BYTES=$(grep -o '0x[0-9a-f][0-9a-f]' "$XBM" | wc -l | tr -d ' ')
WIDTH=$(grep 'width'  "$XBM" | awk '{print $3}')
HEIGHT=$(grep 'height' "$XBM" | awk '{print $3}')
EXPECTED=$(( (WIDTH + 7) / 8 * HEIGHT ))

echo "width=$WIDTH height=$HEIGHT bytes_in_file=$BYTES expected_bytes=$EXPECTED"

if [ "$BYTES" -eq "$EXPECTED" ]; then
  echo "PASS XBM byte count: $BYTES == $EXPECTED"
else
  echo "FAIL XBM byte count: $BYTES != $EXPECTED"
  exit 1
fi
