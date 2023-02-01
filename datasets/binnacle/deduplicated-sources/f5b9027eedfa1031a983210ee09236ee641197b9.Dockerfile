FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get install -y --no-install-recommends make git ssh realpath wget unzip cmake3 vim
RUN apt-get install -y --no-install-recommends libgoogle-glog-dev libyaml-dev
RUN apt-get install -y --no-install-recommends libgtest-dev libz-dev libgmp3-dev
RUN apt-get install -y --no-install-recommends automake libtool valgrind subversion
RUN apt-get install -y --no-install-recommends ca-certificates software-properties-common

RUN cmake --version

# GCC 4.8.*
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt-get install -y --no-install-recommends libcilkrts5
RUN apt-get install -y --no-install-recommends gcc-4.8 g++-4.8
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50

ENV CC /usr/bin/gcc
ENV CXX /usr/bin/g++

# LLVM+Clang
ENV LLVM_SOURCES /tmp/llvm_sources-tapir5.0
WORKDIR $LLVM_SOURCES

ENV CLANG_PREFIX /usr/local/clang+llvm-tapir5.0
ENV CMAKE_VERSION cmake

RUN git clone --recursive https://github.com/wsmoses/Tapir-LLVM llvm && \
    mkdir -p ${LLVM_SOURCES}/llvm_build && cd ${LLVM_SOURCES}/llvm_build && \
    ${CMAKE_VERSION} -DCMAKE_INSTALL_PREFIX=${CLANG_PREFIX} -DLLVM_TARGETS_TO_BUILD=X86 -DCOMPILER_RT_BUILD_CILKTOOLS=OFF -DLLVM_ENABLE_CXX1Y=ON -DLLVM_ENABLE_TERMINFO=OFF -DLLVM_BUILD_TESTS=OFF -DLLVM_ENABLE_ASSERTIONS=ON -DCMAKE_BUILD_TYPE=Release -DLLVM_BUILD_LLVM_DYLIB=ON  -DLLVM_ENABLE_RTTI=ON ../llvm/ && \
    make -j"$(nproc)" -s && make install -j"$(nproc)" -s

RUN rm -Rf ${LLVM_SOURCES}

# Anaconda3
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:/usr/local/cuda/targets/x86_64-linux/lib/stubs/:$LD_LIBRARY_PATH
ENV PATH /usr/local/bin:/usr/local/cuda/bin:$PATH

WORKDIR /conda-install
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh &&\
    wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O anaconda.sh && \
    chmod +x anaconda.sh && \
    ./anaconda.sh -b -p /opt/conda && \
    rm anaconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN conda install \
         numpy\
         decorator\
         six\
         future\
         cmake

# Protobuf 3.4*
WORKDIR /proto-install
RUN wget --quiet https://github.com/google/protobuf/archive/v3.4.0.zip -O proto.zip && unzip -qq proto.zip -d /

RUN cd /protobuf-3.4.0 && ./autogen.sh && ./configure && make -j 8
RUN cd /protobuf-3.4.0 && make install && ldconfig

RUN which conda
RUN conda --version
RUN which protoc
RUN protoc --version
RUN which python
RUN python --version
