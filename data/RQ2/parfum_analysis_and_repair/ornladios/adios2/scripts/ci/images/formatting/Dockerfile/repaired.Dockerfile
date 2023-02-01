FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-utils && \
    apt-get install --no-install-recommends -y curl git flake8 libtinfo5 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://github.com/llvm/llvm-project/releases/download/llvmorg-7.1.0/clang+llvm-7.1.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz | tar -C /opt -xJv && \
    mv /opt/clang* /opt/llvm-7.1.0
ENV PATH=/opt/llvm-7.1.0/bin:$PATH
