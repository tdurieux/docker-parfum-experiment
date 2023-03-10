FROM ubuntu:18.04 as builder

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN  apt-get clean
RUN apt-get update && apt-get install --no-install-recommends -y wget gzip build-essential \
     net-tools inetutils-traceroute iputils-ping && rm -rf /var/lib/apt/lists/*;

WORKDIR /ssh_build

ENV DIST_DIR=/ssh_build/dist ROOT=/ssh_build/root BUILD_DIR=/ssh_build/build

# make it cache friendly
COPY download.sh  /ssh_build
RUN sh download.sh
COPY build_zlib.sh /ssh_build
RUN sh build_zlib.sh
COPY build_openssl.sh /ssh_build
RUN sh build_openssl.sh
COPY build_ssh.sh /ssh_build/
RUN sh build_ssh.sh

# compile gpu_topo
WORKDIR /gpu_topo_build
COPY gpu_topo.cpp /gpu_topo_build
RUN g++ -o gpu_topo gpu_topo.cpp

FROM python:3.8.0-alpine3.10

WORKDIR /dlts-init
COPY requirements.txt /dlts-init

RUN pip3 install --no-cache-dir -r /dlts-init/requirements.txt

COPY --from=builder /ssh_build/root /dlts-init/ssh_build
COPY --from=builder /gpu_topo_build/gpu_topo /dlts-init/gpu_topo

COPY install.sh init.sh /dlts-init/
COPY ssh_config /dlts-init/ssh_config
COPY runtime /dlts-init/runtime
