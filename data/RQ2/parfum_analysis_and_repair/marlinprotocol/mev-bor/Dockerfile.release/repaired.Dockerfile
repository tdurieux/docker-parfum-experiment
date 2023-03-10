FROM alpine:3.14

RUN apk add --no-cache ca-certificates && \
    mkdir -p /etc/bor
COPY bor /usr/local/bin/
COPY builder/files/genesis-mainnet-v1.json /etc/bor/
COPY builder/files/genesis-testnet-v4.json /etc/bor/

EXPOSE 8545 8546 8547 30303 30303/udp
ENTRYPOINT ["bor"]