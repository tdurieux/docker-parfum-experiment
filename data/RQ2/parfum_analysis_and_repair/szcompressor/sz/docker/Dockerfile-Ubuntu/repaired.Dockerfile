FROM ubuntu:18.04
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        cmake \
        coreutils \
        libcunit1-dev \
        exuberant-ctags \
        libfftw3-dev \
        libzstd1-dev \
        libnetcdf-dev \
        ninja-build \
        swig \
        gcc \
        g++ \
        zlib1g-dev && \
    apt-get clean all && rm -rf /var/lib/apt/lists/*;
COPY . /build/
WORKDIR /build/
RUN rm -rf build && \
    mkdir -p build && \
    cd build && \
    cmake -G Ninja .. && \
    ninja
