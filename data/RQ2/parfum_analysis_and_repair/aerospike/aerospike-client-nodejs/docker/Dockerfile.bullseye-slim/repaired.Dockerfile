# This Dockerfile demonstrates how to use the Aerospike Node.js client on
# bullseye-slim (Debian 11) using the pre-built package and minimal prerequirements.
#
# Note: The AS_NODEJS_VERSION must use version 4.0.3 and up since this is where
# the C client submodule was introduced.

# Stage 1: Install Node.js Client Dependencies
FROM node:lts-bullseye-slim as installer
WORKDIR /src

ENV AS_NODEJS_VERSION v5.0.1

RUN apt update -y && apt install --no-install-recommends -y \
    openssl \
    zlib1g && rm -rf /var/lib/apt/lists/*;

RUN npm install aerospike@${AS_NODEJS_VERSION} && npm cache clean --force;
