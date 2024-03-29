# Build Image for Gitlab CI

FROM ubuntu:16.04

MAINTAINER Elliott Slaughter <slaughter@cs.stanford.edu>

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq apt-transport-https ca-certificates software-properties-common wget && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    add-apt-repository ppa:pypy/ppa -y && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    add-apt-repository -y "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main" && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq \
      build-essential git time wget curl \
      libpython-dev python-pip libpython3-dev python3-pip pypy pypy3 \
      g++-4.8 g++-4.9 g++-5 g++-6 g++-7 g++-8 \
      gfortran-4.8 gfortran-4.9 gfortran-5 gfortran-6 gfortran-7 gfortran-8 \
      gcc-multilib g++-multilib \
      gcc-4.9-multilib g++-4.9-multilib \
      clang-3.8 libclang-3.8-dev llvm-3.8-dev \
      clang-8 libclang-8-dev llvm-8-dev \
      libncurses5-dev \
      zlib1g-dev zlib1g-dev:i386 \
      mpich libmpich-dev \
      mesa-common-dev \
      libblas-dev liblapack-dev libhdf5-dev \
      libssl-dev \
      gdb vim && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade 'pip>=20,<21' && \
    pip install --no-cache-dir --upgrade 'setuptools>=44,<45' && \
    pip install --no-cache-dir cffi github3.py 'numpy>=1.16,<1.17' qualname && \
    pip3 install --no-cache-dir --upgrade 'setuptools>=50,<51' 'setuptools_rust>=0.11,<0.12' && \
    pip3 install --no-cache-dir cffi github3.py 'numpy>=1.18,<1.19' 'cryptography>=3.2,<3.3' 'pandas>=0.24,<0.25' daff tabulate

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN wget https://cmake.org/files/v3.13/cmake-3.13.0-Linux-x86_64.tar.gz && \
    echo "1c6612f3c6dd62959ceaa96c4b64ba7785132de0b9cbc719eea6fe1365cc8d94  cmake-3.13.0-Linux-x86_64.tar.gz" | shasum --check && \
    tar xfzC cmake-3.13.0-Linux-x86_64.tar.gz /usr/local --strip-components=1 && \
    rm cmake-3.13.0-Linux-x86_64.tar.gz

RUN git clone -b luajit2.1 https://github.com/StanfordLegion/terra.git && \
    cp -r terra terra38 && \
    LLVM_CONFIG=llvm-config-3.8 make -C terra38 REEXPORT_LLVM_COMPONENTS="irreader mcjit x86" && \
    mkdir /usr/local/terra38 && \
    make -C terra38 install PREFIX=/usr/local/terra38 && \
    rm -rf terra38 && \
    rm -rf terra
