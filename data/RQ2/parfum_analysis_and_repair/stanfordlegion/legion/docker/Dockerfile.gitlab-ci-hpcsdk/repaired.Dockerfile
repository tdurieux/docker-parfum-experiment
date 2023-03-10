# Build Image for Gitlab CI

FROM nvcr.io/nvidia/nvhpc:21.2-devel-cuda_multi-ubuntu20.04

MAINTAINER Sean Treichler <sean@nvidia.com>

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq apt-transport-https ca-certificates software-properties-common wget && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    add-apt-repository ppa:pypy/ppa -y && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    add-apt-repository -y "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-9 main" && \
    add-apt-repository -y "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-10 main" && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq \
      less \
      libpython3-dev python3-pip pypy3 && \
    apt-get clean && \
    pip3 install --no-cache-dir --upgrade setuptools && \
    pip3 install --no-cache-dir cffi github3.py numpy qualname && rm -rf /var/lib/apt/lists/*;

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# TODO: build Terra so we can run regent tests too
#RUN git clone -b luajit2.1 https://github.com/StanfordLegion/terra.git terra9 && \
#    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/terra9 -DLLVM_DIR=/usr/lib/llvm-9/cmake -S terra9 -B terra9/build && \
#    make -C terra9/build install -j8 && \
#    rm -rf terra9

# delete a bunch of stuff we don't need (yet) - NOTE: this is only useful
#  if you use docker-squash on the resulting image (docker build --squash
#  only squashes the new layers we add here)
RUN rm -rf /opt/nvidia/hpc_sdk/Linux_x86_64/21.2/comm_libs/ && \
    rm -rf /opt/nvidia/hpc_sdk/Linux_x86_64/21.2/math_libs/ && \
    rm -rf /opt/nvidia/hpc_sdk/Linux_x86_64/21.2/profilers/ && \
    rm -rf /opt/nvidia/hpc_sdk/Linux_x86_64/21.2/examples/
