#!/usr/bin/env bash
set -euo pipefail

SCHEMA="schemas/manifest_v1.schema.json"

PASS_FILES=(
  "test-vectors/v1/negative_tests/manifest_ok_ed25519.json"
  "test-vectors/v1/negative_tests/manifest_ok_rsapss.json"
)

FAIL_FILES=(
  "test-vectors/v1/negative_tests/manifest_bad_hash.json"
  "test-vectors/v1/negative_tests/manifest_bad_sig.json"
  "test-vectors/v1/negative_tests/manifest_bad_canon.json"
  "test-vectors/v1/negative_tests/manifest_bad_timestamp.json"
  "test-vectors/v1/negative_tests/manifest_bad_profile.json"
)

if [[ -f "test-vectors/v1/negative_tests/manifest_bad_sig_mismatch.json" ]]; then
  FAIL_FILES+=("test-vectors/v1/negative_tests/manifest_bad_sig_mismatch.json")
fi

PASS_JSON_DEFAULT="$(printf '%s\n' "${PASS_FILES[@]}" | python3 -c 'import json,sys; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))')"
FAIL_JSON_DEFAULT="$(printf '%s\n' "${FAIL_FILES[@]}" | python3 -c 'import json,sys; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))')"

export SCHEMA_PATH="${SCHEMA_PATH:-$SCHEMA}"
export PASS_FILES_JSON="${PASS_FILES_JSON:-$PASS_JSON_DEFAULT}"
export FAIL_FILES_JSON="${FAIL_FILES_JSON:-$FAIL_JSON_DEFAULT}"

node - <<'NODE'
const fs = require("fs");
const Ajv2020 = require("ajv/dist/2020");
const addFormats = require("ajv-formats");

const schemaPath = process.env.SCHEMA_PATH;
const passFiles = JSON.parse(process.env.PASS_FILES_JSON);
const failFiles = JSON.parse(process.env.FAIL_FILES_JSON);

const schema = JSON.parse(fs.readFileSync(schemaPath, "utf8"));

const ajv = new Ajv2020({ allErrors: true, strict: false });
addFormats(ajv);

ajv.addSchema(schema, schema.$id || "manifest");

function validateFile(fp) {
  const data = JSON.parse(fs.readFileSync(fp, "utf8"));
  const validate = ajv.getSchema(schema.$id) || ajv.getSchema("manifest");
  const ok = validate(data);
  return { ok, errors: validate.errors || [] };
}

console.log("[schema_tests] schema JSON ok");
console.log("[schema_tests] PASS cases...");
for (const f of passFiles) {
  const { ok, errors } = validateFile(f);
  if (!ok) {
    console.error("[schema_tests] expected PASS but got FAIL:", f);
    console.error(JSON.stringify(errors, null, 2));
    process.exit(1);
  }
  console.log("  -", f);
}

console.log("[schema_tests] FAIL cases...");
for (const f of failFiles) {
  const { ok, errors } = validateFile(f);
  if (ok) {
    console.error("[schema_tests] expected FAIL but got PASS:", f);
    process.exit(1);
  }
  console.log("  -", f);
}

console.log("[schema_tests] OK");
NODE
