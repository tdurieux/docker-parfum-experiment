from fedora:latest

RUN dnf -y upgrade && \
    dnf -y install \
        @development-tools \
        hostname \
        python \
        mingw64-gcc-gfortran \
        mingw64-gcc-c++ \
        mingw64-winpthreads-static \
    && dnf clean all

# build dependencies in /usr/src

WORKDIR /usr/src

RUN mkdir -p OpenBLAS \
    && curl -SL "https://sourceforge.net/projects/openblas/files/v0.3.4/OpenBLAS%200.3.4%20version.tar.gz/download" | \
        tar -xz --strip-component=1 -C OpenBLAS \
    && make -C OpenBLAS BINARY=64 CC=x86_64-w64-mingw32-gcc FC=x86_64-w64-mingw32-gfortran HOSTCC=gcc TARGET=CORE2

# assume a CP2K source tree to be mounted at /cp2k
VOLUME ["/cp2k"]
WORKDIR /cp2k

# if not overridden, simply build CP2K
ENTRYPOINT ["make", "-j", "OPENBLAS_LIBPATH=/usr/src/OpenBLAS", "ARCH=Linux-x86-64-mingw64-minimal", "VERSION=sopt"]
