#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"
load_env
require_command docker

cd "${REPO_ROOT}"
docker compose --profile vllm up -d vllm

echo "vLLM container started. Follow logs with:"
echo "  docker logs -f inference-vllm"
echo "Endpoint: http://127.0.0.1:${VLLM_PORT:-18181}/v1"
