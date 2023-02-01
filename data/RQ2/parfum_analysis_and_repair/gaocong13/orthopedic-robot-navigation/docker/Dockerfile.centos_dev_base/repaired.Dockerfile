# This Docker file is used to build a CentOS image with the necessary
# packages installed to complete an xReg build (along with its dependencies).
# Should be tagged something like: xreg-dev-base-centos-${os_version}

ARG os_version=7

FROM centos:${os_version}

RUN yum install -y \
        gcc gcc-c++ make \
        wget \
        openssl-devel \
        glew-devel libXt-devel \
        git && \
    rm -rf /var/cache/yum/*

# Build a recent version of cmake
RUN mkdir cmake_build && cd cmake_build && \
    wget https://github.com/Kitware/CMake/releases/download/v3.18.2/cmake-3.18.2.tar.gz && \
    tar xf cmake-3.18.2.tar.gz && cd cmake-3.18.2 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && \
    cd / && rm -rf cmake_build && rm cmake-3.18.2.tar.gz

