# Stage 1: dev/build
FROM vernacularai/kaldi-serve:latest as builder

# gRPC Pre-requisites - https://github.com/grpc/grpc/blob/master/BUILDING.md
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
    build-essential \
    autoconf \
    libtool \
    pkg-config \
    libgflags-dev \
    libgtest-dev \
    clang \
    libc++-dev \
    libboost-all-dev \
    curl \
    vim && rm -rf /var/lib/apt/lists/*;

# Install gRPC
RUN cd /root/ && \
    git clone -b v1.28.1 https://github.com/grpc/grpc && \
    cd /root/grpc/ && \
    git submodule update --init && \
    make -j$(nproc) && \
    make install

# Install Protobuf v3
RUN cd /root/grpc/third_party/protobuf && make install

WORKDIR /root/kaldi-serve
COPY . .

WORKDIR /root/kaldi-serve/plugins/grpc
ENV LD_LIBRARY_PATH="/opt/kaldi/tools/openfst/lib:/opt/kaldi/src/lib"
RUN rm -f  ./protos/*.pb.* ./protos/*.o&& \
    make KALDI_ROOT="/opt/kaldi" KALDISERVE_INCLUDE="/usr/include" -j$(nproc)

RUN bash -c "mkdir /so-files/; cp /opt/intel/mkl/lib/intel64/lib*.so /so-files/"

# Stage 2: registrar

FROM golang:1.12.5 as builder2

RUN mkdir -p $GOPATH/src/kaldi_serve/

WORKDIR $GOPATH/src/kaldi_serve/
COPY . .

ENV GO111MODULE on

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o build/register plugins/grpc/registrar/main.go

# Stage 3: prod
FROM debian:jessie-slim

COPY --from=builder /root/kaldi-serve/plugins/grpc/build/kaldi_serve_app /bin/
COPY --from=builder2 /go/src/kaldi_serve/build/register /bin/

# LIBS
COPY --from=builder /usr/lib/x86_64-linux-gnu/libssl.so* /usr/local/lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libcrypto.so* /usr/local/lib/

# CPP LIBS
COPY --from=builder /usr/lib/x86_64-linux-gnu/libstdc++.so* /usr/local/lib/

# BOOST LIBS
COPY --from=builder /usr/lib/x86_64-linux-gnu/libboost_system.so* /usr/local/lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libboost_filesystem.so* /usr/local/lib/

# GRPC LIBS
COPY --from=builder /usr/local/lib/libgrpc++.so* /usr/local/lib/
COPY --from=builder /usr/local/lib/libgrpc++_reflection.so* /usr/local/lib/
COPY --from=builder /usr/local/lib/libgrpc.so* /usr/local/lib/
COPY --from=builder /usr/local/lib/libgpr.so* /usr/local/lib/
COPY --from=builder /usr/local/lib/libupb.so* /usr/local/lib/

# INTEL MKL
COPY --from=builder /so-files /opt/intel/mkl/lib/intel64

# KALDI LIBS
COPY --from=builder /opt/kaldi/tools/openfst/lib/libfst.so.10 /opt/kaldi/tools/openfst/lib/
COPY --from=builder /opt/kaldi/src/lib/libkaldi-*.so /opt/kaldi/src/lib/

# KALDISERVE LIB
COPY --from=builder /usr/local/lib/libkaldiserve.so* /usr/local/lib/

ENV LD_LIBRARY_PATH="/usr/local/lib:/opt/kaldi/tools/openfst/lib:/opt/kaldi/src/lib"

ADD plugins/grpc/build/config/supervisord /etc/

ENV CONSUL_VERSION=1.9.1 \
    CONSUL_DOMAIN=consul \
    CONSUL_DATA_DIR=/data/consul \
    CONSUL_CONFIG_DIR=/etc/consul/conf.d/bootstrap \
    CONSUL_SERVER_NAME=consul \
    CONSUL_DC=dc1 \
    CONSUL_CLIENT=0.0.0.0 \
    CONSUL_RETRY_INTERVAL=5s

# Download and install Consul
RUN apt-get update && \
    apt-get install --no-install-recommends curl util-linux unzip supervisor -y && \
    mkdir -p /var/log/supervisor/ && \
    mkdir -p /etc/supervisor/ && \
    curl -f -sSLo /tmp/consul.zip https://releases.hashicorp.com/consul/{$CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip && \
    unzip -d /bin /tmp/consul.zip && \
    rm /tmp/consul.zip && \
    apt-get autoremove --purge curl unzip -y && \
    groupadd --system consul && \
    useradd -s /sbin/nologin --system -g consul consul && \
    mkdir -p /data/consul && \
    chown -R consul:consul /data/consul && \
    rm -rf /tmp/* /var/cache/apt/lists/* && \
    mkdir /etc/consul.d/

# Add the files
COPY plugins/grpc/build/config/consul /

# Supervisor files
COPY plugins/grpc/build/config/supervisord/grpc_server.conf /etc/supervisor/conf.d/grpc_server.conf
COPY plugins/grpc/build/config/supervisord/consul.conf /etc/supervisor/conf.d/consul.conf
COPY plugins/grpc/build/config/supervisord/register.conf /etc/supervisor/conf.d/register.conf
COPY plugins/grpc/build/config/supervisord/supervisord.conf /etc/supervisor/supervisord.conf

VOLUME ["/data/consul"]

# Same exposed ports than consul
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600 8600/udp 53 53/udp

ENTRYPOINT ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
# Command to run: docker run -p 8500:8500 -e CONSUL_SERVER=127.0.0.1 -d -t base_img_test
