#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 BASE_URL MODEL_ID [OUTPUT_DIR]" >&2
  echo "Example: $0 http://127.0.0.1:18181/v1 google/gemma-4-E2B-it-qat-w4a16-ct" >&2
  exit 1
fi

base_url="${1%/}"
model="$2"
output_dir="${3:-reports/benchmark-$(date +%Y%m%d_%H%M%S)}"
mkdir -p "${output_dir}"

python3 - "${base_url}" "${model}" "${output_dir}" <<'PY'
from __future__ import annotations

import json
import sys
import time
from pathlib import Path
from urllib import request

base_url, model, output_dir = sys.argv[1:4]
out = Path(output_dir)
payload = {
    "model": model,
    "messages": [{
        "role": "user",
        "content": "Explain the difference between process isolation and virtual machine isolation in 150 words.",
    }],
    "temperature": 0,
    "max_tokens": 256,
}
(out / "payload.json").write_text(json.dumps(payload, indent=2), encoding="utf-8")
body = json.dumps(payload).encode("utf-8")
url = f"{base_url}/chat/completions"

def call() -> dict:
    req = request.Request(url, data=body, method="POST", headers={"Content-Type": "application/json"})
    with request.urlopen(req, timeout=600) as response:
        return json.load(response)

call()
start = time.perf_counter()
result = call()
elapsed = time.perf_counter() - start
(out / "response.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
(out / "timing.txt").write_text(f"wall_seconds={elapsed:.6f}\n", encoding="utf-8")
print(f"Benchmark written to {out}")
print(f"wall_seconds={elapsed:.6f}")
PY
