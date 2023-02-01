FROM ubuntu:18.04
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        coreutils \
        libcunit1-dev \
        exuberant-ctags \
        libfftw3-dev \
        libomp-dev \
        libnetcdf-dev \
        python3-pip \
        ninja-build \
        gcc \
        g++ \
        zlib1g-dev && \
        pip3 install --no-cache-dir cmake && \
    apt-get clean all && rm -rf /var/lib/apt/lists/*;
COPY . /build/
WORKDIR /build/
RUN rm -rf build && \
    mkdir -p build && \
    cd build && \
    cmake -G Ninja .. && \
    ninja
