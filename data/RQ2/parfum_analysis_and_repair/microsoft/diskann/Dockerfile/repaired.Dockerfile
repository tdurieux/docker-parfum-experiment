FROM ubuntu:16.04
MAINTAINER Changxu Wang <wang_changxu@zju.edu.cn>

RUN apt-get update -y && apt-get install --no-install-recommends -y g++ cmake libboost-dev libgoogle-perftools-dev && rm -rf /var/lib/apt/lists/*;

COPY . /opt/nsg

WORKDIR /opt/nsg

RUN mkdir -p build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j $(nproc)
