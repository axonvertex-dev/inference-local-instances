# Version Policy

## Development default

Container tags and packages are configurable in `.env`. The starter configuration uses a current vLLM and Ollama image tag, while LiteRT-LM and MLX packages are pinned to versions known to contain the required commands.

## Production recommendation

Before production use:

1. Replace `latest` image tags with immutable version tags or digests.
2. Record the NVIDIA driver and Docker versions.
3. Record the exact model revision.
4. Test one upgrade at a time.
5. Retain the previous image and model cache until verification passes.
6. Review upstream security advisories and release notes.

## Upgrade test

For each runtime:

```bash
./scripts/verify-RUNTIME.sh
```

Then run an application-specific evaluation set. A successful health check does not prove output parity.
