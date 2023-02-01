FROM alpine:3.12 as builder

RUN apk add --no-cache \
    build-base \
    autoconf \
    automake \
    cmake \
    curl \
    git \
    pkgconf \
    libtool \
    libgomp \
    boost-dev \
    openssl-dev \
    c-ares-dev \
    zlib-dev \
    readline-dev \
    lua5.3-dev \
    luarocks \
    patchelf \
    unzip \
    wget

RUN luarocks-5.3 install luasocket && \
    luarocks-5.3 install luasec && \
    luarocks-5.3 install lpeg && \
    luarocks-5.3 install dkjson

# alpine shasum is called sha1sum
RUN echo -e "#!/bin/sh\nsha1sum \"\$@\"" > /usr/bin/shasum && chmod +x /usr/bin/shasum

WORKDIR /usr/src/app
COPY . .

RUN make -j$(nproc) dep && \
    make -j$(nproc) && \
    make install && \
    make clean && \
    rm -rf *

# Fix cartesi-machine and cartesi-machine-tests
RUN \
    chmod 0755 /opt/cartesi/bin/cartesi-machine /opt/cartesi/bin/cartesi-machine-tests

FROM alpine:3.12

RUN apk add --no-cache boost libstdc++ libgomp openssl c-ares zlib readline lua5.3

ENV PATH="/opt/cartesi/bin:${PATH}"
WORKDIR /opt/cartesi
COPY --from=builder /opt/cartesi .

COPY --from=builder /usr/local/lib/lua /usr/local/lib/lua
COPY --from=builder /usr/local/share/lua /usr/local/share/lua

CMD [ "/opt/cartesi/bin/remote-cartesi-machine" ]