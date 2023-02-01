ARG BASE_IMAGE=debian:buster

# image0
FROM ${BASE_IMAGE}
WORKDIR /build/handlebars.c

RUN apt-get update && apt-get install --no-install-recommends -y \
        autoconf \
        automake \
        gcc \
        git \
        libjson-c-dev \
        libtalloc-dev \
        libyaml-dev \
        libtool \
        m4 \
        make \
        pkg-config && rm -rf /var/lib/apt/lists/*;
ADD . .
RUN autoreconf -fiv
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --prefix /usr/local/ \
        --enable-lto \
        --enable-static \
        --enable-hardening \
        --disable-shared \
        --disable-debug \
        --disable-code-coverage \
        --disable-lmdb \
        --disable-pthread \
        --disable-valgrind \
        --disable-testing-exports \
        RANLIB=gcc-ranlib \
        AR=gcc-ar \
        NM=gcc-nm \
        LD=gcc \
        CFLAGS="-O3"
RUN make
RUN make check
RUN make install

# image1
FROM ${BASE_IMAGE}
WORKDIR /srv/
RUN apt-get update && apt-get install --no-install-recommends -y \
        libjson-c-dev \
        libtalloc-dev \
        libyaml-dev && rm -rf /var/lib/apt/lists/*;
COPY --from=0 /usr/local/bin/handlebarsc /usr/local/bin/handlebarsc
ENTRYPOINT ["/usr/local/bin/handlebarsc"]
