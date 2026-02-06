# Signing Profiles

## Allowed signature suites

Exactly one of:

- `ed25519`
- `rsa-pss-sha256`

## Notes

- Signature verification MUST be possible offline using standard tools (OpenSSL path required by the verification profile).
- Signature suite selection is recorded in the manifest.
