# Ollama on Linux with NVIDIA GPU and Docker

## Prerequisite

Complete `cookbooks/COMMON_LINUX_NVIDIA_DOCKER.md`.

## 1. Configure

```bash
cp .env.example .env
chmod 600 .env
```

Default:

```dotenv
OLLAMA_MODEL=gemma4:e2b
```

## 2. Start Ollama

```bash
./scripts/start-ollama.sh
```

## 3. Pull the model

```bash
./scripts/pull-ollama-model.sh
```

## 4. Verify

```bash
./scripts/verify-ollama.sh
```

## 5. Confirm GPU activity

In one terminal:

```bash
watch -n 1 nvidia-smi
```

In another:

```bash
./scripts/verify-ollama.sh
```

## 6. Stop

```bash
./scripts/stop-ollama.sh
```

The named Ollama volume preserves the downloaded model.
