#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

load_env() {
  if [[ -f "${REPO_ROOT}/.env" ]]; then
    set -a
    # shellcheck disable=SC1091
    source "${REPO_ROOT}/.env"
    set +a
  elif [[ -f "${REPO_ROOT}/.env.example" ]]; then
    echo "WARNING: .env not found; using defaults from scripts and Compose." >&2
  fi
}

require_command() {
  local command_name="$1"
  if ! command -v "${command_name}" >/dev/null 2>&1; then
    echo "ERROR: required command not found: ${command_name}" >&2
    exit 1
  fi
}

wait_for_http() {
  local url="$1"
  local attempts="${2:-120}"
  local delay="${3:-2}"
  local i
  for ((i=1; i<=attempts; i++)); do
    if curl -fsS --max-time 5 "${url}" >/dev/null 2>&1; then
      return 0
    fi
    sleep "${delay}"
  done
  echo "ERROR: endpoint did not become ready: ${url}" >&2
  return 1
}
