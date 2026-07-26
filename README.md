# Inference Local Instances

Reference deployments for running small and compact open-weight models locally across Linux, Windows Subsystem for Linux, and Apple Silicon.

Gemma 4 E2B is the initial reference workload.

## Supported paths

| Host | Runtime | Acceleration | Packaging | Default endpoint |
|---|---|---|---|---|
| Linux | vLLM | NVIDIA GPU | Docker | `http://127.0.0.1:18181/v1` |
| WSL2 | vLLM | NVIDIA GPU | Docker | `http://127.0.0.1:18181/v1` |
| Linux | LiteRT-LM | CPU | Docker | `http://127.0.0.1:18182/v1` |
| WSL2 | LiteRT-LM | CPU | Docker | `http://127.0.0.1:18182/v1` |
| Linux | Ollama | NVIDIA GPU | Docker | `http://127.0.0.1:11434` |
| WSL2 | Ollama | NVIDIA GPU | Docker | `http://127.0.0.1:11434` |
| macOS Apple Silicon | MLX / MLX-VLM | Apple GPU via Metal | Native | `http://127.0.0.1:18183/v1` |

Docker Desktop on macOS does not expose the Apple Metal GPU to Linux containers. The Apple path is therefore native MLX rather than Docker.

## Start here

```bash
cp .env.example .env
```

Choose one runtime:

```bash
./scripts/start-vllm.sh
./scripts/start-litert.sh
./scripts/start-ollama.sh
./scripts/start-mlx.sh
```

Verify it:

```bash
./scripts/verify-vllm.sh
./scripts/verify-litert.sh
./scripts/verify-ollama.sh
./scripts/verify-mlx.sh
```

Do not start vLLM and another large GPU runtime simultaneously unless the machine has enough free VRAM.

Validate the repository before committing:

```bash
./scripts/validate-repo.sh
```

## Repository map

- `cookbooks/`: host-specific installation and operation procedures
- `deployments/`: Docker Compose and Dockerfiles
- `native/`: native Apple Silicon MLX configuration
- `scripts/`: preflight, start, stop, verification, and benchmark helpers
- `examples/`: cURL and Python clients
- `docs/`: architecture, security, ports, sizing, troubleshooting, and GitHub setup

## Recommended first cookbook

- Linux NVIDIA: `cookbooks/COMMON_LINUX_NVIDIA_DOCKER.md`
- WSL2 NVIDIA: `cookbooks/COMMON_WSL2_NVIDIA_DOCKER.md`
- Linux/WSL CPU: `cookbooks/litert-lm/`
- Apple Silicon: `cookbooks/mlx/MACOS_APPLE_SILICON.md`

## Important sizing note

The full BF16 `google/gemma-4-E2B-it` vLLM recipe is intended for a single 24 GB or larger GPU. This repository defaults to Google's vLLM-oriented QAT W4A16 checkpoint to reduce model memory. Actual fit still depends on the vLLM version, GPU architecture, multimodal profiling, context length, concurrency, and KV-cache allocation.

## Security default

All published ports bind to `127.0.0.1`. Do not expose an unauthenticated inference endpoint directly to a public interface. See `docs/SECURITY.md`.

Repository initialization and push commands are in `docs/REPOSITORY_SETUP.md`.

## Licensing

This repository does not replace the licenses of the selected frameworks or model weights. Review `NOTICE.md` before redistribution.
