# Merkle

Defines the Merkle commitment construction used for dataset roots.

## Hash function

SHA-256 only.

## Domain separation

- Leaf prefix: `0x00`
- Node prefix: `0x01`

## Leaf hash

Leaf hash is defined in `leaf_encoding.md`.

## Node hash
```
node = SHA256(0x01 || left32 || right32)
```
Where `left32` and `right32` are the raw 32-byte child hashes.

## Leaf ordering (deterministic)

Leaves are sorted by:

1. `normalized_path_bytes` (lexicographic by bytes)
2. `size` (numeric)
3. `file_sha256` (lexicographic by bytes)

## Chunking (scale)

- Leaves are partitioned into chunks of `chunk_size_leaves` (e.g., 1,048,576 = 2^20).
- Each chunk produces a `chunk_root`.
- The dataset root commits to the **ordered list** of chunk roots (top-level Merkle over chunk roots).

## Dataset root

The committed dataset root is the Merkle root of the ordered chunk roots list, encoded as the canonical `dataset_root_sha256` recorded in the manifest.
