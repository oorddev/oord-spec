#!/usr/bin/env bash
set -euo pipefail

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

req_dir() {
  [[ -d "$1" ]] || fail "missing required dir: $1"
}

req_file() {
  [[ -f "$1" ]] || fail "missing required file: $1"
}

# Required top-level directories
req_dir "spec"
req_dir "schemas"
req_dir "test-vectors"
req_dir "licenses"

# Required spec files (minimum spine). Extra spec files are allowed.
req_file "spec/README.md"
req_file "spec/STATUS.md"
req_file "spec/cryptographic_primitives.md"
req_file "spec/leaf_encoding.md"
req_file "spec/merkle.md"
req_file "spec/timestamping_rfc3161.md"
req_file "spec/signing_profiles.md"
req_file "spec/error_codes.md"
req_file "spec/sealing_outcomes.md"
req_file "spec/verification_profile_public_offline.md"

# Core format specs
req_file "spec/manifest.md"
req_file "spec/workset.md"
req_file "spec/results.md"
req_file "spec/inventory.md"

# Supporting verification docs (optional to require; I recommend requiring since you already have them)
req_file "spec/verification_process.md"
req_file "spec/verification_checklist.md"
req_file "spec/verification_failures.md"

# Required schema
req_file "schemas/manifest_v1.schema.json"

# Test-vector skeleton
req_dir "test-vectors/v1"
req_dir "test-vectors/v1/tiny_dataset"
req_dir "test-vectors/v1/chunking_dataset"
req_dir "test-vectors/v1/unicode_edge_cases"
req_dir "test-vectors/v1/negative_tests"
req_file "test-vectors/v1/tiny_dataset/README.md"
req_file "test-vectors/v1/chunking_dataset/README.md"
req_file "test-vectors/v1/unicode_edge_cases/README.md"
req_file "test-vectors/v1/negative_tests/README.md"

# Licenses
# You already have root LICENSE; we require licenses placeholders too.
req_file "licenses/LICENSE"
req_file "licenses/THIRD_PARTY_NOTICES.md"

# Ban obvious implementation directories at repo root (allow .github)
for d in src cmd pkg apps packages scripts tools bin dist build; do
  if [[ -d "$d" ]]; then
    fail "forbidden implementation-ish root dir present: $d"
  fi
done

echo "OK: repo structure + required Phase 0.1 spine present"
