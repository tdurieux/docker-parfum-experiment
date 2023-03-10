ARG TOOLKIT_BASE_IMAGE=ubuntu:18.04
FROM ${TOOLKIT_BASE_IMAGE} as cuda

RUN apt update && apt install --no-install-recommends -y libxml2 curl perl gcc && \
    rm -rf /var/lib/apt/lists/*

RUN CUDA_VERSION=9.0 && \
    CUDA_BUILD=9.0.176_384.81 && \
    curl -f -LO https://developer.nvidia.com/compute/cuda/${CUDA_VERSION}/Prod/local_installers/cuda_${CUDA_BUILD}_linux-run && \
    chmod +x cuda_${CUDA_BUILD}_linux-run && \
    ./cuda_${CUDA_BUILD}_linux-run --silent --no-opengl-libs --toolkit && \
    rm -f cuda_${CUDA_BUILD}_linux-run; \
    # nvJpeg
    NVJPEG_VERSION=719-25900922 && \
    NVJPEG_BUILD=9.0.${NVJPEG_VERSION} && \
    curl -f -L https://developer.download.nvidia.com/compute/redist/libnvjpeg/cuda-linux64-nvjpeg-${NVJPEG_BUILD}.tar.gz | tar -xzf - && \
    cd /cuda-linux64-nvjpeg/ && \
    mv lib64/libnvjpeg*.a* /usr/local/cuda/lib64/ && \
    mv include/nvjpeg.h /usr/local/cuda/include/ && \
    rm -rf /cuda-linux64-nvjpeg;
