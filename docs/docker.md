# Docker

## Prerequisites
* Docker must be installed and running on your system.
* Create a folder to store big models & intermediate files (ex. /llama/models)

## Images
We have three Docker images available for this project:

1. `ghcr.io/volkermauel/ik_llama.cpp:full`: This image includes both the main executable file and the tools to convert LLaMA models into ggml and convert into 4-bit quantization. (platforms: `linux/amd64`, `linux/arm64`)
2. `ghcr.io/volkermauel/ik_llama.cpp:light`: This image only includes the main executable file. (platforms: `linux/amd64`, `linux/arm64`)
3. `ghcr.io/volkermauel/ik_llama.cpp:server`: This image only includes the server executable file. (platforms: `linux/amd64`, `linux/arm64`)

Additionally, the following images, similar to the above, are available:

- `ghcr.io/volkermauel/ik_llama.cpp:full-cuda`: Same as `full` but compiled with CUDA support and used as the base for CUDA images. (platforms: `linux/amd64`)
- `ghcr.io/volkermauel/ik_llama.cpp:llama-cli-cuda`: CUDA-enabled CLI image built from `full-cuda`. (platforms: `linux/amd64`)
- `ghcr.io/volkermauel/ik_llama.cpp:llama-server`: CUDA-enabled server image built from `full-cuda`. (platforms: `linux/amd64`)
- `ghcr.io/volkermauel/ik_llama.cpp:full-rocm`: Same as `full` but compiled with ROCm support. (platforms: `linux/amd64`, `linux/arm64`)
- `ghcr.io/volkermauel/ik_llama.cpp:light-rocm`: Same as `light` but compiled with ROCm support. (platforms: `linux/amd64`, `linux/arm64`)
- `ghcr.io/volkermauel/ik_llama.cpp:server-rocm`: Same as `server` but compiled with ROCm support. (platforms: `linux/amd64`, `linux/arm64`)

The GPU enabled images are not currently tested by CI beyond being built. They are not built with any variation from the ones in the Dockerfiles defined in [.devops/](.devops/) and the GitHub Action defined in [.github/workflows/docker.yml](.github/workflows/docker.yml). If you need different settings (for example, a different CUDA or ROCm library, you'll need to build the images locally for now).

## Usage

The easiest way to download the models, convert them to ggml and optimize them is with the --all-in-one command which includes the full docker image.

Replace `/path/to/models` below with the actual path where you downloaded the models.

```bash
docker run -v /path/to/models:/models ghcr.io/volkermauel/ik_llama.cpp:full --all-in-one "/models/" 7B
```

On completion, you are ready to play!

```bash
docker run -v /path/to/models:/models ghcr.io/volkermauel/ik_llama.cpp:full --run -m /models/7B/ggml-model-q4_0.gguf -p "Building a website can be done in 10 simple steps:" -n 512
```

or with a light image:

```bash
docker run -v /path/to/models:/models ghcr.io/volkermauel/ik_llama.cpp:light -m /models/7B/ggml-model-q4_0.gguf -p "Building a website can be done in 10 simple steps:" -n 512
```

or with a server image:

```bash
docker run -v /path/to/models:/models -p 8000:8000 ghcr.io/volkermauel/ik_llama.cpp:server -m /models/7B/ggml-model-q4_0.gguf --port 8000 --host 0.0.0.0 -n 512
```

## Docker With CUDA

Assuming one has the [nvidia-container-toolkit](https://github.com/NVIDIA/nvidia-container-toolkit) properly installed on Linux, or is using a GPU enabled cloud, `cuBLAS` should be accessible inside the container.

## Building Docker locally

```bash
docker build -t local/llama.cpp:full-cuda -f .devops/full-cuda.Dockerfile .
docker build -t local/llama.cpp:llama-cli-cuda -f .devops/llama-cli-cuda.Dockerfile .
docker build -t local/llama.cpp:llama-server -f .devops/llama-server.Dockerfile .
```

You may want to pass in some different `ARGS`, depending on the CUDA environment supported by your container host, as well as the GPU architecture.

The defaults are:

- `UBUNTU_VERSION` set to `24.04`
- `CUDA_VERSION` set to `12.9.1`
- `CUDA_DOCKER_ARCH` set to `all`

The resulting images, are essentially the same as the non-CUDA images:

1. `local/llama.cpp:full-cuda`: This image includes both the main executable file and the tools to convert LLaMA models into ggml and convert into 4-bit quantization.
2. `local/llama.cpp:llama-cli-cuda`: This image only includes the main executable file.
3. `local/llama.cpp:llama-server`: This image only includes the server executable file.

## Usage

After building locally, Usage is similar to the non-CUDA examples, but you'll need to add the `--gpus` flag. You will also want to use the `--n-gpu-layers` flag.

```bash
docker run --gpus all -v /path/to/models:/models local/llama.cpp:full-cuda --run -m /models/7B/ggml-model-q4_0.gguf -p "Building a website can be done in 10 simple steps:" -n 512 --n-gpu-layers 1
docker run --gpus all -v /path/to/models:/models local/llama.cpp:llama-cli-cuda -m /models/7B/ggml-model-q4_0.gguf -p "Building a website can be done in 10 simple steps:" -n 512 --n-gpu-layers 1
docker run --gpus all -v /path/to/models:/models local/llama.cpp:llama-server -m /models/7B/ggml-model-q4_0.gguf --port 8000 --host 0.0.0.0 -n 512 --n-gpu-layers 1
```
