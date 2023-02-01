FROM alpine:3.14

ARG PHP_VERSION
ARG PECL_SWOOLE_VERSION

RUN mkdir -p /usr/src \
    && cd /usr/src \
    && wget -q https://github.com/php/php-src/archive/refs/tags/php-${PHP_VERSION}.tar.gz \
    && tar -xzf php-${PHP_VERSION}.tar.gz \
    && mv php-src-php-${PHP_VERSION} php && rm -rf /usr/src

RUN cd /usr/src/php/ext \
    && wget -q https://pecl.php.net/get/swoole-${PECL_SWOOLE_VERSION}.tgz \
    && tar -xzf swoole-${PECL_SWOOLE_VERSION}.tgz \
    && mv swoole-${PECL_SWOOLE_VERSION} swoole \
    && sed -i 's/swoole_clock_gettime(CLOCK_REALTIME/clock_gettime(CLOCK_REALTIME/g' /usr/src/php/ext/swoole/include/swoole.h && rm swoole-${PECL_SWOOLE_VERSION}.tgz

WORKDIR /usr/src/php

RUN apk add --no-cache alpine-sdk autoconf automake libc6-compat libtool \
    && apk add --no-cache bison re2c \
    && ./buildconf --force

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-all \
        --disable-cgi \
        --disable-phpdbg --disable-debug \
        --enable-swoole \
        CFLAGS="-O3 -march=native" \
        CPPFLAGS="-O3 -march=native" \
        CXXFLAGS="-O3 -march=native" \
    && sed -i 's/-export-dynamic/-all-static/g' Makefile

RUN make \
    && make install

WORKDIR "/app"

ENTRYPOINT ["/usr/local/bin/php"]

CMD ["server.php"]

EXPOSE 8080
