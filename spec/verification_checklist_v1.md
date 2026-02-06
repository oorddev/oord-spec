# Oord Verification Checklist v1

**Court-Facing, Step-By-Step**

**Audience:** Expert witnesses, courts, regulators
**Purpose:** Provide a deterministic checklist to verify an Oord dataset seal **without trusting the custodian or vendor**.

---

## Inputs Required (verify presence)

☐ `manifest.json`
☐ `manifest.sig`
☐ `workset.jsonl.gz`
☐ `inventory.jsonl.gz`
☐ `results.jsonl.gz`
☐ `*.sha256` digest files for each companion file
☐ RFC 3161 timestamp response file (e.g. `dataset_root.tsr`)
☐ Signer public key or certificate chain

If any required artifact is missing → **INCONCLUSIVE**

---

## Step 1 — Schema validity

☐ Validate `manifest.json` against `manifest_v1.schema.json`
☐ Confirm no undeclared fields are present

Failure → **FAIL**

---

## Step 2 — Canonicalization

☐ Canonicalize manifest using RFC 8785 JCS
☐ Confirm canonical bytes are used for all cryptographic checks

Failure → **FAIL**

---

## Step 3 — Signature verification

☐ Verify signature using declared suite (Ed25519 or RSA-PSS)
☐ Verify signature covers the canonical signing payload

Failure → **FAIL**

---

## Step 4 — Timestamp verification

☐ Verify RFC 3161 token cryptographically
☐ Confirm timestamp covers `roots.dataset_root_sha256`
☐ Confirm timestamp authority is valid

If timestamp invalid and outcome = FINAL → **FAIL**
If timestamp invalid and outcome ≠ FINAL → continue, note limitation

---

## Step 5 — Companion file integrity

For each file below, compute SHA-256 over **compressed bytes** and compare to manifest:

☐ `workset.jsonl.gz`
☐ `inventory.jsonl.gz`
☐ `results.jsonl.gz`

Any mismatch → **FAIL**

---

## Step 6 — Workset verification

☐ Parse `workset.jsonl.gz`
☐ Verify ordering rules
☐ Count records
☐ Confirm `workset.record_count` matches

☐ Review `workset.source.type`
☐ Confirm `workset.source.details` is non-empty
☐ If source is mutable with no immutable reference → outcome MUST NOT be FINAL

Failure → **FAIL**

---

## Step 7 — Results completeness

☐ Parse `results.jsonl.gz`
☐ Count result records
☐ Detect duplicate `object_id` values
☐ Detect conflicting `(path,size,sha256)` tuples

Confirm:

☐ `results_record_count == workset_record_count`
☐ `missing_count == 0`
☐ `conflict_count == 0`

If any condition fails → outcome MUST be NON_FINAL
If manifest claims FINAL anyway → **FAIL**

---

## Step 8 — Inventory verification

☐ Parse `inventory.jsonl.gz`
☐ Validate each record schema
☐ Verify global ordering
☐ Confirm `inventory.record_count`, `file_count`, `total_bytes`

Failure → **FAIL**

---

## Step 9 — Merkle root recomputation

☐ Recompute leaf payloads deterministically
☐ Apply ordering rules
☐ Rebuild Merkle tree (and chunking if applicable)
☐ Compute `dataset_root_sha256`

If recomputed root ≠ manifest root → **FAIL**

---

## Step 10 — Outcome consistency

☐ Confirm manifest outcome matches observed facts

Rules:

* FINAL requires **all checks pass**
* NON_FINAL allowed only when completeness or timestamp conditions are unmet
* ABORTED indicates no coherent seal exists

Inconsistency → **FAIL**

---

## Optional — Subset verification

If subset proofs provided:

☐ Verify proof structure
☐ Recompute leaf hash
☐ Walk Merkle path to dataset root
☐ Confirm root matches manifest

Failure → **FAIL**

---

## Final Determination

* **PASS** — All required checks succeed
* **FAIL** — Any cryptographic or completeness check fails
* **INCONCLUSIVE** — Required artifacts missing, no cryptographic failure proven

No other outcomes are permitted.

---

## Key Assertion for the Court

If verification **PASS** is reached, the verifier can state:

> *“This manifest proves, cryptographically and independently, that the committed dataset existed in this exact form at or before the recorded timestamp and has not been altered since.”*

Nothing more. Nothing less.