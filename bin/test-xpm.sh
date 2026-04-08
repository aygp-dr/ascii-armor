#!/bin/sh
XPM=tests/fixtures/check4.xpm

echo "=== XPM structure check ==="
# First string after "/* XPM */" contains: width height ncolors chars_per_pixel
VALUES=$(grep '"[0-9]' "$XPM" | head -1 | tr -d '",' | awk '{print $1,$2,$3,$4}')
WIDTH=$(echo $VALUES | awk '{print $1}')
HEIGHT=$(echo $VALUES | awk '{print $2}')
NCOLORS=$(echo $VALUES | awk '{print $3}')
CPP=$(echo $VALUES | awk '{print $4}')

echo "width=$WIDTH height=$HEIGHT ncolors=$NCOLORS chars_per_pixel=$CPP"

# Count pixel rows (lines after palette entries)
ROWS=$(grep -c '^"[^0-9 ]' "$XPM" 2>/dev/null || \
       awk '/^"[a-z]/{if(NR>5)c++} END{print c}' "$XPM")

echo "pixel_rows=$ROWS expected=$HEIGHT"

if command -v convert >/dev/null 2>&1; then
  convert tests/fixtures/check4.xpm /tmp/check4.png && \
    echo "PASS convert XPM → PNG" || echo "FAIL convert XPM → PNG"
else
  echo "SKIP convert not available"
fi
