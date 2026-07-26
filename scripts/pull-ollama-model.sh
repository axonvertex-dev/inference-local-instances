#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"
load_env
require_command docker

model="${OLLAMA_MODEL:-gemma4:e2b}"
if ! docker ps --format '{{.Names}}' | grep -Fxq inference-ollama; then
  echo "ERROR: inference-ollama is not running. Start it first." >&2
  exit 1
fi

docker exec -it inference-ollama ollama pull "${model}"
