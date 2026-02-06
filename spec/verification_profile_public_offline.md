# Verification Profile: public_offline


## Name

`public_offline`

## Claim (tight)

A third party can verify dataset integrity **offline**, using **standard tools**, without trusting the dataset custodian or the vendor.

## Verification dependencies (allowed)

Verification may depend only on:

- SHA-256 digests
- public verification keys (Ed25519 or RSA-PSS)
- RFC 3161 timestamp tokens
- RFC 8785 JCS canonicalization for manifest serialization
- deterministic ordering rules defined by the spec

## Explicit exclusions

- HMAC / shared-secret verification mechanisms
- vendor-hosted verification portals
- proprietary verification tools as a requirement
- network-dependent verification steps

## Tooling baseline

The profile requires that verification be possible with:

- OpenSSL >= 3.0
- POSIX shell (sh/bash)
- standard UNIX tools (sha256sum, gunzip, wc)

(Exact step-by-step command walkthrough is deferred to Phase 1; requirements are locked here.)
