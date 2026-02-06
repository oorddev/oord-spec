# Leaf Encoding 

Leaf encoding defines the exact byte payload hashed for Merkle leaves. This is byte-level normative.

## Inputs

- `path_bytes`: UTF-8 bytes of the normalized path string (normalization rules are defined by the inventory format / path semantics docs)
- `size`: uint64
- `file_sha256`: 32 bytes

## Encoding
```
leaf_payload = len(path_bytes) || path_bytes || uint64_be(size) || file_sha256
leaf_hash = SHA256(0x00 || leaf_payload)
```
Where:

- `len(path_bytes)` is a uint32 big-endian length
- `uint64_be(size)` is uint64 big-endian
- `file_sha256` is raw 32 bytes (not hex text)
- domain separation prefix `0x00` is a single byte

## Notes

- This format avoids JSON ambiguity and keeps proof verification tool-independent.

