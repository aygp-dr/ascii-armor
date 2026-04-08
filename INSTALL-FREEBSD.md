# FreeBSD Package Installation

## Required (base system)
These are already in FreeBSD 14 base:
- `uuencode` / `uudecode` - /usr/bin
- `b64encode` / `b64decode` - /usr/bin
- `xxd` - /usr/bin
- `sha256` - /usr/bin

## Required (pkg install)
```bash
pkg install git
```

## Optional tools
```bash
# GNU shar/unshar (differs from base uuencode)
pkg install sharutils

# Image conversion (XBM/XPM ↔ PNG/JPEG)
pkg install ImageMagick7
# or without X11:
pkg install ImageMagick7-nox11

# Video/image processing alternative
pkg install ffmpeg
# or without X11:
pkg install ffmpeg-nox11

# Base64 CLI (alternative to b64encode)
pkg install base64
```

## Not in ports
```bash
# compface/uncompface - X-Face encoding
# Must build from source:
# https://www.cs.indiana.edu/pub/faces/compface/compface.tar.Z

fetch https://www.cs.indiana.edu/pub/faces/compface/compface.tar.Z
tar xzf compface.tar.Z
cd compface
./configure && make && sudo make install
```

## Quick install all optional
```bash
pkg install sharutils ImageMagick7-nox11 ffmpeg-nox11
```

## Verify installation
```bash
# After pkg install, run:
sh bin/check-prereqs.sh
```
