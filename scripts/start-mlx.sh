#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"
load_env

if [[ "$(uname -s)" != "Darwin" || "$(uname -m)" != "arm64" ]]; then
  echo "ERROR: native MLX requires an Apple Silicon Mac." >&2
  exit 1
fi

require_command python3

venv="${REPO_ROOT}/native/mlx/.venv"
if [[ ! -x "${venv}/bin/python" ]]; then
  python3 -m venv "${venv}"
fi

"${venv}/bin/python" -m pip install --upgrade pip
"${venv}/bin/python" -m pip install \
  "mlx-lm==${MLX_LM_VERSION:-0.31.2}" \
  "mlx-vlm==${MLX_VLM_VERSION:-0.4.5}"

exec "${venv}/bin/python" -m mlx_lm.server \
  --model "${MLX_MODEL:-mlx-community/gemma-4-e2b-it-4bit}" \
  --host "${MLX_HOST:-127.0.0.1}" \
  --port "${MLX_PORT:-18183}"
