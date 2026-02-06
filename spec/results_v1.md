# Results v1 (results.jsonl.gz)

## Purpose

`results.jsonl.gz` is the deterministic, mergeable output of the distributed hashing phase.

It exists to make sealing fault-tolerant and resumable **without** producing billions of tiny result objects.

A seal may be marked FINAL only if the results are mechanically complete relative to the Work Set File (WSF).

## Files

- `results.jsonl.gz` — gzip-compressed JSON Lines (UTF-8)
- `results.sha256` — SHA-256 digest of the **compressed bytes** of `results.jsonl.gz`

## Record format

Each line in `results.jsonl.gz` is a single **JCS-canonical** JSON object that conforms to:

- `schemas/result_record_v1.schema.json`

Each record represents one hashed object from the workset.

### Required keys

- `object_id` — stable object identifier hash (lowercase hex SHA-256)
- `path` — normalized path (or storage key normalized into the spec’s path model)
- `size` — exact byte length (uint64 semantics)
- `sha256` — SHA-256 digest of content bytes (lowercase hex)

Example line:
```json
{"object_id":"<64-hex>","path":"<normalized_path>","size":123,"sha256":"<64-hex>"}
```
## Determinism rules (LOCKED)

`results.jsonl.gz` MUST be deterministic given the same WSF + byte content.

### Line ordering

The ordering applied is identified in the manifest as:

`sealing_configuration.ordering = "object_id_path_size_sha256"`

Lines MUST be sorted by:

1. `object_id` (lexicographic)
2. `path` (lexicographic)
3. `size` (numeric)
4. `sha256` (lexicographic)

No downstream re-sorting is permitted outside the sealed generation flow.

### Gzip requirements

`results.jsonl.gz` MUST use deterministic gzip settings:

* UTF-8, no BOM
* LF newlines only
* gzip `mtime=0`
* no filename field
* stable compression parameters (implementation-locked in toolchain)

### Digest binding

`results.sha256` is SHA-256 over the **compressed bytes** of `results.jsonl.gz`.

The manifest binds results via `results_sha256` and `results_record_count`.

## Object ID derivation (AWS S3)

For S3 objects, `object_id` is derived as:

```
object_id_bytes =
bucket_utf8 + "\n" +
key_utf8 + "\n" +
(version_id_utf8 or "")
object_id = SHA256(object_id_bytes)
```

* `bucket_utf8` and `key_utf8` are raw UTF-8 bytes of bucket + key
* `version_id_utf8` is the S3 VersionId string if present, else empty
* output encoding is lowercase hex

## Completeness and conflict handling

The results file is evaluated against the WSF:

* `results_record_count` = number of JSONL lines in `results.jsonl.gz`
* `missing_count` = count of WSF items with no matching `object_id` in results
* `conflict_count` = count of `object_id` values that appear multiple times **with non-identical** `(path,size,sha256)` tuples

Duplicates are allowed only if they are **byte-identical records** (e.g., merge artifacts).
Any non-identical duplicate is a conflict.

## Finalization gate (LOCKED)

A seal may be marked FINAL only if:

* `results_record_count == workset_record_count`
* `missing_count == 0`
* `conflict_count == 0`
* manifest signature verifies
* RFC 3161 timestamp verifies (per timestamp policy)
* recomputed root matches `roots.dataset_root_sha256`

Otherwise, the outcome MUST be `NON_FINAL` or `ABORTED`.