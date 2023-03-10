From ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
     make \
     libssl1.1 \
     libssl-dev \
     libudev-dev \
     curl \
     libprotobuf-dev \
     libssl-dev && \
     rm -rf /var/lib/apt/lists/*

ARG DOWNLOAD_URL
ARG SGX_ENCLAVE=https://download.01.org/intel-sgx/sgx-linux/2.7.1/distro/ubuntu18.04-server/libsgx-enclave-common_2.7.101.3-bionic1_amd64.deb

RUN mkdir -p /opt/intel && \
    cd /opt/intel && \
    set -eux; \
    curl -f -L ${SGX_ENCLAVE} -o common.deb && \
    dpkg -i common.deb; rm common.deb; \
    curl -f -L ${DOWNLOAD_URL} -o /tmp/bin.tar.gz && \
    cd /tmp/ && tar -zxvf bin.tar.gz && \
    bash -c "mv /tmp/{client-cli,chain-abci,client-rpc,dev-utils} /usr/local/bin/" && \
    mkdir -p /crypto-chain/bin && \
    mv tx-query* /crypto-chain/bin/query && \
    mv tx-validation* /crypto-chain/bin/validation && rm bin.tar.gz

COPY ci-scripts/run_tx_query.sh /crypto-chain/bin/query/entrypoint.sh
COPY ci-scripts/run_tx_validation.sh /crypto-chain/bin/validation/entrypoint.sh

STOPSIGNAL SIGTERM

WORKDIR /crypto-chain

ENV RUST_LOG=info
ENV TX_ENCLAVE_STORAGE=/crypto-chain/enclave-storage

ENV SGX_MODE=${SGX_MODE}
ENV NETWORK_ID=${NETWORK_ID}

ENV APP_PORT_VALIDATION=26650
ENV APP_PORT_QUERY=26651
ENV TX_QUERY_TIMEOUT=10
ENV TX_VALIDATION_CONN=${TX_VALIDATION_CONN}
