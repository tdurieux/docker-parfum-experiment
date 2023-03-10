FROM ubuntu:bionic

RUN apt-get update && apt-get install -y -q --no-install-recommends \
    autoconf \
    automake \
    autopoint \
    bash \
    bison \
    bzip2 \
    dpkg \
    dpkg-dev \
    flex \
    g++ \
    g++-multilib \
    gettext \
    git \
    gperf \
    fakeroot \
    intltool \
    libc6-dev-i386 \
    libgdk-pixbuf2.0-dev \
    libltdl-dev \
    libssl-dev \
    libtool \
    libxml-parser-perl \
    lua5.1 \
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
    mercurial \
    subversion \
    lzip \
    libtool-bin \
    && rm -rf /var/lib/apt/lists/*

RUN git clone  https://github.com/mxe/mxe.git

WORKDIR /mxe

# there is a recent bug, 'mesa' fails to build
RUN git checkout 3735aa8020609e680ca6867e3f4835d8a06efa9b

RUN make -j8 qt5 cmake qwt nsis

ENV PATH="${PATH}:/mxe/usr/bin/:/mxe/usr/i686-w64-mingw32.static/qt5/bin/"

WORKDIR /serialplot
ADD . /serialplot
WORKDIR ./build_docker_mxe
RUN i686-w64-mingw32.static-cmake \
    -DBUILD_QWT=false \
    -DQWT_LIBRARY=/mxe/usr/i686-w64-mingw32.static/qt5/lib/libqwt.a \
    -DQWT_INCLUDE_DIR=/mxe/usr/i686-w64-mingw32.static/qt5/include/ \
    ../
RUN make -j8 package