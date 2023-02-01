FROM buildpack-deps:bionic
MAINTAINER hkrn

WORKDIR /build/nanoem
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        clang-6.0 \
        cmake \
        libicu-dev \
        libgtk-3-dev \
        libglu1-mesa-dev \
        ninja-build \
        xorg-dev \
        libxi-dev \
        libxcursor-dev && rm -rf /var/lib/apt/lists/*;
