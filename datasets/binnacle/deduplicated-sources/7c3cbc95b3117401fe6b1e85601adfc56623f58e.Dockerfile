# Parameters related to building rocblas
ARG base_image

FROM ${base_image}
LABEL maintainer="andrew.chapman@amd.com"

ARG user_uid

# Install dependent packages
RUN yum install -y \
    sudo \
    rock-dkms \
    centos-release-scl \
    devtoolset-7 \
    ca-certificates \
    git \
    cmake3 \
    make \
    clang \
    clang-devel \
    gcc-c++ \
    gcc-gfortran \
    gtest-devel \ 
    gtest \
    pkgconfig \
    python27 \
    python36 \
    python36-devel \
    python36-pip \
    python36-pytest \
    python36-setuptools \
    PyYAML \
    libcxx-devel \
    boost-devel \
    numactl-libs \
    rpm-build \ 
    deltarpm

RUN echo '#!/bin/bash' | tee /etc/profile.d/devtoolset7.sh && echo \
    'source scl_source enable devtoolset-7' >>/etc/profile.d/devtoolset7.sh

RUN pip3 install wheel && pip3 install tox pyyaml
    
# docker pipeline runs containers with particular uid
# create a jenkins user with this specific uid so it can use sudo priviledges
# Grant any member of sudo group password-less sudo privileges
RUN useradd --create-home -u ${user_uid} -o -G video --shell /bin/bash jenkins && \
    echo '%video ALL=(ALL) NOPASSWD:ALL' | tee /etc/sudoers.d/sudo-nopasswd && \
    chmod 400 /etc/sudoers.d/sudo-nopasswd

ARG ROCBLAS_SRC_ROOT=/usr/local/src/rocBLAS

# Clone rocblas repo
# Build client dependencies and install into /usr/local (LAPACK & GTEST)
RUN mkdir -p ${ROCBLAS_SRC_ROOT} && cd ${ROCBLAS_SRC_ROOT} && \
    git clone -b develop --depth=1 https://github.com/ROCmSoftwarePlatform/rocBLAS . && \
    mkdir -p build/deps && cd build/deps && \
    cmake3 -DBUILD_BOOST=OFF ${ROCBLAS_SRC_ROOT}/deps && \
    make -j $(nproc) install && \
    rm -rf ${ROCBLAS_SRC_ROOT}
