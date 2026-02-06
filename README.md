# oord-spec

Oord protocol + schema + test-vector skeleton for **court-grade, offline-verifiable** AI dataset sealing.

This repository is **spec-only**. It contains:
- `/spec`: normative prose specifications (formats, rules, verification profile)
- `/schemas`: normative JSON Schemas (schema wins on conflict)
- `/test-vectors`: test-vector directory structure + fixtures (Phase 0: structure + placeholders)
- `/licenses`: licensing and third-party notices

## Normativity and Precedence

**Precedence rule:**
1. `/schemas/*.schema.json` is **normative** for structure and required fields.
2. `/spec/*.md` is normative for semantics and verification rules **unless it contradicts schema**.
3. If prose conflicts with schema, **schema wins** and prose must be corrected.

## Non-goals

This is not an implementation repo. No sealing engine. No verifier. No codegen.

## Repository Structure Lock

No new top-level directories may be introduced without an explicit spec task and versioned justification.
