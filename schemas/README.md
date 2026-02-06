# Oord JSON Schemas

This directory contains machine-validated schemas for Oord v1 artifacts.

## Scope

Schemas in this directory define normative JSON structures for Oord v1 artifacts.

Some schemas (notably `manifest_v1.schema.json`) encode
file-level and cross-field constraints such as finality conditions,
completeness requirements, and verification preconditions.

Those guarantees are defined normatively in the specification documents
under `/spec`.

## JSONL Validation Rule

All `.jsonl` companion files are validated by applying the corresponding
`*_item_vN.schema.json` schema to **each decompressed line independently**.

File-level guarantees (ordering, completeness, determinism, coverage gates)
are enforced by the specification, not by JSON Schema.

## Versioning

Schemas are immutable once published.

Breaking changes require a new versioned schema file
(e.g. `inventory_item_v2.schema.json`) and a corresponding spec update.
