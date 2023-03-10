FROM ubuntu:bionic
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        libssl-dev; \
    rm -rf /var/lib/apt/lists/*

ENV RELEASE_PATH="./"
COPY $RELEASE_PATH/starcoin \
     $RELEASE_PATH/starcoin_miner \
     $RELEASE_PATH/starcoin_txfactory \
     $RELEASE_PATH/starcoin_faucet \
     $RELEASE_PATH/starcoin_generator \
     $RELEASE_PATH/starcoin_indexer \
     $RELEASE_PATH/starcoin_db_exporter \
     /starcoin/
     
CMD ["/starcoin/starcoin"]