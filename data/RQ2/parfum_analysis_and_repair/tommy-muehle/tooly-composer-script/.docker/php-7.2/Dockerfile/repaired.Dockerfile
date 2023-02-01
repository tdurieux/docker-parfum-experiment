FROM php:7.2-alpine
RUN apk --update --no-cache add libbz2 bzip2-dev && \
    apk del build-base && \
    rm -rf /var/cache/apk/*
RUN docker-php-ext-install bz2
VOLUME ["/app"]
WORKDIR /app
