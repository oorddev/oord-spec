# Work Set File (WSF) 

## Purpose

The Work Set File (WSF) defines the **closed-world object identity set**
for a sealing run. All sealing results are defined strictly as a function
of the WSF.

A seal MUST NOT be considered complete unless every WSF entry has exactly
one corresponding result record.

## File

- Name: `workset.jsonl.gz`
- Encoding: UTF-8, no BOM
- Line endings: LF
- Compression: gzip (deterministic: mtime=0, no filename)

Each line is a JCS-canonical JSON object conforming to
`workset_item_v1.schema.json`.

## Object Identity (S3)

Object identity is defined as:

- `(bucket, key, version_id)` if `version_id` is present
- `(bucket, key)` only if the workset source is immutable
  (e.g. S3 Inventory or snapshot identifier)

## Ordering

WSF lines MUST be sorted globally by:

1. `bucket`
2. `key`
3. `version_id` (missing treated as empty string)
4. `size`

Ordering is bytewise UTF-8 lexicographic.

## Workset Source

Each seal MUST record how the WSF was produced. Supported source types:

- `storage_snapshot_id`
- `s3_inventory`
- `versioned_listing`
- `live_list_best_effort`

If the dataset can mutate and no immutable reference is used,
the seal MUST NOT be FINAL.

### Source Evidence (Normative)

The `workset.source.details` object MUST contain source-specific evidence:

- `s3_inventory`:
  - `manifest_key`
  - `manifest_sha256`

- `storage_snapshot_id`:
  - `snapshot_id`
  - `timestamp`

- `versioned_listing`:
  - `source_description`

- `live_list_best_effort`:
  - `enumeration_start_time`
  - `enumeration_end_time`

Absence of required evidence for the declared source type
MUST prevent the seal from being FINAL.

## Integrity Binding

The manifest MUST record:

- `workset.sha256` — SHA-256 of compressed bytes
- `workset.record_count` — number of lines
