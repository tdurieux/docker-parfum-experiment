ARG  from
FROM ${from}
ARG  target

RUN apt-get update && apt-get install -y -q --no-install-recommends \
    autoconf \
    automake \
    autopoint \
    bash \
    bison \
    bzip2 \
    flex \
    g++ \
    g++-multilib \
    gettext \
    git \
    gperf \
    intltool \
    libc6-dev-i386 \
    libgdk-pixbuf2.0-dev \
    libltdl-dev \
    libssl-dev \
    libtool-bin \
    libxml-parser-perl \
    lzip \
    make \
    openssl \
    p7zip-full \
    patch \
    perl \
    pkg-config \
    python \
    ruby \
    scons \
    sed \
    unzip \
    wget \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/mxe/mxe.git /opt/mxe \
    && cd /opt/mxe \
    && git checkout ee88607e \
    && make MXE_TARGETS=$target \
        cc zlib openssl libpng jpeg
# ===== ee88607e =====
# zlib      1.2.11
# openssl   1.1.1g
# libpng    1.6.37
# jpeg      9d
# ====================

ENV PATH="${PATH}:/opt/mxe/usr/bin" CFLAGS=-w CXXFLAGS=-w