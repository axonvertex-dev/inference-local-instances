#!/usr/bin/env bash
set -Eeuo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

if ! grep -qi microsoft /proc/version 2>/dev/null; then
  echo "ERROR: WSL was not detected." >&2
  exit 1
fi

require_command docker

if command -v nvidia-smi >/dev/null 2>&1; then
  nvidia-smi
elif [[ -x /usr/lib/wsl/lib/nvidia-smi ]]; then
  /usr/lib/wsl/lib/nvidia-smi
else
  echo "ERROR: nvidia-smi is not available inside WSL." >&2
  exit 1
fi

docker version >/dev/null
docker compose version >/dev/null

echo "Testing NVIDIA access inside Docker..."
docker run --rm --gpus all ubuntu:24.04 nvidia-smi

echo "WSL2 NVIDIA Docker preflight passed."
