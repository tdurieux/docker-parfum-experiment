# registry.gitlab.com/lsds-kungfu/image/builder:ubuntu18
FROM ubuntu:bionic AS builder

ENV DEBIAN_FRONTEND=noninteractive

ARG SOURCES_LIST=sources.list.ustc
ADD ${SOURCES_LIST} /etc/apt/sources.list

RUN apt update && \
    apt install --no-install-recommends -y curl wget git build-essential cmake python3 python3-pip libgtest-dev && \
    cd /usr/src/googletest && \
    cmake . -DCMAKE_CXX_FLAGS=-std=c++11 -Dgtest_disable_pthreads=1 && \
    make install && rm -rf /var/lib/apt/lists/*;


ARG PY_MIRROR='-i https://pypi.tuna.tsinghua.edu.cn/simple'
RUN pip3 install --no-cache-dir ${PY_MIRROR} tensorflow

RUN wget -q https://dl.google.com/go/go1.13.linux-amd64.tar.gz && \
    tar -C /usr/local -xf go1.13.linux-amd64.tar.gz && \
    rm go1.13.linux-amd64.tar.gz

ENV PATH=${PATH}:/usr/local/go/bin
