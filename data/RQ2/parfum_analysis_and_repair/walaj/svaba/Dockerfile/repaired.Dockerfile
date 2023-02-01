FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y git g++ zlib1g-dev cmake libbz2-dev liblzma-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone --recursive https://github.com/walaj/svaba
RUN cd svaba && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j$(nproc) && make -j$(nproc) install
RUN PATH=$PATH:/svaba/bin
