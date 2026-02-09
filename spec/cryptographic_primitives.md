# Cryptographic Primitives

This document locks the cryptographic suite for Oord Manifest v1 and the `public_offline_v1` verification profile.

No algorithm substitution is permitted within v1. Any change requires a major version bump and new identifiers.

---

## Allowed primitives (non-negotiable)

### Hash
- **SHA-256** only (`sha256`) — FIPS 180-4

### Canonicalization
- **RFC 8785 JSON Canonicalization Scheme (JCS)** only (`RFC8785-JCS`)

### Timestamping
- **RFC 3161 Time-Stamp Protocol (TSP / TSA)** only (`rfc3161`)

### Signatures
Exactly one of:
- **Ed25519** (`ed25519`) — primary
- **RSA-PSS with SHA-256** (`rsa-pss-sha256`) — secondary

Implementations MUST record the chosen signature suite in the manifest and MUST NOT claim a suite different from the one used.

---

## Merkle domain separation

To prevent cross-domain second-preimage ambiguity:

- Leaf prefix: `0x00`
- Node prefix: `0x01`

These prefixes are part of the hashing input for all Merkle computations in v1.

---

## Explicitly excluded in v1

- HMAC / shared-secret MACs
- Shared secrets for verification
- Vendor-hosted verification requirements
- Probabilistic verification profiles
- Algorithm agility within a major version

---

## Versioning rule

Within v1:
- `sha256` is mandatory and exclusive
- `RFC8785-JCS` is mandatory and exclusive
- `rfc3161` is mandatory and exclusive
- Signature suite MUST be `ed25519` or `rsa-pss-sha256`

Any deviation requires a major version bump and new format/profile identifiers.
