FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      binutils \
      clang \
      g++ \
      libc6-dev \
      libc6-dev-i386 \
      libedit2 \
      libevent-dev \
      libexpat1 \
      libffi6 \
      libgc-dev \
      libgcc-5-dev \
      libgfortran3 \
      libgmp-dev \
      libicu55 \
      libllvm6.0 \
      libmpc3 \
      libonig2 \
      libpcre3-dev \
      libstdc++-5-dev \
      llvm-8 \
      locales \
      python-dev \
      python3-dev \
      ruby-dev && \
    # for kennel deps
    apt-get install --no-install-recommends -y \
      libcurl4-openssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s libgmp.so /usr/lib/x86_64-linux-gnu/libgmp.so.3

RUN locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
