# build stage
FROM alpine:3.7 AS packager

RUN \
    apk add --no-cache cmake autoconf make musl-dev gcc g++ openssl openssl-dev git cunit cunit-dev automake libtool util-linux-dev && \
    mkdir -p /build

RUN cd /build && \
    git clone https://github.com/Comcast/parodus2mockTr181.git && \
    cd parodus2mockTr181 && \
    mkdir build && \
    cd build && \
    cmake .. && make && \
    cd /build && \
    git clone https://github.com/Comcast/parodus.git && \
    cd parodus && \
    git checkout ad2d43b4f6e980a6cc1c1340fc82564104eb1dd8 && \
    mkdir build && \
    cd build && \
    cmake .. && make && \
    cd /build && \
    git clone https://github.com/Comcast/aker.git && \
    cd aker && \
    git checkout cfb54022fa6e0ba70040e419d34655da955637b5 && \
    mkdir build && \
    cd build && \
    cmake .. && make

# build image