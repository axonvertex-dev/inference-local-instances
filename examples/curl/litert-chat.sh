#!/usr/bin/env bash
set -Eeuo pipefail

curl -s http://127.0.0.1:18182/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "gemma4-e2b",
    "messages": [
      {"role": "user", "content": "Explain why local inference can improve data locality."}
    ],
    "temperature": 0.2,
    "max_tokens": 256
  }' | python3 -m json.tool
