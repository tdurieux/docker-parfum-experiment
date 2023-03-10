# Use: docker build . -t darkfi:alpine${alpine_ver}_rust${rust_ver} -f ./contrib/docker/Dockerfile.alpine
#   optionally with: --build-arg ALPINE_VER=$alpine_ver --build-arg RUST_VER=$rust_ver
# The wallet test fail problem (see below) was the same for alpine {3.14,3.15,3.16} and rust {1.60,1.61,1.62}

ARG RUST_VER=1.62
ARG ALPINE_VER=3.16

FROM rust:${RUST_VER}-alpine${ALPINE_VER}

ARG RUST_VER
ARG ALPINE_VER

RUN echo "=======================================================" \
    &&echo "===>>>>> The following error will occur during the test::" \
    && echo "process didn't exit successfully: /opt/darkfi/target/release/deps/darkfi-7ff55152bc1bdc59 (signal: 11, SIGSEGV: invalid memory reference)" \
    && echo "rust ${RUST_VER} / alpine ${ALPINE_VER}" \
    && rustc -V && cargo -V \
    && cat /etc/os-release  \
    && echo "====>>>>> wait 30 sec to continue; CTRL+C to break" \
    && sleep 30

RUN apk update

RUN apk add --no-cache cmake jq wget clang curl gcc make
RUN apk add --no-cache llvm-dev openssl-dev expat-dev freetype-dev
RUN apk add --no-cache libudev-zero-dev libgudev-dev
RUN apk add --no-cache pkgconf clang-dev

RUN apk add --no-cache build-base

# musl-dev was enough, maybe libc-dev too

RUN mkdir /opt/darkfi

COPY . /opt/darkfi

WORKDIR /opt/darkfi

RUN make clean

RUN rm -rf ./target/*

RUN make -j test

