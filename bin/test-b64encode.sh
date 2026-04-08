#!/bin/sh
set -e
INPUT=tests/fixtures/binary.bin

# FreeBSD b64encode / b64decode
b64encode -r "$INPUT" binary > /tmp/binary.b64
b64decode -r /tmp/binary.b64 > /tmp/binary.b64.out 2>/dev/null \
  || b64decode /tmp/binary.b64 > /tmp/binary.b64.out

if cmp -s "$INPUT" /tmp/binary.b64.out; then
  echo "PASS b64encode/b64decode round-trip"
else
  echo "FAIL b64encode/b64decode round-trip"
  exit 1
fi

# Python base64 cross-check
python3 - << 'PYEOF'
import base64
orig = open('tests/fixtures/binary.bin','rb').read()
encoded = base64.b64encode(orig)
decoded = base64.b64decode(encoded)
assert orig == decoded, f"FAIL python base64: {orig!r} != {decoded!r}"
overhead = (len(encoded) - len(orig)) / len(orig) * 100
print(f"PASS python base64 round-trip, overhead={overhead:.1f}%")
PYEOF
