#!/usr/bin/env bash
set -Eeuo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${repo_root}"

python3 - <<'PY'
from __future__ import annotations

import hashlib
from pathlib import Path

root = Path('.')
excluded_parts = {'.git', '__pycache__', '.venv'}
excluded_names = {'MANIFEST.sha256', '.env'}

lines: list[str] = []
for path in sorted(p for p in root.rglob('*') if p.is_file()):
    if path.name in excluded_names:
        continue
    if any(part in excluded_parts for part in path.parts):
        continue
    digest = hashlib.sha256(path.read_bytes()).hexdigest()
    lines.append(f"{digest}  ./{path.as_posix()}\n")

Path('MANIFEST.sha256').write_text(''.join(lines), encoding='utf-8')
print(f"Updated MANIFEST.sha256 with {len(lines)} files")
PY
