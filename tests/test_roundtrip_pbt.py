#!/usr/bin/env python3
"""
Property-based tests for binary-to-text encoding round-trips.

The fundamental invariant:
    ∀ x : bytes. decode(encode(x)) == x

Using Hypothesis for property-based testing (PBT).
"""

import base64
import codecs
from hypothesis import given, strategies as st, settings, assume

# --- Base64 ---

@given(st.binary())
def test_base64_roundtrip(data: bytes) -> None:
    """decode(encode(x)) == x for all byte sequences"""
    encoded = base64.b64encode(data)
    decoded = base64.b64decode(encoded)
    assert decoded == data

@given(st.binary())
def test_base64_encoding_stability(data: bytes) -> None:
    """encode(decode(encode(x))) == encode(x)"""
    encoded1 = base64.b64encode(data)
    decoded = base64.b64decode(encoded1)
    encoded2 = base64.b64encode(decoded)
    assert encoded1 == encoded2

@given(st.binary())
def test_base64_overhead(data: bytes) -> None:
    """Base64 overhead is exactly ceil(len/3)*4 / len"""
    if len(data) == 0:
        return
    encoded = base64.b64encode(data)
    # Base64: 3 bytes -> 4 chars, padded to multiple of 4
    expected_len = ((len(data) + 2) // 3) * 4
    assert len(encoded) == expected_len

@given(st.binary())
def test_base64_alphabet(data: bytes) -> None:
    """Base64 output contains only valid alphabet chars"""
    encoded = base64.b64encode(data)
    alphabet = set(b'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=')
    assert all(c in alphabet for c in encoded)


# --- Ascii85 ---

@given(st.binary())
def test_ascii85_roundtrip(data: bytes) -> None:
    """decode(encode(x)) == x for Ascii85"""
    encoded = base64.a85encode(data, adobe=True)
    decoded = base64.a85decode(encoded, adobe=True)
    assert decoded == data

@given(st.binary())
def test_ascii85_encoding_stability(data: bytes) -> None:
    """encode(decode(encode(x))) == encode(x) for Ascii85"""
    encoded1 = base64.a85encode(data, adobe=True)
    decoded = base64.a85decode(encoded1, adobe=True)
    encoded2 = base64.a85encode(decoded, adobe=True)
    assert encoded1 == encoded2

@given(st.binary(min_size=100))
def test_ascii85_better_than_base64(data: bytes) -> None:
    """Ascii85 overhead < Base64 overhead for larger data"""
    b64_len = len(base64.b64encode(data))
    a85_len = len(base64.a85encode(data, adobe=True))
    # Ascii85 is 5/4 = 1.25x, Base64 is 4/3 = 1.33x
    # Adobe wrapper <~ ~> adds 4 bytes overhead
    # For data >= 100 bytes, Ascii85 should be shorter
    assert a85_len <= b64_len, f"a85={a85_len} > b64={b64_len} for {len(data)} bytes"


# --- uuencode ---

@given(st.binary())
def test_uuencode_roundtrip(data: bytes) -> None:
    """decode(encode(x)) == x for uuencode"""
    encoded = codecs.encode(data, 'uu')
    decoded = codecs.decode(encoded, 'uu')
    assert decoded == data

@given(st.binary())
def test_uuencode_encoding_stability(data: bytes) -> None:
    """encode(decode(encode(x))) == encode(x) for uuencode"""
    encoded1 = codecs.encode(data, 'uu')
    decoded = codecs.decode(encoded1, 'uu')
    encoded2 = codecs.encode(decoded, 'uu')
    assert encoded1 == encoded2


# --- Hex (xxd style) ---

@given(st.binary())
def test_hex_roundtrip(data: bytes) -> None:
    """decode(encode(x)) == x for hex"""
    encoded = data.hex()
    decoded = bytes.fromhex(encoded)
    assert decoded == data

@given(st.binary())
def test_hex_overhead(data: bytes) -> None:
    """Hex overhead is exactly 100% (2 chars per byte)"""
    if len(data) == 0:
        return
    encoded = data.hex()
    assert len(encoded) == len(data) * 2


# --- Cross-encoding invariants ---

@given(st.binary())
def test_all_encodings_preserve_data(data: bytes) -> None:
    """All encodings preserve the original data exactly"""
    # Base64
    assert base64.b64decode(base64.b64encode(data)) == data
    # Ascii85
    assert base64.a85decode(base64.a85encode(data, adobe=True), adobe=True) == data
    # uuencode
    assert codecs.decode(codecs.encode(data, 'uu'), 'uu') == data
    # Hex
    assert bytes.fromhex(data.hex()) == data


# --- Channel constraint tests ---

@given(st.binary())
def test_base64_7bit_clean(data: bytes) -> None:
    """Base64 output is 7-bit ASCII clean (all chars 32-126)"""
    encoded = base64.b64encode(data)
    for byte in encoded:
        assert 32 <= byte <= 126, f"Non-printable byte: {byte}"

@given(st.binary())
def test_uuencode_7bit_clean(data: bytes) -> None:
    """uuencode output is 7-bit ASCII (may include newlines)"""
    encoded = codecs.encode(data, 'uu')
    for byte in encoded:
        # uuencode uses 32-96 (space through backtick) plus newlines (10)
        # Also includes 'begin'/'end' markers with letters
        assert byte == 10 or (32 <= byte <= 126), f"Invalid byte: {byte}"


if __name__ == '__main__':
    import pytest
    pytest.main([__file__, '-v'])
