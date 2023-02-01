FROM nvidia/cuda:10.2-devel-ubuntu18.04

WORKDIR /root

ARG MPICH_VERSION=3.3.2

ENV DEBIAN_FRONTEND noninteractive
ENV FORCE_UNSAFE_CONFIGURE 1
ENV MPICH_VERSION ${MPICH_VERSION}

# Install basic tools
RUN apt-get update -qq && apt-get install -qq -y --no-install-recommends \
    python3 \
    git tar wget curl \
    gcc-8 g++-8 make && \
    update-alternatives \
        --install /usr/bin/gcc gcc /usr/bin/gcc-8 60 \
        --slave /usr/bin/g++ g++ /usr/bin/g++-8 && \
    update-alternatives --config gcc && \
    rm -rf /var/lib/apt/lists/*

# Install cmake
RUN wget -q "https://github.com/Kitware/CMake/releases/download/v3.18.6/cmake-3.18.6-Linux-x86_64.tar.gz" -O cmake.tar.gz && \
    echo "87136646867ed65e935d6bacd44d52a740c448ad0806f6897d8c3d47ce438c8b  cmake.tar.gz" | sha256sum --check --quiet && \
    tar --strip-components=1 -xzf cmake.tar.gz -C /usr/local && \
    rm -rf cmake.tar.gz

# Install MPICH ABI compatible with Cray's lib on Piz Daint
RUN wget -q https://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz -O mpich.tar.gz && \
    echo "4bfaf8837a54771d3e4922c84071ef80ffebddbb6971a006038d91ee7ef959b9  mpich.tar.gz" | sha256sum --check --quiet && \
    tar -xzf mpich.tar.gz && \
    cd mpich-${MPICH_VERSION} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-fortran && \
    make install -j$(nproc) && \
    rm -rf mpich.tar.gz mpich-${MPICH_VERSION}

# Install bundle tooling for creating small Docker images
RUN wget -q https://github.com/haampie/libtree/releases/download/v1.2.0/libtree_x86_64.tar.gz && \
    echo "4316a52aed7c8d2f7d2736c935bbda952204be92e56948110a143283764c427c  libtree_x86_64.tar.gz" | sha256sum --check --quiet && \
    tar -xzf libtree_x86_64.tar.gz && \
    rm libtree_x86_64.tar.gz && \
    ln -s /root/libtree/libtree /usr/local/bin/libtree
