FROM debian:10.9-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip wget python python3 bzip2 pkg-config xz-utils tar \
    binutils-powerpc64le-linux-gnu gcc-powerpc64le-linux-gnu \
&&	apt clean \
&&	rm -rf /var/lib/apt/lists/*

RUN cat /etc/apt/sources.list | grep -v "^#"  | sed "s/^deb /deb [arch=amd64] /g" > /tmp/amd64.list && \
    cat /tmp/amd64.list | sed "s/\[arch=amd64\]/[arch=ppc64el]/g" > /tmp/ppc64el.list && \
    cat /tmp/amd64.list /tmp/ppc64el.list > /etc/apt/sources.list && \
    dpkg --add-architecture ppc64el
RUN cat /etc/apt/sources.list

RUN	apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    python \
    flex bison \
    libfreetype6-dev \
    libltdl-dev \
    libxcb1-dev \
    libx11-dev \
    librsvg2-bin \
    gcc-mingw-w64-x86-64 gcc-mingw-w64-i686 \
    automake autoconf pkg-config libtool \
    automake1.11 autoconf2.13 autoconf2.64 \
    gtk-doc-tools git gperf groff p7zip-full \
    gettext \
    make \
    clang \
    dpkg-dev \
    libglib2.0-dev:ppc64el \
    libfreetype6-dev:ppc64el \
    libltdl-dev:ppc64el \
    libxcb1-dev:ppc64el \
    libx11-dev:ppc64el \
&&	apt clean \
&&	rm -rf /var/lib/apt/lists/* \
&&	ln -s /usr/bin/autoconf /usr/bin/autoconf-2.69 \
&&	ln -s /usr/bin/autoheader /usr/bin/autoheader-2.69

ENV NOTESTS 1
ENV PKG_CONFIG powerpc64le-linux-gnu-pkg-config
ENV CROSS_TRIPLE powerpc64le-linux-gnu
ENV HANGOVER_WINE_CC powerpc64le-linux-gnu-gcc
ENV HANGOVER_WINE_CXX powerpc64le-linux-gnu-g++

RUN mkdir -p /root/hangover
COPY . /root/hangover/
RUN make -j `nproc` -C /root/hangover -f Makefile