FROM alpine:3.6

RUN \
        set -ex \
    && \
        apk add --no-cache --virtual .build-deps \
            bash \
            cmake \
            build-base \
            gcc \
            abuild \
            binutils \
            make \
            libc-dev \
            linux-headers \
            libressl-dev \
            curl-dev
