ARG UBUNTU_VERSION=24.04

# This needs to generally match the container host's environment.
ARG CUDA_VERSION=12.9.1

# Target the CUDA build image
ARG BASE_CUDA_DEV_CONTAINER=nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}

FROM ${BASE_CUDA_DEV_CONTAINER} AS build

# Unless otherwise specified, we make a fat build.
ARG CUDA_DOCKER_ARCH=all

RUN apt-get update && \
    apt-get install -y build-essential python3 python3-pip git libcurl4-openssl-dev libgomp1

COPY requirements.txt   requirements.txt
COPY requirements       requirements

# Allow installing Python packages into the system environment even though
# the base image marks it as externally managed (PEP 668).
RUN python3 -m pip install --break-system-packages --ignore-installed pip setuptools \
    && python3 -m pip install --break-system-packages --ignore-installed wheel \
    && python3 -m pip install --break-system-packages -r requirements.txt

WORKDIR /app

COPY . .

# Set nvcc architecture
ENV CUDA_DOCKER_ARCH=${CUDA_DOCKER_ARCH}
# Enable CUDA
ENV GGML_CUDA=1
# Enable cURL
ENV LLAMA_CURL=1

RUN make -j$(nproc)

ENTRYPOINT ["/app/.devops/tools.sh"]
