# Troubleshooting

## Docker cannot see the NVIDIA GPU

Run:

```bash
nvidia-smi
docker run --rm --gpus all ubuntu:24.04 nvidia-smi
```

If the first command fails, fix the NVIDIA driver or WSL GPU integration. If the first succeeds and the second fails, fix Docker and NVIDIA Container Toolkit integration.

## vLLM exits with out-of-memory

Reduce in `.env`:

```dotenv
VLLM_MAX_MODEL_LEN=4096
VLLM_MAX_NUM_SEQS=1
VLLM_GPU_MEMORY_UTILIZATION=0.85
```

Then recreate the service:

```bash
./scripts/stop-vllm.sh
./scripts/start-vllm.sh
```

Also stop Ollama or other GPU processes and inspect `nvidia-smi`.

## vLLM model is gated

1. Accept the model terms on the model repository.
2. Create a Hugging Face token with the minimum required permission.
3. Put it in `.env` as `HF_TOKEN=...`.
4. Restart the container.

## LiteRT-LM import repeats on every start

Inspect the registry volume:

```bash
docker volume ls | grep litert
```

Check logs:

```bash
docker logs inference-litert-lm
```

Do not remove the `litert-registry` volume unless a clean re-import is intended.

## LiteRT-LM package wheel is unavailable

The Dockerfile uses a Linux Python image and a pinned LiteRT-LM release. Confirm the host architecture:

```bash
uname -m
```

Then confirm that the selected release publishes a matching manylinux wheel. If not, use a supported release or build LiteRT-LM from source.

## Ollama uses CPU instead of GPU

Run:

```bash
docker exec inference-ollama nvidia-smi
docker logs inference-ollama
```

Also validate the generic CUDA container test. Ollama cannot use a GPU that Docker cannot expose.

## WSL port is not reachable from Windows

First test inside WSL:

```bash
curl http://127.0.0.1:18181/v1/models
```

Then test the same localhost address from Windows PowerShell. Current WSL2 localhost forwarding normally makes the service available. Corporate VPN, firewall, mirrored networking, or custom WSL configuration can alter this behavior.

## MLX command reports an unsupported platform

MLX requires Apple Silicon. Check:

```bash
uname -m
```

Expected:

```text
arm64
```

Intel Macs cannot use the selected MLX path.
