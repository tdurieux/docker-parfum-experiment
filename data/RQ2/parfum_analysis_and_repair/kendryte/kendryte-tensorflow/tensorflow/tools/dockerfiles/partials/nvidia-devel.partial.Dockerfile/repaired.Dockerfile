ARG UBUNTU_VERSION=16.04
FROM nvidia/cuda:9.0-base-ubuntu${UBUNTU_VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-9-0 \
        cuda-cublas-dev-9-0 \
        cuda-cudart-dev-9-0 \
        cuda-cufft-dev-9-0 \
        cuda-curand-dev-9-0 \
        cuda-cusolver-dev-9-0 \
        cuda-cusparse-dev-9-0 \
        curl \
        git \
        libcudnn7=7.2.1.38-1+cuda9.0 \
        libcudnn7-dev=7.2.1.38-1+cuda9.0 \
        libnccl2=2.2.13-1+cuda9.0 \
        libnccl-dev=2.2.13-1+cuda9.0 \
        libcurl3-dev \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        rsync \
        software-properties-common \
        unzip \
        zip \
        zlib1g-dev \
        wget \
        && \
    rm -rf /var/lib/apt/lists/* && \
    find /usr/local/cuda-9.0/lib64/ -type f -name 'lib*_static.a' -not -name 'libcudart_static.a' -delete && \
    rm /usr/lib/x86_64-linux-gnu/libcudnn_static_v7.a

RUN apt-get update && \
        apt-get install -y --no-install-recommends nvinfer-runtime-trt-repo-ubuntu1604-4.0.1-ga-cuda9.0 && \
        apt-get update && \
        apt-get install -y --no-install-recommends libnvinfer4=4.1.2-1+cuda9.0 && \
        apt-get install -y --no-install-recommends libnvinfer-dev=4.1.2-1+cuda9.0 && rm -rf /var/lib/apt/lists/*;

# Link NCCL libray and header where the build script expects them.
RUN mkdir /usr/local/cuda-9.0/lib &&  \
    ln -s /usr/lib/x86_64-linux-gnu/libnccl.so.2 /usr/local/cuda/lib/libnccl.so.2 && \
    ln -s /usr/include/nccl.h /usr/local/cuda/include/nccl.h

# TODO(tobyboyd): Remove after license is excluded from BUILD file.
RUN gunzip /usr/share/doc/libnccl2/NCCL-SLA.txt.gz && \
    cp /usr/share/doc/libnccl2/NCCL-SLA.txt /usr/local/cuda/
