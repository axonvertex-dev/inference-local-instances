# Benchmarking

## Principles

Compare runtimes with the same prompt, output-token limit, warm-up policy, and host load. Do not compare a cold first request against a warmed model.

## Basic workflow

1. Start one runtime only.
2. Record host details.
3. Send one warm-up request.
4. Send at least five measured requests.
5. Record wall-clock latency, input tokens, output tokens, and runtime-reported throughput when available.
6. Monitor memory and GPU utilization during the run.

## Host capture

Linux or WSL:

```bash
uname -a
lscpu
free -h
nvidia-smi
```

macOS:

```bash
sw_vers
system_profiler SPHardwareDataType SPDisplaysDataType
```

## Included helper

```bash
./scripts/benchmark-openai.sh http://127.0.0.1:18181/v1 MODEL_ID
```

The helper performs a warm-up and writes one JSON response plus timing information. It is intentionally simple and is not a substitute for a load-testing framework.

## GPU monitoring

```bash
watch -n 1 nvidia-smi
```

WSL users should run this inside the WSL distribution where Docker commands are executed.
