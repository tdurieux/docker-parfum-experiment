FROM simplepieng/base:7.2

RUN apk add --no-cache make
COPY build/tests/php.ini /usr/local/etc/php/php.ini

WORKDIR /workspace
ENTRYPOINT ["make", "test"]
