FROM "ubuntu:14.04"

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && apt-get install -y --no-install-recommends \
    adduser \
    ca-certificates \
    libevent-1.4-2 \
    libevent-2.0-5 \
    libevent-extra-2.0-5 \
    libevent-core-2.0-5 \
    libevent-openssl-2.0-5 \
    libevent-pthreads-2.0-5 \
    libidn11 \
    libssl1.0.0 \
    lsb-base \
    lua-bitop \
    lua-event \
    lua-expat \
    lua-filesystem \
    lua-sec \
    lua-socket \
    lua-zlib \
    lua5.1 \
    luajit \
    openssl \
    prosody \
    ssl-cert \
  && chown prosody /var/lib/prosody && rm -rf /var/lib/apt/lists/*;

COPY ./prosody-modules/* /usr/lib/prosody/modules/

VOLUME ["/home/point/ssl", "/var/lib/prosody"]

WORKDIR /var/lib/prosody

EXPOSE 80 443 5222 5269 5347 5280 5281
ENV __FLUSH_LOG yes

COPY ./prosody.sh /prosody.sh
RUN chmod 755 /prosody.sh

CMD ["/prosody.sh"]

