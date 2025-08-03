ARG FULL_CUDA_IMAGE=ghcr.io/volkermauel/ik_llama.cpp:full-cuda

FROM ${FULL_CUDA_IMAGE}

ENTRYPOINT ["/app/llama-cli"]
