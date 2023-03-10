# This Dockerfile demonstrates how to build the Aerospike Node.js client on
# Amazon Linux 2 for AWS Lambda. Since there is no pre-built package for the
# Aerospike C Client SDK for Amazon Linux 2, this Dockerfile uses a multi-stage
# approach to building the client to minimize the final image size.
#
# Note: The AS_NODEJS_VERSION must use version 4.0.3 and up since this is where
# the C client submodule was introduced.

# Stage 1: Build Aerospike C Client & Node.js Client
FROM public.ecr.aws/lambda/nodejs:16 as builder
WORKDIR /src

ENV AS_NODEJS_VERSION v5.0.1

RUN yum update -y
RUN yum install -y \
    gcc-c++ \
    linux-headers \
    libuv-devel \
    lua5.1-devel \
    openssl11-devel \
    zlib-devel \
    python3 \
    make \
    wget \
    tar \
    git && rm -rf /var/cache/yum

RUN git clone --branch ${AS_NODEJS_VERSION} --recursive https://github.com/aerospike/aerospike-client-nodejs aerospike
RUN cd /src/aerospike \
    && /src/aerospike/scripts/build-c-client.sh \
    && npm install /src/aerospike --unsafe-perm --build-from-source && npm cache clean --force;

# Stage 2: Install Node.js Client Dependencies
FROM public.ecr.aws/lambda/nodejs:16 as installer
WORKDIR /src

COPY --from=builder /src/aerospike ./aerospike

RUN yum update -y
RUN yum install -y \
    openssl11 \
    zlib && rm -rf /var/cache/yum
RUN npm install /src/aerospike && npm cache clean --force;