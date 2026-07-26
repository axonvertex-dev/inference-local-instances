SHELL := /usr/bin/env bash

.PHONY: help preflight-linux-gpu preflight-wsl-gpu preflight-cpu preflight-macos \
        vllm-up vllm-down vllm-test litert-up litert-down litert-test \
        ollama-up ollama-down ollama-pull ollama-test mlx-up mlx-test manifest validate down

help:
	@printf '%s\n' \
	  'make preflight-linux-gpu' \
	  'make preflight-wsl-gpu' \
	  'make preflight-cpu' \
	  'make preflight-macos' \
	  'make vllm-up | vllm-down | vllm-test' \
	  'make litert-up | litert-down | litert-test' \
	  'make ollama-up | ollama-down | ollama-pull | ollama-test' \
	  'make mlx-up | mlx-test' \
	  'make manifest | validate'

preflight-linux-gpu:
	./scripts/preflight-linux-gpu.sh

preflight-wsl-gpu:
	./scripts/preflight-wsl-gpu.sh

preflight-cpu:
	./scripts/preflight-cpu.sh

preflight-macos:
	./scripts/preflight-macos.sh

vllm-up:
	./scripts/start-vllm.sh

vllm-down:
	./scripts/stop-vllm.sh

vllm-test:
	./scripts/verify-vllm.sh

litert-up:
	./scripts/start-litert.sh

litert-down:
	./scripts/stop-litert.sh

litert-test:
	./scripts/verify-litert.sh

ollama-up:
	./scripts/start-ollama.sh

ollama-down:
	./scripts/stop-ollama.sh

ollama-pull:
	./scripts/pull-ollama-model.sh

ollama-test:
	./scripts/verify-ollama.sh

mlx-up:
	./scripts/start-mlx.sh

mlx-test:
	./scripts/verify-mlx.sh

down:
	docker compose --profile vllm --profile litert --profile ollama down

manifest:
	./scripts/update-manifest.sh

validate:
	./scripts/validate-repo.sh
