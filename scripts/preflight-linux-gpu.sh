#!/usr/bin/env bash
set -Eeuo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "ERROR: this preflight is for Linux." >&2
  exit 1
fi

if grep -qi microsoft /proc/version 2>/dev/null; then
  echo "ERROR: WSL detected. Use preflight-wsl-gpu.sh." >&2
  exit 1
fi

require_command nvidia-smi
require_command docker

nvidia-smi
docker version >/dev/null
docker compose version >/dev/null

echo "Testing NVIDIA access inside Docker..."
docker run --rm --gpus all ubuntu:24.04 nvidia-smi

echo "Linux NVIDIA Docker preflight passed."
