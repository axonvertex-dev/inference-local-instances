#!/usr/bin/env bash
set -Eeuo pipefail

: "${LITERT_HF_REPO:=litert-community/gemma-4-E2B-it-litert-lm}"
: "${LITERT_MODEL_FILE:=gemma-4-E2B-it.litertlm}"
: "${LITERT_MODEL_ID:=gemma4-e2b}"
: "${LITERT_CONTAINER_PORT:=9379}"

mkdir -p /root/.litert-lm /root/.cache/huggingface

if ! litert-lm list 2>/dev/null | grep -Fq "${LITERT_MODEL_ID}"; then
  echo "Importing ${LITERT_MODEL_FILE} from ${LITERT_HF_REPO} as ${LITERT_MODEL_ID}"
  litert-lm import \
    --from-huggingface-repo="${LITERT_HF_REPO}" \
    "${LITERT_MODEL_FILE}" \
    "${LITERT_MODEL_ID}"
else
  echo "LiteRT-LM model ${LITERT_MODEL_ID} is already present in the registry"
fi

exec litert-lm serve \
  --host 0.0.0.0 \
  --port "${LITERT_CONTAINER_PORT}" \
  --verbose
