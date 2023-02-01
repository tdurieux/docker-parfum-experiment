ARG MANYLINUX_ARCH
# self pathed cpython https://github.com/MarshalX/manylinux-cpython-pathes
FROM quay.io/pypa_patched/manylinux_2_24_$MANYLINUX_ARCH AS builder

RUN apt-get update && apt-get install --no-install-recommends -y xz-utils libxml2 wget build-essential && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt
RUN wget https://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-7.5.0/gcc-7.5.0.tar.gz && \
    tar zxf gcc-7.5.0.tar.gz && \
    cd gcc-7.5.0 && \
    ./contrib/download_prerequisites && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-multilib && \
    make -j $(nproc) && \
    make install && \
    cd .. && \
    rm -rf gcc-7.5.0 && \
    rm gcc-7.5.0.tar.gz
