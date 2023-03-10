FROM ubuntu:xenial

ARG DEBIAN_FRONTEND=noninteractive

RUN echo "Installing dependencies"
RUN apt-get update --fix-missing && \
    apt-get install --no-install-recommends -y \
        software-properties-common && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        cmake \
        python \
        g++ \
        libxerces-c-dev \
        libfox-1.6-dev \
        libgdal-dev \
        libproj-dev \
        libgl2ps-dev \
        swig \
        git && rm -rf /var/lib/apt/lists/*;

RUN cd /usr/src && \
    git clone --recursive https://github.com/eclipse/sumo && \
    cd sumo && \
    git checkout 3a3be608d2408d7cbf10f6bba939254ef439c209 && \
    git fetch origin refs/replace/*:refs/replace/* && \
    export SUMO_HOME="$PWD" && \
    mkdir -p build/cmake-build && cd build/cmake-build && \
    cmake ../.. && \
    make -j$(nproc)
