# Security

## Default position

Treat every inference endpoint as unauthenticated unless an authentication layer has been explicitly added. Model servers often expose generation, model metadata, and resource-intensive operations without user isolation.

## Required controls

1. Keep ports bound to `127.0.0.1` for single-host use.
2. Never commit `.env` or a real `HF_TOKEN`.
3. Use a read-only, least-privilege Hugging Face token when possible.
4. Do not mount the Docker socket into an inference container.
5. Do not use `--privileged` for these NVIDIA or CPU deployments.
6. Validate model repositories before downloading code or custom artifacts.
7. Pin image and package versions for production use.
8. Apply host operating-system, NVIDIA driver, Docker, WSL, and framework updates deliberately.
9. Limit input size, output tokens, concurrency, and request duration at a gateway.
10. Log operational metadata without logging private prompts by default.

## Hugging Face token handling

```bash
cp .env.example .env
chmod 600 .env
```

Set:

```dotenv
HF_TOKEN=hf_example
```

The token is passed as an environment variable. It is not baked into a Docker image.

## Network exposure

Do not change:

```yaml
127.0.0.1:18181:8000
```

to:

```yaml
0.0.0.0:18181:8000
```

unless the host firewall, private network, authentication proxy, request limits, and audit policy have already been configured.

## Model risk

Local inference improves data locality but does not make a model safe or correct. Applications still need:

- prompt-injection controls;
- tool allowlists;
- output validation;
- human approval for consequential actions;
- audit records;
- privacy redaction where required;
- model-specific evaluation.
