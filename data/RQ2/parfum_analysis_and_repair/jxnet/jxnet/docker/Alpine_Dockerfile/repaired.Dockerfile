# alpine 3.5 base os
FROM alpine:3.5

# need root permission to install some development tools
USER root

# update local list of software from official repository
RUN apk update

# install required tools
RUN apk --no-cache add linux-headers \
        bash \
        gcc \
        g++ \
        make \
        git

# required to build libpcap
RUN apk --no-cache add bison \
        flex

# install autotools
RUN apk --no-cache add automake \
        autoconf \
        libtool

# install cmake
RUN apk --no-cache add cmake

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
