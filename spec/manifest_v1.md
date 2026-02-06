# Oord Manifest v1

**Human-Readable Specification**

**Status:** Locked for v1
**Audience:** Courts, regulators, expert witnesses, auditors
**Purpose:** Explain—clearly and defensibly—what a manifest is, what it proves, and what it does *not* prove.

---

## 1. What the Manifest Is

An **Oord Manifest v1** is a signed, time-anchored declaration that commits to:

* **A specific dataset workset** (closed-world list of objects)
* **The exact bytes of each object**
* **The rules used to include and exclude data**
* **The cryptographic commitment** (Merkle root) over those bytes
* **The outcome of the sealing process**

The manifest is designed to be:

* **Verified offline**
* **Using standard cryptographic tools**
* **Without trusting the dataset custodian or Oord**

---

## 2. What the Manifest Proves

A valid, FINAL manifest proves the following statement:

> *“This exact set of bytes existed and was committed to at or before the timestamp shown, under the declared inclusion and exclusion rules, and has not been altered since.”*

Specifically, it proves:

1. **Integrity**

   * Any change to any file will invalidate the commitment.
2. **Determinism**

   * Recomputing from the same inputs yields the same root.
3. **Time anchoring**

   * The commitment existed no later than the RFC 3161 timestamp.
4. **Completeness (mechanical)**

   * Every declared workset item has exactly one corresponding hash result.
5. **Adversarial verifiability**

   * Verification does not rely on vendor systems or secrets.

---

## 3. What the Manifest Does *Not* Prove

The manifest does **not** claim or prove:

* That the dataset is lawful
* That the dataset is complete in a business or ethical sense
* That exclusions were “correct,” only that they were **applied as declared**
* That the dataset was actually used to train a model
* That the contents are confidential or hidden

These questions are intentionally out of scope.

---

## 4. Verification Profile

All manifests conform to exactly one verification profile:

```
verification_profile = public_offline_v1
```

This profile requires:

* SHA-256 hashing
* Merkle commitments
* Ed25519 or RSA-PSS signatures
* RFC 3161 timestamping
* Deterministic canonicalization (RFC 8785 JCS)

**Shared-secret mechanisms (e.g., HMAC) are prohibited** because they prevent independent verification.

### Normative Schema Authority

The authoritative definition of the manifest structure is
`schemas/manifest_v1.schema.json` in the `oord-spec` repository.

If any discrepancy exists between this document and the schema,
the schema definitions take precedence.

### Byte-Level Binding (Explicit)

All digests recorded in the manifest for companion artifacts
(workset, inventory, results, chunk roots, error logs)
are computed over the **compressed on-disk bytes** of those files,
not their parsed or logical contents.

Any change to file bytes—including recompression, reordering,
or repackaging—MUST be detectable during verification.

### Errors Artifact (REQUIRED)

Every seal bundle MUST include an error log artifact, even if no errors occurred.

The manifest binds the error log via:

- `errors.file` — fixed name `errors.jsonl`
- `errors.sha256` — SHA-256 of the file bytes
- `errors.error_count` — number of error records

A zero-length error set MUST still be represented as an explicit artifact
with `error_count = 0`.

---

## 5. Manifest Structure (Conceptual)

The manifest binds together the following components:

| Section               | Purpose                       |
| --------------------- | ----------------------------- |
| Identification        | Versioning and seal identity  |
| Algorithms            | Cryptographic primitives used |
| Sealing configuration | Deterministic rules           |
| Workset               | Closed-world object list      |
| Inventory             | Canonical byte commitments    |
| Exclusions            | Declared exclusion inputs     |
| Results summary       | Completeness evidence         |
| Roots                 | Cryptographic commitments     |
| Timestamps            | Independent time anchor       |
| Signatures            | Authenticity                  |
| Toolchain             | Reproducibility               |
| Outcome               | Finality status               |

All fields are strictly defined by schema and must not contain undeclared data.

---

## 6. Workset Declaration

The **workset** defines the closed-world object identity set for the seal.

It specifies:

* The companion file (`workset.jsonl.gz`)
* A SHA-256 digest of that file’s compressed bytes
* The number of declared objects
* **The source of enumeration**, including supporting evidence

If the workset source does not reference an immutable snapshot or versioned listing, the seal **cannot be FINAL**.

---

## 7. Inventory Commitment

The **inventory** materializes the workset into byte-exact file identities:

* Normalized path
* Exact byte size
* SHA-256 content digest

The inventory defines the **Merkle leaf order** and is the authoritative input to root computation.

Any mismatch between the inventory file and the manifest bindings is a verification failure.

---

## 8. Exclusions

Exclusions are treated as **first-class evidence**.

For each exclusion input, the manifest records:

* Type (e.g., path glob, domain list, policy text)
* Name
* SHA-256 digest of the raw exclusion input

This ensures that exclusions are:

* Explicit
* Reviewable
* Immutable once sealed

---

## 9. Results Summary and Completeness

The manifest records a **results summary** derived from `results.jsonl.gz`.

It includes:

* Digest of the results file
* Number of result records
* Count of missing workset items
* Count of conflicting records

A seal is FINAL only if:

* Result count equals workset count
* Missing count is zero
* Conflict count is zero

This prevents silent partial seals.

---

## 10. Cryptographic Roots

The manifest records:

* `dataset_root_sha256` — the Merkle root committing to all files
* Optional hierarchical roots for chunked datasets

These roots are the **sole cryptographic commitment** used for verification and timestamping.

---

## 11. Timestamping

The manifest binds an **RFC 3161 timestamp token** to the dataset root.

This provides an independent, third-party time anchor.

If timestamping fails, the seal outcome must be NON_FINAL.

---

## 12. Signatures

The manifest is signed using:

* Ed25519 **or**
* RSA-PSS with SHA-256

The signature covers the canonicalized manifest payload and proves authenticity of the declaration.

---

## 13. Outcome and Finality

Every manifest declares an outcome:

* `FINAL`
* `NON_FINAL`
* `ABORTED`

Only `FINAL` manifests may be represented as court-grade dataset commitments.

A manifest declaring `sealing_outcome = FINAL` that violates any FINAL
constraints defined in `manifest_v1.schema.json` is invalid by definition
and MUST be rejected by verifiers.

The manifest explicitly records why finality was or was not achieved.

---

## 14. How Verification Works (High Level)

An independent verifier can:

1. Validate the manifest against schema
2. Verify the signature
3. Verify the RFC 3161 timestamp
4. Recompute hashes and Merkle roots
5. Confirm completeness conditions

All steps can be performed offline using standard tools.

---

## 15. Why This Design Is Defensible

This manifest design is intentionally:

* **Boring** (standard primitives)
* **Explicit** (no implied claims)
* **Hostile-review-ready**
* **Independent of vendor trust**

It converts dataset disputes from testimony into math.

---

## 16. Relationship to Companion Files

The manifest does not stand alone. It binds:

* `workset.jsonl.gz`
* `inventory.jsonl.gz`
* `results.jsonl.gz`
* Optional proof artifacts

Together, these form a complete, verifiable sealing record.

---

## 17. Versioning

This document describes **Manifest v1**.

Breaking changes require a new manifest version and verification profile.
