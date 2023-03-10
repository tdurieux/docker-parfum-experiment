# Dockerfile
FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        binutils-dev \
        bison \
        build-essential \
        ca-certificates \
        curl \
        debhelper \
        devscripts \
        equivs \
        expect \
        fakeroot \
        file \
        flex \
        gfortran \
        gperf \
        libdw-dev \
        libelf-dev \
        libhwloc-dev \
        libiberty-dev \
        libltdl-dev \
        liblzma-dev \
        libpapi-dev \
        libsqlite3-dev \
        libtool \
		  libunwind-dev \
        libxml2-dev \
        lsb-release \
        numactl \
        pkg-config \
        reprepro \
        sqlite3 \
        texinfo \
        wget \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget -qO- https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.bz2 \
              | tar xj -C /opt
