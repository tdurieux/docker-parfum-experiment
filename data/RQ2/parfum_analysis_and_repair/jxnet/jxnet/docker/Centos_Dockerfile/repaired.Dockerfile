# centos 7 base os
FROM centos:7

# need root permission to install some development tools
USER root

# install required tools
RUN yum -y install bash \
        gcc \
        gcc-c++ \
        make \
        git && rm -rf /var/cache/yum

# required to build libpcap
RUN yum -y install bison \
        flex && rm -rf /var/cache/yum

# install autotools
RUN yum -y install automake \
        autoconf \
        libtool && rm -rf /var/cache/yum

# install cmake
RUN yum -y install cmake && rm -rf /var/cache/yum

# clean cache
RUN yum clean all

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
