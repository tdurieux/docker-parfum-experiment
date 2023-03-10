FROM ubuntu:18.04

# Tools
RUN apt-get update && apt-get install --no-install-recommends -y -V \
    git \
    make \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Go installation
RUN cd /tmp && \
    wget -q https://dl.google.com/go/go1.14.6.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.14.6.linux-amd64.tar.gz && \
    rm go1.14.6.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Python bindings
RUN cd /tmp && \
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /miniconda && \
    rm Miniconda3-latest-Linux-x86_64.sh

ENV PATH="/miniconda/bin:${PATH}"
RUN conda install -y \
    Cython \
    conda-forge::compilers \
    conda-forge::pyarrow=0.17.1 \
    ipython \
    numpy \
    pkg-config \
    python=3.8

ENV LD_LIBRARY_PATH=/miniconda/lib

WORKDIR /src/carrow
COPY . .
RUN make clean
RUN make artifact-linux-x86_64
RUN go test -v ./...
