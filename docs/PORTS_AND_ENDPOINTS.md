# Ports and Endpoints

| Runtime | Host port | API base | Models endpoint | Chat endpoint |
|---|---:|---|---|---|
| vLLM | 18181 | `http://127.0.0.1:18181/v1` | `/v1/models` | `/v1/chat/completions` |
| LiteRT-LM | 18182 | `http://127.0.0.1:18182/v1` | `/v1/models` | `/v1/chat/completions` |
| Ollama | 11434 | `http://127.0.0.1:11434` | `/api/tags` | `/api/chat` |
| MLX | 18183 | `http://127.0.0.1:18183/v1` | `/v1/models` | `/v1/chat/completions` |

## Bind policy

Docker Compose publishes each port on `127.0.0.1`, not `0.0.0.0`. The inference process inside the container listens on all container interfaces, but Docker exposes it only through the host loopback interface.

For access through Tailscale or another private overlay, place an authenticated reverse proxy in front of the loopback endpoint or deliberately change the bind address after reviewing `SECURITY.md`.
