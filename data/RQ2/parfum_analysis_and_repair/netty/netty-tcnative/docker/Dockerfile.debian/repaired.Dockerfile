ARG debian_version=7
FROM debian:$debian_version
# needed to do again after FROM due to docker limitation
ARG debian_version

ENV SOURCE_DIR /root/source
ENV CMAKE_VERSION_BASE 3.8
ENV CMAKE_VERSION $CMAKE_VERSION_BASE.2
ENV NINJA_VERSION 1.7.2
ENV GO_VERSION 1.9.3
ENV GCC_VERSION 4.9.4

# install dependencies
RUN echo "deb http://archive.debian.org/debian/ wheezy contrib main non-free" > /etc/apt/sources.list && \
 echo "deb-src http://archive.debian.org/debian/ wheezy contrib main non-free" >> /etc/apt/sources.list && \ 
 apt-get -y update && apt-get --force-yes --no-install-recommends -y install \
 autoconf \
 automake \
 bzip2 \
 cmake \
 curl \
 gcc \
 gcc-multilib \
 git \
 gnupg \
 g++ \
 libapr1-dev \
 libssl1.0.0=1.0.1e-2+deb7u20 \
 libssl-dev \
 libtool \
 libc-bin=2.13-38+deb7u10 \
 libc6=2.13-38+deb7u10 libc6-dev \
 make \
 perl-base=5.14.2-21+deb7u3 \
 tar \
 unzip \
 wget \
 xutils-dev \
 zip && rm -rf /var/lib/apt/lists/*;

RUN mkdir $SOURCE_DIR
WORKDIR $SOURCE_DIR

RUN curl -f -q -k https://cmake.org/files/v$CMAKE_VERSION_BASE/cmake-$CMAKE_VERSION-Linux-x86_64.tar.gz --output cmake-$CMAKE_VERSION-Linux-x86_64.tar.gz && tar zxf cmake-$CMAKE_VERSION-Linux-x86_64.tar.gz && mv cmake-$CMAKE_VERSION-Linux-x86_64 /opt/ && echo 'PATH=/opt/cmake-$CMAKE_VERSION-Linux-x86_64/bin:$PATH' >> ~/.bashrc && rm cmake-$CMAKE_VERSION-Linux-x86_64.tar.gz

RUN wget -q https://github.com/ninja-build/ninja/releases/download/v$NINJA_VERSION/ninja-linux.zip && unzip ninja-linux.zip && mkdir -p /opt/ninja-$NINJA_VERSION/bin && mv ninja /opt/ninja-$NINJA_VERSION/bin && echo 'PATH=/opt/ninja-$NINJA_VERSION/bin:$PATH' >> ~/.bashrc

RUN wget -q https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz && tar zxf go$GO_VERSION.linux-amd64.tar.gz && mv go /opt/ && echo 'PATH=/opt/go/bin:$PATH' >> ~/.bashrc && echo 'export GOROOT=/opt/go/' >> ~/.bashrc && rm go$GO_VERSION.linux-amd64.tar.gz

RUN wget -q https://github.com/netty/netty-tcnative/releases/download/gcc-precompile/gcc-$GCC_VERSION.tar.gz && tar zxf gcc-$GCC_VERSION.tar.gz && mv gcc-$GCC_VERSION /opt/ && echo 'PATH=/opt/gcc-$GCC_VERSION/bin:$PATH' >> ~/.bashrc && echo 'export CC=/opt/gcc-$GCC_VERSION/bin/gcc' >> ~/.bashrc && echo 'export CXX=/opt/gcc-$GCC_VERSION/bin/g++' >> ~/.bashrc && rm gcc-$GCC_VERSION.tar.gz

RUN rm -rf $SOURCE_DIR

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

WORKDIR /opt
RUN curl -f https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz | tar -xz
RUN echo 'PATH=/opt/apache-maven-3.6.3/bin/:$PATH' >> ~/.bashrc

# Prepare our own build
ENV PATH /opt/apache-maven-3.6.3/bin/:$PATH
ENV JAVA_HOME /jdk/
