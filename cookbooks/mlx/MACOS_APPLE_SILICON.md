# Native MLX on macOS Apple Silicon

## Why native instead of Docker

Docker Desktop runs Linux virtual machines and containers. It does not expose the Apple Metal GPU as a CUDA-like device to Linux containers. Native MLX can use Apple Silicon unified memory and Metal directly.

## 1. Confirm Apple Silicon

```bash
uname -m
```

Expected:

```text
arm64
```

## 2. Install system prerequisites

Install Xcode command-line tools:

```bash
xcode-select --install
```

Install Python 3.11 or 3.12. Homebrew example:

```bash
brew install python@3.12
```

## 3. Configure

```bash
cp .env.example .env
chmod 600 .env
```

Default model:

```dotenv
MLX_MODEL=mlx-community/gemma-4-e2b-it-4bit
```

## 4. Start the OpenAI-compatible text server

```bash
./scripts/start-mlx.sh
```

The script creates `native/mlx/.venv`, installs the configured MLX packages, and starts the native server on `127.0.0.1:18183`.

## 5. Verify

In another terminal:

```bash
./scripts/verify-mlx.sh
```

## 6. Multimodal image inference

Activate the environment:

```bash
source native/mlx/.venv/bin/activate
```

Run:

```bash
mlx_vlm.generate \
  --model mlx-community/gemma-4-e2b-it-4bit \
  --image /absolute/path/to/image.jpg \
  --prompt "Describe the image accurately."
```

## 7. Stop

Press `Ctrl+C` in the terminal running the MLX server.

## 8. Remove the environment

```bash
rm -rf native/mlx/.venv
```

Downloaded Hugging Face model files remain in the user's native cache unless removed separately.
