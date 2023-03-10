# This Dockerfile demonstrates how to build the Aerospike Node.js client on
# Ubuntu 22.04. Since there is no pre-built package for the Aerospike C Client SDK
# for Ubuntu 22.04 yet, this Dockerfile uses a multi-stage approach to building the
# client to minimize the final image size.
#
# Note: The AS_NODEJS_VERSION must use version 4.0.3 and up since this is where
# the C client submodule was introduced.

# Stage 1: Build Aerospike C Client & Node.js Client
FROM sitespeedio/node:ubuntu-22.04-nodejs-16.15.0 as builder
WORKDIR /src

ENV AS_NODEJS_VERSION v5.0.1

RUN apt update -y
RUN apt install --no-install-recommends -y \
                libc6-dev \
                libssl-dev \
                autoconf \
                automake \
                libtool \
                g++ \
                zlib1g-dev \
                liblua5.1-0-dev \
                ncurses-dev \
                python3 \
                wget \
                git \
                make && rm -rf /var/lib/apt/lists/*;

RUN git clone --branch ${AS_NODEJS_VERSION} --recursive https://github.com/aerospike/aerospike-client-nodejs aerospike
RUN cd /src/aerospike \
    && /src/aerospike/scripts/build-c-client.sh \
    && npm install /src/aerospike --unsafe-perm --build-from-source && npm cache clean --force;

# Stage 2: Install Node.js Client Dependencies
FROM  sitespeedio/node:ubuntu-22.04-nodejs-16.15.0 as installer
WORKDIR /src

COPY --from=builder /src/aerospike ./aerospike

RUN apt update -y
RUN apt install --no-install-recommends -y \
    zlib1g && rm -rf /var/lib/apt/lists/*;
RUN npm install /src/aerospike && npm cache clean --force;
