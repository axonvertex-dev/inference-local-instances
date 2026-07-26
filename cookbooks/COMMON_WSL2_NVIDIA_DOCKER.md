# WSL2 NVIDIA Docker Prerequisites

This path runs Linux containers inside a WSL2 distribution. It does not describe native Windows inference.

## 1. Windows prerequisites

- Windows with WSL2 enabled
- A supported NVIDIA Windows driver with WSL CUDA support
- Docker Desktop configured to use the WSL2 engine, or Docker Engine installed directly inside the WSL distribution

Do not install a separate Linux NVIDIA kernel driver inside WSL. The GPU is provided through the Windows driver and WSL integration.

## 2. Confirm WSL2

Inside the Linux distribution:

```bash
grep -qi microsoft /proc/version && echo "WSL detected"
wslpath 'C:\\Windows' >/dev/null
```

From Windows PowerShell:

```powershell
wsl --status
wsl --version
wsl -l -v
```

The selected distribution should show version 2.

## 3. Confirm GPU access in WSL

Inside WSL:

```bash
nvidia-smi
```

If `nvidia-smi` is not in `PATH`, check:

```bash
/usr/lib/wsl/lib/nvidia-smi
```

## 4. Confirm Docker access

Inside WSL:

```bash
docker version
docker compose version
docker run --rm --gpus all ubuntu:24.04 nvidia-smi
```

When Docker Desktop is used, enable WSL integration for the selected distribution in Docker Desktop settings.

## 5. Repository placement

For better Linux filesystem performance, clone or extract the repository inside the WSL filesystem, for example:

```bash
mkdir -p ~/repos
cd ~/repos
```

Avoid running model-heavy Docker workflows from `/mnt/c/...` unless Windows filesystem interoperability is required.

## 6. Prepare configuration

```bash
cp .env.example .env
chmod 600 .env
./scripts/preflight-wsl-gpu.sh
```

Proceed to either:

- `cookbooks/vllm/WSL2_NVIDIA_GPU.md`
- `cookbooks/ollama/WSL2_NVIDIA_GPU.md`
