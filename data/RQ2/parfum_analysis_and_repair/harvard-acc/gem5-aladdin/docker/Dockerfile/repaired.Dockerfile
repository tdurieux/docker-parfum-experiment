FROM ubuntu:18.04
LABEL maintainer="Sam Xi, Yuan Yao"

###################################################
####      Install tools for development.       ####
###################################################

RUN apt-get update && apt-get install --no-install-recommends -y \
  python \
  python-pip \
  git \
  tmux \
  vim \
  cmake \
  wget \
  ack-grep && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

###########################################
####      Environment variables        ####
###########################################

RUN mkdir -p /workspace
ENV ALADDIN_HOME /workspace/gem5-aladdin/src/aladdin
ENV TRACER_HOME /workspace/LLVM-Tracer
ENV LLVM_HOME /usr/local
ENV BOOST_ROOT /usr/include

ENV SHELL /bin/bash

# So we can link gem5 against libprotobuf when installed from apt.
ENV FORCE_CXX11_ABI 1

#######################################################
####      Install gem5-Aladdin dependencies.       ####
#######################################################

# Install gem5 dependencies.
RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y m4 \
      libprotobuf-dev \
      protobuf-compiler \
      libsqlite3-dev \
      libtcmalloc-minimal4 \
      scons \
      zlib1g \
      zlib1g-dev \
      python3 \
      python3-pip \
      libgoogle-perftools-dev && rm -rf /var/lib/apt/lists/*;
# Change the default Python version to 3.6.
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip2 1
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 2
RUN pip3 install --no-cache-dir --user --upgrade pip
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 2

RUN pip install --no-cache-dir numpy \
      six \
      configparser \
      pyparsing \
      pytest \
      pytest-xdist

# Install Aladdin dependencies.
RUN apt-get install --no-install-recommends -y \
      libboost-graph-dev \
      libpthread-stubs0-dev \
      libreadline-dev \
      libncurses5-dev && rm -rf /var/lib/apt/lists/*;

# Build LLVM and Clang 6.0 from source.
WORKDIR /tmp
RUN wget -q https://releases.llvm.org/6.0.0/llvm-6.0.0.src.tar.xz && \
    tar -xf llvm-6.0.0.src.tar.xz && \
    wget -q https://releases.llvm.org/6.0.0/cfe-6.0.0.src.tar.xz && \
    tar -xf cfe-6.0.0.src.tar.xz && \
    mkdir -p llvm-6.0.0.src/tools/clang && \
    mv cfe-6.0.0.src/* llvm-6.0.0.src/tools/clang && \
    cd llvm-6.0.0.src && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release .. && \
    make -j24 && \
    make install && \
    rm -rf /tmp/llvm-6.0.0* && \
    rm -rf /tmp/cfe-6.0.0* && rm llvm-6.0.0.src.tar.xz

# Build and install LLVM-Tracer
WORKDIR /workspace
RUN git clone https://github.com/ysshao/LLVM-Tracer && \
    cd LLVM-Tracer && \
    git fetch --all && \
    mkdir bin && \
    mkdir lib && \
    mkdir build && cd build && \
    cmake .. && make && make install

# Clone gem5-aladdin, but don't build. We'll assume the developer will build.
RUN git clone https://github.com/harvard-acc/gem5-aladdin && \
    cd gem5-aladdin && \
    git submodule init && \
    git submodule update
