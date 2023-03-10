FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN set -ex \
    && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
               build-essential \
               cdbs \
               devscripts \
               equivs \
               fakeroot \
               pkg-config \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;

WORKDIR /build

# Download mingw sources
RUN apt-get source mingw-w64-common && \
    cd mingw-w64-* && \
    mk-build-deps -ir -t "apt-get -o Debug::pkgProblemResolver=yes -y --no-install-recommends"

# Patch build for UCRT and build UCRT enabled deb-packages
ADD mingw-w64-*.patch ./
RUN cd mingw-w64-* && \
    cat debian/rules && \
    ls ../mingw-w64-*.patch | xargs -n1 patch --verbose -p1 -i && \
    dpkg-buildpackage -b && \
    rm -rf ../*.ddeb ../*i686* `pwd`

# Install UCRT enabled deb-packages
RUN dpkg -i mingw-w64-common_7.0.0-2_all.deb \
    mingw-w64-tools_7.0.0-2_amd64.deb \
    mingw-w64-x86-64-dev_7.0.0-2_all.deb

# Download gcc-binutils sources for mingw
RUN apt-get source binutils-mingw-w64 && \
    cd binutils-mingw-w64-* && \
    mk-build-deps -ir -t "apt-get -o Debug::pkgProblemResolver=yes -y --no-install-recommends"

# Build gcc-binutils based on UCRT headers and crt
ADD binutils-mingw-w64-*.patch ./
RUN cd binutils-mingw-w64-* && \
    ls ../binutils-mingw-w64-*.patch | xargs -n1 patch --verbose -p1 -i && \
    dpkg-buildpackage -b --jobs=auto && \
    rm -rf ../*.ddeb ../*i686* `pwd`

# Download gcc sources for mingw
RUN apt-get source gcc-mingw-w64 && \
    cd gcc-mingw-w64-* && \
    mk-build-deps -ir -t "apt-get -o Debug::pkgProblemResolver=yes -y --no-install-recommends"

# Build gcc (only C and C++) based on UCRT headers and crt
ADD gcc-mingw-w64-*.patch ./
RUN cd gcc-mingw-w64-* && \
    ls ../gcc-mingw-w64-*.patch | xargs -n1 patch --verbose -p1 -i && \
    dpkg-buildpackage -b --jobs=auto && \
    rm -rf ../*.ddeb ../*i686* `pwd`

RUN ls -l *.deb
