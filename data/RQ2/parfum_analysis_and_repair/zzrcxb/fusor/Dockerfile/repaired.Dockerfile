FROM debian:9.4
MAINTAINER Neil Zhao, i@zzrcxb.me

WORKDIR /root/

RUN apt update && \
    apt install --no-install-recommends -y build-essential cmake llvm vim git clang python python3-pip && \
    git clone https://github.com/zzrcxb/fusor.git && \
    pip3 install --no-cache-dir angr termcolor && rm -rf /var/lib/apt/lists/*;

RUN cd fusor && mkdir build && cd build && cmake .. && make

RUN export FUSOR_CONFIG=/root/fusor/config.json
