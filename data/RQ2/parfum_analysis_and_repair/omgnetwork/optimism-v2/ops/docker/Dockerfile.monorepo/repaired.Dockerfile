# This Dockerfile builds all the dependencies needed by the monorepo, and should
# be used to build any of the follow-on services
#
# ### BASE: Install deps
# We do not use Alpine because there's a regression causing it to be very slow
# when used with typescript/hardhat: https://github.com/nomiclabs/hardhat/issues/1219
FROM node:16-buster-slim as node
RUN if echo "\"`uname -a`\"" | grep -q "arm64" ; then \
    apt-get update -y && apt-get install --no-install-recommends -y git python make gcc libudev-dev libusb-1.0-0-dev g++ pkg-config; rm -rf /var/lib/apt/lists/*; \
  else \
    apt-get update -y && apt-get install --no-install-recommends -y git; rm -rf /var/lib/apt/lists/*; \
  fi
# Pre-download the compilers so that they do not need to be downloaded inside
# the image when building
FROM alpine as downloader
ARG SOLC_PREFIX=https://github.com/ethereum/solc-bin/raw/gh-pages/linux-amd64/solc-linux-amd64

ADD ${SOLC_PREFIX}-v0.4.11+commit.68ef5810 ./solc-v0.4.11+commit.68ef5810
ADD ${SOLC_PREFIX}-v0.5.17+commit.d19bba13 ./solc-v0.5.17+commit.d19bba13
ADD ${SOLC_PREFIX}-v0.6.6+commit.6c089d02  ./solc-v0.6.6+commit.6c089d02
ADD ${SOLC_PREFIX}-v0.8.9+commit.e5eed63a  ./solc-v0.8.9+commit.e5eed63a

FROM node as builder
# copy over the needed configs to run the dep installation
# note: this approach can be a bit unhandy to maintain, but it allows
# us to cache the installation steps
WORKDIR /optimism
COPY *.json yarn.lock ./
COPY packages/core-utils/package.json ./packages/core-utils/package.json
COPY packages/common-ts/package.json ./packages/common-ts/package.json
COPY packages/contracts/package.json ./packages/contracts/package.json
COPY packages/data-transport-layer/package.json ./packages/data-transport-layer/package.json
COPY packages/message-relayer/package.json ./packages/message-relayer/package.json
COPY packages/replica-healthcheck/package.json ./packages/replica-healthcheck/package.json
COPY integration-tests/package.json ./integration-tests/package.json

COPY packages/boba/contracts/package.json ./packages/boba/contracts/package.json
COPY packages/boba/gas-price-oracle/package.json ./packages/boba/gas-price-oracle/package.json
COPY packages/boba/message-relayer-fast/package.json ./packages/boba/message-relayer-fast/package.json
COPY packages/boba/turing/package.json ./packages/boba/turing/package.json

# copy over the patches, if any...
# needs to happen before `yarn` otherwise patch-packages does not apply the patches
COPY ./patches ./patches

RUN yarn install --frozen-lockfile && yarn cache clean;

### BUILDER: Builds the typescript
FROM node

WORKDIR /optimism

# cache the node_modules copying step since it's expensive
# we run this before copying over any source files to avoid re-copying anytime the
# code changes
COPY --from=builder /optimism/node_modules ./node_modules
COPY --from=builder /optimism/packages ./packages
COPY --from=builder /optimism/integration-tests ./integration-tests

# the following steps are cheap
COPY *.json yarn.lock ./
# copy over the source
COPY ./packages ./packages
COPY ./integration-tests ./integration-tests
# copy over solc to save time building (35+ seconds vs not doing this step)
COPY --from=downloader solc-v0.4.11+commit.68ef5810 /root/.cache/hardhat-nodejs/compilers/linux-amd64/solc-linux-amd64-v0.4.11+commit.68ef5810
COPY --from=downloader solc-v0.5.17+commit.d19bba13 /root/.cache/hardhat-nodejs/compilers/linux-amd64/solc-linux-amd64-v0.5.17+commit.d19bba13
COPY --from=downloader solc-v0.6.6+commit.6c089d02  /root/.cache/hardhat-nodejs/compilers/linux-amd64/solc-linux-amd64-v0.6.6+commit.6c089d02
COPY --from=downloader solc-v0.8.9+commit.e5eed63a  /root/.cache/hardhat-nodejs/compilers/linux-amd64/solc-linux-amd64-v0.8.9+commit.e5eed63a

# build it!
RUN yarn build
# build integration tests' contracts
RUN yarn workspace @eth-optimism/integration-tests build && yarn cache clean;

# TODO: Consider thinning up the container by trimming non-production
# dependencies
# so that it can be used in docker-compose
CMD ["true"]
