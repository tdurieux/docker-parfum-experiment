ARG PHP_VERSION=7.4
ARG BASE_IMAGE=php:$PHP_VERSION

# image0
FROM ${BASE_IMAGE}
ARG PHP_VERSION
ARG HANDLEBARSC_VERSION=master
WORKDIR /build

# handlebars.c
RUN apt-get update && apt-get install --no-install-recommends -y \
        autoconf \
        automake \
        gcc \
        git \
        libjson-c-dev \
        liblmdb-dev \
        libtalloc-dev \
        libyaml-dev \
        libtool \
        m4 \
        make \
        pkg-config && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/jbboehr/handlebars.c.git
WORKDIR /build/handlebars.c
RUN git checkout $HANDLEBARSC_VERSION
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
        --enable-pthread \
        --disable-valgrind \
        --disable-testing-exports \
        --enable-compile-warnings=yes \
        --disable-Werror \
        RANLIB=gcc-ranlib \
        AR=gcc-ar \
        NM=gcc-nm \
        LD=gcc \
        CFLAGS="-O3"
RUN make
RUN make install

# php-handlebars
WORKDIR /build/php-handlebars
ADD . .
RUN phpize
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-handlebars-ast \
        CFLAGS="-O3"
RUN make
RUN make install

# image1
FROM ${BASE_IMAGE}
RUN apt-get update && apt-get install --no-install-recommends -y \
        libjson-c-dev \
        liblmdb-dev \
        libtalloc-dev \
        libyaml-dev && rm -rf /var/lib/apt/lists/*;
COPY --from=0 /usr/local/lib/php/extensions /usr/local/lib/php/extensions
RUN docker-php-ext-enable handlebars
ENTRYPOINT ["docker-php-entrypoint"]
