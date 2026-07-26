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

echo "Compiling Python examples"
if ! python3 -m compileall -q examples/python; then
  status=1
fi

echo "Parsing YAML"
if ! python3 - <<'PY2'
from pathlib import Path
import yaml
for path in sorted(Path('.').rglob('*.yaml')) + sorted(Path('.').rglob('*.yml')):
    with path.open('r', encoding='utf-8') as handle:
        yaml.safe_load(handle)
    print(path)
PY2
then
  status=1
fi

if grep -RInE 'HF_TOKEN=hf_[A-Za-z0-9]{20,}' --exclude='.env' --exclude='validate-repo.sh' .; then
  echo "ERROR: possible committed token detected" >&2
  status=1
fi

if [[ ${status} -ne 0 ]]; then
  echo "Repository validation failed." >&2
  exit ${status}
fi

echo "Repository validation passed."
