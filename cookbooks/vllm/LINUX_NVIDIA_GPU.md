# vLLM on Linux with NVIDIA GPU

## Prerequisite

Complete `cookbooks/COMMON_LINUX_NVIDIA_DOCKER.md`.

## 1. Select the model

The default `.env.example` uses:

```dotenv
VLLM_MODEL=google/gemma-4-E2B-it-qat-w4a16-ct
```

For the full BF16 recipe:

```dotenv
VLLM_MODEL=google/gemma-4-E2B-it
```

Use the full model only when the GPU has sufficient memory. The official recipe describes a 24 GB+ single-GPU target.

## 2. Add a token when required

```dotenv
HF_TOKEN=hf_example
```

Accept any required model terms before starting.

## 3. Run preflight

```bash
./scripts/preflight-linux-gpu.sh
```

## 4. Start

```bash
./scripts/start-vllm.sh
```

Follow logs:

```bash
docker logs -f inference-vllm
```

## 5. Verify

```bash
./scripts/verify-vllm.sh
```

Manual model listing:

```bash
curl -s http://127.0.0.1:18181/v1/models | python3 -m json.tool
```

## 6. Monitor

```bash
watch -n 1 nvidia-smi
```

## 7. Stop

```bash
./scripts/stop-vllm.sh
```

## 8. Recover from out-of-memory

Edit `.env`:

```dotenv
VLLM_MAX_MODEL_LEN=4096
VLLM_MAX_NUM_SEQS=1
VLLM_GPU_MEMORY_UTILIZATION=0.85
```

Recreate the service.
