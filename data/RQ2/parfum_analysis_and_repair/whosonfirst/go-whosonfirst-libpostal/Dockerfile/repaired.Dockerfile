FROM golang:1.9

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
    make -j4 && make check && make install && \
    ldconfig

# bring in and build project go code
WORKDIR /code/go-whosonfirst-libpostal
COPY . .
RUN make bin

# set entrypoint to executable, ensuring the host is set so network requests will work
# additional parameters can be passed on the command line
ENTRYPOINT [ "./bin/wof-libpostal-server", "-host", "0.0.0.0" ]
