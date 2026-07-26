# LiteRT-LM CPU Inference on Linux with Docker

## 1. Confirm CPU and Docker

```bash
./scripts/preflight-cpu.sh
docker version
docker compose version
```

## 2. Prepare configuration

```bash
cp .env.example .env
chmod 600 .env
```

The default model is:

```dotenv
LITERT_HF_REPO=litert-community/gemma-4-E2B-it-litert-lm
LITERT_MODEL_FILE=gemma-4-E2B-it.litertlm
LITERT_MODEL_ID=gemma4-e2b
```

## 3. Build and start

```bash
./scripts/start-litert.sh
```

The first start builds the image, downloads the model, imports it into the persistent LiteRT-LM registry, and starts the API server.

Follow logs:

```bash
docker logs -f inference-litert-lm
```

## 4. Verify

```bash
./scripts/verify-litert.sh
```

## 5. Stop

```bash
./scripts/stop-litert.sh
```

## 6. Remove the imported model state

Only when a complete reset is intended:

```bash
docker compose --profile litert down
docker volume rm inference-local-instances_litert-registry
```

The exact volume prefix can differ if the Compose project name is overridden.
