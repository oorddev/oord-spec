# Oord Verification Failures v1

**Interpretation of Failure Modes**

**Status:** Locked for v1
**Audience:** Courts, expert witnesses, regulators
**Purpose:** Define how verification failures must be interpreted and what conclusions are permitted.

---

## 1. Why Failure Semantics Matter

In adversarial settings, ambiguity is weaponized.

This document exists to ensure that:

* Failures are **deterministic**
* Interpretations are **narrow**
* No party can inflate or minimize what a failure actually proves

A verification failure answers a **technical question only**.
It does **not** answer legal or factual questions beyond integrity and time.

---

## 2. Outcome Classes (Strict)

Every verification attempt yields exactly one of:

* **PASS**
* **FAIL**
* **INCONCLUSIVE**

No other outcomes are permitted.

---

## 3. FAIL — What It Means

A **FAIL** outcome means:

> *One or more required cryptographic, integrity, or completeness checks did not succeed.*

A FAIL is a **positive technical finding**, not an absence of evidence.

---

### 3.1 Conditions That Produce FAIL

Any of the following **must** result in FAIL:

#### Structural failures

* Manifest fails schema validation
* Undeclared or malformed fields present

#### Authenticity failures

* Manifest signature does not verify
* Signature algorithm mismatch
* Signing payload mismatch

#### Time anchoring failures

* RFC 3161 timestamp token is invalid
* Timestamp does not cover the committed root
* Manifest claims FINAL but timestamp is missing or invalid

#### Integrity failures

* Companion file digest mismatch
* Inventory record mismatch
* Results digest mismatch

#### Completeness failures

* `results_record_count ≠ workset_record_count`
* `missing_count > 0`
* `conflict_count > 0`
* Manifest claims FINAL despite these conditions

#### Commitment failures

* Recomputed Merkle root ≠ `dataset_root_sha256`
* Chunk root mismatch (if chunked)

---

### 3.2 What FAIL Proves

A FAIL proves **at least one** of the following:

* The dataset has been altered since sealing
* The sealing process was incomplete or inconsistent
* The declaration is internally contradictory
* The cryptographic claims cannot be validated

It does **not** require proving *how* or *why* the failure occurred.

---

### 3.3 What FAIL Does *Not* Prove

A FAIL does **not** prove:

* Intentional wrongdoing
* Fraud
* Illegality of the dataset
* That the data never existed
* That the dataset was or was not used for training

FAIL is a **technical integrity finding only**.

---

## 4. INCONCLUSIVE — What It Means

An **INCONCLUSIVE** outcome means:

> *Verification could not be completed because required artifacts were not provided.*

INCONCLUSIVE is **not** a failure of cryptography.

---

### 4.1 Conditions That Produce INCONCLUSIVE

Examples:

* Missing companion files
* Missing timestamp response
* Missing public key or certificate chain
* Incomplete seal bundle provided to verifier

---

### 4.2 What INCONCLUSIVE Proves

INCONCLUSIVE proves exactly one thing:

> *The verifier cannot reach a conclusion with the provided materials.*

It does **not** imply tampering or correctness.

---

### 4.3 Improper Uses of INCONCLUSIVE (Prohibited)

It is improper to argue:

* “INCONCLUSIVE means the data is untrustworthy”
* “INCONCLUSIVE implies wrongdoing”
* “INCONCLUSIVE means verification failed”

Those statements are **technically false**.

---

## 5. PASS — What It Means

A **PASS** outcome means:

> *All required checks succeeded exactly as specified.*

PASS is not probabilistic, inferential, or subjective.

---

### 5.1 What PASS Proves

PASS proves:

* The dataset commitment is intact
* The dataset has not been altered since sealing
* The commitment existed no later than the timestamp
* The seal is mechanically complete

---

### 5.2 What PASS Does *Not* Prove

PASS does **not** prove:

* Lawfulness of the data
* Ethical sourcing
* Completeness beyond declared scope
* That the dataset was actually used
* Absence of undisclosed data elsewhere

---

## 6. Relationship Between Manifest Outcome and Verification Outcome

| Manifest Declares | Verification Result | Interpretation                              |
| ----------------- | ------------------- | ------------------------------------------- |
| FINAL             | PASS                | Seal is court-grade                         |
| FINAL             | FAIL                | Manifest is false or inconsistent           |
| FINAL             | INCONCLUSIVE        | Verification incomplete                     |
| NON_FINAL         | PASS                | Integrity proven, time/completeness limited |
| NON_FINAL         | FAIL                | Seal invalid                                |
| ABORTED           | any                 | No coherent seal exists                     |

A manifest **claiming FINAL** while failing FINAL conditions is a **hard FAIL**.

---

## 7. Common Failure Scenarios (Explained)

### 7.1 Timestamp Missing

* Outcome: **FAIL** if manifest claims FINAL
* Meaning: Time anchoring not proven
* Does not imply: Dataset alteration

---

### 7.2 Missing Results Records

* Outcome: **FAIL**
* Meaning: Seal is incomplete
* Does not imply: Malicious intent

---

### 7.3 Root Mismatch

* Outcome: **FAIL**
* Meaning: Bytes differ from commitment
* This is the strongest integrity failure

---

### 7.4 Missing Inventory File

* Outcome: **INCONCLUSIVE**
* Meaning: Verification inputs incomplete

---

## 8. Burden of Interpretation

* **Verifier** reports outcome only
* **Court** determines legal implications
* **Custodian** bears responsibility for providing artifacts

The verification process deliberately avoids legal conclusions.

---

## 9. Why This Failure Model Is Defensible

This model:

* Avoids ambiguity
* Prevents rhetorical inflation
* Separates math from law
* Aligns with Daubert reliability expectations

It ensures that disputes focus on **facts**, not testimony.

---

## 10. Canonical Statement for Testimony

An expert may state:

> *“Based on the provided materials, verification resulted in [PASS / FAIL / INCONCLUSIVE] according to the Oord Verification Process v1. This determination reflects cryptographic integrity and completeness only.”*

No additional interpretation is implied.