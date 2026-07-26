#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"
load_env
require_command docker

cd "${REPO_ROOT}"
docker compose --profile litert up -d --build litert-lm

echo "LiteRT-LM container started. The first model import can take time."
echo "Follow logs with: docker logs -f inference-litert-lm"
echo "Endpoint: http://127.0.0.1:${LITERT_PORT:-18182}/v1"
