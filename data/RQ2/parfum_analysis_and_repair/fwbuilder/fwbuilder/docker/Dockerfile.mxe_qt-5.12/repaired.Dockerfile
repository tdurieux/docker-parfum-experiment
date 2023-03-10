FROM debian:stretch AS builder
RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    autopoint \
    binutils \
    bison \
    build-essential \
    bzip2 \
    cmake \
    fakeroot \
    flex \
    git \
    make \
    gperf \
    intltool \
    libgdk-pixbuf2.0-dev \
    libtool \
    libtool-bin \
    lzip \
    python \
    p7zip-full \
    ruby \
    unzip \
    wget && rm -rf /var/lib/apt/lists/*;
WORKDIR /opt
RUN git clone https://github.com/mxe/mxe.git
# Use Qt 5.12.4
RUN cd mxe && git checkout 0567f17d34463abda1790957812c54e8c0cf59fe -- src/qtbase.mk
RUN cd mxe && make MXE_TARGETS='i686-w64-mingw32.shared' -j$(nproc) qtbase libxml2 libxslt
RUN /opt/mxe/.ccache/bin/ccache -Cz

FROM debian:stretch
RUN apt-get update && apt-get install --no-install-recommends -y nsis make git && rm -rf /var/lib/apt/lists/*;
WORKDIR /
COPY --from=builder /opt/mxe /opt/mxe
CMD ["bash"]
