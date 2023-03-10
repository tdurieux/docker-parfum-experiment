FROM golang:1.13.15-alpine3.12 as builder-torgen

RUN apk add --no-cache git build-base

RUN mkdir -p /go/src/torgen

COPY torgen/torgen.go /go/src/torgen

WORKDIR /go/src/torgen

RUN go get

RUN go build torgen.go
RUN chmod +x /go/src/torgen/torgen

FROM alpine:3.12.4 as builder-qrencode

RUN apk add --update --no-cache \
    autoconf \
    automake \
    build-base \
    libtool \
    git \
    pkgconfig

RUN git clone -b v4.1.0 https://github.com/fukuchi/libqrencode.git \
 && cd libqrencode \
 && ./autogen.sh \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
 && make \
 && make install

FROM node:15.11.0-alpine3.12

ENV EDITOR=/usr/bin/nano

COPY . /app
COPY --from=builder-torgen /go/src/torgen/torgen /app/torgen
COPY --from=builder-qrencode /usr/local/bin/qrencode /usr/local/bin/
COPY --from=builder-qrencode /usr/local/lib/libqrencode.so.4.1.0 /usr/local/lib/libqrencode.so.4

WORKDIR /app

RUN mkdir /data && \
  apk add --update su-exec p7zip openssl nano apache2-utils git && \
  rm -rf /var/cache/apk/* && \
  npm ci --production

WORKDIR /app

ENTRYPOINT ["/sbin/su-exec"]

