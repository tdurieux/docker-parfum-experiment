FROM ubuntu:16.04

ARG CMAKE_VERSION=3.9
ARG CXX_COMPILER=g++-7

RUN apt-get -y update && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:jonathonf/gcc-7.1 && \
    apt-get -y update && \
    apt-get -y install gcc-7 g++-7 git build-essential autoconf libtool wget curl

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|apt-key add - && \
    add-apt-repository 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main' && \
    apt-get -y update && \
    apt-get -y install clang-8 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-8 60 \
                        --slave /usr/bin/clang++ clang++ /usr/bin/clang++-8

# Install CMake
RUN curl -SL https://cmake.org/files/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.0-Linux-x86_64.tar.gz \
    |tar -xz --strip-components=1 -C /usr/local

# Build GTIRB
COPY . /gt/gtirb/
RUN rm -rf /gt/gtirb/build /gt/gtirb/CMakeCache.txt /gt/gtirb/CMakeFiles /gt/gtirb/CMakeScripts
RUN mkdir -p /gt/gtirb/build
WORKDIR /gt/gtirb/build
RUN cmake ../ -DCMAKE_CXX_COMPILER=${CXX_COMPILER}
RUN make -j

WORKDIR /gt/gtirb/
ENV PATH=/gt/gtirb/build/bin:$PATH
