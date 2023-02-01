FROM node:8.15-slim as builder

ARG DEVELOPER
ARG STANDALONE
ENV STANDALONE=$STANDALONE

# Install build c-lightning for third-party packages (c-lightning/bitcoind)
RUN apt-get update && apt-get install -y --no-install-recommends git \
    $([ -n "$STANDALONE" ] || echo "autoconf automake build-essential libtool libgmp-dev \
                                     libsqlite3-dev python python3 wget zlib1g-dev")

ENV LIGHTNINGD_VERSION=v0.6.3
ENV LIGHTNINGD_PGP_KEY=15EE8D6CAB0E7F0CF999BFCBD9200E6CD1ADB8F1

RUN [ -n "$STANDALONE" ] || ( \
    git clone https://github.com/ElementsProject/lightning.git /opt/lightningd \
    && cd /opt/lightningd \
    && gpg --keyserver keyserver.ubuntu.com --recv-keys "$LIGHTNINGD_PGP_KEY" \
    && git verify-tag $LIGHTNINGD_VERSION \
    && git checkout $LIGHTNINGD_VERSION \
    && DEVELOPER=$DEVELOPER ./configure \
    && make)

# Install bitcoind
ENV BITCOIN_VERSION 0.17.1
ENV BITCOIN_FILENAME bitcoin-$BITCOIN_VERSION-x86_64-linux-gnu.tar.gz
ENV BITCOIN_URL https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_VERSION/$BITCOIN_FILENAME
ENV BITCOIN_SHA256 53ffca45809127c9ba33ce0080558634101ec49de5224b2998c489b6d0fc2b17
ENV BITCOIN_ASC_URL https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_VERSION/SHA256SUMS.asc
ENV BITCOIN_PGP_KEY 01EA5486DE18A882D4C2684590C8019E36C2E964
RUN [ -n "$STANDALONE" ] || \
    (mkdir /opt/bitcoin && cd /opt/bitcoin \
    && wget -qO "$BITCOIN_FILENAME" "$BITCOIN_URL" \
    && echo "$BITCOIN_SHA256 $BITCOIN_FILENAME" | sha256sum -c - \
    && gpg --keyserver keyserver.ubuntu.com --recv-keys "$BITCOIN_PGP_KEY" \
    && wget -qO bitcoin.asc "$BITCOIN_ASC_URL" \
    && gpg --verify bitcoin.asc \
    && cat bitcoin.asc | grep "$BITCOIN_FILENAME" | sha256sum -c - \
    && BD=bitcoin-$BITCOIN_VERSION/bin \
    && tar -xzvf "$BITCOIN_FILENAME" $BD/bitcoind $BD/bitcoin-cli --strip-components=1)

RUN mkdir /opt/bin && ([ -n "$STANDALONE" ] || \
    (mv /opt/lightningd/cli/lightning-cli /opt/bin/ \
    && mv /opt/lightningd/lightningd/lightning* /opt/bin/ \
    && mv /opt/bitcoin/bin/* /opt/bin/))
# npm doesn't normally like running as root, allow it since we're in docker
RUN npm config set unsafe-perm true

# Install tini
RUN wget -qO /opt/bin/tini "https://github.com/krallin/tini/releases/download/v0.18.0/tini-amd64" \
    && echo "12d20136605531b09a2c2dac02ccee85e1b874eb322ef6baf7561cd93f93c855 /opt/bin/tini" | sha256sum -c - \
    && chmod +x /opt/bin/tini

# Install Spark
WORKDIR /opt/spark/client
COPY client/package.json client/npm-shrinkwrap.json ./
COPY client/fonts ./fonts
RUN npm install

WORKDIR /opt/spark
COPY package.json npm-shrinkwrap.json ./
RUN npm install
COPY . .

# Build production NPM package
RUN npm run dist:npm \
 && npm prune --production \
 && find . -mindepth 1 -maxdepth 1 \
           ! -name '*.json' ! -name dist ! -name LICENSE ! -name node_modules ! -name scripts \
           -exec rm -r "{}" \;

# Prepare final image

FROM node:8.15-slim

ARG STANDALONE
ENV STANDALONE=$STANDALONE

WORKDIR /opt/spark

RUN apt-get update && apt-get install -y --no-install-recommends xz-utils inotify-tools netcat-openbsd \
        $([ -n "$STANDALONE" ] || echo libgmp-dev libsqlite3-dev) \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /opt/spark/dist/cli.js /usr/bin/spark-wallet \
    && mkdir /data \
    && ln -s /data/lightning $HOME/.lightning

COPY --from=builder /opt/bin /usr/bin
COPY --from=builder /opt/spark /opt/spark

ENV CONFIG=/data/spark/config TLS_PATH=/data/spark/tls TOR_PATH=/data/spark/tor COOKIE_FILE=/data/spark/cookie HOST=0.0.0.0

# link the granax (Tor Control client) node_modules installation directory
# inside /data/spark/tor/, to persist the Tor Bundle download in the user-mounted volume
RUN ln -s $TOR_PATH/tor-installation/node_modules dist/transport/granax-dep/node_modules

VOLUME /data
ENTRYPOINT [ "tini", "-g", "--", "scripts/docker-entrypoint.sh" ]

EXPOSE 9735 9737
