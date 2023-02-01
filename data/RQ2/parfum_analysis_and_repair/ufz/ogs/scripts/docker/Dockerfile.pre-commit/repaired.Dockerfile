FROM ubuntu:21.04

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get install -y --no-install-recommends git gcc g++ python3-pip wget xz-utils \
    && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir pre-commit==2.13.0

ARG clang_version=12.0.1
RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-${clang_version}/clang+llvm-${clang_version}-x86_64-linux-gnu-ubuntu-16.04.tar.xz \
    && tar xf clang+llvm-${clang_version}-x86_64-linux-gnu-ubuntu-16.04.tar.xz \
    && rm clang+llvm-${clang_version}-x86_64-linux-gnu-ubuntu-16.04.tar.xz
ENV PATH="/clang+llvm-${clang_version}-x86_64-linux-gnu-ubuntu-/bin:${PATH}"

RUN ln -s /usr/bin/python3 /usr/bin/python
