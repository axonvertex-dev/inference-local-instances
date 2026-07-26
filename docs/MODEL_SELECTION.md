# Model Selection

## Reference family

Gemma 4 E2B is used to keep the runtime comparison focused on one model family. The exact artifact differs by runtime because each engine expects a different storage or quantization format.

## Default artifacts

### vLLM

```text
google/gemma-4-E2B-it-qat-w4a16-ct
```

This is the small-instance default. It is an official QAT W4A16 checkpoint serialized for vLLM-compatible compressed-tensors inference.

Full-precision alternative:

```text
google/gemma-4-E2B-it
```

The official vLLM recipe describes the full model as a single 24 GB+ GPU workload. Start with a reduced context length and low concurrency even on a 24 GB card.

### LiteRT-LM

```text
litert-community/gemma-4-E2B-it-litert-lm
```

Imported model file:

```text
gemma-4-E2B-it.litertlm
```

### Ollama

```text
gemma4:e2b
```

### MLX

```text
mlx-community/gemma-4-e2b-it-4bit
```

## Changing models

1. Update the runtime-specific model variable in `.env`.
2. Confirm that the selected runtime supports the model architecture and quantization.
3. Confirm the model license and access conditions.
4. Recalculate memory requirements.
5. Re-run the preflight and verification scripts.

## Memory is more than weight size

A model that appears to fit by checkpoint size can still fail because the runtime also needs memory for:

- quantization metadata;
- CUDA kernels and workspace;
- vision or audio encoders;
- activation buffers;
- KV cache;
- concurrent sequences;
- framework overhead.

Reduce `VLLM_MAX_MODEL_LEN`, `VLLM_MAX_NUM_SEQS`, and multimodal limits before increasing GPU-memory utilization beyond a safe value.
