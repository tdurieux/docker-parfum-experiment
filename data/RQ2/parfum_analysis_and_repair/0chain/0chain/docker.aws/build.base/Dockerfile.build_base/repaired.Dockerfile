# docker.aws
FROM golang:1.18-alpine3.15
RUN apk add --no-cache bash build-base grep git

# Install RocksDB
RUN apk add --no-cache coreutils linux-headers perl zlib-dev bzip2-dev lz4-dev snappy-dev zstd-libs zstd-dev && \
    cd /tmp && \
    wget -O - https://github.com/facebook/rocksdb/archive/v6.20.3.tar.gz | tar xz && \
    cd /tmp/rocksdb* && \
    make -j $(nproc) install-shared OPT=-g0 USE_RTTI=1 && \
    rm -R /tmp/rocksdb* && \
    apk del coreutils linux-headers perl

# Install Herumi's cryptography
RUN apk add --no-cache gmp gmp-dev openssl-dev && \
    cd /tmp && \
    wget -O - https://github.com/herumi/mcl/archive/master.tar.gz | tar xz && \
    wget -O - https://github.com/herumi/bls/archive/master.tar.gz | tar xz && \
    mv mcl* mcl && \
    mv bls* bls && \
    make -C mcl -j $(nproc) lib/libmclbn256.so install && \
    cp mcl/lib/libmclbn256.so /usr/local/lib && \
    make MCL_DIR=../mcl -C bls -j $(nproc) install && \
    rm -R /tmp/mcl && \
    rm -R /tmp/bls
