FROM ubuntu:xenial

ENV CLANG_VERSION 4.0

# we have to install llvm-dev package as well due to -flto option
# see: https://bugs.launchpad.net/ubuntu/+source/llvm-toolchain-snapshot/+bug/1254970
RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo software-properties-common && \
    add-apt-repository http://openrtm.org/pub/Linux/ubuntu/ && \
    apt-get update && \
    apt-get install --no-install-recommends -y --force-yes \
        clang-${CLANG_VERSION} llvm-${CLANG_VERSION}-dev \
        make uuid-dev libboost-filesystem-dev \
        libomniorb4-dev omniidl \
        openrtm-aist openrtm-aist-doc \
        openrtm-aist-dev openrtm-aist-example \
        python-yaml && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV CC /usr/bin/clang-${CLANG_VERSION}
ENV CXX /usr/bin/clang++-${CLANG_VERSION}

ADD . /choreonoid

RUN cd /choreonoid && \
    echo "y" | ./misc/script/install-requisites-ubuntu-16.04.sh && \
    cmake . \
        -DCMAKE_BUILD_TYPE=Release       \
        -DINSTALL_SDK:BOOL=TRUE          \
        -DINSTALL_DEPENDENCIES:BOOL=TRUE \
        -DCNOID_ENABLE_GETTEXT:BOOL=TRUE \
        -DUSE_EXTERNAL_EIGEN:BOOL=TRUE   \
        -DUSE_EXTERNAL_YAML:BOOL=TRUE    \
        -DENABLE_CORBA:BOOL=TRUE         \
        -DBUILD_CORBA_PLUGIN:BOOL=TRUE   \
        -DBUILD_OPENRTM_PLUGIN:BOOL=TRUE \
        -DBUILD_GROBOT_PLUGIN:BOOL=TRUE  \
        -DBUILD_ASSIMP_PLUGIN:BOOL=FALSE \
        -DBUILD_PYTHON_PLUGIN:BOOL=TRUE && \
    make && \
    make install
