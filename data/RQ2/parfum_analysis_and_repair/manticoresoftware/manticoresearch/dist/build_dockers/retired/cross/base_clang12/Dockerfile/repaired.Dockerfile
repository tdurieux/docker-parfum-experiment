FROM ubuntu:focal
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    ninja-build \
    zstd \
    git \
    bison \
    flex \
&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    software-properties-common \
&& wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-12 main" \
&& apt-get update && apt-get install --no-install-recommends -y \
    clang-12 \
    lld-12 \
&& rm -rf /var/lib/apt/lists/*

CMD []

# docker build -t base_clang:12 -t registry.gitlab.com/manticoresearch/dev/base_clang:12 .
