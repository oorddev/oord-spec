# Sealing Outcomes


Oord defines explicit sealing outcomes. These are claims about bundle completeness and time anchoring.

## Outcomes

- FINAL:
  - coverage gates satisfied
  - deterministic artifacts present
  - valid signature over canonical manifest bytes
  - valid RFC3161 timestamp token for the committed dataset root

- NON_FINAL:
  - artifacts exist, but one or more FINAL requirements are not met
  - must be explicit; no implied completeness

- ABORTED:
  - sealing terminated before producing a coherent bundle
  - must not pretend to be complete

## Non-negotiable rule

A bundle MUST NOT be represented as court-grade complete unless its outcome is FINAL.