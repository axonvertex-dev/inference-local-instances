#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"
load_env
require_command curl
require_command python3

port="${OLLAMA_PORT:-11434}"
model="${OLLAMA_MODEL:-gemma4:e2b}"
base="http://127.0.0.1:${port}"

wait_for_http "${base}/api/tags" 120 2
curl -fsS "${base}/api/tags" | python3 -m json.tool

curl -fsS "${base}/api/chat" \
  -H 'Content-Type: application/json' \
  -d "$(python3 - <<PY
import json
print(json.dumps({
  'model': '${model}',
  'stream': False,
  'messages': [{'role': 'user', 'content': 'Reply with exactly: Ollama inference operational'}],
  'options': {'temperature': 0, 'num_predict': 32}
}))
PY
)" | python3 -m json.tool
