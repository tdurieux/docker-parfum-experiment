FROM golang:1.17-bullseye

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates openssl zip curl jq gcc-multilib \
    g++-multilib && \
    update-ca-certificates && \
    rm -rf /var/lib/apt && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]