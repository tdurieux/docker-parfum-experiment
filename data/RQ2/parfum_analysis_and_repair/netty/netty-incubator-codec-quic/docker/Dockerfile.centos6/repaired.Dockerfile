FROM centos:6.10

ENV SOURCE_DIR /root/source
ENV LIBS_DIR /root/libs
ENV CMAKE_VERSION_BASE 3.8
ENV CMAKE_VERSION $CMAKE_VERSION_BASE.2
ENV NINJA_VERSION 1.7.2
ENV GO_VERSION 1.9.3

# Update yum repos as we need to use the vault now.
RUN sed -i -e 's/^mirrorlist/#mirrorlist/g' -e 's/^#baseurl=http:\/\/mirror.centos.org\/centos\/$releasever\//baseurl=https:\/\/linuxsoft.cern.ch\/centos-vault\/\/6.10\//g' /etc/yum.repos.d/CentOS-Base.repo

# install dependencies
RUN yum install -y \
 apr-devel \
 autoconf \
 automake \
 bzip2 \
 git \
 glibc-devel \
 gnupg \
 libtool \
 lsb-core \
 make \
 perl \
 tar \
 unzip \
 wget \
 zip && rm -rf /var/cache/yum

RUN mkdir $SOURCE_DIR
WORKDIR $SOURCE_DIR

RUN yum install -y centos-release-scl && rm -rf /var/cache/yum
# Update repository urls as we need to use the vault now.
RUN sed -i -e 's/^mirrorlist/#mirrorlist/g' -e 's/^# baseurl=http:\/\/mirror.centos.org\/centos\/6\//baseurl=https:\/\/vault.centos.org\/centos\/6\//g' /etc/yum.repos.d/CentOS-SCLo-scl.repo
RUN sed -i -e 's/^mirrorlist/#mirrorlist/g' -e 's/^#baseurl=http:\/\/mirror.centos.org\/centos\/6\//baseurl=https:\/\/vault.centos.org\/centos\/6\//g' /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo

RUN yum -y install devtoolset-7-gcc devtoolset-7-gcc-c++ && rm -rf /var/cache/yum
RUN echo 'source /opt/rh/devtoolset-7/enable' >> ~/.bashrc

RUN wget -q https://github.com/ninja-build/ninja/releases/download/v$NINJA_VERSION/ninja-linux.zip && unzip ninja-linux.zip && mkdir -p /opt/ninja-$NINJA_VERSION/bin && mv ninja /opt/ninja-$NINJA_VERSION/bin && echo 'PATH=/opt/ninja-$NINJA_VERSION/bin:$PATH' >> ~/.bashrc
RUN wget -q https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz && tar zxf go$GO_VERSION.linux-amd64.tar.gz && mv go /opt/ && echo 'PATH=/opt/go/bin:$PATH' >> ~/.bashrc && echo 'export GOROOT=/opt/go/' >> ~/.bashrc && rm go$GO_VERSION.linux-amd64.tar.gz
RUN curl -f -s https://cmake.org/files/v$CMAKE_VERSION_BASE/cmake-$CMAKE_VERSION-Linux-x86_64.tar.gz --output cmake-$CMAKE_VERSION-Linux-x86_64.tar.gz && tar zvxf cmake-$CMAKE_VERSION-Linux-x86_64.tar.gz && mv cmake-$CMAKE_VERSION-Linux-x86_64 /opt/ && echo 'PATH=/opt/cmake-$CMAKE_VERSION-Linux-x86_64/bin:$PATH' >> ~/.bashrc && rm cmake-$CMAKE_VERSION-Linux-x86_64.tar.gz



# Downloading and installing SDKMAN!
RUN curl -f -s "https://get.sdkman.io" | bash

ARG java_version="8.0.302-zulu"
ENV JAVA_VERSION $java_version

# Installing Java removing some unnecessary SDKMAN files
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    yes | sdk install java $JAVA_VERSION && \
    rm -rf $HOME/.sdkman/archives/* && \
    rm -rf $HOME/.sdkman/tmp/*"

RUN echo 'export JAVA_HOME="/root/.sdkman/candidates/java/current"' >> ~/.bashrc
RUN echo 'PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc

# install rust and setup PATH
run curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN echo 'PATH=$PATH:$HOME/.cargo/bin' >> ~/.bashrc

WORKDIR /opt
RUN curl -f https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz | tar -xz
RUN echo 'PATH=/opt/apache-maven-3.6.3/bin/:$PATH' >> ~/.bashrc

# Prepare our own build
ENV PATH /opt/apache-maven-3.6.3/bin/:$PATH
ENV JAVA_HOME /root/.sdkman/candidates/java/current

# This is workaround to be able to compile boringssl with -DOPENSSL_C11_ATOMIC as while we use a recent gcc installation it still needs some
# help to define static_assert(...) as otherwise the compilation will fail due the system installed assert.h which missed this definition.
RUN mkdir ~/.include
RUN echo '#include "/usr/include/assert.h"' >>  ~/.include/assert.h
RUN echo '#define static_assert _Static_assert'  >>  ~/.include/assert.h
RUN echo 'export C_INCLUDE_PATH="$HOME/.include/"' >>  ~/.bashrc
# Needed to compile against old glibc
RUN echo 'export LDFLAGS=-lrt' >>  ~/.bashrc
