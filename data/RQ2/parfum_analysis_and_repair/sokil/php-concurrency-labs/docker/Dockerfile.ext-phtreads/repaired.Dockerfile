FROM php:7.2.6-zts-alpine3.7

# PECL extension currently not stable for PHP > 7.1

RUN apk update && \
    apk add --no-cache --virtual .build-deps \
        autoconf \
        g++ \
        make \
        git \
        openssh-client && \
    git clone https://github.com/krakjoe/pthreads.git /pthreads && \
    cd /pthreads && \
    phpize && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make install && \
    docker-php-ext-enable pthreads && \
    rm -rf /pthreads && \
    apk del .build-deps && \
    apk add --no-cache \
        bash