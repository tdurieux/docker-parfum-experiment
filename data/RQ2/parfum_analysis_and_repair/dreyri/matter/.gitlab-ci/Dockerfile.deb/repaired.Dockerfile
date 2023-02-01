FROM debian:buster

MAINTAINER Frederik Engels, frederik.engels92@gmail.com

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    clang \
    pkg-config \
    ca-certificates \
    gcovr \
    cmake \
    meson \
    ninja-build \
    libbenchmark-dev && rm -rf /var/lib/apt/lists/*;