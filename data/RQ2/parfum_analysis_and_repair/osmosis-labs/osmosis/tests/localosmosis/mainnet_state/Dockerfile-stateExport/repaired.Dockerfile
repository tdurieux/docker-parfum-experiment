# --------------------------------------------------------
# Build
# --------------------------------------------------------

FROM golang:1.18.2-alpine3.15 as build

RUN set -eux; apk add --no-cache ca-certificates build-base;
RUN apk add --no-cache git
# Needed by github.com/zondax/hid
RUN apk add --no-cache linux-headers

WORKDIR /osmosis
COPY . /osmosis


# CosmWasm: see https://github.com/CosmWasm/wasmvm/releases
ADD https://github.com/CosmWasm/wasmvm/releases/download/v1.0.0/libwasmvm_muslc.aarch64.a /lib/libwasmvm_muslc.aarch64.a
ADD https://github.com/CosmWasm/wasmvm/releases/download/v1.0.0/libwasmvm_muslc.x86_64.a /lib/libwasmvm_muslc.x86_64.a
RUN sha256sum /lib/libwasmvm_muslc.aarch64.a | grep 7d2239e9f25e96d0d4daba982ce92367aacf0cbd95d2facb8442268f2b1cc1fc
RUN sha256sum /lib/libwasmvm_muslc.x86_64.a | grep f6282df732a13dec836cda1f399dd874b1e3163504dbd9607c6af915b2740479

# CosmWasm: copy the right library according to architecture. The final location will be found by the linker flag `-lwasmvm_muslc`
RUN cp /lib/libwasmvm_muslc.$(uname -m).a /lib/libwasmvm_muslc.a

RUN BUILD_TAGS=muslc LINK_STATICALLY=true make build

# --------------------------------------------------------
# Runner
# --------------------------------------------------------

FROM ubuntu

COPY --from=build /osmosis/build/osmosisd /bin/osmosisd
COPY /tests/localosmosis/mainnet_state/statesync.sh /osmosis/statesync.sh
COPY /tests/localosmosis/mainnet_state/testnetify.py /osmosis/testnetify.py
COPY /tests/localosmosis/testnet_genesis.json /osmosis/testnet_genesis.json

ENV HOME /osmosis
WORKDIR $HOME
# RUN apk update
# RUN apk add jq
# RUN apk add moreutils
# RUN rm -rf /var/cache/apk/*
# RUN apk add --no-cache python3 py3-pip
# RUN apt-get update && apt-get install -y software-properties-common gcc && \
#     add-apt-repository -y ppa:deadsnakes/ppa
# RUN apt-get update && apt-get install -y python3.6 python3-distutils python3-pip python3-apt
RUN apt-get update && apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN chmod +x /osmosis/statesync.sh
RUN /osmosis/statesync.sh
ARG ID=localosmosis
RUN python3 /osmosis/testnetify.py --chain-id=$ID
RUN cp testnet_genesis.json .osmosisd/config/genesis.json
EXPOSE 26656
EXPOSE 26657
EXPOSE 1317

ENTRYPOINT ["osmosisd"]
CMD ["start", "--x-crisis-skip-assert-invariants"]
