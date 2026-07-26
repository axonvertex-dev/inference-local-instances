#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"
load_env
require_command docker
require_command curl

model="${OLLAMA_MODEL:-gemma4:e2b}"
port="${OLLAMA_PORT:-11434}"
if ! docker ps --format '{{.Names}}' | grep -Fxq inference-ollama; then
  echo "ERROR: inference-ollama is not running. Start it first." >&2
  exit 1
fi

wait_for_http "http://127.0.0.1:${port}/api/tags" 60 2
docker exec inference-ollama ollama pull "${model}"
