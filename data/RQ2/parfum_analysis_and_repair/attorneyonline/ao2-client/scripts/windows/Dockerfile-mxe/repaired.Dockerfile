FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
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
    sed \
    unzip \
    wget \
    xz-utils && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/mxe/mxe.git
RUN mv mxe /opt/mxe
WORKDIR /opt/mxe
RUN make -j4 MXE_TARGETS="i686-w64-mingw32.static.posix" qtbase qtmultimedia libarchive
ENV PATH=/opt/mxe/usr/bin:$PATH

WORKDIR /
