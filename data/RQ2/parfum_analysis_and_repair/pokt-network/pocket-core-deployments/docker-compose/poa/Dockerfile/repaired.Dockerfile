# REF https://github.com/poanetwork/wiki/wiki/POA-Installation
FROM parity/parity:stable
LABEL maintainer="lowell@pokt.network"
USER root
RUN apt-get update && \
    apt-get install --no-install-recommends git ca-certificates -y && \
    apt-get clean && \
    mkdir /home/parity/.local/share/io.parity.ethereum/ && \
    chown parity -R /home/parity/.local/share/io.parity.ethereum/ && rm -rf /var/lib/apt/lists/*;

USER parity

ARG chain

RUN git clone -b $chain https://github.com/poanetwork/poa-chain-spec.git

EXPOSE 30303
EXPOSE 8545
EXPOSE 8546
