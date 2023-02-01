FROM alpine:3.14.3
LABEL org.opencontainers.image.authors="Vincenzo Palazzo (@vincenzopalazzo) vincenzopalazzodev@gmail.com"

WORKDIR /build

RUN apk update && \
    apk add --no-cache ca-certificates alpine-sdk autoconf automake git libtool \
    gmp-dev sqlite-dev python3 py3-mako net-tools zlib-dev libsodium gettext su-exec \
    python3 py3-pip \


RUN mkdir lightning
COPY . lightning

RUN cd lightning && \
    git submodule update --init --recursive && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    pip3 install --no-cache-dir mrkd mistune==0.8.4 && \
    make -j$(nproc) && \
    make install

# TODO: review entry point here, to make this availale for the user
CMD ["lightningd", "--version"]
