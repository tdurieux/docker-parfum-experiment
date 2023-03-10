FROM nvidia/cuda:11.3.1-devel-ubuntu20.04

ENV TZ=America/New_York
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
        g++\
        cmake \
        libopenblas-dev \
        python3 \
        python3-numpy \
        gfortran \
        git \
        wget \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*