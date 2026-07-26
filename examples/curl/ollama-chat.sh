#!/usr/bin/env bash
set -Eeuo pipefail

curl -s http://127.0.0.1:11434/api/chat \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "gemma4:e2b",
    "stream": false,
    "messages": [
      {"role": "user", "content": "Explain why local inference can improve data locality."}
    ],
    "options": {
      "temperature": 0.2,
      "num_predict": 256
    }
  }' | python3 -m json.tool
