FROM ubuntu:20.04
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV DEBIAN_FRONTEND=noninteractive
USER root
RUN apt-get update && apt-get install -yq --no-install-recommends \
    git wget \
    ca-certificates \
wget cmake  libboost-filesystem-dev libboost-program-options-dev libboost-iostreams-dev libboost-date-time-dev \
 libprotoc-dev libprotoc-dev protobuf-compiler openssl openssh-client vim \
 mafft rsync libtbb-dev mpich libmpich-dev automake libtool autoconf make nasm gdb && apt clean && rm -rf /var/lib/apt/lists/*;

RUN mkdir ISAL&& \
    cd ISAL&& \
    wget https://github.com/intel/isa-l/archive/refs/tags/v2.30.0.tar.gz && \
    tar -xvf v2.30.0.tar.gz && \
    cd isa-l-2.30.0 && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf ISAL && rm v2.30.0.tar.gz
LABEL Name=usher-dev
