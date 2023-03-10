FROM alpine:latest

RUN apk update && \
    apk add --no-cache alpine-sdk \
            bash \
            bzip2 \
            coreutils \
            curl \
            file \
            findutils \
            gawk \
            gnupg \
            grep \
            linux-headers \
            ncurses-dev \
            outils-signify \
            perl \
            python2 \
            python3 \
            rsync \
            rsync \
            unzip \
            wget \
            xz \
            zlib-dev

RUN adduser -h /home/build -s /bin/bash build -D
COPY --chown=build:build ./meta /home/build/openwrt/
RUN chown build:build /home/build/openwrt/

USER build
ENV HOME /home/build
WORKDIR /home/build/openwrt/
