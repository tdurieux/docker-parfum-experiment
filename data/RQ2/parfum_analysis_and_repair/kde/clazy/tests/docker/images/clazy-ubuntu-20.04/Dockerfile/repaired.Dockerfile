# This Dockerfile creates the container for testing on Ubuntu 20.04

FROM ubuntu:20.04
MAINTAINER Sergio Martins (sergio.martins@kdab.com)


ENV PATH=/Qt/5.15.2/gcc_64/bin/:$PATH
ENV LC_CTYPE=C.UTF-8

ENV TZ=Europe/Lisbon
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt install --no-install-recommends -y build-essential g++ clang-9 clang-tools-9 libclang-9-dev libclang-9-dev \
git-core python3 ninja-build qtbase5-dev qtdeclarative5-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

# Install a more recent CMake, so we can use presets
WORKDIR /
RUN git clone https://github.com/Kitware/CMake.git
WORKDIR /CMake
RUN git checkout v3.21.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/ && make -j10 && make install

RUN groupadd -g 1000 defaultgroup && \
useradd -u 1000 -g defaultgroup user -m


ENV PATH=/usr/lib/llvm-9/bin/:/clazy-src/build-ubuntu-20.04/bin/:$PATH
ENV LD_LIBRARY_PATH=/usr/lib/llvm-9/lib64/:/clazy-src/build-ubuntu-20.04/lib/:$LD_LIBRARY_PATH
ENV CLANG_BUILTIN_INCLUDE_DIR=/usr/lib/llvm-9/lib/clang/9.0.1/include/
