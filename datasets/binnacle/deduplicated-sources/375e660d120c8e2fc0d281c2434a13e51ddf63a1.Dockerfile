FROM cusdeb/alpine3.7:amd64
MAINTAINER Evgeny Golyshev <eugulixes@gmail.com>

ENV REDIS_VERSION 5.0-rc3

ENV REDIS_DOWNLOAD_URL https://github.com/antirez/redis/archive/$REDIS_VERSION.tar.gz

ENV REDIS_DOWNLOAD_SHA 4bb2eeef3695d66d8b64767825acfeeb157d64536233eac7eae71b236fd6554f

RUN apk add --update \
    bash \
    build-base \
    coreutils \
    curl \
    linux-headers \
 && curl -OL $REDIS_DOWNLOAD_URL \
 && echo $REDIS_DOWNLOAD_SHA $REDIS_VERSION.tar.gz | sha256sum -c \
 && tar xzvf $REDIS_VERSION.tar.gz \
 && cd redis-$REDIS_VERSION \
 # Install only the server. Such client-side tools as redis-benchmark,
 # redis-check-aof, redis-check-rdb and redis-cli are not needed in the
 # container. They can be obtained by installing the redis-tools package
 # on Debian/Ubuntu.
 && make && install -o root -g root -m 744 src/redis-server /usr/bin \
 && cd .. \
 # Cleanup
 && rm    $REDIS_VERSION.tar.gz \
 && rm -r redis-$REDIS_VERSION \ 
 && apk del \
    build-base \
    coreutils \
    curl \
    linux-headers \
 && rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

