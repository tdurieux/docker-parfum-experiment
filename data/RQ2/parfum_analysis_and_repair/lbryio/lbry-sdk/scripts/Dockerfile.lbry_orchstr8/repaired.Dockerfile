FROM debian:buster-slim

ARG TORBA_VERSION=master

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    python3.7 \
    python3.7-dev \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN python3.7 -m pip install --upgrade pip setuptools wheel

COPY . /app
WORKDIR /app

RUN python3.7 -m pip install --user git+https://github.com/lbryio/torba.git@${TORBA_VERSION}#egg=torba
RUN python3.7 -m pip install -e .

# Orchstr8 API
EXPOSE 7954
# Wallet Server
EXPOSE 5280
# SPV Server
EXPOSE 50002
# blockchain
EXPOSE 9246
ENV TORBA_LEDGER lbry.wallet

RUN /usr/local/bin/orchstr8 download
ENTRYPOINT ["/usr/local/bin/orchstr8"]