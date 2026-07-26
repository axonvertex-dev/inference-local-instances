#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"
load_env
require_command docker

cd "${REPO_ROOT}"
docker compose --profile ollama up -d ollama

echo "Ollama container started."
echo "Pull the configured model with: ./scripts/pull-ollama-model.sh"
echo "Endpoint: http://127.0.0.1:${OLLAMA_PORT:-11434}"
