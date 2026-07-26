#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"
load_env
require_command curl
require_command python3

port="${MLX_PORT:-18183}"
model="${MLX_MODEL:-mlx-community/gemma-4-e2b-it-4bit}"
base="http://127.0.0.1:${port}/v1"

wait_for_http "${base}/models" 180 2
curl -fsS "${base}/models" | python3 -m json.tool

curl -fsS "${base}/chat/completions" \
  -H 'Content-Type: application/json' \
  -d "$(python3 - <<PY
import json
print(json.dumps({
  'model': '${model}',
  'messages': [{'role': 'user', 'content': 'Reply with exactly: MLX inference operational'}],
  'temperature': 0,
  'max_tokens': 32
}))
PY
)" | python3 -m json.tool
