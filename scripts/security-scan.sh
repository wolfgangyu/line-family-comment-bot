#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

echo "Scanning: $ROOT"

echo
echo "1) Files that should not be committed:"
find "$ROOT" \
  \( -name '.env' -o -name 'database.sqlite' -o -name '*.sqlite' -o -name '*.db' -o -name 'config' -o -name '*.log' \) \
  -not -path '*/.git/*' \
  -print

echo
echo "2) Suspicious secret-like strings:"
if command -v rg >/dev/null 2>&1; then
  rg -n --hidden --glob '!*.md' --glob '!scripts/security-scan.sh' \
    --glob '!.git/**' \
    '(Bearer [A-Za-z0-9._~+/=-]{20,}|sk-[A-Za-z0-9_-]{20,}|AIza[0-9A-Za-z_-]{20,}|[A-Za-z0-9+/]{80,}={0,2})' "$ROOT" || true
else
  grep -RInE \
    '(Bearer [A-Za-z0-9._~+/=-]{20,}|sk-[A-Za-z0-9_-]{20,}|AIza[0-9A-Za-z_-]{20,}|[A-Za-z0-9+/]{80,}={0,2})' "$ROOT" || true
fi

echo
echo "If section 2 is empty, no obvious long token was found."
