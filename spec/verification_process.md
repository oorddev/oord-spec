# Oord Verification Process

**Independent, Offline Verification Procedure**

**Audience:** Courts, expert witnesses, regulators, auditors
**Goal:** Describe exactly how a third party verifies an Oord seal **without trusting the custodian or Oord**.

---

## 1. Purpose of Verification

Verification answers one narrow question:

> **Does this seal cryptographically prove that a specific dataset existed, unaltered, at or before a specific time?**

Verification does **not** decide:

* lawfulness
* relevance
* disclosure obligations
* whether the dataset was actually used to train a model

Those are legal questions. Verification answers the **integrity and time** question only.

---

## 2. Inputs Required for Verification

A verifier must be provided with:

### Required artifacts

* `manifest.json`
* `manifest.sig`
* `inventory.jsonl.gz`
* `inventory.sha256`
* `results.jsonl.gz`
* `results.sha256`
* RFC 3161 timestamp response file (e.g. `dataset_root.tsr`)
* Signer public key or certificate chain

### Optional artifacts (for subset verification)

* Merkle proof files under `proofs/`

No network access is required.

---

## 3. Verification Outcomes

Verification produces exactly one outcome:

* **PASS** — all required checks succeed
* **FAIL** — a required cryptographic or completeness check fails
* **INCONCLUSIVE** — required artifacts are missing, but no cryptographic failure is proven

A verifier MUST NOT reinterpret or soften these outcomes.

---

## 4. Step-by-Step Verification Procedure

### Step 1 — Schema Validation

Validate `manifest.json` against:

```
schemas/manifest_v1.schema.json
```

If schema validation fails → **FAIL**

This ensures:

* required fields are present
* no undeclared fields exist
* structural integrity of the declaration

---

### Step 2 — Canonicalization

Canonicalize the manifest using **RFC 8785 JSON Canonicalization Scheme (JCS)**.

All subsequent cryptographic checks operate on canonical bytes, not presentation formatting.

---

### Step 3 — Signature Verification

Verify `manifest.sig` against:

* the canonicalized manifest signing payload
* the declared signature suite (Ed25519 or RSA-PSS)
* the provided public key or certificate chain

If the signature does not verify → **FAIL**

This step proves **authenticity** of the declaration.

---

### Step 4 — Timestamp Verification

Verify the RFC 3161 timestamp token:

* the token must verify cryptographically
* the token must cover the committed digest
* the digest must correspond to `roots.dataset_root_sha256`

If timestamp verification fails and the manifest outcome is FINAL → **FAIL**

If timestamp verification fails and outcome is NON_FINAL → continue, but note lack of court-grade finality.

This step establishes **independent time anchoring**.

---

### Step 5 — Companion File Integrity Checks

Verify companion file bindings:

1. Compute SHA-256 over **compressed bytes** of:

   * `workset.jsonl.gz`
   * `inventory.jsonl.gz`
   * `results.jsonl.gz`

2. Compare each digest to the value recorded in the manifest.

Any mismatch → **FAIL**

This prevents post-hoc modification or repackaging.

---

### Step 6 — Workset Evaluation

Parse `workset.jsonl.gz`:

* Verify line ordering rules
* Count records
* Confirm `workset.record_count` matches

Verify the declared workset source:

* Confirm `workset.source.type`
* Review `workset.source.details` for evidence
* If the source is mutable and no immutable reference exists, the seal MUST NOT be FINAL

Schema or count mismatch → **FAIL**

---

### Step 7 — Results Completeness Check

Parse `results.jsonl.gz`:

* Count records
* Detect duplicate `object_id` values
* Detect conflicting `(path, size, sha256)` tuples

Verify:

```
results_record_count == workset_record_count
missing_count == 0
conflict_count == 0
```

If any condition fails → outcome MUST be NON_FINAL or ABORTED
If manifest claims FINAL anyway → **FAIL**

This step enforces **mechanical completeness**.

---

### Step 8 — Inventory Verification

Parse `inventory.jsonl.gz`:

* Verify line ordering
* Validate each record schema
* Confirm `inventory.record_count`, `file_count`, `total_bytes`

Any mismatch → **FAIL**

The inventory is the authoritative source for recomputation.

---

### Step 9 — Merkle Root Recalculation

Using inventory records:

1. Construct leaf payloads per spec
2. Hash leaves with domain separation
3. Apply deterministic ordering
4. Build chunk roots if applicable
5. Compute `dataset_root_sha256`

If recomputed root ≠ manifest root → **FAIL**

This step proves **byte-level integrity**.

---

### Step 10 — Outcome Consistency Check

Confirm:

* Manifest outcome is consistent with verification results
* A FINAL manifest only exists if all FINAL conditions are met

If outcome declaration contradicts facts → **FAIL**

---

## 5. Subset Verification (Optional)

Subset verification allows verification of specific files without re-hashing the full dataset.

### Inputs

* Proof request file
* Corresponding Merkle proof responses
* Manifest + root

### Procedure

* Verify proof structure
* Recompute leaf hash
* Walk Merkle path to dataset root
* Confirm root matches manifest

If proof fails → **FAIL**
If proof succeeds → inclusion is proven

---

## 6. Tooling Requirements

Verification MUST be possible using:

* OpenSSL (>= 3.0)
* Standard SHA-256 hashing tools
* No proprietary software
* No network calls

Reference implementations MAY exist, but MUST NOT be required.

---

## 7. Failure Semantics

| Condition                      | Result       |
| ------------------------------ | ------------ |
| Schema invalid                 | FAIL         |
| Signature invalid              | FAIL         |
| Timestamp invalid (FINAL)      | FAIL         |
| Companion digest mismatch      | FAIL         |
| Missing or conflicting results | FAIL         |
| Root mismatch                  | FAIL         |
| Missing artifacts              | INCONCLUSIVE |

Silent partial success is prohibited.

---

## 8. Why This Process Is Defensible

This process:

* Does not rely on testimony
* Does not rely on vendor systems
* Does not require trust assumptions
* Converts disputes into deterministic checks

It is designed to survive hostile expert review.

---

## 9. Relationship to Legal Proceedings

This verification process:

* Establishes integrity and time
* Narrows disputes
* Reduces discovery scope
* Produces reproducible evidence

It does not replace judicial judgment.
