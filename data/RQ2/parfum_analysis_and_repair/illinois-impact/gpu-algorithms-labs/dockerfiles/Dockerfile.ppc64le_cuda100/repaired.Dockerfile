FROM nvidia/cuda-ppc64le:10.0-devel-ubuntu18.04
LABEL maintainer="pearson@illinois.edu"

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        software-properties-common \
        zlib1g-dev \
        libcurl4-openssl-dev \
        wget \
        unzip \
        apt-transport-https \
        ca-certificates \
    && \
    rm -rf /var/lib/apt/lists/*



ADD https://github.com/Kitware/CMake/releases/download/v3.13.3/cmake-3.13.3.tar.gz /tmp
RUN cd /tmp \
    && tar -xf cmake-3.13.3.tar.gz \
    && cd cmake-3.13.3 && \
	./bootstrap --system-curl --parallel=`nproc` && \
	make -j $(nproc) &&\
	make install && \
	rm -fr /tmp/cmake-3.13.3 && rm cmake-3.13.3.tar.gz

WORKDIR /build
