#!/usr/bin/env python3
"""Call the native Ollama chat endpoint without third-party dependencies."""

from __future__ import annotations

import argparse
import json
import sys
from urllib import error, request


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--base-url", default="http://127.0.0.1:11434")
    parser.add_argument("--model", default="gemma4:e2b")
    parser.add_argument("--prompt", default="Explain local inference in two sentences.")
    args = parser.parse_args()

    payload = {
        "model": args.model,
        "stream": False,
        "messages": [{"role": "user", "content": args.prompt}],
        "options": {"temperature": 0.2, "num_predict": 128},
    }
    http_request = request.Request(
        f"{args.base_url.rstrip('/')}/api/chat",
        data=json.dumps(payload).encode("utf-8"),
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
