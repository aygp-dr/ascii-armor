# examples/ — Sample Encoded Files

Each file encodes the same 8x8 PNG test image (67 bytes) in different formats.

| File | Format | Year | Overhead | Decoder |
|------|--------|------|----------|---------|
| sample.uu | uuencode | 1980 | ~37% | `uudecode` |
| sample.b64 | base64 | 1987 | ~33% | `b64decode` |
| sample.a85 | Ascii85 (Adobe) | 1985 | ~25% | Python `base64.a85decode` |
| sample.hex | xxd hex dump | 1990 | ~300% | `xxd -r` |
| sample-xxd.h | xxd C include | 1990 | ~400% | C compiler |
| sample.xbm | X BitMap | 1989 | variable | X11 / ImageMagick |
| sample.xpm | X PixMap | 1989 | variable | X11 / ImageMagick |

## Validation

Run `./bin/armor-check examples/*` to verify all samples round-trip correctly.

## Source Image

The test PNG is an 8x8 solid gray image (67 bytes raw).
