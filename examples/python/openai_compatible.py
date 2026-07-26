#!/usr/bin/env python3
"""Call vLLM, LiteRT-LM, or MLX through an OpenAI-compatible endpoint."""

from __future__ import annotations

import argparse
import json
import sys
from urllib import error, request


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--base-url", required=True, help="Example: http://127.0.0.1:18181/v1")
    parser.add_argument("--model", required=True)
    parser.add_argument("--prompt", default="Explain local inference in two sentences.")
    parser.add_argument("--max-tokens", type=int, default=128)
    args = parser.parse_args()

    payload = {
        "model": args.model,
        "messages": [{"role": "user", "content": args.prompt}],
        "temperature": 0.2,
        "max_tokens": args.max_tokens,
    }
    body = json.dumps(payload).encode("utf-8")
    url = f"{args.base_url.rstrip('/')}/chat/completions"
    http_request = request.Request(
        url,
        data=body,
        method="POST",
        headers={"Content-Type": "application/json"},
    )

    try:
        with request.urlopen(http_request, timeout=300) as response:
            result = json.load(response)
    except error.HTTPError as exc:
        sys.stderr.write(exc.read().decode("utf-8", errors="replace"))
        return 1
    except OSError as exc:
        sys.stderr.write(f"Request failed: {exc}\n")
        return 1

    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
