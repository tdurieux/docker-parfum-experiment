FROM alpine@sha256:e15947432b813e8ffa90165da919953e2ce850bef511a0ad1287d7cb86de84b5 AS builder

ARG TOR_VER=0.4.6.8
ARG TORGZ=https://dist.torproject.org/tor-$TOR_VER.tar.gz

RUN apk --no-cache add --update \
  alpine-sdk gnupg libevent libevent-dev zlib zlib-dev openssl openssl-dev

RUN wget $TORGZ.asc && wget $TORGZ

# Verify tar signature and install tor
RUN gpg --batch --keyserver keys.openpgp.org --recv-keys 0x6AFEE6D49E92B601 \
  && gpg --batch --verify tor-$TOR_VER.tar.gz.asc || { echo "Couldn't verify sig"; exit 1; } && rm tor-$TOR_VER.tar.gz.asc
RUN tar xfz tor-$TOR_VER.tar.gz && cd tor-$TOR_VER \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j $(nproc --all) install && rm tor-$TOR_VER.tar.gz

FROM alpine@sha256:e15947432b813e8ffa90165da919953e2ce850bef511a0ad1287d7cb86de84b5

RUN apk --no-cache add --update \
  bash alpine-sdk gnupg libevent libevent-dev zlib zlib-dev openssl openssl-dev

RUN adduser -s /bin/bash -D -u 2000 tor
RUN mkdir -p /var/run/tor && chown -R tor:tor /var/run/tor && chmod 2700 /var/run/tor
RUN mkdir -p /home/tor/tor && chown -R tor:tor /home/tor/tor  && chmod 2700 /home/tor/tor

COPY --from=builder /usr/local/ /usr/local/

USER tor
