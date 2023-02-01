# debian jessie (8) base os
FROM debian:jessie

# need root permission to install some development tools
USER root

# update local list of software from official repository
RUN apt-get update

# install required tools
RUN apt-get -y --no-install-recommends install bash \
        gcc \
        g++ \
        make \
        git && rm -rf /var/lib/apt/lists/*;

# required to build libpcap
RUN apt-get -y --no-install-recommends install bison \
        flex && rm -rf /var/lib/apt/lists/*;

# install autotools
RUN apt-get -y --no-install-recommends install automake \
        autoconf \
        libtool && rm -rf /var/lib/apt/lists/*;

# install cmake
RUN apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean

# add Jxnet project into image
RUN mkdir -p ~/project/
RUN git clone https://github.com/jxnet/Jxnet ~/project/Jxnet

# checkout into jni branch as default
RUN cd ~/project/Jxnet && \
        git checkout jni

# build and install libpcap
RUN cd ~/project/Jxnet/jxnet-native/libpcap && \
        ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
        make

# build jxnet native library with cmake
RUN cd ~/project/Jxnet/jxnet-native/ && \
        mkdir -p build && \
        cd build && \
        cmake ../ && \
        make && \
        make install

# build jxnet native library with autotools
RUN cd ~/project/Jxnet/jxnet-native/ && \
        export JAVA_HOME=$(pwd) && \
        ./bootstrap.sh && \
        ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
        make && \
        make install
