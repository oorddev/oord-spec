# Inventory File v1

## Purpose

The inventory file materializes the WSF into a canonical list of
byte-committed file identities used to build Merkle leaves and roots.

It is the authoritative source for verification and recomputation.

## File

- Name: `inventory.jsonl.gz`
- Encoding: UTF-8, no BOM
- Line endings: LF
- Compression: gzip (deterministic)

Each line is a JCS-canonical JSON object conforming to
`inventory_item_v1.schema.json`.

## Path Semantics

Paths MUST be normalized before inventory emission:

- POSIX separators (`/`)
- No `..` traversal
- Unicode NFC normalization
- No NUL bytes

## Ordering

Inventory lines MUST be globally sorted by:

1. `path`
2. `size`
3. `sha256`

This ordering defines Merkle leaf order and MUST be deterministic.

## Integrity Binding

The manifest MUST record:

- `inventory.sha256` — SHA-256 of compressed bytes
- `inventory.record_count`
- `inventory.file_count`
- `inventory.total_bytes`

Any mismatch during verification is a FAIL.
