FROM centos:centos6.7

RUN yum -y upgrade

RUN yum -y install \
    wget git findutils binutils \
    zip unzip tar gzip zlib-devel \
    clang gcc gcc-c++ \
    java java-devel java-1.8.0-openjdk-devel \
    python

RUN wget http://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo
RUN yum -y install devtoolset-2-gcc devtoolset-2-gcc-c++ devtoolset-2-binutils

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0
ENV CC /opt/rh/devtoolset-2/root/usr/bin/gcc
