FROM braintwister/ubuntu-20.04-cuda-devel-11.0-gcc-8-clang-9-doxygen-1.8.5:0.3

LABEL maintainer="Bernd Doser <bernd.doser@h-its.org>"

RUN apt-get update \
 && apt-get install -y \
    libboost-graph-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN wget -q https://github.com/google/googletest/archive/release-1.8.0.tar.gz \
 && tar xf release-1.8.0.tar.gz \
 && rm release-1.8.0.tar.gz \
 && cd googletest-release-1.8.0 \
 && mkdir build \
 && cd build \
 && cmake -DCMAKE_INSTALL_PREFIX=/opt/googletest-1.8.0 .. \
 && make -j \
 && make install \
 && rm -r /tmp/googletest-release-1.8.0

WORKDIR /

ENV GTEST_ROOT /opt/googletest-1.8.0
