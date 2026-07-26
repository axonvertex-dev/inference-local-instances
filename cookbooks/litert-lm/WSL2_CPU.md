# LiteRT-LM CPU Inference on WSL2 with Docker

This path does not pass a GPU into the container.

## 1. Confirm WSL2 and Docker

Inside WSL:

```bash
grep -qi microsoft /proc/version && echo "WSL detected"
docker version
docker compose version
./scripts/preflight-cpu.sh
```

## 2. Keep the repository in the WSL filesystem

```bash
cd ~/repos/inference-local-instances
cp .env.example .env
chmod 600 .env
```

## 3. Start

```bash
./scripts/start-litert.sh
```

## 4. Verify inside WSL

```bash
./scripts/verify-litert.sh
```

## 5. Verify from Windows PowerShell

```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:18182/v1/models"
```

## 6. Tune WSL memory

CPU inference still requires memory for the model and runtime. Configure `%UserProfile%\.wslconfig` if necessary:

```ini
[wsl2]
memory=16GB
processors=8
swap=16GB
```

Apply:

```powershell
wsl --shutdown
```

## 7. Stop

```bash
./scripts/stop-litert.sh
```
