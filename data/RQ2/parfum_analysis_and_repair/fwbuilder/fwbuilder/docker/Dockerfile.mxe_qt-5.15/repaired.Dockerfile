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
    libssl-dev \
    lzip \
    python \
    python-mako \
    p7zip-full \
    ruby \
    unzip \
    wget && rm -rf /var/lib/apt/lists/*;
WORKDIR /opt
RUN git clone https://github.com/mxe/mxe.git
# Use Qt 5.15.1
RUN cd mxe && git checkout eb26bce6dd1b4b7a79cdbd9011251e6101bed60d -- src/qtbase.mk
RUN cd mxe && make MXE_TARGETS='i686-w64-mingw32.shared' -j$(nproc) qtbase libxml2 libxslt
RUN /opt/mxe/.ccache/bin/ccache -Cz

FROM debian:stretch
RUN apt-get update && apt-get install --no-install-recommends -y nsis make git ccache && rm -rf /var/lib/apt/lists/*;
WORKDIR /
COPY --from=builder /opt/mxe /opt/mxe
CMD ["bash"]
