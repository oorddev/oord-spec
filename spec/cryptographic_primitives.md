# Cryptographic Primitives 

## Allowed primitives (non-negotiable)

- Hash: **SHA-256** only (FIPS 180-4)
- Canonicalization: **RFC 8785 JCS** only
- Timestamping: **RFC 3161 TSA** only
- Signature:
  - **Ed25519** (primary)
  - **RSA-PSS with SHA-256** (secondary)

## Merkle domain separation

- Leaf prefix: `0x00`
- Node prefix: `0x01`

## Explicitly excluded in v1

- HMAC / shared-secret MACs
- Shared secrets for verification
- Vendor-hosted verification requirements
- Probabilistic verification as a verification profile

## Versioning rule

No algorithm substitution is permitted in v1. Any change to this suite requires a **major version bump** and a new profile and/or format identifiers.
