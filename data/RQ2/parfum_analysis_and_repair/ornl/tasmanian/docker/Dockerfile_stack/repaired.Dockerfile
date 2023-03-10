FROM ubuntu:22.04

RUN apt update && apt install --no-install-recommends -y \
        build-essential \
        clang \
        libomp-dev \
        libopenblas-dev \
        python3 \
        python3-numpy \
        cmake \
        gfortran \
        git \
        libopenmpi-dev \
        openmpi-bin \
        openssh-client \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*