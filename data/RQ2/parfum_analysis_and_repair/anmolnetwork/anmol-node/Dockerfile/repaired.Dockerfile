# syntax=docker/dockerfile:1
#
# Enable BuildKit before building this image:
# > export DOCKER_BUILDKIT=1
#
# To build the production image:
# > docker build -t anmolnetwork/anmol-node .

# Build the initial stage with all dependencies from base image
FROM anmolnetwork/anmol-node-build AS build

COPY chains ./chains
COPY common ./common
COPY node ./node
COPY pallets ./pallets
COPY runtime ./runtime
COPY Cargo.* .

ARG SCCACHE_BUCKET=
ENV SCCACHE_BUCKET=$SCCACHE_BUCKET

ARG AWS_ACCESS_KEY_ID=
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID

ARG AWS_SECRET_ACCESS_KEY=
ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

ARG PROFILE=release
ARG BUILD_ARGS=

RUN set -eux \
  && cargo build --$PROFILE --locked $BUILD_ARGS

# Builds the final production image