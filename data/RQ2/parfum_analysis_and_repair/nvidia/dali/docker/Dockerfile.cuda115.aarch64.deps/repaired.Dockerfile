ARG TOOLKIT_BASE_IMAGE=ubuntu:20.04
FROM ${TOOLKIT_BASE_IMAGE} as cuda

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install --no-install-recommends -y libxml2 curl perl gcc && \
    rm -rf /var/lib/apt/lists/*

RUN curl -f -LO https://developer.download.nvidia.com/compute/cuda/11.5.1/local_installers/cuda_11.5.1_495.29.05_linux_sbsa.run && \
    chmod +x cuda_*.run && \
    ./cuda_*.run --silent --no-opengl-libs --toolkit && \
    rm -f cuda_*.run;
