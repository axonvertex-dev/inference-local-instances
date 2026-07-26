# Ollama on WSL2 with NVIDIA GPU and Docker

## Prerequisite

Complete `cookbooks/COMMON_WSL2_NVIDIA_DOCKER.md`.

## 1. Start

Inside WSL:

```bash
cp .env.example .env
chmod 600 .env
./scripts/preflight-wsl-gpu.sh
./scripts/start-ollama.sh
```

## 2. Pull Gemma 4 E2B

```bash
./scripts/pull-ollama-model.sh
```

## 3. Verify in WSL

```bash
./scripts/verify-ollama.sh
```

## 4. Verify from Windows PowerShell

```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:11434/api/tags"
```

## 5. Confirm GPU access

```bash
docker exec inference-ollama nvidia-smi
```

## 6. Stop

```bash
./scripts/stop-ollama.sh
```
