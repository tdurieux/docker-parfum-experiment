FROM    debian:buster


#################################################################
# INSTALL BITCOIN
#################################################################
ENV     BITCOIN_HOME        /home/bitcoin
ENV     BITCOIN_VERSION     0.20.0
ENV     BITCOIN_URL         https://bitcoincore.org/bin/bitcoin-core-0.20.0/bitcoin-0.20.0-x86_64-linux-gnu.tar.gz
ENV     BITCOIN_SHA256      35ec10f87b6bc1e44fd9cd1157e5dfa483eaf14d7d9a9c274774539e7824c427
ENV     BITCOIN_ASC_URL     https://bitcoincore.org/bin/bitcoin-core-0.20.0/SHA256SUMS.asc
ENV     BITCOIN_PGP_KS_URI  hkp://keyserver.ubuntu.com:80
ENV     BITCOIN_PGP_KEY     01EA5486DE18A882D4C2684590C8019E36C2E964

RUN     set -ex && \
        apt-get update && \
        apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg gpg-agent wget && \
        rm -rf /var/lib/apt/lists/*

# Build and install bitcoin binaries
RUN     set -ex && \
        cd /tmp && \
        wget -qO bitcoin.tar.gz "$BITCOIN_URL" && \
        echo "$BITCOIN_SHA256 bitcoin.tar.gz" | sha256sum -c - && \
        gpg --batch --keyserver "$BITCOIN_PGP_KS_URI" --recv-keys "$BITCOIN_PGP_KEY" && \
        wget -qO bitcoin.asc "$BITCOIN_ASC_URL" && \
        gpg --batch --verify bitcoin.asc && \
        tar -xzvf bitcoin.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt && \
        rm -rf /tmp/*

# Create groups bitcoin & tor
# Create user bitcoin and add it to groups
RUN     addgroup --system -gid 1108 bitcoin && \
        addgroup --system -gid 1107 tor && \
        adduser --system --ingroup bitcoin -uid 1105 bitcoin && \
        usermod -a -G tor bitcoin

# Create data directory
RUN     mkdir "$BITCOIN_HOME/.bitcoin" && \
        chown -h bitcoin:bitcoin "$BITCOIN_HOME/.bitcoin"

# Copy restart script
COPY    ./restart.sh /restart.sh
RUN     chown bitcoin:bitcoin /restart.sh && \
        chmod 777 /restart.sh

# Copy wait-for-it script
COPY    ./wait-for-it.sh /wait-for-it.sh

RUN     chown bitcoin:bitcoin /wait-for-it.sh && \
        chmod u+x /wait-for-it.sh && \
        chmod g+x /wait-for-it.sh

EXPOSE  8333 9501 9502 28256

USER    bitcoin