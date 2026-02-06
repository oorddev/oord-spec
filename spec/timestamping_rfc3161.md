# RFC 3161 Timestamping

**Status:** LOCKED FOR BUILD (Phase 0)

Oord uses RFC 3161 TSA timestamp tokens to time-anchor `dataset_root_sha256`.

## Purpose

Timestamping defeats the claim:
> “You generated this commitment after litigation began.”

## What is timestamped

- The TSA token MUST be over the SHA-256 digest representing the committed dataset root (`dataset_root_sha256`), not over mutable files.

## Verification requirement

A bundle cannot be represented as court-grade complete without a valid RFC 3161 token that verifies against the timestamped digest.

## Failure policy

If a TSA token cannot be obtained, the sealing outcome MUST be `NON_FINAL` with explicit recording of the timestamp failure status.
