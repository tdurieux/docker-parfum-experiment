FROM phusion/baseimage:0.11
LABEL maintainer "@ColmenaLabs_svq"
LABEL description="Small image with the Substrate binary."

ARG VERSION=v0.8.27

RUN apt-get update && apt-get install --no-install-recommends wget curl jq -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/bin

RUN wget https://github.com/paritytech/polkadot/releases/download/$VERSION/polkadot \
    && chmod +x polkadot

# FINAL PREPARATIONS
EXPOSE 30333 9933 9944

VOLUME ["/data"]

ENTRYPOINT ["polkadot"]
CMD ["--dev"]
