# Linux NVIDIA Docker Prerequisites

Use this once before the vLLM or Ollama cookbook.

## 1. Confirm the host GPU and driver

```bash
nvidia-smi
```

Do not continue until the NVIDIA GPU is visible without Docker.

## 2. Install Docker Engine

Use Docker's repository for the Linux distribution. Confirm:

```bash
docker version
docker compose version
```

Optional non-root access:

```bash
sudo usermod -aG docker "$USER"
newgrp docker
```

Group membership gives effective root-level control over Docker. Apply it only to trusted users.

## 3. Install NVIDIA Container Toolkit on Ubuntu/Debian

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
  | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -fsSL https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
  | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
  | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

## 4. Validate GPU access inside Docker

```bash
docker run --rm --gpus all ubuntu:24.04 nvidia-smi
```

The container output must show the host NVIDIA GPU.

## 5. Prepare the repository

```bash
cp .env.example .env
chmod 600 .env
```

Run:

```bash
./scripts/preflight-linux-gpu.sh
```

Proceed to either:

- `cookbooks/vllm/LINUX_NVIDIA_GPU.md`
- `cookbooks/ollama/LINUX_NVIDIA_GPU.md`
