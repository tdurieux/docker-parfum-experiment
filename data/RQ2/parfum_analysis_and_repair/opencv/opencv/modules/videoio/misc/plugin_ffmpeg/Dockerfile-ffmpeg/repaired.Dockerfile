FROM ubuntu:18.04

RUN apt-get update && apt-get --no-install-recommends install -y \
        pkg-config \
        cmake \
        g++ \
        ninja-build \
        make \
        nasm \
    && \
    rm -rf /var/lib/apt/lists/*

ARG VER

ADD ffmpeg-${VER}.tar.xz /ffmpeg/

WORKDIR /ffmpeg/ffmpeg-${VER}
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --enable-avresample \
    --prefix=/ffmpeg-shared \
    --enable-shared \
    --disable-static \
    --disable-programs \
    --disable-doc \
    --disable-avdevice \
    --disable-postproc \
    && make -j8 install \
    && make clean \
    && make distclean

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --enable-avresample \
    --prefix=/ffmpeg-static \
    --disable-shared \
    --enable-static \
    --enable-pic \
    --disable-programs \
    --disable-doc \
    --disable-avdevice \
    --disable-postproc \
    && make -j8 install \
    && make clean \
    && make distclean

WORKDIR /tmp
