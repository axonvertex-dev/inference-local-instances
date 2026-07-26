# Architecture

## Purpose

The repository provides four independent inference paths. It does not introduce a routing gateway, authentication proxy, or shared scheduler. Each runtime can be started, tested, upgraded, and removed independently.

## Runtime paths

### vLLM

```text
Client -> localhost:18181 -> Docker port 8000 -> vLLM OpenAI-compatible server
                                     |
                                     +-> NVIDIA CUDA GPU
                                     +-> persistent Hugging Face cache
```

Use this path when OpenAI-compatible APIs, batching, concurrency, or vLLM-specific serving features are required and the NVIDIA GPU has enough memory.

### LiteRT-LM

```text
Client -> localhost:18182 -> Docker port 9379 -> LiteRT-LM OpenAI-compatible server
                                      |
                                      +-> CPU backend
                                      +-> local LiteRT-LM model registry
                                      +-> persistent Hugging Face cache
```

The container receives no GPU device. This keeps the deployment CPU-only and portable between native Linux and WSL2.

### Ollama

```text
Client -> localhost:11434 -> Ollama Docker service -> NVIDIA CUDA GPU
                                      |
                                      +-> persistent Ollama model store
```

Use this path for simple model lifecycle management, broad quantized-model availability, and Ollama-native APIs.

### MLX

```text
Client -> localhost:18183 -> native mlx_lm.server -> Apple Metal GPU
```

The MLX process runs directly on macOS. A Linux container on Docker Desktop cannot access the Apple Metal GPU.

## Isolation model

- Each runtime has a dedicated process or container.
- Model stores are persistent Docker volumes or native Hugging Face caches.
- Ports bind to loopback by default.
- `.env` is the only local configuration file expected to contain a token.
- The repository does not mount the Docker socket.
- The repository does not require privileged mode.

## Non-goals

- Public internet exposure
- Multi-tenant authorization
- Distributed multi-node inference
- Training or fine-tuning
- Automatic model trust or safety evaluation
- Automatic GPU sharing between inference engines
