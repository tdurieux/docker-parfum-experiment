FROM ubuntu:bionic

MAINTAINER tbd

WORKDIR /src

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    gcc-multilib \
    llvm \
    clang \
    bison \
    git \
    curl \
    cabextract \
    libasan5 \
    jq \
    libncurses5 \
    libcapstone3 \
    libcapstone-dev \
    libmagic-dev \
    libzip4 \
    libzip-dev \
    liblz4-1 \
    liblz4-dev \
    gnupg2 \
    python-pip \
    python3-pip \
    pkg-config \
    liblzma5 \
    npm \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir meson
RUN pip3 install --no-cache-dir ninja
RUN pip3 install --no-cache-dir 'git+https://github.com/radareorg/radare2-r2pipe#egg=r2pipe&subdirectory=python'

CMD []
