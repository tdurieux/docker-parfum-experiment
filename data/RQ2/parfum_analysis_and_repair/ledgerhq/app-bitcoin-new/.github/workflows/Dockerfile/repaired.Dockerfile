# An image derived from ledgerhq/speculos but also containing the bitcoin-core binaries

FROM ghcr.io/ledgerhq/speculos:latest

# install curl
RUN apt update -y && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# download bitcoin-core and decompress it to /bitcoin
RUN curl -f -o /tmp/bitcoin.tar.gz https://bitcoin.org/bin/bitcoin-core-22.0/bitcoin-22.0-x86_64-linux-gnu.tar.gz && \
    tar -xf /tmp/bitcoin.tar.gz -C / && \
    mv /bitcoin-22.0 /bitcoin && rm /tmp/bitcoin.tar.gz

# Add bitcoin binaries to path
ENV PATH=/bitcoin/bin:$PATH
