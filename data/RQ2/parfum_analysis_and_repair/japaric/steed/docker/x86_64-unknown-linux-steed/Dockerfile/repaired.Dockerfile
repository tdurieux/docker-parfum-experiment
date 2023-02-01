FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    gcc \
    libc6-dev && \
    mkdir /json && rm -rf /var/lib/apt/lists/*;

COPY xargo.sh /
RUN bash /xargo.sh

COPY lld.sh /
RUN bash /lld.sh

COPY x86_64-unknown-linux-steed.json /json

ENV RUST_TARGET_PATH=/json
