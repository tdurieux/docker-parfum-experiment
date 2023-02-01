# base image
FROM pelias/baseimage

# libpostal apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && \
    apt-get install --no-install-recommends -y autoconf automake libtool pkg-config python && \
    rm -rf /var/lib/apt/lists/*

# install libpostal
RUN git clone https://github.com/openvenues/libpostal /code/libpostal
WORKDIR /code/libpostal
RUN ./bootstrap.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --datadir=/usr/share/libpostal && \
    make && make check && make install && \
    ldconfig
