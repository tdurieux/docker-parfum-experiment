# This Dockerfile creates the container for testing on Debian Unstable


FROM debian:unstable
MAINTAINER Sergio Martins (sergio.martins@kdab.com)

RUN apt-get update && apt install --no-install-recommends -y build-essential g++ clang-12 clang-tools-12 libclang-12-dev git-core python3 ninja-build qtbase5-dev qtdeclarative5-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

# Install a more recent CMake, so we can use presets
WORKDIR /
RUN git clone https://github.com/Kitware/CMake.git
WORKDIR /CMake
RUN git checkout v3.21.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/ && make -j10 && make install

RUN groupadd -g 1000 defaultgroup && \
useradd -u 1000 -g defaultgroup user -m

ENV PATH=/usr/lib/llvm-12/bin/:/clazy-src/build-debian-unstable/bin/:$PATH
ENV LD_LIBRARY_PATH=/usr/lib/llvm-12/lib64/:/clazy-src/build-debian-unstable/lib/:$LD_LIBRARY_PATH
ENV CLANG_BUILTIN_INCLUDE_DIR=/usr/lib/llvm-12/lib/clang/12.0.1/include/
