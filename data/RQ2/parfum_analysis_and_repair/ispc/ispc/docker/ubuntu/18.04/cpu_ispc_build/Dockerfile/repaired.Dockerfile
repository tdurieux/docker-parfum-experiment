ARG LLVM_VERSION=13.0

FROM ubuntu:18.04 AS llvm_build_step1
MAINTAINER Dmitry Babokin <dmitry.y.babokin@intel.com>
SHELL ["/bin/bash", "-c"]

ARG REPO=ispc/ispc
ARG SHA=main
ARG LLVM_VERSION
ARG EXTRA_BUILD_ARG

# !!! Make sure that your docker config provides enough memory to the container,
# otherwise LLVM build may fail, as it will use all the cores available to container.

RUN uname -a

# Packages required to build ISPC and Clang.
RUN apt-get -y update && apt-get install --no-install-recommends -y wget build-essential gcc g++ git python3 ncurses-dev libtinfo-dev && \
    rm -rf /var/lib/apt/lists/*

# Download and install required version of cmake (3.14 for x86, 3.20 for aarch64, as earlier versions are not available as binary distribution) for ISPC build
RUN if [[ `uname -m` =~ "x86" ]]; then export CMAKE_URL="https://cmake.org/files/v3.14/cmake-3.14.0-Linux-x86_64.sh"; else export CMAKE_URL="https://github.com/Kitware/CMake/releases/download/v3.20.3/cmake-3.20.3-linux-aarch64.sh"; fi && \
    wget -q --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 -t 5 $CMAKE_URL && mkdir /opt/cmake && sh cmake-*.sh --prefix=/opt/cmake --skip-license && \
    ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake && rm -rf cmake-*.sh

# If you are behind a proxy, you need to configure git.
RUN if [ -v "$http_proxy" ]; then git config --global --add http.proxy "$http_proxy"; fi

WORKDIR /usr/local/src

# Fork ispc on github and clone *your* fork.
RUN git clone https://github.com/$REPO.git ispc
RUN cd ispc && git checkout $SHA && cd ..

# This is home for Clang builds
RUN mkdir /usr/local/src/llvm

ENV ISPC_HOME=/usr/local/src/ispc
ENV LLVM_HOME=/usr/local/src/llvm

# If you are going to run test for future platforms, go to
# http://www.intel.com/software/sde and download the latest version,
# extract it, add to path and set SDE_HOME.

WORKDIR /usr/local/src/ispc

# Build Clang with all required patches.
# Pass required LLVM_VERSION with --build-arg LLVM_VERSION=<version>.
# Note self-build options, it's required to build clang and ispc with the same compiler,
# i.e. if clang was built by gcc, you may need to use gcc to build ispc (i.e. run "make gcc"),
# or better do clang selfbuild and use it for ispc build as well (i.e. just "make").
# "rm" are just to keep docker image small.
RUN python3 ./alloy.py -b --version=$LLVM_VERSION --selfbuild-phase1 --verbose $EXTRA_BUILD_ARG && \
    rm -rf $LLVM_HOME/build-"$LLVM_VERSION"_temp

FROM llvm_build_step1 AS llvm_build_step2
ARG LLVM_VERSION
ARG EXTRA_BUILD_ARG

RUN python3 ./alloy.py -b --version=$LLVM_VERSION --selfbuild-phase2 --verbose $EXTRA_BUILD_ARG && \
    rm -rf $LLVM_HOME/build-$LLVM_VERSION $LLVM_HOME/llvm-$LLVM_VERSION $LLVM_HOME/bin-"$LLVM_VERSION"_temp
ENV PATH=$LLVM_HOME/bin-$LLVM_VERSION/bin:$PATH

FROM llvm_build_step2 AS ispc_build
ARG LLVM_VERSION

# ISPC builds in C++17 mode and will fail without modern libstdc++
# Also install regular ISPC dependencies
RUN if [[ `uname -m` =~ "x86" ]]; then export CROSS_LIBS="libc6-dev-i386"; else export CROSS_LIBS="libc6-dev-armhf-cross"; fi && \
    apt-get -y update && apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && apt-get -y update && \
    apt-get -y update && apt-get install --no-install-recommends -y libstdc++-9-dev && \
    apt-get install --no-install-recommends -y m4 bison flex zlib1g-dev $CROSS_LIBS && \
    rm -rf /var/lib/apt/lists/*

# Configure ISPC build
RUN mkdir build_$LLVM_VERSION
WORKDIR build_$LLVM_VERSION
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/src/ispc/bin-$LLVM_VERSION -DCMAKE_CXX_FLAGS=-Werror

# Build ISPC
RUN make ispc -j8 && make check-all && make install
WORKDIR ../
RUN rm -rf build_$LLVM_VERSION

#export path for ispc
ENV PATH=/usr/local/src/ispc/bin-$LLVM_VERSION/bin:$PATH
