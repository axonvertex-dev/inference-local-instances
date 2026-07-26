# Inference Matrix

| Requirement | vLLM | LiteRT-LM | Ollama | MLX |
|---|---:|---:|---:|---:|
| Linux | Yes | Yes | Yes | No |
| WSL2 | Yes | Yes | Yes | No |
| macOS Apple Silicon | Not in this repository | Native possible, not selected | Optional native alternative | Yes |
| Docker | Yes | Yes | Yes | No |
| NVIDIA GPU | Required | No | Required for this profile | No |
| CPU-only | No | Yes | Not the selected profile | No |
| Apple Metal GPU | No | No | Not used here | Yes |
| OpenAI-compatible API | Yes | Yes | Ollama has a compatibility layer, but examples use native API | Yes |
| Persistent model cache | Yes | Yes | Yes | Yes, native cache |
| Initial model | Gemma 4 E2B QAT W4A16 | Gemma 4 E2B LiteRT-LM | Gemma 4 E2B | Gemma 4 E2B 4-bit MLX |

## Selection guidance

Choose vLLM when:

- the application already uses an OpenAI-compatible client;
- GPU batching and serving features matter;
- the GPU can hold the checkpoint, multimodal components, runtime workspace, and KV cache.

Choose LiteRT-LM when:

- inference must be CPU-only;
- the same Docker workflow should run on Linux and WSL2;
- lower throughput is acceptable in exchange for portability and reduced GPU requirements.

Choose Ollama when:

- model installation and removal should remain simple;
- a quantized Ollama model is available;
- the workload is interactive rather than high-concurrency serving.

Choose MLX when:

- the host is Apple Silicon;
- direct access to Metal and unified memory is required;
- Docker portability is less important than native performance.
