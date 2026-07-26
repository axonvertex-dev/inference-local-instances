#!/usr/bin/env bash
set -Eeuo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${repo_root}"

status=0

while IFS= read -r -d '' script; do
  echo "bash -n ${script}"
  if ! bash -n "${script}"; then
    status=1
  fi
done < <(find scripts examples/curl deployments -type f -name '*.sh' -print0)

echo "Compiling Python examples without writing __pycache__"
if ! python3 - <<'PY'
from pathlib import Path

for path in sorted(Path('examples/python').glob('*.py')):
    compile(path.read_text(encoding='utf-8'), str(path), 'exec')
    print(path)
PY
then
  status=1
fi

echo "Parsing YAML"
if ! python3 - <<'PY'
from pathlib import Path
import yaml

for path in sorted(Path('.').rglob('*.yaml')) + sorted(Path('.').rglob('*.yml')):
    if any(part in {'.git', '.venv'} for part in path.parts):
        continue
    with path.open('r', encoding='utf-8') as handle:
        yaml.safe_load(handle)
    print(path)
PY
then
  status=1
fi

echo "Checking Docker Compose configuration"
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  if ! docker compose --profile vllm --profile litert --profile ollama config >/dev/null; then
    status=1
  fi
  while IFS= read -r compose_file; do
    echo "docker compose -f ${compose_file} config"
    if ! docker compose -f "${compose_file}" config >/dev/null; then
      status=1
    fi
  done < <(find deployments -mindepth 2 -maxdepth 2 -name compose.yaml | sort)
elif [[ "${CI:-}" == "true" ]]; then
  echo "ERROR: Docker Compose is unavailable in CI." >&2
  status=1
else
  echo "WARNING: Docker Compose is unavailable; Compose validation skipped." >&2
fi

echo "Scanning for common committed secret formats"
if grep -RInE \
  '(HF_TOKEN=hf_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{30,}|gh[pousr]_[A-Za-z0-9]{30,}|-----BEGIN ([A-Z ]+ )?PRIVATE KEY-----)' \
  --exclude-dir=.git \
  --exclude-dir=.venv \
  --exclude-dir=__pycache__ \
  --exclude='.env' \
  --exclude='validate-repo.sh' \
  .; then
  echo "ERROR: possible committed secret detected" >&2
  status=1
fi

echo "Checking SHA-256 manifest"
if command -v sha256sum >/dev/null 2>&1; then
  if ! sha256sum -c MANIFEST.sha256; then
    status=1
  fi
elif command -v shasum >/dev/null 2>&1; then
  if ! shasum -a 256 -c MANIFEST.sha256; then
    status=1
  fi
else
  echo "ERROR: neither sha256sum nor shasum is available." >&2
  status=1
fi

if [[ ${status} -ne 0 ]]; then
  echo "Repository validation failed." >&2
  exit "${status}"
fi

echo "Repository validation passed."
