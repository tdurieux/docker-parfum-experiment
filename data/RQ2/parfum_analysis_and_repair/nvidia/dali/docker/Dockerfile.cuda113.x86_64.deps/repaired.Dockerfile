ARG TOOLKIT_BASE_IMAGE=ubuntu:18.04
FROM ${TOOLKIT_BASE_IMAGE} as cuda

RUN apt update && apt install --no-install-recommends -y libxml2 curl perl gcc && \
    rm -rf /var/lib/apt/lists/*

RUN curl -f -LO https://developer.download.nvidia.com/compute/cuda/11.3.1/local_installers/cuda_11.3.1_465.19.01_linux.run && \
    chmod +x cuda_*.run && \
    ./cuda_*.run --silent --no-opengl-libs --toolkit && \
    rm -f cuda_*.run;

RUN NVJPEG2K_VERSION=0.2.0 && \
    apt-get update && \
    apt-get install --no-install-recommends wget software-properties-common -y && \
    wget -qO - https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /" && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub && \
    apt-get update && \
    apt-get install --no-install-recommends libnvjpeg2k0 libnvjpeg2k-dev -y && \
    cp /usr/include/nvjpeg2k* /usr/local/cuda/include/ && \
    cp /usr/lib/x86_64-linux-gnu/libnvjpeg2k* /usr/local/cuda/lib64/ && \
    rm -rf /var/lib/apt/lists/*
