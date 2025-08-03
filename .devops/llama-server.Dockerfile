ARG FULL_CUDA_IMAGE=ghcr.io/volkermauel/ik_llama.cpp:full-cuda

FROM ${FULL_CUDA_IMAGE}

RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

ENV LC_ALL=C.utf8

HEALTHCHECK CMD [ "curl", "-f", "http://localhost:8080/health" ]

ENTRYPOINT ["/app/llama-server"]
