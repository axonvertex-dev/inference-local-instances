#!/usr/bin/env bash
set -Eeuo pipefail

curl -s http://127.0.0.1:18183/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "mlx-community/gemma-4-e2b-it-4bit",
    "messages": [
      {"role": "user", "content": "Explain why local inference can improve data locality."}
    ],
    "temperature": 0.2,
    "max_tokens": 256
  }' | python3 -m json.tool
