ARG PHP_VERSION=7.2
FROM php:${PHP_VERSION}-fpm-alpine

RUN apk update \
  && apk add --no-cache \
    autoconf \
    bash \
    build-base \
    cmake \
    cmocka-dev \
    curl \
    curl-dev \
    git \
    procps \
    unzip

COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer

WORKDIR /app/src/ext

ENV REPORT_EXIT_STATUS=1
ENV TEST_PHP_DETAILED=1
ENV NO_INTERACTION=1
ENV TEST_PHP_JUNIT=/app/build/junit.xml
ENV CMOCKA_MESSAGE_OUTPUT=XML
ENV CMOCKA_XML_FILE=/app/build/alpine-${PHP_VERSION}-%g-unit-tests-junit.xml

CMD phpize \
    && CFLAGS="-std=gnu99" ./configure --enable-elastic_apm \
    && make clean \
    && make
