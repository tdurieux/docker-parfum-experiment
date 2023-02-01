# -*- mode: dockerfile -*-
#
# An example Dockerfile showing how to add new static C libraries using
# musl-gcc.

FROM ekidd/rust-musl-builder

# Build a static copy of zlib.
#
# EXAMPLE ONLY! libz is already included.
RUN VERS=1.2.11 && \
    cd /home/rust/libs && \
    curl -f -LO http://zlib.net/zlib-$VERS.tar.gz && \
    tar xzf zlib-$VERS.tar.gz && cd zlib-$VERS && \
    CC=musl-gcc ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --static --prefix=/usr/local/musl && \
    make && sudo make install && \
    cd .. && rm -rf zlib-$VERS.tar.gz zlib-$VERS
