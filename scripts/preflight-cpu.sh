#!/usr/bin/env bash
set -Eeuo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"
require_command docker

uname -a
if command -v lscpu >/dev/null 2>&1; then
  lscpu
fi
if command -v free >/dev/null 2>&1; then
  free -h
fi

docker version >/dev/null
docker compose version >/dev/null

echo "Architecture: $(uname -m)"
echo "CPU Docker preflight passed."
