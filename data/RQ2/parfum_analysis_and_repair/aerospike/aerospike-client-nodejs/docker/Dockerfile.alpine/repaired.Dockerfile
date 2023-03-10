# This Dockerfile demonstrates how to build the Aerospike Node.js client on
# Alpine Linux. Since there is no pre-build package for the Aerospike C Client
# SDK for Alpine Linux, this Dockerfile first builds the C Client SDK from source
# (a submodule for the Node.js client), then builds the Node.js client using it.
# Stage 2 install the Node.js client into the final Docker image, to keep the size of
# that image minimal (i.e. no build dependencies).
#
# Note: The AS_NODEJS_VERSION must use version 4.0.3 and up since this is where the
# C client submodule was introduced.

# Stage 1: Build Aerospike C client and Node.js client
FROM node:lts-alpine as as-node-builder
WORKDIR /src

ENV AS_NODEJS_VERSION v5.0.1

RUN apk update
RUN apk add --no-cache \
    build-base \
    linux-headers \
    bash \
    libuv-dev \
    openssl-dev \
    lua5.1-dev \
    zlib-dev \
    git \
    python3

RUN git clone --branch ${AS_NODEJS_VERSION} --recursive https://github.com/aerospike/aerospike-client-nodejs
# TODO: build-command.sh might be broken for alpine in some versions, use latest version when it's in git
COPY build-commands.sh /src/aerospike-client-nodejs/scripts/build-commands.sh

RUN cd /src/aerospike-client-nodejs \
    && /src/aerospike-client-nodejs/scripts/build-c-client.sh \
    && npm install /src/aerospike-client-nodejs --unsafe-perm --build-from-source && npm cache clean --force;

# Stage 2: Deploy Aerospike Node.js Runtime only
FROM node:lts-alpine
WORKDIR /src

RUN apk add --no-cache \
      zlib \
      openssl

COPY --from=as-node-builder /src/aerospike-client-nodejs/ aerospike-client-nodejs/

RUN npm install /src/aerospike-client-nodejs && npm cache clean --force;