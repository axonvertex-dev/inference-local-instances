# vLLM on WSL2 with NVIDIA GPU

## Prerequisite

Complete `cookbooks/COMMON_WSL2_NVIDIA_DOCKER.md`.

## 1. Enter the repository inside WSL

```bash
cd ~/repos/inference-local-instances
cp .env.example .env
chmod 600 .env
```

## 2. Validate the GPU path

```bash
./scripts/preflight-wsl-gpu.sh
```

## 3. Start vLLM

```bash
./scripts/start-vllm.sh
```

## 4. Test inside WSL

```bash
./scripts/verify-vllm.sh
```

## 5. Test from Windows PowerShell

```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:18181/v1/models"
```

## 6. Resource allocation

If Docker Desktop or WSL is memory constrained, create or update `%UserProfile%\.wslconfig` in Windows:

```ini
[wsl2]
memory=24GB
processors=12
swap=16GB
```

Then apply from PowerShell:

```powershell
wsl --shutdown
```

Do not allocate more memory than the Windows host can safely provide.

## 7. Stop

```bash
./scripts/stop-vllm.sh
```
