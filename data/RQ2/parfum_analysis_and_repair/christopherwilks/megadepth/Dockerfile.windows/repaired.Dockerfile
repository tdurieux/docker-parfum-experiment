FROM ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update -yy && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yy gcc g++ libz-dev libcurl4-openssl-dev make unzip zip zlib1g-dev clang g++-mingw-w64 g++-mingw-w64-i686 g++-mingw-w64-x86-64 gcc-mingw-w64 gcc-mingw-w64-base gcc-mingw-w64-i686 gcc-mingw-w64-x86-64 mingw-w64 mingw-w64-common mingw-w64-i686-dev mingw-w64-tools mingw-w64-x86-64-dev binutils-mingw-w64 binutils-mingw-w64-i686 binutils-mingw-w64-x86-64 \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
        cmake \
        automake \
        bison \
        curl \
        file \
        flex \
        git \
        libtool \
        pkg-config \
        texinfo \
        vim \
        wget && rm -rf /var/lib/apt/lists/*;

CMD /bin/bash
