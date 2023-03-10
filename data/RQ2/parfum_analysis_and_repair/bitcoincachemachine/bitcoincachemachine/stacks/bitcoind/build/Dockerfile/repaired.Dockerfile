ARG BASE_IMAGE

FROM ${BASE_IMAGE}

RUN set -ex \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates dirmngr gosu gnupg2 tar wget python3-pip \
	&& rm -rf /var/lib/apt/lists/*

ENV BITCOIN_VERSION 0.19.0.1
ENV BITCOIN_URL https://bitcoincore.org/bin/bitcoin-core-0.19.0.1/bitcoin-0.19.0.1-x86_64-linux-gnu.tar.gz
ENV BITCOIN_SHA256 732cc96ae2e5e25603edf76b8c8af976fe518dd925f7e674710c6c8ee5189204
ENV BITCOIN_ASC_URL https://bitcoincore.org/bin/bitcoin-core-0.19.0.1/SHA256SUMS.asc
ENV BITCOIN_PGP_KEY 01EA5486DE18A882D4C2684590C8019E36C2E964

# install bitcoin binaries
RUN set -ex \
	&& cd /tmp \
	&& wget -qO bitcoin.tar.gz "$BITCOIN_URL" \
	&& echo "$BITCOIN_SHA256  bitcoin.tar.gz" | sha256sum -c - \
	&& gpg2 --batch --keyserver keyserver.ubuntu.com --recv-keys "$BITCOIN_PGP_KEY" \
	&& wget -qO bitcoin.asc "$BITCOIN_ASC_URL" \
	&& gpg --batch --verify bitcoin.asc \
	&& tar -xzvf bitcoin.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm -rf /tmp/* && rm bitcoin.tar.gz

# # create data directory
# ENV BITCOIN_DATA /root/.bitcoin
# RUN mkdir -p "$BITCOIN_DATA" \
# 	&& ln -sfn "$BITCOIN_DATA" /root/.bitcoin

VOLUME /root/.bitcoin

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

# COPY rpcauth.py /rpcauth.py
# RUN chmod 0755 /rpcauth.py

WORKDIR /root/.bitcoin

# mainnet testnet regtest
# ZMQ blocks (3), ZMQ tx (3), RPC (3), P2P (3)
EXPOSE 9332 19332 29332 9331 19331 29331 8332 18332 28332 8333 18333 29333

#CMD ["bitcoind"]
ENTRYPOINT ["/entrypoint.sh"]
