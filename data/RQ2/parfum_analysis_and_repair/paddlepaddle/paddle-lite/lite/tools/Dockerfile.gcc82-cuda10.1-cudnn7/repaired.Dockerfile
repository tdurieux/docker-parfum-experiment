# A image for paddle lite mobile cross compile and simulator on android
FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
MAINTAINER PaddlePaddle Authors <paddle-dev@baidu.com>

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
        curl \
        git \
        make \
        python \
        python-pip \
        python-dev \
        unzip \
        vim \
        wget \
        texinfo && rm -rf /var/lib/apt/lists/*;

# gcc8.2
WORKDIR /usr/bin
RUN apt-get update && \
   DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
   libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
   xz-utils tk-dev libffi-dev liblzma-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-8.2.0/gcc-8.2.0.tar.gz && \
    tar xzvf gcc-8.2.0.tar.gz && \
    cd gcc-8.2.0/ && \
    wget https://ftp.tsukuba.wide.ad.jp/software/gcc/infrastructure/gmp-6.1.0.tar.bz2 && \
    wget https://ftp.tsukuba.wide.ad.jp/software/gcc/infrastructure/mpc-1.0.3.tar.gz && \
    wget https://ftp.tsukuba.wide.ad.jp/software/gcc/infrastructure/mpfr-3.1.4.tar.bz2 && \
    wget https://ftp.tsukuba.wide.ad.jp/software/gcc/infrastructure/isl-0.18.tar.bz2 && \
    tar -jxvf gmp-6.1.0.tar.bz2 && ln -s gmp-6.1.0/ gmp && \
    tar -xzvf mpc-1.0.3.tar.gz && ln -s mpc-1.0.3/ mpc && \
    tar -jxvf mpfr-3.1.4.tar.bz2 && ln -s mpfr-3.1.4/ mpfr && \
    tar -jxvf isl-0.18.tar.bz2 && ln -s isl-0.18/ isl && \
    cd ../ && mkdir gcc-bulid && cd gcc-bulid/ && \
    ../gcc-8.2.0/configure CFLAGS="-g3 -gdwarf-2 -O0" CXXFLAGS="-g3 -gdwarf-2 -O0" CFLAGS_FOR_TARGET="-g3  -gdwarf-2 -O0" CXXFLAGS_FOR_TARGET="-g3 -gdwarf-2 -O0" --disable-multilib --enable-languages=c,c++ --prefix=/usr/local/gcc-8.2 && \
    make -j 4 && make install && rm gcc-8.2.0.tar.gz
    RUN rm gcc
    RUN rm g++
    RUN ln -s /usr/local/gcc-8.2/bin/gcc /usr/local/bin/gcc
    RUN ln -s /usr/local/gcc-8.2/bin/g++ /usr/local/bin/g++
    RUN ln -s /usr/local/gcc-8.2/bin/gcc /usr/bin/gcc
    RUN ln -s /usr/local/gcc-8.2/bin/g++ /usr/bin/g++
    ENV PATH=/usr/local/gcc-8.2/bin:$PATH

# for android simulator
RUN apt-get install -y --no-install-recommends \
        libc6-i386 \
        lib32stdc++6 \
        redir \
        iptables \
        openjdk-8-jre \
        openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

# for cmake 3.10
RUN curl -f -O https://mms-res.cdn.bcebos.com/cmake-3.10.3-Linux-x86_64.tar.gz && \
        tar xzf cmake-3.10.3-Linux-x86_64.tar.gz && \
        mv cmake-3.10.3-Linux-x86_64 /opt/cmake-3.10 && \
        rm -f /usr/bin/cmake && ln -s /opt/cmake-3.10/bin/cmake /usr/bin/cmake && \
        rm -f /usr/bin/ccmake && ln -s /opt/cmake-3.10/bin/ccmake /usr/bin/ccmake && rm cmake-3.10.3-Linux-x86_64.tar.gz

# for arm linux compile
RUN apt-get install -y --no-install-recommends \
        g++-arm-linux-gnueabi \
        gcc-arm-linux-gnueabi \
        g++-arm-linux-gnueabihf \
        gcc-arm-linux-gnueabihf \
        gcc-aarch64-linux-gnu \
        g++-aarch64-linux-gnu && rm -rf /var/lib/apt/lists/*;

# for android ndk17c
RUN cd /tmp && curl -f -O https://dl.google.com/android/repository/android-ndk-r17c-linux-x86_64.zip
ENV NDK_ROOT /opt/android-ndk-r17c
RUN cd /opt && unzip /tmp/android-ndk-r17c-linux-x86_64.zip


# Install arm gcc toolchains
RUN apt-get install -y --no-install-recommends \
  g++-arm-linux-gnueabi gcc-arm-linux-gnueabi \
  g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf \
  gcc-aarch64-linux-gnu g++-aarch64-linux-gnu && rm -rf /var/lib/apt/lists/*;



# Expose android port
EXPOSE 5555
EXPOSE 5557
# VNC port
EXPOSE 5900

RUN rm -rf /sdk-tools-linux-4333796.zip /tmp/android-ndk-r17c-linux-x86_64.zip /cmake-3.10.3-Linux-x86_64.tar.gz
