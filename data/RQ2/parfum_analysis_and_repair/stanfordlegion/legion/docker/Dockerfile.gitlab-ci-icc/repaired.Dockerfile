# Build Image for Gitlab CI

FROM ubuntu:20.04

MAINTAINER Elliott Slaughter <slaughter@cs.stanford.edu>

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq apt-transport-https ca-certificates software-properties-common wget && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    add-apt-repository ppa:pypy/ppa -y && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    add-apt-repository -y "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-9 main" && \
    add-apt-repository -y "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-10 main" && \
    wget -O - https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | apt-key add - && \
    apt-add-repository -y "deb https://apt.repos.intel.com/oneapi all main" && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq \
      build-essential git time wget \
      libpython3-dev python3-pip pypy3 \
      g++-9 \
      gfortran-9 \
      gcc-multilib g++-multilib \
      clang-9 libclang-9-dev llvm-9-dev libomp-9-dev \
      intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic \
      intel-oneapi-compiler-fortran \
      cmake \
      libncurses5-dev libedit-dev \
      zlib1g-dev zlib1g-dev:i386 \
      mpich libmpich-dev \
      mesa-common-dev \
      libblas-dev liblapack-dev libhdf5-dev \
      libssl-dev \
      gdb vim && \
    apt-get clean && \
    pip3 install --no-cache-dir --upgrade setuptools && \
    pip3 install --no-cache-dir cffi github3.py numpy qualname && \
    rm -rf /opt/intel/oneapi/compiler/2021.2.0/linux/lib/oclfpga && rm -rf /var/lib/apt/lists/*;

RUN git clone -b luajit2.1 https://github.com/StanfordLegion/terra.git terra9 && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/terra9 -DLLVM_DIR=/usr/lib/llvm-9/cmake -S terra9 -B terra9/build && \
    make -C terra9/build install -j8 && \
    rm -rf terra9
