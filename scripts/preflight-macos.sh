#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "ERROR: this preflight is for macOS." >&2
  exit 1
fi

if [[ "$(uname -m)" != "arm64" ]]; then
  echo "ERROR: Apple Silicon arm64 is required for MLX." >&2
  exit 1
fi

command -v python3 >/dev/null 2>&1 || {
  echo "ERROR: python3 is required." >&2
  exit 1
}

python3 --version
python3 - <<'PY2'
import sys
if sys.version_info < (3, 10):
    raise SystemExit("ERROR: Python 3.10 or newer is required for MLX-VLM.")
PY2
sw_vers

echo "Apple Silicon MLX preflight passed."
