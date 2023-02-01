# This should be run from the zef repo root
FROM ubuntu:18.04

WORKDIR /root

RUN apt update

RUN apt install -y --no-install-recommends \
    build-essential \
    cmake \
    make \
    ninja-build \
    curl \
    git \
    zstd \
    libzstd-dev \
    openssl \
    libssl-dev \
    libsecret-1-0 \
    libcurl4-openssl-dev \
    jq && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt update && \
    apt install --no-install-recommends -y \
        python3.8 \
        python3.8-dev \
        python3.8-distutils && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py --silent && \
    python3.8 get-pip.py

WORKDIR /root/project

COPY . .

RUN LIBZEF_LOCATION=$(realpath core) python3.8 -mpip install ./python
