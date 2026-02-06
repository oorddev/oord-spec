# Error Codes 

This document locks the error taxonomy and FINAL-blocking rules.

## Locked reason IDs

- ENUM_LIST_FAILED
- ENUM_INCONSISTENT
- WORKSET_WRITE_FAILED
- READ_FAIL
- SIZE_MISMATCH
- HASH_FAIL
- RESULT_MISSING
- RESULT_CONFLICT
- MERKLE_BUILD_FAIL
- MANIFEST_SCHEMA_INVALID
- SIG_INVALID
- TSA_FAILED
- SHARD_WRITE_FAILED
- MERGE_FAILED
- RESULTS_WRITE_FAILED

## FINAL-blocking reason IDs

- RESULT_MISSING
- RESULT_CONFLICT
- TSA_FAILED
- SIG_INVALID
- MANIFEST_SCHEMA_INVALID

## Error artifact (format)

- File: `errors.jsonl`
- Line format (JCS canonical per line):

```json
{"stage":"<stage>","reason_id":"<reason_id>","detail":"<string>","object":"<optional>"}
```
- Ordering: stable sort by (stage, reason_id, object) lexicographically
- Encoding: UTF-8, LF only, no BOM
- Digest: errors.sha256 is SHA-256 over raw errors.jsonl bytes

## Empty policy
Empty errors file is valid (zero errors allowed). Policy choice for emit/omit is locked later; recommended: always emit empty file for consistency.